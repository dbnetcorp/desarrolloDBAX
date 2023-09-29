SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<mauricio Ahumada>
-- Create date: <20120904>
-- Description:	<>
-- =============================================
CREATE TRIGGER [dbo].[tr_formenca_borraregistro]
   ON  [dbo].[dbax_form_enca]
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	declare @vCodiConc varchar(100)
	declare @vCodiEmex varchar(30)
	declare @vCodiEmpr numeric(9,0)

	select	@vCodiEmex = codi_emex, 
			@vCodiEmpr = codi_empr, 
			@vCodiConc = codi_indi 
	from deleted

	delete from dbax_form_enca 
	where	codi_emex = @vCodiEmex 
	and		codi_empr = @vCodiEmpr
	and		codi_indi = @vCodiConc

	delete from dbax_desc_conc
	where	pref_conc = 'indi'
	and		codi_conc = @vCodiConc
	
	delete from dbax_defi_conc
	where	pref_conc = 'indi'
	and		codi_conc = @vCodiConc
END
GO
