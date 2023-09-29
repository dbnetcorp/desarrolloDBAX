SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_info_cntx](
	[codi_inct] [int] IDENTITY(1,1) NOT NULL,
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_emex] [varchar](30) NOT NULL CONSTRAINT [DF_dbax_info_cntx_codi_emex]  DEFAULT ((1)),
	[codi_info] [varchar](50) NOT NULL,
	[codi_cntx] [varchar](50) NOT NULL,
	[orde_cntx] [int] NULL,
 CONSTRAINT [PK_dbax_info_cntx] PRIMARY KEY CLUSTERED 
(
	[codi_inct] ASC,
	[codi_empr] ASC,
	[codi_emex] ASC,
	[codi_info] ASC,
	[codi_cntx] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_info_cntx]  WITH CHECK ADD  CONSTRAINT [FK_dbax_info_cntx_dbax_defi_cntx] FOREIGN KEY([codi_empr], [codi_emex], [codi_cntx])
REFERENCES [dbo].[dbax_defi_cntx] ([codi_empr], [codi_emex], [codi_cntx])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_info_cntx] CHECK CONSTRAINT [FK_dbax_info_cntx_dbax_defi_cntx]
GO
ALTER TABLE [dbo].[dbax_info_cntx]  WITH CHECK ADD  CONSTRAINT [FK_dbax_info_cntx_dbax_info_defi] FOREIGN KEY([codi_empr], [codi_emex], [codi_info])
REFERENCES [dbo].[dbax_info_defi] ([codi_empr], [codi_emex], [codi_info])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_info_cntx] CHECK CONSTRAINT [FK_dbax_info_cntx_dbax_info_defi]
GO
