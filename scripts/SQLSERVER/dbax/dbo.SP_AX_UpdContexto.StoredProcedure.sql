SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_UpdContexto] (
	@pCodiEmex varchar(30),
	@pCodiEmpr numeric(9,0),
	@pCodiCntx varchar(50),
	@pDescCntx varchar(100),
	@pDiaiCntx varchar(100),
	@pAnoiCntx varchar(100),
	@pDiatCntx varchar(100),
	@pAnotCntx varchar(100)
	)
AS
BEGIN
	update	dbax_defi_cntx 
	set		desc_cntx = @pDescCntx,
			diai_cntx = @pDiaiCntx,
			anoi_cntx = @pAnoiCntx,
			diat_cntx = @pDiatCntx,
			anot_cntx = @pAnotCntx
	where	codi_emex = @pCodiEmex
	and		codi_empr = @pCodiEmpr 
	and		codi_cntx = @pCodiCntx
END
GO
