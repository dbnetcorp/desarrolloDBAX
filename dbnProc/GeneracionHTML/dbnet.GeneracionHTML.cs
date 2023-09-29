using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Data;


namespace GeneracionHTML
{
    class Program
    {
        
        static void Main(string[] args)
        {

            GeneracionExcel GenExcel = new GeneracionExcel();
            string pCodiEmex = "1";
            string pCodiEmpr = "1";
            string pCorrInst = "201206";
            string pVersInst = "1";

            DataTable dt_Empresas = GenExcel.GetEmpresas(pCodiEmex, pCodiEmpr, "","Todos").Tables[0];
            string horaInicio = System.DateTime.Now.ToString();

            Console.WriteLine(horaInicio);
            for (int i = 0; i < dt_Empresas.Rows.Count; i++)
            {
                DataTable dt_Informes = GenExcel.getInformesUsables(pCodiEmex, pCodiEmpr, dt_Empresas.Rows[i]["codi_pers"].ToString(), pCorrInst, pVersInst,"");
                Console.WriteLine("Procesando empresa: " + dt_Empresas.Rows[i]["desc_pers"].ToString());
                for (int j = 0; j < dt_Informes.Rows.Count; j++)
                {
                    Console.WriteLine("Procesando informe: " + dt_Informes.Rows[j]["desc_info"].ToString());
                    //string sRutaXML = @"C:\DBNeT\DBAX\dbsWebNet\Website\dbnet.dbax\librerias\sheets\" + dt_Informes.Rows[j]["codi_info"].ToString() + ".html";
                    string sRutaXML = @"C:\DBNeT\DBAX\dbsWebNet\Website\dbnet.dbax\librerias\sheets\" + dt_Informes.Rows[j]["codi_info"].ToString() + "_" + dt_Empresas.Rows[i]["codi_pers"].ToString() + "_" + pCorrInst + "_" + pVersInst+ ".html";
                    string sRutaXML2 = "librerias\\sheets\\" + dt_Informes.Rows[j]["codi_info"].ToString() + ".html";

                    DataTable dt_DescConc = GenExcel.getDatosReporte(pCodiEmex, pCodiEmpr, dt_Empresas.Rows[i]["codi_pers"].ToString(), pCorrInst, pVersInst, dt_Informes.Rows[j]["codi_info"].ToString());
                    GenExcel.GeneradorHTML(sRutaXML, dt_DescConc, dt_Informes.Rows[j]["codi_info"].ToString());
                }
            }
            string horaFin = System.DateTime.Now.ToString();
            Console.WriteLine(horaInicio + "----  " + horaFin);
        }
    }
}
