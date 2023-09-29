SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FU_AX_getUltimaVersion](
			@p_codi_empr numeric(10), 
			@p_fini_cntx varchar(50)) returns numeric(5,0)
begin
	declare @vVersion numeric(5,0)

	select @vVersion = max(vers_inst) from dbax_inst_vers where codi_pers = @p_codi_empr and corr_inst = @p_fini_cntx

	return @vVersion
end
GO
