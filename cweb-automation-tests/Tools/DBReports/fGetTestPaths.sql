USE default_sqa_web_db
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[td].[fGetTestPaths]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [td].[fGetTestPaths]
GO

CREATE FUNCTION [td].[fGetTestPaths]()
RETURNS table
as
return 
(
	--**************************************************************************
	--** This function returns all QC tests and their fully-qualified paths.
	--** Note: there are test that the inner join excludes, 1622 of them as of
	--** 6/18/12.  They are all in the 'unattached' folder.  See QC for details.
	--**************************************************************************

	select		 t.TS_TEST_ID
				,'\'
				+ coalesce(al12.AL_DESCRIPTION + '\', '')
				+ coalesce(al11.AL_DESCRIPTION + '\', '')
				+ coalesce(al10.AL_DESCRIPTION + '\', '')
				+ coalesce(al9.AL_DESCRIPTION  + '\', '')
				+ coalesce(al8.AL_DESCRIPTION  + '\', '')
				+ coalesce(al7.AL_DESCRIPTION  + '\', '')
				+ coalesce(al6.AL_DESCRIPTION  + '\', '')
				+ coalesce(al5.AL_DESCRIPTION  + '\', '')
				+ coalesce(al4.AL_DESCRIPTION  + '\', '')
				+ coalesce(al3.AL_DESCRIPTION  + '\', '')
				+ coalesce(al2.AL_DESCRIPTION  + '\', '')
				+ coalesce(al1.AL_DESCRIPTION  + '\', '')
				+ t.TS_NAME 'Path'
				--,al1.AL_DESCRIPTION 'folder'
				--,al1.AL_ABSOLUTE_PATH 'path1'
				--,al2.AL_ABSOLUTE_PATH 'path2'
				--,al3.AL_ABSOLUTE_PATH 'path3'
	from		td.TEST t
	inner join	td.ALL_LISTS al1  on al1.AL_ITEM_ID    = t.TS_SUBJECT
	left join	td.ALL_LISTS al2  on al1.AL_FATHER_ID  = al2.AL_ITEM_ID
	left join	td.ALL_LISTS al3  on al2.AL_FATHER_ID  = al3.AL_ITEM_ID
	left join	td.ALL_LISTS al4  on al3.AL_FATHER_ID  = al4.AL_ITEM_ID
	left join	td.ALL_LISTS al5  on al4.AL_FATHER_ID  = al5.AL_ITEM_ID
	left join	td.ALL_LISTS al6  on al5.AL_FATHER_ID  = al6.AL_ITEM_ID
	left join	td.ALL_LISTS al7  on al6.AL_FATHER_ID  = al7.AL_ITEM_ID
	left join	td.ALL_LISTS al8  on al7.AL_FATHER_ID  = al8.AL_ITEM_ID
	left join	td.ALL_LISTS al9  on al8.AL_FATHER_ID  = al9.AL_ITEM_ID
	left join	td.ALL_LISTS al10 on al9.AL_FATHER_ID  = al10.AL_ITEM_ID
	left join	td.ALL_LISTS al11 on al10.AL_FATHER_ID = al11.AL_ITEM_ID
	left join	td.ALL_LISTS al12 on al11.AL_FATHER_ID = al12.AL_ITEM_ID
)
GO
