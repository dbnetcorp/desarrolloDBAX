SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[dbax_view_inem]
AS
SELECT     codi_colu1 AS codi_pers, codi_colu2 AS corr_inst, tipo_dato
FROM         dbo.dbax_tabl_temp
WHERE     (tipo_dato = 'IE')
GO
