using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.DBAX.Modelo.DAC;
using DBNeT.Framework.Conector;

namespace DBNeT.DBAX.Controlador
{
    public class dbax_dbne_procController : BaseDAC
    {
        dbax_dbne_proc _goDbaxDbneProc;
        public dbax_dbne_procController()
        {_goDbaxDbneProc = new dbax_dbne_proc();}
        public void prc_create_dbne_proc(string ts_nomb_bin, string ts_nomb_args, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex, string proc)
        {_goDbaxDbneProc.prc_create_dbne_proc(ts_nomb_bin, ts_nomb_args, ts_codi_usua, tn_codi_empr, ts_codi_emex, proc);}
    }
}
