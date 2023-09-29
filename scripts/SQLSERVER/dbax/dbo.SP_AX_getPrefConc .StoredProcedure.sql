SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getPrefConc ]
@pTipoTaxo varchar(10) = ''
as
BEGIN
	declare @vComodinTipo varchar(1)

	set @vComodinTipo = '%'

	if ( @pTipoTaxo != '')
	begin
		set @vComodinTipo = ''
	end

	select distinct pref_conc,pref_conc 
	from dbax_defi_conc 
	where tipo_taxo like @vComodinTipo + @pTipoTaxo + @vComodinTipo
END
GO
