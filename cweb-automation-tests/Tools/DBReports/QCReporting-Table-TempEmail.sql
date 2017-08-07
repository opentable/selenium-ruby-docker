USE QCReporting
GO

-- ***************************************************************************
-- * Create TempEmail table (drop if it doesn't exist)
-- ***************************************************************************
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempEmail]'))
drop table TempEmail
GO

CREATE TABLE dbo.TempEmail (
	 ID					int identity (1,1)
	,[Domain/Language]	varchar(15)
	,Site				varchar(10)
	,Test				varchar(255)
	,LastRun			datetime
	,ScenarioNumber		int null
)

GO

GRANT SELECT,INSERT,DELETE ON [TempEmail] TO public
GO

GRANT SELECT,INSERT,DELETE ON [TempEmail] TO QCReportingRead
GO
