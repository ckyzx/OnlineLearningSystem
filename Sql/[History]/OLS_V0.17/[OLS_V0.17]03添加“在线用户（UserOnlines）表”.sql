USE OLS;

GO

IF EXISTS ( SELECT  1
            FROM    sysobjects
            WHERE   id = OBJECT_ID('UserOnlines')
                    AND type = 'U' ) 
    DROP TABLE UserOnlines
   
go

CREATE TABLE UserOnlines
    (
      UO_Id INT NOT NULL
                PRIMARY KEY
                IDENTITY(1, 1) ,
      U_Id INT NOT NULL ,
      UO_Name NVARCHAR(50) NOT NULL ,
      UO_IdCardNumber VARCHAR(20) NOT NULL ,
      UO_RefreshTime DATETIME2 NOT NULL
    )

GO
