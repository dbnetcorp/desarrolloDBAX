SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getCodiFech] 
	@p_TipoFech  varchar(1)
as
BEGIN
	select '0' codi_fech, 'Seleccionar' desc_fech
	union
	select codi_fech as codi_fech, desc_fech as desc_fech 
	from dbax_codi_fech 
	where tipo_fech = @p_TipoFech
END
GO
