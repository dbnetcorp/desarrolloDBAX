using System;
using System.Collections.Generic;
using System.Text;
using System.Data.OleDb;
using System.Data;
using System.IO;

namespace Gestor
{
    class Descarga
    {
        static string query = "";
        static string[] vLink = new string[5];
        static string[] vNomArch = new string[5];
        static string vRut;
        static string vPeriodo;
        static string pAgent;
        static string Pwget;
        static string PathDesca;
        static string PDoc;
        static string PathBD;

        static void Main(string[] args)
        {
            try
            {
                if (args.Length != 3)
                {
                    System.Console.WriteLine("Número de parámetros erróneo");
                    System.Console.WriteLine("");
                    System.Console.WriteLine("1-Path Wget 2-Path Directorio de Descarga 3-Path base de datos access");
                    Environment.Exit(-1);
                }
                Log._Error = "";

                Pwget = args[0]; // Gestor de descarga
                PathDesca = args[1]; // Directorio de Descarga
                PathBD = args[2]; // path base de datos access
                // Log.putLog(Pwget + " " + PathDesca + " " + PathBD); 
            }
            catch (Exception ex)
            {
                Log.putError(ex.ToString());

            }

            string cadena = @"Provider=Microsoft.ACE.OLEDB.12.0;
                            Data Source=" + PathBD + ";Persist Security Info=False";
            OleDbConnection conexion = new OleDbConnection(cadena);
            OleDbCommand cmd = new OleDbCommand();
            // binario que baja todos los archivos de CI
            try
            {
                conexion.Open();
                query = "SELECT Estdo_Xbrl, Rut_Empr, Peri_Empr, Estdo_Pdf, Analisis, Hechos, Declaracion  from Table1";
                

                OleDbDataAdapter da = new OleDbDataAdapter(query, conexion);
                DataTable dtResclink = new DataTable();
                cmd.CommandTimeout = 900;
                cmd.Connection = conexion;
                cmd.CommandText = query;
                da.SelectCommand = cmd;
                dtResclink.Clear();
                da.Fill(dtResclink);

                /*query = "SELECT Rut_Empr, FechaUltimoEnvio from Table2";
                da = new OleDbDataAdapter(query, conexion);
                DataTable dtFechas = new DataTable();
                cmd.CommandTimeout = 900;
                cmd.Connection = conexion;
                cmd.CommandText = query;
                da.SelectCommand = cmd;
                dtFechas.Clear();
                da.Fill(dtFechas);*/

                //System.Data.DataTable dtResclink = dt;

                for (int i = 0; i < dtResclink.Rows.Count; i++)
                {
                    try
                    {
                        int ii = 0;
                        try
                        {
                            vLink[ii] = dtResclink.Rows[i]["Estdo_Xbrl"].ToString();
                            vNomArch[ii] = "Estados_financieros_(XBRL)";
                            ii++;
                        }
                        catch { }
                        try
                        {
                            vLink[ii] = dtResclink.Rows[i]["Estdo_Pdf"].ToString();
                            vNomArch[ii] = "Estados_financieros_(PDF)";
                            ii++;
                        }
                        catch { }
                        try
                        {
                            vLink[ii] = dtResclink.Rows[i]["Analisis"].ToString();
                            vNomArch[ii] = "Análisis_Razonado";
                            ii++;
                        }
                        catch { }
                        try
                        {
                            vLink[ii] = dtResclink.Rows[i]["Hechos"].ToString();
                            vNomArch[ii] = "Hechos_Relevantes";
                            ii++;
                        }
                        catch { }
                        try
                        {
                            vLink[ii] = dtResclink.Rows[i]["Declaracion"].ToString();
                            vNomArch[ii] = "Declaración_de_responsabilidad";
                            ii++;
                        }
                        catch { }
                        vRut = dtResclink.Rows[i]["Rut_Empr"].ToString().Trim();
                        vPeriodo = dtResclink.Rows[i]["Peri_Empr"].ToString().Trim(); ;
                        // para taxomomia  Comercio Industria
                        //Arregla Periodo
                        vPeriodo = Convert.ToDateTime(vPeriodo).Date.ToString("yyyyMM");

                        // Corta guion y digito verificador
                        int len = vRut.Length;
                        int idx = vRut.IndexOf("-");
                        vRut = vRut.Substring(0, idx) + "" + vRut.Substring(idx + 2);

                        // Parametros que recibe gestor
                        pAgent = " --user-agent='Mozilla/6.0' ";
                        for (int n = 0; n < vLink.Length; n++)
                        {
                            // Log.putLog("pase " + vLink[n]);
                            if (n == 0)
                            {
                                // Nombre de archivo xbrl = que el de la SVS
                                PDoc = vNomArch[n] + vRut + "_" + vPeriodo + ".xbrl".Trim();
                            }
                            else
                            {
                                PDoc = vNomArch[n] + vRut + "_" + vPeriodo + ".pdf".Trim();
                            }
                            // Ruta completa donde se dejara el archvio *OUT*
                            string vPthdown = PathDesca + "\\" + vRut + "_" + vPeriodo;
                            if (!System.IO.Directory.Exists(vPthdown))
                            {
                                System.IO.Directory.CreateDirectory(vPthdown);
                            }
                            vPthdown = vPthdown + "\\" + PDoc;

                            if (PDoc.EndsWith(".xbrl") || !File.Exists(vPthdown))
                            {
                                // *********Ejecuta proceso en CMD**********
                                Ejecuta_Proceso_DOS(Pwget, pAgent + "-O " + vPthdown + " \"" + vLink[n] + "\"");

                                // Abre xbrl y revisa si es Zip o Xbrl, cambia extension
                                StreamReader reader = new StreamReader(vPthdown, Encoding.ASCII);//.GetEncoding("ASCII")); //ASCII o utf-8
                                string ax = reader.ReadLine();
                                reader.Close();
                                if (ax.Contains("PK"))
                                {
                                    string ext = vPthdown.Replace(".xbrl", ".zip");
                                    File.Delete(ext);
                                    File.Move(vPthdown, ext);
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Log.putLog("Error en Rut (" + vRut + ")");
                        Log.putError(ex.ToString());
                    }
                }

            }
            catch (Exception ex)
            {
                Log.putLog("Error en la Conexion: " + ex);
            }
        }

        public static string Ejecuta_Proceso_DOS(string proceso, string parametros)
        {
            string salida = "";
            try
            {
                System.Diagnostics.ProcessStartInfo pinfo = new System.Diagnostics.ProcessStartInfo();
                pinfo.UseShellExecute = false;
                pinfo.RedirectStandardOutput = true;
                pinfo.FileName = proceso;
                pinfo.Arguments = parametros;

                System.Console.WriteLine("Comando Ejecutado : " + proceso + " " + parametros);
                Log.putLog("Comando Ejecutado : " + proceso + " " + parametros);
                System.Diagnostics.Process p = System.Diagnostics.Process.Start(pinfo);
                p.WaitForExit();
                System.Console.WriteLine("Proceso Terminado\n");
            }
            catch (Exception ex)
            {
                salida += ex.Message;
                System.Console.WriteLine("Proceso Terminado con Errores.");
                System.Console.WriteLine(salida);
            }
            return salida;
        }


        public static DataTable Ejecuta_Select(OleDbConnection dbConn, string query)
        {
            OleDbCommand cmd = new OleDbCommand();
            OleDbDataAdapter da = new OleDbDataAdapter();
            DataTable dt = new DataTable();
            cmd.CommandTimeout = 900;
            try
            {
                cmd.Connection = dbConn;

                cmd.CommandText = query;
                da.SelectCommand = cmd;
                dt.Clear();
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                Log.putLog("Error de BD : 1000 " + ex.Message.Substring(1, 50));
                Log.putLog(query);
                throw new System.ArgumentException("Error");
            }
            return dt;
        }


        public class Log
        {
            public static string _Error;
            public static void putError(string pTexto)
            {
                _Error = pTexto.Replace("'", "");
                putLog("ERROR : " + pTexto);
            }

            public static void putLog(string pTexto)
            {
                string vFileName;
                string vFecha = System.DateTime.Now.Year.ToString("0000") + "-" +
                                System.DateTime.Now.Month.ToString("00") + "-" +
                                System.DateTime.Now.Day.ToString("00") + " " +
                                System.DateTime.Now.Hour.ToString("00") + ":" +
                                System.DateTime.Now.Minute.ToString("00") + ":" +
                                System.DateTime.Now.Second.ToString("00") + " ";

                try
                {
                    string[] cmds = Environment.GetCommandLineArgs();
                    string cmd = cmds[0].Split('\\')[cmds[0].Split('\\').Length - 1];
                    cmd = cmd.Replace(".exe", "");

                    vFileName = "AX";
                    cmd = vFileName + '_' + cmd + ".log";
                    vFileName = @"C:\DBNeT\Spider\" + "\\log\\" + cmd;
                }
                catch (Exception ex)
                {
                    try
                    {
                        string[] cmds = Environment.GetCommandLineArgs();
                        string cmd = cmds[0].Split('\\')[cmds[0].Split('\\').Length - 1];
                        cmd = cmd.Replace(".exe", ".log");

                        vFileName = @"C:\DBNeT\Spider\" + "\\log\\" + cmd;
                    }
                    catch
                    {
                        vFileName = @"C:\DBNeT\Spider\" + "\\log\\dbnet.log";
                        Console.WriteLine(ex.Message);
                    }
                }

                using (System.IO.TextWriter streamWriter = new System.IO.StreamWriter(vFileName, true))
                {
                    streamWriter.WriteLine(vFecha + pTexto);
                }
            }
        }
    }
}
