using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace dbax.InserXBRLUsua
{
    class Program
    {
        static void Main(string[] args)
        {
            string pCodiUsua, pCodiEmex, pCodiEmpr, pRutaTemp, pNombzip, pIFRS13, pDbgxEmpr, pDbgxCorr, pDbgxVers;
            if (args.Length != 6 && args.Length != 9)
            {
                Console.WriteLine("Numero incorrecto de parámetros, se informaron " + args.Length);
                Log.putLog("Numero incorrecto de parametros");
                foreach (string parametro in args)
                {
                    Console.WriteLine(parametro);
                }
                Environment.Exit(-1);
            }

            pCodiEmex = args[0];
            pCodiEmpr = args[1];
            pCodiUsua = args[2];
            pRutaTemp = args[3];
            pNombzip = args[4]; //Directorio donde está el XBRL
            pIFRS13 = args[5]; //
            pDbgxEmpr = "";
            pDbgxCorr = "";
            pDbgxVers = "";

            if (args.Length == 9)
            {
                pDbgxEmpr = args[6];
                pDbgxCorr = args[7];
                pDbgxVers = args[8];
            }

            Log.putLog("Inicio proceso de carga");
            GuardarXBRL vXBRL = new GuardarXBRL();

            string pRutaTemppDireXbrl = ""; //ME entrega el directorio donde queda descomprimido el XBRL o me devuelve 1 en caso que no tenga permisos
            pRutaTemppDireXbrl = vXBRL.ValidaPermisoXBRLExte(pCodiEmex, pCodiEmpr, pCodiUsua, pRutaTemp, pNombzip);

            if (pRutaTemppDireXbrl.Count() == 1)
            {
                Log.putLog("No se pudo cargar " + pNombzip + " pues usuario " + pCodiUsua + " no tiene permisos para esa empresa");
            }
            else
            {
                vXBRL.CargaXBRLUsuario(pCodiEmex, pCodiEmpr, pCodiUsua, pRutaTemppDireXbrl, pIFRS13, pDbgxEmpr, pDbgxCorr, pDbgxVers);
            }

            Log.putLog("Fin proceso de carga");
        }
    }
}
