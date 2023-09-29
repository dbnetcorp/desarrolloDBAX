SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_getSegmentos] 
as
BEGIN
	select '' as codi_segm, '' as desc_segm, '1'
	union
	select codi_segm, desc_segm, 'n' from dbax_defi_segm order by 3, 2
END
GO
