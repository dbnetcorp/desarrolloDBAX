SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_defi_pers](
	[codi_pers] [numeric](9, 0) NOT NULL,
	[desc_pers] [varchar](100) NULL,
	[codi_grup] [varchar](50) NULL,
	[codi_segm] [varchar](50) NULL,
	[tipo_taxo] [varchar](10) NULL,
 CONSTRAINT [PK_dbax_defi_pers] PRIMARY KEY CLUSTERED 
(
	[codi_pers] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_defi_pers]  WITH CHECK ADD  CONSTRAINT [FK_dbax_defi_pers_dbax_defi_grup] FOREIGN KEY([codi_grup])
REFERENCES [dbo].[dbax_defi_grup] ([codi_grup])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[dbax_defi_pers] CHECK CONSTRAINT [FK_dbax_defi_pers_dbax_defi_grup]
GO
ALTER TABLE [dbo].[dbax_defi_pers]  WITH CHECK ADD  CONSTRAINT [FK_dbax_defi_pers_dbax_defi_segm] FOREIGN KEY([codi_segm])
REFERENCES [dbo].[dbax_defi_segm] ([codi_segm])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[dbax_defi_pers] CHECK CONSTRAINT [FK_dbax_defi_pers_dbax_defi_segm]
GO
ALTER TABLE [dbo].[dbax_defi_pers]  WITH CHECK ADD  CONSTRAINT [FK_dbax_defi_pers_dbax_tipo_taxo] FOREIGN KEY([tipo_taxo])
REFERENCES [dbo].[dbax_tipo_taxo] ([tipo_taxo])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[dbax_defi_pers] CHECK CONSTRAINT [FK_dbax_defi_pers_dbax_tipo_taxo]
GO
