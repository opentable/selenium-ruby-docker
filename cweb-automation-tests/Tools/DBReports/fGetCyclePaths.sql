IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[td].[fGetCyclePaths]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [td].[fGetCyclePaths]
GO

CREATE FUNCTION [td].[fGetCyclePaths]()
RETURNS table
as
return 
(
	--**************************************************************************
	--** This function returns all QC test runs and their fully-qualified paths.
--	--** Note: there are test that the inner join excludes, 1622 of them as of
--	--** 6/18/12.  They are all in the 'unattached' folder.  See QC for details.
	--**************************************************************************

	select		 c.CY_CYCLE_ID
				,c.CY_CYCLE
				,c.CY_FOLDER_ID
				,'\'
				+ coalesce(cf12.CF_ITEM_NAME + '\', '')
				+ coalesce(cf11.CF_ITEM_NAME + '\', '')
				+ coalesce(cf10.CF_ITEM_NAME + '\', '')
				+ coalesce(cf9.CF_ITEM_NAME  + '\', '')
				+ coalesce(cf8.CF_ITEM_NAME  + '\', '')
				+ coalesce(cf7.CF_ITEM_NAME  + '\', '')
				+ coalesce(cf6.CF_ITEM_NAME  + '\', '')
				+ coalesce(cf5.CF_ITEM_NAME  + '\', '')
				+ coalesce(cf4.CF_ITEM_NAME  + '\', '')
				+ coalesce(cf3.CF_ITEM_NAME  + '\', '')
				+ coalesce(cf2.CF_ITEM_NAME  + '\', '')
				+ coalesce(cf1.CF_ITEM_NAME  + '\', '')
				+ c.CY_CYCLE 'Path'
	from		td.CYCLE c
	inner join	td.CYCL_FOLD cf1  on c.CY_FOLDER_ID    = cf1.CF_ITEM_ID
	left join	td.CYCL_FOLD cf2  on cf1.CF_FATHER_ID  = cf2.CF_ITEM_ID
	left join	td.CYCL_FOLD cf3  on cf2.CF_FATHER_ID  = cf3.CF_ITEM_ID
	left join	td.CYCL_FOLD cf4  on cf3.CF_FATHER_ID  = cf4.CF_ITEM_ID
	left join	td.CYCL_FOLD cf5  on cf4.CF_FATHER_ID  = cf5.CF_ITEM_ID
	left join	td.CYCL_FOLD cf6  on cf5.CF_FATHER_ID  = cf6.CF_ITEM_ID
	left join	td.CYCL_FOLD cf7  on cf6.CF_FATHER_ID  = cf7.CF_ITEM_ID
	left join	td.CYCL_FOLD cf8  on cf7.CF_FATHER_ID  = cf8.CF_ITEM_ID
	left join	td.CYCL_FOLD cf9  on cf8.CF_FATHER_ID  = cf9.CF_ITEM_ID
	left join	td.CYCL_FOLD cf10 on cf9.CF_FATHER_ID  = cf10.CF_ITEM_ID
	left join	td.CYCL_FOLD cf11 on cf10.CF_FATHER_ID = cf11.CF_ITEM_ID
	left join	td.CYCL_FOLD cf12 on cf11.CF_FATHER_ID = cf12.CF_ITEM_ID
)
GO


