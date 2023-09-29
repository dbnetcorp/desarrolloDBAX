USE [dbaxBI]
GO
/****** Object:  StoredProcedure [dbo].[prc_bi_dbax_create_3]    Script Date: 01/06/2017 12:57:03 ******/
DROP PROCEDURE [dbo].[prc_bi_dbax_create_3]
GO
/****** Object:  StoredProcedure [dbo].[prc_table_create]    Script Date: 01/06/2017 12:57:03 ******/
DROP PROCEDURE [dbo].[prc_table_create]
GO
/****** Object:  StoredProcedure [dbo].[prc_table_create_3]    Script Date: 01/06/2017 12:57:03 ******/
DROP PROCEDURE [dbo].[prc_table_create_3]
GO
/****** Object:  StoredProcedure [dbo].[prc_bi_dbax_Fact_Table]    Script Date: 01/06/2017 12:57:03 ******/
DROP PROCEDURE [dbo].[prc_bi_dbax_Fact_Table]
GO
/****** Object:  StoredProcedure [dbo].[prc_bi_dbax_Fact_Table_2]    Script Date: 01/06/2017 12:57:03 ******/
DROP PROCEDURE [dbo].[prc_bi_dbax_Fact_Table_2]
GO
/****** Object:  StoredProcedure [dbo].[prc_bi_dbax_Fact_Table_3]    Script Date: 01/06/2017 12:57:03 ******/
DROP PROCEDURE [dbo].[prc_bi_dbax_Fact_Table_3]
GO
/****** Object:  StoredProcedure [dbo].[prc_bi_insertaDatosPeriodoEmpresa]    Script Date: 01/06/2017 12:57:03 ******/
DROP PROCEDURE [dbo].[prc_bi_insertaDatosPeriodoEmpresa]
GO
/****** Object:  StoredProcedure [dbo].[prc_PRUEBA]    Script Date: 01/06/2017 12:57:03 ******/
DROP PROCEDURE [dbo].[prc_PRUEBA]
GO
/****** Object:  UserDefinedFunction [dbo].[FU_PF_getMaxOrdenConcepto]    Script Date: 01/06/2017 12:57:03 ******/
DROP FUNCTION [dbo].[FU_PF_getMaxOrdenConcepto]
GO
/****** Object:  UserDefinedFunction [dbo].[FU_PF_ObtieneMiembro]    Script Date: 01/06/2017 12:57:03 ******/
DROP FUNCTION [dbo].[FU_PF_ObtieneMiembro]
GO
/****** Object:  UserDefinedFunction [dbo].[FU_PF_ObtieneMiembro]    Script Date: 01/06/2017 12:57:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FU_PF_ObtieneMiembro] 
(
	-- Add the parameters for the function here
	@CodiPers varchar(16),
	@CorrInst numeric(10,0),
	@VersInst numeric(5,0),
	@CodiAxis varchar(256),
	@CodiCntx varchar(350),
	@Modo varchar(1)
)
RETURNS varchar(256)
AS
BEGIN
	DECLARE @vMiembro varchar(256)
	if(@Modo='S' and (@CodiAxis='cl-cs:DetalleSubRamosEje' or @CodiAxis='cl-cs:RentasVitaliciasEje'))
	begin
			select	@vMiembro = codi_memb 
			from	dbax.dbo.dbax_inst_dicx 
			where	codi_pers = @CodiPers
			and		corr_inst = @CorrInst
			and		vers_inst = @VersInst
			and		codi_cntx = @CodiCntx
			and		codi_axis = @CodiAxis
		
		if(@vMiembro is null)
			set @vMiembro = '0'
	end
	else
	if(@Modo='R' and @CodiAxis='cl-cs:RamosEje')
	begin
		/*select	@vMiembro = replace(replace(replace(replace(upper(dc.codi_memb),'TX','' ),':',''),'C',''),'ITEM','')
		from	dbax.dbo.dbax_inst_dicx dc
		where	dc.codi_pers = @CodiPers
		and		dc.corr_inst = @CorrInst
		and		dc.vers_inst = @VersInst
		and		dc.codi_cntx = @CodiCntx
		and		dc.codi_axis = @CodiAxis*/

	select	--@vMiembro = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(im.desc_memb),'TX','' ),':',''),'C',''),'ITEM',''),',',''),'.',''),'RSA',''),'item',''),'01','0'),'02','2'),'03','3'),'04','4'),'05','5'),'06','6'),'07','7'),'08','8'),'09','9')
			@vMiembro = replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(im.desc_memb),'TX','' ),':',''),'C',''),'ITEM',''),',',''),'.',''),'RSA',''),'item',''),' ','')
	from	dbax.dbo.dbax_inst_dicx dc,
			dbax.dbo.dbax_inst_memb im
	where	dc.codi_pers = @CodiPers
	and		dc.corr_inst = @CorrInst
	and		dc.vers_inst = @VersInst
	and		dc.codi_cntx = @CodiCntx
	and		dc.codi_axis = @CodiAxis
	and		im.codi_pers collate Modern_Spanish_CI_AS = dc.codi_pers collate Modern_Spanish_CI_AS
	and		im.corr_inst = dc.corr_inst
	and		im.vers_inst = dc.vers_inst
	and		im.codi_memb collate Modern_Spanish_CI_AS = dc.codi_memb

		if(@vMiembro is null)
			set @vMiembro = '0'
	end

	return @vMiembro
END
GO
/****** Object:  UserDefinedFunction [dbo].[FU_PF_getMaxOrdenConcepto]    Script Date: 01/06/2017 12:57:03 ******/
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
/****** Object:  StoredProcedure [dbo].[prc_PRUEBA]    Script Date: 01/06/2017 12:57:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[prc_PRUEBA] 
	
as

SET NOCOUNT ON

BEGIN

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PF_2_06_Periodos') 
	BEGIN
			CREATE TABLE [dbo].[PF_2_06_Periodos](
				[CodigoPeriodo] [varchar](256) COLLATE Modern_Spanish_CI_AS NULL,
				[Periodo] [varchar](7) COLLATE Modern_Spanish_CI_AS NOT NULL,
			CONSTRAINT [PK2_Periodos] PRIMARY KEY CLUSTERED 
			(
				[Periodo] DESC
			)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
			) ON [PRIMARY]

	END
ELSE
	BEGIN

	INSERT INTO PF_2_06_Periodos 
	select	distinct
			codi_cntx			as CodigoPeriodo, 
			desc_cntx			as Periodo
	from BI_SG_Periodos A
	where   not exists (select	1 
						from 	PF_2_06_Periodos B 
						where codi_cntx = CodigoPeriodo
						and   desc_cntx = Periodo
						)
	order by codi_cntx
	END
END
GO
/****** Object:  StoredProcedure [dbo].[prc_bi_insertaDatosPeriodoEmpresa]    Script Date: 01/06/2017 12:57:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[prc_bi_insertaDatosPeriodoEmpresa]
	@P_EMPRESA VARCHAR(30),
	@P_PERIODO VARCHAR(7)
as
BEGIN
	select getdate(), 'INICIO CARGA PERIODO POR EMPRESA: ' + @P_PERIODO 

	delete	PF_07_Valores
	where	PKEmpresa = @P_EMPRESA
	and		Periodo = @P_PERIODO;
	
	INSERT INTO PF_02_Empresas 
	SELECT 	codi_segm + '_' + codi_pers	as PKEmpresa, 
			codi_pers			as Rut, 
			nomb_pers			as RazonSocial,
			codi_pers + ' ' + nomb_pers	as RazonSocialCompleta,
			empr_vige			as Vigente FROM BI_SG_Empresas A 
	where   not exists (select	1 
						from 	PF_02_Empresas B 
						where	A.codi_pers = B.Rut
						and     A.codi_segm + '_' + A.codi_pers = B.PKEmpresa
						)

	insert PF_03_Conceptos (PKConcepto,Cuadro,Tabla,CodigoConcepto, Concepto)
	select	distinct case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end + '_' + dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime as PKConcepto,
			substring(di.desc_info, len(di.desc_info) - charindex(' ]',reverse(di.desc_info))+2,10000) as Cuadro,
			--di.desc_info,
			de2.desc_conc as Tabla,
			case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end + '_' + dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime as CodigoConcepto,
			dbo.FU_PF_getMaxOrdenConcepto(dc.pref_conc, dc.codi_conc) + ' - ' + de.desc_conc as Concepto
			--df.*
	from	dbax.dbo.dbax_dime_conc dc,
			dbax.dbo.dbax_desc_conc de,
			dbax.dbo.dbax_desc_info di,
			dbax.dbo.dbax_desc_conc de2,
			dbax.dbo.dbax_defi_conc df
	where	dc.codi_dein like '%cuadro%'
	and		de.pref_conc = dc.pref_conc
	and		de.codi_conc = dc.codi_conc
	and		di.codi_info = dc.codi_dein
	and		di.codi_lang = 'es_ES'
	and		di.tipo_info = 'D'
	and		de2.pref_conc = dc.pref_dime
	and		de2.codi_conc = dc.codi_dime
	and		dc.pref_conc = df.pref_conc
	and		dc.codi_conc = df.codi_conc
	and		df.tipo_cuen != 'abstract'
	and		case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end + '_' + dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime not in (
				select PKConcepto collate Modern_Spanish_CI_AS from PF_03_Conceptos)

	declare @vCodiEmpr varchar(20)
	declare @vCorrInst varchar(10) 

	declare curEmpresas cursor for
		select	codi_pers,replace(@P_PERIODO,'-','') 
		from	dbax.dbo.dbax_defi_pers 
		where	codi_pers = @P_EMPRESA
		and		codi_segm in ('SEGUROVIDA','SEGUROGRAL') --and codi_pers in (700157302)

	declare @vRamo varchar(300)
	declare @vSubRamo varchar(300)
	declare @vCodiCntx varchar(300)
	
	open curEmpresas
	fetch next from curEmpresas into @vCodiEmpr, @vCorrInst
	while @@fetch_status = 0
	begin
		print @vCodiEmpr
		
		declare @vVersInst varchar(3)
		set @vVersInst = dbax.dbo.FU_AX_getPersCorrVersInst(@vCodiEmpr, @vCorrInst,'I', 'M')
		
		delete from PF_07_Valores 
		where PKEmpresa like '%[_]' + @vCodiEmpr
		and	Periodo = @P_PERIODO
		
		declare curContextos cursor for
			select	distinct ic.codi_cntx
				from	dbax.dbo.dbax_info_defi id,
						dbax.dbo.dbax_dime_conc dc,
						dbax.dbo.dbax_defi_conc df,
						dbax.dbo.dbax_inst_conc ic,
						dbax.dbo.dbax_inst_dicx ix,
						dbax.dbo.dbax_defi_pers dp
				where	id.indi_vige = '1'
				and		id.tipo_info = 'D'
				and		id.codi_info like '%cuadro%'
				and		dc.codi_dein = id.codi_info
				and		dc.pref_conc = df.pref_conc
				and		dc.codi_conc = df.codi_conc
				and		df.tipo_cuen != 'abstract'
				and		dp.codi_pers = @vCodiEmpr
				and		dp.codi_segm = case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end
				and		ic.codi_pers = dp.codi_pers
				and		ic.corr_inst = @vCorrInst
				and		ic.vers_inst = @vVersInst
				and		ic.pref_conc = dc.pref_conc
				and		ic.codi_conc = dc.codi_conc
				and		ic.codi_conc not in ('RamosVida', 'RamosGenerales')
				and		ix.codi_pers = ic.codi_pers
				and		ix.corr_inst = ic.corr_inst
				and		ix.vers_inst = ic.vers_inst
				and		ix.codi_cntx = ic.codi_cntx
				and		ix.codi_axis in ('cl-cs:RamosEje','cl-cs:DetalleSubRamosEje')

		open curContextos
		fetch next from curContextos into @vCodiCntx
		while @@fetch_status = 0
		begin
			select @vRamo = dbo.FU_PF_ObtieneMiembro (@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:RamosEje', @vCodiCntx, 'R')
			select @vSubRamo = dbo.FU_PF_ObtieneMiembro (@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:DetalleSubRamosEje', @vCodiCntx,'S') 
			
			insert PF_07_Valores
			select Segmento, @P_PERIODO, Segmento + '_' + codi_pers as PKEmpresa, Segmento + '_' + PKConcepto, Segmento + '_' + @vRamo as PKRamo, Segmento + '_' + @vSubRamo as PKSubRamo, ValorPesos, ValorUF, ValorUSD 
			from (
					select	distinct ic.codi_pers, ic.corr_inst, ic.vers_inst, 
							case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end as Segmento,
							dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime as PKConcepto,
							convert(numeric,replace(ic.valo_cntx,',','.')) as ValorPesos,
							convert(numeric,replace(ic.valo_refe,',','.')) as ValorUF,
							convert(numeric,replace(ic.valo_inte,',','.')) as ValorUSD
					from	dbax.dbo.dbax_info_defi id,
							dbax.dbo.dbax_dime_conc dc,
							dbax.dbo.dbax_defi_conc df,
							dbax.dbo.dbax_inst_conc ic,
							dbax.dbo.dbax_inst_dicx ix,
							dbax.dbo.dbax_defi_pers dp
					where	id.indi_vige = '1'
					and		id.tipo_info = 'D'
					and		id.codi_info like '%cuadro%'
					and		dc.codi_dein = id.codi_info
					and		dc.pref_conc = df.pref_conc
					and		dc.codi_conc = df.codi_conc
					and		df.tipo_cuen != 'abstract'
					and		dp.codi_pers = @vCodiEmpr
					and		dp.codi_segm = case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end
					and		ic.codi_pers = dp.codi_pers
					and		ic.corr_inst = @vCorrInst
					and		ic.vers_inst = @vVersInst
					and		ic.pref_conc = dc.pref_conc
					and		ic.codi_conc = dc.codi_conc
					and		ic.codi_conc not in ('RamosVida', 'RamosGenerales')
					and		ic.codi_cntx = @vCodiCntx
					and		ix.codi_pers = ic.codi_pers
					and		ix.corr_inst = ic.corr_inst
					and		ix.vers_inst = ic.vers_inst
					and		ix.codi_cntx = ic.codi_cntx
					and		ix.codi_axis in ('cl-cs:RamosEje','cl-cs:DetalleSubRamosEje'))V
				where	@vSubRamo != '0'
				and		@vRamo != '0'
				and		@vRamo != '421'
				and		@vRamo != '422'
				
			fetch next from curContextos into @vCodiCntx
		end
		close curContextos
		deallocate curContextos
		
		declare curContextos cursor for
			select	distinct ic.codi_cntx
				from	dbax.dbo.dbax_info_defi id,
						dbax.dbo.dbax_dime_conc dc,
						dbax.dbo.dbax_defi_conc df,
						dbax.dbo.dbax_inst_conc ic,
						dbax.dbo.dbax_inst_dicx ix,
						dbax.dbo.dbax_defi_pers dp
				where	id.indi_vige = '1'
				and		id.tipo_info = 'D'
				and		id.codi_info like '%cuadro%'
				and		dc.codi_dein = id.codi_info
				and		dc.pref_conc = df.pref_conc
				and		dc.codi_conc = df.codi_conc
				and		df.tipo_cuen != 'abstract'
				and		dp.codi_pers = @vCodiEmpr
				and		dp.codi_segm = case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end
				and		ic.codi_pers = dp.codi_pers
				and		ic.corr_inst = @vCorrInst
				and		ic.vers_inst = @vVersInst
				and		ic.pref_conc = dc.pref_conc
				and		ic.codi_conc = dc.codi_conc
				and		ic.codi_conc not in ('RamosVida', 'RentasVitaliciasEje')
				and		ix.codi_pers = ic.codi_pers
				and		ix.corr_inst = ic.corr_inst
				and		ix.vers_inst = ic.vers_inst
				and		ix.codi_cntx = ic.codi_cntx
				and		ix.codi_axis = 'cl-cs:RentasVitaliciasEje'

	
		open curContextos
		fetch next from curContextos into @vCodiCntx
		while @@fetch_status = 0
		begin
			select @vRamo = dbo.FU_PF_ObtieneMiembro (@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:RamosEje', @vCodiCntx, 'R')
			select @vSubRamo = dbo.FU_PF_ObtieneMiembro (@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:RentasVitaliciasEje', @vCodiCntx,'S') 
			
			insert PF_07_Valores
			select Segmento, @P_PERIODO, Segmento + '_' + codi_pers as PKEmpresa, Segmento + '_' + PKConcepto, Segmento + '_' + @vRamo as PKRamo, Segmento + '_' + @vSubRamo as PKSubRamo, ValorPesos, ValorUF, ValorUSD 
			from (
					select	distinct ic.codi_pers, ic.corr_inst, ic.vers_inst, 
							case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end as Segmento,
							dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime as PKConcepto,
							convert(numeric,replace(ic.valo_cntx,',','.')) as ValorPesos,
							convert(numeric,replace(ic.valo_refe,',','.')) as ValorUF,
							convert(numeric,replace(ic.valo_inte,',','.')) as ValorUSD
					from	dbax.dbo.dbax_info_defi id,
							dbax.dbo.dbax_dime_conc dc,
							dbax.dbo.dbax_defi_conc df,
							dbax.dbo.dbax_inst_conc ic,
							dbax.dbo.dbax_inst_dicx ix,
							dbax.dbo.dbax_defi_pers dp
					where	id.indi_vige = '1'
					and		id.tipo_info = 'D'
					and		id.codi_info like '%cuadro%'
					and		dc.codi_dein = id.codi_info
					and		dc.pref_conc = df.pref_conc
					and		dc.codi_conc = df.codi_conc
					and		df.tipo_cuen != 'abstract'
					and		dp.codi_pers = @vCodiEmpr
					and		dp.codi_segm = case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end
					and		ic.codi_pers = dp.codi_pers
					and		ic.corr_inst = @vCorrInst
					and		ic.vers_inst = @vVersInst
					and		ic.pref_conc = dc.pref_conc
					and		ic.codi_conc = dc.codi_conc
					and		ic.codi_conc not in ('RamosVida', 'RentasVitaliciasEje')
					and		ic.codi_cntx = @vCodiCntx
					and		ix.codi_pers = ic.codi_pers
					and		ix.corr_inst = ic.corr_inst
					and		ix.vers_inst = ic.vers_inst
					and		ix.codi_cntx = ic.codi_cntx
					and		ix.codi_axis = 'cl-cs:RentasVitaliciasEje') V
				where	@vSubRamo != '0'
				and		@vRamo != '421'
				and		@vRamo != '422'
				
				
			fetch next from curContextos into @vCodiCntx
		end
		close curContextos
		deallocate curContextos

		fetch next from curEmpresas into @vCodiEmpr, @vCorrInst
	end
	close curEmpresas
	deallocate curEmpresas	

	select getdate(), 'FIN CARGA PERIODO POR EMPRESA: ' + @P_PERIODO 	
END
GO
/****** Object:  StoredProcedure [dbo].[prc_bi_dbax_Fact_Table_3]    Script Date: 01/06/2017 12:57:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<JGALDAMEZ>
-- Create date: <2014-03-06>
-- Description:	<Inserta>
-- =============================================
CREATE PROCEDURE [dbo].[prc_bi_dbax_Fact_Table_3] 
		@P_PERIODO VARCHAR(30)
AS
SET NOCOUNT ON

BEGIN

	
	INSERT INTO PF_07_Valores 
	select	codiSegm			as Segmento, 
			codi_cntx			as Periodo, 
			codiSegm + '_' + codiPers	as PKEmpresa, 
			codiSegm + '_' + codiConc	as PKConcepto, 
			codiSegm + '_' + codiRamo	as PKRamo, 
			codiSegm + '_' + subRamo	as PKSubRamo, 
			convert(numeric(38,4),replace(valo_cntx,',',''))			as ValorPesos, 
			convert(numeric(38,4), valo_refe)			as ValorUF, 
			convert(numeric(38,4), valo_inte)			as ValorUSD
		from	BI_SG_Fact_Table
		where	exists (select	1
						from	PF_04_Ramos
						where	PKRamo		= codiSegm + '_' + codiRamo) 
		/*and     exists (select	1 
						from	PF_05_SubRamos
						where	PKSubRamo	= codiSegm + '_' + subRamo) */
		and     exists (select	1 
						from	PF_03_Conceptos 
						where	PKConcepto 	=  codiSegm + '_' + codiConc)
	and		codi_cntx = 	@P_PERIODO
					
	select getdate(), 'Tabla BI_SG_Fact_Table Creada'

	/*
	update	PF_07_Valores
	set	ValorPesos = replace(ValorPesos,',','')
	where	charindex(',',ValorPesos) > 1
	*/
	
	/*
	alter table PF_07_Valores alter column Segmento		varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column Periodo		varchar(7)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKEmpresa	varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKRamo		varchar(80)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKSubRamo	varchar(80)	collate Modern_Spanish_CI_AS
	alter table PF_07_Valores alter column PKConcepto	varchar(256)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column ValorPesos	numeric(38,4)
	alter table PF_07_Valores alter column ValorUF		numeric(38,4)
	alter table PF_07_Valores alter column ValorUsd		numeric(38,4)

	alter table PF_07_Valores WITH CHECK add constraint	Valores_FK_Segmentos
		FOREIGN KEY	(Segmento) REFERENCES PF_01_Segmentos (Segmento)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Segmentos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Periodos
		FOREIGN KEY (Periodo) REFERENCES PF_06_Periodos (Periodo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Periodos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Empresas
		FOREIGN KEY	(PKEmpresa)	REFERENCES PF_02_Empresas  (PKEmpresa)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Empresas
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Ramos
		FOREIGN KEY (PKRamo) REFERENCES PF_04_Ramos (PKRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Ramos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_SubRamos
		FOREIGN KEY (PKSubRamo) REFERENCES PF_05_SubRamos  (PKSubRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_SubRamos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Conceptos
		FOREIGN KEY (PKConcepto) REFERENCES PF_03_Conceptos (PKConcepto)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Conceptos
	*/
	

	-- Limpia periodos
	delete	PF_06_Periodos
	from	PF_06_Periodos p
	where	not exists (select 1 from PF_07_Valores v where v.Periodo = p.Periodo)

	drop table dbo.ZZ_inst_ramo
	
	drop table dbo.ZZ_inst_conc
	

	select getdate(), 'Completando Totales'

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, 'SEGUROGRAL_cl-cs:MasivoMiembro' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  v1.Periodo = 	@P_PERIODO
	and   not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = 'SEGUROGRAL_cl-cs:MasivoMiembro')
	and   Segmento = 'SEGUROGRAL'
	and   (	PKSubRamo like '%CarteraHipotecariaMiembro'
		or  PKSubRamo like '%CarteraConsumoMiembro'
		or  PKSubRamo like '%OtraCarteraMiembro')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, 'SEGUROVIDA_cl-cs:MasivoMiembro' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where	   v1.Periodo = 	@P_PERIODO
	and  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = 'SEGUROVIDA_cl-cs:MasivoMiembro')
	and   Segmento = 'SEGUROVIDA'
	and   (	PKSubRamo like '%CarteraHipotecariaMiembro'
		or  PKSubRamo like '%CarteraConsumoMiembro'
		or  PKSubRamo like '%OtraCarteraMiembro')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, 'SEGUROGRAL_0' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where	   v1.Periodo = 	@P_PERIODO
	and  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = 'SEGUROGRAL_0')
	and   Segmento = 'SEGUROGRAL'
	and   (	PKSubRamo like '%IndustriaInfraestructuraComercioMiembro'
		or  PKSubRamo like '%IndividualesMiembro'
		or  PKSubRamo like '%ColectivosMiembro'
		or  PKSubRamo like '%MasivoMiembro'
		or  PKSubRamo like '%PrevisionalesMiembro')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, 'SEGUROVIDA_0' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where	   v1.Periodo = 	@P_PERIODO
	and  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = 'SEGUROVIDA_0')
	and   Segmento = 'SEGUROVIDA'
	and   (	PKSubRamo like '%IndustriaInfraestructuraComercioMiembro'
		or  PKSubRamo like '%IndividualesMiembro'
		or  PKSubRamo like '%ColectivosMiembro'
		or  PKSubRamo like '%MasivoMiembro'
		or  PKSubRamo like '%PrevisionalesMiembro')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	select getdate(), 'FIN CARGA PERIODO: ' + @P_PERIODO

END
GO
/****** Object:  StoredProcedure [dbo].[prc_bi_dbax_Fact_Table_2]    Script Date: 01/06/2017 12:57:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<JGALDAMEZ>
-- Create date: <2014-03-06>
-- Description:	<Inserta>
-- =============================================
CREATE PROCEDURE [dbo].[prc_bi_dbax_Fact_Table_2] 
	
AS
SET NOCOUNT ON

BEGIN

	INSERT INTO PF_07_Valores 
	select	codi_segm			as Segmento, 
			codi_cntx			as Periodo, 
			codi_segm + '_' + codi_pers	as PKEmpresa, 
			codi_segm + '_' + codi_conc	as PKConcepto, 
			codi_segm + '_' + codi_ramo	as PKRamo, 
			codi_segm + '_' + sub_ramo	as PKSubRamo, 
			convert(numeric(38,4),replace(valo_cntx,',',''))			as ValorPesos, 
			convert(numeric(38,4), valo_refe)			as ValorUF, 
			convert(numeric(38,4), valo_inte)			as ValorUSD
		from	BI_SG_Fact_Table
		where	exists (select	1
						from	PF_04_Ramos
						where	PKRamo		= codi_segm + '_' + codi_ramo) 
		and     exists (select	1 
						from	PF_05_SubRamos
						where	PKSubRamo	= codi_segm + '_' + sub_ramo) 
		and     exists (select	1 
						from	PF_03_Conceptos 
						where	PKConcepto 	=  codi_segm + '_' + codi_conc)
	and		not exists (select	1 
							from 	PF_07_Valores B 
							where codi_segm = B.Segmento
							and codi_cntx = B.Periodo 
							and codi_segm + '_' + codi_pers = B.PKEmpresa
							and codi_segm + '_' + codi_conc	= B.PKConcepto
							and codi_segm + '_' + codi_ramo	= B.PKRamo 
							and codi_segm + '_' + sub_ramo  = B.PKSubRamo 
							and convert(numeric(38,4),replace(valo_cntx,',','')) = ValorPesos
							and convert(numeric(38,4), valo_refe) = ValorUF
							and convert(numeric(38,4), valo_inte) = ValorUSD
							)
					
	select getdate(), 'Tabla BI_SG_Fact_Table Creada'

	/*
	update	PF_07_Valores
	set	ValorPesos = replace(ValorPesos,',','')
	where	charindex(',',ValorPesos) > 1
	*/
	
	/*
	alter table PF_07_Valores alter column Segmento		varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column Periodo		varchar(7)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKEmpresa	varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKRamo		varchar(80)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKSubRamo	varchar(80)	collate Modern_Spanish_CI_AS
	alter table PF_07_Valores alter column PKConcepto	varchar(256)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column ValorPesos	numeric(38,4)
	alter table PF_07_Valores alter column ValorUF		numeric(38,4)
	alter table PF_07_Valores alter column ValorUsd		numeric(38,4)

	alter table PF_07_Valores WITH CHECK add constraint	Valores_FK_Segmentos
		FOREIGN KEY	(Segmento) REFERENCES PF_01_Segmentos (Segmento)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Segmentos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Periodos
		FOREIGN KEY (Periodo) REFERENCES PF_06_Periodos (Periodo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Periodos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Empresas
		FOREIGN KEY	(PKEmpresa)	REFERENCES PF_02_Empresas  (PKEmpresa)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Empresas
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Ramos
		FOREIGN KEY (PKRamo) REFERENCES PF_04_Ramos (PKRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Ramos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_SubRamos
		FOREIGN KEY (PKSubRamo) REFERENCES PF_05_SubRamos  (PKSubRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_SubRamos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Conceptos
		FOREIGN KEY (PKConcepto) REFERENCES PF_03_Conceptos (PKConcepto)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Conceptos
	*/
	

	-- Limpia periodos
	delete	PF_06_Periodos
	from	PF_06_Periodos p
	where	not exists (select 1 from PF_07_Valores v where v.Periodo = p.Periodo)

	drop table dbo.ZZ_inst_ramo
	
	drop table dbo.ZZ_inst_conc
	

	select getdate(), 'Completando Totales'

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, 'SEGUROGRAL_cl-cs:MasivoMiembro' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = 'SEGUROGRAL_cl-cs:MasivoMiembro')
	and   Segmento = 'SEGUROGRAL'
	and   (	PKSubRamo like '%CarteraHipotecariaMiembro'
		or  PKSubRamo like '%CarteraConsumoMiembro'
		or  PKSubRamo like '%OtraCarteraMiembro')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, 'SEGUROVIDA_cl-cs:MasivoMiembro' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = 'SEGUROVIDA_cl-cs:MasivoMiembro')
	and   Segmento = 'SEGUROVIDA'
	and   (	PKSubRamo like '%CarteraHipotecariaMiembro'
		or  PKSubRamo like '%CarteraConsumoMiembro'
		or  PKSubRamo like '%OtraCarteraMiembro')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, 'SEGUROGRAL_0' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = 'SEGUROGRAL_0')
	and   Segmento = 'SEGUROGRAL'
	and   (	PKSubRamo like '%IndustriaInfraestructuraComercioMiembro'
		or  PKSubRamo like '%IndividualesMiembro'
		or  PKSubRamo like '%ColectivosMiembro'
		or  PKSubRamo like '%MasivoMiembro'
		or  PKSubRamo like '%PrevisionalesMiembro')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, 'SEGUROVIDA_0' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = 'SEGUROVIDA_0')
	and   Segmento = 'SEGUROVIDA'
	and   (	PKSubRamo like '%IndustriaInfraestructuraComercioMiembro'
		or  PKSubRamo like '%IndividualesMiembro'
		or  PKSubRamo like '%ColectivosMiembro'
		or  PKSubRamo like '%MasivoMiembro'
		or  PKSubRamo like '%PrevisionalesMiembro')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	select getdate(), 'FIN'

END
GO
/****** Object:  StoredProcedure [dbo].[prc_bi_dbax_Fact_Table]    Script Date: 01/06/2017 12:57:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<JGALDAMEZ>
-- Create date: <2014-03-06>
-- Description:	<Inserta>
-- =============================================
CREATE PROCEDURE [dbo].[prc_bi_dbax_Fact_Table] 
	
as

SET NOCOUNT ON

BEGIN

	select	codi_segm			as Segmento, 
		codi_cntx			as Periodo, 
		codi_segm + '_' + codi_pers	as PKEmpresa, 
		codi_segm + '_' + codi_conc	as PKConcepto, 
		codi_segm + '_' + codi_ramo	as PKRamo, 
		codi_segm + '_' + sub_ramo	as PKSubRamo, 
		valo_cntx			as ValorPesos, 
		valo_refe			as ValorUF, 
		valo_inte			as ValorUSD
	into    PF_07_Valores
	from	BI_SG_Fact_Table
	where	exists (select	1
			from	PF_04_Ramos
			where	PKRamo		= codi_segm + '_' + codi_ramo) 
	and     exists (select	1 
			from	PF_05_SubRamos
			where	PKSubRamo	= codi_segm + '_' + sub_ramo) 
	and     exists (select	1 
			from	PF_03_Conceptos 
			where	PKConcepto 	=  codi_segm + '_' + codi_conc)
					
	
	select getdate(), 'Tabla BI_SG_Fact_Table Creada'

	update	PF_07_Valores
	set	ValorPesos = replace(ValorPesos,',','')
	where	charindex(',',ValorPesos) > 1
	

	alter table PF_07_Valores alter column Segmento		varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column Periodo		varchar(7)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKEmpresa	varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKRamo		varchar(80)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKSubRamo	varchar(80)	collate Modern_Spanish_CI_AS
	alter table PF_07_Valores alter column PKConcepto	varchar(256)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column ValorPesos	numeric(38,4)
	alter table PF_07_Valores alter column ValorUF		numeric(38,4)
	alter table PF_07_Valores alter column ValorUsd		numeric(38,4)

	alter table PF_07_Valores WITH CHECK add constraint	Valores_FK_Segmentos
		FOREIGN KEY	(Segmento) REFERENCES PF_01_Segmentos (Segmento)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Segmentos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Periodos
		FOREIGN KEY (Periodo) REFERENCES PF_06_Periodos (Periodo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Periodos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Empresas
		FOREIGN KEY	(PKEmpresa)	REFERENCES PF_02_Empresas  (PKEmpresa)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Empresas
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Ramos
		FOREIGN KEY (PKRamo) REFERENCES PF_04_Ramos (PKRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Ramos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_SubRamos
		FOREIGN KEY (PKSubRamo) REFERENCES PF_05_SubRamos  (PKSubRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_SubRamos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Conceptos
		FOREIGN KEY (PKConcepto) REFERENCES PF_03_Conceptos (PKConcepto)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Conceptos
	

	-- Limpia periodos
	delete	PF_06_Periodos
	from	PF_06_Periodos p
	where	not exists (select 1 from PF_07_Valores v where v.Periodo = p.Periodo)

	drop table dbo.ZZ_inst_ramo
	
	drop table dbo.ZZ_inst_conc
	

	select getdate(), 'Completando Totales'

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, 'SEGUROGRAL_cl-cs:MasivoMiembro' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = 'SEGUROGRAL_cl-cs:MasivoMiembro')
	and   Segmento = 'SEGUROGRAL'
	and   (	PKSubRamo like '%CarteraHipotecariaMiembro'
		or  PKSubRamo like '%CarteraConsumoMiembro'
		or  PKSubRamo like '%OtraCarteraMiembro')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, 'SEGUROVIDA_cl-cs:MasivoMiembro' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = 'SEGUROVIDA_cl-cs:MasivoMiembro')
	and   Segmento = 'SEGUROVIDA'
	and   (	PKSubRamo like '%CarteraHipotecariaMiembro'
		or  PKSubRamo like '%CarteraConsumoMiembro'
		or  PKSubRamo like '%OtraCarteraMiembro')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, 'SEGUROGRAL_0' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = 'SEGUROGRAL_0')
	and   Segmento = 'SEGUROGRAL'
	and   (	PKSubRamo like '%IndustriaInfraestructuraComercioMiembro'
		or  PKSubRamo like '%IndividualesMiembro'
		or  PKSubRamo like '%ColectivosMiembro'
		or  PKSubRamo like '%MasivoMiembro'
		or  PKSubRamo like '%PrevisionalesMiembro')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	insert into PF_07_Valores (Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, PKSubRamo,ValorPesos, ValorUF, ValorUSD)
	select	Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo, 'SEGUROVIDA_0' PKSubRamo, 
			sum(ValorPesos) ValorPesos, sum(ValorUF) ValorUF, sum(ValorUSD) ValorUSD
	from   PF_07_Valores v1
	where  not exists (select 1
					   from   PF_07_Valores v2
					   where  v2.Segmento = v1.Segmento
					   and	  v2.Periodo  = v1.Periodo
					   and    v2.PKEmpresa = v1.PKEmpresa
					   and    v2.PKConcepto = v1.PKConcepto
					   and    v2.PKRamo = v1.PKRamo
					   and	  v2.PKSubRamo = 'SEGUROVIDA_0')
	and   Segmento = 'SEGUROVIDA'
	and   (	PKSubRamo like '%IndustriaInfraestructuraComercioMiembro'
		or  PKSubRamo like '%IndividualesMiembro'
		or  PKSubRamo like '%ColectivosMiembro'
		or  PKSubRamo like '%MasivoMiembro'
		or  PKSubRamo like '%PrevisionalesMiembro')
	group by Segmento, Periodo, PKEmpresa, PKConcepto, PKRamo

	select getdate(), 'FIN'

END
GO
/****** Object:  StoredProcedure [dbo].[prc_bi_dbax_create_3]    Script Date: 01/06/2017 12:57:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<JGALDAMEZ>
-- Create date: <2014-03-06>
-- Description:	<2>
-- =============================================
CREATE PROCEDURE [dbo].[prc_bi_dbax_create_3] @P_PERIODO VARCHAR(30)
AS
SELECT getdate()
	,'INICIO CARGA PERIODO: ' + @P_PERIODO

DELETE PF_07_Valores
WHERE Periodo = @P_PERIODO;

DELETE PF_06_Periodos
WHERE CodigoPeriodo = @P_PERIODO;

BEGIN
	/*** Inserta PF_2_01_Segmentos ***/
	/*INSERT INTO	PF_01_Segmentos 
		SELECT 	* FROM BI_SG_Segmento A 
		where   not exists (select	1 
							from 	PF_01_Segmentos B 
							where   A.codi_segm  = B.Segmento
							and		A.desc_segm  = B.NombreSegmento)*/
	/*** Crea o Inserta PF_2_02_Empresas ***/
	INSERT INTO PF_02_Empresas
	SELECT codi_segm + '_' + codi_pers AS PKEmpresa
		,codi_pers AS Rut
		,nomb_pers AS RazonSocial
		,codi_pers + ' ' + nomb_pers AS RazonSocialCompleta
		,empr_vige AS Vigente
	FROM BI_SG_Empresas A
	WHERE NOT EXISTS (
			SELECT 1
			FROM PF_02_Empresas B
			WHERE A.codi_pers = B.Rut
			)

	--and     A.codi_segm + '_' + A.codi_pers = B.PKEmpresa
	--and		A.codi_pers = B.Rut
	--and		A.nomb_pers = B.RazonSocial
	--and		A.codi_pers + ' ' + A.nomb_pers	= B.RazonSocialCompleta
	--and		A.empr_vige = B.Vigente)
	/*** Crea o Inserta PF_2_03_Conceptos ***/
	/*INSERT INTO PF_03_Conceptos 
	select	codi_segm + '_' + codi_conc	as PKConcepto,
			descInfo			as Cuadro,
			descDime			as Tabla,
			codi_conc			as CodigoConcepto, 
			descConc			as Concepto 
	from BI_SG_Conceptos A
	where   not exists (select	1 
					from 	PF_03_Conceptos B 
					where	codi_segm + '_' + codi_conc	= PKConcepto
					and		descInfo = Cuadro
					and		descDime = Tabla
					and		codi_conc = CodigoConcepto
					and		descConc = Concepto)*/
	INSERT PF_03_Conceptos (
		PKConcepto
		,Cuadro
		,Tabla
		,CodigoConcepto
		,Concepto
		)
	SELECT DISTINCT CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
			WHEN '1'
				THEN 'SEGUROGRAL'
			ELSE 'SEGUROVIDA'
			END + '_' + dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime AS PKConcepto
		,substring(di.desc_info, len(di.desc_info) - charindex(' ]', reverse(di.desc_info)) + 2, 10000) AS Cuadro
		,
		--di.desc_info,
		de2.desc_conc AS Tabla
		,CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
			WHEN '1'
				THEN 'SEGUROGRAL'
			ELSE 'SEGUROVIDA'
			END + '_' + dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime AS CodigoConcepto
		,dbo.FU_PF_getMaxOrdenConcepto(dc.pref_conc, dc.codi_conc) + ' - ' + de.desc_conc AS Concepto
	--df.*
	FROM dbax.dbo.dbax_dime_conc dc
		,dbax.dbo.dbax_desc_conc de
		,dbax.dbo.dbax_desc_info di
		,dbax.dbo.dbax_desc_conc de2
		,dbax.dbo.dbax_defi_conc df
	WHERE dc.codi_dein LIKE '%cuadro%'
		AND de.pref_conc = dc.pref_conc
		AND de.codi_conc = dc.codi_conc
		AND di.codi_info = dc.codi_dein
		AND di.codi_lang = 'es_ES'
		AND di.tipo_info = 'D'
		AND de2.pref_conc = dc.pref_dime
		AND de2.codi_conc = dc.codi_dime
		AND dc.pref_conc = df.pref_conc
		AND dc.codi_conc = df.codi_conc
		AND df.tipo_cuen != 'abstract'
		AND CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
			WHEN '1'
				THEN 'SEGUROGRAL'
			ELSE 'SEGUROVIDA'
			END + '_' + dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime NOT IN (
			SELECT PKConcepto collate Modern_Spanish_CI_AS
			FROM PF_03_Conceptos
			)

	/*** Crea o Inserta PF_2_04_Ramos ***/
	/*INSERT INTO PF_04_Ramos 
	select	codi_segm + '_' + codi_ramo	as PKRamo, 
			codi_ramo			as CodigoRamo, 
			desc_ramo			as Ramo,
			nume_ramo			as NumeroRamo
	from BI_SG_Ramos A
	where   not exists (select	1 
					from 	PF_04_Ramos B 
					where codi_segm + '_' + codi_ramo	= PKRamo
					and codi_ramo = CodigoRamo
					and desc_ramo = Ramo
					and nume_ramo = NumeroRamo)*/
	/*** Crea o Inserta PF_2_05_SubRamos ***/
	/*INSERT INTO PF_05_SubRamos 
	select	distinct
			codiSegm + '_' + codiRamo	as PKSubRamo, 
			codiRamo			as CodigoSubRamo, 
			descRamo			as SubRamo,
			numeRamo			as NumeroSubRamo
	from BI_SG_SubRamos A
	where   not exists (select	1 
					from 	PF_05_SubRamos B 
					where codiSegm + '_' + codiRamo	= PKSubRamo
					and codiRamo = CodigoSubRamo
					and descRamo = SubRamo
					and numeRamo = NumeroSubRamo)				
	order by 1*/
	/*** Inserta PF_2_06_Periodos segun periodo ***/
	/*INSERT INTO PF_06_Periodos 
	select	distinct
			codi_cntx			as CodigoPeriodo, 
			desc_cntx			as Periodo
	from BI_SG_Periodos A
	where codi_cntx = @P_PERIODO
	order by codi_cntx*/
	INSERT INTO PF_06_Periodos (
		CodigoPeriodo
		,Periodo
		)
	VALUES (
		@P_PERIODO
		,@P_PERIODO
		)

	DECLARE @vCodiEmpr VARCHAR(20)
	DECLARE @vCorrInst VARCHAR(10)

	DECLARE curEmpresas CURSOR
	FOR
	SELECT codi_pers
		,replace(@P_PERIODO, '-', '')
	FROM dbax.dbo.dbax_defi_pers
	WHERE codi_segm IN (
			'SEGUROVIDA'
			,'SEGUROGRAL'
			) 
	--and codi_pers not in (762125191,762634142,965792802,990120002,992890002,762821912)
	--and codi_pers in ('762125191')

	DECLARE @vRamo VARCHAR(300)
	DECLARE @vSubRamo VARCHAR(300)
	DECLARE @vCodiCntx VARCHAR(300)

	OPEN curEmpresas

	FETCH NEXT FROM curEmpresas INTO @vCodiEmpr,@vCorrInst

	WHILE @@fetch_status = 0
	BEGIN
		PRINT @vCodiEmpr

		DECLARE @vVersInst VARCHAR(3)

		SET @vVersInst = dbax.dbo.FU_AX_getPersCorrVersInst(@vCodiEmpr, @vCorrInst, 'I', 'M')

		--DELETE
		--FROM PF_07_Valores
		--WHERE PKEmpresa LIKE '%[_]' + @vCodiEmpr
		--AND Periodo = @P_PERIODO

		DECLARE curContextos CURSOR
		FOR
		SELECT DISTINCT ic.codi_cntx
		FROM dbax.dbo.dbax_info_defi id
			,dbax.dbo.dbax_dime_conc dc
			,dbax.dbo.dbax_defi_conc df
			,dbax.dbo.dbax_inst_conc ic
			,dbax.dbo.dbax_inst_dicx ix
			,dbax.dbo.dbax_defi_pers dp
		WHERE id.indi_vige = '1'
			AND id.tipo_info = 'D'
			AND id.codi_info LIKE '%cuadro%'
			AND dc.codi_dein = id.codi_info
			AND dc.pref_conc = df.pref_conc
			AND dc.codi_conc = df.codi_conc
			AND df.tipo_cuen != 'abstract'
			AND dp.codi_pers = @vCodiEmpr
			AND dp.codi_segm = CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
				WHEN '1'
					THEN 'SEGUROGRAL'
				ELSE 'SEGUROVIDA'
				END
			AND ic.codi_pers = dp.codi_pers
			AND ic.corr_inst = @vCorrInst
			AND ic.vers_inst = @vVersInst
			AND ic.pref_conc = dc.pref_conc
			AND ic.codi_conc = dc.codi_conc
			AND ic.codi_conc NOT IN (
				'RamosVida'
				,'RamosGenerales'
				)
			AND ix.codi_pers = ic.codi_pers
			AND ix.corr_inst = ic.corr_inst
			AND ix.vers_inst = ic.vers_inst
			AND ix.codi_cntx = ic.codi_cntx
			AND ix.codi_axis IN (
				'cl-cs:RamosEje'
				,'cl-cs:DetalleSubRamosEje'
				)
			
		OPEN curContextos

		FETCH NEXT FROM curContextos INTO @vCodiCntx

		WHILE @@fetch_status = 0
		BEGIN
			print @vCodiEmpr + ',' + @vCorrInst + ', ' + @vVersInst + ', cl-cs:RamosEje, ' + @vCodiCntx + ', R'
			SELECT @vRamo = dbo.FU_PF_ObtieneMiembro(@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:RamosEje', @vCodiCntx, 'R')

			SELECT @vSubRamo = dbo.FU_PF_ObtieneMiembro(@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:DetalleSubRamosEje', @vCodiCntx, 'S')
			print @vRamo + ', ' + @vSubRamo
			
			INSERT PF_07_Valores
			SELECT distinct Segmento
				,@P_PERIODO
				,Segmento + '_' + codi_pers AS PKEmpresa
				,Segmento + '_' + PKConcepto
				,Segmento + '_' + @vRamo AS PKRamo
				,Segmento + '_' + @vSubRamo AS PKSubRamo
				,ValorPesos
				,ValorUF
				,ValorUSD
			FROM (
				SELECT DISTINCT ic.codi_pers
					,ic.corr_inst
					,ic.vers_inst
					,CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
						WHEN '1'
							THEN 'SEGUROGRAL'
						ELSE 'SEGUROVIDA'
						END AS Segmento
					,dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime AS PKConcepto
					,convert(NUMERIC, replace(ic.valo_cntx, ',', '.')) AS ValorPesos
					,convert(NUMERIC, replace(ic.valo_refe, ',', '.')) AS ValorUF
					,convert(NUMERIC, replace(ic.valo_inte, ',', '.')) AS ValorUSD
				FROM dbax.dbo.dbax_info_defi id
					,dbax.dbo.dbax_dime_conc dc
					,dbax.dbo.dbax_defi_conc df
					,dbax.dbo.dbax_inst_conc ic
					,dbax.dbo.dbax_inst_dicx ix
					,dbax.dbo.dbax_defi_pers dp
				WHERE id.indi_vige = '1'
					AND id.tipo_info = 'D'
					AND id.codi_info LIKE '%cuadro%'
					AND dc.codi_dein = id.codi_info
					AND dc.pref_conc = df.pref_conc
					AND dc.codi_conc = df.codi_conc
					AND df.tipo_cuen != 'abstract'
					AND dp.codi_pers = @vCodiEmpr
					AND dp.codi_segm = CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
						WHEN '1'
							THEN 'SEGUROGRAL'
						ELSE 'SEGUROVIDA'
						END
					AND ic.codi_pers = dp.codi_pers
					AND ic.corr_inst = @vCorrInst
					AND ic.vers_inst = @vVersInst
					AND ic.pref_conc = dc.pref_conc
					AND ic.codi_conc = dc.codi_conc
					AND ic.codi_conc NOT IN (
						'RamosVida'
						,'RamosGenerales'
						)
					AND ic.codi_cntx = @vCodiCntx
					AND ix.codi_pers = ic.codi_pers
					AND ix.corr_inst = ic.corr_inst
					AND ix.vers_inst = ic.vers_inst
					AND ix.codi_cntx = ic.codi_cntx
					AND ix.codi_axis IN (
						'cl-cs:RamosEje'
						,'cl-cs:DetalleSubRamosEje'
						)
				) V
			WHERE 1=1
				--@vSubRamo != '0'
				--AND @vRamo != '0'
				AND @vRamo != '421'
				AND @vRamo != '422'
			--except
			--select distinct PKRamo from PF_04_Ramos
			
			FETCH NEXT FROM curContextos INTO @vCodiCntx
		END

		CLOSE curContextos

		DEALLOCATE curContextos

		DECLARE curContextos CURSOR
		FOR
		SELECT DISTINCT ic.codi_cntx
		FROM dbax.dbo.dbax_info_defi id
			,dbax.dbo.dbax_dime_conc dc
			,dbax.dbo.dbax_defi_conc df
			,dbax.dbo.dbax_inst_conc ic
			,dbax.dbo.dbax_inst_dicx ix
			,dbax.dbo.dbax_defi_pers dp
		WHERE id.indi_vige = '1'
			AND id.tipo_info = 'D'
			AND id.codi_info LIKE '%cuadro%'
			AND dc.codi_dein = id.codi_info
			AND dc.pref_conc = df.pref_conc
			AND dc.codi_conc = df.codi_conc
			AND df.tipo_cuen != 'abstract'
			AND dp.codi_pers = @vCodiEmpr
			AND dp.codi_segm = CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
				WHEN '1'
					THEN 'SEGUROGRAL'
				ELSE 'SEGUROVIDA'
				END
			AND ic.codi_pers = dp.codi_pers
			AND ic.corr_inst = @vCorrInst
			AND ic.vers_inst = @vVersInst
			AND ic.pref_conc = dc.pref_conc
			AND ic.codi_conc = dc.codi_conc
			AND ic.codi_conc NOT IN (
				'RamosVida'
				,'RentasVitaliciasEje'
				)
			AND ix.codi_pers = ic.codi_pers
			AND ix.corr_inst = ic.corr_inst
			AND ix.vers_inst = ic.vers_inst
			AND ix.codi_cntx = ic.codi_cntx
			AND ix.codi_axis = 'cl-cs:RentasVitaliciasEje'

		OPEN curContextos

		FETCH NEXT FROM curContextos INTO @vCodiCntx

		WHILE @@fetch_status = 0
		BEGIN
			SELECT @vRamo = dbo.FU_PF_ObtieneMiembro(@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:RamosEje', @vCodiCntx, 'R')

			SELECT @vSubRamo = dbo.FU_PF_ObtieneMiembro(@vCodiEmpr, @vCorrInst, @vVersInst, 'cl-cs:RentasVitaliciasEje', @vCodiCntx, 'S')

			INSERT PF_07_Valores
			SELECT Segmento
				,@P_PERIODO
				,Segmento + '_' + codi_pers AS PKEmpresa
				,Segmento + '_' + PKConcepto
				,Segmento + '_' + @vRamo AS PKRamo
				,Segmento + '_' + @vSubRamo AS PKSubRamo
				,ValorPesos
				,ValorUF
				,ValorUSD
			FROM (
				SELECT DISTINCT ic.codi_pers
					,ic.corr_inst
					,ic.vers_inst
					,CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
						WHEN '1'
							THEN 'SEGUROGRAL'
						ELSE 'SEGUROVIDA'
						END AS Segmento
					,dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime AS PKConcepto
					,convert(NUMERIC, replace(ic.valo_cntx, ',', '.')) AS ValorPesos
					,convert(NUMERIC, replace(ic.valo_refe, ',', '.')) AS ValorUF
					,convert(NUMERIC, replace(ic.valo_inte, ',', '.')) AS ValorUSD
				FROM dbax.dbo.dbax_info_defi id
					,dbax.dbo.dbax_dime_conc dc
					,dbax.dbo.dbax_defi_conc df
					,dbax.dbo.dbax_inst_conc ic
					,dbax.dbo.dbax_inst_dicx ix
					,dbax.dbo.dbax_defi_pers dp
				WHERE id.indi_vige = '1'
					AND id.tipo_info = 'D'
					AND id.codi_info LIKE '%cuadro%'
					AND dc.codi_dein = id.codi_info
					AND dc.pref_conc = df.pref_conc
					AND dc.codi_conc = df.codi_conc
					AND df.tipo_cuen != 'abstract'
					AND dp.codi_pers = @vCodiEmpr
					AND dp.codi_segm = CASE substring(dc.codi_dein, charindex('(', dc.codi_dein) - 1, 1)
						WHEN '1'
							THEN 'SEGUROGRAL'
						ELSE 'SEGUROVIDA'
						END
					AND ic.codi_pers = dp.codi_pers
					AND ic.corr_inst = @vCorrInst
					AND ic.vers_inst = @vVersInst
					AND ic.pref_conc = dc.pref_conc
					AND ic.codi_conc = dc.codi_conc
					AND ic.codi_conc NOT IN (
						'RamosVida'
						,'RentasVitaliciasEje'
						)
					AND ic.codi_cntx = @vCodiCntx
					AND ix.codi_pers = ic.codi_pers
					AND ix.corr_inst = ic.corr_inst
					AND ix.vers_inst = ic.vers_inst
					AND ix.codi_cntx = ic.codi_cntx
					AND ix.codi_axis = 'cl-cs:RentasVitaliciasEje'
				) V
			WHERE 1=1
				--AND @vSubRamo != '0'
				AND @vRamo != '421'
				AND @vRamo != '422'

			FETCH NEXT FROM curContextos INTO @vCodiCntx
		END

		CLOSE curContextos

		DEALLOCATE curContextos

		FETCH NEXT FROM curEmpresas INTO @vCodiEmpr ,@vCorrInst
	END

	CLOSE curEmpresas

	DEALLOCATE curEmpresas

	SELECT getdate()
		,'FIN CARGA PERIODO: ' + @P_PERIODO
END
GO
/****** Object:  StoredProcedure [dbo].[prc_table_create_3]    Script Date: 01/06/2017 12:57:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[prc_table_create_3] 	
		@P_PERIODO VARCHAR(30)
AS
SET NOCOUNT ON

BEGIN

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PF_01_Segmentos') 

	BEGIN
		CREATE TABLE [dbo].[PF_01_Segmentos](
			[Segmento] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[NombreSegmento] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL)
		/*,
		 CONSTRAINT [PK_Segmentos] PRIMARY KEY CLUSTERED 
		(
			[Segmento] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END
	
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PF_02_Empresas') 

	BEGIN
		CREATE TABLE [dbo].[PF_02_Empresas](
			[PKEmpresa] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Rut] [varchar](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[RazonSocial] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
			[RazonSocialCompleta] [varchar](116) COLLATE Modern_Spanish_CI_AS NULL,
			[Vigente] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL)
/*,
		 CONSTRAINT [PK_Empresas] PRIMARY KEY CLUSTERED 
		(
			[PKEmpresa] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PF_03_Conceptos') 

	BEGIN
		CREATE TABLE [dbo].[PF_03_Conceptos](
			[PKConcepto] [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Cuadro] [varchar](512) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Tabla] [varchar](512) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[CodigoConcepto] [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Concepto] [varchar](8000) COLLATE Modern_Spanish_CI_AS NULL)
/*,
		 CONSTRAINT [PK_Conceptos] PRIMARY KEY CLUSTERED 
		(
			[PKConcepto] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END
	
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PF_04_Ramos') 

	BEGIN
		CREATE TABLE [dbo].[PF_04_Ramos](
			[PKRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[CodigoRamo] [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[Ramo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[NumeroRamo] [numeric](18, 0) NULL)
/*,
		 CONSTRAINT [PK_Ramos] PRIMARY KEY CLUSTERED 
		(
			[PKRamo] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PF_05_SubRamos') 

	BEGIN
		CREATE TABLE [dbo].[PF_05_SubRamos](
			[PKSubRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[CodigoSubRamo] [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[SubRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
			[NumeroSubRamo] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL)
/*,
		 CONSTRAINT [PK_SubRamos] PRIMARY KEY CLUSTERED 
		(
			[PKSubRamo] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PF_06_Periodos') 

	BEGIN
		CREATE TABLE [dbo].[PF_06_Periodos](
				[CodigoPeriodo] [varchar](256) COLLATE Modern_Spanish_CI_AS NULL,
				[Periodo] [varchar](7) COLLATE Modern_Spanish_CI_AS NOT NULL)
/*,
		CONSTRAINT [PK_Periodos] PRIMARY KEY CLUSTERED 
		(
			[Periodo] DESC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]*/
	END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PF_07_Valores') 

	BEGIN
		CREATE TABLE [dbo].[PF_07_Valores](
					[Segmento] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[Periodo] [varchar](7) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[PKEmpresa] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[PKConcepto] [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[PKRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
					[PKSubRamo] [varchar](80) COLLATE Modern_Spanish_CI_AS NULL,
					[ValorPesos] [numeric](38, 4) NULL,
					[ValorUF] [numeric](38, 4) NULL,
					[ValorUSD] [numeric](38, 4) NULL)
				/*) ON [PRIMARY]*/

		

	END


	alter table PF_01_Segmentos	alter column	Segmento	varchar(30) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_01_Segmentos	add constraint	PK_Segmentos	PRIMARY KEY CLUSTERED (Segmento)
	
	alter table PF_02_Empresas	alter column	PKEmpresa	varchar(30) collate Modern_Spanish_CI_AS not null 
	alter table PF_02_Empresas	alter column	Rut		varchar(15) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_02_Empresas	add constraint	PK_Empresas	PRIMARY KEY CLUSTERED (PKEmpresa)
	
	alter table PF_04_Ramos		alter column	PKRamo		varchar(80) collate Modern_Spanish_CI_AS not null 
	alter table PF_04_Ramos		alter column	CodigoRamo	varchar(50) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_04_Ramos		add constraint	PK_Ramos	PRIMARY KEY CLUSTERED (PKRamo)
	
	alter table PF_05_SubRamos	alter column	PKSubRamo	varchar(80) collate Modern_Spanish_CI_AS not null 
	alter table PF_05_SubRamos	alter column	CodigoSubRamo	varchar(50) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_05_SubRamos	add constraint	PK_SubRamos	PRIMARY KEY CLUSTERED (PKSubRamo)
	
	alter table PF_03_Conceptos	alter column	PKConcepto	varchar(256) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	CodigoConcepto	varchar(256) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	Cuadro		varchar(512) collate Modern_Spanish_CI_AS not null 
	alter table PF_03_Conceptos	alter column	Tabla		varchar(512) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_03_Conceptos	add constraint	PK_Conceptos	PRIMARY KEY CLUSTERED (PKConcepto)
	
	alter table PF_06_Periodos	alter column	Periodo		varchar(7) collate Modern_Spanish_CI_AS not null 
	
	alter table PF_06_Periodos	add constraint	PK_Periodos	PRIMARY KEY CLUSTERED (Periodo DESC)

	/*** PF_07_Valores ***/

alter table PF_07_Valores alter column Segmento		varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column Periodo		varchar(7)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKEmpresa	varchar(30)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKRamo		varchar(80)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column PKSubRamo	varchar(80)	collate Modern_Spanish_CI_AS
	alter table PF_07_Valores alter column PKConcepto	varchar(256)	collate Modern_Spanish_CI_AS not null 
	alter table PF_07_Valores alter column ValorPesos	numeric(38,4)
	alter table PF_07_Valores alter column ValorUF		numeric(38,4)
	alter table PF_07_Valores alter column ValorUsd		numeric(38,4)

	alter table PF_07_Valores WITH CHECK add constraint	Valores_FK_Segmentos
		FOREIGN KEY	(Segmento) REFERENCES PF_01_Segmentos (Segmento)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Segmentos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Periodos
		FOREIGN KEY (Periodo) REFERENCES PF_06_Periodos (Periodo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Periodos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Empresas
		FOREIGN KEY	(PKEmpresa)	REFERENCES PF_02_Empresas  (PKEmpresa)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Empresas
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Ramos
		FOREIGN KEY (PKRamo) REFERENCES PF_04_Ramos (PKRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Ramos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_SubRamos
		FOREIGN KEY (PKSubRamo) REFERENCES PF_05_SubRamos  (PKSubRamo)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_SubRamos
	
	alter table PF_07_Valores WITH CHECK add constraint Valores_FK_Conceptos
		FOREIGN KEY (PKConcepto) REFERENCES PF_03_Conceptos (PKConcepto)
	alter table PF_07_Valores CHECK CONSTRAINT Valores_FK_Conceptos



		EXEC prc_bi_dbax_create_3 @P_PERIODO;




END
GO
