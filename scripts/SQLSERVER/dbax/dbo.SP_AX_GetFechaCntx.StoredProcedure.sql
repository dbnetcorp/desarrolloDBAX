SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_GetFechaCntx](
@Codi_inst varchar(30),
@p_DiaMes varchar(50),
@p_Ano varchar(50))	
AS
BEGIN
	select dbo.FU_AX_getFechas(@Codi_inst , @p_DiaMes, @p_Ano) AS Fecha
END
GO
