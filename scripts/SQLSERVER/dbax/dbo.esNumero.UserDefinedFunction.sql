SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[esNumero](@p_valor varchar(200)) returns varchar(1)
begin
	declare @i int
	declare @l numeric
	declare @r varchar(1)

	set @i = 1
	set @r = 'S'
	set @l = len(@p_valor)
	
	if(@l = 1 AND @p_valor in ('-', '.', ',', ' '))
		return 'N'

	while (@i <= len(@p_valor) AND @r = 'S')
	begin
		if (@i = 1 AND substring(@p_valor,@i,1) not in ('0','1','2','3','4','5','6','7','8','9','.','-'))
		begin
			set @r = 'N'
		end
		else if (@i > 1 AND substring(@p_valor,@i,1) not in ('0','1','2','3','4','5','6','7','8','9','.'))
		begin
			set @r = 'N'
		end
		set @i = @i + 1
	end

    return @r
end
GO
