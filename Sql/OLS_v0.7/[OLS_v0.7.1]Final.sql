USE OLS;

GO

if object_id(N'SystemLogs',N'U') is not NULL
	DROP TABLE SystemLogs

GO

CREATE TABLE SystemLogs
    (
      SL_Id INT identity ,
      SL_Name VARCHAR(500) NOT NULL ,
      SL_Type TINYINT NOT NULL ,
      SL_Content TEXT NOT NULL ,
      SL_Remark VARCHAR(500) NULL ,
      SL_Status TINYINT NOT NULL ,
      SL_AddTime DATETIME2 NOT NULL ,
      CONSTRAINT PK_SYSTEMLOGS PRIMARY KEY ( SL_Id )
    )

GO
