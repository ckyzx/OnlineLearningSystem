USE OLS;

GO

IF OBJECT_ID(N'dbo.GetUserScoreDetail', 'TF') IS NOT NULL 
    DROP FUNCTION dbo.GetUserScoreDetail;
GO

CREATE FUNCTION dbo.GetUserScoreDetail ( @uId INT )
RETURNS @table TABLE
    (
      USD_TaskName NVARCHAR(50) NOT NULL ,
      USD_TaskTime DATETIME2 NOT NULL ,
      USD_IfAttendee BIT NOT NULL ,
      USD_Score INT NOT NULL ,
      USD_state TINYINT NOT NULL
    )
AS 
    BEGIN

        RETURN;
    END