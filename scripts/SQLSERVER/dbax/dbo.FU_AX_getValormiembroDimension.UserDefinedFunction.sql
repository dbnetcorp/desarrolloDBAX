SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FU_AX_getValormiembroDimension](
			@p_CodiPers numeric(10),  --código de la empresa
			@p_CorrInst numeric(10),  -- instancia (período a consultar)
			@p_VersInst numeric(10),  -- verción de la carga
			@p_PrefConc varchar(256), -- prefijo del conceto
			@p_CodiConc varchar(256), -- código del concepto
            @v_FechIni varchar(512),  -- período de inicio
            @v_FechFin varchar(512),  -- período final
            @v_codi_axis varchar(256),-- código de eje
            @v_codi_memb varchar(256),-- código del miembro
            @v_sald_ini varchar(10),  -- ver si es de ininio o no
            @v_tipo_peri varchar(50), -- tipo de período
            @V_periodo_InicioCambiado varchar(100) -- período cambiado  
            ) 
            returns varchar(4000)

begin
declare @valor_cntx varchar(100)
if (  @v_sald_ini = 'I')
	begin

--		set @valor_cntx = (select	top 1 valo_cntx
--		from	dbax_inst_conc ic,
--				dbax_inst_cntx ix,
--				dbax_inst_dicx id
--		where	ix.codi_pers = @p_CodiPers 
--		and		ix.corr_inst = @p_CorrInst 
--		and		ix.vers_inst = @p_VersInst
--		and		(ix.fini_cntx = @V_periodo_InicioCambiado -- <-- Fecha inicial de columna
--			     or ix.fini_cntx = @v_FechIni)
--		and		ix.ffin_cntx is null
--		and		ic.codi_pers = ix.codi_pers
--		and		ic.corr_inst = ix.corr_inst
--		and		ic.vers_inst = ix.vers_inst
--		and		ic.pref_conc = @p_PrefConc 
--		and		ic.codi_conc = @p_CodiConc 
--		and		ic.codi_cntx = ix.codi_cntx
--		--and		id.codi_pers = ix.codi_pers
--		--and		id.corr_inst = ix.corr_inst
--		--and		id.vers_inst = ix.vers_inst
--		--and		id.codi_cntx = ix.codi_cntx
--		and		isnull(id.codi_axis,'') = isnull(@v_codi_axis,'')
--		and		isnull(id.codi_memb,'') = isnull(@v_codi_memb,'')
--		order by ic.codi_conc, ix.fini_cntx asc)

		set @valor_cntx = (select	top 1 valo_cntx
		from	dbax_inst_conc ic,
				dbax_inst_cntx ix
				left join dbax_inst_dicx id
				on ix.codi_pers = id.codi_pers
				and	ix.corr_inst = id.corr_inst
				and ix.vers_inst = id.vers_inst
				and	ix.codi_cntx = id.codi_cntx
		where	ic.codi_pers = @p_CodiPers
		and		ic.corr_inst = @p_CorrInst 
		and		ic.vers_inst = @p_VersInst 
		and		ix.codi_pers = ic.codi_pers
		and		ix.corr_inst = ic.corr_inst
		and		ix.vers_inst = ic.vers_inst
		and		(ix.fini_cntx = @V_periodo_InicioCambiado -- <-- Fecha inicial de columna
				or ix.fini_cntx = @v_FechIni)
		and		ix.ffin_cntx is null
		and		ic.pref_conc = @p_PrefConc 
		and		ic.codi_conc = @p_CodiConc 
		and		ic.codi_cntx = ix.codi_cntx
		and		isnull(id.codi_axis,'') = isnull(@v_codi_axis,'')
		and		isnull(id.codi_memb,'') = isnull(@v_codi_memb,'')
		order by ic.codi_conc, ix.fini_cntx asc)


	end
else
	begin
         if(@v_tipo_peri = 'duration')
            begin

				set @valor_cntx = (select	top 1 valo_cntx
				from	dbax_inst_conc ic,
						dbax_inst_cntx ix
						left join dbax_inst_dicx id
						on ix.codi_pers = id.codi_pers
						and	ix.corr_inst = id.corr_inst
						and ix.vers_inst = id.vers_inst
						and	ix.codi_cntx = id.codi_cntx
				where	ic.codi_pers = @p_CodiPers
				and		ic.corr_inst = @p_CorrInst 
				and		ic.vers_inst = @p_VersInst 
				and		ix.codi_pers = ic.codi_pers
				and		ix.corr_inst = ic.corr_inst
				and		ix.vers_inst = ic.vers_inst
				and		ix.fini_cntx = @v_FechIni
				and		ix.ffin_cntx = @v_FechFin
				--and		isnull(ix.ffin_cntx,'') = isnull(@v_FechFin,'')
				--and		ix.ffin_cntx is null
				and		ic.pref_conc = @p_PrefConc 
				and		ic.codi_conc = @p_CodiConc 
				and		ic.codi_cntx = ix.codi_cntx
				and		isnull(id.codi_axis,'') = isnull(@v_codi_axis,'')
				and		isnull(id.codi_memb,'') = isnull(@v_codi_memb,'')
				order by ic.codi_conc, ix.fini_cntx asc)

			end
        if(@v_tipo_peri = 'instant')
			begin

				set @valor_cntx = (select	top 1 valo_cntx
				from	dbax_inst_conc ic,
						dbax_inst_cntx ix
						left join dbax_inst_dicx id
						on ix.codi_pers = id.codi_pers
						and	ix.corr_inst = id.corr_inst
						and ix.vers_inst = id.vers_inst
						and	ix.codi_cntx = id.codi_cntx
				where	ic.codi_pers = @p_CodiPers
				and		ic.corr_inst = @p_CorrInst 
				and		ic.vers_inst = @p_VersInst 
				and		ix.codi_pers = ic.codi_pers
				and		ix.corr_inst = ic.corr_inst
				and		ix.vers_inst = ic.vers_inst
				and		ix.fini_cntx =  @v_FechFin -- <-- Final columna
				and		ix.ffin_cntx is null
				and		ic.pref_conc = @p_PrefConc 
				and		ic.codi_conc = @p_CodiConc 
				and		ic.codi_cntx = ix.codi_cntx
				and		isnull(id.codi_axis,'') = isnull(@v_codi_axis,'')
				and		isnull(id.codi_memb,'') = isnull(@v_codi_memb,'')
				order by ic.codi_conc, ix.fini_cntx asc)
			end 
	end 

return @valor_cntx

end -- fin función
GO
