SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_InsEncaIndi](
	@p_codi_modo  varchar(1),
	@p_codi_emex  varchar(30),
	@p_codi_empr  numeric(9,0),
	@p_codi_indi  varchar(100),
	@p_tipo_indi  varchar(20),
	@p_desc_indi  varchar(256),
	@p_form_indi  varchar(100)) as
BEGIN
	if(@p_codi_modo = 'I')
	begin
		insert into dbax_form_enca (codi_emex, codi_empr, codi_indi, tipo_conc, desc_indi, form_indi)
		values					   (@p_codi_emex, @p_codi_empr, @p_codi_indi, @p_tipo_indi, @p_desc_indi, @p_form_indi)
	end
	else
	begin
		/*select	@p_tipo_indi as tipo_indi, 
				@p_desc_indi as desc_indi, 
				@p_form_indi as form_indi, 
				@p_codi_emex as codi_emex, 
				@p_codi_empr as codi_empr, 
				@p_codi_indi as codi_indi*/

		update	dbax_form_enca 
		set		tipo_conc = @p_tipo_indi, 
				desc_indi = @p_desc_indi, 
				form_indi = @p_form_indi 
		where	codi_emex = @p_codi_emex
		and		codi_empr = @p_codi_empr
		and		codi_indi = @p_codi_indi
	end
END
GO
