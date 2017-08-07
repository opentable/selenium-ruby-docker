USE default_sqa_web_db
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[td].[fSplitString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [td].[fSplitString]
GO

CREATE FUNCTION [td].[fSplitString]
(
	 @String	varchar(8000)
	,@Delimiter	char(1)
)
RETURNS @temptable TABLE (items varchar(8000))       
AS
BEGIN
    declare @idx int       
    declare @slice varchar(8000)       
      
    select @idx = 1       
        if len(@String)<1 or @String is null
        begin
			insert into @temptable(Items) values(@String)
			return
        end
      
    while @idx!= 0       
    begin       
        set @idx = charindex(@Delimiter,@String)       
        if @idx!=0       
            set @slice = left(@String,@idx - 1)       
        else       
            set @slice = @String       
          
        if(len(@slice)>0)  
            insert into @temptable(Items) values(@slice)       
  
        set @String = right(@String,len(@String) - @idx)       
        if len(@String) = 0 break       
    end   
RETURN
END
GO
