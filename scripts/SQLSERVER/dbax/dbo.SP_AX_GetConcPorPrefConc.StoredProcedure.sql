SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetConcPorPrefConc](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_PrefConc  varchar(50),
	@p_CodiConc  varchar(100)) as
BEGIN
	select	distinct sc.desc_conc as desc_conc,
			dc.pref_conc as pref_conc, 
			dc.codi_conc as codi_conc 
	from	dbax_defi_conc dc, 
			dbax_desc_conc sc, 
			dbax_tipo_conc tc,
			sys_code s 
	where	dc.pref_conc = sc.pref_conc 
	and		dc.codi_conc = sc.codi_conc 
	and		dc.tipo_conc = tc.tipo_conc 
--	and		tc.tipo_conc = 'concepto' 
	and		sc.pref_conc like '%' + @p_PrefConc + '%'
	and		sc.desc_conc like '%' + @p_CodiConc + '%'
    and		s.domain_code in ('200','210')
	and		dc.tipo_valo = s.code
	order by desc_conc
END
GO
