using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class CalculoMonedaDAC : BaseDAC
    {
        public CalculoMonedaDAC() { }

        public DataTable getPersCorrInst(string ts_codi_pers)
        {
            try
            {
                OpenConnection();
                CreateCommand("SP_AX_getPersCorrInst");
                AddCommandParamIN("pCodiPers", CmdParamType.StringVarLen, 16, ts_codi_pers);
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { throw ex; }
        }

        public void prc_create_calc_mone(string ts_nomb_bin, string ts_nomb_args, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            try
            {
                OpenConnection();
                CreateCommand("prc_create_exec_bin");
                AddCommandParamIN("p_nomb_bin", CmdParamType.StringVarLen, 128, ts_nomb_bin);
                AddCommandParamIN("p_corr_inst", CmdParamType.StringVarLen, 30, ts_nomb_args);
                AddCommandParamIN("p_codi_usua", CmdParamType.StringVarLen, 30, ts_codi_usua);
                AddCommandParamIN("p_codi_empr", CmdParamType.Integer,tn_codi_empr);
                AddCommandParamIN("p_codi_emex", CmdParamType.StringVarLen, 30, ts_codi_emex);
                AddCommandParamIN("p_codi_args", CmdParamType.StringVarLen, 512, "mone");
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
        }

    }
}
