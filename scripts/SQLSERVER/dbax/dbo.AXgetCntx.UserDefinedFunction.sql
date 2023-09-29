SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[AXgetCntx](
			@p_codi_empr numeric(10), 
			@p_fini_cntx varchar(50),
			@p_ffin_cntx varchar(50)) returns varchar(4000)
begin
	declare @v_codi_cntx varchar(512)

	select @v_codi_cntx = codi_cntx
	from dbax_inst_cntx ic 
	where ic.codi_pers = @p_codi_empr
	and ic.corr_inst = @p_codi_empr
	and ic.vers_inst = 1 
	and	ic.fini_cntx = @p_fini_cntx
	and	isnull(ic.ffin_cntx,'') = isnull(@p_ffin_cntx,'')
	and ic.codi_cntx not in (
			select di.codi_cntx 
			from dbax_inst_dicx di 
			where di.codi_pers = @p_codi_empr
			and di.corr_inst = @p_codi_empr
			and di.vers_inst = 1)

	return @v_codi_cntx
end
GO
