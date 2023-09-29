set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER procedure [dbo].[SP_AX_getInfoValoColu] 
	@p_CodiEmex  varchar(30),
	@p_CodiEmpr  numeric(9,0),
	@p_CodiPers  numeric(9,0),
	@p_CorrInst  numeric(10,0),
	@p_VersInst  numeric(5,0),
	@p_codi_info varchar(50),
	@p_finiCntx varchar(15),
	@p_ffinCntx varchar(15),
	@p_CodiMone varchar(16),
	@p_TipoInfo varchar(1) = 'C' as
BEGIN
	set dateformat ymd
	--Si version = 0, significa que debe calcularse la ultima version para la empresa/instancia
	if(@p_VersInst = 0)
	begin
		select	@p_VersInst = max(vers_inst) 
		from	dbax_inst_vers 
		where	codi_pers = @p_CodiPers 
		and		corr_inst = @p_CorrInst
		and     vers_inst < 30
	end

	declare @vFechaSini varchar(15)

	--No se por que, pero si no hago esto al invocar el SP para un periodo completo
	--obtengo filas de mas
	-- FUNCIONA, NO TOCAR! SI LO CAMBIAS TE CAERA UNA MALDICION Y MORIRAS EN 7 DIAS --
--	if(@p_ffinCntx='')
		set @vFechaSini = convert(varchar,(convert(numeric,substring(@p_finiCntx,1,4))-1)) + '-12-31'
--	else
--		set @vFechaSini = ''

	if(	@p_TipoInfo = 'C')
	begin	
		if(@p_ffinCntx!='')
		BEGIN
			--Para poder mostrar conceptos instant y duration en la misma columna
			--Se reemplaza por el siguiente select que tiene la estructura de
			--Conceptos nulos (interseccion entre conceptos vacios instant y conceptos vacios duration)
			--unidos con
			--conceptos instant
			--unidos con
			--conceptos duration
			--unidos con conceptos iniciales
			select	dbo.separaMiles(max(ic.valo_orig)) valo_cntx, ic.corr_conc, A.codi_conc, A.orde_conc
			from	dbax_info_conc A
					left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers
													and ix.corr_inst = @p_CorrInst 
													and ix.vers_inst = 1
													and ((ix.fini_cntx = @p_ffinCntx and ix.ffin_cntx = '') 
													or (ix.fini_cntx = replace(convert(varchar,DATEADD(day, 1, @p_ffinCntx),111),'/','-') and ix.ffin_cntx = '') 
													or   (ix.fini_cntx = @p_ffinCntx and ix.ffin_cntx is null))
													and not exists (select 1 
																	from dbax_inst_dicx id 
																	where id.codi_pers = ix.codi_pers
																	and   id.corr_inst = ix.corr_inst
																	and   id.vers_inst = ix.vers_inst
																	and   id.codi_cntx = ix.codi_cntx)
					 left join dbax_inst_conc ic on ic.codi_pers = ix.codi_pers
													and ic.corr_inst = ix.corr_inst
													and ic.vers_inst = ix.vers_inst
													and ic.pref_conc = A.pref_conc
													and ic.codi_conc = A.codi_conc
													and ic.codi_cntx = ix.codi_cntx
			where	((A.codi_emex = '0' AND A.codi_empr = 0) or (A.codi_emex = @p_CodiEmex AND A.codi_empr = @p_CodiEmpr))
			AND		A.codi_info = @p_codi_info
			AND		A.tipo_info = 'C'
			group by A.orde_conc, ic.corr_conc, A.codi_conc, A.orde_conc
			intersect
			select	dbo.separaMiles(max(ic.valo_orig)) valo_cntx, ic.corr_conc, A.codi_conc, A.orde_conc
			from	dbax_info_conc A
					left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers
													and ix.corr_inst = @p_CorrInst 
													and ix.vers_inst = 1
													and ((ix.fini_cntx = @p_finiCntx and ix.ffin_cntx = @p_ffinCntx) 
													or (ix.fini_cntx = replace(convert(varchar,DATEADD(day, 1, @p_finiCntx),111),'/','-') and ix.ffin_cntx = @p_ffinCntx))
													and not exists (select 1 
																	from dbax_inst_dicx id 
																	where id.codi_pers = ix.codi_pers
																	and   id.corr_inst = ix.corr_inst
																	and   id.vers_inst = ix.vers_inst
																	and   id.codi_cntx = ix.codi_cntx)
					 left join dbax_inst_conc ic on ic.codi_pers = ix.codi_pers
													and ic.corr_inst = ix.corr_inst
													and ic.vers_inst = ix.vers_inst
													and ic.pref_conc = A.pref_conc
													and ic.codi_conc = A.codi_conc
													and ic.codi_cntx = ix.codi_cntx
			where	((A.codi_emex = '0' AND A.codi_empr = 0) or (A.codi_emex = @p_CodiEmex AND A.codi_empr = @p_CodiEmpr))
			AND		A.codi_info = @p_codi_info
			AND		A.tipo_info = 'C'
			group by A.orde_conc, ic.corr_conc, A.codi_conc, A.orde_conc
			/*intersect
			select	dbo.separaMiles(max(ic.valo_orig)) valo_cntx, ic.corr_conc, A.codi_conc, A.orde_conc
			from	dbax_info_conc A
					left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers
													and ix.corr_inst = @p_CorrInst 
													and ix.vers_inst = 1
													and ((ix.fini_cntx = @vFechaSini and ix.ffin_cntx = '') 
													or (ix.fini_cntx = replace(convert(varchar,DATEADD(day, 1, @vFechaSini),111),'/','-') and ix.ffin_cntx = '') 
													or   (ix.fini_cntx = @vFechaSini and ix.ffin_cntx is null))
													and not exists (select 1 
																	from dbax_inst_dicx id 
																	where id.codi_pers = ix.codi_pers
																	and   id.corr_inst = ix.corr_inst
																	and   id.vers_inst = ix.vers_inst
																	and   id.codi_cntx = ix.codi_cntx)
					 left join dbax_inst_conc ic on ic.codi_pers = ix.codi_pers
													and ic.corr_inst = ix.corr_inst
													and ic.vers_inst = ix.vers_inst
													and ic.pref_conc = A.pref_conc
													and ic.codi_conc = A.codi_conc
													and ic.codi_cntx = ix.codi_cntx
			where	((A.codi_emex = '0' AND A.codi_empr = 0) or (A.codi_emex = @p_CodiEmex AND A.codi_empr = @p_CodiEmpr))
			AND		A.codi_info = @p_codi_info
			AND		A.tipo_info = 'C'
			group by A.orde_conc, ic.corr_conc, A.codi_conc, A.orde_conc*/
			union
			select	case @p_CodiMone 
					when 'MONE_ORIG' then dbo.separaMiles(max(ic.valo_orig)) 
					when 'MONE_LOCA' then dbo.separaMiles(max(ic.valo_cntx)) 
					when 'MONE_REFE' then dbo.separaMiles(max(ic.valo_refe)) collate Latin1_General_CS_AS
					when 'MONE_INTE' then dbo.separaMiles(max(ic.valo_inte)) collate Latin1_General_CS_AS END valo_cntx, 
					ic.corr_conc, A.codi_conc, A.orde_conc
			from	dbax_info_conc A
					left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers
													and ix.corr_inst = @p_CorrInst 
													and ix.vers_inst = 1
													and ((ix.fini_cntx = @p_ffinCntx and ix.ffin_cntx = '') 
													or (ix.fini_cntx = replace(convert(varchar,DATEADD(day, 1, @p_ffinCntx),111),'/','-') and ix.ffin_cntx = '') 
													or   (ix.fini_cntx = @p_ffinCntx and ix.ffin_cntx is null))
													and not exists (select 1 
																	from dbax_inst_dicx id 
																	where id.codi_pers = ix.codi_pers
																	and   id.corr_inst = ix.corr_inst
																	and   id.vers_inst = ix.vers_inst
																	and   id.codi_cntx = ix.codi_cntx),
					 dbax_inst_conc ic 		
			where	((A.codi_emex = '0' AND A.codi_empr = 0) or (A.codi_emex = @p_CodiEmex AND A.codi_empr = @p_CodiEmpr))
			AND		A.codi_info = @p_codi_info
			AND		A.tipo_info = 'C'
			and ic.pref_conc = A.pref_conc
			and ic.codi_conc = A.codi_conc
			and ic.codi_pers = ix.codi_pers
			and ic.corr_inst = ix.corr_inst
			and ic.vers_inst = ix.vers_inst
			and ic.codi_cntx = ix.codi_cntx		
			and	isnull(A.conc_sini,'0') != '1'
			group by A.orde_conc, ic.corr_conc, A.codi_conc, A.orde_conc
			union
			select	case @p_CodiMone 
					when 'MONE_ORIG' then dbo.separaMiles(max(ic.valo_orig)) 
					when 'MONE_LOCA' then dbo.separaMiles(max(ic.valo_cntx)) 
					when 'MONE_REFE' then dbo.separaMiles(max(ic.valo_refe)) collate Latin1_General_CS_AS
					when 'MONE_INTE' then dbo.separaMiles(max(ic.valo_inte)) collate Latin1_General_CS_AS END valo_cntx, 
					ic.corr_conc, A.codi_conc, A.orde_conc
			from	dbax_info_conc A
					left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers
													and ix.corr_inst = @p_CorrInst 
													and ix.vers_inst = 1
													and ((ix.fini_cntx = @p_finiCntx and ix.ffin_cntx = @p_ffinCntx) 
													or (ix.fini_cntx = replace(convert(varchar,DATEADD(day, 1, @p_finiCntx),111),'/','-') and ix.ffin_cntx = @p_ffinCntx))
													and not exists (select 1 
																	from dbax_inst_dicx id 
																	where id.codi_pers = ix.codi_pers
																	and   id.corr_inst = ix.corr_inst
																	and   id.vers_inst = ix.vers_inst
																	and   id.codi_cntx = ix.codi_cntx),
					 dbax_inst_conc ic						
			where	((A.codi_emex = '0' AND A.codi_empr = 0) or (A.codi_emex = @p_CodiEmex AND A.codi_empr = @p_CodiEmpr))
			AND		A.codi_info = @p_codi_info
			AND		A.tipo_info = 'C'
			and ic.pref_conc = A.pref_conc
			and ic.codi_conc = A.codi_conc
			and ic.codi_pers = ix.codi_pers
			and ic.corr_inst = ix.corr_inst
			and ic.vers_inst = ix.vers_inst
			and ic.codi_cntx = ix.codi_cntx		
			group by A.orde_conc, ic.corr_conc, A.codi_conc, A.orde_conc
			union
			select	case @p_CodiMone 
					when 'MONE_ORIG' then dbo.separaMiles(max(ic.valo_orig)) 
					when 'MONE_LOCA' then dbo.separaMiles(max(ic.valo_cntx)) 
					when 'MONE_REFE' then dbo.separaMiles(max(ic.valo_refe)) collate Latin1_General_CS_AS
					when 'MONE_INTE' then dbo.separaMiles(max(ic.valo_inte)) collate Latin1_General_CS_AS END valo_cntx, 
					ic.corr_conc, A.codi_conc, A.orde_conc
			from	dbax_info_conc A
					left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers 
													and ix.corr_inst = @p_CorrInst 
													and ix.vers_inst = 1
													and ((ix.fini_cntx = @vFechaSini and ix.ffin_cntx = @p_ffinCntx) 
													or (ix.fini_cntx = replace(convert(varchar,DATEADD(day, 1, @vFechaSini),111),'/','-') and ix.ffin_cntx = @p_ffinCntx) 
													or   (ix.fini_cntx = @vFechaSini and ix.ffin_cntx is null))
													and not exists (select 1 
																	from dbax_inst_dicx id 
																	where id.codi_pers = ix.codi_pers
																	and   id.corr_inst = ix.corr_inst
																	and   id.vers_inst = ix.vers_inst
																	and   id.codi_cntx = ix.codi_cntx),
					 dbax_inst_conc ic
			where	((A.codi_emex = '0' AND A.codi_empr = 0) or (A.codi_emex = @p_CodiEmex AND A.codi_empr = @p_CodiEmpr))
			AND		A.codi_info = @p_codi_info
			AND		A.tipo_info = 'C'
			and ic.pref_conc = A.pref_conc
			and ic.codi_conc = A.codi_conc
			and ic.codi_pers = ix.codi_pers
			and ic.corr_inst = ix.corr_inst
			and ic.vers_inst = ix.vers_inst
			and ic.codi_cntx = ix.codi_cntx	
			and	isnull(A.conc_sini,'0') = '1'
			group by A.orde_conc, ic.corr_conc, A.codi_conc, A.orde_conc
			order by A.orde_conc
		END
		ELSE if(@p_ffinCntx='')
		BEGIN
			select	case @p_CodiMone 
					when 'MONE_ORIG' then dbo.separaMiles(max(ic.valo_orig)) 
					when 'MONE_LOCA' then dbo.separaMiles(max(ic.valo_cntx)) 
					when 'MONE_REFE' then dbo.separaMiles(max(ic.valo_refe)) collate Latin1_General_CS_AS
					when 'MONE_INTE' then dbo.separaMiles(max(ic.valo_inte)) collate Latin1_General_CS_AS END valo_cntx, 
					ic.corr_conc,A.codi_conc, A.orde_conc
			from	dbax_info_conc A
					left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers 
													and ix.corr_inst = @p_CorrInst 
													and ix.vers_inst = @p_VersInst
													and ((ix.fini_cntx = @p_finiCntx and ix.ffin_cntx = @p_ffinCntx) 
													or (ix.fini_cntx = replace(convert(varchar,DATEADD(day, 1, @p_finiCntx),111),'/','-') and ix.ffin_cntx = @p_ffinCntx) 
													or   (ix.fini_cntx = @p_finiCntx and ix.ffin_cntx is null))
													and not exists (select 1 
																	from dbax_inst_dicx id 
																	where id.codi_pers = ix.codi_pers
																	and   id.corr_inst = ix.corr_inst
																	and   id.vers_inst = ix.vers_inst
																	and   id.codi_cntx = ix.codi_cntx)
					 left join dbax_inst_conc ic on ic.codi_pers = ix.codi_pers
													and ic.corr_inst = ix.corr_inst
													and ic.vers_inst = ix.vers_inst
													and ic.pref_conc = A.pref_conc
													and ic.codi_conc = A.codi_conc
													and ic.codi_cntx = ix.codi_cntx
													and	isnull(A.conc_sini,'0') != '1'
			where	((A.codi_emex = '0' AND A.codi_empr = 0) or (A.codi_emex = @p_CodiEmex AND A.codi_empr = @p_CodiEmpr))
			AND		A.codi_info = @p_codi_info
			AND		A.tipo_info = 'C'
			and	isnull(A.conc_sini,'0') != '1'
			group by A.codi_conc, A.orde_conc, ic.corr_conc
			union
			select	case @p_CodiMone 
					when 'MONE_ORIG' then dbo.separaMiles(max(ic.valo_orig)) 
					when 'MONE_LOCA' then dbo.separaMiles(max(ic.valo_cntx)) 
					when 'MONE_REFE' then dbo.separaMiles(max(ic.valo_refe)) collate Latin1_General_CS_AS
					when 'MONE_INTE' then dbo.separaMiles(max(ic.valo_inte)) collate Latin1_General_CS_AS END valo_cntx, 
					ic.corr_conc,A.codi_conc, A.orde_conc
			from	dbax_info_conc A
					left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers 
													and ix.corr_inst = @p_CorrInst 
													and ix.vers_inst = @p_VersInst
													and ((ix.fini_cntx = @vFechaSini and ix.ffin_cntx = @p_ffinCntx) 
													or (ix.fini_cntx = replace(convert(varchar,DATEADD(day, 1, @vFechaSini),111),'/','-') and ix.ffin_cntx = @p_ffinCntx) 
													or   (ix.fini_cntx = @vFechaSini and ix.ffin_cntx is null))
													and not exists (select 1 
																	from dbax_inst_dicx id 
																	where id.codi_pers = ix.codi_pers
																	and   id.corr_inst = ix.corr_inst
																	and   id.vers_inst = ix.vers_inst
																	and   id.codi_cntx = ix.codi_cntx)
					 left join dbax_inst_conc ic on ic.codi_pers = ix.codi_pers
													and ic.corr_inst = ix.corr_inst
													and ic.vers_inst = ix.vers_inst
													and ic.pref_conc = A.pref_conc
													and ic.codi_conc = A.codi_conc
													and ic.codi_cntx = ix.codi_cntx
													and	isnull(A.conc_sini,'0') = '1'
			where	((A.codi_emex = '0' AND A.codi_empr = 0) or (A.codi_emex = @p_CodiEmex AND A.codi_empr = @p_CodiEmpr))
			AND		A.codi_info = @p_codi_info
			AND		A.tipo_info = 'C'
			and	isnull(A.conc_sini,'0') = '1'
			group by A.codi_conc, A.orde_conc, ic.corr_conc
			order by A.orde_conc
		END
	else if(@p_TipoInfo = 'D')
	begin
		if(@p_CodiMone = 'MONE_ORIG')
		BEGIN
			select	dbo.separaMiles(max(ic.valo_orig)) valo_cntx, ic.corr_conc
			from	dbax_dime_conc A
					left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers 
													and ix.corr_inst = @p_CorrInst 
													and ix.vers_inst = @p_VersInst
													and ((ix.fini_cntx = @p_finiCntx and ix.ffin_cntx = @p_ffinCntx) 
													or (ix.fini_cntx = replace(convert(varchar,DATEADD(day, 1, @p_finiCntx),111),'/','-') and ix.ffin_cntx = @p_ffinCntx) 
													or   (ix.fini_cntx = @p_finiCntx and ix.ffin_cntx is null))
													and not exists (select 1 
																	from dbax_inst_dicx id 
																	where id.codi_pers = ix.codi_pers
																	and   id.corr_inst = ix.corr_inst
																	and   id.vers_inst = ix.vers_inst
																	and   id.codi_cntx = ix.codi_cntx)
					 left join dbax_inst_conc ic on ic.codi_pers = ix.codi_pers
													and ic.corr_inst = ix.corr_inst
													and ic.vers_inst = ix.vers_inst
													and ic.pref_conc = A.pref_conc
													and ic.codi_conc = A.codi_conc
													and ic.codi_cntx = ix.codi_cntx
			where	A.codi_dein = @p_codi_info
			group by A.orde_conc, ic.corr_conc
			order by A.orde_conc
		END
		END	
		ELSE IF(@p_CodiMone = 'MONE_LOCA')
		BEGIN
			select	dbo.separaMiles(max(ic.valo_cntx)) valo_cntx, ic.corr_conc
			from	dbax_dime_conc A
					left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers 
													and ix.corr_inst = @p_CorrInst 
													and ix.vers_inst = @p_VersInst
													and ((ix.fini_cntx = @p_finiCntx and ix.ffin_cntx = @p_ffinCntx) 
													or (ix.fini_cntx = replace(convert(varchar,DATEADD(day, 1, @p_finiCntx),111),'/','-') and ix.ffin_cntx = @p_ffinCntx) 
													or   (ix.fini_cntx = @p_finiCntx and ix.ffin_cntx is null))
													and not exists (select 1 
																	from dbax_inst_dicx id 
																	where id.codi_pers = ix.codi_pers
																	and   id.corr_inst = ix.corr_inst
																	and   id.vers_inst = ix.vers_inst
																	and   id.codi_cntx = ix.codi_cntx)
					 left join dbax_inst_conc ic on ic.codi_pers = ix.codi_pers
													and ic.corr_inst = ix.corr_inst
													and ic.vers_inst = ix.vers_inst
													and ic.pref_conc = A.pref_conc
													and ic.codi_conc = A.codi_conc
													and ic.codi_cntx = ix.codi_cntx
			where	A.codi_dein = @p_codi_info
			group by A.orde_conc, ic.corr_conc
			order by A.orde_conc
		END
		ELSE IF(@p_CodiMone = 'MONE_INTE')
		BEGIN
			select	dbo.separaMiles(max(ic.valo_inte)) valo_cntx, ic.corr_conc
			from	dbax_dime_conc A
					left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers 
													and ix.corr_inst = @p_CorrInst 
													and ix.vers_inst = @p_VersInst
													and ((ix.fini_cntx = @p_finiCntx and ix.ffin_cntx = @p_ffinCntx) 
													or (ix.fini_cntx = replace(convert(varchar,DATEADD(day, 1, @p_finiCntx),111),'/','-') and ix.ffin_cntx = @p_ffinCntx) 
													or   (ix.fini_cntx = @p_finiCntx and ix.ffin_cntx is null))
													and not exists (select 1 
																	from dbax_inst_dicx id 
																	where id.codi_pers = ix.codi_pers
																	and   id.corr_inst = ix.corr_inst
																	and   id.vers_inst = ix.vers_inst
																	and   id.codi_cntx = ix.codi_cntx)
					 left join dbax_inst_conc ic on ic.codi_pers = ix.codi_pers
													and ic.corr_inst = ix.corr_inst
													and ic.vers_inst = ix.vers_inst
													and ic.pref_conc = A.pref_conc
													and ic.codi_conc = A.codi_conc
													and ic.codi_cntx = ix.codi_cntx
			where	A.codi_dein = @p_codi_info
			group by A.orde_conc, ic.corr_conc
			order by A.orde_conc
		END
		ELSE IF(@p_CodiMone = 'MONE_REFE')
		BEGIN
			select	dbo.separaMiles(max(ic.valo_refe)) valo_cntx, ic.corr_conc
			from	dbax_dime_conc A
					left join dbax_inst_cntx ix on ix.codi_pers = @p_CodiPers 
													and ix.corr_inst = @p_CorrInst 
													and ix.vers_inst = @p_VersInst
													and ((ix.fini_cntx = @p_finiCntx and ix.ffin_cntx = @p_ffinCntx) 
													or (ix.fini_cntx = replace(convert(varchar,DATEADD(day, 1, @p_finiCntx),111),'/','-') and ix.ffin_cntx = @p_ffinCntx) 
													or   (ix.fini_cntx = @p_finiCntx and ix.ffin_cntx is null))
													and not exists (select 1 
																	from dbax_inst_dicx id 
																	where id.codi_pers = ix.codi_pers
																	and   id.corr_inst = ix.corr_inst
																	and   id.vers_inst = ix.vers_inst
																	and   id.codi_cntx = ix.codi_cntx)
					 left join dbax_inst_conc ic on ic.codi_pers = ix.codi_pers
													and ic.corr_inst = ix.corr_inst
													and ic.vers_inst = ix.vers_inst
													and ic.pref_conc = A.pref_conc
													and ic.codi_conc = A.codi_conc
													and ic.codi_cntx = ix.codi_cntx
			where	A.codi_dein = @p_codi_info
			group by A.orde_conc, ic.corr_conc
			order by A.orde_conc
		END
	end
END
GO