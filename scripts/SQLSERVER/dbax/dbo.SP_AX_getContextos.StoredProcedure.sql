SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getContextos]
	@pCodiEmex varchar(30),
	@pCodiEmpr varchar(100),
	@pCorrInst numeric(6,0),
	@pCodiInfo varchar(50) = ''
as
BEGIN
	if(@pCorrInst = 0)
	begin
		select	distinct dc.codi_cntx,
				dc.desc_cntx,
				dc.diai_cntx as codi_diai, 
				dbo.FU_AX_getDescFech(diai_cntx) diai_cntx, 
				dc.anoi_cntx as codi_anoi,
				dbo.FU_AX_getDescFech(anoi_cntx) anoi_cntx,
				dc.diat_cntx as codi_diat,
				dbo.FU_AX_getDescFech(diat_cntx) diat_cntx,
				dc.anot_cntx as codi_anot,
				dbo.FU_AX_getDescFech(anot_cntx) anot_cntx,
				null fini_cntx,
				null ffin_cntx,
				isnull(ic.orde_cntx,9999) as 'orde_cntx',
				dc.orde_cntx as 'dc.orde_cntx'
		from	dbax_defi_cntx dc
				left join dbax_info_cntx ic
				on dc.codi_cntx = ic.codi_cntx
				and	ic.codi_info like @pCodiInfo
				and	ic.codi_emex = @pCodiEmex
				and ic.codi_empr = @pCodiEmpr
		where	dc.codi_emex = @pCodiEmex
		and		dc.codi_empr = @pCodiEmpr
		order by isnull(ic.orde_cntx,9999), dc.orde_cntx
	end
	else
	begin
		select	distinct dc.codi_cntx, 
				dc.desc_cntx,
				dc.diai_cntx as codi_diai, 
				dbo.FU_AX_getDescFech(diai_cntx) diai_cntx, 
				dc.anoi_cntx as codi_anoi,
				dbo.FU_AX_getDescFech(anoi_cntx) anoi_cntx,
				dc.diat_cntx as codi_diat,
				dbo.FU_AX_getDescFech(diat_cntx) diat_cntx,
				dc.anot_cntx as codi_anot,
				dbo.FU_AX_getDescFech(anot_cntx) anot_cntx,
				dbo.FU_AX_getFechas(@pCorrInst , diai_cntx, anoi_cntx) fini_cntx,
				dbo.FU_AX_getFechas(@pCorrInst , diat_cntx, anot_cntx) ffin_cntx,
				isnull(ic.orde_cntx,9999) as 'orde_cntx',
				dc.orde_cntx as 'dc.orde_cntx'
		from	dbax_defi_cntx dc
				left join dbax_info_cntx ic
				on dc.codi_cntx = ic.codi_cntx
				and	ic.codi_info like @pCodiInfo
				and	ic.codi_emex = @pCodiEmex
				and ic.codi_empr = @pCodiEmpr
		where	dc.codi_emex = @pCodiEmex
		and		dc.codi_empr = @pCodiEmpr
		order by isnull(ic.orde_cntx,9999), dc.orde_cntx
	end
END
GO
