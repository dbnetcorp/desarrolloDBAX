SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_prueba]
 (@CODI_PERS varchar(50),
  @PERIODO varchar(50))
AS

BEGIN

insert into PRUEBA (CODI_PERS, PERIODO)
        values (@CODI_PERS, @PERIODO)



END
GO
