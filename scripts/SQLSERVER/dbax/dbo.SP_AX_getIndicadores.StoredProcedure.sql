SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getIndicadores](
	@pCodi_emex varchar(30),
	@pCodi_empr  numeric(9,0)) as
BEGIN
	select codi_indi, tipo_conc, desc_indi, form_indi from dbax_form_enca where codi_emex = @pCodi_emex and codi_empr = @pCodi_empr
END
GO
