USE [dbax]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[BORRAR_SP_AX_getConceptos](
	@pFiltro_Concepto varchar(100),
	@pTipoConc varchar(4)='200')
as
BEGIN
	   select	D.codi_conc,
				D.desc_conc
	   from		dbax_defi_conc B, 
				dbax_desc_conc D,
				sys_code s
	   where	B.pref_conc = D.pref_conc
				AND B.codi_conc = D.codi_conc
				and desc_conc like '%'+ @pFiltro_Concepto  +'%'
				and s.domain_code = @pTipoConc
				and B.tipo_valo = s.code
       order by  D.desc_conc
END
GO
