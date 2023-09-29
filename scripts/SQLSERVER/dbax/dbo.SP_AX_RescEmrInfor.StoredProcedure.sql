SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_AX_RescEmrInfor] as
BEGIN
	select		codi_info, codi_pers, corr_inst, vers_inst 
	from		dbax_inst_info
	order by	codi_pers, corr_inst, vers_inst, codi_info
END
GO
