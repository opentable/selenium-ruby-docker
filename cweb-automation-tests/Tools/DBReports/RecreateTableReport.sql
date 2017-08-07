USE QCReporting
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RecreateTableReport]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[RecreateTableReport]
GO

create procedure dbo.RecreateTableReport
AS
	-- ***************************************************************************
	-- * Drop Report table (only if it doesn't exist)
	-- ***************************************************************************
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Report]'))
	drop table dbo.Report

	-- ***************************************************************************
	-- * Creat Report table again
	-- ***************************************************************************
	CREATE TABLE dbo.Report (
		 ID				int identity (1,1)
		,SiteType		varchar(100)
		,TestFolder		varchar(100)
		,TestPath		varchar(200)
		,TestName		varchar(200)
		,DomainLanguage	varchar(100)
		,Tier			int
		,AutoOwner		varchar(100)
		,AutoStatus		varchar(100)
		,TestID			int
		,CycleID		int
		,Instance		int
		,ScenarioDesc	varchar(255)
		,QTPTestID		int
		,ManExecDate1	datetime		null
		,ManExecStatus1	varchar(100)	null
		,ManExecHost1	varchar(40)		null
		,CucExecDate1	datetime		null
		,CucExecStatus1	varchar(100)	null
		,CucExecHost1	varchar(40)		null
		,CucExecDate2	datetime		null
		,CucExecStatus2	varchar(100)	null
		,CucExecHost2	varchar(40)		null
		,CucExecDate3	datetime		null
		,CucExecStatus3	varchar(100)	null
		,CucExecHost3	varchar(40)		null
		,CucExecDate4	datetime		null
		,CucExecStatus4	varchar(100)	null
		,CucExecHost4	varchar(40)		null
		,CucExecDate5	datetime		null
		,CucExecStatus5	varchar(100)	null
		,CucExecHost5	varchar(40)		null
		,QTPExecDate1	datetime		null
		,QTPExecStatus1	varchar(100)	null
		,QTPExecHost1	varchar(40)		null
		,QTPExecDate2	datetime		null
		,QTPExecStatus2	varchar(100)	null
		,QTPExecHost2	varchar(40)		null
		,QTPExecDate3	datetime		null
		,QTPExecStatus3	varchar(100)	null
		,QTPExecHost3	varchar(40)		null
		,QTPExecDate4	datetime		null
		,QTPExecStatus4	varchar(100)	null
		,QTPExecHost4	varchar(40)		null
		,QTPExecDate5	datetime		null
		,QTPExecStatus5	varchar(100)	null
		,QTPExecHost5	varchar(40)		null
	)
GO

GRANT EXECUTE ON [RecreateTableReport] TO public
GO
