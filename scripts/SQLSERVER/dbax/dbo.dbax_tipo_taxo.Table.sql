SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_tipo_taxo](
	[tipo_taxo] [varchar](10) NOT NULL,
	[desc_tipo] [varchar](50) NOT NULL,
 CONSTRAINT [PK_dbax_tipo_taxo] PRIMARY KEY CLUSTERED 
(
	[tipo_taxo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
