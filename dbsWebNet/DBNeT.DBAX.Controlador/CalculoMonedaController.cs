using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.DBAX.Modelo.DAC;

namespace DBNeT.DBAX.Controlador
{
    public class CalculoMonedaController
    {
        CalculoMonedaDAC _goCalcMoneDAC;
        public CalculoMonedaController()
        { _goCalcMoneDAC = new CalculoMonedaDAC(); }

        public DataTable getPersCorrInst(string ts_codi_pers)
        { return _goCalcMoneDAC.getPersCorrInst(ts_codi_pers); }

        public void prc_create_calc_mone(string ts_nomb_bin, string ts_corr_inst, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        { _goCalcMoneDAC.prc_create_calc_mone(ts_nomb_bin, ts_corr_inst, ts_codi_usua,tn_codi_empr,ts_codi_emex); }
    }
}