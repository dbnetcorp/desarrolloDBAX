SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[sys_object](
	[object_name] [varchar](30) NOT NULL,
	[object_type] [varchar](1) NULL,
	[object_brief] [varchar](100) NULL,
	[table_name] [varchar](30) NULL,
	[table_type] [varchar](1) NULL,
	[appname] [varchar](100) NULL,
	[form_type] [varchar](1) NULL,
	[report_name] [varchar](30) NULL,
	[report_type] [varchar](1) NULL,
	[query_clause] [varchar](2000) NULL,
	[order_key] [numeric](3, 0) NULL,
	[object_desc] [varchar](200) NULL,
	[alter_key] [numeric](3, 0) NULL,
	[object_code] [varchar](30) NULL,
	[object_single] [varchar](30) NULL,
	[object_rela] [varchar](30) NULL,
	[rol0] [varchar](1) NULL,
	[rol1] [varchar](1) NULL,
	[rol2] [varchar](1) NULL,
	[rol3] [varchar](1) NULL,
	[rol4] [varchar](1) NULL,
	[rol5] [varchar](1) NULL,
	[rol6] [varchar](1) NULL,
	[rol7] [varchar](1) NULL,
	[rol8] [varchar](1) NULL,
	[rol9] [varchar](1) NULL,
	[object_prog] [varchar](30) NULL,
	[object_priv] [varchar](1) NULL,
	[object_order] [varchar](30) NULL,
	[object_sex] [varchar](1) NULL,
	[object_state] [varchar](30) NULL,
	[object_date] [datetime] NULL,
	[object_pname] [varchar](30) NULL,
	[object_shell] [varchar](30) NULL,
	[codi_modu] [varchar](30) NULL,
	[par0] [varchar](30) NULL,
	[par1] [varchar](30) NULL,
	[par2] [varchar](30) NULL,
	[par3] [varchar](30) NULL,
	[par4] [varchar](30) NULL,
	[par5] [varchar](30) NULL,
	[par6] [varchar](30) NULL,
	[par7] [varchar](30) NULL,
	[par8] [varchar](30) NULL,
	[par9] [varchar](30) NULL,
	[val0] [varchar](30) NULL,
	[val1] [varchar](30) NULL,
	[val2] [varchar](30) NULL,
	[val3] [varchar](30) NULL,
	[val4] [varchar](30) NULL,
	[val5] [varchar](30) NULL,
	[val6] [varchar](30) NULL,
	[val7] [varchar](30) NULL,
	[val8] [varchar](30) NULL,
	[val9] [varchar](30) NULL,
	[object_orun] [varchar](60) NULL,
	[object_level] [numeric](22, 0) NULL,
	[object_freq] [varchar](1) NULL,
	[codi_acti] [numeric](22, 0) NULL,
	[object_empr] [varchar](1) NULL,
 CONSTRAINT [sys_obje_pk] PRIMARY KEY CLUSTERED 
(
	[object_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
