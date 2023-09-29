SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbax_form_deta](
	[codi_emex] [varchar](30) NOT NULL CONSTRAINT [DF_dbaxl_form_deta_codi_emex]  DEFAULT ((1)),
	[codi_empr] [numeric](9, 0) NOT NULL,
	[codi_indi] [varchar](100) NOT NULL,
	[letr_vari] [varchar](2) NOT NULL,
	[pref_conc] [varchar](50) NOT NULL,
	[codi_conc] [varchar](256) NOT NULL,
	[codi_cntx] [varchar](50) NOT NULL,
 CONSTRAINT [PK_xbrl_form_deta] PRIMARY KEY CLUSTERED 
(
	[letr_vari] ASC,
	[codi_indi] ASC,
	[codi_emex] ASC,
	[codi_empr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[dbax_form_deta]  WITH CHECK ADD  CONSTRAINT [FK_dbax_form_deta_dbax_defi_cntx] FOREIGN KEY([codi_empr], [codi_emex], [codi_cntx])
REFERENCES [dbo].[dbax_defi_cntx] ([codi_empr], [codi_emex], [codi_cntx])
GO
ALTER TABLE [dbo].[dbax_form_deta] CHECK CONSTRAINT [FK_dbax_form_deta_dbax_defi_cntx]
GO
ALTER TABLE [dbo].[dbax_form_deta]  WITH CHECK ADD  CONSTRAINT [FK_xbrl_form_deta_xbrl_defi_conc] FOREIGN KEY([codi_conc], [pref_conc])
REFERENCES [dbo].[dbax_defi_conc] ([codi_conc], [pref_conc])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_form_deta] CHECK CONSTRAINT [FK_xbrl_form_deta_xbrl_defi_conc]
GO
ALTER TABLE [dbo].[dbax_form_deta]  WITH CHECK ADD  CONSTRAINT [FK_xbrl_form_deta_xbrl_form_enca] FOREIGN KEY([codi_emex], [codi_indi], [codi_empr])
REFERENCES [dbo].[dbax_form_enca] ([codi_emex], [codi_indi], [codi_empr])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dbax_form_deta] CHECK CONSTRAINT [FK_xbrl_form_deta_xbrl_form_enca]
GO
