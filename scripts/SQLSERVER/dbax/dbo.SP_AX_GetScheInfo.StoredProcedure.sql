SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_AX_GetScheInfo] (@pScheInfo varchar(256))
AS
BEGIN
set @pScheInfo = replace(replace(@pScheInfo,'//','/'),':/','://')
select codi_info from dbax_taxo_info where sche_info = @pScheInfo 
END
GO
