SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_inst_dicx](
	[codi_pers] [numeric](9, 0) NOT NULL,
	[corr_inst] [numeric](10, 0) NOT NULL,
	[codi_cntx] [varchar](256) NOT NULL,
	[codi_axis] [varchar](256) NOT NULL,
	[codi_memb] [varchar](256) NOT NULL,
	[vers_inst] [numeric](5, 0) NOT NULL,
 CONSTRAINT [PK_dbax_inst_dicx] PRIMARY KEY CLUSTERED 
(
	[codi_pers] ASC,
	[corr_inst] ASC,
	[codi_cntx] ASC,
	[codi_axis] ASC,
	[codi_memb] ASC,
	[vers_inst] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_inst_dicx]  WITH CHECK ADD  CONSTRAINT [FK_dbax_inst_dicx_dbax_inst_cntx] FOREIGN KEY([codi_pers], [corr_inst], [vers_inst], [codi_cntx])
REFERENCES [dbo].[dbax_inst_cntx] ([codi_pers], [corr_inst], [vers_inst], [codi_cntx])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_inst_dicx] CHECK CONSTRAINT [FK_dbax_inst_dicx_dbax_inst_cntx]
GO
