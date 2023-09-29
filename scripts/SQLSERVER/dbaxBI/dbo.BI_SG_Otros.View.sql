USE [dbaxBI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BI_SG_Otros]
AS
select distinct codi_segm, codi_memb, desc_memb, orde_memb, codi_axis, desc_axis
	from (
select  'SEGUROVIDA' codi_segm,
		cast(m.codi_memb as varchar(50)) collate Modern_Spanish_CI_AS	codi_memb,
		replace(c2.desc_conc, '[miembro]','')							desc_memb,
		m.orde_memb														orde_memb,
		cast(m.codi_axis as varchar(50)) collate Modern_Spanish_CI_AS	codi_axis,
		replace(c1.desc_conc, '[eje]','')								desc_axis
from	dbax.dbo.dbax_dime_memb m,
		dbax.dbo.dbax_desc_conc c1,
		dbax.dbo.dbax_desc_conc c2
where	m.tipo_memb = 'domain-member'
and     c1.pref_conc = m.pref_axis
and     c1.codi_conc = m.codi_axis
and     c2.pref_conc = m.pref_memb
and     c2.codi_conc = m.codi_memb
and     exists (select  1
				from	dbax.dbo.dbax_dime_diax d
				where	d.codi_dein like '%cuadro%'
				and     substring(d.codi_dein, charindex('role',d.codi_dein) + 5 + 5,1) = '2'
				and     d.codi_axis = m.codi_axis)
UNION
select  'SEGUROGRAL' codi_segm,
		cast(m.codi_memb as varchar(50)) collate Modern_Spanish_CI_AS	codi_memb,
		replace(c2.desc_conc, '[miembro]','')	desc_memb,
		m.orde_memb								orde_memb,
		cast(m.codi_axis as varchar(50)) collate Modern_Spanish_CI_AS	codi_axis,
		replace(c1.desc_conc, '[eje]','')		desc_axis
from	dbax.dbo.dbax_dime_memb m,
		dbax.dbo.dbax_desc_conc c1,
		dbax.dbo.dbax_desc_conc c2
where	m.tipo_memb = 'domain-member'
and     c1.pref_conc = m.pref_axis
and     c1.codi_conc = m.codi_axis
and     c2.pref_conc = m.pref_memb
and     c2.codi_conc = m.codi_memb
and     exists (select  1
				from	dbax.dbo.dbax_dime_diax d
				where	d.codi_dein like '%cuadro%'
				and     substring(d.codi_dein, charindex('role',d.codi_dein) + 5 + 5,1) = '1'
				and     d.codi_axis = m.codi_axis)
) vista
GO
