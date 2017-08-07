USE default_sqa_web_db
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[td].[fGetTierIntFromString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [td].[fGetTierIntFromString]
GO

CREATE FUNCTION [td].[fGetTierIntFromString]
(
	 @sTier	varchar(100)
)
RETURNS int
as
begin
	declare @rv int
	select @rv = 
		case
			-- return the lowest tier in case of multiple tiers (it's a semicolon separated string)
			when @sTier like '%Tier 0%'		then 0
			when @sTier like '%Tier I'		then 1
			when @sTier like '%Tier I;%'	then 1
			when @sTier like '%Tier II'		then 2
			when @sTier like '%Tier II;%'	then 2
			when @sTier like '%Tier III'	then 3
			when @sTier like '%Tier III;%'	then 3
			when @sTier like '%NA%'			then -98 -- not applicable
											else -99 -- no tier
		end
	return @rv
end
GO

--select distinct TS_USER_12 as 'Tier' from default_sqa_web_db.td.TEST 
