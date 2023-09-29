SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dbax_pers_grup2](
	[domain_code] [numeric](4, 0) NOT NULL,
	[fech_inic] [datetime] NULL,
	[fech_term] [datetime] NULL,
 CONSTRAINT [PK_dbax_pers_grup2] PRIMARY KEY CLUSTERED 
(
	[domain_code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
