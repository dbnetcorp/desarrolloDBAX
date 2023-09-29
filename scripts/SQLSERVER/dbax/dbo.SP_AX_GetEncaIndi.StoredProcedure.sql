SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetEncaIndi](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiIndi varchar(100)) as
BEGIN
	select	fe.tipo_conc, fe.desc_indi, fe.form_indi, fe.tipo_taxo, tt.desc_tipo
	from	dbax_form_enca fe,
			dbax_tipo_taxo tt
	where	fe.codi_emex = @p_CodiEmex
	and		fe.codi_empr = @p_CodiEmpr
	and		fe.codi_indi = @p_CodiIndi
	and		fe.tipo_taxo = tt.tipo_taxo

END
GO
