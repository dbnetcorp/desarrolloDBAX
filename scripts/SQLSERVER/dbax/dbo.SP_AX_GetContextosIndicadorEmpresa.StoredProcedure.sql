SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetContextosIndicadorEmpresa](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVers_inst numeric(5,0),
	@pCodiIndi varchar(100))
as
declare @pVers_ante numeric (5,0)
BEGIN
	select	distinct ic.codi_cntx as codi_cntx, 
			vc.fini_cntx as fini_cntx, 
			isnull(vc.ffin_cntx,'') as ffin_cntx
	from	dbax_inst_conc ic,
			dbax_form_deta fm,
			dbax_view_cntx vc
	where	ic.codi_pers = @pCodi_pers 
	and		ic.corr_inst = @pCorr_inst
	and		ic.vers_inst = @pVers_inst
	and		vc.codi_pers = ic.codi_pers
	and		vc.corr_inst = ic.corr_inst
	and		vc.vers_inst = ic.vers_inst
	and		vc.codi_cntx = ic.codi_cntx
	and		fm.codi_indi = @pCodiIndi
	and		ic.pref_conc = fm.pref_conc
	and		ic.codi_conc = fm.codi_conc
END
GO
