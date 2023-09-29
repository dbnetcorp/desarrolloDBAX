SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AX_getInformesUsables] 
	@pCodiEmex varchar(30),
	@pCodiEmpr numeric(9,0),
	@pCodiPers numeric(9,0),
	@pCorrInst numeric(10,0),
	@pVersInst numeric(5,0),
	@pTipoInfo varchar(1)
AS
BEGIN
	if(@pTipoInfo='R') --Solo informes realmente reportados por la empresa
	begin
		select	id.codi_info, di.desc_info
		from	dbax_info_defi id,
				dbax_info_cntx ic,
				dbax_desc_info di,
				dbax_inst_info ii
		where	id.codi_emex = @pCodiEmex
		and		id.codi_empr = @pCodiEmpr
		and		ic.codi_emex = id.codi_emex
		and		ic.codi_empr = id.codi_empr
		and		ic.codi_info = id.codi_info
		and		di.codi_info = id.codi_info
		and		di.codi_lang = 'es_ES'
		and		ii.codi_pers = @pCodiPers
		and		ii.corr_inst = @pCorrInst
		and		ii.vers_inst = @pVersInst
		and		ii.codi_info = ic.codi_info
		group by id.codi_info, di.desc_info, id.orde_info
		order by id.orde_info
	end
	else
	begin
		select	id.codi_info, isnull(de.desc_info, id.codi_info) as desc_info
		from	dbax_info_defi id 
			left join	dbax_desc_info de
			on id.codi_info = de.codi_info
		where	id.codi_emex = @pCodiEmex
		and		id.codi_empr = @pCodiEmpr
		order by id.orde_info
	end
END
GO
