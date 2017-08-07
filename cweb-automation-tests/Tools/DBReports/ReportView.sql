use QCReporting
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportView]') and OBJECTPROPERTY(id, N'IsView') = 1)
exec('create view [dbo].[ReportView] as select 1 temp')
GO

ALTER VIEW [dbo].[ReportView]

AS
	select 'PreProd'	as Environment, * from Report_PreProd
	union
	select 'WebRelease'	as Environment, * from Report_WebRelease
GO

GRANT SELECT ON [ReportView] TO public
GO
