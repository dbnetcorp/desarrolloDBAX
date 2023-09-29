SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_Get_Ingreso](
	@p_CodiEmpr numeric(9,0),
    @p_CodiEmex varchar(30))
as
BEGIN
	SELECT COUNT(*) as contador
    FROM dbax_pers_grup 
    WHERE codi_empr = @p_CodiEmpr and codi_emex = @p_CodiEmex
END
GO
