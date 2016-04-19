USE OLS;

GO

IF EXISTS ( SELECT  1
            FROM    sys.sysreferences r
                    JOIN sys.sysobjects o ON ( o.id = r.constid
                                               AND o.type = 'F'
                                             )
            WHERE   r.fkeyid = OBJECT_ID('LearningDatas')
                    AND o.name = 'FK_LD_LDC' ) 
    ALTER TABLE LearningDatas
    DROP CONSTRAINT FK_LD_LDC

GO

IF EXISTS ( SELECT  1
            FROM    sys.sysobjects
            WHERE   id = OBJECT_ID('LearningDataCategories')
                    AND type = 'U' ) 
    DROP TABLE LearningDataCategories;

IF EXISTS ( SELECT  1
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID('LearningDatas')
                    AND type = 'U' ) 
    DROP TABLE LearningDatas
    
GO

/*==============================================================*/
/* Table: LearningDataCategories                                */
/*==============================================================*/
CREATE TABLE LearningDataCategories
    (
      LDC_Id INT NOT NULL ,
      LDC_AutoId INT IDENTITY ,
      LDC_Name VARCHAR(200) NOT NULL ,
      LDC_Remark VARCHAR(200) NULL ,
      LDC_AddTime DATETIME2 NOT NULL ,
      LDC_Status TINYINT NOT NULL,
      LDC_Sort FLOAT NOT NULL,
      CONSTRAINT PK_LEARNINGDATACLASSIFY PRIMARY KEY ( LDC_Id )
    )
GO

/*==============================================================*/
/* Table: LearningDatas                                         */
/*==============================================================*/
CREATE TABLE LearningDatas
    (
      LD_Id INT NOT NULL ,
      LD_AutoId INT IDENTITY ,
      LD_Title VARCHAR(200) NOT NULL ,
      LDC_Id INT NULL ,
      LD_Content TEXT NOT NULL ,
      LD_Remark VARCHAR(200) NULL ,
      LD_AddTime DATETIME2 NOT NULL ,
      LD_Status TINYINT NOT NULL,
      LD_Sort FLOAT NOT NULL,
      CONSTRAINT PK_LEARNINGDATAS PRIMARY KEY ( LD_Id )
    )
GO

ALTER TABLE LearningDatas
ADD CONSTRAINT FK_LD_LDC FOREIGN KEY (LDC_Id)
REFERENCES LearningDataCategories (LDC_Id)

GO