SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_inst_docu](
	[codi_pers] [numeric](9, 0) NOT NULL,
	[corr_inst] [numeric](10, 0) NOT NULL,
	[vers_taxo] [varchar](256) NULL,
	[desc_inst] [varchar](512) NULL,
	[codi_esta] [varchar](3) NOT NULL,
	[anno_proc] [varchar](50) NULL,
	[mess_proc] [numeric](2, 0) NULL,
 CONSTRAINT [PK_dbax_inst_docu] PRIMARY KEY CLUSTERED 
(
	[codi_pers] ASC,
	[corr_inst] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_inst_docu]  WITH CHECK ADD  CONSTRAINT [FK_dbax_inst_docu_dbax_defi_pers] FOREIGN KEY([codi_pers])
REFERENCES [dbo].[dbax_defi_pers] ([codi_pers])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_inst_docu] CHECK CONSTRAINT [FK_dbax_inst_docu_dbax_defi_pers]
GO
ALTER TABLE [dbo].[dbax_inst_docu]  WITH CHECK ADD  CONSTRAINT [FK_dbax_inst_docu_dbax_taxo_vers] FOREIGN KEY([vers_taxo])
REFERENCES [dbo].[dbax_taxo_vers] ([vers_taxo])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_inst_docu] CHECK CONSTRAINT [FK_dbax_inst_docu_dbax_taxo_vers]
GO
