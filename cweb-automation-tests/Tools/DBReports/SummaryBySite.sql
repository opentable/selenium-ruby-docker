USE QCReporting
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SummaryBySite]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SummaryBySite]
GO

create procedure dbo.SummaryBySite
AS

	set nocount on
	set transaction isolation level read uncommitted

	select		 r.SiteType
				,count(*)																	'Total Cases'
				,sum(case	when CucExecStatus1 is not null then 1 else 0 end)				'Cucumber Automated'
				,sum(case	when coalesce(CucExecStatus1, '') = 'Passed' then 1 else 0 end)	'Cucumber Passing'
				,round(cast(sum(case when CucExecStatus1 is not null then 1 else 0 end) as float) * 100
						/ cast(count(*) as float), 2) 'Percent Automated'
				,round(cast(sum(case when coalesce(CucExecStatus1, '') = 'Passed' then 1 else 0 end) as float) * 100
						/ cast(count(*) as float), 2) 'Percent Automated Passing'
	from		[Report] r
	left join	DomainLanguageMap dlm
	on			dlm.DomainLanguage	= r.DomainLanguage
	and			dlm.Tier			= r.Tier
	group by	r.SiteType
	order by	r.SiteType desc
GO

GRANT EXECUTE ON [SummaryBySite] TO public
GO
