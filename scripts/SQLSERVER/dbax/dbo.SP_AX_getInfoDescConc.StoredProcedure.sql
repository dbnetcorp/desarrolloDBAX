SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getInfoDescConc] 
	@p_CodiEmex  varchar(30),
	@p_CodiEmpr  numeric(9,0),
	@p_codi_info varchar(50)
	as
BEGIN
	select	A.negr_conc,
			A.nive_conc,
            D.desc_conc
	from	dbax_info_conc A, 
			dbax_defi_conc B, 
			dbax_desc_conc D
	where	A.codi_emex = @p_CodiEmex
	AND		A.codi_empr = @p_CodiEmpr
	AND		A.codi_info = @p_codi_info
	AND A.pref_conc = B.pref_conc
	AND A.codi_conc = B.codi_conc
	AND	B.pref_conc = D.pref_conc
	AND B.codi_conc = D.codi_conc
	order by A.orde_conc
END
GO
