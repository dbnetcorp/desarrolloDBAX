SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_ejem](
	@p_CodiConc  varchar(100)) as
BEGIN
	select codi_conc from dbax_defi_conc	where codi_conc like '%' + @p_CodiConc + '%'
END
GO
