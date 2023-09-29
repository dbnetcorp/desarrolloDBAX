SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[area_geog](
	[codi_arge] [varchar](8) NOT NULL,
	[nomb_arge] [varchar](20) NOT NULL,
	[tipo_arge] [varchar](2) NOT NULL,
	[desc_peri_arge] [varchar](30) NULL,
	[codi_arge1] [varchar](8) NULL,
	[post_arge] [numeric](4, 0) NULL,
	[marc_arge] [varchar](1) NULL,
	[genm_arge] [varchar](30) NULL,
	[genf_arge] [varchar](30) NULL,
 CONSTRAINT [arge_pk] PRIMARY KEY CLUSTERED 
(
	[codi_arge] ASC,
	[tipo_arge] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
