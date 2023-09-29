SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_delInfoConc] 
@pCodiEmex varchar(50),
@pCodiEmpr varchar(9),
@pCodiInfo varchar(50),
@pPrefConc varchar(50),
@pCodiConc varchar(100),
@pOrdeConc varchar(50)
 as
BEGIN
	delete	dbax_info_conc 
	where	codi_emex = @pCodiEmex
	and		codi_empr = @pCodiEmpr
	and		codi_info = @pCodiInfo
	and		pref_conc = @pPrefConc
	and		codi_conc = @pCodiConc
	and		orde_conc = @pOrdeConc
END
GO
