USE [dbaxBI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FU_PF_getMaxOrdenConcepto] 
(
	@vPrefConc varchar(10),
	@vCodiConc varchar(256)
)
RETURNS varchar(10)
AS
BEGIN
	declare @vOrden varchar(10)

	select	@vOrden = isnull(max(orde_conc),'0')
	from	dbax.dbo.dbax_dime_conc
	where	pref_conc = @vPrefConc
	and		codi_conc = @vCodiConc

	RETURN @vOrden
END
GO
