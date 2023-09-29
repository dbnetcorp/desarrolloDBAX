USE [dbaxBI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PF_07_Valores](
	[Segmento] [varchar](30) NOT NULL,
	[Periodo] [varchar](7) NOT NULL,
	[PKEmpresa] [varchar](30) NOT NULL,
	[PKConcepto] [varchar](256) NOT NULL,
	[PKRamo] [varchar](80) NOT NULL,
	[PKSubRamo] [varchar](80) NULL,
	[ValorPesos] [numeric](38, 4) NULL,
	[ValorUF] [numeric](38, 4) NULL,
	[ValorUSD] [numeric](38, 4) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
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
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_Ramos] FOREIGN KEY([PKRamo])
REFERENCES [dbo].[PF_04_Ramos] ([PKRamo])
GO
ALTER TABLE [dbo].[PF_07_Valores] CHECK CONSTRAINT [Valores_FK_Ramos]
GO
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_Segmentos] FOREIGN KEY([Segmento])
REFERENCES [dbo].[PF_01_Segmentos] ([Segmento])
GO
ALTER TABLE [dbo].[PF_07_Valores] CHECK CONSTRAINT [Valores_FK_Segmentos]
GO
ALTER TABLE [dbo].[PF_07_Valores]  WITH CHECK ADD  CONSTRAINT [Valores_FK_SubRamos] FOREIGN KEY([PKSubRamo])
REFERENCES [dbo].[PF_05_SubRamos] ([PKSubRamo])
GO
ALTER TABLE [dbo].[PF_07_Valores] CHECK CONSTRAINT [Valores_FK_SubRamos]
GO
