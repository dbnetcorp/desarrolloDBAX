SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getInfoDimensionDescConc]
	@p_CodiInfo varchar(256),
	@p_dimension varchar(256)
as
BEGIN
-- obtenciòn de los conceptos  de la dimension

	select
--	 dc.codi_conc,
--	 dc.pref_conc, 
	 des.desc_conc 
--	 dc.orde_conc, 
--	 dc.sald_ini, 
--	 de.tipo_peri
	from 
	dbax_dime_conc dc,
	dbax_desc_conc des,
	dbax_defi_conc de
	where 
	dc.codi_dein = @p_CodiInfo 
	and dc.codi_dime = @p_dimension 
	and dc.codi_conc = des.codi_conc
	and des.codi_conc = de.codi_conc
	and dc.codi_conc = de.codi_conc
	and dc.pref_conc = des.pref_conc
	and dc.pref_conc = de.pref_conc
	and des.pref_conc = de.pref_conc
	order by dc.orde_conc

END
GO
