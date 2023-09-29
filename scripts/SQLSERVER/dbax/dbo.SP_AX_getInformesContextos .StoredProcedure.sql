SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getInformesContextos ]
	@p_CodiEmex varchar(30),
	@p_CodiEmpr varchar(100),
	@p_CorrInst numeric(10,0),
	@p_CodiInfo varchar(50)
as
BEGIN
	select	dc.codi_cntx, 
			dc.diai_cntx, dc.anoi_cntx,
			dc.diat_cntx, dc.anot_cntx,
			dbo.FU_AX_getFechas(@p_CorrInst, dc.diai_cntx, dc.anoi_cntx) fini_cntx, 
			dbo.FU_AX_getFechas(@p_CorrInst, dc.diat_cntx, dc.anot_cntx) ffin_cntx,
			dc.desc_cntx,
			ic.orde_cntx
	from	dbax_defi_cntx dc,
			dbax_info_cntx ic
	where	dc.codi_emex = @p_CodiEmex
	and		dc.codi_empr = @p_CodiEmpr
	and		ic.codi_emex = dc.codi_emex
	and		ic.codi_empr = dc.codi_empr
	and		ic.codi_info = @p_CodiInfo
	and		ic.codi_cntx = dc.codi_cntx
	order by ic.orde_cntx
END
GO
