using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class ValoresActualizadosDAC : BaseDAC
    {
        public ValoresActualizadosDAC()
        { }

        public void create_dbax_calc_actu(string tsNombBin, string tsCodiUsua, string tsCodiArgs, string tsCodiEmex, int tsCodiEmpr)
        {
            try
            {
                OpenConnection();
                CreateCommand("prc_create_exec_bin");
                AddCommandParamIN("p_nomb_bin", CmdParamType.StringVarLen, 128, tsNombBin);
                AddCommandParamIN("p_corr_inst", CmdParamType.StringVarLen, 30, "");
                AddCommandParamIN("p_codi_usua", CmdParamType.StringVarLen, 30, tsCodiUsua);
                AddCommandParamIN("p_codi_empr", CmdParamType.Integer, tsCodiEmpr);
                AddCommandParamIN("p_codi_emex", CmdParamType.StringVarLen, 30, tsCodiEmex);
                AddCommandParamIN("p_codi_args", CmdParamType.StringVarLen, 512, tsCodiArgs);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }
    }
}
