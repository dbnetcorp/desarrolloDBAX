using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.IO;
using System.Xml;
using DbnetWebLibrary;

namespace dbax.ExpoData
{
    class Program
    {
        [System.Runtime.InteropServices.DllImport("Kernel32")]
        private static extern bool SetConsoleCtrlHandler(EventHandler handler, bool add);

        private delegate bool EventHandler(CtrlType sig);
        static EventHandler _handler;

        private static string nombreArc;
        private static string id_sem;
        private static bool indiEncabezado = true;
        private static bool indiArchivo = true;

        enum CtrlType
        {
            CTRL_C_EVENT = 0,
            CTRL_BREAK_EVENT = 1,
            CTRL_CLOSE_EVENT = 2,
            CTRL_LOGOFF_EVENT = 5,
            CTRL_SHUTDOWN_EVENT = 6,
            CTRL_SHUTDOWN_FORCE = -532462766
        }
        
        static void Main(string[] args)
        {
            _handler += new EventHandler(Handler);
            SetConsoleCtrlHandler(_handler, true);
            
            //string texto = "";
            DateTime localDate = DateTime.Now;
            
            Log.putLog("[" + localDate.ToString() + "] Comenzamos el proceso expoData. ");
            System.Threading.Thread.Sleep(5000);

            //Habilitar para realizar pruebas
            //args = new string[] { "pre_cl-cs_cuadro-604_role-906042(2015)", "990120002", "201609", @"C:\DBNeT\DBAX\dbnProc\dbax.ExpoData", "dbax", "108641" };
            
            //Validamos los parámetros 
            if (6 != args.Length)
            {
                Log.putLog("[" + localDate.ToString() + "] Cantidad de argumentos no corresponde " + Environment.NewLine);
                System.Threading.Thread.Sleep(3000);
                Environment.Exit(0);
            }

            String codiInfo  = args[0].ToString();
            String codiEmpr  = args[1].ToString();
            String corrInst  = args[2].ToString();
            String archivo   = args[3].ToString();
            String codi_usua = args[4].ToString();
            String id_sema   = args[5].ToString();

            //Asignamos el nombre
            id_sem = id_sema;
            string fechaNombre = localDate.Day.ToString("00") + localDate.Month.ToString("00") + localDate.Year.ToString("0000");
            string nombre_archivo = id_sem + fechaNombre + ".txt";
            string archivo_carga = archivo.ToString() + "/" + nombre_archivo;
            nombreArc = archivo_carga;

            //Recepcionamos los argumentos
            Log.putLog("[" + localDate.ToString() + "] Recepcionamos los argumentos.");
            Log.putLog("[" + localDate.ToString() + "] codiInfo: " + codiEmpr);
            Log.putLog("[" + localDate.ToString() + "] codiEmpr: " + codiInfo);
            Log.putLog("[" + localDate.ToString() + "] corrInst: " + corrInst);

            List<string> periodos = agrupar(corrInst, 2);
            List<string> empresas = agrupar(codiEmpr, 1);
            List<string> informes = agrupar(codiInfo, 2);

            int total = 0;

            foreach (string periodo in periodos)
            {
                foreach (string empresa in empresas)
                {
                    foreach (string infor in informes)
                    {
                        total += pedirDatos(localDate.ToString(), empresa, infor, periodo, id_sem);
                    }

                }

            }
            
            if (total == 0)
            {
                actualizarSemaforo("<!--expoData--><label CssClass=\"lblIzquierdo\"><img src=\"../librerias/img/rojo.png\" />Proceso concluido, sin datos para los parámetros seleccionados.</label>", localDate.ToString(), id_sem);
                Log.putLog("[" + localDate.ToString() + "] Proceso terminado en semaforo rojo: Sin registros!");
            }
            else
            {
                //Si sale OK pasa a verde
                Console.WriteLine("Fin de ejecución, todo OK \n");
                actualizarSemaforo("<!--expoData_" + nombre_archivo + "--><label CssClass=\"lblIzquierdo\"><img src=\"../librerias/img/verde.png\" />Proceso " + id_sem + " concluido correctamente.</label>", localDate.ToString(), id_sem, '1');
            }

            //Escribimos el log
            Log.putLog("[" + localDate.ToString() + "] Cantidad de datos extraidos: " + total + Environment.NewLine);
            System.Threading.Thread.Sleep(5000);

        }

        static List<string> agrupar(string elementos, int cant)
        {
            string[]     listado      = elementos.Split(',');
            List<string> pre_agrupado = new List<string>();
            List<string> grupos       = new List<string>();

            int cont = 0;
            foreach (string list_item in listado)
            {
                pre_agrupado.Add(list_item);
                cont++;

                if (pre_agrupado.Count() == cant)
                {
                    grupos.Add(string.Join(",", pre_agrupado));
                    pre_agrupado.RemoveRange(0, pre_agrupado.Count());
                }
            }

            //En el caso de que la cantidad de filtros sea menor a la de base
            if (pre_agrupado.Count() > 0)
            {
                grupos.Add(string.Join(",", pre_agrupado));
            }

            return grupos;

        }

        static int pedirDatos(String fecha, string empresas2, string informes2, string periodos2, String id_sem)
        {
            try
            {
                Log.putLog("[" + fecha + "] Filtros añadidos, comienzo de ejecución parcial.");
                Log.putLog("[" + fecha + "] Filtros empresas: " + empresas2);
                Log.putLog("[" + fecha + "] Filtros informes: " + informes2);
                Log.putLog("[" + fecha + "] Filtros periodos: " + periodos2);

                string texto = "";
                int total = 0;

                DataTable datos = ejecutarConsulta("exec dbo.SP_AX_ExpoData '" + empresas2 + "', '" + informes2 + "','" + periodos2 + "'", id_sem);

                //Escribimos el archivo
                foreach (DataRow row in datos.Rows)
                {
                    if (indiEncabezado)
                    {
                        foreach (DataColumn c in row.Table.Columns)
                        {
                            texto += c.ColumnName + ";";
                        }
                        texto += Environment.NewLine;
                        indiEncabezado = false;
                    }
                    texto += string.Join(";", row.ItemArray).Replace("Ã³","ó") + Environment.NewLine;
                    total++;
                }

                if (total > 0)
                {
                    if (indiArchivo)
                    { 
                        File.WriteAllText(nombreArc, texto, Encoding.GetEncoding("ISO-8859-1"));
                        indiArchivo = false;
                    }
                    else
                    {
                        File.AppendAllText(nombreArc, texto);
                    }
                }

                Log.putLog("[" + fecha + "] Fin de ejecución parcial, total registros añadidos: " + total);
                return total;
            }
            catch (Exception e)
            {
                Log.putLog("[" + fecha + "] " + e.Message);
                Console.WriteLine(e.Message);
                return 0;
            }
        }

        static DataTable ejecutarConsulta(String sql, String id_sem=null)
        {
            string strcon = devuelveCon();
            //Log.putLog("expoData consulta: " + sql);

            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                        SqlDataAdapter ada = new SqlDataAdapter(sql, con);
                        ada.SelectCommand.CommandTimeout = 1500000;
                        DataTable ds = new DataTable();
                        ada.Fill(ds);
                        con.Close();

                        return ds;

                    }
                }

            }
            catch (SqlException ex)
            {
                //Escribimos el log
                DateTime localDate = DateTime.Now;
                if (id_sem != null)
                {
                    actualizarSemaforo("<!--expoData--><label CssClass=\"lblIzquierdo\"><img src=\"../librerias/img/rojo.png\" />Proceso concluido con errores en BD, código del proceso: " + id_sem + " .</label>", localDate.ToString(), id_sem);
                }

                Log.putLog("[" + localDate.ToString() + "] Error al ejecutar consulta: " + ex.Number + "sql: " + sql);
                throw new Exception("Ocurrio un error de base de datos. Codigo " + ex.Number);
            }

            return null;

        }

        static string devuelveCon()
        {
            XmlDocument xmldoc = new XmlDocument();

            string baseDir = @"C:\DBNeT\dbax\bin\";
            string configPath = Path.Combine(baseDir, "setting.config");
            xmldoc.Load(configPath);

            XmlNode server = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataServer" + "']");
            XmlNode serverAttribute = server.Attributes.GetNamedItem("value");
            string DataServer = serverAttribute.Value.ToString();

            XmlNode bd = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataBase" + "']");
            XmlNode bdAttribute = bd.Attributes.GetNamedItem("value");
            string DataBase = bdAttribute.Value.ToString();

            XmlNode Us = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "User" + "']");
            XmlNode USAttribute = Us.Attributes.GetNamedItem("value");
            string User = USAttribute.Value.ToString();

            XmlNode pass = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "Password" + "']");
            XmlNode passAttribute = pass.Attributes.GetNamedItem("value");
            string Password = passAttribute.Value.ToString();
            string descPassword = DbnetSecurity.dese_vari(Password);

            string strcon = "Data Source=" + DataServer + ";Initial Catalog=" + DataBase + ";Persist Security Info=True;User ID=" + User + ";Password=" + descPassword + "";

            return strcon;
            
        }

        static void actualizarSemaforo(string texto, string fecha, string corr_proc, char borr_mens = '0')
        {
            string sql = "UPDATE [dbax].[dbo].[dbax_proc_even]" +
                         "SET [desc_proc] = '" + texto + "' ,[fech_even] = GETDATE(), [borr_mens] = '" + borr_mens + "'" +
                         "WHERE corr_proc = '" + corr_proc + "'";

            ejecutarConsulta(sql);

        }

        private static bool Handler(CtrlType sig)
        {
            DateTime localDate = DateTime.Now;

            switch (sig)
            {
                case CtrlType.CTRL_C_EVENT:
                    Log.putLog("[" + localDate.ToString() + "] Se cierra la aplicación (a la fuerza) CTRL_C_EVENT");
                    actualizarSemaforo("<!--expoData--><label CssClass=\"lblIzquierdo\"><img src=\"../librerias/img/rojo.png\" />Proceso concluido cierre inesperado de la aplicación.</label>", localDate.ToString(), id_sem);
                    break;

                case CtrlType.CTRL_BREAK_EVENT:
                    Log.putLog("[" + localDate.ToString() + "] Se cierra la aplicación (a la fuerza) CTRL_BREAK_EVENT");
                    actualizarSemaforo("<!--expoData--><label CssClass=\"lblIzquierdo\"><img src=\"../librerias/img/rojo.png\" />Proceso concluido cierre inesperado de la aplicación.</label>", localDate.ToString(), id_sem);
                    break;
                
                case CtrlType.CTRL_CLOSE_EVENT:
                    actualizarSemaforo("<!--expoData--><label CssClass=\"lblIzquierdo\"><img src=\"../librerias/img/rojo.png\" />Proceso concluido cierre inesperado de la aplicación.</label>", localDate.ToString(), id_sem);
                    Log.putLog("[" + localDate.ToString() + "] Se cierra la aplicación CTRL_CLOSE_EVENT");
                    break;

                case CtrlType.CTRL_LOGOFF_EVENT:
                case CtrlType.CTRL_SHUTDOWN_EVENT:
                case CtrlType.CTRL_SHUTDOWN_FORCE:
                    actualizarSemaforo("<!--expoData--><label CssClass=\"lblIzquierdo\"><img src=\"../librerias/img/rojo.png\" />Proceso concluido cierre inesperado de la aplicación.</label>", localDate.ToString(), id_sem);
                    Log.putLog("[" + localDate.ToString() + "] Se cierra la aplicación (a la fuerza)");
                    break;

            }

            return false;

        }

    }
}
