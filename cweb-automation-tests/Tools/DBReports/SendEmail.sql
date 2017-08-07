use QCReporting
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SendEmail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SendEmail]
GO

create procedure dbo.SendEmail
	 @From		varchar(100) 
	,@To		varchar(100) 
	,@Subject	varchar(100) 
	,@Body		varchar(MAX)
AS
BEGIN
	--First we need to make sure that the from field is a valid profile configured in the system
	IF NOT EXISTS (select * from msdb.dbo.sysmail_profile where name = @From)
	set @From = null --null will use the default profile

	EXEC msdb.dbo.sp_send_dbmail
		@profile_name	= @From,
		@recipients		= @To,
		@subject		= @Subject,
		@body_format	= 'HTML',
		@body			= @Body

END 

GRANT EXECUTE ON [SendEmail] TO public
GO
