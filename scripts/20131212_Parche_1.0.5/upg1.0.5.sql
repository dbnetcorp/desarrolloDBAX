set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER function [dbo].[AX_getDescInfo](
			@p_CodiEmex varchar(30),
			@p_CodiEmpr numeric(9,0),
			@p_CodiInfo varchar(50),
			@p_CodiLangOrig varchar(256)='es_ES',
			@p_TipoInfo varchar(2) = 'C') returns varchar(256)
as
begin
	declare @vNombreCorto varchar(256)

	if(@p_CodiLangOrig='es_ES')
	begin
		declare @DescAlt numeric(2,0)
		declare @p_CodiLang varchar(256)

		set @p_CodiLang = @p_CodiLangOrig

		select	@DescAlt = count(*) from para_empr 
		where	codi_emex = @p_CodiEmex 
		and		codi_empr = @p_CodiEmpr
		and		codi_paem = 'CODI_LANG'
		and		valo_paem = 'ALT'
		
		if(@DescAlt > 0)
		begin
			set @p_CodiLang = 'ALT'
		end

		select	@vNombreCorto = max(desc_info)
		from	dbax_desc_info
		where	((codi_emex = 0 and codi_empr = 0) or (codi_emex = @p_CodiEmex and codi_empr = @p_CodiEmpr))
		and		codi_info = @p_CodiInfo
		and		codi_lang = @p_CodiLang
		and		tipo_info = @p_TipoInfo

		if(@vNombreCorto is null)
		begin
			select	@vNombreCorto = isnull(max(desc_info),@p_CodiInfo)
			from	dbax_desc_info
			where	((codi_emex = 0 and codi_empr = 0) or (codi_emex = @p_CodiEmex and codi_empr = @p_CodiEmpr))
			and		codi_info = @p_CodiInfo
			and		codi_lang = @p_CodiLangOrig
			and		tipo_info = @p_TipoInfo
		end
	end
	else
	begin
		select	@vNombreCorto = isnull(max(desc_info),'')
		from	dbax_desc_info
		where	((codi_emex = 0 and codi_empr = 0) or (codi_emex = @p_CodiEmex and codi_empr = @p_CodiEmpr))
		and		codi_info = @p_CodiInfo
		and		codi_lang = @p_CodiLangOrig
		and		tipo_info = @p_TipoInfo
	end

	return @vNombreCorto
end
GO

update dbax_desc_info set codi_lang = 'ALT' where codi_lang = '2'

insert into dbne_defi_lang (codi_lang, desc_lang)
values ('ALT', 'Descripciones alternativas')
delete from dbne_defi_lang where codi_lang = '2'
GO

ALTER function [dbo].[FU_AX_getDescConc](
			@p_CodiEmex varchar(30),
			@p_CodiEmpr numeric(9,0),
			@p_PrefConc varchar(50),
			@p_CodiConc varchar(256),
			@p_CodiLangOrig varchar(256)='es_ES') returns varchar(256)
as
begin
	declare @vDescConc varchar(256)


	declare @DescAlt numeric(2,0)
	declare @p_CodiLang varchar(256)

	set @p_CodiLang = @p_CodiLangOrig

	select	@DescAlt = count(*) from para_empr 
	where	codi_emex = @p_CodiEmex 
	and		codi_empr = @p_CodiEmpr
	and		codi_paem = 'CODI_LANG'
	and		valo_paem = 'ALT'
	
	if(@DescAlt > 0)
	begin
		set @p_CodiLang = 'ALT'
	end

	select	@vDescConc = max(desc_conc)
	from	dbax_desc_conc
	where	pref_conc = @p_PrefConc
	and		codi_conc = @p_CodiConc
	and		codi_lang = @p_CodiLang

	if(@vDescConc is null)
	begin
		select	@vDescConc = max(desc_conc)
		from	dbax_desc_conc
		where	pref_conc = @p_PrefConc
		and		codi_conc = @p_CodiConc
		and		codi_lang = @p_CodiLangOrig
	end
	

	return @vDescConc
end
GO

ALTER procedure [dbo].[SP_AX_getDimensionesUsables]
		@p_CodiEmex varchar(30),
		@p_CodiEmpr numeric(9,0),
		@p_CodiInfo varchar(256)
as
BEGIN
	select distinct dd.pref_dime + ':' + dd.codi_dime codi_dime, dbo.[FU_AX_getDescConc](@p_CodiEmex, @p_CodiEmpr, dd.pref_dime, dd.codi_dime, 'es_ES') desc_dime
	from	dbax_dime_defi dd
	where	dd.codi_dein = @p_CodiInfo 
END
GO

CREATE procedure [dbo].[SP_AX_GetPermUsuaEmpr](
	@p_CodiEmex varchar(30),
	@p_CodiEmpr numeric(9,0),
	@p_CodiUsua varchar(30)) as
BEGIN
	SELECT COUNT(*)
	FROM  dbax_exte_pers ep,
		  usua_sist us
	WHERE ep.codi_emex=us.codi_emex collate Modern_Spanish_CS_AS
	AND   ep.codi_emex=@p_CodiEmex
	AND   ep.codi_pers=@p_CodiEmpr
	AND   us.codi_usua=@p_CodiUsua
END
GO

--2013
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2013-31-03'), '472.54')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2013-30-06'), '503.86')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2013-30-09'), '502.97')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2013-31-12'), '523.7600')


insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2013-30-09'), '23091.03')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2011-30-12'), '23309.56')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2013-31-12'), '23309.56')
GO
--2012
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2012-31-03'), '489.76')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2012-30-06'), '509.73')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2012-30-09'), '470.48')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2012-31-12'), '478.60')

insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2012-31-03'), '22533.51')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2012-30-06'), '22627.36')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2012-30-09'), '22591.05')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2012-31-12'), '22840.75')
--2011
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2011-31-03'), '482.08')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2011-30-06'), '471.13')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2011-30-09'), '515.14')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2011-31-12'), '521.46')

insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2011-31-03'), '22869.38')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2011-30-06'), '22852.67')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2011-30-09'), '23091.03')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2011-31-12'), '23309.56')
--2010
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2010-30-06'), '21202.16')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2010-30-09'), '21339.99')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','CLF',convert(datetime,'2010-30-12'), '21455.55')

insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2010-30-06'), '543.09')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2010-30-09'), '485.23')
insert into dbn_camb_mone
		(codi_emex, codi_mone, codi_mone1, fech_camo, valo_camo)
values	(1,'CLP','USD',convert(datetime,'2010-31-12'), '468.37')
--

ALTER function [dbo].[esNumero](@p_valor varchar(50)) returns varchar(1)
begin
	declare @i int
	declare @l numeric
	declare @r varchar(1)
	set @i = 1
	set @r = 'S'


	if(len(@p_valor) - len(replace(@p_valor, '.', '')) > 1)
		return 'N'

	set @l = len(@p_valor)

	if(@l = 1 AND @p_valor in ('-', '.', ',', ' '))
		return 'N'

	while (@i <= len(@p_valor) AND @r = 'S')
	begin
		if (@i = 1 AND substring(@p_valor,@i,1) not in ('0','1','2','3','4','5','6','7','8','9',' ','.','-'))
		begin
			set @r = 'N'
		end
		else if (@i > 1 AND substring(@p_valor,@i,1) not in ('0','1','2','3','4','5','6','7','8','9',' ','.'))
		begin
			set @r = 'N'
		end
		set @i = @i + 1
	end

    return @r
end
GO

insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-110000(2011)','0001#0001#110000','svs-cl-ci-2011-04-26/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-110000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-210000(2011)','0001#0001#210000','svs-cl-ci-2011-04-26/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-210000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-220000(2011)','0001#0001#220000','svs-cl-ci-2011-04-26/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-220000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-310000(2011)','0001#0001#310000','svs-cl-ci-2011-04-26/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-310000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-320000(2011)','0001#0001#320000','svs-cl-ci-2011-04-26/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-320000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-420000(2011)','0001#0001#420000','svs-cl-ci-2011-04-26/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-420000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-610000(2011)','0001#0001#610000','svs-cl-ci-2011-04-26/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-610000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-832100(2011)','0002#0001#832100','svs-cl-ci-2011-04-26/notas/cl-ci_ias-1_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-24_2010-04-30_role-818010(2011)','0002#0024#818010','svs-cl-ci-2011-04-26/notas/cl-ci_ias-24_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-27_2010-04-30_role-825490(2011)','0002#0027#825490','svs-cl-ci-2011-04-26/notas/cl-ci_ias-27_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-7_2010-04-30_role-510000(2011)','0001#0007#510000','svs-cl-ci-2011-04-26/cl-ci_ias-7_2010-04-30/cl-ci_ias-7_2010-04-30_role-510000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-7_2010-04-30_role-520000(2011)','0001#0007#520000','svs-cl-ci-2011-04-26/cl-ci_ias-7_2010-04-30/cl-ci_ias-7_2010-04-30_role-520000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ifrs-7_2010-04-30_role-822390(2011)','0003#0007#822390','svs-cl-ci-2011-04-26/notas/cl-ci_ifrs-7_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ifrs-7_2010-04-30_role-822400(2011)','0003#0007#822400','svs-cl-ci-2011-04-26/notas/cl-ci_ifrs-7_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-hb_ias-1_2010-04-30_role-210000(2011)','0001#0001#210000','cl-hb-2011-04-26/cl-hb_ias-1_2010-04-30_role-210000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-hb_ias-1_2010-04-30_role-310000(2011)','0001#0001#310000','cl-hb-2011-04-26/cl-hb_ias-1_2010-04-30_role-310000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-hb_ias-7_2010-04-30_role-510000(2011)','0001#0007#510000','cl-hb-2011-04-26/cl-hb_ias-7_2010-04-30_role-510000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-hs_ias-1_2010-04-30_role-210000(2011)','0001#0001#210000','cl-hs-2011-04-26/cl-hs_ias-1_2010-04-30_role-210000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-hs_ias-1_2010-04-30_role-310000(2011)','0001#0001#310000','cl-hs-2011-04-26/cl-hs_ias-1_2010-04-30_role-310000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-hs_ias-7_2010-04-30_role-510000(2011)','0001#0007#510000','cl-hs-2011-04-26/cl-hs_ias-7_2010-04-30_role-510000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_1_2010-04-30_role-810000(2011)','0002#0001#810000','svs-cl-ci-2011-04-26/notas/cl-ci_ias-1_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_1_2010-04-30_role-832000(2011)','0002#0001#832000','svs-cl-ci-2011-04-26/notas/cl-ci_ias-1_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_1_2010-04-30_role-861200(2011)','0002#0001#861200','svs-cl-ci-2011-04-26/notas/cl-ci_ias-1_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_10_2010-04-30_role-815000(2011)','0002#0010#815000','svs-cl-ci-2011-04-26/notas/cl-ci_ias-10_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_11_2010-04-30_role-831710(2011)','0002#0011#831710','svs-cl-ci-2011-04-26/notas/cl-ci_ias-11_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_12_2010-04-30_role-835110(2011)','0002#0012#835110','svs-cl-ci-2011-04-26/notas/cl-ci_ias-12_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_16_2010-04-30_role-822100(2011)','0002#0016#822100','svs-cl-ci-2011-04-26/notas/cl-ci_ias-16_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_17_2010-04-30_role-832600(2011)','0002#0017#832600','svs-cl-ci-2011-04-26/notas/cl-ci_ias-17_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_18_2010-04-30_role-831110(2011)','0002#0018#831110','svs-cl-ci-2011-04-26/notas/cl-ci_ias-18_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_19_2010-04-30_role-834480(2011)','0002#0019#834480','svs-cl-ci-2011-04-26/notas/cl-ci_ias-19_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_2_2010-04-30_role-826380(2011)','0002#0002#826380','svs-cl-ci-2011-04-26/notas/cl-ci_ias-2_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_20_2010-04-30_role-831400(2011)','0002#0020#831400','svs-cl-ci-2011-04-26/notas/cl-ci_ias-20_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_21_2010-04-30_role-842000(2011)','0002#0021#842000','svs-cl-ci-2011-04-26/notas/cl-ci_ias-21_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_23_2010-04-30_role-836200(2011)','0002#0023#836200','svs-cl-ci-2011-04-26/notas/cl-ci_ias-23_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_24_2010-04-30_role-818000(2011)','0002#0024#818000','svs-cl-ci-2011-04-26/notas/cl-ci_ias-24_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_26_2010-04-30_role-710000(2011)','0001#0026#710000','svs-cl-ci-2011-04-26/notas/cl-ci_ias-26_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_27_2010-04-30_role-825480(2011)','0002#0027#825480','svs-cl-ci-2011-04-26/notas/cl-ci_ias-27_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_28_2010-04-30_role-825600(2011)','0002#0028#825600','svs-cl-ci-2011-04-26/notas/cl-ci_ias-28_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_29_2010-04-30_role-816000(2011)','0002#0029#816000','svs-cl-ci-2011-04-26/notas/cl-ci_ias-29_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_31_2010-04-30_role-825500(2011)','0002#0031#825500','svs-cl-ci-2011-04-26/notas/cl-ci_ias-31_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_33_2010-04-30_role-838000(2011)','0002#0033#838000','svs-cl-ci-2011-04-26/notas/cl-ci_ias-33_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_36_2010-04-30_role-832410(2011)','0002#0036#832410','svs-cl-ci-2011-04-26/notas/cl-ci_ias-36_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_37_2010-04-30_role-827570(2011)','0002#0037#827570','svs-cl-ci-2011-04-26/notas/cl-ci_ias-37_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_38_2010-04-30_role-823180(2011)','0002#0038#823180','svs-cl-ci-2011-04-26/notas/cl-ci_ias-38_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_40_2010-04-30_role-825100(2011)','0002#0040#825100','svs-cl-ci-2011-04-26/notas/cl-ci_ias-40_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_41_2010-04-30_role-824180(2011)','0002#0041#824180','svs-cl-ci-2011-04-26/notas/cl-ci_ias-41_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_7_2010-04-30_role-851100(2011)','0002#0007#851100','svs-cl-ci-2011-04-26/notas/cl-ci_ias-7_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ias_8_2010-04-30_role-811000(2011)','0002#0008#811000','svs-cl-ci-2011-04-26/notas/cl-ci_ias-8_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ifric_2_2010-04-30_role-868500(2011)','0004#0000#868500','svs-cl-ci-2011-04-26/notas/cl-ci_ifric_2_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ifric_5_2010-04-30_role-868200(2011)','0004#0000#868200','svs-cl-ci-2011-04-26/notas/cl-ci_ifric_5_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ifrs_2_2010-04-30_role-834120(2011)','0003#0002#834120','svs-cl-ci-2011-04-26/notas/cl-ci_ifrs-2_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ifrs_3_2010-04-30_role-817000(2011)','0003#0003#817000','svs-cl-ci-2011-04-26/notas/cl-ci_ifrs-3_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ifrs_4_2010-04-30_role-836500(2011)','0003#0004#836500','svs-cl-ci-2011-04-26/notas/cl-ci_ifrs-4_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ifrs_5_2010-04-30_role-825900(2011)','0003#0005#825900','svs-cl-ci-2011-04-26/notas/cl-ci_ifrs-5_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ifrs_6_2010-04-30_role-822200(2011)','0003#0006#822200','svs-cl-ci-2011-04-26/notas/cl-ci_ifrs-6_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_ifrs_8_2010-04-30_role-871100(2011)','0003#0008#871100','svs-cl-ci-2011-04-26/notas/cl-ci_ifrs-8_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_sic_27_2010-04-30_role-832800(2011)','0004#0000#832800','svs-cl-ci-2011-04-26/notas/cl-ci_sic-27_2010-04-30.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_sic_29_2010-04-30_role-832900(2011)','0004#0000#832900','svs-cl-ci-2011-04-26/notas/cl-ci_sic-29_2010-04-30.xsd')

update dbax_taxo_info set sche_info = replace(sche_info, 'svs-cl-ci-2011-04-26', 'http://www.svs.cl/cl/fr/ci/2011-04-26')
GO

insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-110000','0001#0001#110000','svs-cl-ci-2010-05-15/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-110000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-210000','0001#0001#210000','svs-cl-ci-2010-05-15/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-210000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-210005','0001#0001#210005','svs-cl-ci-2010-05-15/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-210005.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-220000','0001#0001#220000','svs-cl-ci-2010-05-15/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-220000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-220005','0001#0001#220005','svs-cl-ci-2010-05-15/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-220005.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-310000','0001#0001#310000','svs-cl-ci-2010-05-15/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-310000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-310005','0001#0001#310005','svs-cl-ci-2010-05-15/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-310005.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-320000','0001#0001#320000','svs-cl-ci-2010-05-15/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-320000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-320005','0001#0001#320005','svs-cl-ci-2010-05-15/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-320005.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-420000','0001#0001#420000','svs-cl-ci-2010-05-15/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-420000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-420005','0001#0001#420005','svs-cl-ci-2010-05-15/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-420005.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-610000','0001#0001#610000','svs-cl-ci-2010-05-15/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-610000.xsd')
insert into dbax_taxo_info (codi_info, orde_info, sche_info) values ('pre_cl-ci_ias-1_2010-04-30_role-610005','0001#0001#610005','svs-cl-ci-2010-05-15/cl-ci_ias-1_2010-04-30/cl-ci_ias-1_2010-04-30_role-610005.xsd')

update dbax_taxo_info set sche_info = replace(sche_info, 'svs-cl-ci-2010-05-15', 'http://www.svs.cl/cl/fr/ci/2010-05-15')
GO

ALTER procedure [dbo].[SP_AX_getEmpresaPorGrupoSegmento](
	@pCodiEmex varchar(30),
	@pCodiEmpr numeric (9,0),
	@pCorrInst varchar(10),
	@pDescripcion varchar(100),
	@pGrupo varchar(50),
	@pSegmento varchar(50),
	@pTipo varchar(10),
	@pTipoDesc varchar(100) = 'P',
	@pTipoArch varchar(10) = 'Oficial'
	)
as
BEGIN
	--select @pTipoDesc, @pTipoArch
	/*	
		@pTipoDesc = 'P' devuelve descripcion por defecto y personalizada
		@pTipoDesc  = 'C' SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN
		@pTipoDesc  = 'E' SE DEVUELVE SOLO LAS QUE TENGAN CORR_INST CREADO

		@pTipoArch = O significa oficial, E = externo (no oficial)
	*/

	set @pDescripcion = upper(@pDescripcion)

	declare @vComodinGrup varchar(1)
	declare @vComodinSegm varchar(1)
	declare @vComodinTipo varchar(1)
	declare @vComodinCorr varchar(1)
	declare @AccesoLimitado numeric(4,0)
	declare @vMaxiVers numeric(3,0)
	declare @vMinVers numeric(2,0)

	set @vComodinGrup = '%'
	set @vComodinSegm = '%'
	set @vComodinTipo = '%'
	set @vComodinCorr = '%'

	if ( @pGrupo != '')
	begin
		set @vComodinGrup = ''
	end

	if ( @pSegmento != '')
	begin
		set @vComodinSegm = ''
	end

	if ( @pTipo != '')
	begin
		set @vComodinTipo = ''
	end

	if (@pCorrInst != '')
	begin
		set @vComodinCorr = ''
	end

	if(@pTipoArch='Oficial')
	begin
		set @vMinVers = 0
		set @vMaxiVers = 30
	end
	else
	begin
		set @vMinVers = 30
		set @vMaxiVers = 999
	end

	-- TODAS LAS EMPRESAS
	if(@pTipoDesc = 'P') 
	begin
		select @AccesoLimitado = count(*) from dbax_exte_pers where codi_emex = @pCodiEmex

		--Todos los periodos
		if(@pCorrInst = '')
		BEGIN
			if(@AccesoLimitado > 0)
			begin
				select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
				from	(select distinct dp.codi_pers as codi_pers,
										dp.desc_pers as desc_pers,
										isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										dp.tipo_taxo as tipo_taxo,
										(select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id,
								dbax_exte_pers ep
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
								or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		isnull(dp.empr_vige,'SI') = 'SI'
						and		ep.codi_emex = dh.codi_emex
						and		ep.codi_pers = id.codi_pers) v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				order by v.desc_pers asc
			end
			else
			begin
				select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
				from	(select distinct dp.codi_pers as codi_pers,
										dp.desc_pers as desc_pers,
										isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										dp.tipo_taxo as tipo_taxo
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
								or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		isnull(dp.empr_vige,'SI') = 'SI') v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				order by v.desc_pers asc
			end
		END
		--Fin todos los periodos
		ELSE
		--Un periodo en particular
		BEGIN
			if(@AccesoLimitado > 0)
			begin
				print 1
				select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo, v.vers_inst, @pCorrInst corr_inst
				from	(select distinct dp.codi_pers as codi_pers,
										dp.desc_pers as desc_pers,
										isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										dp.tipo_taxo as tipo_taxo,
										(select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id,
								dbax_exte_pers ep
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
								or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		isnull(dp.empr_vige,'SI') = 'SI'
						and		ep.codi_emex = dh.codi_emex
						and		ep.codi_pers = id.codi_pers) v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				order by v.desc_pers asc
			end
			else
			begin
				select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo, v.vers_inst, @pCorrInst corr_inst
				from	(select distinct dp.codi_pers as codi_pers,
										dp.desc_pers as desc_pers,
										isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										dp.tipo_taxo as tipo_taxo,
										(select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
								or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		isnull(dp.empr_vige,'SI') = 'SI') v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				order by v.desc_pers asc
			end
		END
		--Fin un periodo en particular
	end
	--Fin todas las empresas
	
	if(@pTipoDesc = 'C') -- SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN (para grilla de diferencias)
	begin
		select	distinct v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo, vt.vers_inst
		from	(select distinct dp.codi_pers as codi_pers,
								dp.desc_pers as desc_pers,
								isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
								dg.desc_grup as desc_grup,
								dp.codi_grup as codi_grup,
								dp.codi_segm as codi_segm,
								dp.tipo_taxo as tipo_taxo,
								(select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
				from	dbax_defi_pers dp 
							left join dbax_defi_peho dh 
							on	dh.codi_emex = @pCodiEmex 
							and	dh.codi_empr = @pCodiEmpr 
							and	dp.codi_pers = dh.codi_pers
								left join dbax_defi_grup dg
								on	dg.codi_grup = dp.codi_grup,
						dbax_inst_docu id
				where	(dp.codi_pers like '%' + @pDescripcion + '%' 
						or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
						or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
				and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
				and		dp.codi_pers = id.codi_pers
				and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
				and		isnull(dp.empr_vige,'SI') = 'SI') v
		left join dbax_defi_segm ds
			on v.codi_segm = ds.codi_segm
		left join dbax_tipo_taxo tt
			on v.tipo_taxo = tt.tipo_taxo,
		dbax_inst_vers vt
		where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
		and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
		and	vt.codi_pers = v.codi_pers
		and	vt.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
		and	vt.vers_inst > 1
		and	vt.vers_inst < @vMaxiVers
		order by v.desc_pers asc
	end

	if(@pTipoDesc = 'E') -- TODAS LAS EMPRESAS CON PERIODO CREADO CORR_INST
	begin
		select @AccesoLimitado = count(*) from dbax_exte_pers where codi_emex = @pCodiEmex

		if(@AccesoLimitado > 0)
		begin
			Print 'Acceso limitado > 0'
			--select @pCodiEmex, @pCodiEmpr, @pDescripcion, @pGrupo, @pCorrInst, @pSegmento, @pTipo
			select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
			from	(select distinct dp.codi_pers as codi_pers,
									dp.desc_pers as desc_pers,
									isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
									dg.desc_grup as desc_grup,
									dp.codi_grup as codi_grup,
									dp.codi_segm as codi_segm,
									dp.tipo_taxo as tipo_taxo,
								    (select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
					from	dbax_defi_pers dp 
								left join dbax_defi_peho dh 
								on	dh.codi_emex = @pCodiEmex 
								and	dh.codi_empr = @pCodiEmpr 
								and	dp.codi_pers = dh.codi_pers
									left join dbax_defi_grup dg
									on	dg.codi_grup = dp.codi_grup,
							dbax_inst_docu id,
							dbax_exte_pers ep
					where	(dp.codi_pers like '%' + @pDescripcion + '%' 
							or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
							or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
					and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
					and		dp.codi_pers = id.codi_pers
					and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
					and		isnull(dp.empr_vige,'SI') = 'SI'
					and		ep.codi_emex = dh.codi_emex
					and		ep.codi_pers = id.codi_pers) v
			left join dbax_defi_segm ds
				on v.codi_segm = ds.codi_segm
			left join dbax_tipo_taxo tt
				on v.tipo_taxo = tt.tipo_taxo,
			dbax_inst_vers vt
			where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
			and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
			and	vt.codi_pers = v.codi_pers
			and	vt.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
			and	vt.vers_inst >= @vMinVers
			and	vt.vers_inst < @vMaxiVers
			and vt.vers_inst= dbo.FU_AX_getUltimaVersion(vt.codi_pers, vt.corr_inst)
			order by v.desc_pers asc
		end
		else
		begin
			--Select @vMinVers, @vMaxiVers
			Print 'Acceso limitado >= 0'
			--select @pCodiEmex, @pCodiEmpr, @pDescripcion, @pGrupo, @pCorrInst, @pSegmento, @pTipo
			select	v.codi_pers, v.desc_pers, v.desc_peho, v.desc_grup, v.codi_grup, ds.desc_segm, v.codi_segm, v.tipo_taxo, desc_tipo
			from	(select distinct dp.codi_pers as codi_pers,
									dp.desc_pers as desc_pers,
									isnull(dh.desc_empr,dp.desc_pers) as desc_peho,
									dg.desc_grup as desc_grup,
									dp.codi_grup as codi_grup,
									dp.codi_segm as codi_segm,
									dp.tipo_taxo as tipo_taxo,
									(select max(vi.vers_inst) from dbax_inst_vers vi where vi.corr_inst = isnull(@pCorrInst,0) and vi.codi_pers = dp.codi_pers) as vers_inst
					from	dbax_defi_pers dp 
								left join dbax_defi_peho dh 
								on	dh.codi_emex = @pCodiEmex 
								and	dh.codi_empr = @pCodiEmpr 
								and	dp.codi_pers = dh.codi_pers
									left join dbax_defi_grup dg
									on	dg.codi_grup = dp.codi_grup,
							dbax_inst_docu id
					where	(dp.codi_pers like '%' + @pDescripcion + '%' 
							or upper(dh.desc_empr) like '%' + @pDescripcion + '%' 
							or upper(dp.desc_pers) like '%' + @pDescripcion + '%')
					and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
					and		dp.codi_pers = id.codi_pers
					and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
					and		isnull(dp.empr_vige,'SI') = 'SI') v
			left join dbax_defi_segm ds
				on v.codi_segm = ds.codi_segm
			left join dbax_tipo_taxo tt
				on v.tipo_taxo = tt.tipo_taxo,
			dbax_inst_vers vt
			where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
			and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
			and	vt.codi_pers = v.codi_pers
			and	vt.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
			and	vt.vers_inst >= @vMinVers
			and	vt.vers_inst < @vMaxiVers
			and vt.vers_inst= dbo.FU_AX_getUltimaVersion(vt.codi_pers, vt.corr_inst)
			order by v.desc_pers asc
		end
	end
END
GO

ALTER procedure [dbo].[SP_AX_getArchivosPorGrupoSegmento](
@pCodiEmex varchar(30),
@pCodiEmpr numeric (9,0),
@pCorrInst varchar(10),
@pDescripcion varchar(100),
@pGrupo varchar(50),
@pSegmento varchar(50),
@pTipo varchar(10),
@pNombArch varchar(100),
@pTipoArch varchar(10)='Oficial')
as
BEGIN
	/*	
		@pTipoDesc = 'D' se devuelve descripcion "por defecto", 
		@pTipoDesc = 'P' devuelve descripcion por defecto y personalizada
		@pTipoDesc  = 'C' SE DEVUELVE SOLO LAS DE MAS DE UNA VERSIÓN

		@pTipoArch = Oficial significa oficial, Externo = externo (no oficial)
	*/
	declare @vComodinGrup varchar(1)
	declare @vComodinSegm varchar(1)
	declare @vComodinTipo varchar(1)
	declare @vMaxiVers numeric(3,0)
	declare @vMinVers numeric(2,0)
	set @vComodinGrup = '%'
	set @vComodinSegm = '%'
	set @vComodinTipo = '%'

	if ( @pGrupo != '')
	begin
		set @vComodinGrup = ''
	end

	if ( @pSegmento != '')
	begin
		set @vComodinSegm = ''
	end

	if ( @pTipo != '')
	begin
		set @vComodinTipo = ''
	end

	declare @vComodinCorr varchar(1)
	set @vComodinCorr = '%'

	if (@pCorrInst != '')
	begin
		set @vComodinCorr = ''
	end
	if(@pTipoArch='Oficial')
	begin
		set @vMinVers = 0
		set @vMaxiVers = 30
	end
	else
	begin
		set @vMinVers = 30
		set @vMaxiVers = 999
	end

	declare @AccesoLimitado numeric(4,0)
	select @AccesoLimitado = count(*) from dbax_exte_pers where codi_emex = @pCodiEmex

	Print @vMinVers
	Print @vMaxiVers
	Print @AccesoLimitado
	if(@AccesoLimitado > 0)
	--inicio acceso limitado
	begin
		print '@AccesoLimitado > 0'
		if(@pTipoArch = 'Oficial')
		begin
		--Inicio oficial
			select t.codi_pers, t.corr_inst, ia.vers_inst, max(ia.nomb_arch) nomb_arch
			from (select	v.desc_pers, v.codi_pers, v.corr_inst
				 from	(select distinct dp.codi_pers as codi_pers,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										id.corr_inst as corr_inst,
										dp.tipo_taxo as tipo_taxo,
										dp.desc_pers as desc_pers
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id,
								dbax_exte_pers ep
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or dh.desc_empr like '%' + @pDescripcion + '%' 
								or dp.desc_pers like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
						and		isnull(dp.empr_vige,'SI') = 'SI'
						and		ep.codi_emex = dh.codi_emex
						and		ep.codi_pers = id.codi_pers
						) v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo,
				dbax_inst_vers vt
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				and	vt.codi_pers = v.codi_pers
				and	vt.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
				and	vt.vers_inst >= @vMinVers
				and	vt.vers_inst < @vMaxiVers) t
			left join dbax_inst_arch ia
			on	t.codi_pers = ia.codi_pers
			and	t.corr_inst = ia.corr_inst
			and	ia.vers_inst = dbo.FU_AX_getUltimaVersion(ia.codi_pers, ia.corr_inst)
			and	ia.nomb_arch like @pNombArch + '%'
			group by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
			order by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
		end
		--fin oficial
		else
		--inicio externo
		begin
			select t.codi_pers, t.corr_inst, ia.vers_inst, max(ia.nomb_arch) nomb_arch
			from (select	v.desc_pers, v.codi_pers, v.corr_inst
				 from	(select distinct dp.codi_pers as codi_pers,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										id.corr_inst as corr_inst,
										dp.tipo_taxo as tipo_taxo,
										dp.desc_pers as desc_pers
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id,
								dbax_exte_pers ep
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or dh.desc_empr like '%' + @pDescripcion + '%' 
								or dp.desc_pers like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
						and		isnull(dp.empr_vige,'SI') = 'SI'
						and		ep.codi_emex = dh.codi_emex
						and		ep.codi_pers = id.codi_pers
						) v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo,
				dbax_inst_vers vt
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				and	vt.codi_pers = v.codi_pers
				and	vt.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
				and	vt.vers_inst >= @vMinVers
				and	vt.vers_inst < @vMaxiVers) t
			left join dbax_inst_arch ia
			on	t.codi_pers = ia.codi_pers
			and	t.corr_inst = ia.corr_inst
			and	ia.vers_inst = dbo.FU_AX_getUltimaVersionExterna(ia.codi_pers, ia.corr_inst,@vMinVers,@vMaxiVers)
			and	ia.nomb_arch like @pNombArch + '%'
			group by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
			order by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
		end
		--fin externo
	end
	--Fin acceso limitado
	else
	begin
	--inicio accceso ilimitado
		if(@pTipoArch = 'Oficial')
		begin
print 'Ilimitado'
		--Inicio oficial
			select t.codi_pers, t.corr_inst, ia.vers_inst, max(ia.nomb_arch) nomb_arch
			from (select	v.desc_pers, v.codi_pers, v.corr_inst
				 from	(select distinct dp.codi_pers as codi_pers,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										id.corr_inst as corr_inst,
										dp.tipo_taxo as tipo_taxo,
										dp.desc_pers as desc_pers
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or dh.desc_empr like '%' + @pDescripcion + '%' 
								or dp.desc_pers like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
						and		isnull(dp.empr_vige,'SI') = 'SI'
						) v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo,
				dbax_inst_vers vt
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				and	vt.codi_pers = v.codi_pers
				and	vt.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
				and	vt.vers_inst >= @vMinVers
				and	vt.vers_inst < @vMaxiVers) t
			left join dbax_inst_arch ia
			on	t.codi_pers = ia.codi_pers
			and	t.corr_inst = ia.corr_inst
			and	ia.vers_inst = dbo.FU_AX_getUltimaVersion(ia.codi_pers, ia.corr_inst)
			and	ia.nomb_arch like @pNombArch + '%'
			group by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
			order by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
		end
		--Fin oficial
		else
		--Inicio externo
		begin
			select t.codi_pers, t.corr_inst, ia.vers_inst, max(ia.nomb_arch) nomb_arch
			from (select	v.desc_pers, v.codi_pers, v.corr_inst
				 from	(select distinct dp.codi_pers as codi_pers,
										dg.desc_grup as desc_grup,
										dp.codi_grup as codi_grup,
										dp.codi_segm as codi_segm,
										id.corr_inst as corr_inst,
										dp.tipo_taxo as tipo_taxo,
										dp.desc_pers as desc_pers
						from	dbax_defi_pers dp 
									left join dbax_defi_peho dh 
									on	dh.codi_emex = @pCodiEmex 
									and	dh.codi_empr = @pCodiEmpr 
									and	dp.codi_pers = dh.codi_pers
										left join dbax_defi_grup dg
										on	dg.codi_grup = dp.codi_grup,
								dbax_inst_docu id
						where	(dp.codi_pers like '%' + @pDescripcion + '%' 
								or dh.desc_empr like '%' + @pDescripcion + '%' 
								or dp.desc_pers like '%' + @pDescripcion + '%')
						and		isnull(dp.codi_grup,'') like @vComodinGrup + @pGrupo + @vComodinGrup
						and		dp.codi_pers = id.codi_pers
						and		id.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
						and		isnull(dp.empr_vige,'SI') = 'SI'
						) v
				left join dbax_defi_segm ds
					on v.codi_segm = ds.codi_segm
				left join dbax_tipo_taxo tt
					on v.tipo_taxo = tt.tipo_taxo,
				dbax_inst_vers vt
				where isnull(v.codi_segm,'') like @vComodinSegm + @pSegmento + @vComodinSegm
				and	isnull(v.tipo_taxo,'') like @vComodinTipo + @pTipo + @vComodinTipo
				and	vt.codi_pers = v.codi_pers
				and	vt.corr_inst like @vComodinCorr + @pCorrInst + @vComodinCorr
				and	vt.vers_inst >= @vMinVers
				and	vt.vers_inst < @vMaxiVers) t
			left join dbax_inst_arch ia
			on	t.codi_pers = ia.codi_pers
			and	t.corr_inst = ia.corr_inst
			and	ia.vers_inst = dbo.FU_AX_getUltimaVersionExterna(ia.codi_pers, ia.corr_inst,@vMinVers,@vMaxiVers)
			and	ia.nomb_arch like @pNombArch + '%'
			group by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
			order by t.desc_pers, t.codi_pers, t.corr_inst, ia.vers_inst
		end
		--Fin externo
	end
	--fin accceso ilimitado
END
GO

delete from dbax_dime_conc where codi_conc like '%ñ%'

insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe90DiasHasta1AñoPrestamosNominales','cl-ci',19,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe1AñoHasta3AñosPrestamosNominales','cl-ci',20,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe3AñosHasta5AñosPrestamosNominales','cl-ci',21,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe5AñosPrestamosNominales','cl-ci',22,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','Masde90DiasHasta1AñoPrestamosContable','cl-ci',27,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe1AñoHasta3AñosPrestamosContable','cl-ci',29,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe3AñosHasta5AñosPrestamosContable','cl-ci',30,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe5AñosPrestamosContable','cl-ci',31,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe90DiasHasta1AñoLeasingNominales','cl-ci',48,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe1AñoHasta3AñosLeasingNominales','cl-ci',49,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe3AñosHasta5AñosLeasingNominales','cl-ci',50,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe5AñosLeasingNominales','cl-ci',51,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','Masde90DiasHasta1AñoLeasingContable','cl-ci',56,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe1AñoHasta3AñosLeasingContable','cl-ci',58,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe3AñosHasta5AñosLeasingContable','cl-ci',59,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe5AñosLeasingContable','cl-ci',60,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe90DiasHasta1AñoObligacionesPublicoNominales','cl-ci',79,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe1AñoHasta3AñosObligacionesPublicoNominales','cl-ci',80,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe3AñosHasta5AñosObligacionesPublicoNominales','cl-ci',81,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe5AñosObligacionesPublicoNominales','cl-ci',82,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','Masde90DiasHasta1AñoObligacionesPublicoContable','cl-ci',87,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe1AñoHasta3AñosObligacionesPublicoContable','cl-ci',89,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe3AñosHasta5AñosObligacionesPublicoContable','cl-ci',90,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2011-03-25_role-822400','MasDe5AñosObligacionesPublicoContable','cl-ci',91,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe90DiasHasta1AñoPrestamosNominales','cl-ci',180,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe1AñoHasta3AñosPrestamosNominales','cl-ci',190,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe3AñosHasta5AñosPrestamosNominales','cl-ci',200,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe5AñosPrestamosNominales','cl-ci',210,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','Masde90DiasHasta1AñoPrestamosContable','cl-ci',260,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe1AñoHasta3AñosPrestamosContable','cl-ci',280,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe3AñosHasta5AñosPrestamosContable','cl-ci',290,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe5AñosPrestamosContable','cl-ci',300,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe90DiasHasta1AñoLeasingNominales','cl-ci',470,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe1AñoHasta3AñosLeasingNominales','cl-ci',480,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe3AñosHasta5AñosLeasingNominales','cl-ci',490,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe5AñosLeasingNominales','cl-ci',500,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','Masde90DiasHasta1AñoLeasingContable','cl-ci',550,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe1AñoHasta3AñosLeasingContable','cl-ci',570,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe3AñosHasta5AñosLeasingContable','cl-ci',580,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe5AñosLeasingContable','cl-ci',590,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe90DiasHasta1AñoObligacionesPublicoNominales','cl-ci',780,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe1AñoHasta3AñosObligacionesPublicoNominales','cl-ci',790,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe3AñosHasta5AñosObligacionesPublicoNominales','cl-ci',800,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe5AñosObligacionesPublicoNominales','cl-ci',810,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','Masde90DiasHasta1AñoObligacionesPublicoContable','cl-ci',860,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe1AñoHasta3AñosObligacionesPublicoContable','cl-ci',880,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe3AñosHasta5AñosObligacionesPublicoContable','cl-ci',890,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400','MasDe5AñosObligacionesPublicoContable','cl-ci',900,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe90DiasHasta1AñoPrestamosNominales','cl-ci',180,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe1AñoHasta3AñosPrestamosNominales','cl-ci',190,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe3AñosHasta5AñosPrestamosNominales','cl-ci',200,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe5AñosPrestamosNominales','cl-ci',210,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','Masde90DiasHasta1AñoPrestamosContable','cl-ci',260,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe1AñoHasta3AñosPrestamosContable','cl-ci',280,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe3AñosHasta5AñosPrestamosContable','cl-ci',290,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe5AñosPrestamosContable','cl-ci',300,'PrestamosBancariosTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe90DiasHasta1AñoLeasingNominales','cl-ci',470,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe1AñoHasta3AñosLeasingNominales','cl-ci',480,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe3AñosHasta5AñosLeasingNominales','cl-ci',490,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe5AñosLeasingNominales','cl-ci',500,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','Masde90DiasHasta1AñoLeasingContable','cl-ci',550,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe1AñoHasta3AñosLeasingContable','cl-ci',570,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe3AñosHasta5AñosLeasingContable','cl-ci',580,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe5AñosLeasingContable','cl-ci',590,'ObligacionesLeasingTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe90DiasHasta1AñoObligacionesPublicoNominales','cl-ci',780,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe1AñoHasta3AñosObligacionesPublicoNominales','cl-ci',790,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe3AñosHasta5AñosObligacionesPublicoNominales','cl-ci',800,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe5AñosObligacionesPublicoNominales','cl-ci',810,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','Masde90DiasHasta1AñoObligacionesPublicoContable','cl-ci',860,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe1AñoHasta3AñosObligacionesPublicoContable','cl-ci',880,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe3AñosHasta5AñosObligacionesPublicoContable','cl-ci',890,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-ci_ifrs-7_2012-03-29_role-822400(2013)','MasDe5AñosObligacionesPublicoContable','cl-ci',900,'ObligacionesConPublicoTabla','cl-ci','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_cuadro-607_role-906072(2013)','PrimaPrimerAñoSinopsis','cl-cs',140,'CuadroPrimasTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_cuadro-607_role-906072(2013)','PrimaPrimerAñoDirecta','cl-cs',150,'CuadroPrimasTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_cuadro-607_role-906072(2013)','PrimaPrimerAñoAceptada','cl-cs',160,'CuadroPrimasTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_cuadro-607_role-906072(2013)','PrimaPrimerAñoCedida','cl-cs',170,'CuadroPrimasTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_cuadro-607_role-906072(2013)','PrimaPrimerAñoNeta','cl-cs',180,'CuadroPrimasTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-13_role-825000(2013)','CustodiaEnCompañiaSinopsis','cl-cs',680,'InformacionCarteraInversionesTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-13_role-825000(2013)','InversionesCustodiadasEnCompañia','cl-cs',690,'InformacionCarteraInversionesTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-13_role-825000(2013)','PorcentajeInversionesCustodiadasEnCompañiaRespectoTotalInversiones','cl-cs',700,'InformacionCarteraInversionesTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-14_role-826000(2013)','TerminoContratoLeasingHasta1Año','cl-cs',370,'AñosRemanentesContratoLeasingTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-14_role-826000(2013)','TerminoContratoLeasingEntre1Y5Años','cl-cs',380,'AñosRemanentesContratoLeasingTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-14_role-826000(2013)','TerminoContratoLeasingSuperior5Años','cl-cs',390,'AñosRemanentesContratoLeasingTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-21_role-834000(2013)','ProvisionIndemnizacionAñosDeServicio','cl-cs',410,'EfectoImpuestosDiferidosEnPatrimonioYEnResultadosTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-25_role-838200(2013)','ReservaInvalidezCompañia','cl-cs',2220,'InvalidezSinPrimerDictamenTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-25_role-838200(2013)','ReservaInvalidezCompañiaPesos','cl-cs',2221,'InvalidezSinPrimerDictamenTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-25_role-838200(2013)','ReservaInvalidezTransitoriaCompañia','cl-cs',2340,'InvalidosTransitoriosTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-25_role-838200(2013)','ReservaInvalidezTransitoriaCompañiaPesos','cl-cs',2341,'InvalidosTransitoriosTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-25_role-838200(2013)','ReservaInvalidezParcialTransitoriaCompañia','cl-cs',2600,'InvalidosParcialesTransitoriosConSolicitudTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-25_role-838200(2013)','ReservaInvalidezParcialTransitoriaCompañiaPesos','cl-cs',2601,'InvalidosParcialesTransitoriosConSolicitudTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-25_role-838200(2013)','AporteAdicionalCompañiaInvalidosTransitoriosFallecidos','cl-cs',2710,'InvalidosTransitoriosFallecidosTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-46_role-862100(2013)','PromedioSiniestrosUltimosTresAños','cl-cs',440,'SiniestrosUltimosTresAñosTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-46_role-862100(2013)','CostoSiniestrosDirectosUltimosTresAños','cl-cs',450,'SiniestrosUltimosTresAñosTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-46_role-862100(2013)','CostoSiniestrosAceptadosUltimosTresAñosSiniestrosUltimosTresAños','cl-cs',500,'SiniestrosUltimosTresAñosTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-46_role-862100(2013)','FRPrimasCompañiaResumen','cl-cs',700,'MargenSolvenciaGeneralesTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-46_role-862100(2013)','FRSiniestrosCompañiaResumen','cl-cs',760,'MargenSolvenciaGeneralesTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-46_role-862200(2013)','FRPrimaCompañiaSegurosAccidentesSaludYAdicionales','cl-cs',540,'SegAccidentesSaludYAdicionalesTabla','cl-cs','')
insert into dbax_dime_conc (codi_dein, codi_conc, pref_conc, orde_conc, codi_dime, pref_dime, sald_ini) values ('pre_cl-cs_nota-46_role-862200(2013)','FRSiniestrosCompañiaSegurosAccidentesSaludYAdicionales','cl-cs',600,'SegAccidentesSaludYAdicionalesTabla','cl-cs','')

delete dbax_info_conc 
from dbax_info_conc ic, dbax_dime_memb dm
where ic.pref_conc = dm.pref_memb
and ic.codi_conc = dm.codi_memb

select count(*) from dbax_info_conc
delete dbax_info_conc 
from dbax_info_conc ic, dbax_dime_axis da
where ic.pref_conc = da.pref_axis
and ic.codi_conc = da.codi_axis
select count(*) from dbax_info_conc