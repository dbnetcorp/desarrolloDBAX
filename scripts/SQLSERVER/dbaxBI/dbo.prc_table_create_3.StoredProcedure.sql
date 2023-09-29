USE [dbaxBI]
GO
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
