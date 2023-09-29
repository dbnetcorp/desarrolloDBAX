SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FU_AX_getValorPorFecha](
			@p_CodiPers numeric(10), 
			@p_CorrInst numeric(10), 
			@p_VersInst numeric(10), 
			@p_PrefConc varchar(256), 
			@p_CodiConc varchar(256), 
            @v_FechIni varchar(512),
            @v_FechFin varchar(512)
            ) 
            returns varchar(4000)
begin
/*
Devuelve un valor que este asociado a un contexto con las fechas entregadas
*/
	declare @v_valor varchar(4000)

	select	@v_valor =	isnull(max(valo_cntx),'')
    from	dbax_inst_conc ic,
			dbax_view_cntx ix
	where	ix.codi_pers = @p_CodiPers 
	and		ix.corr_inst = @p_CorrInst 
	and		ix.vers_inst = @p_VersInst 
	and		ix.fini_cntx = @v_FechIni
	and		isnull(ix.ffin_cntx,'') = isnull(@v_FechFin,'')
	and		ic.codi_pers = ix.codi_pers
	and		ic.corr_inst = ix.corr_inst
	and		ic.vers_inst = ix.vers_inst
	and		ic.pref_conc = @p_PrefConc 
	and		ic.codi_conc = @p_CodiConc 
	and		ic.codi_cntx = ix.codi_cntx
	
	if(len(@v_valor) = 0)
	begin
		select	@v_valor =	isnull(max(valo_cntx),'')
		from	dbax_inst_conc ic,
				dbax_view_cntx ix
		where	ix.codi_pers = @p_CodiPers 
		and		ix.corr_inst = @p_CorrInst 
		and		ix.vers_inst = @p_VersInst 
		and		(ix.fini_cntx = @v_FechIni or ix.fini_cntx = substring(convert(varchar,DATEADD(day,1,convert(datetime, @v_FechIni,20)),20),1,10))
		and		isnull(ix.fini_cntx,'') <= isnull(@v_FechFin,'')
		and		ic.codi_pers = ix.codi_pers
		and		ic.corr_inst = ix.corr_inst
		and		ic.vers_inst = ix.vers_inst
		and		ic.pref_conc = @p_PrefConc 
		and		ic.codi_conc = @p_CodiConc 
		and		ic.codi_cntx = ix.codi_cntx
	end

	if(len(@v_valor) = 0)
	begin
		select	@v_valor =	isnull(max(valo_cntx),'')
		from	dbax_inst_conc ic,
				dbax_view_cntx ix
		where	ix.codi_pers = @p_CodiPers 
		and		ix.corr_inst = @p_CorrInst 
		and		ix.vers_inst = @p_VersInst 
		and		ix.fini_cntx >= @v_FechFin
		and		isnull(ix.fini_cntx,'') = isnull(@v_FechFin,'')
		and		ic.codi_pers = ix.codi_pers
		and		ic.corr_inst = ix.corr_inst
		and		ic.vers_inst = ix.vers_inst
		and		ic.pref_conc = @p_PrefConc 
		and		ic.codi_conc = @p_CodiConc 
		and		ic.codi_cntx = ix.codi_cntx
	end

	return @v_valor
end
GO
