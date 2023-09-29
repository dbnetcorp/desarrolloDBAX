SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[separaMiles] (@p_valor varchar(256)) returns varchar(256)
as
begin
	declare	@p_valor2 varchar(256)
	declare	@tmpvalor varchar(256)
	declare	@subvalor varchar (3)
    declare @sigvalor varchar(1)
	declare @esDecimal bit

	if(dbo.esNumero(@p_valor)='S')
	begin

		set @esDecimal = 0
		set @tmpvalor = ''
		set @sigvalor = ''
		if(substring(@p_valor,1,1)='-')
		begin
			set @sigvalor='-'
			set @p_valor=replace(@p_valor,'-','')
		end

		if (charindex('.', @p_valor)>0)
		begin
			set @p_valor2 = substring(@p_valor,1,charindex('.', @p_valor)-1)
			set @esDecimal = 1
		end
		else
			set @p_valor2 = @p_valor

		while(len(@p_valor2) > 3)
		begin
			set @subvalor = substring(@p_valor2, len(@p_valor2)-2, 3)
			set @tmpvalor = '.' + @subvalor +  @tmpvalor
			set @p_valor2 = substring(@p_valor2, 1, len(@p_valor2)-3)
		end

		if(@sigvalor = '')
		begin
			set @tmpvalor = @p_valor2 + @tmpvalor
		end
		else
			set @tmpvalor = @sigvalor + @p_valor2 + @tmpvalor

		if(@esDecimal=1)
			return @tmpvalor + replace(substring(@p_valor,charindex('.', @p_valor),256),'.',',')
	end
	else
	begin
		set @tmpvalor = @p_valor
	end
	return @tmpvalor 
end
GO
