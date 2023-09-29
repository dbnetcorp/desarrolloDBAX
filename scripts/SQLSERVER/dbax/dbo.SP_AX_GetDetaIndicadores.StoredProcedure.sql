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
