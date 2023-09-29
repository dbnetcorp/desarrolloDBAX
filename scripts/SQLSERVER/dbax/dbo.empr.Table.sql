SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[empr](
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_emex] [varchar](30) NOT NULL CONSTRAINT [DF_empr_codi_emex]  DEFAULT ((1)),
	[desc_empr] [varchar](100) NULL,
 CONSTRAINT [PK_empr] PRIMARY KEY CLUSTERED 
(
	[codi_empr] ASC,
	[codi_emex] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[empr]  WITH CHECK ADD  CONSTRAINT [FK_empr_holding] FOREIGN KEY([codi_emex])
REFERENCES [dbo].[holding] ([codi_emex])
GO
ALTER TABLE [dbo].[empr] CHECK CONSTRAINT [FK_empr_holding]
GO
