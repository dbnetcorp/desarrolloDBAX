SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetConcDife](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVers_inst numeric(5,0)) 
as
declare @pVers_ante numeric (5,0)
BEGIN
set @pVers_ante = @pVers_inst - 1
	select  v.codi_conc,x1.fini_cntx,isnull(x1.ffin_cntx,0)ffin_cntx
		from	dbax_inst_conc v,
			dbax_inst_cntx x1,
			dbax_defi_conc c,
			dbax_info_defi i,
			dbax_desc_conc d
		where v.codi_pers = @pCodi_pers
		and   v.corr_inst = @pCorr_inst
		and   v.vers_inst = @pVers_ante
		and   v.pref_conc = c.pref_conc
		and   v.codi_conc = c.codi_conc
		and   x1.codi_pers = v.codi_pers
		and   x1.corr_inst = v.corr_inst
		and   x1.codi_cntx = v.codi_cntx
		and   c.pref_conc  = d.pref_conc
		and   c.codi_conc  = d.codi_conc    
		and   exists (	select 1
					   from dbax_inst_conc v1,
							dbax_inst_cntx x2
					   where v1.codi_pers = @pCodi_pers
					   and   v1.corr_inst = @pCorr_inst
					   and   v1.vers_inst = @pVers_inst
					   and   v1.pref_conc = v.pref_conc
					   and   v1.codi_conc = v.codi_conc
					   and   v1.codi_cntx = v.codi_cntx
					   and   x2.codi_pers = v1.codi_pers 
					   and   x2.corr_inst = v1.corr_inst
					   and   x2.vers_inst = v1.vers_inst
					   and   x2.fini_cntx = x1.fini_cntx
					   and   isnull(x2.ffin_cntx,'') = isnull(x1.ffin_cntx,'')
					   and   x1.codi_pers = v1.codi_pers
					   and   replace(v1.valo_cntx,'.00','') != replace(v.valo_cntx,'.00',''))
		group by  v.codi_conc,x1.fini_cntx,x1.ffin_cntx
union 
 select  v.codi_conc,x1.fini_cntx,isnull(x1.ffin_cntx,0)ffin_cntx
		from	dbax_inst_conc v,
			dbax_inst_cntx x1,
			dbax_defi_conc c,
			dbax_info_defi i,
			dbax_desc_conc d
		where v.codi_pers = @pCodi_pers
		and   v.corr_inst = @pCorr_inst
		and   v.vers_inst = @pVers_ante
		and   v.pref_conc = c.pref_conc
		and   v.codi_conc = c.codi_conc
		and   x1.codi_pers = v.codi_pers
		and   x1.corr_inst = v.corr_inst
		and   x1.codi_cntx = v.codi_cntx
		and   c.pref_conc  = d.pref_conc
		and   c.codi_conc  = d.codi_conc  
		and   not exists (	select 1
					   from dbax_inst_conc v1,
							dbax_inst_cntx x2
					   where v1.codi_pers = @pCodi_pers
					   and   v1.corr_inst = @pCorr_inst
					   and   v1.vers_inst = @pVers_inst
					   and   v1.pref_conc = v.pref_conc
					   and   v1.codi_conc = v.codi_conc
					   and   v1.codi_cntx = v.codi_cntx
					   and   x2.codi_pers = v1.codi_pers 
					   and   x2.corr_inst = v1.corr_inst
					   and   x2.vers_inst = v1.vers_inst
					   and   x2.fini_cntx = x1.fini_cntx
					   and   isnull(x2.ffin_cntx,'') = isnull(x1.ffin_cntx,'')
					   and   x1.codi_pers = v1.codi_pers
					   )
		group by v.codi_conc,x1.fini_cntx,x1.ffin_cntx
union
select  v.codi_conc,x1.fini_cntx,isnull(x1.ffin_cntx,0)ffin_cntx
	from	dbax_inst_conc v,
			dbax_inst_cntx x1,
			dbax_defi_conc c,
			dbax_info_defi i,
			dbax_desc_conc d
		where v.codi_pers = @pCodi_pers
		and   v.corr_inst = @pCorr_inst
		and   v.vers_inst = @pVers_inst
		and   v.pref_conc = c.pref_conc
		and   v.codi_conc = c.codi_conc
		and   x1.codi_pers = v.codi_pers
		and   x1.corr_inst = v.corr_inst
		and   x1.codi_cntx = v.codi_cntx
		and   c.pref_conc  = d.pref_conc
		and   c.codi_conc  = d.codi_conc   
		and   not exists (	select 1
					   from dbax_inst_conc v1,
							dbax_inst_cntx x2
					   where v1.codi_pers = @pCodi_pers
					   and   v1.corr_inst = @pCorr_inst
					   and   v1.vers_inst = @pVers_ante
					   and   v1.pref_conc = v.pref_conc
					   and   v1.codi_conc = v.codi_conc
					   and   v1.codi_cntx = v.codi_cntx
					   and   x2.codi_pers = v1.codi_pers 
					   and   x2.corr_inst = v1.corr_inst
					   and   x2.vers_inst = v1.vers_inst
					   and   x2.fini_cntx = x1.fini_cntx
					   and   isnull(x2.ffin_cntx,'') = isnull(x1.ffin_cntx,'')
					   and   x1.codi_pers = v1.codi_pers
					   )
		group by  v.codi_conc,x1.fini_cntx,x1.ffin_cntx
END
GO
