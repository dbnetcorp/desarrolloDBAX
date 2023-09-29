SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getInformes] 
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@pTipo varchar(10)=''
AS
BEGIN
	declare @vComodinTipo varchar(1)
	
	set @vComodinTipo = '%'

	if ( @pTipo != '')
	begin
		set @vComodinTipo = ''
	end

	select	id.codi_info, 
			isnull(de.desc_info, id.codi_info) as desc_info, 
			id.tipo_taxo,
			tt.desc_tipo
	from	dbax_info_defi id 
		left join	dbax_desc_info de
		on id.codi_info = de.codi_info,
		dbax_tipo_taxo tt
	where	id.codi_emex = @p_CodiEmex
	and		id.codi_empr = @p_CodiEmpr
	and		id.tipo_taxo = tt.tipo_taxo
	and		id.tipo_taxo like @vComodinTipo + @pTipo + @vComodinTipo
	order by id.orde_info
END
GO
