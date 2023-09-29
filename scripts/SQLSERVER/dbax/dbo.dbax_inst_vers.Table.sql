SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_inst_vers](
	[codi_pers] [numeric](9, 0) NOT NULL,
	[corr_inst] [numeric](10, 0) NOT NULL,
	[vers_inst] [numeric](5, 0) NOT NULL,
	[desc_vers] [varchar](256) NOT NULL,
	[codi_esta] [varchar](3) NOT NULL,
	[fech_carg] [varchar](20) NULL,
	[usua_carg] [varchar](30) NULL,
	[esta_carg] [varchar](3) NULL,
	[esta_gene] [varchar](3) NULL,
	[esta_impr] [varchar](3) NULL,
	[esta_doc] [varchar](3) NULL,
	[esta_visu] [varchar](3) NULL,
	[esta_cons] [int] NULL,
 CONSTRAINT [PK_dbax_inst_vers] PRIMARY KEY CLUSTERED 
(
	[codi_pers] ASC,
	[corr_inst] ASC,
	[vers_inst] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_inst_vers]  WITH CHECK ADD  CONSTRAINT [FK_dbax_inst_vers_dbax_inst_docu] FOREIGN KEY([codi_pers], [corr_inst])
REFERENCES [dbo].[dbax_inst_docu] ([codi_pers], [corr_inst])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_inst_vers] CHECK CONSTRAINT [FK_dbax_inst_vers_dbax_inst_docu]
GO
