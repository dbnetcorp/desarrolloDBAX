using System;
using System.Collections.Generic;
using System.Text;
using System.Data.OleDb;
using System.Data;
using System.IO;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Text;
using System.Net;
using System.IO;
using System.Web;
using System.Globalization;
using System.Diagnostics;

namespace GestorDescargas2
{
    class GestorDescargas2
    {
        static string query = "";
        static string[] vLink = new string[5];
        static string[] vNomArch = new string[5];
        static string Pwget;
        static string PathDesca;
        static string PathBD;
        static string PathSpider = @"E:\DBNeT\Spider\";
        static string PathSistema = @"C:\DBNeT\";
        static string pCorrInst = "";
        static void Main(string[] args)
        {
            try
            {
                if (args.Length == 2)
                {
                    Console.WriteLine("Modalidad de compresión de directorios");
                    ComprimeCarpetas(args[0].ToString(), args[1].ToString());
                }
                else if (args.Length == 3)
                {
                    Log.putLog("Modalidad de descarga normal");
                }
                else if (args.Length == 4)
                {
                    Log.putLog("Modalidad de descarga para un unico periodo");
                    pCorrInst = args[3].ToString();
                }
                else
                {
                    System.Console.WriteLine("Número de parámetros erróneo: " + args.Length);
                    System.Console.WriteLine("");
                    System.Console.WriteLine("1-Path Wget 2-Path Directorio de Descarga 3-Path base de datos access");
                    Environment.Exit(-1);
                }

                Console.WriteLine("2");
                Log._Error = "";
                Console.WriteLine("3");
                Pwget = args[0]; // Gestor de descarga
                PathDesca = args[1]; // Directorio de Descarga

                if (!PathDesca.EndsWith("\\"))
                    PathDesca += "\\";

                PathBD = args[2]; // path base de datos access
                // Log.putLog(Pwget + " " + PathDesca + " " + PathBD); 
            }
            catch (Exception ex)
            {
                Log.putError(ex.ToString());
            }

            // binario que baja todos los archivos de CI
            try
            {
                string cadena = @"Provider=Microsoft.ACE.OLEDB.12.0;
                            Data Source=" + PathBD + ";Persist Security Info=False";
                OleDbConnection conexion = new OleDbConnection(cadena);
                OleDbCommand cmd = new OleDbCommand();

                SqlConnection conCentral = new SqlConnection("Data Source=192.168.2.42;Initial Catalog=dbax_central;Persist Security Info=True;User ID=dbax_central;Password=dbax");
                SqlConnection conPrisma = new SqlConnection("Data Source=192.168.2.42;Initial Catalog=dbax;Persist Security Info=True;User ID=dbax;Password=dbax");

                

                //Rescato los periodos con los que trabajaré
                if (args.Length == 3)
                {
                    query = "SELECT distinct CorrInst from RutFechas where Rut_Empr <> '' and CorrInst <> '' order by CorrInst asc";
                }
                else if (args.Length == 4)
                {
                    query = "SELECT distinct CorrInst from RutFechas where Rut_Empr <> '' and CorrInst like '%" + pCorrInst + "%' order by CorrInst asc";
                }

                if(conexion.State==ConnectionState.Closed)
                    conexion.Open();
                OleDbDataAdapter da = new OleDbDataAdapter(query, conexion);
                DataTable dtPeriodosOriginal = new DataTable();

                cmd.CommandTimeout = 900;
                cmd.Connection = conexion;
                cmd.CommandText = query;
                da.SelectCommand = cmd;
                dtPeriodosOriginal.Clear();
                da.Fill(dtPeriodosOriginal);
                if (conexion.State == ConnectionState.Open)
                    conexion.Close();

                for (int i = 0; i < dtPeriodosOriginal.Rows.Count; i++)
                {
                    dtPeriodosOriginal.Rows[i]["CorrInst"] = dtPeriodosOriginal.Rows[i]["CorrInst"].ToString().Trim().Replace("Sociedades anónimas que han remitido información financiera bajo IFRS al ", "");
                    dtPeriodosOriginal.Rows[i]["CorrInst"] = dtPeriodosOriginal.Rows[i]["CorrInst"].ToString().Replace("/", "");
                    dtPeriodosOriginal.Rows[i]["CorrInst"] = dtPeriodosOriginal.Rows[i]["CorrInst"].ToString().Substring(2) + dtPeriodosOriginal.Rows[i]["CorrInst"].ToString().Substring(0, 2);
                }

                DataView dvPeriodos = dtPeriodosOriginal.DefaultView;
                dvPeriodos.Sort = "CorrInst asc";
                DataTable dtPeriodos = dvPeriodos.ToTable();
                dtPeriodosOriginal.Dispose();
                dvPeriodos.Dispose();


                for (int w = 0; w < dtPeriodos.Rows.Count; w++)
                {
                    List<string> vXBRLEnviados = new List<string>();
                    List<string> vXBRLDescargado = new List<string>();
                    List<string> vXBRLcProbDesc = new List<string>();

                    string vCorrInst = dtPeriodos.Rows[w]["CorrInst"].ToString().Trim();
                    string vMes = vCorrInst.Substring(4);
                    string vAno = vCorrInst.Substring(0, 4);

                    //if (args.Length == 3)
                    //{
                    //    query = "SELECT Rut_Empr, CorrInst, FechaPrimerEnvio, FechaUltimoEnvio, RazonSocial, TipoBalance, TipoEnvio, Link from RutFechas where Rut_Empr <> '' and CorrInst <> '' order by CorrInst asc";
                    //}
                    //else if (args.Length == 4)
                    //{
                    query = "SELECT Rut_Empr, CorrInst, FechaPrimerEnvio, FechaUltimoEnvio, RazonSocial, TipoBalance, TipoEnvio, Link from RutFechas where Rut_Empr <> '' and CorrInst like '%" + vMes+ "/" + vAno + "%' order by CorrInst asc";
                    //}

                    da = new OleDbDataAdapter(query, conexion);

                    DataTable dtFechaEnviosOriginal = new DataTable();
                    DataTable dtFechaEnvios = new DataTable();

                    cmd.CommandTimeout = 900;
                    cmd.Connection = conexion;
                    cmd.CommandText = query;
                    da.SelectCommand = cmd;
                    dtFechaEnviosOriginal.Clear();
                    da.Fill(dtFechaEnviosOriginal);
                    conexion.Close();

                    for (int i = 0; i < dtFechaEnviosOriginal.Rows.Count; i++)
                    {
                        dtFechaEnviosOriginal.Rows[i]["CorrInst"] = dtFechaEnviosOriginal.Rows[i]["CorrInst"].ToString().Trim().Replace("Sociedades anónimas que han remitido información financiera bajo IFRS al ", "");
                        dtFechaEnviosOriginal.Rows[i]["CorrInst"] = dtFechaEnviosOriginal.Rows[i]["CorrInst"].ToString().Replace("/", "");
                        dtFechaEnviosOriginal.Rows[i]["CorrInst"] = dtFechaEnviosOriginal.Rows[i]["CorrInst"].ToString().Substring(2) + dtFechaEnviosOriginal.Rows[i]["CorrInst"].ToString().Substring(0, 2);
                    }

                    DataView dv = dtFechaEnviosOriginal.DefaultView;
                    dv.Sort = "CorrInst desc";
                    dtFechaEnvios = dv.ToTable();


                    string vMsgAdvertencia = "";
                    string vCorrInstAnt = "";
                    #region Comparación de fechas y descarga
                    for (int i = 0; i < dtFechaEnvios.Rows.Count; i++)
                    {
                        try
                        {
                            string result = "";
                            string vRutEmpr = dtFechaEnvios.Rows[i]["Rut_empr"].ToString().Substring(0, dtFechaEnvios.Rows[i]["Rut_empr"].ToString().IndexOf("-"));
                            //if (vRutEmpr == "96970380")
                            //{
                                query = " exec SP_AX_updArchPend " + vAno + vMes + ",'" + vRutEmpr + "','SVS'";
                                if (conPrisma.State == ConnectionState.Closed)
                                    conPrisma.Open();
                                SqlCommand Command = new SqlCommand();
                                Command.Connection = conPrisma;
                                Command.CommandText = query;
                                Command.ExecuteNonQuery();
                                if (conPrisma.State == ConnectionState.Open)
                                    conPrisma.Close();

                                /*if (dtCantEnvi.Rows[0][0].ToString() == "0")
                                {
                                    query = "insert into dbax_arch_pend (corr_inst, codi_pers, vers_envi, fech_svs) " +
                                            "values ('" + vAno + vMes + "','" + vRutEmpr + "', 1, getdate())";
                                    conPrisma.Open();
                                    SqlCommand Command = new SqlCommand();
                                    Command.Connection = conPrisma;
                                    Command.CommandText = query;
                                    Command.ExecuteNonQuery();
                                    conPrisma.Close();
                                }*/

                                string vFechaPrimerEnvio = dtFechaEnvios.Rows[i]["FechaPrimerEnvio"].ToString().Trim();
                                //vFechaPrimerEnvio = vFechaPrimerEnvio.Substring(3, 3) + vFechaPrimerEnvio.Substring(0, 2) + vFechaPrimerEnvio.Substring(5);

                                string vFechaUltimoEnvio = dtFechaEnvios.Rows[i]["FechaUltimoEnvio"].ToString().Trim();
                                //vFechaUltimoEnvio = vFechaUltimoEnvio.Substring(3, 3) + vFechaUltimoEnvio.Substring(0, 2) + vFechaUltimoEnvio.Substring(5);

                                string vRazonSocial = dtFechaEnvios.Rows[i]["RazonSocial"].ToString().Trim();
                                string vTipoBalance = dtFechaEnvios.Rows[i]["TipoBalance"].ToString().Trim().Replace("Individual", "I").Replace("Consolidado", "C");
                                string vTipoEnvio = dtFechaEnvios.Rows[i]["TipoEnvio"].ToString().Trim();

                                string vLink = dtFechaEnvios.Rows[i]["Link"].ToString().Trim();

                                Console.WriteLine("Obtengo fecha almancenada en central para archivo siendo procesado");
                                query = "set dateformat dmy;select    isnull(max(0),1) " +
                                        " from      dbax_tras_arch " +
                                        " where     path_arch like '" + vCorrInst + "%'" +
                                        " and       path_arch like '%" + vRutEmpr + "%'" +
                                        " and       fech_envi > convert(datetime,'" + vFechaUltimoEnvio + "')";
                                Log.putLog(query);
                                if (conCentral.State == ConnectionState.Closed)
                                    conCentral.Open();
                                SqlDataAdapter ada = new SqlDataAdapter(query, conCentral);
                                DataTable dtUltimaFecha = new DataTable();
                                ada.Fill(dtUltimaFecha);

                                if (conCentral.State == ConnectionState.Open)
                                    conCentral.Close();

                                //if(1==1)
                                if (dtUltimaFecha.Rows[0][0].ToString() == "1")
                                {
                                    Log.putLog("Intento descargar archivos para rut " + vRutEmpr + ", " + vCorrInst);

                                    //Obtengo página desde sitio web de la SVS
                                    vLink = HttpUtility.HtmlDecode(vLink);
                                    vLink = vLink.Substring(vLink.IndexOf("href=\"") + 6);
                                    vLink = @"https://www.cmfchile.cl/institucional/mercados/" + vLink.Substring(0, vLink.IndexOf("\">"));
                                    
                                    //Revisión con curl
                                    try
                                    {
                                        Log.putLog("Link a revisar: " + vLink); //Borrar
                                        ProcessStartInfo start = new ProcessStartInfo();
                                        start.FileName = @"C:\DBNeT\dbax_central\bin\curl.exe";
                                        start.Arguments = "--user-agent 'Mozilla/6.0' \"" + vLink + "\"";
                                        start.UseShellExecute = false;
                                        start.RedirectStandardOutput = true;
                                        start.StandardOutputEncoding = System.Text.Encoding.UTF8;
                                        
                                        using (Process procesoMail = Process.Start(start))
                                        {
                                            using (StreamReader reader = procesoMail.StandardOutput)
                                            {
                                                result = reader.ReadToEnd();                                             
                                            }

                                        }

                                    }
                                    catch (Exception ex)
                                    {
                                        Log.putLog("Error al procesar curl: " + ex.Message);
                                        Log.putLog("Stack : " + ex.StackTrace);
                                        Log.putLog("InnerException : " + ex.InnerException);
                                        Console.WriteLine(ex.Message);
                                        Console.WriteLine(ex.StackTrace);
                                        Console.WriteLine(ex.InnerException);
                                        Environment.Exit(-1);
                                    }
                                    

                                    string vLinkXBRL = obtieneLinksPdf(vRutEmpr, vCorrInst, result, "XBRL");

                                    string vPthdown = PathDesca + "SVS" + vCorrInst + "\\Descarga\\" + vRutEmpr + "_" + vCorrInst;
                                    if (!System.IO.Directory.Exists(vPthdown))
                                    {
                                        System.IO.Directory.CreateDirectory(vPthdown);
                                    }

                                    if (!System.IO.Directory.Exists(PathSistema + @"dbax_central\out\" + vCorrInst + @"_CI\")) ;
                                    System.IO.Directory.CreateDirectory(PathSistema + @"dbax_central\out\" + vCorrInst + @"_CI\");

                                    bool vArchConDatos = false;

                                    /*if (vRutEmpr == "76073164")
                                        vArchConDatos = false;
                                    */
                                    if (vLinkXBRL.Length > 10)
                                    {
                                        query = " exec SP_AX_updArchPend " + vAno + vMes + ",'" + vRutEmpr + "','XBRL'";
                                        if (conPrisma.State == ConnectionState.Closed)
                                            conPrisma.Open();
                                        Command = new SqlCommand();
                                        Command.Connection = conPrisma;
                                        Command.CommandText = query;
                                        Command.ExecuteNonQuery();

                                        if (conPrisma.State == ConnectionState.Open)
                                            conPrisma.Close();

                                        Log.putLog("Link: ok");
                                        vXBRLEnviados.Add(vRutEmpr);
                                        using (System.Net.WebClient Client = new System.Net.WebClient())
                                        {
                                            FileInfo FilePropX = null;
                                            //Trato de bajar ZIP
                                            if (vLinkXBRL.ToUpper().Contains(".ZIP"))
                                            {
                                                //Client.DownloadFile(vLinkXBRL, vPthdown + @"\Estados_financieros_(XBRL)" + vRutEmpr + "_" + vCorrInst + ".zip");
                                                DownloadFile(vLinkXBRL, vPthdown + @"\Estados_financieros_(XBRL)" + vRutEmpr + "_" + vCorrInst + ".zip");
                                                FilePropX = new FileInfo(vPthdown + @"\Estados_financieros_(XBRL)" + vRutEmpr + "_" + vCorrInst + ".zip");
                                            }
                                            else if (vLinkXBRL.ToUpper().Contains(".XBRL"))
                                            {
                                                DownloadFile(vLinkXBRL, vPthdown + @"\Estados_financieros_(XBRL)" + vRutEmpr + "_" + vCorrInst + ".xbrl");
                                                FilePropX = new FileInfo(vPthdown + @"\Estados_financieros_(XBRL)" + vRutEmpr + "_" + vCorrInst + ".xbrl");
                                            }

                                            long FileLengX = FilePropX.Length;
                                            if (FileLengX < 100)
                                            {
                                                query = " exec SP_AX_updArchPend " + vAno + vMes + ",'" + vRutEmpr + "','','ETA'";
                                                if (conPrisma.State == ConnectionState.Closed)
                                                conPrisma.Open();
                                                Command = new SqlCommand();
                                                Command.Connection = conPrisma;
                                                Command.CommandText = query;
                                                Command.ExecuteNonQuery();
                                                if (conPrisma.State == ConnectionState.Open)
                                                    conPrisma.Close();

                                                vXBRLcProbDesc.Add(vRutEmpr);
                                                Log.putLog("Se detectó que archivo " + FilePropX.Name + " es menor a 100 bytes");
                                                System.Threading.Thread.Sleep(1000);
                                                File.Delete(vPthdown + @"\Estados_financieros_(XBRL)" + vRutEmpr + "_" + vCorrInst + ".zip");
                                            }
                                            else
                                            {
                                                query = " exec SP_AX_updArchPend " + vAno + vMes + ",'" + vRutEmpr + "','DESC'";
                                                if (conPrisma.State == ConnectionState.Closed)
                                                    conPrisma.Open();
                                                Command = new SqlCommand();
                                                Command.Connection = conPrisma;
                                                Command.CommandText = query;
                                                Command.ExecuteNonQuery();
                                                if (conPrisma.State == ConnectionState.Open)
                                                    conPrisma.Close();

                                                vXBRLDescargado.Add(vRutEmpr);
                                                vArchConDatos = true;
                                            }

                                            if (vArchConDatos)
                                            {
                                                Log.putLog("El archivo tiene datos y se descargaran los XBRL");
                                                //Descarga de PDFs

                                                if (result.Trim().Length == 0)
                                                {
                                                    Log.putLog("Error descargando web desde link (contenido vacio): " + vLink);
                                                }

                                                try
                                                {
                                                    DownloadFile(obtieneLinksPdf(vRutEmpr, vCorrInst, result, "ANAL_RAZO"), vPthdown + @"\Análisis_Razonado" + vRutEmpr + "_" + vCorrInst + ".pdf");
                                                    FileInfo FileProp = new FileInfo(vPthdown + @"\Análisis_Razonado" + vRutEmpr + "_" + vCorrInst + ".pdf");
                                                    long FileLeng = FileProp.Length;
                                                    if (FileLeng < 100)
                                                    {
                                                        System.Threading.Thread.Sleep(1000);
                                                        File.Delete(vPthdown + @"\Análisis_Razonado" + vRutEmpr + "_" + vCorrInst + ".pdf");
                                                    }
                                                }
                                                catch (Exception ex)
                                                {
                                                    Log.putError("No se pudo descargar PDF: Análisis_Razonado." + ex.Message + ex.StackTrace);
                                                }

                                                try
                                                {
                                                    DownloadFile(obtieneLinksPdf(vRutEmpr, vCorrInst, result, "DECL_RESP"), vPthdown + @"\Declaración_de_responsabilidad" + vRutEmpr + "_" + vCorrInst + ".pdf");
                                                    FileInfo FileProp = new FileInfo(vPthdown + @"\Declaración_de_responsabilidad" + vRutEmpr + "_" + vCorrInst + ".pdf");
                                                    long FileLeng = FileProp.Length;
                                                    if (FileLeng < 100)
                                                    {
                                                        System.Threading.Thread.Sleep(1000);
                                                        File.Delete(vPthdown + @"\Declaración_de_responsabilidad" + vRutEmpr + "_" + vCorrInst + ".pdf");
                                                    }
                                                }
                                                catch
                                                {
                                                    Log.putError("No se pudo descargar PDF: Declaracion de responsabilidad.");
                                                }

                                                try
                                                {
                                                    DownloadFile(obtieneLinksPdf(vRutEmpr, vCorrInst, result, "HECH_RELE"), vPthdown + @"\Hechos_Relevantes" + vRutEmpr + "_" + vCorrInst + ".pdf");
                                                    FileInfo FileProp = new FileInfo(vPthdown + @"\Hechos_Relevantes" + vRutEmpr + "_" + vCorrInst + ".pdf");
                                                    long FileLeng = FileProp.Length;
                                                    if (FileLeng < 100)
                                                    {
                                                        System.Threading.Thread.Sleep(1000);
                                                        File.Delete(vPthdown + @"\Hechos_Relevantes" + vRutEmpr + "_" + vCorrInst + ".pdf");
                                                    }
                                                }
                                                catch
                                                {
                                                    Log.putError("No se pudo descargar PDF: Hechos relevantes.");
                                                }

                                                try
                                                {
                                                    DownloadFile(obtieneLinksPdf(vRutEmpr, vCorrInst, result, "ESTA_FINA"), vPthdown + @"\Estados_financieros_(PDF)" + vRutEmpr + "_" + vCorrInst + ".pdf");
                                                    FileInfo FileProp = new FileInfo(vPthdown + @"\Estados_financieros_(PDF)" + vRutEmpr + "_" + vCorrInst + ".pdf");
                                                    long FileLeng = FileProp.Length;
                                                    if (FileLeng < 100)
                                                    {
                                                        System.Threading.Thread.Sleep(1000);
                                                        File.Delete(vPthdown + @"\Estados_financieros_(PDF)" + vRutEmpr + "_" + vCorrInst + ".pdf");
                                                    }
                                                }
                                                catch
                                                {
                                                    Log.putError("No se pudo descargar PDF: Estados financieros.");
                                                }

                                                Log.putLog("Se descargó el archivo XBRL para la empresa " + vRutEmpr + ", " + vCorrInst);
                                                string proceso = PathSistema + @"dbax_central\bin\zip.exe";
                                                string parametros = @"-Djr9 " + PathSistema + @"dbax_central\out\" + vCorrInst + @"_CI\" + vRutEmpr + "_" + vCorrInst + " " + vPthdown;
                                                Ejecuta_Proceso_DOS(proceso, parametros);
                                                Log.putLog("Se comprimió el archivo XBRL para la empresa " + vRutEmpr + ", " + vCorrInst);
                                            }
                                            else
                                            {
                                                Log.putError("No se pudo descargar el XBRL para " + vRutEmpr + ", " + vCorrInst + ".");
                                            }
                                        }
                                    }
                                    else if (vLinkXBRL.Length <= 10 && (vLinkXBRL.Length > 0))
                                    {
                                        Log.putError("Parece que hay un error con el link de descarga de XBRL:" + vLinkXBRL);
                                    }
                                    else if (vLinkXBRL.Length == 0)
                                    {
                                        Log.putError("No hay un XBRLpublicado para " + vRutEmpr + ", " + vCorrInst);
                                    }

                                }
                                else
                                {
                                    vXBRLEnviados.Add(vRutEmpr);
                                }
                                vCorrInstAnt = vCorrInst;
                            //}
                        }
                        catch (Exception ex)
                        {
                            Log.putLog("Error en Rut (" + dtFechaEnvios.Rows[i]["Rut_empr"].ToString() + ")");
                            Log.putError(ex.ToString());
                        }
                    }
                    #endregion

                    #region Generación de alertas por descarga

                    /*string vMensaje = "";
                    if (vXBRLDescargado.Count > 0 || vXBRLcProbDesc.Count > 0)
                    {
                        vMensaje = "Hay " + vXBRLEnviados.Count + " XBRL enviados a la SVS: ";
                        Log.putLog(vMensaje);
                        if (vXBRLEnviados.Count > 0)
                        {
                            for (int j = 0; j < vXBRLEnviados.Count; j++)
                            {
                                //if ((vMensaje + vXBRLEnviados[j].ToString() + ", ").Length <= 3500 && j < (vXBRLEnviados.Count - 1))
                                //{
                                //    vMensaje += vXBRLEnviados[j].ToString() + ", ";
                                //}
                                //else
                                //{
                                    query = " select    count(*) " +
                                            " from      dbax_repo_prob " +
                                            " where     corr_inst = " + pCorrInst +
                                            " and       codi_pers = '" + vXBRLEnviados[j].ToString() + "'";
                                    conPrisma.Open();
                                    SqlDataAdapter ada = new SqlDataAdapter(query, conPrisma);
                                    //Version de envio
                                    DataTable dtCantEnvi = new DataTable();
                                    ada.Fill(dtCantEnvi);
                                    conPrisma.Close();

                                    if (dtCantEnvi.Rows[0][0].ToString() == "0")
                                    {
                                        query = "insert into dbax_repo_prob (corr_inst, codi_pers, fech_svs) " +
                                                "values ('" + vAno + vMes + "',getdate(),'INF','" + vMensaje + "')";
                                        conPrisma.Open();
                                        SqlCommand Command = new SqlCommand();
                                        Command.Connection = conPrisma;
                                        Command.CommandText = query;
                                        Command.ExecuteNonQuery();
                                        conPrisma.Close();
                                    }
                                //    vMensaje = "Hay " + vXBRLEnviados.Count + " XBRL enviados a la SVS: " + vXBRLEnviados[j].ToString() + ", ";
                                //}
                            }
                        }

                        vMensaje = "Se han descargado " + vXBRLDescargado.Count + " XBRL: ";
                        Log.putLog(vMensaje);
                        if (vXBRLDescargado.Count > 0)
                        {
                            for (int j = 0; j < vXBRLDescargado.Count; j++)
                            {
                                query = "insert into dbax_arch_pend (fech_proc, corr_inst, codi_pers, esta_vers) " +
                                        "values (getdate(), '" + vAno + vMes + "','" + vXBRLDescargado[j].ToString() +"','0')";
                                conCentral.Open();
                                SqlCommand Command = new SqlCommand();
                                Command.Connection = conCentral;
                                Command.CommandText = query;
                                Command.ExecuteNonQuery();
                                conCentral.Close();

                                if ((vMensaje + vXBRLDescargado[j].ToString() + ", ").Length <= 3500 && j < (vXBRLDescargado.Count - 1))
                                {
                                    vMensaje += vXBRLDescargado[j].ToString() + ", ";
                                }
                                else
                                {
                                    query = "insert into dbax_repo_prob (corr_inst, hora_carg, tipo_prob, desc_prob) " +
                                            "values ('" + vAno + vMes + "',getdate(),'INF','" + vMensaje + "')";
                                    conPrisma.Open();
                                    Command = new SqlCommand();
                                    Command.Connection = conPrisma;
                                    Command.CommandText = query;
                                    Command.ExecuteNonQuery();
                                    conPrisma.Close();

                                    vMensaje = "Se han descargado " + vXBRLDescargado.Count + " XBRL: " + vXBRLDescargado[j].ToString() + ", ";
                                }
                            }
                        }

                        vMensaje = "No se pudieron descargar " + vXBRLcProbDesc.Count + " XBRL de la pagina de la SVS: ";
                        Log.putLog(vMensaje);
                        if (vXBRLcProbDesc.Count > 0)
                        {
                            for (int j = 0; j < vXBRLcProbDesc.Count; j++)
                            {
                                if ((vMensaje + vXBRLcProbDesc[j].ToString() + ", ").Length <= 3500 && j < (vXBRLcProbDesc.Count - 1))
                                {
                                    vMensaje += vXBRLcProbDesc[j].ToString() + ", ";
                                }
                                else
                                {
                                    query = "insert into dbax_repo_prob (corr_inst, hora_carg, tipo_prob, desc_prob) " +
                                            "values ('" + vAno + vMes + "',getdate(),'EDE','" + vMensaje + "')";
                                    conPrisma.Open();
                                    SqlCommand Command = new SqlCommand();
                                    Command.Connection = conPrisma;
                                    Command.CommandText = query;
                                    Command.ExecuteNonQuery();
                                    conPrisma.Close();

                                    vMensaje = "No se pudieron descargar " + vXBRLcProbDesc.Count + " XBRL de la pagina de la SVS: " + vXBRLDescargado[j].ToString() + ", ";
                                }
                            }
                        }
                    }*/
                    #endregion

                    /*#region Generación de alertas por descarga vieja
                    for (int i = 0; i < dtFechaEnvios.Rows.Count; i++)
                    {
                        try
                        {
                            string vRutEmpr = dtFechaEnvios.Rows[i]["Rut_empr"].ToString().Substring(0, dtFechaEnvios.Rows[i]["Rut_empr"].ToString().IndexOf("-"));

                            string vCorrInst = dtFechaEnvios.Rows[i]["CorrInst"].ToString().Trim();
                            string vMes = vCorrInst.Substring(4);
                            string vAno = vCorrInst.Substring(0, 4);

                            string vPthdown = PathDesca + "SVS" + vCorrInst + "\\Descarga\\" + vRutEmpr + "_" + vCorrInst;
                            if (!System.IO.Directory.Exists(vPthdown))
                            {
                                System.IO.Directory.CreateDirectory(vPthdown);
                            }

                            bool vArchConDatos = false;

                            if (File.Exists(vPthdown + @"\Estados_financieros_(XBRL)" + vRutEmpr + "_" + vCorrInst + ".zip") || File.Exists(vPthdown + @"\Estados_financieros_(XBRL)" + vRutEmpr + "_" + vCorrInst + ".xbrl"))
                            {
                                vArchConDatos = true;
                            }

                            if (!vArchConDatos)
                            {
                                vMsgAdvertencia += vRutEmpr.ToString() + ", ";
                                if (vMsgAdvertencia.Length > 0 && ((i > 0 && vCorrInst != vCorrInstAnt) || (i == (dtFechaEnvios.Rows.Count - 1))))
                                {
                                    query = "insert into dbax_repo_prob (corr_inst, hora_carg, tipo_prob, desc_prob) " +
                                            " values ('" + dtFechaEnvios.Rows[i - 1]["CorrInst"].ToString() + "',getdate(),'EDE','No se pudieron descargar: " + vMsgAdvertencia + "')";
                                    da = new OleDbDataAdapter(query, conexion);

                                    conPrisma.Open();
                                    SqlCommand Command = new SqlCommand();
                                    Command.Connection = conPrisma;
                                    Command.CommandText = query;
                                    Command.ExecuteNonQuery();
                                    conPrisma.Close();

                                    Log.putError("No se pudieron descargar: " + vMsgAdvertencia);
                                    vMsgAdvertencia = "";
                                }
                            }

                            vCorrInstAnt = vCorrInst;
                        }
                        catch (Exception ex)
                        {
                            Log.putLog("Error en Rut (" + dtFechaEnvios.Rows[i]["Rut_empr"].ToString() + ")");
                            Log.putError(ex.ToString());
                        }
                    }
                    #endregion*/
                }
            }
            catch (Exception ex)
            {
                Log.putError("Error");
                Log.putError(query);
                Log.putError(ex.Message);
                Log.putError(ex.StackTrace);
            }
        }
            
        public static string obtieneLinksPdf(string vRutEmpr, string vCorrInst, string vPagina, string vTipoArchivo)
        {
            /*if (vRutEmpr == "82777100")
            {
                Log.putLog(vPagina);
                Log.putLog(vTipoArchivo);
            }*/
            string vCopiaPagina = vPagina;
            string vLink;
            int vInicio, vFinal;
            switch (vTipoArchivo)
            {
                case "ANAL_RAZO":
                    vInicio = vPagina.LastIndexOf("ar_" + vRutEmpr + "_" + vCorrInst);
                    vCopiaPagina = vPagina.Substring(0, vInicio);
                    vInicio = vCopiaPagina.LastIndexOf("<a href="); //
                    vCopiaPagina = vPagina.Substring(vInicio);
                    vFinal = vCopiaPagina.IndexOf("\">Análisis Razonado </a>");
                    vLink = @"https://www.cmfchile.cl/institucional/" + vCopiaPagina.Substring(12, vFinal - 12);
                    return vLink;
                    break;
                case "DECL_RESP":
                    vInicio = vPagina.LastIndexOf("dr_" + vRutEmpr + "_" + vCorrInst);
                    vCopiaPagina = vPagina.Substring(0, vInicio);
                    vInicio = vCopiaPagina.LastIndexOf("<a href="); //
                    vCopiaPagina = vPagina.Substring(vInicio);
                    vFinal = vCopiaPagina.IndexOf("\">Declaración de responsabilidad </a>");
                    vLink = @"https://www.cmfchile.cl/institucional/" + vCopiaPagina.Substring(12, vFinal - 12);
                    return vLink;
                    break;
                case "HECH_RELE":
                    vInicio = vPagina.LastIndexOf("hr_" + vRutEmpr + "_" + vCorrInst);
                    vCopiaPagina = vPagina.Substring(0, vInicio);
                    vInicio = vCopiaPagina.LastIndexOf("<a href="); //
                    vCopiaPagina = vPagina.Substring(vInicio);
                    vFinal = vCopiaPagina.IndexOf("\">Hechos Relevantes </a>");
                    vLink = @"https://www.cmfchile.cl/institucional/" + vCopiaPagina.Substring(12, vFinal - 12);
                    return vLink;
                    break;
                case "ESTA_FINA":
                    vInicio = vPagina.LastIndexOf("pdf_" + vRutEmpr + "_" + vCorrInst);
                    if(vInicio == -1)
                        vInicio = vPagina.LastIndexOf("ef_" + vRutEmpr + "_" + vCorrInst);
                    vCopiaPagina = vPagina.Substring(0, vInicio);
                    vInicio = vCopiaPagina.LastIndexOf("<a href="); //
                    vCopiaPagina = vPagina.Substring(vInicio);
                    vFinal = vCopiaPagina.IndexOf("\">Estados financieros (PDF) </a>");
                    vLink = @"https://www.cmfchile.cl/institucional/" + vCopiaPagina.Substring(12, vFinal - 12);
                    return vLink;
                    break;
                case "XBRL":
                    vInicio = vPagina.LastIndexOf("&desc_archivo=Estados financieros (XBRL)&tipo_archivo=XBRL\">Estados financieros (XBRL) </a>");
                    if (vInicio == -1)
                        return "";
                    vCopiaPagina = vPagina.Substring(0, vInicio);
                    vInicio = vCopiaPagina.LastIndexOf("<a href="); //
                    vCopiaPagina = vPagina.Substring(vInicio);
                    vFinal = vCopiaPagina.IndexOf("\">Estados financieros (XBRL) </a>");
                    vLink = @"https://www.cmfchile.cl/institucional/" + vCopiaPagina.Substring(12, vFinal - 12);
                    return vLink;
                    break;
            }
            return "asf";
        }

        public static void ComprimeCarpetas(string ruta, string rutaSalida)
        {
            if (!Directory.Exists(ruta))
            {
                Console.WriteLine("NO existe directorio " + ruta);
                Environment.Exit(-1);
            }

            if (!ruta.EndsWith("\\"))
                ruta += "\\";

            if (!rutaSalida.EndsWith("\\"))
                rutaSalida += "\\";

            foreach (string vEmpresaPeriodo in Directory.GetDirectories(ruta))
            {
                string proceso = PathSistema + @"dbax_central\bin\zip.exe";
                string parametros = @"-Djr9 " + rutaSalida + vEmpresaPeriodo.Substring(vEmpresaPeriodo.LastIndexOf("\\") + 1) + ".zip " + vEmpresaPeriodo + "\\*.*";
                Ejecuta_Proceso_DOS(proceso, parametros);
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

        public static void DownloadFile(string url, string filePath)
        {
            string vLink = HttpUtility.HtmlDecode(url);
            vLink = Uri.EscapeUriString(vLink);
            string result = "";

            try
            {
                Log.putLog("Entrando a DownloadFile " + "--user-agent 'Mozilla/6.0' --output \"" + filePath + "\" \"" + vLink + "\""); //Borrar
                Process procesoMail = new Process();
                procesoMail.StartInfo.FileName = @"C:\DBNeT\dbax_central\bin\curl.exe";
                procesoMail.StartInfo.Arguments = "--user-agent 'Mozilla/6.0' --output \"" + filePath + "\" \"" + vLink + "\"";
                procesoMail.Start();
                procesoMail.WaitForExit();

                
            }
            catch (Exception ex)
            {
                Log.putLog("Error al procesar curl: " + ex.Message);
                Log.putLog("Stack : " + ex.StackTrace);
                Log.putLog("InnerException : " + ex.InnerException);             
            }

            Log.putLog("Salida OK DownloadFile"); //Borrar

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
                    vFileName = PathSpider + "\\log\\" + cmd;
                }
                catch (Exception ex)
                {
                    try
                    {
                        string[] cmds = Environment.GetCommandLineArgs();
                        string cmd = cmds[0].Split('\\')[cmds[0].Split('\\').Length - 1];
                        cmd = cmd.Replace(".exe", ".log");

                        vFileName = PathSpider + "\\log\\" + cmd;
                    }
                    catch
                    {
                        vFileName = PathSpider + "\\log\\dbnet.log";
                        Console.WriteLine(ex.Message);
                    }
                }

                using (System.IO.TextWriter streamWriter = new System.IO.StreamWriter(vFileName, true))
                {
                    streamWriter.WriteLine(vFecha + pTexto);
                    //Console.WriteLine(vFecha + pTexto);
                }

                Console.WriteLine(vFecha + pTexto);
            }
        }
    }
}
