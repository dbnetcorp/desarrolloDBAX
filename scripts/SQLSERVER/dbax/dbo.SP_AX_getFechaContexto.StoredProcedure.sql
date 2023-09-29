SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getFechaContexto]
	@CodiEmex varchar(30),
	@CodiEmpr numeric(9,0),
	@CorrInst numeric(6,0),
	@CodiCntx varchar(50)
as
BEGIN
	select	codi_cntx, 
			dbo.FU_AX_getFechas(@CorrInst, dc.diai_cntx, dc.anoi_cntx) fini_cntx, 
			dbo.FU_AX_getFechas(@CorrInst, dc.diat_cntx, dc.anot_cntx) ffin_cntx 
	from	dbax_defi_cntx dc
	where	codi_emex = @CodiEmex
	and		codi_empr = @CodiEmpr
	and		codi_cntx = @CodiCntx
END
GO
