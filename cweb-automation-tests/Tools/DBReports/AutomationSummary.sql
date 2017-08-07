use QCReporting
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AutomationSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AutomationSummary]
GO

create procedure dbo.AutomationSummary
	 @env				varchar(100)	= 'PreProd'
	,@persistentonly	bit				= 0
	,@rv				varchar(MAX) OUTPUT
AS

	set nocount on
	set transaction isolation level read uncommitted

	declare @count as int
	declare @title as varchar(MAX)
	declare @html as varchar(MAX)
	set @rv = ''

	set @rv = @rv + '<style>
					summary { cursor: pointer; font: bold 1.2em Arial, Helvetica, sans-serif; padding: -30px 0; position: relative; width: 100%; float: right }
					summary::-webkit-details-marker { display: none }
					summary:after { background: red; border-radius: 5px; content: "+"; color: #fff; float: right; font-size: 1.5em;
									font-weight: bold; text-align: center; margin: -50px 30px 0 0; padding: 0; width: 40px; }
					details[open] summary:after { content: "–"; }
					</style>'

	delete from TempEmail

	-- Tier 0, Not Automated --

	insert		TempEmail
	select		DomainLanguage 'Domain/Language', SiteType 'Site', TestPath 'Test', CucExecDate1 'LastRun', null 'ScenarioNumber'
	from		ReportView rv
	inner join	Domain d
	on			d.Domain = rv.DomainLanguage
	where		Environment		= @env
	and			Tier			= 0
	and			CucExecDate1	is null
	order by	d.SortOrder, rv.SiteType, rv.TestPath, rv.CucExecDate1

	exec GetTempEmailAsHTML 'Tier 0 (all sites) - Not Automated', @html OUTPUT
	set @rv = @rv + @html
	delete from TempEmail

	if @persistentonly = 1
	begin
		set @rv = @rv + '<h4>These are persistent failures - only the cases that have failed the last 5 times they ran.</h4>'
	end

	-- Tier 0, Not Passing --

	insert		TempEmail
	select		DomainLanguage 'Domain/Language', SiteType 'Site', TestPath 'Test', CucExecDate1 'LastRun', Instance 'ScenarioNumber'
	from		ReportView rv
	inner join	Domain d
	on			d.Domain = rv.DomainLanguage
	where		Environment		= @env
	and			Tier			= 0
	and			SiteType		= 'Consumer'
	and			((CucExecStatus1	!= 'Passed' and @persistentonly <> 1)
		or		 ((CucExecStatus1	= 'Failed' and @persistentonly = 1)
		and		  (CucExecStatus2	= 'Failed' and @persistentonly = 1)
		and		  (CucExecStatus3	= 'Failed' and @persistentonly = 1)
		and		  (CucExecStatus4	= 'Failed' and @persistentonly = 1)
		and		  (CucExecStatus5	= 'Failed' and @persistentonly = 1)))
	order by	d.SortOrder, rv.SiteType, rv.TestPath, rv.CucExecDate1
	
	exec GetTempEmailAsHTML 'Tier 0 (all sites) - Automated, Not Passing, Consumer', @html OUTPUT
	set @rv = @rv + @html
	delete from TempEmail

	insert		TempEmail
	select		DomainLanguage 'Domain/Language', SiteType 'Site', TestPath 'Test', CucExecDate1 'LastRun', Instance 'ScenarioNumber'
	from		ReportView rv
	inner join	Domain d
	on			d.Domain = rv.DomainLanguage
	where		Environment		= @env
	and			Tier			= 0
	and			SiteType		= 'MobileSite'
	and			((CucExecStatus1	!= 'Passed' and @persistentonly <> 1)
		or		 ((CucExecStatus1	= 'Failed' and @persistentonly = 1)
		and		  (CucExecStatus2	= 'Failed' and @persistentonly = 1)
		and		  (CucExecStatus3	= 'Failed' and @persistentonly = 1)
		and		  (CucExecStatus4	= 'Failed' and @persistentonly = 1)
		and		  (CucExecStatus5	= 'Failed' and @persistentonly = 1)))
	order by	d.SortOrder, rv.SiteType, rv.TestPath, rv.CucExecDate1
	
	exec GetTempEmailAsHTML 'Tier 0 (all sites) - Automated, Not Passing, MobileSite', @html OUTPUT
	set @rv = @rv + @html
	delete from TempEmail

	insert		TempEmail
	select		DomainLanguage 'Domain/Language', SiteType 'Site', TestPath 'Test', CucExecDate1 'LastRun', Instance 'ScenarioNumber'
	from		ReportView rv
	inner join	Domain d
	on			d.Domain = rv.DomainLanguage
	where		Environment		= @env
	and			Tier			= 0
	and			SiteType		= 'CHARM'
	and			((CucExecStatus1	!= 'Passed' and @persistentonly <> 1)
		or		 ((CucExecStatus1	= 'Failed' and @persistentonly = 1)
		and		  (CucExecStatus2	= 'Failed' and @persistentonly = 1)
		and		  (CucExecStatus3	= 'Failed' and @persistentonly = 1)
		and		  (CucExecStatus4	= 'Failed' and @persistentonly = 1)
		and		  (CucExecStatus5	= 'Failed' and @persistentonly = 1)))
	order by	d.SortOrder, rv.SiteType, rv.TestPath, rv.CucExecDate1
	
	exec GetTempEmailAsHTML 'Tier 0 (all sites) - Automated, Not Passing, CHARM', @html OUTPUT
	set @rv = @rv + @html
	delete from TempEmail

	if @persistentonly = 1
		return

	-- Tier 1, Not Automated --

	insert		TempEmail
	select		DomainLanguage 'Domain/Language', SiteType 'Site', TestPath 'Test', CucExecDate1 'LastRun', null 'ScenarioNumber'
	from		ReportView rv
	inner join	Domain d
	on			d.Domain = rv.DomainLanguage
	where		Environment		= @env
	and			SiteType		= 'MobileSite'
	and			Tier			= 1
	and			CucExecDate1	is null
	order by	d.SortOrder, rv.SiteType, rv.TestPath, rv.CucExecDate1

	exec GetTempEmailAsHTML 'Tier 1, Mobile - Not Automated', @html OUTPUT
	set @rv = @rv + @html
	delete from TempEmail

	insert		TempEmail
	select		DomainLanguage 'Domain/Language', SiteType 'Site', TestPath 'Test', CucExecDate1 'LastRun', null 'ScenarioNumber'
	from		ReportView rv
	inner join	Domain d
	on			d.Domain = rv.DomainLanguage
	where		Environment		= @env
	and			SiteType		= 'Consumer'
	and			Tier			= 1
	and			CucExecDate1	is null
	order by	d.SortOrder, rv.SiteType, rv.TestPath, rv.CucExecDate1

	exec GetTempEmailAsHTML 'Tier 1, Consumer - Not Automated', @html OUTPUT
	set @rv = @rv + @html
	delete from TempEmail

	insert		TempEmail
	select		DomainLanguage 'Domain/Language', SiteType 'Site', TestPath 'Test', CucExecDate1 'LastRun', null 'ScenarioNumber'
	from		ReportView rv
	inner join	Domain d
	on			d.Domain = rv.DomainLanguage
	where		Environment		= @env
	and			SiteType		= 'CHARM'
	and			Tier			= 1
	and			CucExecDate1	is null
	order by	d.SortOrder, rv.SiteType, rv.TestPath, rv.CucExecDate1

	exec GetTempEmailAsHTML 'Tier 1, CHARM - Not Automated', @html OUTPUT
	set @rv = @rv + @html
	delete from TempEmail

	-- Start collapsible section	
	set @rv = @rv + '<details><summary><h3>Tier 1, Not Passing</h3></summary>'

		-- Tier 1, Not Passing --

		insert		TempEmail
		select		DomainLanguage 'Domain/Language', SiteType 'Site', TestPath 'Test', CucExecDate1 'LastRun', null 'ScenarioNumber'
		from		ReportView rv
		inner join	Domain d
		on			d.Domain = rv.DomainLanguage
		where		Environment		= @env
		and			SiteType		= 'MobileSite'
		and			Tier			= 1
		and			CucExecStatus1	!= 'Passed'
		order by	d.SortOrder, rv.SiteType, rv.TestPath, rv.CucExecDate1

		exec GetTempEmailAsHTML 'Tier 1, Mobile - Automated, Not Passing', @html OUTPUT
		set @rv = @rv + @html
		delete from TempEmail

		insert		TempEmail
		select		DomainLanguage 'Domain/Language', SiteType 'Site', TestPath 'Test', CucExecDate1 'LastRun', null 'ScenarioNumber'
		from		ReportView rv
		inner join	Domain d
		on			d.Domain = rv.DomainLanguage
		where		Environment		= @env
		and			SiteType		= 'Consumer'
		and			Tier			= 1
		and			CucExecStatus1	!= 'Passed'
		order by	d.SortOrder, rv.SiteType, rv.TestPath, rv.CucExecDate1

		exec GetTempEmailAsHTML 'Tier 1, Consumer - Automated, Not Passing', @html OUTPUT
		set @rv = @rv + @html
		delete from TempEmail

		insert		TempEmail
		select		DomainLanguage 'Domain/Language', SiteType 'Site', TestPath 'Test', CucExecDate1 'LastRun', null 'ScenarioNumber'
		from		ReportView rv
		inner join	Domain d
		on			d.Domain = rv.DomainLanguage
		where		Environment		= @env
		and			SiteType		= 'CHARM'
		and			Tier			= 1
		and			CucExecStatus1	!= 'Passed'
		order by	d.SortOrder, rv.SiteType, rv.TestPath, rv.CucExecDate1

		exec GetTempEmailAsHTML 'Tier 1, CHARM - Automated, Not Passing', @html OUTPUT
		set @rv = @rv + @html
		delete from TempEmail

	-- End collapsible section	
	set @rv = @rv + '</details>'
GO

GRANT EXECUTE ON [AutomationSummary] TO public
GO

--exec EmailAutomationSummary 'bcatlin@opentable.com'