USE QCReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fGetTestPlanTests]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fGetTestPlanTests]
GO

CREATE FUNCTION [dbo].[fGetTestPlanTests]
(
	  @path	varchar(200) -- Paths: 'Basic Acceptance Tests' (Consumer BAT), 'CHARM BAT', 'Console Site BAT', 'Mobile BAT'
	 ,@env	varchar(200) -- Environments: 'PreProd'
)
RETURNS table
as
return
	select		 t.TS_TEST_ID			'TestID'
				,case	when @path =	'Basic Acceptance Tests'	then 'Consumer'
						when @path =	'CHARM BAT'					then 'CHARM'
						when @path =	'Mobile BAT\Mobile Website'	then 'MobileSite'
						else null end	'SiteType'
				,t.TS_NAME				'TestName'
				,substring(paths.Path, len('\Subject\')+len(@path)+2, 200)
										'TestPath'
				,coalesce(coalesce(dlm.DomainLanguage, 'UNMAPPED-'+ctrylang.items), 'UNDETERMINED')
										'DomainLanguage'
				,dlm.Tier				'Tier'
				,ctrylang.items			'CountryLanguage'
				,paths.Path				'Path'
	--			,default_sqa_web_db.td.fGetLabTestSetFromPath(substring(paths.Path,  len('\Subject\')+len(@path)+2, 100)) 'MapLabTestSet'
				,t.TS_USER_04			'QTPTestID'
				,t.TS_USER_10			'AutoOwner' -- repurposed from 'Feature File'
				,t.TS_USER_05			'AutoStatus'
	--			,t.TS_USER_07			'Last Modified By'
	--			,t.TS_USER_03			'Country/Language'
	--			,t.TS_USER_01			'Environment'
	--			,t.TS_USER_12			'Tier'
	--			,t.TS_USER_11			'QTP Function'
	--			,t.TS_USER_02			'Automated On'
	--			,t.TS_USER_09			'CC Reso (?)'
	--			,t.*
	from		default_sqa_web_db.td.TEST t
	inner join	default_sqa_web_db.td.fGetTestPaths() paths
	on			t.TS_TEST_ID		= paths.TS_TEST_ID
	cross apply	default_sqa_web_db.td.fSplitString(t.TS_USER_03, ';') ctrylang
	left join	DomainLanguageMap dlm
	on			dlm.CountryLanguage	= ctrylang.items
	and			dlm.Tier			= default_sqa_web_db.td.fGetTierIntFromString(t.TS_USER_12 /* Tier */)
	and			dlm.SiteType		= case	when @path =	'Basic Acceptance Tests'	then 'Consumer'
											when @path =	'CHARM BAT'					then 'CHARM'
											when @path =	'Mobile BAT\Mobile Website'	then 'MobileSite'
											else null end
	where		paths.Path			like '\Subject\' + @path + '\%'
	and			t.TS_USER_01		like '%' + @env + '%' -- Environment
GO
