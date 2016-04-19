USE OLS;

GO

IF OBJECT_ID(N'dbo.UserScoreSummaries', 'V') IS NOT NULL
	DROP VIEW dbo.UserScoreSummaries;
GO

CREATE VIEW dbo.UserScoreSummaries
AS
SELECT * FROM dbo.fn_GetUserScoreSummary()

GO

IF OBJECT_ID(N'dbo.UserScoreDetails', 'V') IS NOT NULL
	DROP VIEW dbo.UserScoreDetails;
GO

CREATE VIEW dbo.UserScoreDetails
AS
SELECT * FROM dbo.fn_GetUserScoreDetail()

GO