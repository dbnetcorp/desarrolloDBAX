SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_desc_info](
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_emex] [varchar](30) NOT NULL CONSTRAINT [DF_dbax_desc_info_codi_emex]  DEFAULT ((1)),
	[codi_info] [varchar](50) NOT NULL,
	[codi_lang] [varchar](50) NOT NULL,
	[desc_info] [varchar](256) NOT NULL,
 CONSTRAINT [PK_xbrl_desc_info] PRIMARY KEY CLUSTERED 
(
	[codi_empr] ASC,
	[codi_emex] ASC,
	[codi_info] ASC,
	[codi_lang] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_desc_info]  WITH CHECK ADD  CONSTRAINT [FK_dbax_desc_info_dbax_info_defi] FOREIGN KEY([codi_empr], [codi_emex], [codi_info])
REFERENCES [dbo].[dbax_info_defi] ([codi_empr], [codi_emex], [codi_info])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_desc_info] CHECK CONSTRAINT [FK_dbax_desc_info_dbax_info_defi]
GO
ALTER TABLE [dbo].[dbax_desc_info]  WITH CHECK ADD  CONSTRAINT [FK_xbrl_desc_info_dbne_defi_lang] FOREIGN KEY([codi_lang])
REFERENCES [dbo].[dbne_defi_lang] ([codi_lang])
GO
ALTER TABLE [dbo].[dbax_desc_info] CHECK CONSTRAINT [FK_xbrl_desc_info_dbne_defi_lang]
GO
