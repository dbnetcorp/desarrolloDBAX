SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_info_defi](
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_emex] [varchar](30) NOT NULL CONSTRAINT [DF_dbax_info_defi_codi_emex]  DEFAULT ((1)),
	[codi_info] [varchar](50) NOT NULL,
	[orde_info] [varchar](50) NULL,
	[indi_eeff] [varchar](1) NULL,
	[indi_situ] [varchar](1) NULL,
	[indi_resu] [varchar](1) NULL,
	[indi_fluj] [varchar](1) NULL,
	[indi_patr] [varchar](1) NULL,
	[indi_inte] [varchar](1) NULL,
	[tipo_xml] [varchar](1) NULL,
	[sche_info] [varchar](256) NULL,
	[tipo_taxo] [varchar](10) NULL,
 CONSTRAINT [PK_dbax_info_defi_1] PRIMARY KEY CLUSTERED 
(
	[codi_empr] ASC,
	[codi_emex] ASC,
	[codi_info] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_info_defi]  WITH CHECK ADD  CONSTRAINT [FK_dbax_info_defi_dbax_tipo_taxo] FOREIGN KEY([tipo_taxo])
REFERENCES [dbo].[dbax_tipo_taxo] ([tipo_taxo])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_info_defi] CHECK CONSTRAINT [FK_dbax_info_defi_dbax_tipo_taxo]
GO
