USE master

GO

-- 删除数据库
------------------------------------------------------------------

IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[p_killspid]')
                    AND OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
    DROP PROCEDURE [dbo].[p_killspid]
GO

--建立一个存储过程
CREATE PROC p_killspid @dbname SYSNAME --要关闭进程的数据库名
AS 
    DECLARE @s NVARCHAR(1000)
    DECLARE tb CURSOR local
        FOR SELECT  s = 'kill ' + CAST(spid AS VARCHAR)
            FROM    master..sysprocesses
            WHERE   dbid = DB_ID(@dbname)
    OPEN tb
    FETCH NEXT FROM tb INTO @s
    WHILE @@fetch_status = 0
        BEGIN
            EXEC(@s)
            FETCH NEXT FROM tb INTO @s
        END
    CLOSE tb
    DEALLOCATE tb
GO

EXEC p_killspid 'OLS'

GO

DROP DATABASE OLS;

GO

------------------------------------------------------------------

-- 初始化数据库
------------------------------------------------------------------

CREATE DATABASE OLS ON
	(
		NAME='OLS_Data',
		FILENAME='D:\SQL Server 2008 Data\OLS.mdf',
		SIZE=3,
		MAXSIZE=UNLIMITED,
		FILEGROWTH=200MB
	) LOG ON
	(
		NAME='OLS_Log',
		FILENAME='D:\SQL Server 2008 Data\OLS_log.ldf',
		SIZE=1,
		MAXSIZE=UNLIMITED,
		FILEGROWTH=200MB
	)

GO

------------------------------------------------------------------

-- 初始化数据结构
------------------------------------------------------------------

USE OLS;

GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Department_Role') and o.name = 'FK_DEPARTME_DR_D_DEPARTME')
alter table Department_Role
   drop constraint FK_DEPARTME_DR_D_DEPARTME
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Department_Role') and o.name = 'FK_DEPARTME_DR_R_ROLES')
alter table Department_Role
   drop constraint FK_DEPARTME_DR_R_ROLES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationPaperQuestions') and o.name = 'FK_EXAMINAT_EQ_EP_EXAMINAT')
alter table ExaminationPaperQuestions
   drop constraint FK_EXAMINAT_EQ_EP_EXAMINAT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationPaperTemplateQuestions') and o.name = 'FK_EXAMINAT_EPTQ_EPT_EXAMINAT')
alter table ExaminationPaperTemplateQuestions
   drop constraint FK_EXAMINAT_EPTQ_EPT_EXAMINAT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationPaperTemplates') and o.name = 'FK_EXAMINAT_EPT_ET_EXAMINAT')
alter table ExaminationPaperTemplates
   drop constraint FK_EXAMINAT_EPT_ET_EXAMINAT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ExaminationPapers') and o.name = 'FK_EXAMINAT_EP_EPT_EXAMINAT')
alter table ExaminationPapers
   drop constraint FK_EXAMINAT_EP_EPT_EXAMINAT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Permissions') and o.name = 'FK_PERMISSI_P_PC_PERMISSI')
alter table Permissions
   drop constraint FK_PERMISSI_P_PC_PERMISSI
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Questions') and o.name = 'FK_QUESTION_Q_QC_QUESTION')
alter table Questions
   drop constraint FK_QUESTION_Q_QC_QUESTION
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Role_Permission') and o.name = 'FK_ROLE_PER_RP_P_PERMISSI')
alter table Role_Permission
   drop constraint FK_ROLE_PER_RP_P_PERMISSI
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Role_Permission') and o.name = 'FK_ROLE_PER_RP_R_ROLES')
alter table Role_Permission
   drop constraint FK_ROLE_PER_RP_R_ROLES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('User_Department') and o.name = 'FK_USER_DEP_UD_D_DEPARTME')
alter table User_Department
   drop constraint FK_USER_DEP_UD_D_DEPARTME
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('User_Department') and o.name = 'FK_USER_DEP_UD_U_USERS')
alter table User_Department
   drop constraint FK_USER_DEP_UD_U_USERS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('User_Role') and o.name = 'FK_USER_ROL_UR_R_ROLES')
alter table User_Role
   drop constraint FK_USER_ROL_UR_R_ROLES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('User_Role') and o.name = 'FK_USER_ROL_UR_U_USERS')
alter table User_Role
   drop constraint FK_USER_ROL_UR_U_USERS
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Users') and o.name = 'FK_USERS_U_DU_DUTIES')
alter table Users
   drop constraint FK_USERS_U_DU_DUTIES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Department_Role')
            and   type = 'U')
   drop table Department_Role
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Departments')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index Departments.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Departments')
            and   type = 'U')
   drop table Departments
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Duties')
            and   type = 'U')
   drop table Duties
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ExaminationPaperQuestions')
            and   type = 'U')
   drop table ExaminationPaperQuestions
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ExaminationPaperTemplateQuestions')
            and   type = 'U')
   drop table ExaminationPaperTemplateQuestions
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ExaminationPaperTemplates')
            and   type = 'U')
   drop table ExaminationPaperTemplates
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ExaminationPapers')
            and   type = 'U')
   drop table ExaminationPapers
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ExaminationTaskTemplates')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index ExaminationTaskTemplates.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ExaminationTaskTemplates')
            and   type = 'U')
   drop table ExaminationTaskTemplates
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ExaminationTasks')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index ExaminationTasks.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ExaminationTasks')
            and   type = 'U')
   drop table ExaminationTasks
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PermissionCategories')
            and   type = 'U')
   drop table PermissionCategories
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Permissions')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index Permissions.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Permissions')
            and   type = 'U')
   drop table Permissions
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('QuestionClassifies')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index QuestionClassifies.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('QuestionClassifies')
            and   type = 'U')
   drop table QuestionClassifies
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Questions')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index Questions.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Questions')
            and   type = 'U')
   drop table Questions
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Role_Permission')
            and   type = 'U')
   drop table Role_Permission
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Roles')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index Roles.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Roles')
            and   type = 'U')
   drop table Roles
go

if exists (select 1
            from  sysobjects
           where  id = object_id('User_Department')
            and   type = 'U')
   drop table User_Department
go

if exists (select 1
            from  sysobjects
           where  id = object_id('User_Role')
            and   type = 'U')
   drop table User_Role
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Users')
            and   name  = 'Index_1'
            and   indid > 0
            and   indid < 255)
   drop index Users.Index_1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Users')
            and   type = 'U')
   drop table Users
go

/*==============================================================*/
/* Table: Department_Role                                       */
/*==============================================================*/
create table Department_Role (
   D_Id                 int                  null,
   R_Id                 int                  null
)
go

/*==============================================================*/
/* Table: Departments                                           */
/*==============================================================*/
create table Departments (
   D_Id                 int                  not null,
   D_AutoId             int                  identity,
   D_Name               varchar(50)          not null,
   D_Roles              text                 null,
   D_Level              varchar(50)          not null,
   D_Remark             varchar(200)         null,
   D_AddTime            DateTime2            not null,
   D_Status             tinyint              not null,
   constraint PK_DEPARTMENTS primary key (D_Id)
)
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on Departments (
D_Name ASC
)
go

/*==============================================================*/
/* Table: Duties                                                */
/*==============================================================*/
create table Duties (
   Du_Id                int                  not null,
   Du_AutoId            int                  identity,
   Du_Name              varchar(50)          not null,
   Du_Remark            varchar(200)         null,
   Du_AddTime           datetime2            not null,
   Du_Status            tinyint              not null,
   constraint PK_DUTIES primary key (Du_Id)
)
go

/*==============================================================*/
/* Table: ExaminationPaperQuestions                             */
/*==============================================================*/
create table ExaminationPaperQuestions (
   EPQ_Id               int                  not null,
   EPQ_AutoId           int                  identity,
   EPTQ_Id              int                  null,
   EP_Id                int                  null,
   EPQ_Answer           text                 not null,
   EPQ_Exactness        tinyint              not null,
   EPQ_Critique         varchar(200)         null,
   EPQ_AddTime          datetime2            not null,
   constraint PK_EXAMINATIONPAPERQUESTIONS primary key (EPQ_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPaperQuestions')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EP_Id')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EP_Id'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '试卷',
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EP_Id'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPaperQuestions')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EPQ_Answer')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EPQ_Answer'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '答案',
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EPQ_Answer'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPaperQuestions')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EPQ_Exactness')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EPQ_Exactness'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '是否正确',
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EPQ_Exactness'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPaperQuestions')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EPQ_Critique')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EPQ_Critique'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '点评',
   'user', @CurrentUser, 'table', 'ExaminationPaperQuestions', 'column', 'EPQ_Critique'
go

/*==============================================================*/
/* Table: ExaminationPaperTemplateQuestions                     */
/*==============================================================*/
create table ExaminationPaperTemplateQuestions (
   EPTQ_Id              int                  not null,
   EPTQ_AutoId          int                  identity,
   EPT_Id               int                  null,
   EPTQ_Type            varchar(20)          not null,
   EPTQ_Classify        int                  not null,
   EPTQ_DifficultyCoefficient tinyint              not null,
   EPTQ_Content         text                 not null,
   EPTQ_OptionalAnswer  varchar(500)         not null,
   EPTQ_ModelAnswer     text                 not null,
   EPTQ_Remark          varchar(200)         null,
   EPTQ_AddTime         datetime2            not null,
   EPTQ_Status          tinyint              null,
   constraint PK_EXAMINATIONPAPERTEMPLATEQUE primary key (EPTQ_Id)
)
go

/*==============================================================*/
/* Table: ExaminationPaperTemplates                             */
/*==============================================================*/
create table ExaminationPaperTemplates (
   EPT_Id               int                  not null,
   EPT_AutoId           int                  identity,
   ET_Id                int                  null,
   ET_Type              tinyint              null,
   EPT_PaperTemplateStatus tinyint              null,
   EPT_StartTime        datetime2            not null,
   EPT_EndTime          datetime2            null,
   EPT_TimeSpan         int                  not null,
   EPT_Questions        text                 null,
   EPT_Remark           varchar(200)         null,
   EPT_AddTime          datetime2            not null,
   EPT_Status           tinyint              not null,
   constraint PK_EXAMINATIONPAPERTEMPLATES primary key (EPT_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPaperTemplates')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EPT_PaperTemplateStatus')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPaperTemplates', 'column', 'EPT_PaperTemplateStatus'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 进行中
   1 已结束',
   'user', @CurrentUser, 'table', 'ExaminationPaperTemplates', 'column', 'EPT_PaperTemplateStatus'
go

/*==============================================================*/
/* Table: ExaminationPapers                                     */
/*==============================================================*/
create table ExaminationPapers (
   EP_Id                int                  not null,
   EP_AutoId            int                  identity,
   EPT_Id               int                  null,
   EP_PaperStatus       tinyint              null,
   EP_UserId            int                  not null,
   EP_UserName          varchar(10)          null,
   EP_Score             int                  not null,
   EP_Remark            varchar(200)         null,
   EP_AddTime           DateTime2            not null,
   EP_Status            tinyint              not null,
   constraint PK_EXAMINATIONPAPERS primary key (EP_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPapers')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EP_PaperStatus')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPapers', 'column', 'EP_PaperStatus'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 进行中
   1 已结束',
   'user', @CurrentUser, 'table', 'ExaminationPapers', 'column', 'EP_PaperStatus'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationPapers')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'EP_Status')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationPapers', 'column', 'EP_Status'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 删除
   1 可见',
   'user', @CurrentUser, 'table', 'ExaminationPapers', 'column', 'EP_Status'
go

/*==============================================================*/
/* Table: ExaminationTaskTemplates                              */
/*==============================================================*/
create table ExaminationTaskTemplates (
   ETT_Id               int                  not null,
   ETT_AutoId           int                  identity,
   ETT_Name             varchar(50)          not null,
   ETT_Type             tinyint              not null,
   ETT_Mode             tinyint              not null,
   ETT_DifficultyCoefficient tinyint              not null,
   ETT_ParticipatingDepartment text                 null,
   ETT_Attendee         text                 null,
   ETT_AutoType         tinyint              not null,
   ETT_AutoOffsetDay    tinyint              null,
   ETT_StartTime        DateTime2            not null,
   ETT_EndTime          DateTime2            not null,
   ETT_TimeSpan         int                  not null,
   ETT_Remark           varchar(200)         null,
   ETT_AddTime          DateTime2            not null,
   ETT_Status           tinyint              not null,
   constraint PK_EXAMINATIONTASKTEMPLATES primary key (ETT_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTaskTemplates')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ETT_Type')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTaskTemplates', 'column', 'ETT_Type'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 考试
   1 练习',
   'user', @CurrentUser, 'table', 'ExaminationTaskTemplates', 'column', 'ETT_Type'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTaskTemplates')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ETT_Mode')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTaskTemplates', 'column', 'ETT_Mode'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 手动
   1 自动',
   'user', @CurrentUser, 'table', 'ExaminationTaskTemplates', 'column', 'ETT_Mode'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTaskTemplates')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ETT_AutoType')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTaskTemplates', 'column', 'ETT_AutoType'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 关闭
   1 每日
   2 每星期
   3 每月',
   'user', @CurrentUser, 'table', 'ExaminationTaskTemplates', 'column', 'ETT_AutoType'
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on ExaminationTaskTemplates (
ETT_Name ASC
)
go

/*==============================================================*/
/* Table: ExaminationTasks                                      */
/*==============================================================*/
create table ExaminationTasks (
   ET_Id                int                  not null,
   ET_AutoId            int                  identity,
   ET_Name              varchar(50)          not null,
   ET_Type              tinyint              not null,
   ET_Mode              tinyint              not null,
   ET_DifficultyCoefficient tinyint              not null,
   ET_ParticipatingDepartment text                 null,
   ET_Attendee          text                 null,
   ET_AutoType          tinyint              not null,
   ET_AutoOffsetDay     tinyint              null,
   ET_StartTime         DateTime2            not null,
   ET_EndTime           DateTime2            not null,
   ET_TimeSpan          int                  not null,
   ET_PaperTemplates    text                 null,
   ET_Questions         text                 null,
   ET_Remark            varchar(200)         null,
   ET_AddTime           DateTime2            not null,
   ET_Status            tinyint              not null,
   constraint PK_EXAMINATIONTASKS primary key (ET_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTasks')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ET_Type')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_Type'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 考试
   1 练习',
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_Type'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTasks')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ET_Mode')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_Mode'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 手动
   1 自动',
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_Mode'
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ExaminationTasks')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'ET_AutoType')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_AutoType'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 关闭
   1 每日
   2 每星期
   3 每月
   4 按时，单位为分钟',
   'user', @CurrentUser, 'table', 'ExaminationTasks', 'column', 'ET_AutoType'
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on ExaminationTasks (
ET_Name ASC
)
go

/*==============================================================*/
/* Table: PermissionCategories                                  */
/*==============================================================*/
create table PermissionCategories (
   PC_Id                int                  not null,
   PC_AutoId            int                  identity,
   PC_Name              varchar(20)          not null,
   PC_Level             varchar(50)          not null,
   PC_Remark            varchar(200)         null,
   PC_AddTime           datetime2            not null,
   PC_Status            tinyint              not null,
   constraint PK_PERMISSIONCATEGORIES primary key (PC_Id)
)
go

/*==============================================================*/
/* Table: Permissions                                           */
/*==============================================================*/
create table Permissions (
   P_Id                 int                  not null,
   P_AutoId             int                  identity,
   PC_Id                int                  null,
   P_Name               varchar(50)          not null,
   P_Controller         varchar(50)          not null,
   P_Action             varchar(50)          not null,
   P_Remark             varchar(200)         null,
   P_AddTime            DateTime2            not null,
   constraint PK_PERMISSIONS primary key (P_Id)
)
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on Permissions (
P_Name ASC
)
go

/*==============================================================*/
/* Table: QuestionClassifies                                    */
/*==============================================================*/
create table QuestionClassifies (
   QC_Id                int                  not null,
   QC_AutoId            int                  identity,
   QC_Name              varchar(100)         not null,
   QC_Level             varchar(50)          not null,
   QC_Remark            varchar(200)         null,
   QC_AddTime           DateTime2            not null,
   QC_Status            tinyint              not null,
   constraint PK_QUESTIONCLASSIFIES primary key (QC_Id)
)
go

if exists (select 1 from  sys.extended_properties
           where major_id = object_id('QuestionClassifies') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'QuestionClassifies' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   '分类示例：
   2014梅州市局
   信息技术练习题库
   2012梅州市局信息技术岗位练兵', 
   'user', @CurrentUser, 'table', 'QuestionClassifies'
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on QuestionClassifies (
QC_Name ASC
)
go

/*==============================================================*/
/* Table: Questions                                             */
/*==============================================================*/
create table Questions (
   Q_Id                 int                  not null,
   Q_AutoId             int                  identity,
   Q_Type               varchar(20)          not null,
   QC_Id                int                  null,
   Q_DifficultyCoefficient tinyint              not null,
   Q_Content            text                 not null,
   Q_OptionalAnswer     varchar(500)         null,
   Q_ModelAnswer        text                 not null,
   Q_Remark             varchar(200)         null,
   Q_AddTime            DateTime2            not null,
   Q_Status             tinyint              not null,
   constraint PK_QUESTIONS primary key (Q_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Questions')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'Q_Type')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Questions', 'column', 'Q_Type'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '题目类型。
   0 单项选择题
   1 多项选择题
   2 判断题
   3 公文改错题
   4 计算题
   5 案例分析题
   6 问答题',
   'user', @CurrentUser, 'table', 'Questions', 'column', 'Q_Type'
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on Questions (
Q_Type ASC,
Q_DifficultyCoefficient ASC
)
go

/*==============================================================*/
/* Table: Role_Permission                                       */
/*==============================================================*/
create table Role_Permission (
   R_Id                 int                  not null,
   P_Id                 int                  not null
)
go

/*==============================================================*/
/* Table: Roles                                                 */
/*==============================================================*/
create table Roles (
   R_Id                 int                  not null,
   R_AutoId             int                  identity,
   R_Name               varchar(50)          not null,
   R_Permissions        text                 null,
   R_PermissionCategories text                 null,
   R_Remark             varchar(200)         null,
   R_AddTime            DateTime2            not null,
   R_Status             tinyint              not null,
   constraint PK_ROLES primary key (R_Id)
)
go

if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Roles') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Roles' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   '角色表/职务表', 
   'user', @CurrentUser, 'table', 'Roles'
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on Roles (
R_Name ASC
)
go

/*==============================================================*/
/* Table: User_Department                                       */
/*==============================================================*/
create table User_Department (
   U_Id                 int                  not null,
   D_Id                 int                  not null
)
go

/*==============================================================*/
/* Table: User_Role                                             */
/*==============================================================*/
create table User_Role (
   U_Id                 int                  not null,
   R_Id                 int                  not null
)
go

/*==============================================================*/
/* Table: Users                                                 */
/*==============================================================*/
create table Users (
   U_Id                 int                  not null,
   U_AutoId             int                  identity,
   Du_Id                int                  null,
   U_Name               varchar(10)          not null,
   U_LoginName          varchar(50)          not null,
   U_Password           varchar(200)         not null,
   U_Departments        text                 null,
   U_Roles              text                 null,
   U_Remark             varchar(200)         null,
   U_AddTime            DateTime2            not null,
   U_Status             tinyint              not null,
   constraint PK_USERS primary key (U_Id)
)
go

if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Users')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'U_Status')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Users', 'column', 'U_Status'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '0 删除
   1 启用',
   'user', @CurrentUser, 'table', 'Users', 'column', 'U_Status'
go

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on Users (
U_Name ASC,
U_LoginName ASC
)
go

alter table Department_Role
   add constraint FK_DEPARTME_DR_D_DEPARTME foreign key (D_Id)
      references Departments (D_Id)
go

alter table Department_Role
   add constraint FK_DEPARTME_DR_R_ROLES foreign key (R_Id)
      references Roles (R_Id)
go

alter table ExaminationPaperQuestions
   add constraint FK_EXAMINAT_EQ_EP_EXAMINAT foreign key (EP_Id)
      references ExaminationPapers (EP_Id)
go

alter table ExaminationPaperTemplateQuestions
   add constraint FK_EXAMINAT_EPTQ_EPT_EXAMINAT foreign key (EPT_Id)
      references ExaminationPaperTemplates (EPT_Id)
go

alter table ExaminationPaperTemplates
   add constraint FK_EXAMINAT_EPT_ET_EXAMINAT foreign key (ET_Id)
      references ExaminationTasks (ET_Id)
go

alter table ExaminationPapers
   add constraint FK_EXAMINAT_EP_EPT_EXAMINAT foreign key (EPT_Id)
      references ExaminationPaperTemplates (EPT_Id)
go

alter table Permissions
   add constraint FK_PERMISSI_P_PC_PERMISSI foreign key (PC_Id)
      references PermissionCategories (PC_Id)
go

alter table Questions
   add constraint FK_QUESTION_Q_QC_QUESTION foreign key (QC_Id)
      references QuestionClassifies (QC_Id)
go

alter table Role_Permission
   add constraint FK_ROLE_PER_RP_P_PERMISSI foreign key (P_Id)
      references Permissions (P_Id)
go

alter table Role_Permission
   add constraint FK_ROLE_PER_RP_R_ROLES foreign key (R_Id)
      references Roles (R_Id)
go

alter table User_Department
   add constraint FK_USER_DEP_UD_D_DEPARTME foreign key (D_Id)
      references Departments (D_Id)
go

alter table User_Department
   add constraint FK_USER_DEP_UD_U_USERS foreign key (U_Id)
      references Users (U_Id)
go

alter table User_Role
   add constraint FK_USER_ROL_UR_R_ROLES foreign key (R_Id)
      references Roles (R_Id)
go

alter table User_Role
   add constraint FK_USER_ROL_UR_U_USERS foreign key (U_Id)
      references Users (U_Id)
go

alter table Users
   add constraint FK_USERS_U_DU_DUTIES foreign key (Du_Id)
      references Duties (Du_Id)
go

------------------------------------------------------------------

-- 初始化用户数据
------------------------------------------------------------------
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (1, '技术部', '[1]', '0001', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (1, '技术部', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (1, 1);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (1, '系统管理员', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (1, '系统管理员', 'Admin', '86A59028668AA3DB6794A16C91D30476'/*kyzx201510*/, 1, '[1]', '[1]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (1, 1);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (2, '局长室', '[2]', '0002', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (2, '局长室', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (2, 2);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (2, '局长', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (2, '郑旭彪', 'ZhengXuBiao', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 2, '[2]', '[2]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (2, 2);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (3, '副局长室', '[3]', '0003', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (3, '副局长室', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (3, 3);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (3, '副局长', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (3, '何坤文', 'HeKunWen', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 3, '[3]', '[3]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (3, 3);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (4, '刘文胜', 'LiuWenSheng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 3, '[3]', '[3]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (4, 3);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (5, '黄立权', 'HuangLiQuan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[3]', '[3]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (5, 3);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (4, '纪检组长室', '[4]', '0004', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (4, '纪检组长室', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (4, 4);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (4, '纪检组长', NULL, GETDATE(), 1);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (5, '总经济师', '[5]', '0005', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (5, '总经济师', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (5, 5);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (5, '总经济师', NULL, GETDATE(), 1);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (6, '办公室', '[6]', '0006', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (6, '办公室', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (6, 6);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (6, '主任', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (6, '李惠平', 'LiHuiPing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 6, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (6, 6);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (7, '副主任', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (7, '彭远达', 'PengYuanDa', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 7, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (7, 6);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (8, '张清平', 'ZhangQingPing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (8, 6);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (9, '李婷', 'LiTing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (9, 6);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (8, '业务组长', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (10, '刘会文', 'LiuHuiWen', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 8, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (10, 6);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (11, '张丹丹', 'ZhangDanDan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (11, 6);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (12, '肖志崇', 'XiaoZhiChong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (12, 6);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (13, '廖秋芳', 'LiaoQiuFang', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (13, 6);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (14, '钟岚', 'ZhongLan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (14, 6);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (15, '刘珊', 'LiuShan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (15, 6);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (16, '何兴章', 'HeXingZhang', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (16, 6);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (9, '司机', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (17, '陈耀辉', 'ChenYaoHui', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 9, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (17, 6);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (18, '肖森怀', 'XiaoSenHuai', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 9, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (18, 6);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (19, '何益文', 'HeYiWen', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 9, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (19, 6);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (20, '陈文峰', 'ChenWenFeng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 9, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (20, 6);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (21, '廖春福', 'LiaoChunFu', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 9, '[6]', '[6]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (21, 6);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (7, '税政股', '[7]', '0007', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (7, '税政股', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (7, 7);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (10, '股长', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (22, '罗建华', 'LuoJianHua', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 10, '[7]', '[7]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (22, 7);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (23, '郭俊耿', 'GuoJunGeng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[7]', '[7]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (23, 7);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (24, '徐中辉', 'XuZhongHui', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[7]', '[7]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (24, 7);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (11, '临工', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (25, '廖春利', 'LiaoChunLi', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 11, '[7]', '[7]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (25, 7);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (8, '征管股', '[8]', '0008', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (8, '征管股', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (8, 8);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (26, '张伟', 'ZhangWei', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 10, '[8]', '[8]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (26, 8);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (12, '副股长', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (27, '罗标辉', 'LuoBiaoHui', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 12, '[8]', '[8]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (27, 8);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (28, '曾强', 'ZengQiang', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[8]', '[8]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (28, 8);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (29, '钟玉', 'ZhongYu', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[8]', '[8]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (29, 8);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (30, '刘春梅', 'LiuChunMei', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[8]', '[8]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (30, 8);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (31, '彭利锋', 'PengLiFeng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[8]', '[8]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (31, 8);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (32, '吴红中', 'WuHongZhong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 8, '[8]', '[8]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (32, 8);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (33, '张颖', 'ZhangYing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[8]', '[8]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (33, 8);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (34, '朱雨辰', 'ZhuYuChen', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 11, '[8]', '[8]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (34, 8);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (13, '副分局长', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (35, '胡燕芬', 'HuYanFen', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 13, '[8]', '[8]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (35, 8);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (36, '陈远东', 'ChenYuanDong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 8, '[8]', '[8]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (36, 8);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (37, '曾利方', 'ZengLiFang', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[8]', '[8]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (37, 8);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (38, '张添朋', 'ZhangTianPeng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[8]', '[8]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (38, 8);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (9, '人教股', '[9]', '0009', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (9, '人教股', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (9, 9);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (39, '刁向萍', 'DiaoXiangPing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 10, '[9]', '[9]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (39, 9);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (14, '副主任科员', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (40, '张展林', 'ZhangZhanLin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 14, '[9]', '[9]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (40, 9);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (41, '赖建华', 'LaiJianHua', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 14, '[9]', '[9]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (41, 9);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (42, '刘思明', 'LiuSiMing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 14, '[9]', '[9]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (42, 9);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (43, '陈伟新', 'ChenWeiXin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[9]', '[9]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (43, 9);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (44, '孙剑波', 'SunJianBo', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[9]', '[9]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (44, 9);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (45, '陈佳伟', 'ChenJiaWei', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[9]', '[9]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (45, 9);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (10, '监察室', '[10]', '0010', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (10, '监察室', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (10, 10);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (46, '钟玩章', 'ZhongWanZhang', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 6, '[10]', '[10]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (46, 10);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (47, '李荣怀', 'LiRongHuai', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 8, '[10]', '[10]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (47, 10);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (11, '纳税服务股', '[11]', '0011', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (11, '纳税服务股', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (11, 11);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (48, '蔡伟政', 'CaiWeiZheng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 10, '[11]', '[11]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (48, 11);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (49, '陈伟苑', 'ChenWeiYuan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[11]', '[11]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (49, 11);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (15, '协税员', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (50, '林丹', 'LinDan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[11]', '[11]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (50, 11);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (12, '稽查局', '[12]', '0012', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (12, '稽查局', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (12, 12);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (51, '刘波', 'LiuBo', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 2, '[12]', '[12]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (51, 12);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (52, '吴焕昌', 'WuHuanChang', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 3, '[12]', '[12]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (52, 12);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (16, '办公室副主任', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (53, '钟云彬', 'ZhongYunBin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 16, '[12]', '[12]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (53, 12);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (54, '刘坤', 'LiuKun', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[12]', '[12]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (54, 12);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (17, '稽查股股长', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (55, '潘建强', 'PanJianQiang', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 17, '[12]', '[12]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (55, 12);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (18, '稽查股副股长', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (56, '黄永新', 'HuangYongXin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 18, '[12]', '[12]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (56, 12);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (57, '罗俊辉', 'LuoJunHui', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[12]', '[12]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (57, 12);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (19, '审理股副股长', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (58, '陈冲', 'ChenChong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 19, '[12]', '[12]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (58, 12);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (59, '龚浩', 'GongHao', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[12]', '[12]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (59, 12);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (20, '执行股股长', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (60, '孙佑新', 'SunYouXin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 20, '[12]', '[12]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (60, 12);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (61, '钟明', 'ZhongMing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[12]', '[12]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (61, 12);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (13, '新陂分局（大税源管理分局） ', '[13]', '0013', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (13, '新陂分局（大税源管理分局） ', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (13, 13);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (21, '分局长', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (62, '陈启东', 'ChenQiDong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 21, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (62, 13);
INSERT INTO Duties (Du_Id, Du_Name, Du_Remark, Du_AddTime, Du_Status) VALUES (22, '专职监察员', NULL, GETDATE(), 1);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (63, '刘红', 'LiuHong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 22, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (63, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (64, '彭伟林', 'PengWeiLin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 13, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (64, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (65, '伍伟清', 'WuWeiQing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (65, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (66, '黄志高', 'HuangZhiGao', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (66, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (67, '黄侃炎', 'HuangKanYan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (67, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (68, '刘光平', 'LiuGuangPing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (68, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (69, '温启华', 'WenQiHua', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (69, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (70, '林集', 'LinJi', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (70, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (71, '刁雄', 'DiaoXiong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (71, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (72, '毛建军', 'MaoJianJun', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (72, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (73, '刘仿新', 'LiuFangXin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (73, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (74, '罗源', 'LuoYuan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (74, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (75, '王永东', 'WangYongDong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (75, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (76, '余理键', 'YuLiJian', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (76, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (77, '戴文锋', 'DaiWenFeng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (77, 13);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (78, '钟荣榜', 'ZhongRongBang', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[13]', '[13]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (78, 13);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (14, '宁中分局（一般税源管理分局）', '[14]', '0014', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (14, '宁中分局（一般税源管理分局）', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (14, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (79, '王新', 'WangXin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 21, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (79, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (80, '罗洪波', 'LuoHongBo', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 22, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (80, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (81, '李永红', 'LiYongHong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 13, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (81, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (82, '陈庆辉', 'ChenQingHui', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 13, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (82, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (83, '罗志红', 'LuoZhiHong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 8, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (83, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (84, '罗小明', 'LuoXiaoMing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 8, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (84, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (85, '吴思科', 'WuSiKe', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (85, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (86, '黄浩', 'HuangHao', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (86, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (87, '童茂汕', 'TongMaoShan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (87, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (88, '陈建中', 'ChenJianZhong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (88, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (89, '张新伟', 'ZhangXinWei', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (89, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (90, '张运华', 'ZhangYunHua', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (90, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (91, '陈定金', 'ChenDingJin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (91, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (92, '陈新宏', 'ChenXinHong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (92, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (93, '李凡', 'LiFan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (93, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (94, '黄斯列', 'HuangSiLie', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (94, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (95, '刘森朋', 'LiuSenPeng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (95, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (96, '王福群', 'WangFuQun', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (96, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (97, '刘山权', 'LiuShanQuan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (97, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (98, '王宁华', 'WangNingHua', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (98, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (99, '林顺兴', 'LinShunXing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (99, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (100, '高汉明', 'GaoHanMing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (100, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (101, '罗万能', 'LuoWanNen', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (101, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (102, '陈益辉', 'ChenYiHui', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (102, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (103, '曾金泉', 'ZengJinQuan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (103, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (104, '张明才', 'ZhangMingCai', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (104, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (105, '陈卫民', 'ChenWeiMin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (105, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (106, '张建东', 'ZhangJianDong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (106, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (107, '刘秋慧', 'LiuQiuHui', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (107, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (108, '黄育清', 'HuangYuQing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (108, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (109, '李文光', 'LiWenGuang', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (109, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (110, '幸伟越', 'XingWeiYue', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (110, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (111, '李汉来', 'LiHanLai', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (111, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (112, '曾洪辉', 'ZengHongHui', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (112, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (113, '刁伟金', 'DiaoWeiJin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (113, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (114, '林远松', 'LinYuanSong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (114, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (115, '曾国强', 'ZengGuoQiang', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (115, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (116, '曾祥万', 'ZengXiangWan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (116, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (117, '陈冠雄', 'ChenGuanXiong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (117, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (118, '朱荣桂', 'ZhuRongGui', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (118, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (119, '刘明育', 'LiuMingYu', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (119, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (120, '黄岸平', 'HuangAnPing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (120, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (121, '王建清', 'WangJianQing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (121, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (122, '黄玩华', 'HuangWanHua', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (122, 14);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (123, '罗庆桓', 'LuoQingHuan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[14]', '[14]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (123, 14);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (15, '城区分局', '[15]', '0015', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (15, '城区分局', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (15, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (124, '刁苑辉', 'DiaoYuanHui', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 21, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (124, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (125, '孙丽霞', 'SunLiXia', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 13, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (125, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (126, '曾科', 'ZengKe', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 13, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (126, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (127, '谢伟东', 'XieWeiDong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 8, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (127, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (128, '张艳芳', 'ZhangYanFang', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (128, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (129, '陈利娟', 'ChenLiJuan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (129, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (130, '钟燕飞', 'ZhongYanFei', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (130, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (131, '陈菊新', 'ChenJuXin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (131, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (132, '李汉华', 'LiHanHua', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (132, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (133, '吴国辉', 'WuGuoHui', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (133, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (134, '肖学东', 'XiaoXueDong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (134, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (135, '罗卫东', 'LuoWeiDong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (135, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (136, '梁平', 'LiangPing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (136, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (137, '罗国新', 'LuoGuoXin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (137, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (138, '刘俐平', 'LiuLiPing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (138, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (139, '廖娟', 'LiaoJuan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (139, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (140, '陈思', 'ChenSi', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (140, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (141, '刘春兰', 'LiuChunLan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (141, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (142, '钟海平', 'ZhongHaiPing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (142, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (143, '邓佳维', 'DengJiaWei', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (143, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (144, '邱美婷', 'QiuMeiTing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (144, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (145, '曾婷', 'ZengTing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (145, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (146, '范雅静', 'FanYaJing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (146, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (147, '黄幸华', 'HuangXingHua', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (147, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (148, '丁颖', 'DingYing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (148, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (149, '范婷', 'FanTing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (149, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (150, '袁丹艳', 'YuanDanYan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (150, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (151, '毛双利', 'MaoShuangLi', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (151, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (152, '彭燕', 'PengYan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (152, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (153, '郑俏玲', 'ZhengQiaoLing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (153, 15);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (154, '陈萍', 'ChenPing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[15]', '[15]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (154, 15);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (16, '罗岗分局', '[16]', '0016', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (16, '罗岗分局', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (16, 16);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (155, '张思明', 'ZhangSiMing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 21, '[16]', '[16]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (155, 16);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (156, '邱力', 'QiuLi', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 8, '[16]', '[16]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (156, 16);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (157, '罗启杰', 'LuoQiJie', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[16]', '[16]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (157, 16);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (158, '刘庆福', 'LiuQingFu', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[16]', '[16]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (158, 16);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (159, '陈国平', 'ChenGuoPing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[16]', '[16]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (159, 16);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (160, '欧阳升', 'OuYangSheng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[16]', '[16]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (160, 16);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (161, '陈峰', 'ChenFeng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[16]', '[16]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (161, 16);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (17, '黄陂分局 ', '[17]', '0017', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (17, '黄陂分局 ', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (17, 17);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (162, '蓝俊波', 'LanJunBo', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 21, '[17]', '[17]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (162, 17);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (163, '王悦', 'WangYue', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 13, '[17]', '[17]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (163, 17);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (164, '张裕坚', 'ZhangYuJian', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[17]', '[17]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (164, 17);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (165, '陈为民', 'ChenWeiMin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[17]', '[17]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (165, 17);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (166, '侯学文', 'HouXueWen', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[17]', '[17]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (166, 17);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (167, '李丽珠', 'LiLiZhu', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[17]', '[17]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (167, 17);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (168, '罗维静', 'LuoWeiJing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[17]', '[17]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (168, 17);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (18, '龙田分局', '[18]', '0018', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (18, '龙田分局', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (18, 18);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (169, '刘绍斌', 'LiuShaoBin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 21, '[18]', '[18]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (169, 18);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (170, '陈东', 'ChenDong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 13, '[18]', '[18]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (170, 18);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (171, '许国锋', 'XuGuoFeng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 13, '[18]', '[18]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (171, 18);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (172, '王梅飞', 'WangMeiFei', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 8, '[18]', '[18]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (172, 18);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (173, '钟焕元', 'ZhongHuanYuan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[18]', '[18]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (173, 18);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (174, '刘亮生', 'LiuLiangSheng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[18]', '[18]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (174, 18);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (175, '张冰强', 'ZhangBingQiang', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[18]', '[18]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (175, 18);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (176, '黄均华', 'HuangJunHua', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[18]', '[18]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (176, 18);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (177, '刘涛', 'LiuTao', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[18]', '[18]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (177, 18);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (178, '陈辰', 'ChenChen', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[18]', '[18]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (178, 18);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (179, '陈文媛', 'ChenWenYuan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[18]', '[18]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (179, 18);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (180, '刘佳', 'LiuJia', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[18]', '[18]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (180, 18);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (181, '刁芳妮', 'DiaoFangNi', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 15, '[18]', '[18]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (181, 18);
INSERT INTO Departments (D_Id, D_Name, D_Roles, D_Level, D_Remark, D_AddTime, D_Status) VALUES (19, '坭陂分局', '[19]', '0019', NULL, GETDATE(), 1);
INSERT INTO Roles (R_Id, R_Name, R_Permissions, R_PermissionCategories, R_Remark, R_AddTime, R_Status) VALUES (19, '坭陂分局', '[]', '[]', NULL, GETDATE(), 1);
INSERT INTO Department_Role (D_Id, R_Id) VALUES (19, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (182, '罗新峰', 'LuoXinFeng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 21, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (182, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (183, '罗尚东', 'LuoShangDong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 13, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (183, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (184, '刘国良', 'LiuGuoLiang', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 13, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (184, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (185, '黄宏清', 'HuangHongQing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, 8, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (185, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (186, '吴宝钦', 'WuBaoQin', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (186, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (187, '钟福星', 'ZhongFuXing', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (187, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (188, '廖亚文', 'LiaoYaWen', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (188, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (189, '何旺宏', 'HeWangHong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (189, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (190, '童小生', 'TongXiaoSheng', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (190, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (191, '张冰雄', 'ZhangBingXiong', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (191, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (192, '罗崇标', 'LuoChongBiao', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (192, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (193, '曾坤华', 'ZengKunHua', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (193, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (194, '曾慧瑶', 'ZengHuiYao', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (194, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (195, '毛思权', 'MaoSiQuan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (195, 19);
INSERT INTO Users (U_Id, U_Name, U_LoginName, U_Password, Du_Id, U_Departments, U_Roles, U_Remark, U_AddTime, U_Status) VALUES (196, '翁丽兰', 'WengLiLan', 'BC111B2A0E2ABDB0A74F698C45551DE7'/*xnsw201510*/, NULL, '[19]', '[19]', NULL, GETDATE(), 1);
INSERT INTO User_Department (U_Id, D_Id) VALUES (196, 19);

GO

------------------------------------------------------------------

-- 初始化权限数据
------------------------------------------------------------------

SET IDENTITY_INSERT [dbo].[PermissionCategories] ON

INSERT [dbo].[PermissionCategories] ([PC_Id], [PC_AutoId], [PC_Name], [PC_Level], [PC_Remark], [PC_AddTime], [PC_Status]) VALUES (1, 1, N'权限目录管理', N'0001', NULL, CAST(0x070083B6CC8AAB3A0B AS DateTime2), 1)
INSERT [dbo].[PermissionCategories] ([PC_Id], [PC_AutoId], [PC_Name], [PC_Level], [PC_Remark], [PC_AddTime], [PC_Status]) VALUES (2, 2, N'角色管理', N'0002', NULL, CAST(0x0700CC35DC8AAB3A0B AS DateTime2), 1)
INSERT [dbo].[PermissionCategories] ([PC_Id], [PC_AutoId], [PC_Name], [PC_Level], [PC_Remark], [PC_AddTime], [PC_Status]) VALUES (3, 3, N'部门管理', N'0003', NULL, CAST(0x0700E883EA8AAB3A0B AS DateTime2), 1)
INSERT [dbo].[PermissionCategories] ([PC_Id], [PC_AutoId], [PC_Name], [PC_Level], [PC_Remark], [PC_AddTime], [PC_Status]) VALUES (4, 4, N'职务管理', N'0004', NULL, CAST(0x07804008F78AAB3A0B AS DateTime2), 1)
INSERT [dbo].[PermissionCategories] ([PC_Id], [PC_AutoId], [PC_Name], [PC_Level], [PC_Remark], [PC_AddTime], [PC_Status]) VALUES (5, 5, N'用户管理', N'0005', NULL, CAST(0x07006C5B028BAB3A0B AS DateTime2), 1)
INSERT [dbo].[PermissionCategories] ([PC_Id], [PC_AutoId], [PC_Name], [PC_Level], [PC_Remark], [PC_AddTime], [PC_Status]) VALUES (6, 6, N'公共功能', N'0006', NULL, CAST(0x0780C4DF0E8BAB3A0B AS DateTime2), 1)
INSERT [dbo].[PermissionCategories] ([PC_Id], [PC_AutoId], [PC_Name], [PC_Level], [PC_Remark], [PC_AddTime], [PC_Status]) VALUES (7, 7, N'试题库管理', N'0007', NULL, CAST(0x078086CB1A8BAB3A0B AS DateTime2), 1)
INSERT [dbo].[PermissionCategories] ([PC_Id], [PC_AutoId], [PC_Name], [PC_Level], [PC_Remark], [PC_AddTime], [PC_Status]) VALUES (8, 8, N'考试任务模板管理', N'0008', NULL, CAST(0x078048B7268BAB3A0B AS DateTime2), 1)
INSERT [dbo].[PermissionCategories] ([PC_Id], [PC_AutoId], [PC_Name], [PC_Level], [PC_Remark], [PC_AddTime], [PC_Status]) VALUES (9, 9, N'考试任务管理', N'0009', NULL, CAST(0x0700FB9D358BAB3A0B AS DateTime2), 1)
INSERT [dbo].[PermissionCategories] ([PC_Id], [PC_AutoId], [PC_Name], [PC_Level], [PC_Remark], [PC_AddTime], [PC_Status]) VALUES (10, 10, N'试卷模板管理', N'0010', NULL, CAST(0x0700EABA428BAB3A0B AS DateTime2), 1)
INSERT [dbo].[PermissionCategories] ([PC_Id], [PC_AutoId], [PC_Name], [PC_Level], [PC_Remark], [PC_AddTime], [PC_Status]) VALUES (11, 11, N'考试功能', N'0011', NULL, CAST(0x0700EABA428BAB3A0B AS DateTime2), 1)

SET IDENTITY_INSERT [dbo].[PermissionCategories] OFF

SET IDENTITY_INSERT [dbo].[Permissions] ON

INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (1, 1, 1, N'权限目录列表', N'PermissionCategory', N'List', NULL, CAST(0x07E246B2D68AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (2, 2, 1, N'查询权限目录', N'PermissionCategory', N'ListDataTablesAjax', NULL, CAST(0x07E246B2D68AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (3, 3, 1, N'新建权限目录', N'PermissionCategory', N'Create', NULL, CAST(0x07E246B2D68AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (4, 4, 1, N'添加权限目录', N'PermissionCategory', N'Create', NULL, CAST(0x07E246B2D68AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (5, 5, 1, N'查看权限目录', N'PermissionCategory', N'Edit', NULL, CAST(0x07E246B2D68AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (6, 6, 1, N'修改权限目录', N'PermissionCategory', N'Edit', NULL, CAST(0x07E246B2D68AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (7, 7, 1, N'回收权限目录', N'PermissionCategory', N'Recycle', NULL, CAST(0x07E246B2D68AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (8, 8, 1, N'恢复权限目录', N'PermissionCategory', N'Resume', NULL, CAST(0x07E246B2D68AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (9, 9, 1, N'删除权限目录', N'PermissionCategory', N'Delete', NULL, CAST(0x07E246B2D68AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (10, 10, 2, N'角色列表', N'Role', N'List', NULL, CAST(0x073462D6E58AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (11, 11, 2, N'查询角色', N'Role', N'ListDataTablesAjax', NULL, CAST(0x073462D6E58AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (12, 12, 2, N'新建角色', N'Role', N'Create', NULL, CAST(0x073462D6E58AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (13, 13, 2, N'添加角色', N'Role', N'Create', NULL, CAST(0x073462D6E58AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (14, 14, 2, N'查看角色', N'Role', N'Edit', NULL, CAST(0x073462D6E58AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (15, 15, 2, N'修改角色', N'Role', N'Edit', NULL, CAST(0x073462D6E58AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (16, 16, 2, N'回收角色', N'Role', N'Recycle', NULL, CAST(0x073462D6E58AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (17, 17, 2, N'恢复角色', N'Role', N'Resume', NULL, CAST(0x073462D6E58AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (18, 18, 2, N'删除角色', N'Role', N'Delete', NULL, CAST(0x073462D6E58AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (19, 19, 3, N'部门列表', N'Department', N'List', NULL, CAST(0x072DB911F38AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (20, 20, 3, N'查询部门', N'Department', N'ListDataTablesAjax', NULL, CAST(0x072DB911F38AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (21, 21, 3, N'新建部门', N'Department', N'Create', NULL, CAST(0x072DB911F38AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (22, 22, 3, N'添加部门', N'Department', N'Create', NULL, CAST(0x072DB911F38AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (23, 23, 3, N'查看部门', N'Department', N'Edit', NULL, CAST(0x072DB911F38AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (24, 24, 3, N'修改部门', N'Department', N'Edit', NULL, CAST(0x072DB911F38AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (25, 25, 3, N'回收部门', N'Department', N'Recycle', NULL, CAST(0x072DB911F38AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (26, 26, 3, N'恢复部门', N'Department', N'Resume', NULL, CAST(0x072DB911F38AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (27, 27, 3, N'删除部门', N'Department', N'Delete', NULL, CAST(0x072DB911F38AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (28, 28, 4, N'职务列表', N'Duty', N'List', NULL, CAST(0x07DAFBDEFE8AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (29, 29, 4, N'查询职务', N'Duty', N'ListDataTablesAjax', NULL, CAST(0x07DAFBDEFE8AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (30, 30, 4, N'新建职务', N'Duty', N'Create', NULL, CAST(0x07DAFBDEFE8AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (31, 31, 4, N'添加职务', N'Duty', N'Create', NULL, CAST(0x07DAFBDEFE8AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (32, 32, 4, N'查看职务', N'Duty', N'Edit', NULL, CAST(0x07DAFBDEFE8AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (33, 33, 4, N'修改职务', N'Duty', N'Edit', NULL, CAST(0x07DAFBDEFE8AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (34, 34, 4, N'回收职务', N'Duty', N'Recycle', NULL, CAST(0x07DAFBDEFE8AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (35, 35, 4, N'恢复职务', N'Duty', N'Resume', NULL, CAST(0x07DAFBDEFE8AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (36, 36, 4, N'删除职务', N'Duty', N'Delete', NULL, CAST(0x07DAFBDEFE8AAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (37, 37, 5, N'用户列表', N'User', N'List', NULL, CAST(0x07B80986098BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (38, 38, 5, N'查询用户', N'User', N'ListDataTablesAjax', NULL, CAST(0x07B80986098BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (39, 39, 5, N'新建用户', N'User', N'Create', NULL, CAST(0x07B80986098BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (40, 40, 5, N'添加用户', N'User', N'Create', NULL, CAST(0x07B80986098BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (41, 41, 5, N'查看用户', N'User', N'Edit', NULL, CAST(0x07B80986098BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (42, 42, 5, N'编辑用户', N'User', N'Edit', NULL, CAST(0x07B80986098BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (43, 43, 5, N'回收用户', N'User', N'Recycle', NULL, CAST(0x07B80986098BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (44, 44, 5, N'恢复用户', N'User', N'Resume', NULL, CAST(0x07B80986098BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (45, 45, 5, N'删除用户', N'User', N'Delete', NULL, CAST(0x07B80986098BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (46, 46, 6, N'控制面板', N'Panel', N'Index', NULL, CAST(0x070B2037168BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (47, 47, 6, N'欢迎面板', N'Panel', N'Welcome', NULL, CAST(0x070B2037168BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (48, 48, 7, N'试题列表', N'Question', N'List', NULL, CAST(0x07A03E13238BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (49, 49, 7, N'查询试题', N'Question', N'ListDataTablesAjax', NULL, CAST(0x07A03E13238BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (50, 50, 7, N'试题上传', N'Question', N'DocxUploadAndImport', NULL, CAST(0x07A03E13238BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (51, 51, 7, N'试题导入', N'Question', N'Import', NULL, CAST(0x07A03E13238BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (52, 52, 7, N'新建试题', N'Question', N'Create', NULL, CAST(0x07A03E13238BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (53, 53, 7, N'添加试题', N'Question', N'Create', NULL, CAST(0x07A03E13238BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (54, 54, 7, N'查看试题', N'Question', N'Edit', NULL, CAST(0x07A03E13238BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (55, 55, 7, N'编辑试题', N'Question', N'Edit', NULL, CAST(0x07A03E13238BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (56, 56, 7, N'回收试题', N'Question', N'Recycle', NULL, CAST(0x07A03E13238BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (57, 57, 7, N'恢复试题', N'Question', N'Resume', NULL, CAST(0x07A03E13238BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (58, 58, 7, N'删除试题', N'Question', N'Delete', NULL, CAST(0x07A03E13238BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (59, 59, 7, N'设置难度系数', N'Question', N'SetDifficultyCoefficient', NULL, CAST(0x07A03E13238BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (60, 60, 8, N'考试任务模板列表', N'ExaminationTaskTemplate', N'List', NULL, CAST(0x07684D6C328BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (61, 61, 8, N'查询考试任务模板', N'ExaminationTaskTemplate', N'ListDataTablesAjax', NULL, CAST(0x07684D6C328BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (62, 62, 8, N'新建考试任务模板', N'ExaminationTaskTemplate', N'Create', NULL, CAST(0x07684D6C328BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (63, 63, 8, N'添加考试任务模板', N'ExaminationTaskTemplate', N'Create', NULL, CAST(0x07684D6C328BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (64, 64, 8, N'查看考试任务模板', N'ExaminationTaskTemplate', N'Edit', NULL, CAST(0x07684D6C328BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (65, 65, 8, N'修改考试任务模板', N'ExaminationTaskTemplate', N'Edit', NULL, CAST(0x07684D6C328BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (66, 66, 8, N'回收考试任务模板', N'ExaminationTaskTemplate', N'Recycle', NULL, CAST(0x07684D6C328BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (67, 67, 8, N'恢复考试任务模板', N'ExaminationTaskTemplate', N'Resume', NULL, CAST(0x07684D6C328BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (68, 68, 8, N'删除考试任务模板', N'ExaminationTaskTemplate', N'Delete', NULL, CAST(0x07684D6C328BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (69, 69, 9, N'考试任务列表', N'ExaminationTask', N'List', NULL, CAST(0x073E658D3F8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (70, 70, 9, N'查询考试任务', N'ExaminationTask', N'ListDataTablesAjax', NULL, CAST(0x073E658D3F8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (71, 71, 9, N'新建考试任务', N'ExaminationTask', N'Create', NULL, CAST(0x073E658D3F8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (72, 72, 9, N'添加考试任务', N'ExaminationTask', N'Create', NULL, CAST(0x073E658D3F8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (73, 73, 9, N'查看考试任务', N'ExaminationTask', N'Edit', NULL, CAST(0x073E658D3F8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (74, 74, 9, N'修改考试任务', N'ExaminationTask', N'Edit', NULL, CAST(0x073E658D3F8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (75, 75, 9, N'回收考试任务', N'ExaminationTask', N'Recycle', NULL, CAST(0x073E658D3F8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (76, 76, 9, N'恢复考试任务', N'ExaminationTask', N'Resume', NULL, CAST(0x073E658D3F8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (77, 77, 9, N'删除考试任务', N'ExaminationTask', N'Delete', NULL, CAST(0x073E658D3F8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (78, 78, 10, N'试卷模板列表，管理后台', N'ExaminationPaperTemplate', N'List', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (79, 79, 10, N'试卷模板列表，学员后台', N'ExaminationPaperTemplate', N'ListStudent', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (80, 80, 10, N'查询试卷模板，管理后台', N'ExaminationPaperTemplate', N'ListDataTablesAjax', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (81, 81, 10, N'查询试卷模板，学员后台', N'ExaminationPaperTemplate', N'ListDataTablesAjaxStudent', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (82, 82, 10, N'新建试卷模板', N'ExaminationPaperTemplate', N'Create', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (83, 83, 10, N'添加试卷模板', N'ExaminationPaperTemplate', N'Create', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (84, 84, 10, N'查看试卷模板', N'ExaminationPaperTemplate', N'Edit', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (85, 85, 10, N'修改试卷模板', N'ExaminationPaperTemplate', N'Edit', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (86, 86, 10, N'回收试卷模板', N'ExaminationPaperTemplate', N'Recycle', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (87, 87, 10, N'恢复试卷模板', N'ExaminationPaperTemplate', N'Resume', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (88, 88, 10, N'删除试卷模板', N'ExaminationPaperTemplate', N'Delete', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (89, 89, 6, N'修改密码', N'User', N'ModifyPassword', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (90, 90, 6, N'检查密码', N'User', N'CheckOldPassword', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (91,	91,	7, N'缓存导入', N'Question', N'CacheImport', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (92,	92,	7, N'缓存清除', N'Question', N'CacheClear', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (93,	93,	11, N'进入考试', N'ExaminationPaperTemplate', N'Paper', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (94,	94,	11, N'试卷', N'ExaminationPaper', N'Paper', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (95,	95,	11, N'获取试题', N'ExaminationPaper', N'GetQuestions', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (96,	96,	11, N'提交答案', N'ExaminationPaper', N'SubmitAnswers', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (97,	97,	5, N'检查用户名', N'User', N'DuplicateName', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (98,	98,	5, N'检查登录名', N'User', N'DuplicateLoginName', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (99, 99, 4, N'检查职务名称', N'Duty', N'DuplicateName', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (100, 100, 2, N'检查角色名称', N'Role', N'DuplicateName', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (101, 101, 1, N'检查权限目录名称', N'PermissionCategory', N'DuplicateName', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))
INSERT [dbo].[Permissions] ([P_Id], [P_AutoId], [PC_Id], [P_Name], [P_Controller], [P_Action], [P_Remark], [P_AddTime]) VALUES (102, 102, 3, N'检查部门名称', N'Department', N'DuplicateName', NULL, CAST(0x079DAEB04D8BAB3A0B AS DateTime2))

SET IDENTITY_INSERT [dbo].[Permissions] OFF

GO

INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 1)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 2)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 3)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 4)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 5)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 6)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 7)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 8)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 9)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 10)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 11)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 12)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 13)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 14)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 15)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 16)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 17)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 18)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 19)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 20)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 21)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 22)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 23)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 24)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 25)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 26)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 27)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 28)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 29)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 30)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 31)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 32)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 33)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 34)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 35)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 36)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 37)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 38)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 39)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 40)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 41)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 42)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 43)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 44)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 45)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 46)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 47)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 48)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 49)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 50)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 51)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 52)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 53)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 54)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 55)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 56)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 57)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 58)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 59)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 60)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 61)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 62)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 63)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 64)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 65)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 66)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 67)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 68)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 69)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 70)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 71)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 72)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 73)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 74)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 75)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 76)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 77)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 78)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 79)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 80)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 81)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 82)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 83)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 84)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 85)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 86)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 87)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 88)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 89)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 90)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 91)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 92)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 93)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 94)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 95)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 96)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 97)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 98)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 99)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 100)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 101)
INSERT [dbo].[Role_Permission] ([R_Id], [P_Id]) VALUES (1, 102)

UPDATE Roles SET 
R_Permissions = '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102]',
R_PermissionCategories = '[1,2,3,4,5,6,7,8,9,10,11]'
WHERE R_Id = 1

GO

------------------------------------------------------------------
