use QCReporting
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EmailAutomationSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[EmailAutomationSummary]
GO

create procedure dbo.EmailAutomationSummary
	 @env				varchar(100)	= 'PreProd'
	,@persistentonly	bit				= 0
	,@to				varchar(100)	= 'WebReleaseAuto@opentable.com'
AS
BEGIN
	declare @from varchar(100), @subject varchar(100), @body varchar(MAX)

	set @from		= 'WebAutomation'
	set @subject	= 'Automation Summary Report' + coalesce(' - ' + case when @env = 'WebRelease' then 'SF QA' else @env end, '')
	if @persistentonly = 1
	begin
		set @subject	= @subject + ' - Persistent Failures'
	end
	exec dbo.AutomationSummary @env, @persistentonly, @body OUTPUT

	exec dbo.SendEmail @from, @to, @subject, @body
END 

GRANT EXECUTE ON [EmailAutomationSummary] TO public
GO
