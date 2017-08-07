USE QCReporting
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SummaryStats]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SummaryStats]
GO

create procedure dbo.SummaryStats
AS

	set nocount on
	set transaction isolation level read uncommitted

	select		 r.SiteType, r.DomainLanguage, r.Tier
				,count(*)																	'Total Cases'
				,sum(case	when coalesce(ManExecStatus1, '') = 'Passed' then 1 else 0 end)	'Manually Passed'
				,sum(case	when coalesce(CucExecStatus1, '') = 'Passed' then 1 else 0 end)	'Cucumber Passed'
				,sum(case	when coalesce(QTPExecStatus1, '') = 'Passed' then 1 else 0 end)	'QTP Passed'
				,sum(case	when coalesce(ManExecStatus1, '') = 'Passed' then 1
							when coalesce(CucExecStatus1, '') = 'Passed' then 1
							when coalesce(QTPExecStatus1, '') = 'Passed' then 1 else 0 end)	'Any Passed'
				,sum(case	when coalesce(ManExecStatus1, '') = 'Passed' then 0
							when coalesce(CucExecStatus1, '') = 'Passed' then 0
							when coalesce(QTPExecStatus1, '') = 'Passed' then 0 else 1 end)	'Any Not Passed'
	from		Report_PreProd r
	left join	DomainLanguageMap dlm
	on			dlm.DomainLanguage	= r.DomainLanguage
	and			dlm.Tier			= r.Tier
	group by	r.SiteType, r.DomainLanguage, r.Tier
	order by	r.SiteType, r.DomainLanguage, r.Tier
	
	-- Copy/paste to Stats spreadsheet tab
	select		 r.SiteType
				,sum(case	when r.Tier = 0 and coalesce(CucExecStatus1, '') = 'Passed' then 1 else 0 end)	'Tier 0 Passed'
				,sum(case	when r.Tier = 1 and coalesce(CucExecStatus1, '') = 'Passed' then 1 else 0 end)	'Tier 1 Passed'
				,sum(case	when r.Tier = 2 and coalesce(CucExecStatus1, '') = 'Passed' then 1 else 0 end)	'Tier 2 Passed'
				,sum(case	when                coalesce(CucExecStatus1, '') = 'Passed' then 1 else 0 end)	'Total Passed'
				,sum(case	when r.Tier = 0 and coalesce(CucExecStatus1, '') != '' then 1 else 0 end)	'Tier 0 Automated'
				,sum(case	when r.Tier = 1 and coalesce(CucExecStatus1, '') != '' then 1 else 0 end)	'Tier 1 Automated'
				,sum(case	when r.Tier = 2 and coalesce(CucExecStatus1, '') != '' then 1 else 0 end)	'Tier 2 Automated'
				,sum(case	when                coalesce(CucExecStatus1, '') != '' then 1 else 0 end)	'Total Automated'
				,sum(case	when r.Tier = 0                                        then 1 else 0 end)	'Tier 0 Cases'
				,sum(case	when r.Tier = 1                                        then 1 else 0 end)	'Tier 1 Cases'
				,sum(case	when r.Tier = 2                                        then 1 else 0 end)	'Tier 2 Cases'
				,count(*                                                                            )	'Total Cases'
	from		Report_PreProd r
	left join	DomainLanguageMap dlm
	on			dlm.DomainLanguage	= r.DomainLanguage
	and			dlm.Tier			= r.Tier
	group by	r.SiteType
	order by	r.SiteType
GO

GRANT EXECUTE ON [SummaryStats] TO public
GO
