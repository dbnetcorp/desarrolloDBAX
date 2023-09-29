SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[sys_domain](
	[domain_code] [numeric](4, 0) NOT NULL,
	[domain_name] [varchar](20) NULL,
	[domain_length] [numeric](2, 0) NULL,
	[domain_type] [varchar](1) NULL,
	[domain_show] [varchar](1) NULL,
	[domain_class] [varchar](1) NULL,
	[domain_low] [varchar](12) NULL,
	[domain_hight] [varchar](12) NULL,
	[domain_view] [varchar](30) NULL,
	[domain_sclass] [varchar](1) NULL,
	[domain_query] [varchar](1) NULL,
	[domain_aux] [varchar](1) NULL,
	[domain_auxlabel] [varchar](15) NULL,
 CONSTRAINT [sys_domain_pk] PRIMARY KEY CLUSTERED 
(
	[domain_code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
