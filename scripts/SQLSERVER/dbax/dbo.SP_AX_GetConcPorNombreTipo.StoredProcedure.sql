SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetConcPorNombreTipo](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiConc  varchar(100),
	@p_TipoElem varchar(1),
	@p_CodiConc2  varchar(100),
	@p_TipoConc varchar(4)='200') as
BEGIN
	if(@p_TipoElem='T')
	begin
		select	sc.desc_conc as desc_conc,
				dc.pref_conc as pref_conc, 
				dc.codi_conc as codi_conc 
		from	dbax_defi_conc dc, 
				dbax_desc_conc sc, 
				dbax_tipo_conc tc,
				sys_code s 
		where	dc.pref_conc = sc.pref_conc 
		and		dc.codi_conc = sc.codi_conc 
		and		dc.tipo_conc = tc.tipo_conc 
		and		tc.tipo_conc = 'concepto' 
		and		sc.desc_conc like '%' + @p_CodiConc + '%'
		and		s.domain_code = @p_TipoConc
		and		dc.tipo_valo = s.code
		order by desc_conc
	end
	else if(@p_TipoElem='P')
	begin
		select	sc.desc_conc as desc_conc,
				dc.pref_conc as pref_conc, 
				dc.codi_conc as codi_conc 
		from	dbax_defi_conc dc, 
				dbax_desc_conc sc, 
				dbax_form_enca fe
		where	fe.codi_emex = @p_CodiEmex
		and		fe.codi_empr = @p_CodiEmpr
		and		fe.codi_indi != @p_CodiConc2
		and		dc.pref_conc = 'indi'
		and		dc.codi_conc = fe.codi_indi
		and		dc.tipo_conc = fe.tipo_conc
		and		sc.pref_conc = dc.pref_conc
		and		sc.codi_conc = dc.codi_conc
		and		sc.desc_conc like '%' + @p_CodiConc + '%'
		order by desc_conc
	end
	else if(@p_TipoElem='')
	begin
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
		and		tc.tipo_conc = 'concepto' 
		and		sc.desc_conc like '%' + @p_CodiConc + '%'
		and		s.domain_code = @p_TipoConc
		and		dc.tipo_valo = s.code
		union
		select	distinct isnull(sc.desc_conc,dc.codi_conc) as desc_conc,
				dc.pref_conc as pref_conc, 
				dc.codi_conc as codi_conc 
		from	dbax_defi_conc dc, 
				dbax_desc_conc sc, 
				dbax_form_enca fe
		where	fe.codi_emex = @p_CodiEmex
		and		fe.codi_empr = @p_CodiEmpr
		and		fe.codi_indi != @p_CodiConc2
		and		dc.pref_conc = 'indi'
		and		dc.codi_conc = fe.codi_indi
		and		dc.tipo_conc = fe.tipo_conc
		and		sc.pref_conc = dc.pref_conc
		and		sc.codi_conc = dc.codi_conc
		and		sc.desc_conc like '%' + @p_CodiConc + '%'
		order by desc_conc
	end
END
GO
