using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Xml;
using System.IO;

namespace GeneradorScript
{
    class Program
    {
        
        static void Main(string[] args)
        {
            GeneracionExcel gene = new GeneracionExcel();

            Console.WriteLine(System.DateTime.Now);

            Console.WriteLine("Ingrese el período a extraer");
            string periodo = Console.ReadLine();

            Console.WriteLine("Ingrese la versión  a extraer");
            string version = Console.ReadLine();
            
            DataTable dtP = gene.GetPersArch(periodo,  version).Tables[0]; // extraigo las empresas

            foreach (DataRow drFila in dtP.Rows)
            {
                string persona = drFila["codi_pers"].ToString();

                DataTable dt = gene.GetArchXBRL(persona, periodo, version).Tables[0];
              gene.GeneArchivo(dt);

            }
           // Console.WriteLine("Se escribieron " + i + " lineas");
            Console.WriteLine(System.DateTime.Now);
            Console.ReadLine();

        }
    }
}
