SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[AXgetValor](
			@p_codi_pers numeric(10), 
			@p_corr_inst numeric(5), 
			@p_vers_inst numeric(5), 
			@p_pref_conc varchar(256), 
			@p_codi_conc varchar(256), 
            @v_codi_cntx varchar(512),
            @v_codi_cntx2 varchar(512)
            ) 
            returns varchar(4000)
begin
	declare @v_valor varchar(4000)

	--select @v_valor = CONVERT(VarChar(50), cast( isnull(max(valo_cntx),'') as money ), 1)
	select	@v_valor =isnull(max(valo_cntx),'')
    from	dbax_inst_conc 
	where	codi_pers = @p_codi_pers 
	and		corr_inst = @p_corr_inst 
	and		vers_inst = @p_vers_inst 
	and		pref_conc = @p_pref_conc 
	and		codi_conc = @p_codi_conc 
	and		codi_cntx = @v_codi_cntx

	if(@v_valor = '')
	begin
        --select @v_valor = CONVERT(VarChar(50), cast( isnull(max(valo_cntx),'') as money ), 1)
	    select @v_valor =isnull(max(valo_cntx),'')
		from dbax_inst_conc 
		where codi_pers = @p_codi_pers 
		and corr_inst = @p_corr_inst 
		and vers_inst = @p_vers_inst 
		and pref_conc = @p_pref_conc 
		and codi_conc = @p_codi_conc 
		and codi_cntx = @v_codi_cntx2
	end

	return @v_valor
end
GO
