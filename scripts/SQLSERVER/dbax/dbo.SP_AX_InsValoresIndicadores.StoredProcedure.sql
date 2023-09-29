SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AX_InsValoresIndicadores] (
	@p_codi_pers numeric(9,0),
	@p_corr_inst numeric(10,0),
	@p_vers_inst numeric(5,0),
	@p_codi_conc varchar(256),
	@p_codi_cntx varchar(1000),
	@p_valo_cntx varchar(1000),
    @p_Codi_unit varchar(50)
	)as
BEGIN
	delete from dbax_inst_conc 
	where codi_pers= @p_codi_pers 
	and corr_inst = @p_corr_inst 
	and vers_inst = @p_vers_inst
	and	pref_conc = 'indi'
	and	codi_conc = @p_codi_conc
	and	codi_cntx = @p_codi_cntx

	insert dbax_inst_conc (codi_pers, corr_inst, vers_inst,pref_conc, codi_conc, codi_cntx, valo_cntx, codi_unit) 
	values (@p_codi_pers, @p_corr_inst, @p_vers_inst,'indi',@p_codi_conc,@p_codi_cntx,@p_valo_cntx,@p_Codi_unit)
END
GO
