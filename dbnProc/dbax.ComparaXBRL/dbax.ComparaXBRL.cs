using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace dbax.ComparaXBRL
{
    class Program
    {
        static void Main(string[] args)
        {
            MantencionParametros Para = new MantencionParametros();
            GuardarXBRL vXBRL = new GuardarXBRL();

            bool bEliminarCarpeta = true;
            bool bForzarCarga = false;

            if (args.Count() == 2)
            {
                bEliminarCarpeta = args[0] == "1" ? true : false;
                bForzarCarga = args[1] == "1" ?  true : false;
            }
         
            Para.SP_AX_insEstadoBarra("Proc", "Ejecutando carga de XBRL", "N");
            Log.putLog("Inicio proceso de carga");

            vXBRL.CargaXBRLCorregida(bEliminarCarpeta, bForzarCarga);
            //vXBRL.RescataXBRLCargaInformes("201409", "765908401");
            Log.putLog("Fin proceso de carga");
            Para.SP_AX_insEstadoBarra("OK", "Fin de carga de XBRL", "S");
            
        }
    }
}
