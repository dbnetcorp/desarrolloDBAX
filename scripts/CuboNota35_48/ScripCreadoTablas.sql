select * from PF_01_Segmentos
select * from PF_02_Empresas
select * from PF_03_Conceptos
select * from PF_04_Columnas
--select * from PF_05_SubRamos
select * from PF_06_Periodos
select * from PF_07_Valores


use dbaxBINotas
GO

alter table PF_01_Segmentos drop constraint PK_Segmentos
alter table PF_02_Empresas drop constraint PK_Empresas
alter table PF_03_Conceptos drop constraint PK_Conceptos
alter table PF_04_Columnas drop constraint PK_Columnas
alter table PF_06_Periodos drop constraint PK_Periodos

--alter table PF_07_Valores drop constraint [Valores_FK_Conceptos]


drop table [PF_01_Segmentos]
drop table [PF_02_Empresas]
drop table [PF_03_Conceptos]
drop table [PF_04_Columnas]
drop table [PF_06_Periodos]
drop table [PF_07_Valores]

/****** Object:  Table [dbo].[PF_01_Segmentos]    Script Date: 14-12-2018 15:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PF_01_Segmentos](
	[Segmento] [varchar](30) NOT NULL,
	[NombreSegmento] [varchar](100) NULL,
 CONSTRAINT [PK_Segmentos] PRIMARY KEY CLUSTERED 
(
	[Segmento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PF_02_Empresas]    Script Date: 14-12-2018 15:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PF_02_Empresas](
	[PKEmpresa] [varchar](30) NOT NULL,
	[Rut] [varchar](15) NOT NULL,
	[RazonSocial] [varchar](100) NULL,
	[RazonSocialCompleta] [varchar](116) NULL,
	[Vigente] [varchar](10) NULL,
	[Tipo] [varchar](2) NULL,
 CONSTRAINT [PK_Empresas] PRIMARY KEY CLUSTERED 
(
	[PKEmpresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PF_03_Conceptos]    Script Date: 14-12-2018 15:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PF_03_Conceptos](
	[PKConcepto] [varchar](256) NOT NULL,
	[Cuadro] [varchar](512) NOT NULL,
	[Tabla] [varchar](512) NOT NULL,
	[CodigoConcepto] [varchar](256) NOT NULL,
	[Concepto] [varchar](8000) NULL,
 CONSTRAINT [PK_Conceptos] PRIMARY KEY CLUSTERED 
(
	[PKConcepto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PF_04_Ramos]    Script Date: 14-12-2018 15:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PF_04_Columnas](
	[PKColumna] [varchar](512) NOT NULL,
	[CodigoColumna] [varchar](512) NOT NULL,
	[Columna] [varchar](512) NOT NULL,
	--[Cuadro] [varchar](512) NOT NULL,
	--[Tabla] [varchar](512) NOT NULL,
 CONSTRAINT [PK_Columnas] PRIMARY KEY CLUSTERED 
(
	[PKColumna] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PF_06_Periodos]    Script Date: 14-12-2018 15:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PF_06_Periodos](
	[CodigoPeriodo] [varchar](256) NULL,
	[Periodo] [varchar](7) NOT NULL,
 CONSTRAINT [PK_Periodos] PRIMARY KEY CLUSTERED 
(
	[Periodo] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PF_07_Valores]    Script Date: 14-12-2018 15:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PF_07_Valores](
	[Segmento] [varchar](30) NOT NULL,
	[Periodo] [varchar](7) NOT NULL,
	[PKEmpresa] [varchar](30) NOT NULL,
	[PKConcepto] [varchar](256) NOT NULL,
	[PKColumna] [varchar](512) NOT NULL,
	[ValorPesos] [numeric](38, 4) NULL,
	[ValorUF] [numeric](38, 4) NULL,
	[ValorUSD] [numeric](38, 4) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_Conceptos] FOREIGN KEY([PKConcepto])
REFERENCES [dbo].[PF_03_Conceptos] ([PKConcepto])
GO
ALTER TABLE [dbo].[PF_07_Valores] CHECK CONSTRAINT [Valores_FK_Conceptos]
GO
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_Empresas] FOREIGN KEY([PKEmpresa])
REFERENCES [dbo].[PF_02_Empresas] ([PKEmpresa])
GO
ALTER TABLE [dbo].[PF_07_Valores] CHECK CONSTRAINT [Valores_FK_Empresas]
GO
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_Periodos] FOREIGN KEY([Periodo])
REFERENCES [dbo].[PF_06_Periodos] ([Periodo])
GO
ALTER TABLE [dbo].[PF_07_Valores] CHECK CONSTRAINT [Valores_FK_Periodos]
GO
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_Columnas] FOREIGN KEY([PKColumna])
REFERENCES [dbo].[PF_04_Columnas] ([PKColumna])
GO
ALTER TABLE [dbo].[PF_07_Valores] CHECK CONSTRAINT [Valores_FK_Columnas]
GO
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_Segmentos] FOREIGN KEY([Segmento])
REFERENCES [dbo].[PF_01_Segmentos] ([Segmento])
GO
ALTER TABLE [dbo].[PF_07_Valores] CHECK CONSTRAINT [Valores_FK_Segmentos]
GO





INSERT INTO "PF_01_Segmentos" ("Segmento", "NombreSegmento") VALUES ('SEGUROGRAL', 'SEGUROS GENERALES Y CREDITO');
INSERT INTO "PF_01_Segmentos" ("Segmento", "NombreSegmento") VALUES ('SEGUROVIDA', 'SEGUROS DE VIDA');

INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_760155921', '760155921', 'CESCE CHILE ASEGURADORA S.A.', '760155921 CESCE CHILE ASEGURADORA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_760397581', '760397581', 'FAF INTERNATIONAL SEGUROS GENERALES S.A.', '760397581 FAF INTERNATIONAL SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_760429651', '760429651', 'ORION SEGUROS GENERALES S.A.', '760429651 ORION SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_760612231', '760612231', 'ZENIT SEGUROS GENERALES S.A.', '760612231 ZENIT SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_760796241', '760796241', 'ASEG MAGALLANES DE GARANTIA', '760796241 ASEG MAGALLANES DE GARANTIA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_760942341', '760942341', 'SOLUNION CHILE SEGUROS DE CREDITO S.A.', '760942341 SOLUNION CHILE SEGUROS DE CREDITO S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_761732581', '761732581', 'QBE CHILE SEGUROS GENERALES S.A.', '761732581 QBE CHILE SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_762125191', '762125191', 'ASSURANT CHILE COMPAÑIA DE SEGUROS GENERALES S.A.', '762125191 ASSURANT CHILE COMPAÑIA DE SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_763287931', '763287931', 'METLIFE CHILE SEGUROS GENERALES S.A.', '763287931 METLIFE CHILE SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_763635341', '763635341', 'AVALCHILE SEGUROS DE CREDITO Y GARANTIA S.A.', '763635341 AVALCHILE SEGUROS DE CREDITO Y GARANTIA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_764794981', '764794981', 'BBVA SEGUROS GENERALES S.A.', '764794981 BBVA SEGUROS GENERALES S.A.', 'NO');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_765908401', '765908401', 'ZURICH SANTANDER SEGUROS GENERALES CHILE S.A.', '765908401 ZURICH SANTANDER SEGUROS GENERALES CHILE S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_765986251', '765986251', 'ASEGURADORA PORVENIR S.A.', '765986251 ASEGURADORA PORVENIR S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_766208161', '766208161', 'SEGCHILE SEGUROS GENERALES S.A.', '766208161 SEGCHILE SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_766209321', '766209321', 'STARR INTERNATIONAL SEGUROS GENERALES S.A.', '766209321 STARR INTERNATIONAL SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_767434921', '767434921', 'REALE CHILE SEGUROS GENERALES S.A.', '767434921 REALE CHILE SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_76810563', '76810563', 'ORSAN SEGUROS DE CREDITO Y GARANTIA S.A.', '76810563 ORSAN SEGUROS DE CREDITO Y GARANTIA S.A.', 'NO');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_768105631', '768105631', 'ORSAN SEGUROS DE CREDITO Y GARANTIA S.A.', '768105631 ORSAN SEGUROS DE CREDITO Y GARANTIA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_768447881', '768447881', 'SUAVAL COMPAÑIA DE SEGUROS DE GARANTIA Y CREDITO S.A.', '768447881 SUAVAL COMPAÑIA DE SEGUROS DE GARANTIA Y CREDITO S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_945100001', '945100001', 'RENTA NACIONAL COMPAÑIA DE SEGUROS GENERALES S.A.', '945100001 RENTA NACIONAL COMPAÑIA DE SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_965082101', '965082101', 'MAPFRE COMPAÑIA DE SEGUROS GENERALES DE CHILE S.A.', '965082101 MAPFRE COMPAÑIA DE SEGUROS GENERALES DE CHILE S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_965349401', '965349401', 'HDI SEGUROS S.A.', '965349401 HDI SEGUROS S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_965735901', '965735901', 'CONTINENTAL CREDITO', '965735901 CONTINENTAL CREDITO', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_966123101', '966123101', 'MAPFRE GARANT. Y CRED.', '966123101 MAPFRE GARANT. Y CRED.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_966426101', '966426101', 'CHUBB DE CHILE COMPAÑIA DE SEGUROS GENERALES S. A.', '966426101 CHUBB DE CHILE COMPAÑIA DE SEGUROS GENERALES S. A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_966541801', '966541801', 'CIA DE SEGUROS GENERALES CONSORCIO NACIONAL DE SEGUROS S.A.', '966541801 CIA DE SEGUROS GENERALES CONSORCIO NACIONAL DE SEGUROS S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_966831201', '966831201', 'COMPAÑIA DE SEGUROS GENERALES PENTA-SECURITY S.A.', '966831201 COMPAÑIA DE SEGUROS GENERALES PENTA-SECURITY S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_968316901', '968316901', 'COFACE CHILE S.A.', '968316901 COFACE CHILE S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_968376401', '968376401', 'BNP PARIBAS CARDIF SEGUROS GENERALES S.A.', '968376401 BNP PARIBAS CARDIF SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_969947001', '969947001', 'COMPAÑIA DE SEGUROS GENERALES HUELEN S.A.', '969947001 COMPAÑIA DE SEGUROS GENERALES HUELEN S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990010001', '990010001', ' ING  GENERALES', '990010001  ING  GENERALES', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990050001', '990050001', 'CONDOR', '990050001 CONDOR', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990100001', '990100001', ' UNESPA', '990100001  UNESPA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990170001', '990170001', 'RSA SEGUROS CHILE S.A.', '990170001 RSA SEGUROS CHILE S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990180001', '990180001', ' SANTIAGO', '990180001  SANTIAGO', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990240001', '990240001', 'MUTUALIDAD DE CARABINEROS GENERALES', '990240001 MUTUALIDAD DE CARABINEROS GENERALES', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990270001', '990270001', ' YCAJA REASEG. DE CHILE', '990270001  YCAJA REASEG. DE CHILE', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990330001', '990330001', 'ARAUCANIA', '990330001 ARAUCANIA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990370001', '990370001', 'CHILENA CONSOLIDADA SEGUROS GENERALES S.A.', '990370001 CHILENA CONSOLIDADA SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990400001', '990400001', ' LA ESPAÑOLA', '990400001  LA ESPAÑOLA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990410001', '990410001', 'FENIX', '990410001 FENIX', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990460001', '990460001', 'HISPANO CHILENA', '990460001 HISPANO CHILENA', 'NO');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990480001', '990480001', ' SEGUROS LA ITALIA S.A.', '990480001  SEGUROS LA ITALIA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990570001', '990570001', 'PROTECTORA', '990570001 PROTECTORA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990590001', '990590001', 'ALLIANZ', '990590001 ALLIANZ', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990610001', '990610001', 'LIBERTY COMPAÑIA DE SEGUROS GENERALES S.A.', '990610001 LIBERTY COMPAÑIA DE SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990630001', '990630001', ' UNION ITALO CHILENA', '990630001  UNION ITALO CHILENA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_990820001', '990820001', 'COMPAÑIA DE SEGUROS GENERALES LA AUSTRAL S.A.', '990820001 COMPAÑIA DE SEGUROS GENERALES LA AUSTRAL S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_991140001', '991140001', ' THE HOME', '991140001  THE HOME', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_991470001', '991470001', 'BCI SEGUROS GENERALES S.A.', '991470001 BCI SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_991550001', '991550001', 'ABN AMRO S.A.', '991550001 ABN AMRO S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_991630001', '991630001', 'BHC', '991630001 BHC', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_991840001', '991840001', 'AMERICANA, LA', '991840001 AMERICANA, LA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_991900001', '991900001', ' PEDRO DE VALDIVIA', '991900001  PEDRO DE VALDIVIA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_992240001', '992240001', ' MINERA', '992240001  MINERA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_992250001', '992250001', 'ACE SEGUROS S.A.', '992250001 ACE SEGUROS S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_992290011', '992290011', 'CENTINELA', '992290011 CENTINELA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_992310001', '992310001', 'ASEGURADORA MAGALLANES S.A.', '992310001 ASEGURADORA MAGALLANES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_992730001', '992730001', 'GARANTIZADORA NACIONAL', '992730001 GARANTIZADORA NACIONAL', 'NO');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_992810001', '992810001', ' UNION AMERICANA', '992810001  UNION AMERICANA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_992850001', '992850001', 'CRUZ  DEL SUR S.A.', '992850001 CRUZ  DEL SUR S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_992880001', '992880001', 'AIG CHILE COMPAÑIA DE SEGUROS GENERALES S.A.', '992880001 AIG CHILE COMPAÑIA DE SEGUROS GENERALES S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_992980001', '992980001', ' XAMERICAN  RE  ( CHILE )  S.A', '992980001  XAMERICAN  RE  ( CHILE )  S.A', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_993000001', '993000001', 'CLUBSEGUROS', '993000001 CLUBSEGUROS', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROGRAL_993020001', '993020001', ' SECURITY  PREVISION', '993020001  SECURITY  PREVISION', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_700157302', '700157302', 'MUTUAL DE SEGUROS DE CHILE', '700157302 MUTUAL DE SEGUROS DE CHILE', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_760347372', '760347372', 'ITAU CHILE COMPAÑIA DE SEGUROS DE VIDA S.A.', '760347372 ITAU CHILE COMPAÑIA DE SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_760723042', '760723042', 'COMPAÑIA DE SEGUROS CORPSEGUROS S.A.', '760723042 COMPAÑIA DE SEGUROS CORPSEGUROS S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_760925872', '760925872', 'RIGEL SEGUROS DE VIDA S.A.', '760925872 RIGEL SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_762133292', '762133292', 'ASEGURADORA MAGALLANES DE VIDA S.A.', '762133292 ASEGURADORA MAGALLANES DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_762634142', '762634142', 'RSA SEGUROS DE VIDA S.A.', '762634142 RSA SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_762821912', '762821912', 'CRUZ BLANCA COMPAÑIA DE SEGUROS DE VIDA S.A.', '762821912 CRUZ BLANCA COMPAÑIA DE SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_764087572', '764087572', 'COLMENA COMPAÑIA DE SEGUROS DE VIDA S.A.', '764087572 COLMENA COMPAÑIA DE SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_764187512', '764187512', 'BTG PACTUAL CHILE S.A. COMPAÑIA DE SEGUROS DE VIDA', '764187512 BTG PACTUAL CHILE S.A. COMPAÑIA DE SEGUROS DE VIDA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_764771162', '764771162', 'CF SEGUROS DE VIDA S.A.', '764771162 CF SEGUROS DE VIDA S.A.', 'NO');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_765114232', '765114232', 'ALEMANA SEGUROS S.A.', '765114232 ALEMANA SEGUROS S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_765734802', '765734802', 'SEGUROS CLC S.A.', '765734802 SEGUROS CLC S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_947160002', '947160002', 'RENTA NACIONAL COMPAÑIA DE SEGUROS DE VIDA S.A.', '947160002 RENTA NACIONAL COMPAÑIA DE SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_964560002', '964560002', ' LA CONSTRUCCION', '964560002  LA CONSTRUCCION', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_965349502', '965349502', ' ISE -  LAS AMERICAS', '965349502  ISE -  LAS AMERICAS', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_965490502', '965490502', 'SEGUROS DE VIDA SURA S.A.', '965490502 SEGUROS DE VIDA SURA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_965649702', '965649702', 'METLIFE', '965649702 METLIFE', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_965682102', '965682102', ' PREBAN', '965682102  PREBAN', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_965711502', '965711502', 'EL RAULI', '965711502 EL RAULI', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_965718902', '965718902', 'COMPAÑIA DE SEGUROS CORPVIDA S.A.', '965718902 COMPAÑIA DE SEGUROS CORPVIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_965736002', '965736002', 'BCI SEGUROS VIDA S.A.', '965736002 BCI SEGUROS VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_965767202', '965767202', 'COMPAÑIA DE SEGUROS DE VIDA LA AUSTRAL S.A.', '965767202 COMPAÑIA DE SEGUROS DE VIDA LA AUSTRAL S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_965792802', '965792802', 'CN LIFE, COMPAÑIA DE SEGUROS DE VIDA S.A.', '965792802 CN LIFE, COMPAÑIA DE SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_965880802', '965880802', 'PRINCIPAL COMPAÑIA DE SEGUROS DE VIDA CHILE S.A.', '965880802 PRINCIPAL COMPAÑIA DE SEGUROS DE VIDA CHILE S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_965898402', '965898402', ' XMETLIFE-RE', '965898402  XMETLIFE-RE', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_966059602', '966059602', 'LE MANS', '966059602 LE MANS', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_966287802', '966287802', 'COMPAÑIA DE SEGUROS DE VIDA CRUZ DEL SUR S.A.', '966287802 COMPAÑIA DE SEGUROS DE VIDA CRUZ DEL SUR S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_966564102', '966564102', 'BICE VIDA COMPAÑIA DE SEGUROS S.A.', '966564102 BICE VIDA COMPAÑIA DE SEGUROS S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_966573602', '966573602', ' SECURITY RENTAS', '966573602  SECURITY RENTAS', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_966879002', '966879002', 'OHIO NATIONAL SEGUROS DE VIDA S.A.', '966879002 OHIO NATIONAL SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_967592802', '967592802', 'MASS', '967592802 MASS', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_968129602', '968129602', 'PENTA VIDA COMPAÑIA DE SEGUROS DE VIDA S.A.', '968129602 PENTA VIDA COMPAÑIA DE SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_968196302', '968196302', 'ZURICH SANTANDER SEGUROS DE VIDA CHILE S.A.', '968196302 ZURICH SANTANDER SEGUROS DE VIDA CHILE S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_968253302', '968253302', 'BCI', '968253302 BCI', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_968376302', '968376302', 'BNP PARIBAS CARDIF SEGUROS DE VIDA S.A.', '968376302 BNP PARIBAS CARDIF SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_968482202', '968482202', ' VITALIS', '968482202  VITALIS', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_969179902', '969179902', 'BANCHILE SEGUROS DE VIDA S.A.', '969179902 BANCHILE SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_969330302', '969330302', 'MAPFRE COMPAÑIA DE SEGUROS DE VIDA DE CHILE S.A.', '969330302 MAPFRE COMPAÑIA DE SEGUROS DE VIDA DE CHILE S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_969337702', '969337702', 'BBVA SEGUROS DE VIDA S.A.', '969337702 BBVA SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_990030002', '990030002', 'COMPAÑIA DE SEGUROS DE VIDA CAMARA S.A.', '990030002 COMPAÑIA DE SEGUROS DE VIDA CAMARA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_990120002', '990120002', 'COMPAÑIA DE SEG DE VIDA CONSORCIO NACIONAL DE SEGUROS S.A.', '990120002 COMPAÑIA DE SEG DE VIDA CONSORCIO NACIONAL DE SEGUROS S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_990240002', '990240002', 'MUTUALIDAD DE CARABINEROS VIDA', '990240002 MUTUALIDAD DE CARABINEROS VIDA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_990250002', '990250002', 'MUTUALIDAD DEL EJERCITO Y AVIACION', '990250002 MUTUALIDAD DEL EJERCITO Y AVIACION', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_99027000', '99027000', 'CAJA REASEGURADORA DE CHILE S.A.', '99027000 CAJA REASEGURADORA DE CHILE S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_990270002', '990270002', 'CAJA REASEGURADORA DE CHILE S.A.', '990270002 CAJA REASEGURADORA DE CHILE S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_991490002', '991490002', 'BCH', '991490002 BCH', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_991560002', '991560002', 'CIGNA', '991560002 CIGNA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_991850002', '991850002', 'CHILENA CONSOLIDADA SEGUROS DE VIDA S.A.', '991850002 CHILENA CONSOLIDADA SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_991960002', '991960002', 'COMPAÑIA DE SEGUROS DE VIDA HUELEN S.A.', '991960002 COMPAÑIA DE SEGUROS DE VIDA HUELEN S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_992790002', '992790002', 'EUROAMERICA SEGUROS DE VIDA S.A.', '992790002 EUROAMERICA SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_992860002', '992860002', 'DIEGO DE ALMAGRO', '992860002 DIEGO DE ALMAGRO', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_992890002', '992890002', 'METLIFE CHILE SEGUROS DE VIDA S.A.', '992890002 METLIFE CHILE SEGUROS DE VIDA S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_992920002', '992920002', 'AETNA', '992920002 AETNA', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_992960002', '992960002', 'EL ROBLE', '992960002 EL ROBLE', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_992990002', '992990002', 'CONTINENTAL', '992990002 CONTINENTAL', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_993010002', '993010002', 'SEGUROS VIDA SECURITY PREVISION S.A.', '993010002 SEGUROS VIDA SECURITY PREVISION S.A.', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_993280002', '993280002', ' YOHIO RE', '993280002  YOHIO RE', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_995121602', '995121602', ' METLIFE CHILE - ANT', '995121602  METLIFE CHILE - ANT', 'SI');
INSERT INTO "PF_02_Empresas" ("PKEmpresa", "Rut", "RazonSocial", "RazonSocialCompleta", "Vigente") VALUES ('SEGUROVIDA_995880602', '995880602', 'ACE SEGUROS DE VIDA S.A.', '995880602 ACE SEGUROS DE VIDA S.A.', 'SI');

INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2018-09', '2018-09');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2018-06', '2018-06');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2018-03', '2018-03');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2017-12', '2017-12');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2017-09', '2017-09');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2017-06', '2017-06');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2017-03', '2017-03');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2016-12', '2016-12');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2016-09', '2016-09');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2016-06', '2016-06');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2016-03', '2016-03');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2015-12', '2015-12');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2015-09', '2015-09');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2015-06', '2015-06');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2015-03', '2015-03');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2014-12', '2014-12');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2014-09', '2014-09');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2014-06', '2014-06');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2014-03', '2014-03');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2013-12', '2013-12');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2013-09', '2013-09');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('201309', '201309');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2013-06', '2013-06');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2013-03', '2013-03');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2012-12', '2012-12');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2012-09', '2012-09');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2012-06', '2012-06');
INSERT INTO "PF_06_Periodos" ("CodigoPeriodo", "Periodo") VALUES ('2012-03', '2012-03');
