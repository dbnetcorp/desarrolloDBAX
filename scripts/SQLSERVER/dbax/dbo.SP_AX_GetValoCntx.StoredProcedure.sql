SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetValoCntx](
	@pCodi_pers numeric(9,0),
	@pCorr_inst  numeric(10,0),
	@pVers_inst  numeric(5,0),
	@pCodi_cntx  varchar(50),
    @pCodi_conc  varchar(256),
    @pFini_cntx  varchar(10),
    @pFfin_cntx  varchar(10)) as

BEGIN
	if(  @pFfin_cntx  = '')
		begin
				select	conc.valo_cntx as valo_cntx, 
						conc.codi_unit as codi_unit, 
						conc.codi_cntx as codi_cntx
				from	dbax_inst_conc conc, 
						dbax_view_cntx cntx
				where	conc.codi_pers = cntx.codi_pers
				and		conc.corr_inst = cntx.corr_inst
				and		conc.vers_inst = cntx.vers_inst
				and		conc.codi_cntx = cntx.codi_cntx
				and		conc.codi_pers = @pCodi_pers 
				and		conc.corr_inst = @pCorr_inst
				and		conc.vers_inst = @pVers_inst
				and		conc.codi_conc = @pCodi_conc
				and		cntx.fini_cntx = @pFini_cntx 
                and		cntx.ffin_cntx is null 
		end
	else
		begin
                select	conc.valo_cntx as valo_cntx, 
						conc.codi_unit as codi_unit,
						conc.codi_cntx as codi_cntx
				from	dbax_inst_conc conc, 
						dbax_view_cntx cntx
				where	conc.codi_pers = cntx.codi_pers
				and		conc.corr_inst = cntx.corr_inst
				and		conc.vers_inst = cntx.vers_inst
				and		conc.codi_cntx = cntx.codi_cntx
				and		conc.codi_pers = @pCodi_pers 
				and		conc.corr_inst = @pCorr_inst 
				and		conc.vers_inst = @pVers_inst
				and		conc.codi_conc = @pCodi_conc
				and		(cntx.fini_cntx = @pFini_cntx or cntx.fini_cntx = substring(convert(varchar,DATEADD(day,1,convert(datetime, @pFini_cntx,20)),20),1,10))
                and		cntx.ffin_cntx = @pFfin_cntx
		end
END
GO
