SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetListaIndicadoresEmpresa](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
    @p_Codi_indi varchar(100)) as
BEGIN
if(  @p_Codi_indi = '')
	begin
		select	codi_indi as Nombre, 
				tipo_conc as Tipo, 
				desc_indi as Descripción, 
				form_indi as Fórmula
		from	dbax_form_enca
		where	codi_emex = @p_CodiEmex
		and		codi_empr = @p_CodiEmpr
	end
else
	begin
		select	codi_indi as Nombre, 
				tipo_conc as Tipo, 
				desc_indi as Descripción, 
				form_indi as Fórmula
		from	dbax_form_enca
		where	codi_emex = @p_CodiEmex
		and		codi_empr = @p_CodiEmpr
		and     codi_indi = @p_Codi_indi 
	end
END
GO
