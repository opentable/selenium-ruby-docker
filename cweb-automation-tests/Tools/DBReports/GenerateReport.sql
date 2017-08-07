USE QCReporting
GO

/* */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GenerateReport]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GenerateReport]
GO

create procedure dbo.GenerateReport
	 @product		varchar(50)
	,@env			varchar(50)
	,@branch		varchar(50)
	,@testfolder	varchar(50)
AS
/* */
/*
delete from Report
DBCC CHECKIDENT ( Report, RESEED, 0)

declare	 @env			varchar(50)
		,@branch		varchar(50)
		,@testfolder	varchar(50)
set @env		= 'PreProd'
set @branch		= 'Web_12_8'
set @testfolder	= 'Basic Acceptance Tests'
*/
	set nocount on
	set transaction isolation level read uncommitted


	declare @CycleID as int, @TestID as int, @TestInstance as int, @ScenarioDesc as varchar(255), @QTPTestID as int, @path as varchar(200)
	declare @CucumberTesterName as varchar(50)
	set @CucumberTesterName = 'teamcity'
	set @path = '\Deployments\'+@branch+'\'+@env+'\%' -- Cucumber result data path


	-- ***************************************************************************
	-- * Aggregate all tests from Quality Center Test Plan into report temp table
	-- ***************************************************************************

	insert into	Report (SiteType, TestFolder, TestPath, DomainLanguage, Tier, TestID, Instance, QTPTestID, TestName, AutoOwner, AutoStatus)
	select		SiteType, @testfolder, TestPath, DomainLanguage, Tier, TestID, 1 /*Instance*/, QTPTestID, TestName, AutoOwner, AutoStatus
	from		fGetTestPlanTests(@testfolder, 'PreProd') -- 'PreProd' should really be @env, but then in QC we need 'WebRelease' as an environment (or overriding to "QA")


	-- ***************************************************************************
	-- * Update run-dependent fields: CycleID, ScenarioDesc
	-- ***************************************************************************
	update		Report
	set			CycleID = run.CycleID, ScenarioDesc = tc.TC_USER_02
	from
	(
 		select		distinct RN_CYCLE_ID 'CycleID', RN_TEST_ID 'TestID', RN_TEST_INSTANCE 'Instance', coalesce(cf1.CF_ITEM_NAME, '') 'Product',
					coalesce(cf2.CF_ITEM_NAME + '\', '') + coalesce(cf1.CF_ITEM_NAME + '\', '') + c.CY_CYCLE 'Path'
		from		default_sqa_web_db.td.RUN r
		inner join	default_sqa_web_db.td.TESTCYCL tc
		on			tc.TC_CYCLE_ID		= r.RN_CYCLE_ID
		and			tc.TC_TEST_ID		= r.RN_TEST_ID
		inner join	default_sqa_web_db.td.CYCLE c
		on			c.CY_CYCLE_ID		= r.RN_CYCLE_ID
		inner join	default_sqa_web_db.td.CYCL_FOLD cf1
		on			c.CY_FOLDER_ID		= cf1.CF_ITEM_ID
		left join	default_sqa_web_db.td.CYCL_FOLD cf2
		on			cf1.CF_FATHER_ID	= cf2.CF_ITEM_ID
		where		RN_CYCLE_ID in
		(
			select	CY_CYCLE_ID from default_sqa_web_db.td.fGetCyclePaths()
			where	Path like @path
		)
		and			RN_TEST_INSTANCE = 1
	) run
	inner join	default_sqa_web_db.td.TEST t
	on			t.TS_TEST_ID			= run.TestID
	inner join	DomainLanguageMap dlm
	on			dlm.LabTestSetCucumber	= run.Path
	inner join	default_sqa_web_db.td.TESTCYCL tc
	on			tc.TC_CYCLE_ID			= run.CycleID
	and			tc.TC_TEST_ID			= run.TestID
	and			tc.TC_TEST_INSTANCE		= run.Instance
	inner join	Report rpt
	on			rpt.SiteType			= dlm.SiteType
	and			rpt.DomainLanguage		= dlm.DomainLanguage
	and			rpt.TestID				= run.TestID
	and			rpt.Instance			= 1
	where		run.Product				= @product


	-- ***************************************************************************
	-- * Insert duplicate executions for each Cucumber test
	-- ***************************************************************************
	insert into	Report (SiteType,		TestFolder,		TestPath,		DomainLanguage,     
						Tier,			CycleID,		TestID,			Instance,		ScenarioDesc,
					    QTPTestID,		TestName,		AutoOwner,		AutoStatus)
	select			    rpt.SiteType,	rpt.TestFolder,	rpt.TestPath,	rpt.DomainLanguage,
						rpt.Tier,		run.CycleID,	rpt.TestID,		run.Instance,	tc.TC_USER_02 /*ScenarioDesc*/,
						rpt.QTPTestID,	rpt.TestName,	rpt.AutoOwner,	rpt.AutoStatus
	from
	(
 		select		distinct RN_CYCLE_ID 'CycleID', RN_TEST_ID 'TestID', RN_TEST_INSTANCE 'Instance', coalesce(cf1.CF_ITEM_NAME, '') 'Product',
					coalesce(cf2.CF_ITEM_NAME + '\', '') + coalesce(cf1.CF_ITEM_NAME + '\', '') + c.CY_CYCLE 'Path'
		from		default_sqa_web_db.td.RUN r
		inner join	default_sqa_web_db.td.TESTCYCL tc
		on			tc.TC_CYCLE_ID		= r.RN_CYCLE_ID
		and			tc.TC_TEST_ID		= r.RN_TEST_ID
		inner join	default_sqa_web_db.td.CYCLE c
		on			c.CY_CYCLE_ID		= r.RN_CYCLE_ID
		inner join	default_sqa_web_db.td.CYCL_FOLD cf1
		on			c.CY_FOLDER_ID		= cf1.CF_ITEM_ID
		left join	default_sqa_web_db.td.CYCL_FOLD cf2
		on			cf1.CF_FATHER_ID	= cf2.CF_ITEM_ID
		where		RN_CYCLE_ID in
		(
			select	CY_CYCLE_ID from default_sqa_web_db.td.fGetCyclePaths()
			where	Path like @path
		)
		and			RN_TEST_INSTANCE > 1
	) run
	inner join	default_sqa_web_db.td.TEST t
	on			t.TS_TEST_ID			= run.TestID
	inner join	DomainLanguageMap dlm
	on			dlm.LabTestSetCucumber	= run.Path
	inner join	default_sqa_web_db.td.TESTCYCL tc
	on			tc.TC_CYCLE_ID			= run.CycleID
	and			tc.TC_TEST_ID			= run.TestID
	and			tc.TC_TEST_INSTANCE		= run.Instance
	inner join	Report rpt
	on			rpt.SiteType			= dlm.SiteType
	and			rpt.DomainLanguage		= dlm.DomainLanguage
	and			rpt.TestID				= run.TestID
	and			rpt.Instance			= 1
	where		run.Product				= @product


	-- ***************************************************************************
	-- * Get last 5 Cucumber test results for the branch/environment from Test Lab
	-- ***************************************************************************

	create table #Results (
		 CycleID		int
		,TestID			int
		,Instance		int
		,PreviousRun1	int
		,PreviousRun2	int
		,PreviousRun3	int
		,PreviousRun4	int
		,PreviousRun5	int
	)


	-- ***************************************************************************
	-- * Iterate over all tests so we can get the last 5 results for each Cucumber test
	-- ***************************************************************************

	-- Clear results temp table
	truncate table #Results

	declare AllTestsCuc cursor for
		select distinct RN_CYCLE_ID 'CycleID', RN_TEST_ID 'TestID', RN_TEST_INSTANCE 'TestInstance'
		from		default_sqa_web_db.td.RUN
		where RN_CYCLE_ID in
		(
			select CY_CYCLE_ID from default_sqa_web_db.td.fGetCyclePaths()
			where Path like @path
		)

	open AllTestsCuc
	fetch next from AllTestsCuc INTO @CycleID, @TestID, @TestInstance

	while @@FETCH_STATUS = 0
	begin
		select		top 5 identity(int, 1, 1) as ID, RN_RUN_ID
		into		#CucRuns
		from		default_sqa_web_db.td.RUN
		where		RN_CYCLE_ID			= @CycleID
		and			RN_TEST_ID			= @TestID
		and			RN_TEST_INSTANCE	= @TestInstance
		and			coalesce(RN_TESTER_NAME, '')	= @CucumberTesterName
		order by	RN_RUN_ID desc
		
		insert into #Results
		select		 @CycleID		as 'CycleID'
					,@TestID		as 'TestID'
					,@TestInstance	as 'Instance'
					,[1]			as 'PreviousRun1'
					,[2]			as 'PreviousRun2'
					,[3]			as 'PreviousRun3'
					,[4]			as 'PreviousRun4'
					,[5]			as 'PreviousRun5'
		from		#CucRuns t
		pivot		( max(RN_RUN_ID) for ID in ([1], [2], [3], [4], [5]) ) as pivottable

		drop table #CucRuns
		--print 'Done with CycleID ' + cast(@CycleID as varchar(50)) + ', TestID ' + cast(@TestID as varchar(50)) + '...'

		fetch next from AllTestsCuc INTO @CycleID, @TestID, @TestInstance
	end

	close AllTestsCuc
	deallocate AllTestsCuc


	-- ***************************************************************************
	-- * Update report temp table with Cucumber data
	-- ***************************************************************************

-- Insert new Report record for Instance when it doesn't exist, then update it

	update		Report
	set			 CucExecDate1	= y.CucExecDate1
				,CucExecStatus1	= y.CucExecStatus1
				,CucExecHost1	= y.CucExecHost1
				,CucExecDate2	= y.CucExecDate2
				,CucExecStatus2	= y.CucExecStatus2
				,CucExecHost2	= y.CucExecHost2
				,CucExecDate3	= y.CucExecDate3
				,CucExecStatus3	= y.CucExecStatus3
				,CucExecHost3	= y.CucExecHost3
				,CucExecDate4	= y.CucExecDate4
				,CucExecStatus4	= y.CucExecStatus4
				,CucExecHost4	= y.CucExecHost4
				,CucExecDate5	= y.CucExecDate5
				,CucExecStatus5	= y.CucExecStatus5
				,CucExecHost5	= y.CucExecHost5
	from		Report r
	inner join	(
			select		 dlm.DomainLanguage
						,dlm.Tier
						,x.TestID
						,x.Instance
						,x.CucExecDate1
						,x.CucExecStatus1
						,x.CucExecHost1
						,x.CucExecDate2
						,x.CucExecStatus2
						,x.CucExecHost2
						,x.CucExecDate3
						,x.CucExecStatus3
						,x.CucExecHost3
						,x.CucExecDate4
						,x.CucExecStatus4
						,x.CucExecHost4
						,x.CucExecDate5
						,x.CucExecStatus5
						,x.CucExecHost5
			from		(
					select		 res.CycleID
								,res.TestID
								,res.Instance
								,cp.Path
								,substring(cp.Path, len(@path), 100)	'TestPath'
								,t.TS_NAME								'TestName'
								,r1.RN_EXECUTION_DATE + cast(r1.RN_EXECUTION_TIME as datetime)	as 'CucExecDate1'
								,r1.RN_STATUS													as 'CucExecStatus1'
								,r1.RN_HOST														as 'CucExecHost1'
								,r2.RN_EXECUTION_DATE + cast(r2.RN_EXECUTION_TIME as datetime)	as 'CucExecDate2'
								,r2.RN_STATUS													as 'CucExecStatus2'
								,r2.RN_HOST														as 'CucExecHost2'
								,r3.RN_EXECUTION_DATE + cast(r3.RN_EXECUTION_TIME as datetime)	as 'CucExecDate3'
								,r3.RN_STATUS													as 'CucExecStatus3'
								,r3.RN_HOST														as 'CucExecHost3'
								,r4.RN_EXECUTION_DATE + cast(r4.RN_EXECUTION_TIME as datetime)	as 'CucExecDate4'
								,r4.RN_STATUS													as 'CucExecStatus4'
								,r4.RN_HOST														as 'CucExecHost4'
								,r5.RN_EXECUTION_DATE + cast(r5.RN_EXECUTION_TIME as datetime)	as 'CucExecDate5'
								,r5.RN_STATUS													as 'CucExecStatus5'
								,r5.RN_HOST														as 'CucExecHost5'
					from		#Results res
					inner join	default_sqa_web_db.td.TESTCYCL tc
					on			tc.TC_CYCLE_ID		= res.CycleID
					and			tc.TC_TEST_ID		= res.TestID
					inner join	default_sqa_web_db.td.TEST t
					on			t.TS_TEST_ID		= tc.TC_TEST_ID
					inner join	default_sqa_web_db.td.fGetCyclePaths() cp
					on			cp.CY_CYCLE_ID		= res.CycleID
					left join	default_sqa_web_db.td.RUN r1
					on			r1.RN_RUN_ID		= res.PreviousRun1
					left join	default_sqa_web_db.td.RUN r2
					on			r2.RN_RUN_ID		= res.PreviousRun2
					left join	default_sqa_web_db.td.RUN r3
					on			r3.RN_RUN_ID		= res.PreviousRun3
					left join	default_sqa_web_db.td.RUN r4
					on			r4.RN_RUN_ID		= res.PreviousRun4
					left join	default_sqa_web_db.td.RUN r5
					on			r5.RN_RUN_ID		= res.PreviousRun5
			) x
			left join	DomainLanguageMap dlm
			on			dlm.LabTestSetCucumber	= x.TestPath
	) y
	on		y.DomainLanguage	= r.DomainLanguage
	and		y.Tier				= r.Tier
	and		y.TestID			= r.TestID
	and		y.Instance			= r.Instance


	-- ***************************************************************************
	-- * Iterate over all tests so we can get the last 5 results for each Manual test
	-- ***************************************************************************

	-- Clear results temp table
	truncate table #Results

	declare AllTestsMan cursor for
		select distinct RN_CYCLE_ID 'CycleID', RN_TEST_ID 'TestID', RN_TEST_INSTANCE 'TestInstance'
		from default_sqa_web_db.td.RUN
		where RN_CYCLE_ID in
		(
			select CY_CYCLE_ID from default_sqa_web_db.td.fGetCyclePaths()
			where Path like @path
		)

	open AllTestsMan
	fetch next from AllTestsMan INTO @CycleID, @TestID, @TestInstance

	-- Iterate over all tests so we can get the last 5 results for each test
	while @@FETCH_STATUS = 0
	begin
		select		top 5 identity(int, 1, 1) as ID, RN_RUN_ID
		into		#ManRuns
		from		default_sqa_web_db.td.RUN
		where		RN_CYCLE_ID			= @CycleID
		and			RN_TEST_ID			= @TestID
		and			RN_TEST_INSTANCE	= @TestInstance
		and			coalesce(RN_TESTER_NAME, '')	!= @CucumberTesterName
		order by	RN_RUN_ID desc
		
		insert into #Results
		select		 @CycleID		as 'CycleID'
					,@TestID		as 'TestID'
					,@TestInstance	as 'Instance'
					,[1]			as 'PreviousRun1'
					,[2]			as 'PreviousRun2'
					,[3]			as 'PreviousRun3'
					,[4]			as 'PreviousRun4'
					,[5]			as 'PreviousRun5'
		from		#ManRuns t
		pivot		( max(RN_RUN_ID) for ID in ([1], [2], [3], [4], [5]) ) as pivottable

		drop table #ManRuns
		--print 'Done with CycleID ' + cast(@CycleID as varchar(50)) + ', TestID ' + cast(@TestID as varchar(50)) + '...'

		fetch next from AllTestsMan INTO @CycleID, @TestID, @TestInstance
	end

	close AllTestsMan
	deallocate AllTestsMan


	-- ***************************************************************************
	-- * Update report temp table with Manual tester data data
	-- ***************************************************************************

	update		Report
	set			 ManExecDate1	= y.ManExecDate1
				,ManExecStatus1	= y.ManExecStatus1
				,ManExecHost1	= y.ManExecHost1
	from		Report r
	inner join	(
			select		 dlm.DomainLanguage
						,dlm.Tier
						,x.TestID
						,x.Instance
						,x.ManExecDate1
						,x.ManExecStatus1
						,x.ManExecHost1
			from		(
					select		 res.CycleID
								,res.TestID
								,res.Instance
								,cp.Path
								,substring(cp.Path, len(@path), 100)	'TestPath'
								,t.TS_NAME								'TestName'
								,r1.RN_EXECUTION_DATE + cast(r1.RN_EXECUTION_TIME as datetime)	as 'ManExecDate1'
								,r1.RN_STATUS													as 'ManExecStatus1'
								,r1.RN_HOST														as 'ManExecHost1'
					from		#Results res
					inner join	default_sqa_web_db.td.TESTCYCL tc
					on			tc.TC_CYCLE_ID		= res.CycleID
					and			tc.TC_TEST_ID		= res.TestID
					inner join	default_sqa_web_db.td.TEST t
					on			t.TS_TEST_ID		= tc.TC_TEST_ID
					inner join	default_sqa_web_db.td.fGetCyclePaths() cp
					on			cp.CY_CYCLE_ID		= res.CycleID
					left join	default_sqa_web_db.td.RUN r1
					on			r1.RN_RUN_ID		= res.PreviousRun1
			) x
			left join	DomainLanguageMap dlm
			on			dlm.LabTestSetCucumber	= x.TestPath
	) y
	on		y.DomainLanguage	= r.DomainLanguage
	and		y.Tier				= r.Tier
	and		y.TestID			= r.TestID
	and		y.Instance			= r.Instance


	-- ***************************************************************************
	-- * Update report temp table with QTP data
	-- ***************************************************************************

	-- Clear results temp table
	truncate table #Results

	-- QTP result data path
	set @path = '\Automation\PreProd\Web\%'

	declare AllTestsQTP cursor for
		select distinct RN_CYCLE_ID 'CycleID', RN_TEST_ID 'TestID', RN_TEST_INSTANCE 'TestInstance'
		from default_sqa_web_db.td.RUN
		where RN_CYCLE_ID in
		(
			select CY_CYCLE_ID from default_sqa_web_db.td.fGetCyclePaths()
			where Path like @path
		)
		
	open AllTestsQTP
	fetch next from AllTestsQTP INTO @CycleID, @TestID, @TestInstance

	-- Iterate over all tests so we can get the last 5 results for each test
	while @@FETCH_STATUS = 0
	begin
		select		top 5 identity(int, 1, 1) as ID, RN_RUN_ID
		into		#CucRuns2
		from		default_sqa_web_db.td.RUN
		where		RN_CYCLE_ID			= @CycleID
		and			RN_TEST_ID			= @TestID
		and			RN_TEST_INSTANCE	= @TestInstance
		order by	RN_RUN_ID desc
		
		insert into #Results
		select		 @CycleID		as 'CycleID'
					,@TestID		as 'TestID'
					,@TestInstance	as 'Instance'
					,[1]			as 'PreviousRun1'
					,[2]			as 'PreviousRun2'
					,[3]			as 'PreviousRun3'
					,[4]			as 'PreviousRun4'
					,[5]			as 'PreviousRun5'
		from		#CucRuns2 t
		pivot		( max(RN_RUN_ID) for ID in ([1], [2], [3], [4], [5]) ) as pivottable

		drop table #CucRuns2
		--print 'Done with CycleID ' + cast(@CycleID as varchar(50)) + ', TestID ' + cast(@TestID as varchar(50)) + '...'

		fetch next from AllTestsQTP INTO @CycleID, @TestID, @TestInstance
	end

	close AllTestsQTP
	deallocate AllTestsQTP


	update		Report
	set			 QTPExecDate1	= y.QTPExecDate1
				,QTPExecStatus1	= y.QTPExecStatus1
				,QTPExecHost1	= y.QTPExecHost1
				,QTPExecDate2	= y.QTPExecDate2
				,QTPExecStatus2	= y.QTPExecStatus2
				,QTPExecHost2	= y.QTPExecHost2
				,QTPExecDate3	= y.QTPExecDate3
				,QTPExecStatus3	= y.QTPExecStatus3
				,QTPExecHost3	= y.QTPExecHost3
				,QTPExecDate4	= y.QTPExecDate4
				,QTPExecStatus4	= y.QTPExecStatus4
				,QTPExecHost4	= y.QTPExecHost4
				,QTPExecDate5	= y.QTPExecDate5
				,QTPExecStatus5	= y.QTPExecStatus5
				,QTPExecHost5	= y.QTPExecHost5
	from		Report r
	inner join	(
			select		 dlm.DomainLanguage
						,dlm.Tier
						,x.TestID
						,x.Instance
						,x.QTPExecDate1
						,x.QTPExecStatus1
						,x.QTPExecHost1
						,x.QTPExecDate2
						,x.QTPExecStatus2
						,x.QTPExecHost2
						,x.QTPExecDate3
						,x.QTPExecStatus3
						,x.QTPExecHost3
						,x.QTPExecDate4
						,x.QTPExecStatus4
						,x.QTPExecHost4
						,x.QTPExecDate5
						,x.QTPExecStatus5	
						,x.QTPExecHost5
			from		(
					select		 res.CycleID
								,res.TestID
								,res.Instance
								,cp.Path
								,substring(cp.Path, len(@path), 100)	'TestPath'
								,t.TS_NAME								'TestName'
								,r1.RN_EXECUTION_DATE + cast(r1.RN_EXECUTION_TIME as datetime)	as 'QTPExecDate1'
								,r1.RN_STATUS													as 'QTPExecStatus1'
								,r1.RN_HOST														as 'QTPExecHost1'
								,r2.RN_EXECUTION_DATE + cast(r2.RN_EXECUTION_TIME as datetime)	as 'QTPExecDate2'
								,r2.RN_STATUS													as 'QTPExecStatus2'
								,r2.RN_HOST														as 'QTPExecHost2'
								,r3.RN_EXECUTION_DATE + cast(r3.RN_EXECUTION_TIME as datetime)	as 'QTPExecDate3'
								,r3.RN_STATUS													as 'QTPExecStatus3'
								,r3.RN_HOST														as 'QTPExecHost3'
								,r4.RN_EXECUTION_DATE + cast(r4.RN_EXECUTION_TIME as datetime)	as 'QTPExecDate4'
								,r4.RN_STATUS													as 'QTPExecStatus4'
								,r4.RN_HOST														as 'QTPExecHost4'
								,r5.RN_EXECUTION_DATE + cast(r5.RN_EXECUTION_TIME as datetime)	as 'QTPExecDate5'
								,r5.RN_STATUS													as 'QTPExecStatus5'
								,r5.RN_HOST														as 'QTPExecHost5'
					from		#Results res
					inner join	default_sqa_web_db.td.TESTCYCL tc
					on			tc.TC_CYCLE_ID	= res.CycleID
					and			tc.TC_TEST_ID	= res.TestID
					inner join	default_sqa_web_db.td.TEST t
					on			t.TS_TEST_ID	= tc.TC_TEST_ID
					inner join	default_sqa_web_db.td.fGetCyclePaths() cp
					on			cp.CY_CYCLE_ID	= res.CycleID
					left join	default_sqa_web_db.td.RUN r1
					on			r1.RN_RUN_ID	= res.PreviousRun1
					left join	default_sqa_web_db.td.RUN r2
					on			r2.RN_RUN_ID	= res.PreviousRun2
					left join	default_sqa_web_db.td.RUN r3
					on			r3.RN_RUN_ID	= res.PreviousRun3
					left join	default_sqa_web_db.td.RUN r4
					on			r4.RN_RUN_ID	= res.PreviousRun4
					left join	default_sqa_web_db.td.RUN r5
					on			r5.RN_RUN_ID	= res.PreviousRun5
			) x
			left join	DomainLanguageMap dlm
			on			dlm.LabTestSetQTP	= x.TestPath
	--		order by	x.Path
	) y
	on		y.DomainLanguage	= r.DomainLanguage
	and		y.Tier				= r.Tier
	and		y.TestID			= r.QTPTestID
	and		y.Instance			= r.Instance



	-- ***************************************************************************
	-- * Cleanup
	-- ***************************************************************************
	drop table #Results
/* */
GO

GRANT EXECUTE ON [GenerateReport] TO public
GO
/* */
/*
select count(*) from Report
*/
