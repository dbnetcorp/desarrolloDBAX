SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getInformesDimension] 

AS
BEGIN
select distinct codi_dein, codi_dein 
from  dbax_dime_defi
END
GO
