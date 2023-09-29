USE [dbaxBI]
GO
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
