declare @vCodiPers varchar(256)
declare @vCorrInst varchar(256)

set @vCorrInst = 201606 --Periodo

/*
use dbax_central
	delete 
	from	dbax_tras_usua 
	where	1=1
	and	codi_usua = 'DBNET' 
	and codi_arch in(
						select	codi_arch 
						from	dbax_tras_arch 
						where	codi_taxo = 'CL-CS'
						and		path_arch like @vCorrInst + '%' + @vCorrInst + '%'
						/*and		(
								path_arch like '%' + '966123101' + '%'
								or path_arch like '%' + '992250001' + '%'
								or path_arch like '%' + '968316901' + '%'
								or path_arch like '%' + '990030002' + '%'
								)*/
					)
*/
--use dbax 
	declare curEmpresas cursor for
		select	id.codi_pers 
		from	dbax_inst_docu id, dbax_defi_pers dp 
		where	1=1
		and		(	   dp.codi_pers = '890907157' 
					--or dp.codi_pers = '99543100'
					--or dp.codi_pers = '96980650'
					--or dp.codi_pers = '96872980'
					--or dp.codi_pers = '96513630'
					--or dp.codi_pers = '76551925'
					--or dp.codi_pers = '76503272'
					--or dp.codi_pers = '76122579'
					--or dp.codi_pers = '76048177'
					--or dp.codi_pers = '96579410'
					--or dp.codi_pers = '96966250'
					--or dp.codi_pers = '96804330'
					--or dp.codi_pers = '96912880'
					--or dp.codi_pers = '99549940'
					--or dp.codi_pers = '96591040'
				)
		--and		dp.tipo_taxo = 'COME_INDU'
		and		id.codi_pers = dp.codi_pers
		and		id.corr_inst = 201606

	open curEmpresas
	fetch next from curEmpresas into @vCodiPers
	while @@fetch_status = 0
	begin
		print @vCodiPers
		exec SP_AX_delInstDocu @vCodiPers, @vCorrInst
		fetch next from curEmpresas into @vCodiPers
	end
	close curEmpresas
	deallocate curEmpresas