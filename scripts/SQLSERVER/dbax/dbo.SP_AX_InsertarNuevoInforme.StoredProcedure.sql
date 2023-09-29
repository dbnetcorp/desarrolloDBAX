SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_InsertarNuevoInforme]
 (@pInforme varchar(50),
  @pCodiEmpr varchar(20))
AS
declare
@codi_informe varchar(100)
BEGIN
 set @codi_informe = (select replace(@pInforme,' ',''))

insert into dbax_info_defi (codi_empr, codi_info)
        values (@pCodiEmpr, @codi_informe)

insert into dbax_desc_info (codi_empr, codi_info, codi_lang, desc_info )
        values (@pCodiEmpr,@codi_informe  ,'es_ES',@pInforme)

END
GO
