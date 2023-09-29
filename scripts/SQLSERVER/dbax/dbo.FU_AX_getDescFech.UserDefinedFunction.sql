SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FU_AX_getDescFech](
			@p_CodiFech varchar(100)
            ) 
            returns varchar(4000)
begin
	declare @v_valor varchar(4000)

	select	@v_valor = desc_fech
	from	dbax_codi_fech
	where	codi_fech = @p_CodiFech

	return @v_valor
end
GO
