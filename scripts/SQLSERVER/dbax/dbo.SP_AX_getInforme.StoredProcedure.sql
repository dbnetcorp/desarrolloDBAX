SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getInforme] 
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@pCodiInfo varchar(50)
AS
BEGIN
	select	id.codi_info, 
			isnull(de.desc_info, id.codi_info) as desc_info, 
			id.tipo_taxo
	from	dbax_info_defi id 
		left join	dbax_desc_info de
		on id.codi_info = de.codi_info
	where	id.codi_emex = @p_CodiEmex
	and		id.codi_empr = @p_CodiEmpr
	and		id.codi_info = @pCodiInfo
	order by id.orde_info
END
GO
