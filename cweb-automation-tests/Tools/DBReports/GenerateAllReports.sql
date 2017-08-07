USE QCReporting
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GenerateAllReports]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GenerateAllReports]
GO

create procedure dbo.GenerateAllReports
	 @consumer_branch	varchar(100)
	,@mobile_branch		varchar(100)
AS
	declare @product as varchar(50), @env as varchar(50), @branch as varchar(50), @testfolder as varchar(50)

	begin transaction

	-- ***************************************************************************
	-- * PreProd Report
	-- ***************************************************************************
	set @env		= 'PreProd'

	print 'Generating PreProd report for Consumer Branch: ' + @consumer_branch
	print 'Generating PreProd report for Mobile Branch: ' + @mobile_branch

	-- Drop old tables
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Report_PreProd]'))
	drop table dbo.Report_PreProd

	-- Recreate new report table
	exec RecreateTableReport

	-- Consumer
	set @branch		= @consumer_branch
	set @product	= 'Consumer'
	set @testfolder	= 'Basic Acceptance Tests'
	exec GenerateReport @product, @env, @branch, @testfolder

	-- CHARM
	set @branch		= @consumer_branch
	set @product	= 'CHARM'
	set @testfolder	= 'CHARM BAT'
	exec GenerateReport @product, @env, @branch, @testfolder

	-- Mobile
	set @branch		= @mobile_branch
	set @product	= 'Mobile'
	set @testfolder	= 'Mobile BAT\Mobile Website'
	exec GenerateReport @product, @env, @branch, @testfolder

	-- Delete all 'N/A' records from the results
	delete from Report where Tier = -98
	-- Delete all ES and FR records
	delete from Report where DomainLanguage in ('.es/es-es', '.fr/fr-fr')

	-- Rename table
	exec sp_RENAME 'Report' , 'Report_PreProd'


	-- ***************************************************************************
	-- * WebRelease Report
	-- ***************************************************************************
	set @env		= 'WebQA'
	set @branch		= 'Trunk'

	-- Drop old tables
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Report_WebRelease]'))
	drop table dbo.Report_WebRelease

	-- Recreate new report table
	exec RecreateTableReport

	-- Consumer
	set @product	= 'Consumer'
	set @testfolder	= 'Basic Acceptance Tests'
	exec GenerateReport @product, @env, @branch, @testfolder

	-- CHARM
	set @product	= 'CHARM'
	set @testfolder	= 'CHARM BAT'
	exec GenerateReport @product, @env, @branch, @testfolder

	-- Mobile
	set @product	= 'Mobile'
	set @testfolder	= 'Mobile BAT\Mobile Website'
	exec GenerateReport @product, @env, @branch, @testfolder

	-- Delete all 'N/A' records from the results
	delete from Report where Tier = -98
	-- Delete all ES and FR records
	delete from Report where DomainLanguage in ('.es/es-es', '.fr/fr-fr')

	-- Rename table
	exec sp_RENAME 'Report' , 'Report_WebRelease'

	commit transaction

	-- ***************************************************************************
	-- * Finished
	-- ***************************************************************************
GO

GRANT EXECUTE ON [GenerateAllReports] TO public
GO
