using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Data;
using System.Data.OleDb;

namespace dbax.CuentaXBRL
{
    class Program
    {
        static string pCorrInst = "";
        static string pRutaSpider = "";

        static void Main(string[] args)
        {
            try
            {
                if (args.Count() != 2)
                {
                    Console.WriteLine("Número incorrecto de parámetros");
                    Environment.Exit(-1);
                }
                else
                {
                    pRutaSpider = args[0];
                    pCorrInst = args[1];
                }

                if (pRutaSpider.Substring(pRutaSpider.Length - 1, 1) != "\\")
                    pRutaSpider = pRutaSpider + "\\";

                //Valido directorio
                if (!Directory.Exists(pRutaSpider + "SVS" + pCorrInst))
                {
                    Console.WriteLine("No existe ruta " + pRutaSpider + "SVS" + pCorrInst);
                    Environment.Exit(-1);
                }

                //Valido base de datos
                if (!File.Exists(pRutaSpider + "SVS" + pCorrInst + "\\Xbrl" + pCorrInst + ".MDB"))
                {
                    Console.WriteLine("No existe DB de Bot: " + pRutaSpider + "SVS" + pCorrInst + "\\Xbrl" + pCorrInst + ".MDB");
                    Environment.Exit(-1);
                }
                GuardarXBRL vXBRL = new GuardarXBRL();
                string strAccessConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + pRutaSpider + "SVS" + pCorrInst + "\\Xbrl" + pCorrInst + ".MDB";
                OleDbConnection myAccessConn = new OleDbConnection(strAccessConn);

                OleDbCommand myAccessCommand = new OleDbCommand("Select * from table1", myAccessConn);
                OleDbDataAdapter myDataAdapter = new OleDbDataAdapter(myAccessCommand);

                myAccessConn.Open();
                DataTable tCantXbrl = new DataTable();
                myDataAdapter.Fill(tCantXbrl);

                //string vCantXbrl = tCantXbrl.Select("estdo_xbrl<>''").Count().ToString();
                //Console.WriteLine(vCantXbrl.ToString());
                vXBRL.insCantidadXbrlReportados(pCorrInst, "0");
                vXBRL.insLinksXbrlReportados(pCorrInst, tCantXbrl);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Console.WriteLine(ex.StackTrace.ToString());
                Environment.Exit(-1);
            }
            
        }
    }
}
