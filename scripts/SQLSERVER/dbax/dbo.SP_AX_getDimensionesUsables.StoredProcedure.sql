SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getDimensionesUsables]
	@p_CodiInfo varchar(256)
as
BEGIN
	select distinct dd.codi_dime, dd.codi_dime
	from	dbax_dime_defi dd,
    dbax_defi_conc dc
    where	dd.codi_dein = @p_CodiInfo
    and    dd.codi_dime = dc.codi_conc 
END
GO
