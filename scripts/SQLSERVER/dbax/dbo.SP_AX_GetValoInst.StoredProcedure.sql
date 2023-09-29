SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetValoInst](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVers_inst numeric(5,0),
	@pCodi_conc varchar(256),
	@pFini_cntx varchar(10),
	@pFfin_cntx varchar(10)) 
as
declare @pVers_ante numeric (5,0)
declare @vDesc_ante varchar(256)
declare @vDesc_actu varchar(256)
declare @vFini_ante varchar(10)
declare @vFini_actu varchar(10)
declare @vFfin_ante varchar(10)
declare @vFfin_actu varchar(10)
declare @vValo_ante varchar(100)
declare @vValo_actu varchar(100)


BEGIN
set @pVers_ante = @pVers_inst - 1
if(@pFfin_cntx='0')
set @pFfin_cntx =null

select @vDesc_ante=d.desc_conc,@vFini_ante=c.fini_cntx,@vFfin_ante=c.ffin_cntx,@vValo_ante =i.valo_cntx
--select d.desc_conc,c.fini_cntx,c.ffin_cntx,i.valo_cntx
	from dbax_inst_conc i,dbax_inst_cntx c,
	dbax_desc_conc d
	where c.codi_pers=i.codi_pers
	and c.corr_inst =i.corr_inst
	and c.vers_inst=i.vers_inst
	and c.codi_cntx=i.codi_cntx
	and d.pref_conc=i.pref_conc
	and d.codi_conc=i.codi_conc 
	and i.codi_pers = @pCodi_pers
	and i.corr_inst =@pCorr_inst
	and i.vers_inst= @pVers_ante 
	and i.codi_conc=@pCodi_conc
	and c.fini_cntx=@pFini_cntx
	and isnull(c.ffin_cntx,'')=isnull(@pFfin_cntx,'')

select @vDesc_actu=d.desc_conc,@vFini_actu=c.fini_cntx,@vFfin_actu=c.ffin_cntx,@vValo_actu=i.valo_cntx 
	from dbax_inst_conc i,dbax_inst_cntx c,
	dbax_desc_conc d
	where c.codi_pers=i.codi_pers
	and c.corr_inst=i.corr_inst
	and c.vers_inst=i.vers_inst
	and c.codi_cntx=i.codi_cntx
	and d.pref_conc=i.pref_conc
	and d.codi_conc=i.codi_conc 
	and i.codi_pers = @pCodi_pers
	and i.corr_inst=@pCorr_inst
	and i.vers_inst=@pVers_inst
	and i.codi_conc=@pCodi_conc
	and c.fini_cntx=@pFini_cntx
	and isnull(c.ffin_cntx,'')=isnull(@pFfin_cntx,'')

set @vDesc_actu=isnull(@vDesc_ante,@vDesc_actu)
set @vFini_actu=isnull(@vFini_ante,@vFini_actu)
set @vFfin_actu=isnull(@vFfin_ante,@vFfin_actu)


select @vDesc_actu desc_conc,@vFini_actu fini_cntx,@vFfin_actu ffin_cntx,@vValo_actu valo_actu,@vValo_ante valo_ante


END
GO
