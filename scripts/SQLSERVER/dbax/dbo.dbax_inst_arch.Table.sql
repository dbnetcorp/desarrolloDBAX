SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_inst_arch](
	[codi_pers] [numeric](9, 0) NOT NULL,
	[corr_inst] [numeric](10, 0) NOT NULL,
	[vers_inst] [numeric](5, 0) NOT NULL,
	[nomb_arch] [varchar](256) NOT NULL,
	[cont_arch] [text] NOT NULL,
	[tipo_mime] [varchar](50) NULL,
 CONSTRAINT [PK_dbax_inst_arch] PRIMARY KEY CLUSTERED 
(
	[codi_pers] ASC,
	[corr_inst] ASC,
	[vers_inst] ASC,
	[nomb_arch] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_inst_arch]  WITH CHECK ADD  CONSTRAINT [FK_dbax_inst_arch_dbax_inst_vers] FOREIGN KEY([codi_pers], [corr_inst], [vers_inst])
REFERENCES [dbo].[dbax_inst_vers] ([codi_pers], [corr_inst], [vers_inst])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_inst_arch] CHECK CONSTRAINT [FK_dbax_inst_arch_dbax_inst_vers]
GO
