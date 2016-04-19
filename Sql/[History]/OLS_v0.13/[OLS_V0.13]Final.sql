-- [1]备份数据库
DECLARE @now VARCHAR(100)
DECLARE @fileName VARCHAR(100)
DECLARE @filePath VARCHAR(500)

SET @now = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(100), GETDATE(), 20), '-', ''), ' ', ''), ':', '');
SET @fileName = 'OLS_' + @now + '.sqlserver2k8'
-- 下面填入保存数据库备份文件的路径
-- 例如: 填入 'D:\' + @fileName
SET @filePath = 'D:\' + @fileName;

BACKUP DATABASE OLS TO DISK = @filePath

GO

USE OLS;

GO

/***************************************************
** [OLS_v0.13]01修改【获取用户成绩详情函数 fn_GetUserScoreDetail】.sql
****************************************************/

IF OBJECT_ID(N'dbo.fn_GetUserScoreDetail', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScoreDetail;
GO

CREATE FUNCTION dbo.fn_GetUserScoreDetail ( )
RETURNS @table TABLE
    (
      USD_UserId INT NOT NULL ,
      USD_UserName NVARCHAR(50) NOT NULL ,
      USD_DepartmentId INT NOT NULL,
      USD_DepartmentName NVARCHAR(50) NOT NULL,
      USD_TaskId INT NULL ,
      USD_TaskName NVARCHAR(50) NULL ,
      USD_TaskStatisticType TINYINT NULL ,
      USD_PaperTemplateId INT NULL ,
      USD_StartDate DATETIME2 NULL ,
      USD_StartTime DATETIME2 NULL ,
      USD_PaperId INT NULL ,
      USD_Score INT NULL ,
      USD_State TINYINT NOT NULL
    )
AS 
    BEGIN
        INSERT  INTO @table
                SELECT  *
                FROM    ( SELECT    u1.U_Id USD_UserId ,
                                    u1.U_Name USD_UserName ,
                                    u1.D_Id USD_DepartmentId,
                                    u1.D_Name USD_DepartmentName,
                                    et.ET_Id USD_TaskId ,
                                    et.ET_Name USD_TaskName ,
                                    et.ET_StatisticType USD_TaskStatisticType ,
                                    ept.EPT_Id USD_PaperTemplateId ,
                                    ept.EPT_StartDate USD_StartDate ,
                                    ept.EPT_StartTime USD_StartTime ,
                                    ISNULL(ep.EP_Id, 0) USD_PaperId ,
                                    ISNULL(ep.EP_Score, -1) USD_Score ,
                                    ( CASE WHEN ept.EPT_Id IS NULL THEN 0
                                           ELSE CASE WHEN ep.EP_Score IS NULL THEN 1
                                                     ELSE CASE WHEN et.ET_StatisticType = 1
                                                               THEN CASE WHEN EP_Score = -1 THEN 2
                                                                         WHEN ( ep.EP_Score / CAST(et.ET_TotalScore AS FLOAT) * 100 ) > 59 THEN 3
                                                                         ELSE 4
                                                                    END
                                                               WHEN et.ET_StatisticType = 2 THEN CASE WHEN EP_Score = -1 THEN 2
                                                                                                      WHEN ep.EP_Score > 59 THEN 3
                                                                                                      ELSE 4
                                                                                                 END
                                                               ELSE 0
                                                          END
                                                END
                                      END ) AS ETUS_State /* 0未设置 1未考试 2未打分 3合格 4未合格 */
                          FROM      ( SELECT    u.U_Id ,
                                                u.U_Name ,
                                                u.U_Status,
                                                d.D_Id ,
                                                d.D_Name ,
                                                d.D_Status,
                                                du.Du_Id ,
                                                du.Du_Name,
                                                du.Du_Status
                                      FROM      dbo.Users u
                                                LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
                                                LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                                                LEFT JOIN dbo.Duties du ON u.Du_Id = du.Du_Id
                                    ) u1
                                    LEFT JOIN dbo.ExaminationTaskAttendees eta ON eta.U_Id = u1.U_Id
                                    LEFT JOIN dbo.ExaminationTasks et ON et.ET_Id = eta.ET_Id
                                    LEFT JOIN dbo.ExaminationPaperTemplates ept ON ept.ET_Id = et.ET_Id
                                    FULL OUTER JOIN dbo.ExaminationPapers ep ON ep.EPT_Id = ept.EPT_Id
                          WHERE     ep.EP_UserId = u1.U_Id
						  --添加未考试的记录
                          UNION ALL
                          SELECT    u1.U_Id USD_UserId ,
                                    u1.U_Name USD_UserName ,
                                    u1.D_Id USD_DepartmentId,
                                    u1.D_Name USD_DepartmentName,
                                    et.ET_Id USD_TaskId ,
                                    et.ET_Name USD_TaskName ,
                                    et.ET_StatisticType USD_TaskStatisticType ,
                                    ept.EPT_Id USD_PaperTemplateId ,
                                    ept.EPT_StartDate USD_StartDate ,
                                    ept.EPT_StartTime USD_StartTime ,
                                    0 USD_PaperId ,
                                    -1 USD_Score ,
                                    0 ETUS_State /* 0未设置 1未考试 2未打分 3合格 4未合格 */
                          FROM      ( SELECT    u.U_Id ,
                                                u.U_Name ,
                                                u.U_Status,
                                                d.D_Id ,
                                                d.D_Name ,
                                                d.D_Status,
                                                du.Du_Id ,
                                                du.Du_Name,
                                                du.Du_Status
                                      FROM      dbo.Users u
                                                LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
                                                LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                                                LEFT JOIN dbo.Duties du ON u.Du_Id = du.Du_Id
                                    ) u1
                                    LEFT JOIN dbo.ExaminationTaskAttendees eta ON eta.U_Id = u1.U_Id
                                    LEFT JOIN dbo.ExaminationTasks et ON et.ET_Id = eta.ET_Id
                                    LEFT JOIN dbo.ExaminationPaperTemplates ept ON ept.ET_Id = et.ET_Id
                        ) tmp
                ORDER BY USD_PaperTemplateId ASC ,
                        USD_TaskId ASC ,
                        USD_PaperId ASC
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.UserScoreDetails', 'V') IS NOT NULL
	DROP VIEW dbo.UserScoreDetails;
GO

CREATE VIEW dbo.UserScoreDetails
AS
SELECT * FROM dbo.fn_GetUserScoreDetail()

GO

/***************************************************
** [OLS_v0.13]02添加用户字段“身份证号”.sql
****************************************************/

ALTER TABLE dbo.Users
ADD U_IdCardNumber VARCHAR(20) NULL;

GO

UPDATE Users SET U_IdCardNumber='460102198412071818' WHERE U_Name='系统管理员';
UPDATE Users SET U_IdCardNumber='440511196904130074' WHERE U_Name='郑旭彪';
UPDATE Users SET U_IdCardNumber='441425196208040212' WHERE U_Name='何坤文';
UPDATE Users SET U_IdCardNumber='441425196210250358' WHERE U_Name='刘文胜';
UPDATE Users SET U_IdCardNumber='441425197301222939' WHERE U_Name='黄立权';
UPDATE Users SET U_IdCardNumber='440902197606281210' WHERE U_Name='张振潮';
UPDATE Users SET U_IdCardNumber='441425196608281971' WHERE U_Name='罗新峰';
UPDATE Users SET U_IdCardNumber='44142519571113035X' WHERE U_Name='刘思明';
UPDATE Users SET U_IdCardNumber='44142519721031001X' WHERE U_Name='李惠平';
UPDATE Users SET U_IdCardNumber='441425196212161375' WHERE U_Name='彭远达';
UPDATE Users SET U_IdCardNumber='44142519800220548X' WHERE U_Name='刘会文';
UPDATE Users SET U_IdCardNumber='441425195907220357' WHERE U_Name='肖志崇';
UPDATE Users SET U_IdCardNumber='441425197212122944' WHERE U_Name='廖秋方';
UPDATE Users SET U_IdCardNumber='441425196004061134' WHERE U_Name='张清平';
UPDATE Users SET U_IdCardNumber='441402198711291822' WHERE U_Name='张丹丹';
UPDATE Users SET U_IdCardNumber='441425196810087291' WHERE U_Name='刘珊';
UPDATE Users SET U_IdCardNumber='441425197707170024' WHERE U_Name='钟岚';
UPDATE Users SET U_IdCardNumber='441425195810060078' WHERE U_Name='何兴章';
UPDATE Users SET U_IdCardNumber='441425196802130552' WHERE U_Name='肖森怀';
UPDATE Users SET U_IdCardNumber='441425197208230010' WHERE U_Name='陈耀辉';
UPDATE Users SET U_IdCardNumber='441425195604100198' WHERE U_Name='张展林';
UPDATE Users SET U_IdCardNumber='441425197401180043' WHERE U_Name='刁向萍';
UPDATE Users SET U_IdCardNumber='441425196703161978' WHERE U_Name='陈伟新';
UPDATE Users SET U_IdCardNumber='441425196501156310' WHERE U_Name='孙剑波';
UPDATE Users SET U_IdCardNumber='441425195809150017' WHERE U_Name='赖建华';
UPDATE Users SET U_IdCardNumber='441481198805230874' WHERE U_Name='陈佳伟';
UPDATE Users SET U_IdCardNumber='441425197812290191' WHERE U_Name='张伟';
UPDATE Users SET U_IdCardNumber='44142519740421566X' WHERE U_Name='胡燕芬';
UPDATE Users SET U_IdCardNumber='441425196105100016' WHERE U_Name='罗标辉';
UPDATE Users SET U_IdCardNumber='441421197304031112' WHERE U_Name='吴红中';
UPDATE Users SET U_IdCardNumber='441425197304170046' WHERE U_Name='刘春梅';
UPDATE Users SET U_IdCardNumber='441425197003255652' WHERE U_Name='曾强';
UPDATE Users SET U_IdCardNumber='441425197403052264' WHERE U_Name='曾利方';
UPDATE Users SET U_IdCardNumber='441481198311140705' WHERE U_Name='钟玉';
UPDATE Users SET U_IdCardNumber='441425196203101135' WHERE U_Name='彭利锋';
UPDATE Users SET U_IdCardNumber='441424199011086994' WHERE U_Name='张颖';
UPDATE Users SET U_IdCardNumber='441425197011280014' WHERE U_Name='张添朋';
UPDATE Users SET U_IdCardNumber='441425196310100891' WHERE U_Name='罗建华';
UPDATE Users SET U_IdCardNumber='445201198511240031' WHERE U_Name='郭俊耿';
UPDATE Users SET U_IdCardNumber='360734198906052414' WHERE U_Name='徐中辉';
UPDATE Users SET U_IdCardNumber='441481199112201426' WHERE U_Name='曾慧瑶';
UPDATE Users SET U_IdCardNumber='441425196107190377' WHERE U_Name='钟玩章';
UPDATE Users SET U_IdCardNumber='441425197012287293' WHERE U_Name='李荣怀';
UPDATE Users SET U_IdCardNumber='441425196808130350' WHERE U_Name='蔡伟政';
UPDATE Users SET U_IdCardNumber='441425197302286184' WHERE U_Name='陈伟苑';
UPDATE Users SET U_IdCardNumber='441425196303053855' WHERE U_Name='刘波';
UPDATE Users SET U_IdCardNumber='441425195706274156' WHERE U_Name='吴焕昌';
UPDATE Users SET U_IdCardNumber='441425197309250192' WHERE U_Name='罗尚东';
UPDATE Users SET U_IdCardNumber='441425196210192733' WHERE U_Name='孙佑新';
UPDATE Users SET U_IdCardNumber='441425196001103853' WHERE U_Name='钟云彬';
UPDATE Users SET U_IdCardNumber='441425195811020019' WHERE U_Name='陈羽中';
UPDATE Users SET U_IdCardNumber='441425197111273655' WHERE U_Name='黄永新';
UPDATE Users SET U_IdCardNumber='441425196310260051' WHERE U_Name='罗俊辉';
UPDATE Users SET U_IdCardNumber='441426198903310013' WHERE U_Name='刘坤';
UPDATE Users SET U_IdCardNumber='441425196103215477' WHERE U_Name='刁苑辉';
UPDATE Users SET U_IdCardNumber='441425197311285917' WHERE U_Name='曾科';
UPDATE Users SET U_IdCardNumber='441425197112036301' WHERE U_Name='孙丽霞';
UPDATE Users SET U_IdCardNumber='44142519650516385X' WHERE U_Name='谢伟东';
UPDATE Users SET U_IdCardNumber='441425197206060206' WHERE U_Name='陈利娟';
UPDATE Users SET U_IdCardNumber='441425196210070883' WHERE U_Name='张艳芳';
UPDATE Users SET U_IdCardNumber='441425196502010022' WHERE U_Name='廖娟';
UPDATE Users SET U_IdCardNumber='441425196305200548' WHERE U_Name='陈思';
UPDATE Users SET U_IdCardNumber='441425197410094403' WHERE U_Name='刘春兰';
UPDATE Users SET U_IdCardNumber='441425196305270028' WHERE U_Name='陈菊新';
UPDATE Users SET U_IdCardNumber='441426197408250047' WHERE U_Name='钟燕飞';
UPDATE Users SET U_IdCardNumber='441425196207060043' WHERE U_Name='梁平';
UPDATE Users SET U_IdCardNumber='441425196105062478' WHERE U_Name='李汉华';
UPDATE Users SET U_IdCardNumber='44142519671115361X' WHERE U_Name='钟海平';
UPDATE Users SET U_IdCardNumber='44142519630804443X' WHERE U_Name='吴国辉';
UPDATE Users SET U_IdCardNumber='441425196504084658' WHERE U_Name='肖学东';
UPDATE Users SET U_IdCardNumber='441425196911076532' WHERE U_Name='罗国新';
UPDATE Users SET U_IdCardNumber='441427199203120869' WHERE U_Name='邓佳维';
UPDATE Users SET U_IdCardNumber='441422199011080047' WHERE U_Name='邱美婷';
UPDATE Users SET U_IdCardNumber='441425196803130351' WHERE U_Name='罗卫东';
UPDATE Users SET U_IdCardNumber='441425195804090190' WHERE U_Name='王新';
UPDATE Users SET U_IdCardNumber='441425195606030031' WHERE U_Name='罗洪波';
UPDATE Users SET U_IdCardNumber='441425197208281416' WHERE U_Name='陈庆辉';
UPDATE Users SET U_IdCardNumber='441425196301263859' WHERE U_Name='李永红';
UPDATE Users SET U_IdCardNumber='441425196405023593' WHERE U_Name='罗志红';
UPDATE Users SET U_IdCardNumber='441425196712120019' WHERE U_Name='罗小明';
UPDATE Users SET U_IdCardNumber='441425195709135290' WHERE U_Name='童茂汕';
UPDATE Users SET U_IdCardNumber='441425196403125297' WHERE U_Name='陈定金';
UPDATE Users SET U_IdCardNumber='441425195603252499' WHERE U_Name='张运华';
UPDATE Users SET U_IdCardNumber='441425195705136130' WHERE U_Name='陈新宏';
UPDATE Users SET U_IdCardNumber='441425196212120354' WHERE U_Name='黄玩华';
UPDATE Users SET U_IdCardNumber='441425195406116658' WHERE U_Name='黄育清';
UPDATE Users SET U_IdCardNumber='441425195905090018' WHERE U_Name='黄斯列';
UPDATE Users SET U_IdCardNumber='44142519570814091X' WHERE U_Name='曾金泉';
UPDATE Users SET U_IdCardNumber='44142519690211631X' WHERE U_Name='陈益辉';
UPDATE Users SET U_IdCardNumber='441425196208194692' WHERE U_Name='刘森朋';
UPDATE Users SET U_IdCardNumber='441425195906230190' WHERE U_Name='李凡';
UPDATE Users SET U_IdCardNumber='441425195710092718' WHERE U_Name='黄岸平';
UPDATE Users SET U_IdCardNumber='510102196812168593' WHERE U_Name='刁伟金';
UPDATE Users SET U_IdCardNumber='441425196412240051' WHERE U_Name='张新伟';
UPDATE Users SET U_IdCardNumber='441423195708172054' WHERE U_Name='朱荣桂';
UPDATE Users SET U_IdCardNumber='441425196709105096' WHERE U_Name='张建东';
UPDATE Users SET U_IdCardNumber='441425196611195097' WHERE U_Name='李文光';
UPDATE Users SET U_IdCardNumber='44142519640610087X' WHERE U_Name='陈建中';
UPDATE Users SET U_IdCardNumber='441425196109115899' WHERE U_Name='王建清';
UPDATE Users SET U_IdCardNumber='441425196611105098' WHERE U_Name='刘山权';
UPDATE Users SET U_IdCardNumber='440102197906234447' WHERE U_Name='刘秋慧';
UPDATE Users SET U_IdCardNumber='441425195710054877' WHERE U_Name='刘明育';
UPDATE Users SET U_IdCardNumber='441425197201220354' WHERE U_Name='陈卫民';
UPDATE Users SET U_IdCardNumber='441425196910242236' WHERE U_Name='曾祥万';
UPDATE Users SET U_IdCardNumber='441425195708063395' WHERE U_Name='罗庆桓';
UPDATE Users SET U_IdCardNumber='441425196601204199' WHERE U_Name='王福群';
UPDATE Users SET U_IdCardNumber='441425196205160358' WHERE U_Name='幸伟越';
UPDATE Users SET U_IdCardNumber='441425195804104150' WHERE U_Name='张明才';
UPDATE Users SET U_IdCardNumber='441425196006300012' WHERE U_Name='王宁华';
UPDATE Users SET U_IdCardNumber='441425196411230038' WHERE U_Name='曾国强';
UPDATE Users SET U_IdCardNumber='441425196311240351' WHERE U_Name='高汉明';
UPDATE Users SET U_IdCardNumber='441425195804160873' WHERE U_Name='林顺兴';
UPDATE Users SET U_IdCardNumber='441425195811043851' WHERE U_Name='李汉来';
UPDATE Users SET U_IdCardNumber='441481198407040354' WHERE U_Name='吴思科';
UPDATE Users SET U_IdCardNumber='441425197410233338' WHERE U_Name='黄浩';
UPDATE Users SET U_IdCardNumber='441425197104230016' WHERE U_Name='曾洪辉';
UPDATE Users SET U_IdCardNumber='441425196308026290' WHERE U_Name='罗万能';
UPDATE Users SET U_IdCardNumber='441425196509071418' WHERE U_Name='陈冠雄';
UPDATE Users SET U_IdCardNumber='441425196512284414' WHERE U_Name='陈启东';
UPDATE Users SET U_IdCardNumber='441425196503180023' WHERE U_Name='刘红';
UPDATE Users SET U_IdCardNumber='44142519720302199X' WHERE U_Name='王悦';
UPDATE Users SET U_IdCardNumber='441425195706150014' WHERE U_Name='温启华';
UPDATE Users SET U_IdCardNumber='441425196112252931' WHERE U_Name='黄志高';
UPDATE Users SET U_IdCardNumber='441425196608040019' WHERE U_Name='毛建军';
UPDATE Users SET U_IdCardNumber='441425196208180573' WHERE U_Name='刘光平';
UPDATE Users SET U_IdCardNumber='44142519641016143X' WHERE U_Name='刘仿新';
UPDATE Users SET U_IdCardNumber='441425195703130018' WHERE U_Name='刁雄';
UPDATE Users SET U_IdCardNumber='441424198702020535' WHERE U_Name='戴文锋';
UPDATE Users SET U_IdCardNumber='44148119831107041X' WHERE U_Name='罗源';
UPDATE Users SET U_IdCardNumber='44142119870525221X' WHERE U_Name='余理键';
UPDATE Users SET U_IdCardNumber='441425197104103113' WHERE U_Name='王永东';
UPDATE Users SET U_IdCardNumber='441481198710280027' WHERE U_Name='李婷';
UPDATE Users SET U_IdCardNumber='441425197008250877' WHERE U_Name='张思明';
UPDATE Users SET U_IdCardNumber='441481198412092511' WHERE U_Name='邱力';
UPDATE Users SET U_IdCardNumber='360733199302220016' WHERE U_Name='欧阳升';
UPDATE Users SET U_IdCardNumber='441425195810111672' WHERE U_Name='罗启杰';
UPDATE Users SET U_IdCardNumber='441425195809123350' WHERE U_Name='刘庆福';
UPDATE Users SET U_IdCardNumber='441425196708104155' WHERE U_Name='蓝俊波';
UPDATE Users SET U_IdCardNumber='441425196306042019' WHERE U_Name='张裕坚';
UPDATE Users SET U_IdCardNumber='441425196105155674' WHERE U_Name='陈为民';
UPDATE Users SET U_IdCardNumber='441481198909240022' WHERE U_Name='李丽珠';
UPDATE Users SET U_IdCardNumber='441481198704030072' WHERE U_Name='陈峰';
UPDATE Users SET U_IdCardNumber='44252419701028171X' WHERE U_Name='侯学文';
UPDATE Users SET U_IdCardNumber='441425196404044392' WHERE U_Name='刘绍斌';
UPDATE Users SET U_IdCardNumber='441425196309155692' WHERE U_Name='陈东';
UPDATE Users SET U_IdCardNumber='441425197409014410' WHERE U_Name='许国锋';
UPDATE Users SET U_IdCardNumber='441425197811010362' WHERE U_Name='王梅飞';
UPDATE Users SET U_IdCardNumber='441425196010193598' WHERE U_Name='钟焕元';
UPDATE Users SET U_IdCardNumber='441425196009013094' WHERE U_Name='刘亮生';
UPDATE Users SET U_IdCardNumber='441425196212102498' WHERE U_Name='黄均华';
UPDATE Users SET U_IdCardNumber='441481198205240059' WHERE U_Name='刘涛';
UPDATE Users SET U_IdCardNumber='44162219880709669X' WHERE U_Name='钟荣榜';
UPDATE Users SET U_IdCardNumber='441481199009210359' WHERE U_Name='陈辰';
UPDATE Users SET U_IdCardNumber='441481199108200201' WHERE U_Name='陈文媛';
UPDATE Users SET U_IdCardNumber='441425195708305470' WHERE U_Name='张冰强';
UPDATE Users SET U_IdCardNumber='440106197507051876' WHERE U_Name='彭伟林';
UPDATE Users SET U_IdCardNumber='441425196603200554' WHERE U_Name='刘国良';
UPDATE Users SET U_IdCardNumber='44142519700525547X' WHERE U_Name='黄宏清';
UPDATE Users SET U_IdCardNumber='441425195701180353' WHERE U_Name='吴宝钦';
UPDATE Users SET U_IdCardNumber='441402195909040013' WHERE U_Name='张冰雄';
UPDATE Users SET U_IdCardNumber='44142519571213589X' WHERE U_Name='廖亚文';
UPDATE Users SET U_IdCardNumber='441425195812204194' WHERE U_Name='罗崇标';
UPDATE Users SET U_IdCardNumber='441425196602081397' WHERE U_Name='曾坤华';
UPDATE Users SET U_IdCardNumber='441425196210126314' WHERE U_Name='钟福星';
UPDATE Users SET U_IdCardNumber='362321198906282429' WHERE U_Name='翁丽兰';
UPDATE Users SET U_IdCardNumber='44142519700827035X' WHERE U_Name='毛思权';
UPDATE Users SET U_IdCardNumber='441425196212180015' WHERE U_Name='童小生';
UPDATE Users SET U_IdCardNumber='441425195408300192' WHERE U_Name='何旺宏';
UPDATE Users SET U_IdCardNumber='441421199112212444' WHERE U_Name='张冬娜';
UPDATE Users SET U_IdCardNumber='360733199407180022' WHERE U_Name='文予';
UPDATE Users SET U_IdCardNumber='430407199402052020' WHERE U_Name='汤玉兰';
UPDATE Users SET U_IdCardNumber='44148119921025154X' WHERE U_Name='陈幸婷';
UPDATE Users SET U_IdCardNumber='441427199003220160' WHERE U_Name='汤梦妤';

GO

/***************************************************
** [OLS_v0.13]03添加权限 .sql
****************************************************/

DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = 5;
SELECT  @pId = MAX(P_Id) + 1
FROM    dbo.[Permissions]

-- 添加权限值
SET IDENTITY_INSERT [dbo].[Permissions] ON

INSERT  [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( @pId ,
          @pId ,
          @pcId ,
          N'检查身份证号' ,
          N'User' ,
          N'DuplicateIdCardNumber' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

SET IDENTITY_INSERT [dbo].[Permissions] OFF

GO

-- 添加关联记录
DELETE  FROM dbo.Role_Permission
WHERE   R_Id = 1;
INSERT  [dbo].[Role_Permission]
        SELECT  1 ,
                P_Id
        FROM    dbo.[Permissions]

GO

-- 更新角色记录
DECLARE @table TABLE ( PC_Id INT );
DECLARE @table1 TABLE ( P_Id INT );
DECLARE @pcs VARCHAR(500) ,
    @ps VARCHAR(2000);
DECLARE @id INT;

SET @pcs = '';
SET @ps = '';

INSERT  INTO @table
        SELECT  PC_Id
        FROM    dbo.PermissionCategories
        ORDER BY PC_Id ASC;

WHILE ( SELECT  COUNT(PC_Id)
        FROM    @table
      ) > 0 
    BEGIN
        SELECT TOP 1
                @id = PC_Id
        FROM    @table
        ORDER BY PC_Id ASC;
        DELETE  FROM @table
        WHERE   PC_Id = @id;
        SET @pcs = @pcs + CAST(@id AS VARCHAR(5)) + ',';
    END

SET @pcs = '[' + STUFF(@pcs, LEN(@pcs), 1, ']');

INSERT  INTO @table1
        SELECT  P_Id
        FROM    dbo.[Permissions]
        ORDER BY P_Id ASC

WHILE ( SELECT  COUNT(P_Id)
        FROM    @table1
      ) > 0 
    BEGIN
        SELECT TOP 1
                @id = P_Id
        FROM    @table1
        ORDER BY P_Id ASC;
        DELETE  FROM @table1
        WHERE   P_Id = @id;
        SET @ps = @ps + CAST(@id AS VARCHAR(5)) + ',';
    END

SET @ps = '[' + STUFF(@ps, LEN(@ps), 1, ']');

UPDATE  Roles
SET     R_Permissions = @ps ,
        R_PermissionCategories = @pcs
WHERE   R_Id = 1

GO

/***************************************************
** [OLS_v0.13]04添加权限 .sql
****************************************************/

DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = 9;
SELECT  @pId = MAX(P_Id) + 1
FROM    dbo.[Permissions]

-- 添加权限值
SET IDENTITY_INSERT [dbo].[Permissions] ON

INSERT  [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( @pId ,
          @pId ,
          @pcId ,
          N'获取正在考试的人数' ,
          N'ExaminationTask' ,
          N'GetDoingUserNumber' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

SET IDENTITY_INSERT [dbo].[Permissions] OFF

GO

-- 添加关联记录
DELETE  FROM dbo.Role_Permission
WHERE   R_Id = 1;
INSERT  [dbo].[Role_Permission]
        SELECT  1 ,
                P_Id
        FROM    dbo.[Permissions]

GO

-- 更新角色记录
DECLARE @table TABLE ( PC_Id INT );
DECLARE @table1 TABLE ( P_Id INT );
DECLARE @pcs VARCHAR(500) ,
    @ps VARCHAR(2000);
DECLARE @id INT;

SET @pcs = '';
SET @ps = '';

INSERT  INTO @table
        SELECT  PC_Id
        FROM    dbo.PermissionCategories
        ORDER BY PC_Id ASC;

WHILE ( SELECT  COUNT(PC_Id)
        FROM    @table
      ) > 0 
    BEGIN
        SELECT TOP 1
                @id = PC_Id
        FROM    @table
        ORDER BY PC_Id ASC;
        DELETE  FROM @table
        WHERE   PC_Id = @id;
        SET @pcs = @pcs + CAST(@id AS VARCHAR(5)) + ',';
    END

SET @pcs = '[' + STUFF(@pcs, LEN(@pcs), 1, ']');

INSERT  INTO @table1
        SELECT  P_Id
        FROM    dbo.[Permissions]
        ORDER BY P_Id ASC

WHILE ( SELECT  COUNT(P_Id)
        FROM    @table1
      ) > 0 
    BEGIN
        SELECT TOP 1
                @id = P_Id
        FROM    @table1
        ORDER BY P_Id ASC;
        DELETE  FROM @table1
        WHERE   P_Id = @id;
        SET @ps = @ps + CAST(@id AS VARCHAR(5)) + ',';
    END

SET @ps = '[' + STUFF(@ps, LEN(@ps), 1, ']');

UPDATE  Roles
SET     R_Permissions = @ps ,
        R_PermissionCategories = @pcs
WHERE   R_Id = 1

GO

/***************************************************
** [OLS_v0.13]05添加权限 .SQL
****************************************************/

DECLARE @pcId INT ,
    @pId INT;

SELECT  @pcId = 6;
SELECT  @pId = MAX(P_Id) + 1
FROM    dbo.[Permissions]

-- 添加权限值
SET IDENTITY_INSERT [dbo].[Permissions] ON

INSERT  [dbo].[Permissions]
        ( P_Id ,
          P_AutoId ,
          PC_Id ,
          P_Name ,
          P_Controller ,
          P_Action ,
          P_Remark ,
          P_AddTime
        )
VALUES  ( @pId ,
          @pId ,
          @pcId ,
          N'交卷' ,
          N'ExaminationPaper' ,
          N'HandIn' ,
          NULL ,
          CAST(0x079DAEB04D8BAB3A0B AS DATETIME2)
        )

SET IDENTITY_INSERT [dbo].[Permissions] OFF

GO

-- 添加关联记录
DELETE  FROM dbo.Role_Permission
WHERE   R_Id = 1;
INSERT  [dbo].[Role_Permission]
        SELECT  1 ,
                P_Id
        FROM    dbo.[Permissions]

GO

-- 更新角色记录
DECLARE @table TABLE ( PC_Id INT );
DECLARE @table1 TABLE ( P_Id INT );
DECLARE @pcs VARCHAR(500) ,
    @ps VARCHAR(2000);
DECLARE @id INT;

SET @pcs = '';
SET @ps = '';

INSERT  INTO @table
        SELECT  PC_Id
        FROM    dbo.PermissionCategories
        ORDER BY PC_Id ASC;

WHILE ( SELECT  COUNT(PC_Id)
        FROM    @table
      ) > 0 
    BEGIN
        SELECT TOP 1
                @id = PC_Id
        FROM    @table
        ORDER BY PC_Id ASC;
        DELETE  FROM @table
        WHERE   PC_Id = @id;
        SET @pcs = @pcs + CAST(@id AS VARCHAR(5)) + ',';
    END

SET @pcs = '[' + STUFF(@pcs, LEN(@pcs), 1, ']');

INSERT  INTO @table1
        SELECT  P_Id
        FROM    dbo.[Permissions]
        ORDER BY P_Id ASC

WHILE ( SELECT  COUNT(P_Id)
        FROM    @table1
      ) > 0 
    BEGIN
        SELECT TOP 1
                @id = P_Id
        FROM    @table1
        ORDER BY P_Id ASC;
        DELETE  FROM @table1
        WHERE   P_Id = @id;
        SET @ps = @ps + CAST(@id AS VARCHAR(5)) + ',';
    END

SET @ps = '[' + STUFF(@ps, LEN(@ps), 1, ']');

UPDATE  Roles
SET     R_Permissions = @ps ,
        R_PermissionCategories = @pcs
WHERE   R_Id = 1

GO

-- 设置用户公共权限
DECLARE @pId INT;

SELECT  @pId = MAX(P_Id)
FROM    dbo.[Permissions]

INSERT  [dbo].[Role_Permission]
        SELECT  R_Id ,
                @pId
        FROM    dbo.Roles
        WHERE   R_Id <> 1;

UPDATE  Roles
SET     R_Permissions = '[46,47,79,81,89,90,93,94,95,96,' + CAST(@pId AS VARCHAR(5)) + ']' ,
        R_PermissionCategories = '[6,11]'
WHERE   R_Id <> 1;

GO

/***************************************************
** [OLS_v0.13]06删除试卷试题外键关系 FK_EPQ_EPTQ .sql
****************************************************/

ALTER TABLE dbo.ExaminationPaperQuestions
DROP CONSTRAINT FK_EPQ_EPTQ

GO

/***************************************************
** [OLS_v0.13]07修改【获取用户成绩概览函数 fn_GetUserScoreSummary】.sql
****************************************************/

IF OBJECT_ID(N'dbo.fn_GetUserScoreSummary', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.fn_GetUserScoreSummary;
GO

CREATE FUNCTION dbo.fn_GetUserScoreSummary ( )
RETURNS @table TABLE
    (
      USS_UserId INT NOT NULL ,
      USS_UserName NVARCHAR(50) NOT NULL ,
      USS_DepartmentId INT NOT NULL,
      USS_DepartmentName NVARCHAR(50) NOT NULL ,
      USS_DutyName NVARCHAR(50) NULL ,
      USS_TotalNumber INT NOT NULL ,
      USS_DoneNumber INT NOT NULL ,
      USS_UndoNumber INT NOT NULL ,
      USS_PassNumber INT NOT NULL ,
      USS_DoneRatio DECIMAL NOT NULL ,
      USS_PassRatio DECIMAL NOT NULL
    )
AS 
    BEGIN
		
        INSERT  INTO @table
                SELECT  USS_UserId ,
                        USS_UserName ,
                        USS_DepartmentId,
                        USS_DepartmentName ,
                        ISNULL(USS_DutyName, '') ,
                        USS_TotalNumber ,
                        USS_DoneNumber ,
                        ( USS_TotalNumber - USS_DoneNumber ) USS_UndoNumber ,
                        USS_PassNumber ,
                        ( CASE USS_TotalNumber
                            WHEN 0 THEN 0
                            ELSE ROUND(( USS_DoneNumber / CAST(USS_TotalNumber AS FLOAT) ), 2) * 100
                          END ) USS_DoneRatio ,
                        ( CASE USS_TotalNumber
                            WHEN 0 THEN 0
                            ELSE ROUND(( USS_PassNumber / CAST(USS_TotalNumber AS FLOAT) ), 2) * 100
                          END ) USS_PassRatio
                FROM    ( SELECT    USS_UserId ,
                                    USS_UserName ,
                                    USS_DepartmentId,
                                    USS_DepartmentName ,
                                    USS_DutyName ,
                                    COUNT(USS_TaskName) USS_TotalNumber ,
                                    SUM(USS_DoneNumber) USS_DoneNumber ,
                                    SUM(ISNULL(USS_PassNumber, 0)) USS_PassNumber
                          FROM      ( SELECT    u.U_Id USS_UserId ,
                                                u.U_Name USS_UserName ,
                                                d.D_Id USS_DepartmentId,
                                                d.D_Name USS_DepartmentName ,
                                                du.Du_Name USS_DutyName ,
                                                et.ET_Id USS_TaskId ,
                                                et.ET_Name USS_TaskName ,
                                                ept.EPT_Id USS_PaperTemplateId ,
                                                ept.EPT_StartDate USS_StartTime ,
                                                ( SELECT    COUNT(ep1.EP_Id)
                                                  FROM      dbo.ExaminationTasks et1
                                                            LEFT JOIN dbo.ExaminationTaskAttendees eta1 ON et1.ET_Id = eta1.ET_Id
                                                            LEFT JOIN dbo.Users u1 ON eta1.U_Id = u1.U_Id
                                                            LEFT JOIN dbo.ExaminationPaperTemplates ept1 ON et1.ET_Id = ept1.ET_Id
                                                            LEFT JOIN dbo.ExaminationPapers ep1 ON et1.ET_Id = ep1.ET_Id
                                                  WHERE     et1.ET_Id = et.ET_Id
                                                            AND ept1.EPT_Id = ept.EPT_Id
                                                            AND ep1.EP_UserId = u.U_Id
                                                            AND ep1.EP_UserId = u1.U_Id
                                                            AND ept1.EPT_Id = ep1.EPT_Id
                                                            AND ep1.EP_Id IS NOT NULL
                                                ) USS_DoneNumber ,
                                                ( SELECT    SUM(CASE et2.ET_StatisticType
                                                                  WHEN 1 THEN ( CASE WHEN ( ep2.EP_Score / CAST(et2.ET_TotalScore AS FLOAT) * 100 ) > 59 THEN 1
                                                                                     ELSE 0
                                                                                END )
                                                                  WHEN 2 THEN ( CASE WHEN ep2.EP_Score > 59 THEN 1
                                                                                     ELSE 0
                                                                                END )
                                                                  ELSE 0
                                                                END)
                                                  FROM      dbo.ExaminationTasks et2
                                                            LEFT JOIN dbo.ExaminationTaskAttendees eta2 ON et2.ET_Id = eta2.ET_Id
                                                            LEFT JOIN dbo.Users u2 ON eta2.U_Id = u2.U_Id
                                                            LEFT JOIN dbo.ExaminationPaperTemplates ept2 ON et2.ET_Id = ept2.ET_Id
                                                            LEFT JOIN dbo.ExaminationPapers ep2 ON et2.ET_Id = ep2.ET_Id
                                                  WHERE     et2.ET_Id = et.ET_Id
                                                            AND ept2.EPT_Id = ept.EPT_Id
                                                            AND ep2.EP_UserId = u.U_Id
                                                            AND ep2.EP_UserId = u2.U_Id
                                                            AND ept2.EPT_Id = ep2.EPT_Id
                                                            AND ep2.EP_Id IS NOT NULL
                                                ) USS_PassNumber
                                      FROM      dbo.Users u
                                                LEFT JOIN dbo.User_Department ud ON u.U_Id = ud.U_Id
                                                LEFT JOIN dbo.Departments d ON ud.D_Id = d.D_Id
                                                LEFT JOIN dbo.Duties du ON u.Du_Id = du.Du_Id
                                                LEFT JOIN dbo.ExaminationTaskAttendees eta ON u.U_Id = eta.U_Id
                                                LEFT JOIN dbo.ExaminationTasks et ON eta.ET_Id = et.ET_Id
                                                LEFT JOIN dbo.ExaminationPaperTemplates ept ON et.ET_Id = ept.ET_Id
                                      WHERE     ( et.ET_Status = 1
                                                  OR et.ET_Status IS NULL
                                                )
                                                AND u.U_Status = 1
                                                AND d.D_Status = 1
                                                AND ( du.Du_Status = 1
                                                      OR du.Du_Status IS NULL
                                                    )
                                    ) TmpTable
                          GROUP BY  USS_UserId ,
                                    USS_UserName ,
                                    USS_DepartmentId,
                                    USS_DepartmentName ,
                                    USS_DutyName
                        ) TmpTable1
		
        RETURN;
    END

GO

IF OBJECT_ID(N'dbo.UserScoreSummaries', 'V') IS NOT NULL
	DROP VIEW dbo.UserScoreSummaries;
GO

CREATE VIEW dbo.UserScoreSummaries
AS
SELECT * FROM dbo.fn_GetUserScoreSummary()

GO
/***************************************************
** [OLS_v0.13]08修改【用户成绩概览导出视图 UserScoreSummaryToExcel】.sql
****************************************************/

IF OBJECT_ID(N'dbo.UserScoreSummaryToExcel') IS NOT NULL 
    DROP VIEW dbo.UserScoreSummaryToExcel

GO

CREATE VIEW dbo.UserScoreSummaryToExcel
AS
    SELECT  USS_UserId ,
            USS_UserName ,
            USS_UserName 用户 ,
            USS_DepartmentId ,
            USS_DepartmentName 部门 ,
            USS_DutyName 职务 ,
            USS_TotalNumber 应考 ,
            USS_DoneNumber 已考 ,
            USS_UndoNumber 未考 ,
            USS_PassNumber 合格 ,
            CAST(USS_DoneRatio AS VARCHAR(5)) + '%' 参考率 ,
            CAST(USS_PassRatio AS VARCHAR(5)) + '%' 合格率
    FROM    dbo.fn_GetUserScoreSummary()

GO

/***************************************************
** [OLS_v0.13]09修改【用户成绩详情导出视图 UserScoreDetailToExcel】.sql
****************************************************/

IF OBJECT_ID(N'dbo.UserScoreDetailToExcel', 'V') IS NOT NULL 
    DROP VIEW dbo.UserScoreDetailToExcel;
GO

CREATE VIEW dbo.UserScoreDetailToExcel
AS
    SELECT  USD_UserId,
			USD_UserName,
			USD_DepartmentId,
			USD_DepartmentName,
			USD_TaskName,
			USD_StartTime,
			USD_PaperId,
			CASE WHEN USD_PaperId = 0 THEN '' ELSE CAST(USD_PaperId AS NVARCHAR(20)) END 试卷编号,
			USD_TaskName 考试任务 ,
            CONVERT(VARCHAR(20), USD_StartTime, 20) 考试时间 ,
            CASE USD_TaskStatisticType
              WHEN 1 THEN '得分'
              WHEN 2 THEN '正确率'
              ELSE '[未设置]'
            END 成绩类型 ,
            CASE USD_Score
              WHEN -1 THEN ''
              ELSE CASE USD_TaskStatisticType
                     WHEN 1 THEN CAST(USD_Score AS VARCHAR(10)) + '分'
                     WHEN 2 THEN CAST(USD_Score AS VARCHAR(10)) + '%'
                     ELSE ''
                   END
            END 成绩 ,
            CASE USD_State
              WHEN 1 THEN '未考试'
              WHEN 2 THEN '未打分'
              WHEN 3 THEN '合格'
              WHEN 4 THEN '未合格'
              ELSE '[未设置]'
            END 状态
    FROM    dbo.fn_GetUserScoreDetail()

GO
