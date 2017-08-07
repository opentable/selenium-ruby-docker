use QCReporting
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetTempEmailAsHTML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GetTempEmailAsHTML]
GO

create procedure dbo.GetTempEmailAsHTML
	 @title varchar(MAX)
	,@html varchar(MAX) OUTPUT
AS
BEGIN
	declare @openfontsuccess as varchar(50), @openfonterror as varchar(50), @closefont as varchar(50)
	set @openfonterror		= '<font color=red>'
	set @openfontsuccess	= '<font color=green>'
	set @closefont			= '</font>'

	declare @count as int
	select @count = count(*) from TempEmail

	-- Title
	select @html = '<h3>'
				 + case when @count > 0 then @openfonterror else @openfontsuccess end
				 + @title + ' - '
				 + cast(@count as varchar) + ' cases'
				 + @closefont
				 + '</h3>' + char(10)
	
	-- Table
	if @count > 0
	begin
		select @html = @html + '<table style="border:1px solid #333" cellpadding="2" cellspacing="0">' + char(10)
		select @html = @html + '<tr>'
							 + '<th align="left" style="border:1px solid #333" >Domain/ Language</th>'
							 + '<th align="left" style="border:1px solid #333" >Site</th>'
							 + '<th align="left" style="border:1px solid #333" >Test</th>'
							 + '<th align="left" style="border:1px solid #333" >Last Run</th>'
							 + '<th align="left" style="border:1px solid #333" >ScenNum</th>'
							 + '</tr>' + char(10)
		select @html = @html + '<tr>'
							 + '<td style="border:1px solid #333" >' + [Domain/Language] + '</td>'
							 + '<td style="border:1px solid #333" >' + Site + '</td>'
							 + '<td style="border:1px solid #333" >' + Test + '</td>'
							 + '<td style="border:1px solid #333" >' + coalesce(cast(LastRun as varchar(50)), 'Never') + '</td>'
							 + '<td style="border:1px solid #333" >' + coalesce(cast(ScenarioNumber as varchar(10)), 'n/a') + '</td>'
							 + '</tr>' + char(10) from TempEmail order by ID
		select @html = @html + '</table>' + char(10)
	end
END 

GRANT EXECUTE ON [GetTempEmailAsHTML] TO public
GO
