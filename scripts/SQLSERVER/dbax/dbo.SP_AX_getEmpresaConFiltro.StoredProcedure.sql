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
