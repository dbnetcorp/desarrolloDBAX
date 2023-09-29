USE [dbaxBI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<JGALDAMEZ>
-- Create date: <2014-03-06>
-- Description:	<2>
-- =============================================
CREATE PROCEDURE [dbo].[prc_bi_dbax_create_3] 	

	@P_PERIODO VARCHAR(30)
as

	select getdate(), 'INICIO CARGA PERIODO: ' + @P_PERIODO 

	delete PF_07_Valores
	where Periodo = @P_PERIODO;

	delete PF_06_Periodos
	where CodigoPeriodo = @P_PERIODO;

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
		SELECT 	codi_segm + '_' + codi_pers	as PKEmpresa, 
				codi_pers			as Rut, 
				nomb_pers			as RazonSocial,
				codi_pers + ' ' + nomb_pers	as RazonSocialCompleta,
				empr_vige			as Vigente FROM BI_SG_Empresas A 
		where   not exists (select	1 
					from 	PF_02_Empresas B 
					where	A.codi_pers = B.Rut
					and     A.codi_segm + '_' + A.codi_pers = B.PKEmpresa
					and		A.codi_pers = B.Rut
					and		A.nomb_pers = B.RazonSocial
					and		A.codi_pers + ' ' + A.nomb_pers	= B.RazonSocialCompleta
					and		A.empr_vige = B.Vigente)

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

	insert into PF_06_Periodos (CodigoPeriodo, Periodo)
	values (@P_PERIODO,@P_PERIODO)

	declare @vCodiEmpr varchar(20)
	declare @vCorrInst varchar(10) 

	declare curEmpresas cursor for
		select codi_pers,replace(@P_PERIODO,'-','') from dbax.dbo.dbax_defi_pers where codi_segm in ('SEGUROVIDA','SEGUROGRAL') --and codi_pers in (700157302)

	open curEmpresas
	fetch next from curEmpresas into @vCodiEmpr, @vCorrInst
	while @@fetch_status = 0
	begin
		print @vCodiEmpr
		insert PF_07_Valores
		select * from (
			select	 distinct case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end as Segmento,
					substring(convert(varchar,ic.corr_inst),1,4) + '-' + substring(convert(varchar,ic.corr_inst),5,2) as Periodo,
					case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end + '_' + ic.codi_pers as PKEmpresa,
					case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end + '_' + dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime as PKConcepto,
					case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end + '_' + dbo.FU_PF_ObtieneMiembro (ic.codi_pers, ic.corr_inst, ic.vers_inst, 'cl-cs:RamosEje', ic.codi_cntx, 'R') as PKRamo,
					case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end + '_' + dbo.FU_PF_ObtieneMiembro (ic.codi_pers, ic.corr_inst, ic.vers_inst, 'cl-cs:DetalleSubRamosEje', ic.codi_cntx,'S') as PKSubRamo,
					--case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end + '_' + dbo.FU_PF_ObtieneMiembro (ic.codi_pers, ic.corr_inst, ic.vers_inst, 'cl-cs:RentasVitaliciasEje', ic.codi_cntx,'S') as PKSubRamo2,
					--ic.valo_cntx as ValorPesos,
					--ic.codi_cntx,
					convert(numeric,replace(ic.valo_cntx,',','.')) as ValorPesos,
					convert(numeric,replace(ic.valo_refe,',','.')) as ValorUF,
					convert(numeric,replace(ic.valo_inte,',','.')) as ValorUSD
					--ic.valo_orig
			from	dbax.dbo.dbax_dime_conc dc,
					dbax.dbo.dbax_defi_conc df,
					dbax.dbo.dbax_inst_conc ic,
					dbax.dbo.dbax_inst_dicx ix,
					dbax.dbo.dbax_defi_pers dp
			where	dc.codi_dein like '%cuadro%'
			and		dc.pref_conc = df.pref_conc
			and		dc.codi_conc = df.codi_conc
			and		df.tipo_cuen != 'abstract'
			and		dp.codi_pers = @vCodiEmpr
			and		dp.codi_segm = case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end
			and		ic.codi_pers = dp.codi_pers
			and		ic.corr_inst = @vCorrInst
			and		ic.vers_inst = dbax.dbo.FU_AX_getPersCorrVersInst(dp.codi_pers, ic.corr_inst,'I', 'M')
			and		ic.pref_conc = dc.pref_conc
			and		ic.codi_conc = dc.codi_conc
			--and		ic.valo_cntx like ('%,%')
			and		ic.codi_conc not in ('RamosVida', 'RamosGenerales')
			and		ix.codi_pers = ic.codi_pers
			and		ix.corr_inst = ic.corr_inst
			and		ix.vers_inst = ic.vers_inst
			and		ix.codi_cntx = ic.codi_cntx
			and		ix.codi_axis in ('cl-cs:RamosEje','cl-cs:DetalleSubRamosEje'))V
		where	PKSubRamo not like '%[_]0'
		and		PKRamo not like '%[_]0'
		--and		PKRamo = 'SEGUROVIDA_110'

		insert PF_07_Valores
		select * from (
			select	 distinct case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end as Segmento,
					substring(convert(varchar,ic.corr_inst),1,4) + '-' + substring(convert(varchar,ic.corr_inst),5,2) as Periodo,
					case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end + '_' + ic.codi_pers as PKEmpresa,
					case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end + '_' + dc.pref_conc + '_' + dc.codi_conc + '_' + codi_dime as PKConcepto,
					case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end + '_' + dbo.FU_PF_ObtieneMiembro (ic.codi_pers, ic.corr_inst, ic.vers_inst, 'cl-cs:RamosEje', ic.codi_cntx, 'R') as PKRamo,
					--case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end + '_' + dbo.FU_PF_ObtieneMiembro (ic.codi_pers, ic.corr_inst, ic.vers_inst, 'cl-cs:DetalleSubRamosEje', ic.codi_cntx,'S') as PKSubRamo,
					case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end + '_' + dbo.FU_PF_ObtieneMiembro (ic.codi_pers, ic.corr_inst, ic.vers_inst, 'cl-cs:RentasVitaliciasEje', ic.codi_cntx,'S') as PKSubRamo,
					--ic.valo_cntx as ValorPesos,
					--ic.codi_cntx,
					convert(numeric,replace(ic.valo_cntx,',','.')) as ValorPesos,
					convert(numeric,replace(ic.valo_refe,',','.')) as ValorUF,
					convert(numeric,replace(ic.valo_inte,',','.')) as ValorUSD
					--ic.valo_orig
			from	dbax.dbo.dbax_dime_conc dc,
					dbax.dbo.dbax_defi_conc df,
					dbax.dbo.dbax_inst_conc ic,
					dbax.dbo.dbax_inst_dicx ix,
					dbax.dbo.dbax_defi_pers dp
			where	dc.codi_dein like '%cuadro%'
			and		dc.pref_conc = df.pref_conc
			and		dc.codi_conc = df.codi_conc
			and		df.tipo_cuen != 'abstract'
			and		dp.codi_pers = @vCodiEmpr
			and		dp.codi_segm = case substring(dc.codi_dein,charindex('(',dc.codi_dein)-1,1) when '1'  then 'SEGUROGRAL' else 'SEGUROVIDA' end
			and		ic.codi_pers = dp.codi_pers
			and		ic.corr_inst = @vCorrInst
			and		ic.vers_inst = dbax.dbo.FU_AX_getPersCorrVersInst(dp.codi_pers, ic.corr_inst,'I', 'M')
			and		ic.pref_conc = dc.pref_conc
			and		ic.codi_conc = dc.codi_conc
			--and		ic.valo_cntx like ('%,%')
			and		ic.codi_conc not in ('RamosVida', 'RentasVitaliciasEje')
			and		ix.codi_pers = ic.codi_pers
			and		ix.corr_inst = ic.corr_inst
			and		ix.vers_inst = ic.vers_inst
			and		ix.codi_cntx = ic.codi_cntx
			and		ix.codi_axis in ('cl-cs:RentasVitaliciasEje'))V
		where	PKSubRamo not like '%[_]0'
		--and		PKRamo not like '%_0'

		fetch next from curEmpresas into @vCodiEmpr, @vCorrInst
	end
	close curEmpresas
	deallocate curEmpresas	

	select getdate(), 'FIN CARGA PERIODO: ' + @P_PERIODO 	
END
GO
