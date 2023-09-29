ALTER TABLE [dbax_defi_cntx] ADD [desc_cntx] [varchar](100) NULL
GO
update [dbax_defi_cntx] set [desc_cntx] = codi_cntx
GO
----
drop table [dbo].[dbax_defi_grup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_defi_grup](
	[codi_grup] [varchar](50) NOT NULL,
	[desc_grup] [varchar](100) NULL,
 CONSTRAINT [PK_dbax_defi_grup] PRIMARY KEY CLUSTERED 
(
	[codi_grup] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
----
ALTER TABLE [dbax_defi_pers] ADD [codi_grup] [varchar](50) NULL
GO
ALTER TABLE [dbax_defi_pers] ADD [codi_segm] [varchar](50) NULL
GO
----
ALTER TABLE [dbax_defi_cntx] ADD [orde_cntx] [numeric](3,0) NULL
GO

update dbax_defi_cntx set orde_cntx = 1 where codi_cntx = 'CierreTrimestreActual'
update dbax_defi_cntx set orde_cntx = 2 where codi_cntx = 'TrimestreAcumuladoActual'
update dbax_defi_cntx set orde_cntx = 3 where codi_cntx = 'Cierre Trimestre Anterior'
update dbax_defi_cntx set orde_cntx = 4 where codi_cntx = 'TrimestreAcumuladoAnterior'
update dbax_defi_cntx set orde_cntx = 5 where codi_cntx = 'TrimestreActual'
update dbax_defi_cntx set orde_cntx = 6 where codi_cntx = 'TrimestreAnterior'
update dbax_defi_cntx set orde_cntx = 7 where codi_cntx = 'CierreAnualAnterior'
update dbax_defi_cntx set orde_cntx = 8 where codi_cntx = 'CierreAnualPrevioAnterior'

----
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_grup_pers](
	[codi_grup] [varchar](50) NOT NULL,
	[codi_pers] [numeric](9, 0) NOT NULL,
 CONSTRAINT [PK_dbax_grup_pers] PRIMARY KEY CLUSTERED 
(
	[codi_grup] ASC,
	[codi_pers] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
----
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_tabl_temp](
	[codi_colu1] [varchar](256) NOT NULL,
	[codi_colu2] [varchar](256) NOT NULL,
	[codi_colu3] [varchar](256) NULL,
	[codi_colu4] [varchar](256) NULL,
	[codi_colu5] [varchar](256) NULL,
	[codi_colu6] [varchar](256) NULL,
	[tipo_dato] [varchar](2) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
----
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[dbax_view_inem]
AS
SELECT     codi_colu1 AS codi_pers, codi_colu2 AS corr_inst, tipo_dato
FROM         dbo.dbax_tabl_temp
WHERE     (tipo_dato = 'IE')
GO

----
drop function [dbo].[FU_AX_getValorPorFecha]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[FU_AX_getValorPorFecha](
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
	
	if(@v_valor = '')
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

	return @v_valor
end
GO
----
drop procedure [dbo].[SP_AX_Get_informe_contexto_grilla]
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AX_Get_informe_contexto_grilla](
@p_codi_informe varchar(100))
as
BEGIN
	select	ic.codi_inct, 
			ic.orde_cntx, 
			ic.codi_cntx, 
			ic.codi_info,
			dc.desc_cntx
	from	dbax_info_cntx ic,
			dbax_defi_cntx dc
	where	ic.codi_info = @p_codi_informe
	and		ic.codi_cntx = dc.codi_cntx
	ORDER BY ic.orde_cntx
END
GO
----
drop procedure [dbo].[SP_AX_getCodiFech]
GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getCodiFech] 
	@p_TipoFech  varchar(1)
as
BEGIN
	select '0' codi_fech, 'Seleccionar' desc_fech
	union
	select codi_fech as codi_fech, desc_fech as desc_fech 
	from dbax_codi_fech 
	where tipo_fech = @p_TipoFech
END
GO
----
drop procedure [dbo].[SP_AX_getContextos]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getContextos]
	@pCodiEmex varchar(30),
	@pCodiEmpr varchar(100),
	@pCorrInst numeric(6,0),
	@pCodiInfo varchar(50) = ''
as
BEGIN
	if(@pCorrInst = 0)
	begin
		select	distinct dc.codi_cntx,
				dc.desc_cntx,
				dc.diai_cntx as codi_diai, 
				dbo.FU_AX_getDescFech(diai_cntx) diai_cntx, 
				dc.anoi_cntx as codi_anoi,
				dbo.FU_AX_getDescFech(anoi_cntx) anoi_cntx,
				dc.diat_cntx as codi_diat,
				dbo.FU_AX_getDescFech(diat_cntx) diat_cntx,
				dc.anot_cntx as codi_anot,
				dbo.FU_AX_getDescFech(anot_cntx) anot_cntx,
				null fini_cntx,
				null ffin_cntx,
				isnull(ic.orde_cntx,9999) as 'orde_cntx',
				dc.orde_cntx as 'dc.orde_cntx'
		from	dbax_defi_cntx dc
				left join dbax_info_cntx ic
				on dc.codi_cntx = ic.codi_cntx
				and	ic.codi_info like @pCodiInfo
				and	ic.codi_emex = @pCodiEmex
				and ic.codi_empr = @pCodiEmpr
		where	dc.codi_emex = @pCodiEmex
		and		dc.codi_empr = @pCodiEmpr
		order by isnull(ic.orde_cntx,9999), dc.orde_cntx
	end
	else
	begin
		select	distinct dc.codi_cntx, 
				dc.desc_cntx,
				dc.diai_cntx as codi_diai, 
				dbo.FU_AX_getDescFech(diai_cntx) diai_cntx, 
				dc.anoi_cntx as codi_anoi,
				dbo.FU_AX_getDescFech(anoi_cntx) anoi_cntx,
				dc.diat_cntx as codi_diat,
				dbo.FU_AX_getDescFech(diat_cntx) diat_cntx,
				dc.anot_cntx as codi_anot,
				dbo.FU_AX_getDescFech(anot_cntx) anot_cntx,
				dbo.FU_AX_getFechas(@pCorrInst , diai_cntx, anoi_cntx) fini_cntx,
				dbo.FU_AX_getFechas(@pCorrInst , diat_cntx, anot_cntx) ffin_cntx,
				isnull(ic.orde_cntx,9999) as 'orde_cntx',
				dc.orde_cntx as 'dc.orde_cntx'
		from	dbax_defi_cntx dc
				left join dbax_info_cntx ic
				on dc.codi_cntx = ic.codi_cntx
				and	ic.codi_info like @pCodiInfo
				and	ic.codi_emex = @pCodiEmex
				and ic.codi_empr = @pCodiEmpr
		where	dc.codi_emex = @pCodiEmex
		and		dc.codi_empr = @pCodiEmpr
		order by isnull(ic.orde_cntx,9999), dc.orde_cntx
	end
END
GO
----
drop procedure [dbo].[SP_AX_GetContextosIndicadorEmpresa]
GO

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
----
drop procedure [dbo].[SP_AX_GetDetaIndicadores]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetDetaIndicadores](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiIndi varchar(100)) as
BEGIN


select  de.letr_vari,de.pref_conc, de.codi_conc, de.codi_cntx, ct.desc_cntx, ct.diai_cntx, ct.anoi_cntx, ct.diat_cntx, ct.anot_cntx
from dbax_form_deta de, dbax_defi_cntx ct  
where 
de.codi_cntx =ct.codi_cntx
and de.codi_emex = @p_CodiEmex 
and de.codi_empr = @p_CodiEmpr  
and de.codi_indi = @p_CodiIndi 

END
GO
----
drop procedure [dbo].[SP_AX_getEmpresaConFiltro]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getEmpresaConFiltro](
@pCodiEmex varchar(30),
@pCodiEmpr numeric (9,0),
@pDescripcion varchar(100),
@pGrupo varchar(100),
@pTipoDesc varchar(100) = 'P'
)
as
BEGIN
	/*	
		@pTipoDesc = 'D' se devuelve descripcion "por defecto", 
		@pTipoDesc = 'P' devuelve descripcion por defecto y personalizada
		@pTipoDesc  = 'EM' SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN
	*/
	if(@pTipoDesc = 'P') -- TODAS LAS EMPRESAS PARA COMBOBOX
		begin
         if ( @pGrupo = '')
            begin
				select distinct dp.codi_pers as codi_pers,
								'[' + convert(varchar,dp.codi_pers) + '] ' + isnull(dp.desc_pers,'') as desc_pers,
								dh.desc_empr as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								ds.desc_segm as desc_segm,
								dp.codi_segm as codi_segm
				from	dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and	dh.codi_empr = @pCodiEmpr 
					and	dp.codi_pers = dh.codi_pers
						left join dbax_defi_grup dg
						on	dg.codi_grup = dp.codi_grup
							left join dbax_defi_segm ds
							on	ds.codi_segm = dp.codi_segm
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or dh.desc_empr like '%' + @pDescripcion + '%' 
						or dp.desc_pers like '%' + @pDescripcion + '%')
		    end
          else
            begin
				select distinct dp.codi_pers as codi_pers,
								'[' + convert(varchar,dp.codi_pers) + '] ' + isnull(dp.desc_pers,'') as desc_pers,
								dh.desc_empr as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								ds.desc_segm as desc_segm,
								dp.codi_segm as codi_segm
				from	dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and	dh.codi_empr = @pCodiEmpr 
					and	dp.codi_pers = dh.codi_pers
						left join dbax_defi_grup dg
						on	dg.codi_grup = dp.codi_grup
							left join dbax_defi_segm ds
							on	ds.codi_segm = dp.codi_segm
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or dh.desc_empr like '%' + @pDescripcion + '%' 
						or dp.desc_pers like '%' + @pDescripcion + '%')
				and		dp.codi_grup = dg.codi_grup
				and		dp.codi_grup = @pGrupo
            end
		end
	else

	if(@pTipoDesc = 'EM') --TODAS LAS EMPRESAS PARA GRILLA
		begin
		if ( @pGrupo = '')
            begin
				select distinct dp.codi_pers as codi_pers,
							'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
							dh.desc_empr as desc_peho 
				from dbax_defi_pers dp 
				left join dbax_defi_peho dh 
					on dh.codi_emex = @pCodiEmex 
					and dh.codi_empr = @pCodiEmpr 
					and dp.codi_pers = dh.codi_pers 
				where dp.codi_pers like '%' + @pDescripcion + '%'
				union
				select distinct dp.codi_pers as codi_pers, '[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
								dh.desc_empr as desc_peho 
				from dbax_defi_pers dp left join dbax_defi_peho dh on dh.codi_emex = @pCodiEmex 
				and dh.codi_empr = @pCodiEmpr 
				and dp.codi_pers = dh.codi_pers 
				where dp.desc_pers like '%' + @pDescripcion + '%' or dh.desc_empr like '%' + @pDescripcion + '%'
			end
        else
            begin
				select distinct dp.codi_pers as codi_pers,
								'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
								dh.desc_empr as desc_peho 
				from	dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and	dh.codi_empr = @pCodiEmpr 
					and	dp.codi_pers = dh.codi_pers 
				where	dp.codi_pers like '%' + @pDescripcion + '%'
				and		dp.codi_pers in (select codi_pers from dbax_grup_pers where codi_grup = @pGrupo )
				union
				select distinct dp.codi_pers as codi_pers, '[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
								dh.desc_empr as desc_peho 
				from	dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and	dh.codi_empr = @pCodiEmpr 
					and	dp.codi_pers = dh.codi_pers 
				where dp.codi_pers in (select codi_pers from dbax_grup_pers where codi_grup = @pGrupo )
				and dp.desc_pers like '%' + @pDescripcion + '%' or dh.desc_empr like '%' + @pDescripcion + '%'			
            end
		end
    else
		begin  --TODAS LAS EMPRESAS CON MAS  DE UNA VERSIÓN
          if ( @pGrupo = '')
            begin
				select distinct dp.codi_pers as codi_pers,
				'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
				dh.desc_empr as desc_peho 
				from dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and dh.codi_empr = @pCodiEmpr 
					and dp.codi_pers = dh.codi_pers 
				where dp.codi_pers like '%' + @pDescripcion + '%'
				and dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1')
				union
				select distinct dp.codi_pers as codi_pers, '[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
				dh.desc_empr as desc_peho 
				from	dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and	dh.codi_empr = @pCodiEmpr 
					and	dp.codi_pers = dh.codi_pers 
				where	dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1') 
				and		dp.desc_pers like '%' + @pDescripcion + '%' or dh.desc_empr like '%' + @pDescripcion + '%'
            end
          else
            begin
				select distinct dp.codi_pers as codi_pers,
				'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
				dh.desc_empr as desc_peho 
				from dbax_defi_pers dp 
					left join dbax_defi_peho dh 
					on	dh.codi_emex = @pCodiEmex 
					and dh.codi_empr = @pCodiEmpr 
					and dp.codi_pers = dh.codi_pers 
				where	dp.codi_pers like '%' + @pDescripcion + '%'
				and		dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1')
				and		dp.codi_pers in (select codi_pers from dbax_grup_pers where codi_grup = @pGrupo )
				union
				select distinct dp.codi_pers as codi_pers, '[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
								dh.desc_empr as desc_peho 
				from	dbax_defi_pers dp left join dbax_defi_peho dh on dh.codi_emex = @pCodiEmex 
				and		dh.codi_empr = @pCodiEmpr 
				and		dp.codi_pers = dh.codi_pers 
				where	dp.codi_pers in (select codi_pers from dbax_grup_pers where codi_grup = @pGrupo )
				and		dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1') 
				and		dp.desc_pers like '%' + @pDescripcion + '%' or dh.desc_empr like '%' + @pDescripcion + '%'
            end 
		end
END
GO
----
drop procedure [dbo].[SP_AX_getEmpresaPorGrupoSegmento]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getEmpresaPorGrupoSegmento](
@pCodiEmex varchar(30),
@pCodiEmpr numeric (9,0),
@pDescripcion varchar(100),
@pGrupo varchar(50),
@pSegmento varchar(50),
@pTipoDesc varchar(100) = 'P'
)
as
BEGIN
	/*	
		@pTipoDesc = 'D' se devuelve descripcion "por defecto", 
		@pTipoDesc = 'P' devuelve descripcion por defecto y personalizada
		@pTipoDesc  = 'C' SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN
	*/
	declare @vComodinGrup varchar(1)
	declare @vComodinSegm varchar(1)
	set @vComodinGrup = '%'
	set @vComodinSegm = '%'

	if ( @pGrupo != '')
	begin
		set @vComodinGrup = ''
	end

	if ( @pSegmento != '')
	begin
		set @vComodinSegm = ''
	end

	if(@pTipoDesc = 'P') -- TODAS LAS EMPRESAS PARA COMBOBOX
	begin
		select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm
		from	(select distinct dp.codi_pers as codi_pers,
								'[' + convert(varchar,dp.codi_pers) + '] ' + isnull(dp.desc_pers,'') as desc_pers,
								dh.desc_empr as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								dp.codi_segm as codi_segm
				from	dbax_defi_pers dp 
							left join dbax_defi_peho dh 
							on	dh.codi_emex = @pCodiEmex 
							and	dh.codi_empr = @pCodiEmpr 
							and	dp.codi_pers = dh.codi_pers
								left join dbax_defi_grup dg
								on	dg.codi_grup = dp.codi_grup,
						dbax_inst_docu id
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or dh.desc_empr like '%' + @pDescripcion + '%' 
						or dp.desc_pers like '%' + @pDescripcion + '%')
				and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
				and		dp.codi_pers = id.codi_pers) v
		left join dbax_defi_segm ds
			on v.codi_segm = ds.codi_segm
		where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
	end

	if(@pTipoDesc = 'C') -- SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN (para grilla de diferencias)
		begin

			select distinct dp.codi_pers as codi_pers,
			'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
			dh.desc_empr as desc_peho 
			from dbax_defi_pers dp left join dbax_defi_peho dh on dh.codi_emex = @pCodiEmex 
			and dh.codi_empr = @pCodiEmpr 
			and dp.codi_pers = dh.codi_pers 
			where dp.codi_pers like '%' + @pDescripcion + '%'
			and dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1')
			union
			select distinct dp.codi_pers as codi_pers, '[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
			dh.desc_empr as desc_peho 
			from dbax_defi_pers dp left join dbax_defi_peho dh on dh.codi_emex = @pCodiEmex 
			and dh.codi_empr = @pCodiEmpr 
			and dp.codi_pers = dh.codi_pers 
			where 
			dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1') 
			and dp.desc_pers like '%' + @pDescripcion + '%' or dh.desc_empr like '%' + @pDescripcion + '%'
	end

END
GO
----
drop procedure [dbo].[SP_AX_GetFechaCntx]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_GetFechaCntx](
@Codi_inst varchar(30),
@p_DiaMes varchar(50),
@p_Ano varchar(50))	
AS
BEGIN
	select dbo.FU_AX_getFechas(@Codi_inst , @p_DiaMes, @p_Ano) AS Fecha
END
GO
----
DROP procedure [dbo].[SP_AX_getFechaContexto]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getFechaContexto]
	@CodiEmex varchar(30),
	@CodiEmpr numeric(9,0),
	@CorrInst numeric(6,0),
	@CodiCntx varchar(50)
as
BEGIN
	select	codi_cntx, 
			dbo.FU_AX_getFechas(@CorrInst, dc.diai_cntx, dc.anoi_cntx) fini_cntx, 
			dbo.FU_AX_getFechas(@CorrInst, dc.diat_cntx, dc.anot_cntx) ffin_cntx 
	from	dbax_defi_cntx dc
	where	codi_emex = @CodiEmex
	and		codi_empr = @CodiEmpr
	and		codi_cntx = @CodiCntx
END
GO
----
drop procedure [dbo].[SP_AX_getGrupos]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getGrupos] 
as
BEGIN
	select '' as codi_grup, '' as desc_grup, '1'
	union
	select codi_grup, desc_grup, 'n' from dbax_defi_grup order by 3, 2
END
GO
----
drop procedure [dbo].[SP_AX_getInformesContextos]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getInformesContextos ]
	@p_CodiEmex varchar(30),
	@p_CodiEmpr varchar(100),
	@p_CorrInst numeric(10,0),
	@p_CodiInfo varchar(50)
as
BEGIN
	select	dc.codi_cntx, 
			dc.diai_cntx, dc.anoi_cntx,
			dc.diat_cntx, dc.anot_cntx,
			dbo.FU_AX_getFechas(@p_CorrInst, dc.diai_cntx, dc.anoi_cntx) fini_cntx, 
			dbo.FU_AX_getFechas(@p_CorrInst, dc.diat_cntx, dc.anot_cntx) ffin_cntx,
			dc.desc_cntx,
			ic.orde_cntx
	from	dbax_defi_cntx dc,
			dbax_info_cntx ic
	where	dc.codi_emex = @p_CodiEmex
	and		dc.codi_empr = @p_CodiEmpr
	and		ic.codi_emex = dc.codi_emex
	and		ic.codi_empr = dc.codi_empr
	and		ic.codi_info = @p_CodiInfo
	and		ic.codi_cntx = dc.codi_cntx
	order by ic.orde_cntx
END
GO
----
drop procedure [dbo].[SP_AX_getInformesUsables]
GO

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
----
drop procedure [dbo].[SP_AX_getInfoValoColu]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getInfoValoColu] 
	@p_CodiEmex  varchar(30),
	@p_CodiEmpr  numeric(9,0),
	@p_CodiPers  numeric(9,0),
	@p_CorrInst  numeric(10,0),
	@p_VersInst  numeric(5,0),
	@p_codi_info varchar(50),
	@p_finiCntx varchar(15),
	@p_ffinCntx varchar(15) as

BEGIN
	--Si version = 0, significa que debe calcularse la ultima version para la empresa/instancia
	if(@p_VersInst = 0)
	begin
		select @p_VersInst = max(vers_inst) from dbax_inst_vers where codi_pers = @p_CodiPers and corr_inst = @p_CorrInst
	end
	
	select	dbo.separaMiles(dbo.FU_AX_getValorPorFecha(@p_CodiPers,@p_CorrInst,@p_VersInst,B.pref_conc,B.codi_conc,@p_finiCntx,@p_ffinCntx))
	from	dbax_info_conc A, 
			dbax_defi_conc B, 
			dbax_desc_conc D
	where	A.codi_emex = @p_CodiEmex
	AND		A.codi_empr = @p_CodiEmpr
	AND		A.codi_info = @p_codi_info
	AND A.pref_conc = B.pref_conc
	AND A.codi_conc = B.codi_conc
	AND	B.pref_conc = D.pref_conc
	AND B.codi_conc = D.codi_conc
	order by A.orde_conc
END
GO
----
drop procedure [dbo].[SP_AX_getInfoValoColuDimension]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getInfoValoColuDimension] 
	@p_CodiPers  numeric(9,0),
	@p_CorrInst  numeric(10,0),
	@p_VersInst  numeric(5,0),
	@p_codi_info varchar(50),
	@p_desc_miemb varchar(256),
	@p_dimension varchar(256),
    @p_tipo_memb varchar(256)
 as

BEGIN
declare @V_eje varchar(256)
declare @V_periodo_Inicio varchar(50)
declare @V_periodo_InicioCambiado varchar(50)
declare @V_periodo_Final varchar(50)
------------------------------------------------------------------------------------------------------
-- obtenciòn de eje por dimension
set @V_eje =(select dd.pref_axis + ':' + dd.codi_axis
			from dbax_dime_diax dd,
			dbax_defi_conc dc
			where  dd.codi_dein = @p_codi_info
			and    dd.codi_dime = @p_dimension
			and    dd.codi_axis = dc.codi_conc)
-------------------------------------------------------------------------------------------------------
print @V_eje 
-- período de inicio  termino de la dimension por informe ---------------------------------------------
   --INICIAL
SET @V_periodo_Inicio =(select dbo.FU_AX_getFechas(@p_CorrInst,diai_actu, anoi_actu) as período_inicial
			            from 
						dbax_dime_cntx
						where codi_fcdi = (select codi_fcdi 
										   from dbax_dime_defi
			   							   where codi_dime = @p_dimension
										   and codi_dein = @p_codi_info))

--SELECT DATEADD(year,DATEDIFF(year, 0, GETDATE()),0); PRIMER DIA DEL AÑO
print @V_periodo_Inicio
 IF ( @V_periodo_Inicio = '2012-01-01') 
	BEGIN                                

     SET @V_periodo_InicioCambiado  = (SELECT convert(varchar,DATEADD(DAY, -1, @V_periodo_Inicio), 23))         
	END

print @V_periodo_InicioCambiado

   -- FINAL
SET @V_periodo_Final =(select  dbo.FU_AX_getFechas(@p_CorrInst,diat_actu, anot_actu) as período_termino
						from 
						dbax_dime_cntx
						where codi_fcdi = (select codi_fcdi 
										   from dbax_dime_defi
			   							   where codi_dime = @p_dimension
										   and codi_dein = @p_codi_info))
print @V_periodo_Final
------------------------------------------------------------------------------------
print  @p_tipo_memb 

-- obtencion de los conceptos y valores -------------------------------------------------------
if( @p_tipo_memb = 'dimension-default')
	begin
		select 
		dbo.separaMiles(dbo.FU_AX_getValormiembroDimension(@p_CodiPers,
															@p_CorrInst,
															@p_VersInst,
															dc.pref_conc ,
															dc.codi_conc,
															@V_periodo_Inicio,
															@V_periodo_Final,
															null,
															null,
															dc.sald_ini,
															de.tipo_peri,
															@V_periodo_InicioCambiado)) as valo_cntx
		from 
		dbax_dime_conc dc,
		dbax_desc_conc des,
		dbax_defi_conc de
		where 
		dc.codi_dein = @p_codi_info
		and dc.codi_dime = @p_dimension
		and dc.codi_conc = des.codi_conc
		and des.codi_conc = de.codi_conc
		and dc.codi_conc = de.codi_conc
		and dc.pref_conc = des.pref_conc
		and dc.pref_conc = de.pref_conc
		and des.pref_conc = de.pref_conc
		order by dc.orde_conc
	end
else -- domain-member
	begin
		select 
		dbo.separaMiles(dbo.FU_AX_getValormiembroDimension(@p_CodiPers,
															@p_CorrInst,
															@p_VersInst,
															dc.pref_conc ,
															dc.codi_conc,
															@V_periodo_Inicio,
															@V_periodo_Final,
															@V_eje,
															@p_desc_miemb,
															dc.sald_ini,
															de.tipo_peri,
															@V_periodo_InicioCambiado)) as valo_cntx
		from 
		dbax_dime_conc dc,
		dbax_desc_conc des,
		dbax_defi_conc de
		where 
		dc.codi_dein = @p_codi_info
		and dc.codi_dime = @p_dimension
		and dc.codi_conc = des.codi_conc
		and des.codi_conc = de.codi_conc
		and dc.codi_conc = de.codi_conc
		and dc.pref_conc = des.pref_conc
		and dc.pref_conc = de.pref_conc
		and des.pref_conc = de.pref_conc
		order by dc.orde_conc
	end
---------------------------------------------------------------------------------------------
END
GO
----
drop procedure [dbo].[SP_AX_GetListaIndicadoresEmpresa]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetListaIndicadoresEmpresa](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
    @p_Codi_indi varchar(100)) as
BEGIN
if(  @p_Codi_indi = '')
	begin
		select	codi_indi as Nombre, 
				tipo_conc as Tipo, 
				desc_indi as Descripción, 
				form_indi as Fórmula
		from	dbax_form_enca
		where	codi_emex = @p_CodiEmex
		and		codi_empr = @p_CodiEmpr
	end
else
	begin
		select	codi_indi as Nombre, 
				tipo_conc as Tipo, 
				desc_indi as Descripción, 
				form_indi as Fórmula
		from	dbax_form_enca
		where	codi_emex = @p_CodiEmex
		and		codi_empr = @p_CodiEmpr
		and     codi_indi = @p_Codi_indi 
	end
END
GO
----
drop procedure [dbo].[SP_AX_getProcesosPendientes]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_getProcesosPendientes] 
AS
BEGIN
	select codi_proc,
    prog_proc, 
    args_proc 
    from   dbax_dbne_proc 
    where  esta_proc = 'I' 
    order by fech_crea
END
GO
----
drop procedure [dbo].[SP_AX_getSegmentos]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getSegmentos] 
as
BEGIN
	select '' as codi_segm, '' as desc_segm, '1'
	union
	select codi_segm, desc_segm, 'n' from dbax_defi_segm order by 3, 2
END
GO
----
drop procedure [dbo].[SP_AX_GetValoCntx]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AX_GetValoCntx](
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
----
drop procedure [dbo].[SP_AX_GetVersInst]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_AX_GetVersInst] (
	@pCodiPers numeric(9,0),
	@pCorrInst numeric(10,0),
	@tipo varchar(3) = 'S')
AS
BEGIN
	if(@tipo='S')
	begin
		select	(isnull(max(vers_inst),0) + 1) vers_inst 
		from	dbax_inst_vers 
		where	codi_pers = @pCodiPers 
		and		corr_inst= @pCorrInst
	end
	else
	begin
		select	max(vers_inst) vers_inst 
		from	dbax_inst_vers 
		where	codi_pers = @pCodiPers 
		and		corr_inst= @pCorrInst
	end
END
GO
----
drop procedure [dbo].[SP_AX_insCntx]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_insCntx] (
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiCntx varchar(100),
	@p_DescCntx varchar(100),
	@p_DiaiCntx varchar(100),
	@p_AnoiCntx varchar(100),
	@p_DiatCntx varchar(100),
	@p_AnotCntx varchar(100)
	)as
BEGIN
	insert dbax_defi_cntx (codi_emex, codi_empr, codi_cntx, desc_cntx, diai_cntx, anoi_cntx, diat_cntx, anot_cntx) 
	values (@p_CodiEmex, @p_CodiEmpr, @p_CodiCntx, @p_DescCntx,@p_DiaiCntx,@p_AnoiCntx,@p_DiatCntx,@p_AnotCntx)
END
GO
----
drop procedure [dbo].[SP_AX_InsDatosCalIndicadores]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_InsDatosCalIndicadores](
    @p_codi_emex  varchar(30),
	@p_codi_empr  numeric(9,0),
	@p_corr_inst varchar(6),
	@p_codi_grup varchar(50),
	@p_codi_segm varchar(50),
	@p_codi_indi  varchar(100)
) as
BEGIN
	declare @pRuta_binario varchar(256)
	declare @pFecha_ini varchar(256)

	set @pRuta_binario = (select PARAM_VALUE from sys_param where PARAM_NAME = 'DBAX_XBRL_BINA')
	set @pFecha_ini  = (select getdate())

	insert dbax_dbne_proc(prog_proc, args_proc, fech_crea, fini_proc, esta_proc) 
	values (@pRuta_binario + '\CalculoIndicadores.exe ', '"' + convert(varchar,@p_codi_emex) + '" "' + convert(varchar,@p_codi_empr) + '" "' + @p_corr_inst + '" "' + convert(varchar,@p_codi_grup) + '" "' + convert(varchar,@p_codi_segm) + '" "' + convert(varchar,@p_codi_indi) + '"', @pFecha_ini, @pFecha_ini, 'I')
END
GO
----
drop procedure [dbo].[SP_AX_insEmpresaParaInforme]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_insEmpresaParaInforme](
	@pCodiEmpr numeric(9,0),
	@pCorrInst numeric(6,0)) as
BEGIN
	insert into dbax_tabl_temp (codi_colu1, codi_colu2, tipo_dato)
	values					   (@pCodiEmpr, @pCorrInst, 'IE')
END
GO
----
drop procedure [dbo].[SP_AX_insInfoConc]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_AX_insInfoConc] 
@pCodiEmex varchar(30),
@pCodiEmpr numeric(9,0),
@p_Codi_info varchar(100),
@p_pref_conc varchar(50),
@p_Codi_Conc varchar(100),
@p_Orden varchar(10),
@p_Nivel varchar(10)
 as
BEGIN

insert dbax_info_conc (codi_emex, codi_empr, codi_info, pref_conc, codi_conc, orde_conc, nive_conc) 
values (@pCodiEmex, @pCodiEmpr,@p_Codi_info, @p_pref_conc, @p_Codi_Conc, @p_Orden, @p_Nivel)
END
GO
----
drop procedure [dbo].[SP_AX_InsValoresIndicadores]
GO

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
----
drop procedure [dbo].[SP_AX_UpdContexto]
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_UpdContexto] (
	@pCodiEmex varchar(30),
	@pCodiEmpr numeric(9,0),
	@pCodiCntx varchar(50),
	@pDescCntx varchar(100),
	@pDiaiCntx varchar(100),
	@pAnoiCntx varchar(100),
	@pDiatCntx varchar(100),
	@pAnotCntx varchar(100)
	)
AS
BEGIN
	update	dbax_defi_cntx 
	set		desc_cntx = @pDescCntx,
			diai_cntx = @pDiaiCntx,
			anoi_cntx = @pAnoiCntx,
			diat_cntx = @pDiatCntx,
			anot_cntx = @pAnotCntx
	where	codi_emex = @pCodiEmex
	and		codi_empr = @pCodiEmpr 
	and		codi_cntx = @pCodiCntx
END
GO
----
drop procedure [dbo].[SP_AX_UpdDescEmpresa]
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_AX_UpdDescEmpresa](
@pCodiEmex varchar(30),
@pCodiEmpr numeric(9,0),
@pCodiPers numeric(9,0),
@pDescEmpr varchar(200),
@pCodiGrup varchar(50),
@pCodiSegm varchar(50))
AS
BEGIN
	IF (@pDescEmpr = '')
	BEGIN
		SET @pDescEmpr =  NULL;
	END

	IF (@pCodiGrup = '')
	BEGIN
		SET @pCodiGrup =  NULL;
	END

	IF (@pCodiSegm = '')
	BEGIN
		SET @pCodiSegm =  NULL;
	END	

    update	dbax_defi_peho
	set		desc_empr = @pDescEmpr
	where	codi_emex = @pCodiEmex
	and		codi_empr = @pCodiEmpr
	and		codi_pers = @pCodiPers
	
	update	dbax_defi_pers
	set		codi_grup = @pCodiGrup,
			codi_segm = @pCodiSegm
	where	codi_pers = @pCodiPers
END
GO
----
drop procedure [dbo].[SP_AX_UpdOrdenInforme]
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_UpdOrdenInforme] 
@p_codi_info_cntx varchar(100),
@p_Codi_empr varchar(100),
@p_Orden_conc varchar(50)
 as
BEGIN
	UPDATE dbax_info_cntx 
	set orde_cntx =  @p_Orden_conc
	where codi_inct = @p_codi_info_cntx AND codi_empr = @p_Codi_empr
END
GO

Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo1','Angelini')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo10','OHL')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo12','CAP')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo129','DREAMS')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo13','YARUR')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo14','SANTANDER')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo144','ENJOY')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo15','ENERSIS')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo156','SAID')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo16','FERNANDEZ LEON')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo17','URENDA')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo18','CGE')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo19','SIGDO KOPPERS')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo2','Matte')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo21','NOSE')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo22','Chilquinta')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo24','Ponce-Lerou')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo27','Hurtado-Vicuña')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo29','Sura')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo3','Luksic')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo30','GENER')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo33','Calderon')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo34','SAIHE')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo35','Security')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo37','BBVA')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo4','LECAROS')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo40','Paulmann')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo41','Penta')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo43','Telefónica')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo50','BOFILL')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo51','Zurich')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo53','SAESA')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo58','LARRAIN')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo6','CLARO')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo7','Guillisasti-Larrain')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo73','SOLARI')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo76','ITAU')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo89','CUETO')
Go
Insert into [dbo].[dbax_defi_grup](codi_grup,desc_grup) Values ('grupo93','BRESCIA')
Go

drop procedure [dbo].[SP_AX_InseVersInst]
go

create PROCEDURE [dbo].[SP_AX_InseVersInst] (@pCodiPers numeric(9,0),@pCorrInst numeric(10,0), @pVersInst numeric(5,0),@pDescVers varchar(256),@pCodiEsta varchar(3))
AS
BEGIN
insert into dbax_inst_vers (codi_pers, corr_inst, vers_inst,fech_carg, desc_vers, codi_esta) 
values (@pCodiPers,@pCorrInst,@pVersInst, substring (convert (varchar,getdate()), 0, 20) ,@pDescVers,@pCodiEsta)
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

drop procedure [dbo].[SP_AX_GetPeriRang]
go

CREATE procedure [dbo].[SP_AX_GetPeriRang](
	@pPeriIni varchar(30),
    @pPeriFin varchar(30)) as
BEGIN
	select distinct corr_inst
	from	dbax_inst_docu
	where corr_inst BETWEEN @pPeriIni and @pPeriFin
	order by 1 desc
END
GO

drop procedure [dbo].[SP_AX_getPersCorrInst]
go

create procedure [dbo].[SP_AX_getPersCorrInst](
	@pCodiPers varchar(30),
	@pCorrInst numeric(6,0) = 0) as
BEGIN
	if(len(@pCodiPers) > 0)
	begin
		select distinct corr_inst, corr_inst 
		from	dbax_inst_docu
		where	codi_pers = @pCodiPers
		and		corr_inst >= @pCorrInst
		order by 1 desc
	end
	else
	begin
		select distinct corr_inst, corr_inst 
		from	dbax_inst_docu
		where	corr_inst >= @pCorrInst
		order by 1 desc
	end
END
GO

drop procedure [dbo].[SP_AX_Get_informe_contexto_grilla]
GO

CREATE procedure [dbo].[SP_AX_getContextosInforme](
@p_codi_informe varchar(100))
as
BEGIN
	select	ic.codi_inct, 
			ic.orde_cntx, 
			ic.codi_cntx, 
			ic.codi_info,
			dc.desc_cntx
	from	dbax_info_cntx ic,
			dbax_defi_cntx dc
	where	ic.codi_info = @p_codi_informe
	and		ic.codi_cntx = dc.codi_cntx
	ORDER BY ic.orde_cntx
END
GO

Drop procedure [dbo].[SP_AX_RescConcepInfo]
GO

CREATE procedure [dbo].[SP_AX_getConcepInfo] 
@p_Codi_info varchar(100)
 as
BEGIN
       select D.codi_conc,
              A.orde_conc,
              D.desc_conc,
              A.nive_conc,
              A.negr_conc,
              CASE 
               WHEN  D.pref_conc = 'indi' THEN '~/dbnet.dbax/librerias/img/text_italic.png'
               WHEN  D.pref_conc != 'indi' THEN '~/dbnet.dbax/librerias/img/Transparencia.png'
               END  as imagen                  
	   from	dbax_info_conc A, 
			dbax_defi_conc B, 
			dbax_desc_conc D
		where A.codi_info = @p_Codi_info
		AND A.pref_conc = B.pref_conc
		AND A.codi_conc = B.codi_conc
		AND	B.pref_conc = D.pref_conc
		AND B.codi_conc = D.codi_conc
		order by A.orde_conc
END
GO

ALTER TRIGGER [dbo].[Actualiza_Orden_Infor_CNTX]
ON [dbo].[dbax_info_cntx]
AFTER UPDATE 
AS
declare
	@nueva int,
	@antigua int,
	@orde_conc int,
	@codi_inct varchar(50),
	@codi_info varchar(100),
	@CodiCntx varchar(50)
BEGIN
	select  @antigua = orde_cntx, @CodiCntx = codi_cntx, @codi_info = codi_info  from  deleted
	select @nueva  = orde_cntx  from  INSERTED
	select @codi_inct = codi_inct  from  deleted

	--Si estoy moviendo concepto hacia abajo...
	if(@antigua < @nueva)
	begin
	    update	dbax_info_cntx
		set		orde_cntx = orde_cntx  -1
		where	orde_cntx <= @nueva
		and		orde_cntx > @antigua
        and		codi_info = @codi_info 
        and		codi_cntx != @CodiCntx
	end
	--Si estoy moviendo concepto hacia arriba...
    else if (@nueva < @antigua )
	begin 
        update	dbax_info_cntx
		set		orde_cntx = orde_cntx  +1
		where	orde_cntx >= @nueva
		and		orde_cntx < @antigua
        and		codi_info = @codi_info
        and		codi_cntx != @CodiCntx
	end
END
GO

drop procedure [dbo].[SP_AX_UpdOrdenInforme]
go

create procedure [dbo].[SP_AX_UpdOrdenInforme] 
@CodiEmex varchar(30),
@CodiEmpr numeric(9,0),
@CodiInfo varchar(50),
@CodiCntx varchar(50),
@OrdeConcAnt numeric(5,0),
@OrdeConcAct numeric(5,0)
 as
BEGIN
	UPDATE	dbax_info_cntx 
	set		orde_cntx =  @OrdeConcAct
	where	codi_emex = @CodiEmex
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and		codi_cntx = @CodiCntx
	and		orde_cntx = @OrdeConcAnt
END
GO

drop procedure [dbo].[SP_AX_Elimina_Info_cntx]
go

CREATE procedure [dbo].[SP_AX_delInfoCntx] 
	@CodiEmex varchar(30),
	@CodiEmpr numeric(9,0),
	@CodiInfo varchar(50),
	@CodiCntx varchar(50)
 as
BEGIN
	delete from dbax_info_cntx 
	where	codi_emex = @CodiEmex  
	and		codi_empr = @CodiEmpr
	and		codi_info = @CodiInfo
	and		codi_cntx = @CodiCntx
END
GO

drop procedure [dbo].[SP_AX_Get_ArchivosXbrl]
GO

ALTER procedure [dbo].[SP_AX_getArchivosXbrl] 
	@p_Codi_Pers numeric(9,0),
	@p_Corr_Inst  numeric(10,0),
    @p_Vers_Inst  numeric(5,0),
	@vNombArch	  varchar(256)=''
as
BEGIN
declare @V_cant_zip varchar (10)

	select  @V_cant_zip = count(*)
	from	dbax_inst_arch 
	where	codi_pers = @p_Codi_Pers 
	and		corr_inst = @p_Corr_Inst
	and		vers_inst  = @p_Vers_Inst
	and		substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.zip'

	if ( @V_cant_zip = '0' and	len(@vNombArch)=0)
	begin
		select nomb_arch as Archivos,
               '' as Contenido
		from dbax_inst_arch 
		where codi_pers = @p_Codi_Pers
		and corr_inst = @p_Corr_Inst
		and vers_inst  = @p_Vers_Inst
	end
	else if(len(@vNombArch)=0)
	begin
       	select  nomb_arch as Archivos,
                '' as Contenido
		from dbax_inst_arch 
		where codi_pers = @p_Codi_Pers
		and corr_inst = @p_Corr_Inst
		and vers_inst  = @p_Vers_Inst
        and( substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.pdf.zip'
        or substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.zip'
        or substring(nomb_arch,charindex('.',nomb_arch), len(nomb_arch)) = '.pdf')
	end
	else
	begin
		select nomb_arch as Archivos,
               cont_arch as Contenido
		from dbax_inst_arch 
		where codi_pers = @p_Codi_Pers
		and corr_inst = @p_Corr_Inst
		and vers_inst  = @p_Vers_Inst
		and	nomb_arch = @vNombArch
	end
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 ALTER procedure [dbo].[SP_AX_InsBase64XBRL](
	@pCodi_pers numeric(9,0) ,
	@pCorr_inst varchar(10),
	@pVersInst numeric(5,0),
	@pCont_arch text,
	@pNomb_Arch varchar(256),
    @pTipo_mime varchar(50)) as
BEGIN 
	insert into dbax_inst_arch (codi_pers,corr_inst,vers_inst,cont_arch,nomb_arch, tipo_mime) 
    values (@pCodi_pers,@pCorr_inst,@pVersInst,@pCont_arch,@pNomb_Arch,@pTipo_mime)
END
GO

ALTER procedure [dbo].[SP_AX_getEmpresaPorGrupoSegmento](
@pCodiEmex varchar(30),
@pCodiEmpr numeric (9,0),
@pCorrInst varchar(10),
@pDescripcion varchar(100),
@pGrupo varchar(50),
@pSegmento varchar(50),
@pTipoDesc varchar(100) = 'P'
)
as
BEGIN
	/*	
		@pTipoDesc = 'D' se devuelve descripcion "por defecto", 
		@pTipoDesc = 'P' devuelve descripcion por defecto y personalizada
		@pTipoDesc  = 'C' SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN
	*/
	declare @vComodinGrup varchar(1)
	declare @vComodinSegm varchar(1)
	set @vComodinGrup = '%'
	set @vComodinSegm = '%'

	if ( @pGrupo != '')
	begin
		set @vComodinGrup = ''
	end

	if ( @pSegmento != '')
	begin
		set @vComodinSegm = ''
	end

	declare @vComodinCorr varchar(1)
	set @vComodinCorr = '%'

	if (@pCorrInst != '')
	begin
		set @vComodinCorr = ''
	end

	if(@pTipoDesc = 'P') -- TODAS LAS EMPRESAS PARA COMBOBOX
	begin
		select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm
		from	(select distinct dp.codi_pers as codi_pers,
								'[' + convert(varchar,dp.codi_pers) + '] ' + isnull(dh.desc_empr,dp.desc_pers) as desc_pers,
								dh.desc_empr as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								dp.codi_segm as codi_segm
				from	dbax_defi_pers dp 
							left join dbax_defi_peho dh 
							on	dh.codi_emex = @pCodiEmex 
							and	dh.codi_empr = @pCodiEmpr 
							and	dp.codi_pers = dh.codi_pers
								left join dbax_defi_grup dg
								on	dg.codi_grup = dp.codi_grup,
						dbax_inst_docu id
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or dh.desc_empr like '%' + @pDescripcion + '%' 
						or dp.desc_pers like '%' + @pDescripcion + '%')
				and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
				and		dp.codi_pers = id.codi_pers) v
		left join dbax_defi_segm ds
			on v.codi_segm = ds.codi_segm
		where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
	end

	if(@pTipoDesc = 'C') -- SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN (para grilla de diferencias)
		begin

			select distinct dp.codi_pers as codi_pers,
			'[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
			dh.desc_empr as desc_peho 
			from dbax_defi_pers dp left join dbax_defi_peho dh on dh.codi_emex = @pCodiEmex 
			and dh.codi_empr = @pCodiEmpr 
			and dp.codi_pers = dh.codi_pers 
			where dp.codi_pers like '%' + @pDescripcion + '%'
			and dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1')
			union
			select distinct dp.codi_pers as codi_pers, '[' + convert(varchar,dp.codi_pers) + '] ' + dp.desc_pers as desc_pers,
			dh.desc_empr as desc_peho 
			from dbax_defi_pers dp left join dbax_defi_peho dh on dh.codi_emex = @pCodiEmex 
			and dh.codi_empr = @pCodiEmpr 
			and dp.codi_pers = dh.codi_pers 
			where 
			dp.codi_pers in (select distinct a.codi_pers from dbax_inst_info a where  a.vers_inst > '1') 
			and dp.desc_pers like '%' + @pDescripcion + '%' or dh.desc_empr like '%' + @pDescripcion + '%'
	end

	if(@pTipoDesc = 'E') -- TODAS LAS EMPRESAS PARA COMBOBOX
	begin
		select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm
		from	(select distinct dp.codi_pers as codi_pers,
								'[' + convert(varchar,dp.codi_pers) + '] ' + isnull(dh.desc_empr,dp.desc_pers) as desc_pers,
								dh.desc_empr as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								dp.codi_segm as codi_segm
				from	dbax_defi_pers dp 
							left join dbax_defi_peho dh 
							on	dh.codi_emex = @pCodiEmex 
							and	dh.codi_empr = @pCodiEmpr 
							and	dp.codi_pers = dh.codi_pers
								left join dbax_defi_grup dg
								on	dg.codi_grup = dp.codi_grup,
						dbax_inst_docu id
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or dh.desc_empr like '%' + @pDescripcion + '%' 
						or dp.desc_pers like '%' + @pDescripcion + '%')
				and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
				and		dp.codi_pers = id.codi_pers
				and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
				) v
		left join dbax_defi_segm ds
			on v.codi_segm = ds.codi_segm
		where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
	end
END
GO

drop procedure SP_AX_InsertarNuevoInforme
go

Drop procedure SP_AX_ModificarConceptos
GO

drop procedure SP_AX_EliminarConceptos
Go

drop procedure SP_AX_DeleInst
Go

drop procedure SP_AX_InseInst
GO

drop procedure SP_AX_InseHtmlDife
GO

drop procedure SP_AX_InseConcDife
GO
drop procedure SP_AX_InseInstInfo
GO
drop procedure SP_AX_InseInstConc
drop procedure SP_AX_InseInstUnit
drop procedure SP_AX_InseCntxInst
drop procedure SP_AX_InseCntxInst
drop procedure SP_AX_InseInstDicx
drop procedure SP_AX_InseVersInst
GO