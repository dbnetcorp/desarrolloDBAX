declare @vCodiPers varchar(256)
declare @vCorrInst varchar(256)

set @vCorrInst = 201312 --Periodo

use dbax_central
	delete 
	from	dbax_tras_usua 
	where	1=1
	and	codi_usua = 'AACH' 
	and codi_arch in(
						select	codi_arch 
						from	dbax_tras_arch 
						where	1=1
						--and		codi_taxo = 'CL-CS'
						and		path_arch like @vCorrInst + '%' + @vCorrInst + '%'
						/*and		(
								path_arch like '%' + '966123101' + '%'
								or path_arch like '%' + '992250001' + '%'
								or path_arch like '%' + '968316901' + '%'
								or path_arch like '%' + '990030002' + '%'
								)*/
					)


use dbax
	declare curEmpresas cursor for
		select	id.codi_pers 
		from	dbax_inst_docu id, dbax_defi_pers dp 
		where	1=1
		/*and		(	dp.codi_pers = '966123101' 
					or dp.codi_pers = '992250001'
					or dp.codi_pers = '968316901'
					or dp.codi_pers = '990030002'
				)*/
		--and		dp.tipo_taxo = 'COME_INDU'
		and		id.codi_pers = dp.codi_pers
		and		id.corr_inst = @vCorrInst

	open curEmpresas
	fetch next from curEmpresas into @vCodiPers
	while @@fetch_status = 0
	begin
		exec SP_AX_delInstDocu @vCodiPers, @vCorrInst
		fetch next from curEmpresas into @vCodiPers
	end
	close curEmpresas
	deallocate curEmpresas