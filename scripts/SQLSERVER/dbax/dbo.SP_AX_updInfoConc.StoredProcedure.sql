SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_updInfoConc] 
	@pCodiEmex varchar(30),
	@pCodiEmpr varchar(9),
	@pCodiInfo varchar(100),
	@pPrefConc varchar(50),
	@p_Codi_conc varchar(100),
	@p_Orden_conc varchar(100),
	@p_Nivel varchar(100),
	@p_Negrita varchar(100)
as
BEGIN
	UPDATE	dbax_info_conc 
	set		orde_conc = @p_Orden_conc,
			nive_conc = @p_Nivel,
			negr_conc = @p_Negrita
	where	codi_emex = @pCodiEmex
	and		codi_empr = @pCodiEmpr
	AND		codi_info = @pCodiInfo
	and		pref_conc = @pPrefConc
	and		codi_conc = @p_Codi_conc 
END
GO
