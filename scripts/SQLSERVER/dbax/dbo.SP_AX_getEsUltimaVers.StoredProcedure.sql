set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[SP_AX_getEsUltimaVers] 
	@p_CodiPers  numeric(9,0),
	@p_CorrInst  numeric(10,0),
	@p_VersInst  numeric(5,0) as
BEGIN
	select count(*) 
	from
		(select 1 col1
		from dbax_inst_vers
		where codi_pers =@p_CodiPers
		and corr_inst = @p_CorrInst
		and vers_inst > @p_VersInst
		and vers_inst < 30
		union
		select 1 col1
		from	dbax_arch_pend
		where	codi_pers = @p_CodiPers
		and		corr_inst = @p_CorrInst
		and		vers_envi > @p_VersInst
		and		vers_envi < 30
		and		codi_erro in ('ETA','ECA','ECC')) V
END

