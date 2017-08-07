USE PerfTests
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RecordResults]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[RecordResults]
GO

create procedure dbo.RecordResults
(
	 @url		varchar(80)
	,@results	nvarchar(MAX)
)
AS
	insert into	WebPageTestResults	(TestDtUtc,		ResultsURL,	TestResults)
	values							(getutcdate(),	@url,		@results)
GO

GRANT EXECUTE ON RecordResults TO public
GO
