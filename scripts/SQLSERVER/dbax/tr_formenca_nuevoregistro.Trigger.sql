SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<mauricio Ahumada>
-- Create date: <20120904>
-- Description:	<>
-- =============================================
CREATE TRIGGER [dbo].[tr_formenca_nuevoregistro]
   ON  [dbo].[dbax_form_enca]
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	declare @vCodiConc varchar(100)
	declare @vDescIndi varchar(256)
	declare @vTipoConc varchar(20)
	declare @vCodiEmex varchar(30)
	declare @vCodiEmpr numeric(9,0)

	select	@vCodiEmex = codi_emex,
			@vCodiEmpr = codi_empr,
			@vCodiConc = codi_indi, 
			@vDescIndi = desc_indi,
			@vTipoConc = tipo_conc 
	from inserted

	if(len(@vDescIndi)=0)
		set @vDescIndi = @vCodiConc;

	if((select count(*) from deleted) = 0) --Es una inserción
	begin
		insert into dbax_defi_conc (pref_conc, codi_conc, tipo_conc, tipo_valo)
		values ('indi', @vCodiConc, @vTipoConc, 'indi')

		insert into dbax_desc_conc (pref_conc, codi_conc, codi_lang, desc_conc)
		values ('indi', @vCodiConc, 'es_ES', @vDescIndi)
	end
	else
	begin
		--select @vCodiEmex, @vCodiEmpr, @vCodiConc

		delete	from dbax_form_deta
		where	codi_emex = @vCodiEmex
		and		codi_empr = @vCodiEmpr
		and		codi_indi = @vCodiConc

		update	dbax_defi_conc 
		set		tipo_conc = @vTipoConc 
		where	pref_conc = 'indi' 
		and		codi_conc = @vCodiConc

		update	dbax_desc_conc
		set		desc_conc = @vDescIndi
		where	pref_conc = 'indi' 
		and		codi_conc = @vCodiConc
	end
END
GO
