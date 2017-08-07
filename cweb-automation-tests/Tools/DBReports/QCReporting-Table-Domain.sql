USE QCReporting
GO

-- ***************************************************************************
-- * Create Domain table (drop if it doesn't exist)
-- ***************************************************************************
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Domain]'))
drop table Domain
GO

CREATE TABLE dbo.Domain (
	 Domain		varchar(15)
	,SortOrder	int
)
GO

GRANT SELECT,INSERT,DELETE ON [Domain] TO public
GO

GRANT SELECT,INSERT,DELETE ON [Domain] TO QCReportingRead
GO

-- North America
insert into Domain (Domain, SortOrder) values ('.com/en-us', 1)
insert into Domain (Domain, SortOrder) values ('.com.mx/es-mx', 2)
insert into Domain (Domain, SortOrder) values ('.com.mx/en-us', 3)
insert into Domain (Domain, SortOrder) values ('.com(ca)/en-us', 4)
insert into Domain (Domain, SortOrder) values ('.com(ca)/fr-ca', 5)
insert into Domain (Domain, SortOrder) values ('.na/en-us', 11)
insert into Domain (Domain, SortOrder) values ('.na/es-mx', 12)
insert into Domain (Domain, SortOrder) values ('.na/mx-en-us', 13)
insert into Domain (Domain, SortOrder) values ('.na/fr-ca', 14)
-- Europe
insert into Domain (Domain, SortOrder) values ('.co.uk/en-gb', 31)
insert into Domain (Domain, SortOrder) values ('.de/de-de', 32)
insert into Domain (Domain, SortOrder) values ('.de/en-gb', 33)
insert into Domain (Domain, SortOrder) values ('.eu/uk-en-gb', 41)
insert into Domain (Domain, SortOrder) values ('.eu/de-de', 42)
insert into Domain (Domain, SortOrder) values ('.eu/de-en-gb', 43)

-- Asia
insert into Domain (Domain, SortOrder) values ('.jp/ja-jp', 51)
insert into Domain (Domain, SortOrder) values ('.jp/en-gb', 52)
insert into Domain (Domain, SortOrder) values ('.asia/ja-jp', 61)
insert into Domain (Domain, SortOrder) values ('.asia/jp-en-gb', 62)
-- No longer supported
insert into Domain (Domain, SortOrder) values ('.es/es-es', 81)
insert into Domain (Domain, SortOrder) values ('.es/en-gb', 82)
insert into Domain (Domain, SortOrder) values ('.fr/fr-fr', 83)
insert into Domain (Domain, SortOrder) values ('.fr/en-gb', 84)
insert into Domain (Domain, SortOrder) values ('.eu/fr-fr', 91)
-- Strange domains
insert into Domain (Domain, SortOrder) values ('???-.na/uk', 91)
insert into Domain (Domain, SortOrder) values ('???-uk.com/enus', 92)
