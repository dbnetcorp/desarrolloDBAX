SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetDatosGrupo](
@pCodi_empr numeric(9,0),
@pCodi_emex varchar(30),
@pCode varchar(100))
as 
BEGIN
	select  B.codi_pers, B.desc_pers
	from dbax_pers_grup A, dbax_defi_pers B
    where A.codi_pers = B.codi_pers
    AND A.codi_empr = @pCodi_empr
    AND A.codi_emex = @pCodi_emex
    AND A.code = @pCode
END
GO
