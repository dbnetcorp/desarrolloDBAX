SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_dime_cntx](
	[codi_fcdi] [varchar](20) NOT NULL,
	[diai_actu] [varchar](50) NULL,
	[anoi_actu] [varchar](50) NULL,
	[diat_actu] [varchar](50) NULL,
	[anot_actu] [varchar](50) NULL,
	[diai_ante] [varchar](50) NULL,
	[anoi_ante] [varchar](50) NULL,
	[diat_ante] [varchar](50) NULL,
	[anot_ante] [varchar](50) NULL,
 CONSTRAINT [PK_dbax_dime_cntx_1] PRIMARY KEY CLUSTERED 
(
	[codi_fcdi] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
