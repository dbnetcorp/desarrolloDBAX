SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_delIndi](
	@p_codi_emex  varchar(30),
	@p_codi_empr  numeric(9,0),
	@p_codi_indi  varchar(100)) as
BEGIN
delete from dbax_form_enca 
where codi_emex = @p_codi_emex 
and codi_empr = @p_codi_empr 
and codi_indi = @p_codi_indi

delete from dbax_info_conc
where codi_conc = @p_codi_indi
and pref_conc  ='indi'

delete from dbax_inst_conc
where codi_conc = @p_codi_indi
and pref_conc  ='INDI'
END
GO
