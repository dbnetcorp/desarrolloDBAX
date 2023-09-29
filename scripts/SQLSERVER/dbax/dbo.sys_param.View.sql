SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[sys_param]
AS
SELECT     object_name AS PARAM_NAME, object_type, codi_modu, object_brief AS PARAM_VALUE, object_desc AS PARAM_DESC, table_type AS param_type, 
                      object_order AS PARAM_ORDER
FROM         dbo.sys_object
WHERE     (object_type = 'O')
GO
