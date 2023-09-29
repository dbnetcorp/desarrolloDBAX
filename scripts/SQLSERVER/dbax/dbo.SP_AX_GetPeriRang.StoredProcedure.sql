SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_GetPeriRang](
	@pPeriIni varchar(30),
    @pPeriFin varchar(30)) as
BEGIN
	select distinct corr_inst
	from	dbax_inst_docu
	where corr_inst BETWEEN @pPeriIni and @pPeriFin
	order by 1 desc
END
GO
