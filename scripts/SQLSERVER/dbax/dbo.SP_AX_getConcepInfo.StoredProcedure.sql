SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getConcepInfo] 
	@p_CodiEmex varchar(30),
	@p_CodiEmpr varchar(9),
	@p_CodiInfo varchar(100)
as
BEGIN
   select	A.pref_conc,
			D.codi_conc,
			A.orde_conc,
			D.desc_conc,
			A.nive_conc,
			A.negr_conc,
			CASE 
				WHEN	D.pref_conc = 'indi' THEN '~/dbnet.dbax/librerias/img/text_italic.png'
				WHEN	D.pref_conc != 'indi' THEN '~/dbnet.dbax/librerias/img/Transparencia.png'
			END	as imagen                  
   from		dbax_info_conc A, 
			dbax_defi_conc B, 
			dbax_desc_conc D
	where	A.codi_emex = @p_CodiEmex
	and		A.codi_empr = @p_CodiEmpr
	and		A.codi_info = @p_CodiInfo
	AND		A.pref_conc = B.pref_conc
	AND		A.codi_conc = B.codi_conc
	AND		B.pref_conc = D.pref_conc
	AND		B.codi_conc = D.codi_conc
	order by A.orde_conc
END
GO
