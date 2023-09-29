SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_insEmpresaParaInforme](
	@pCodiEmpr numeric(9,0),
	@pCorrInst numeric(6,0)) as
BEGIN
	insert into dbax_tabl_temp (codi_colu1, codi_colu2, tipo_dato)
	values					   (@pCodiEmpr, @pCorrInst, 'IE')
END
GO
