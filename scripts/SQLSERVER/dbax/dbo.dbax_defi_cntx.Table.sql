SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_defi_cntx](
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_emex] [varchar](30) NOT NULL CONSTRAINT [DF_dbax_defi_cntx_codi_emex]  DEFAULT ((1)),
	[codi_cntx] [varchar](50) NOT NULL,
	[diai_cntx] [varchar](100) NOT NULL,
	[anoi_cntx] [varchar](100) NOT NULL,
	[diat_cntx] [varchar](100) NULL,
	[anot_cntx] [varchar](100) NULL,
	[desc_cntx] [varchar](100) NULL,
	[orde_cntx] [numeric](3, 0) NULL,
 CONSTRAINT [PK_dbax_defi_cntx] PRIMARY KEY CLUSTERED 
(
	[codi_empr] ASC,
	[codi_emex] ASC,
	[codi_cntx] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
