USE PerfTests
GO

-- ***************************************************************************
-- * Create WebPageTestResults table (only if it doesn't exist)
-- ***************************************************************************
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebPageTestResults]'))

CREATE TABLE dbo.WebPageTestResults (
	 ID				int				identity (1,1)
	,TestDtUtc		datetime		not null
	,ResultsURL		varchar(80)		not null
	,TestResults	nvarchar(max)	not null
)

GO
