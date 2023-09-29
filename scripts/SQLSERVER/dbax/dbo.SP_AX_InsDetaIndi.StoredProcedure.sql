SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_InsDetaIndi](
	@p_codi_emex  varchar(30),
	@p_codi_empr  numeric(9,0),
	@p_codi_indi  varchar(100),
	@p_letr_vari  varchar(20),
	@p_pref_conc  varchar(256),
	@p_codi_conc  varchar(100),
	@p_codi_cntx  varchar(50)) as
BEGIN
	insert into dbax_form_deta (codi_emex, codi_empr, codi_indi, letr_vari, pref_conc, codi_conc, codi_cntx)
	values					   (@p_codi_emex, @p_codi_empr, @p_codi_indi, @p_letr_vari, @p_pref_conc, @p_codi_conc,@p_codi_cntx)
END
GO
