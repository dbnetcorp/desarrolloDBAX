SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetDetaIndi](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiIndi varchar(100),
	@p_LetrVari varchar(1)) as
BEGIN
	select	fd.pref_conc, fd.codi_conc, dc.desc_conc, fd.codi_cntx
	from	dbax_form_deta fd,
			dbax_desc_conc dc
	where	fd.codi_emex = @p_CodiEmex
	and		fd.codi_empr = @p_CodiEmpr
	and		fd.codi_indi = @p_CodiIndi
	and		fd.letr_vari = @p_LetrVari
	and		fd.pref_conc = dc.pref_conc
	and		fd.codi_conc = dc.codi_conc
END
GO
