SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_RescAgru] as
BEGIN
	select tipo_conc, desc_conc from dbax_tipo_conc where tipo_elem = 'I'
END
GO
