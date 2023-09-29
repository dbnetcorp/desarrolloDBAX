/****** Object:  StoredProcedure [dbo].[SP_AX_GetFechasEmprInstVersConc]    Script Date: 12/27/2016 08:29:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_GetFechasEmprInstVersConc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_GetFechasEmprInstVersConc]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_GetFechasEmprInstVersConc]    Script Date: 12/27/2016 08:29:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_AX_GetFechasEmprInstVersConc](
	@pCodi_pers varchar(16),
	@pCorr_inst numeric(10,0),
	@pVers_inst numeric(5,0),
	@pcodi_conc varchar(256)) 
as
BEGIN
	select	distinct isnull(ix.fini_cntx,'') as fini_cntx, 
			isnull(ix.ffin_cntx,'') as ffin_cntx,
			isnull(ix.fini_cntx,'') + '   ' + isnull(ix.ffin_cntx,'') as descFecha
	from	dbax_inst_cntx ix,
			dbax_inst_conc ic
	where	ix.codi_pers = @pCodi_pers
	and		ix.corr_inst = @pCorr_inst
	and		ix.vers_inst = @pVers_inst
	and		ic.codi_pers = ix.codi_pers
	and		ic.corr_inst = ix.corr_inst
	and		ic.vers_inst = ix.vers_inst
	and		ic.codi_conc = @pcodi_conc
	and		ic.codi_cntx = ix.codi_cntx
	order by 3 desc
END
GO
--
/****** Object:  StoredProcedure [dbo].[SP_AX_GetCntxEmprInstVersFech]    Script Date: 12/27/2016 08:34:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_GetCntxEmprInstVersFech]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_GetCntxEmprInstVersFech]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_GetCntxEmprInstVersFech]    Script Date: 12/27/2016 08:34:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_AX_GetCntxEmprInstVersFech](
	@pCodi_pers varchar(16),
	@pCorr_inst numeric(10,0),
	@pVers_inst numeric(5,0),
	@pPrefConc varChar(50),
	@pCodiConc varchar(256),
	@pCntxFini varchar(10),
	@pCntxFfin varchar(10),
	@pCntxDime varchar(1)='0') 
as
BEGIN
	if(@pCntxDime='0')
	begin
		select	distinct ix.codi_cntx
		from	dbax_inst_cntx ix,
				dbax_inst_conc ic
		where	ix.codi_pers = @pCodi_pers
		and		ix.corr_inst = @pCorr_inst
		and		ix.vers_inst = @pVers_inst
		and		ix.fini_cntx = @pCntxFini
		and		isnull(ix.ffin_cntx,'') = @pCntxFfin
		and		ix.codi_cntx not in (
						select	distinct id.codi_cntx
						from	dbax_inst_dicx id
						where	id.codi_pers = @pCodi_pers
						and		id.corr_inst = @pCorr_inst
						and		id.vers_inst = @pVers_inst
						)
		and		ic.codi_pers = ix.codi_pers
		and		ic.corr_inst = ix.corr_inst
		and		ic.vers_inst = ix.vers_inst
		and		ic.pref_conc = @pPrefConc
		and		ic.codi_conc = @pCodiConc
		and		ic.codi_cntx = ix.codi_cntx
		order by 1 desc
	end
	else
	begin
		select	ix.codi_cntx
		from	dbax_inst_cntx ix,
				dbax_inst_conc ic
		where	ix.codi_pers = @pCodi_pers
		and		ix.corr_inst = @pCorr_inst
		and		ix.vers_inst = @pVers_inst
		and		ix.fini_cntx = @pCntxFini
		and		isnull(ix.ffin_cntx,'') = @pCntxFfin
		and		ic.codi_pers = ix.codi_pers
		and		ic.corr_inst = ix.corr_inst
		and		ic.vers_inst = ix.vers_inst
		and		ic.pref_conc = @pPrefConc
		and		ic.codi_conc = @pCodiConc
		and		ic.codi_cntx = ix.codi_cntx
		order by 1 desc
	end
END
GO
--

/****** Object:  StoredProcedure [dbo].[SP_AX_getCntxDimension1Eje]    Script Date: 12/27/2016 08:36:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_getCntxDimension1Eje]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_getCntxDimension1Eje]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_getCntxDimension1Eje]    Script Date: 12/27/2016 08:36:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_AX_getCntxDimension1Eje]
	@p_codi_pers varchar(16),
	@p_corr_inst numeric(10,0),
	@p_vers_inst numeric(5,0),
	@p_pref_axis1 varchar(30),
	@p_codi_axis1 varchar(256),
	@p_pref_memb1 varchar(20),
	@p_codi_memb1 varchar(256),
	@p_tipo_memb1 varchar(256),
	@p_pref_conc varchar(50),
	@p_codi_conc varchar(256)
as
BEGIN
	declare @TipoPeri varchar(15)
	
	select	@TipoPeri = isnull(tipo_peri,'')
	from	dbax_defi_conc 
	where	pref_conc = @p_pref_conc 
	and		codi_conc = @p_codi_conc

	if(@TipoPeri = 'instant')
	begin
		if(@p_tipo_memb1 = 'dimension-default')
		begin
			select	distinct dc.codi_cntx
			from	dbax_inst_cntx ic
					,dbax_inst_cntx dc
					--,dbax_inst_conc ic
			where	ic.codi_pers = @p_codi_pers
			and		ic.corr_inst = @p_corr_inst
			and		ic.vers_inst = @p_vers_inst
			and		ic.ffin_cntx is null
			and		dc.codi_pers = ic.codi_pers
			and		dc.corr_inst = ic.corr_inst
			and		dc.vers_inst = ic.vers_inst
			and		dc.codi_cntx = ic.codi_cntx
			--and		ic.codi_pers = dc.codi_pers
			--and		ic.corr_inst = dc.corr_inst
			--and		ic.vers_inst = dc.vers_inst
			--and		ic.pref_conc = @p_pref_conc
			--and		ic.codi_conc = @p_codi_conc
			--and		ic.codi_cntx = dc.codi_cntx
			except
			select	dc.codi_cntx
			from	dbax_inst_dicx dc
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
		end
		else if(@p_tipo_memb1 != 'dimension-default')
		begin
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dc.ffin_cntx is null
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis1 + ':' + @p_codi_axis1
			and		dx.codi_memb = @p_pref_memb1 + ':' + @p_codi_memb1
			--and		ic.codi_pers = dx.codi_pers
			--and		ic.corr_inst = dx.corr_inst
			--and		ic.vers_inst = dx.vers_inst
			--and		ic.pref_conc = @p_pref_conc
			--and		ic.codi_conc = @p_codi_conc
			--and		ic.codi_cntx = dx.codi_cntx
			except
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis != @p_pref_axis1 + ':' + @p_codi_axis1
			--and		dx.codi_memb = @p_pref_memb2 + ':' + @p_codi_memb2
		end
	end
	else -- duration
	begin
		if(@p_tipo_memb1 = 'dimension-default')
		begin
			select	distinct dc.codi_cntx
			from	dbax_inst_cntx ic
					,dbax_inst_cntx dc
					--,dbax_inst_conc ic
			where	ic.codi_pers = @p_codi_pers
			and		ic.corr_inst = @p_corr_inst
			and		ic.vers_inst = @p_vers_inst
			and		ic.ffin_cntx is not null
			and		dc.codi_pers = ic.codi_pers
			and		dc.corr_inst = ic.corr_inst
			and		dc.vers_inst = ic.vers_inst
			and		dc.codi_cntx = ic.codi_cntx
			--and		ic.codi_pers = dc.codi_pers
			--and		ic.corr_inst = dc.corr_inst
			--and		ic.vers_inst = dc.vers_inst
			--and		ic.pref_conc = @p_pref_conc
			--and		ic.codi_conc = @p_codi_conc
			--and		ic.codi_cntx = dc.codi_cntx
			except
			select	dc.codi_cntx
			from	dbax_inst_dicx dc
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
		end
		else if(@p_tipo_memb1 != 'dimension-default')
		begin
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dc.ffin_cntx is not null
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis1 + ':' + @p_codi_axis1
			and		dx.codi_memb = @p_pref_memb1 + ':' + @p_codi_memb1
			--and		ic.codi_pers = dx.codi_pers
			--and		ic.corr_inst = dx.corr_inst
			--and		ic.vers_inst = dx.vers_inst
			--and		ic.pref_conc = @p_pref_conc
			--and		ic.codi_conc = @p_codi_conc
			--and		ic.codi_cntx = dx.codi_cntx
			except
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis != @p_pref_axis1 + ':' + @p_codi_axis1
			--and		dx.codi_memb = @p_pref_memb2 + ':' + @p_codi_memb2
		end
	end
END
GO
--
/****** Object:  StoredProcedure [dbo].[SP_AX_getCntxDimension2Ejes]    Script Date: 12/27/2016 08:37:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_getCntxDimension2Ejes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_getCntxDimension2Ejes]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_getCntxDimension2Ejes]    Script Date: 12/27/2016 08:37:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_AX_getCntxDimension2Ejes]
	@p_codi_pers varchar(16),
	@p_corr_inst numeric(10,0),
	@p_vers_inst numeric(5,0),
	@p_pref_axis1 varchar(30),
	@p_codi_axis1 varchar(256),
	@p_pref_memb1 varchar(20),
	@p_codi_memb1 varchar(256),
	@p_tipo_memb1 varchar(256),
	@p_pref_axis2 varchar(30),
	@p_codi_axis2 varchar(256),
	@p_pref_memb2 varchar(20),
	@p_codi_memb2 varchar(256),
	@p_tipo_memb2 varchar(256),
	@p_pref_conc varchar(50),
	@p_codi_conc varchar(256)
as
BEGIN
	declare @TipoPeri varchar(15)
	
	select	@TipoPeri = isnull(tipo_peri,'')
	from	dbax_defi_conc 
	where	pref_conc = @p_pref_conc 
	and		codi_conc = @p_codi_conc

	if(@TipoPeri = 'instant')
	begin
		if(@p_tipo_memb1 = 'dimension-default' and @p_tipo_memb2 = 'dimension-default')
		begin
			select	distinct dc.codi_cntx
			from	dbax_inst_cntx ic
					,dbax_inst_cntx dc
					--,dbax_inst_conc ic
			where	ic.codi_pers = @p_codi_pers
			and		ic.corr_inst = @p_corr_inst
			and		ic.vers_inst = @p_vers_inst
			and		ic.ffin_cntx is null
			and		dc.codi_pers = ic.codi_pers
			and		dc.corr_inst = ic.corr_inst
			and		dc.vers_inst = ic.vers_inst
			and		dc.codi_cntx = ic.codi_cntx
			--and		ic.codi_pers = dc.codi_pers
			--and		ic.corr_inst = dc.corr_inst
			--and		ic.vers_inst = dc.vers_inst
			--and		ic.pref_conc = @p_pref_conc
			--and		ic.codi_conc = @p_codi_conc
			--and		ic.codi_cntx = dc.codi_cntx
			except
			select	dc.codi_cntx
			from	dbax_inst_dicx dc
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
		end
		else if(@p_tipo_memb1 = 'dimension-default' and @p_tipo_memb2 != 'dimension-default')
		begin
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dc.ffin_cntx is null
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis2 + ':' + @p_codi_axis2
			and		dx.codi_memb = @p_pref_memb2 + ':' + @p_codi_memb2
			--and		ic.codi_pers = dx.codi_pers
			--and		ic.corr_inst = dx.corr_inst
			--and		ic.vers_inst = dx.vers_inst
			--and		ic.pref_conc = @p_pref_conc
			--and		ic.codi_conc = @p_codi_conc
			--and		ic.codi_cntx = dx.codi_cntx
			except
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis1 + ':' + @p_codi_axis1
		end
		else if(@p_tipo_memb1 != 'dimension-default' and @p_tipo_memb2 = 'dimension-default')
		begin
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dc.ffin_cntx is null
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis1 + ':' + @p_codi_axis1
			and		dx.codi_memb = @p_pref_memb1 + ':' + @p_codi_memb1
			--and		ic.codi_pers = dx.codi_pers
			--and		ic.corr_inst = dx.corr_inst
			--and		ic.vers_inst = dx.vers_inst
			--and		ic.pref_conc = @p_pref_conc
			--and		ic.codi_conc = @p_codi_conc
			--and		ic.codi_cntx = dx.codi_cntx
			except
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis2 + ':' + @p_codi_axis2
		end
		else if(@p_tipo_memb1 != 'dimension-default' and @p_tipo_memb2 != 'dimension-default')
		begin
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dc.ffin_cntx is null
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis1 + ':' + @p_codi_axis1
			and		dx.codi_memb = @p_pref_memb1 + ':' + @p_codi_memb1
			--and		ic.codi_pers = dx.codi_pers
			--and		ic.corr_inst = dx.corr_inst
			--and		ic.vers_inst = dx.vers_inst
			--and		ic.pref_conc = @p_pref_conc
			--and		ic.codi_conc = @p_codi_conc
			--and		ic.codi_cntx = dx.codi_cntx
			intersect
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis2 + ':' + @p_codi_axis2
			and		dx.codi_memb = @p_pref_memb2 + ':' + @p_codi_memb2
		end
	end
	else -- duration
	begin
		if(@p_tipo_memb1 = 'dimension-default' and @p_tipo_memb2 = 'dimension-default')
		begin
			select	distinct dc.codi_cntx
			from	dbax_inst_cntx ic
					,dbax_inst_cntx dc
					--,dbax_inst_conc ic
			where	ic.codi_pers = @p_codi_pers
			and		ic.corr_inst = @p_corr_inst
			and		ic.vers_inst = @p_vers_inst
			and		ic.ffin_cntx is not null
			and		dc.codi_pers = ic.codi_pers
			and		dc.corr_inst = ic.corr_inst
			and		dc.vers_inst = ic.vers_inst
			and		dc.codi_cntx = ic.codi_cntx
			--and		ic.codi_pers = dc.codi_pers
			--and		ic.corr_inst = dc.corr_inst
			--and		ic.vers_inst = dc.vers_inst
			--and		ic.pref_conc = @p_pref_conc
			--and		ic.codi_conc = @p_codi_conc
			--and		ic.codi_cntx = dc.codi_cntx
			except
			select	dc.codi_cntx
			from	dbax_inst_dicx dc
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
		end
		else if(@p_tipo_memb1 = 'dimension-default' and @p_tipo_memb2 != 'dimension-default')
		begin
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dc.ffin_cntx is not null
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis2 + ':' + @p_codi_axis2
			and		dx.codi_memb = @p_pref_memb2 + ':' + @p_codi_memb2
			--and		ic.codi_pers = dx.codi_pers
			--and		ic.corr_inst = dx.corr_inst
			--and		ic.vers_inst = dx.vers_inst
			--and		ic.pref_conc = @p_pref_conc
			--and		ic.codi_conc = @p_codi_conc
			--and		ic.codi_cntx = dx.codi_cntx
			except
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis1 + ':' + @p_codi_axis1
		end
		else if(@p_tipo_memb1 != 'dimension-default' and @p_tipo_memb2 = 'dimension-default')
		begin
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dc.ffin_cntx is not null
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis1 + ':' + @p_codi_axis1
			and		dx.codi_memb = @p_pref_memb1 + ':' + @p_codi_memb1
			--and		ic.codi_pers = dx.codi_pers
			--and		ic.corr_inst = dx.corr_inst
			--and		ic.vers_inst = dx.vers_inst
			--and		ic.pref_conc = @p_pref_conc
			--and		ic.codi_conc = @p_codi_conc
			--and		ic.codi_cntx = dx.codi_cntx
			except
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis2 + ':' + @p_codi_axis2
		end
		else if(@p_tipo_memb1 != 'dimension-default' and @p_tipo_memb2 != 'dimension-default')
		begin
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dc.ffin_cntx is not null
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis1 + ':' + @p_codi_axis1
			and		dx.codi_memb = @p_pref_memb1 + ':' + @p_codi_memb1
			--and		ic.codi_pers = dx.codi_pers
			--and		ic.corr_inst = dx.corr_inst
			--and		ic.vers_inst = dx.vers_inst
			--and		ic.pref_conc = @p_pref_conc
			--and		ic.codi_conc = @p_codi_conc
			--and		ic.codi_cntx = dx.codi_cntx
			intersect
			select	dx.codi_cntx
			from	dbax_inst_cntx dc
					,dbax_inst_dicx dx
					--,dbax_inst_conc ic
			where	dc.codi_pers = @p_codi_pers
			and		dc.corr_inst = @p_corr_inst
			and		dc.vers_inst = @p_vers_inst
			and		dx.codi_pers = dc.codi_pers
			and		dx.corr_inst = dc.corr_inst
			and		dx.vers_inst = dc.vers_inst
			and		dx.codi_cntx = dc.codi_cntx
			and		dx.codi_axis = @p_pref_axis2 + ':' + @p_codi_axis2
			and		dx.codi_memb = @p_pref_memb2 + ':' + @p_codi_memb2
		end
	end
END
GO
--
/****** Object:  StoredProcedure [dbo].[SP_AX_GetMiembrosContexto]    Script Date: 12/27/2016 08:39:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_GetMiembrosContexto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_GetMiembrosContexto]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_GetMiembrosContexto]    Script Date: 12/27/2016 08:39:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_AX_GetMiembrosContexto](
		@pCodiPers varchar(16),
		@pCorr_inst numeric(10,0),
		@pVers_inst numeric(5,0),
		@CodiCntx varchar(256)) 
as
BEGIN
	select	*
	from	dbax_inst_dicx
	where	codi_pers = @pCodiPers
	and		corr_inst = @pCorr_inst
	and		vers_inst = @pVers_inst
	and		codi_cntx = @CodiCntx
END
GO
--

/****** Object:  StoredProcedure [dbo].[SP_AX_GetConcEmprInstVers]    Script Date: 12/27/2016 08:41:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_GetConcEmprInstVers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_GetConcEmprInstVers]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_GetConcEmprInstVers]    Script Date: 12/27/2016 08:41:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_AX_GetConcEmprInstVers](
	@pCodi_pers varchar(16),
	@pCorr_inst numeric(10,0),
	@pVers_inst numeric(5,0),
	@pTextBusq varchar(256)='') 
as
BEGIN
	select distinct ic.pref_conc, 
			ic.codi_conc, 
			ic.pref_conc + '#' + ic.codi_conc as codigo, 
			dc.desc_conc
	from	dbax_inst_conc ic,
			dbax_desc_conc dc
	where	ic.codi_pers = @pCodi_pers
	and		ic.corr_inst = @pCorr_inst
	and		ic.vers_inst = @pVers_inst
	and		ic.pref_conc = 'cl-cs'
	and		dc.pref_conc = ic.pref_conc
	and		dc.codi_conc = ic.codi_conc
	and		dc.codi_lang = 'es_ES'
	and		(
			dc.codi_conc like '%' + @pTextBusq + '%'
			or
			dc.desc_conc like '%' + @pTextBusq + '%'
			)
	order by 3
END
GO
--
/****** Object:  StoredProcedure [dbo].[SP_AX_getEjesPorDimension]    Script Date: 12/27/2016 08:42:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_getEjesPorDimension]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_getEjesPorDimension]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_getEjesPorDimension]    Script Date: 12/27/2016 08:42:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_AX_getEjesPorDimension]
	@p_codi_dein varchar(50),
	@p_pref_dime varchar(20),
	@p_codi_dime varchar(256)
as
BEGIN
	select	dd.pref_axis, 
			dd.codi_axis, 
			dd.pref_axis + '#' + dd.codi_axis as 'codigo', 
			dc.desc_conc
	from	dbax_dime_diax dd,
			dbax_desc_conc dc
	where	dd.codi_dein = @p_codi_dein
	and		dd.pref_dime = @p_pref_dime
	and		dd.codi_dime = @p_codi_dime
	and		dc.pref_conc = dd.pref_axis
	and		dc.codi_conc = dd.codi_axis
	order by dd.orde_axis
END
GO
--
/****** Object:  StoredProcedure [dbo].[SP_AX_getMiembrosPorEjeEmpresaInstanciaVersion]    Script Date: 12/27/2016 08:44:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_getMiembrosPorEjeEmpresaInstanciaVersion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_getMiembrosPorEjeEmpresaInstanciaVersion]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_getMiembrosPorEjeEmpresaInstanciaVersion]    Script Date: 12/27/2016 08:44:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_AX_getMiembrosPorEjeEmpresaInstanciaVersion]
	@p_codi_pers varchar(16),
	@p_corr_inst numeric(10,0),
	@p_vers_inst numeric(5,0),
	@p_pref_axis varchar(30),
	@p_codi_axis varchar(256)
as
BEGIN
	select	dm.pref_memb, 
			dm.codi_memb, 
			dm.tipo_memb, 
			dm.pref_memb + '#' + dm.codi_memb + '#' + dm.tipo_memb + '#' + @p_pref_axis + '#' + @p_codi_axis as 'codigo', 
			dc.desc_conc,
			dm.orde_memb
	from	dbax_dime_memb dm,
			dbax_desc_conc dc
	where	pref_axis = @p_pref_axis
	and		codi_axis = @p_codi_axis	
	and		dc.pref_conc = dm.pref_memb
	and		dc.codi_conc = dm.codi_memb
	union
	select	distinct substring(ic.codi_memb, 1,2) collate Modern_Spanish_CI_AS as 'pref_memb',
			substring(ic.codi_memb, 4,1000) collate Modern_Spanish_CI_AS as 'codi_memb', 
			'dimension-domain' as 'tipo_memb', 
			replace(ic.codi_memb,':','#') + '#dimension-domain#' + @p_pref_axis + '#' + @p_codi_axis collate Modern_Spanish_CI_AS as 'codigo', 
			im.desc_memb collate Modern_Spanish_CI_AS as 'desc_conc',
			0
	from	dbax_inst_dicx ic,
			dbax_inst_memb im
	where	ic.codi_pers = @p_codi_pers
	and		ic.corr_inst = @p_corr_inst
	and		ic.vers_inst = @p_vers_inst
	and		ic.codi_axis = @p_pref_axis + ':' + @p_codi_axis
	and		ic.codi_pers = im.codi_pers collate Modern_Spanish_CS_AS
	and		ic.corr_inst = im.corr_inst 
	and		ic.vers_inst = im.vers_inst 
	and     ic.codi_memb = im.codi_memb collate Modern_Spanish_CS_AS
	order by 6 desc
END
GO
--
/****** Object:  StoredProcedure [dbo].[SP_AX_getMiembrosPorEje]    Script Date: 12/27/2016 08:44:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_getMiembrosPorEje]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_getMiembrosPorEje]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_getMiembrosPorEje]    Script Date: 12/27/2016 08:44:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[SP_AX_getMiembrosPorEje]
	@p_pref_axis varchar(30),
	@p_codi_axis varchar(256)
as
BEGIN
	select	dm.pref_memb, 
			dm.codi_memb, 
			dm.tipo_memb, 
			dm.pref_memb + '#' + dm.codi_memb + '#' + dm.tipo_memb as 'codigo', 
			dc.desc_conc
	from	dbax_dime_memb dm,
			dbax_desc_conc dc
	where	pref_axis = @p_pref_axis
	and		codi_axis = @p_codi_axis	
	and		dc.pref_conc = dm.pref_memb
	and		dc.codi_conc = dm.codi_memb
	order by dm.orde_memb
END

GO
--
/****** Object:  StoredProcedure [dbo].[SP_AX_getConceptoPorDimension]    Script Date: 12/27/2016 08:44:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_getConceptoPorDimension]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_getConceptoPorDimension]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_getConceptoPorDimension]    Script Date: 12/27/2016 08:44:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_AX_getConceptoPorDimension]
(
	@CodiInfo varchar(50),
	@PrefDime varchar(50),
	@CodiDime varchar(256)
)
AS
BEGIN
	select	dc.pref_conc + '#' + dc.codi_conc as 'codigo', dc.pref_conc, dc.codi_conc, dd.desc_conc
	from	dbax_dime_conc dc,
			dbax_desc_conc dd
	where	dc.codi_dein = @CodiInfo
	and		dc.pref_dime = @PrefDime
	and		dc.codi_dime = @CodiDime
	and		dd.pref_conc = dc.pref_conc
	and		dd.codi_conc = dc.codi_conc
	and		dd.codi_lang = 'es_ES'
	order by dc.orde_conc
END
GO
--
/****** Object:  StoredProcedure [dbo].[SP_AX_getInformesCuadrosTecnicos]    Script Date: 12/27/2016 08:45:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_getInformesCuadrosTecnicos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_getInformesCuadrosTecnicos]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_getInformesCuadrosTecnicos]    Script Date: 12/27/2016 08:45:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_AX_getInformesCuadrosTecnicos]
AS
BEGIN
	select	di.codi_info, di.desc_info
	from	dbax_info_defi id,
			dbax_desc_info di
	where	id.codi_info like '%cl-cs%cuadro%9060%'
	and		di.codi_info = id.codi_info
	and		di.codi_lang = 'es_ES'
END
GO
--
/****** Object:  StoredProcedure [dbo].[SP_AX_getCuadrosTecnicos]    Script Date: 12/27/2016 08:46:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_getCuadrosTecnicos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_getCuadrosTecnicos]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_getCuadrosTecnicos]    Script Date: 12/27/2016 08:46:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_AX_getCuadrosTecnicos]
	(
		@CodiInfo varchar(256) = ''
	)
AS
BEGIN
	if(@CodiInfo = '')
	begin
		select	dd.pref_dime, dd.codi_dime,dd.pref_dime + '#' + dd.codi_dime as 'codigo', dc.desc_conc
		from	dbax_dime_defi dd,
				dbax_desc_conc dc
		where	dd.codi_dein like '%cl-cs%cuadro%9060%'
		and		dd.pref_dime = dc.pref_conc
		and		dd.codi_dime = dc.codi_conc
		and		dc.codi_lang = 'es_ES'
	end
	else
	begin
		select	dd.pref_dime, dd.codi_dime,dd.pref_dime + '#' + dd.codi_dime as 'codigo', dc.desc_conc
		from	dbax_dime_defi dd,
				dbax_desc_conc dc
		where	dd.codi_dein = @CodiInfo
		and		dd.codi_dein like '%cl-cs%cuadro%9060%'
		and		dd.pref_dime = dc.pref_conc
		and		dd.codi_dime = dc.codi_conc
		and		dc.codi_lang = 'es_ES'
	end
END

GO
--
/****** Object:  StoredProcedure [dbo].[SP_AX_GetConceptoPrefConc]    Script Date: 12/27/2016 08:46:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_GetConceptoPrefConc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_GetConceptoPrefConc]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_GetConceptoPrefConc]    Script Date: 12/27/2016 08:46:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_AX_GetConceptoPrefConc](
		@PrefConc varchar(50),
		@CodiConc varchar(256)) 
as
BEGIN
	select	*
	from	dbax_defi_conc dc,
			dbax_desc_conc sc
	where	dc.pref_conc = @PrefConc
	and		dc.codi_conc = @CodiConc
	and		sc.pref_conc = dc.pref_conc
	and		sc.codi_conc = dc.codi_conc
END

GO
--
/****** Object:  StoredProcedure [dbo].[SP_AX_GetValoEmprInstVersPrefConcCntx]    Script Date: 12/27/2016 08:48:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_GetValoEmprInstVersPrefConcCntx]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_GetValoEmprInstVersPrefConcCntx]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_GetValoEmprInstVersPrefConcCntx]    Script Date: 12/27/2016 08:48:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_AX_GetValoEmprInstVersPrefConcCntx](
		@pCodiPers varchar(16),
		@pCorr_inst numeric(10,0),
		@pVers_inst numeric(5,0),
		@pPrefConc varchar(50),
		@pCodiConc varchar(256),
		@CodiCntx varchar(256)) 
as
BEGIN
	select	valo_cntx,
			valo_inte,
			valo_refe
	from	dbax_inst_conc
	where	codi_pers = @pCodiPers
	and		corr_inst = @pCorr_inst
	and		vers_inst = @pVers_inst
	and		pref_conc = @pPrefConc
	and		codi_conc = @pCodiConc
	and		codi_cntx = @CodiCntx
END

GO
--
/****** Object:  StoredProcedure [dbo].[SP_AX_updValorInstConc]    Script Date: 12/27/2016 08:49:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_updValorInstConc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_updValorInstConc]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_updValorInstConc]    Script Date: 12/27/2016 08:49:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_AX_updValorInstConc](
		@pCodiPers varchar(16)
		,@pCorrInst numeric(10,0)
		,@pVersInst numeric(5,0)
		,@pPrefConc varchar(50)
		,@pCodiConc varchar(256)
		,@pCodiCntx varchar(256)
		,@ValoCntx varchar(256)
		,@ValoRefe varchar(256)
		,@ValoInte varchar(256)
		) 
as
BEGIN
	declare @vCorrModi numeric(5,0)
	select	@vCorrModi = isnull(max(corr_modi),0) + 1
	from	dbax_inst_modi
	where	codi_pers = @pCodiPers
	and		corr_inst = @pCorrInst
	and		vers_inst = @pVersInst
	
	insert into [dbax_inst_modi] (corr_modi, codi_pers, corr_inst, vers_inst, pref_conc, codi_conc, codi_cntx, valo_cntx, valo_refe, valo_inte, fech_modi)
	select @vCorrModi, @pCodiPers, @pCorrInst, @pVersInst, @pPrefConc, @pCodiConc, @pCodiCntx, valo_cntx, valo_refe, valo_inte, GETDATE()
	from dbax_inst_conc
	where	codi_pers = @pCodiPers
	and		corr_inst = @pCorrInst
	and		vers_inst = @pVersInst
	and		pref_conc = @pPrefConc
	and		codi_conc = @pCodiConc
	and		codi_cntx = @pCodiCntx
	
	update	dbax_inst_conc
	set		valo_cntx = @ValoCntx, valo_refe = @ValoRefe, valo_inte = @ValoInte
	where	codi_pers = @pCodiPers
	and		corr_inst = @pCorrInst
	and		vers_inst = @pVersInst
	and		pref_conc = @pPrefConc
	and		codi_conc = @pCodiConc
	and		codi_cntx = @pCodiCntx
END
GO
--
/****** Object:  StoredProcedure [dbo].[SP_AX_insValorEdicionInstConc]    Script Date: 12/27/2016 08:50:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AX_insValorEdicionInstConc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_AX_insValorEdicionInstConc]
GO

/****** Object:  StoredProcedure [dbo].[SP_AX_insValorEdicionInstConc]    Script Date: 12/27/2016 08:50:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_AX_insValorEdicionInstConc](
		@pCodiPers varchar(16)
		,@pCorrInst numeric(10,0)
		,@pVersInst numeric(5,0)
		,@pPrefConc varchar(50)
		,@pCodiConc varchar(256)
		,@pCodiCntx varchar(256)
		,@ValoCntx varchar(256)
		,@ValoRefe varchar(256)
		,@ValoInte varchar(256)
		) 
as
BEGIN
	declare @vCorrModi numeric(5,0)
	select	@vCorrModi = isnull(max(corr_modi),0) + 1
	from	dbax_inst_modi
	where	codi_pers = @pCodiPers
	and		corr_inst = @pCorrInst
	and		vers_inst = @pVersInst
	
	--declare @vCorrConc numeric(10,0)
	--select	@vCorrConc = MAX(corr_conc) + 1
	--from	dbax_inst_conc
	--where	codi_pers = @pCodiPers
	--and		corr_inst = @pCorrInst
	--and		vers_inst = @pVersInst
	
	declare @vTipoValo varchar(256)
	select	@vTipoValo = tipo_valo
	from	dbax_defi_conc
	where	pref_conc = @pPrefConc
	and		codi_conc = @pCodiConc
	
	declare @vCodiUnit varchar(50)
	select	top 1 @vCodiUnit = ic.codi_unit
	from	dbax_inst_conc ic,
			dbax_defi_conc dc
	where	ic.codi_pers = @pCodiPers
	and		ic.corr_inst = @pCorrInst
	and		ic.vers_inst = @pVersInst
	and		dc.tipo_valo = @vTipoValo
	
	insert into [dbax_inst_modi] (corr_modi, codi_pers, corr_inst, vers_inst, pref_conc, codi_conc, codi_cntx, valo_cntx, valo_refe, valo_inte, fech_modi)
	select @vCorrModi, @pCodiPers, @pCorrInst, @pVersInst, @pPrefConc, @pCodiConc, @pCodiCntx, null, null, null, GETDATE()
	
	insert into dbax_inst_conc (codi_pers, corr_inst, vers_inst, pref_conc, codi_conc, codi_cntx, valo_cntx, codi_unit, valo_orig, valo_refe, valo_inte)
	values (@pCodiPers, @pCorrInst, @pVersInst, @pPrefConc, @pCodiConc, @pCodiCntx, @ValoCntx, @vCodiUnit, @ValoCntx, @ValoRefe, @ValoInte)
END

GO




