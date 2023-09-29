using System;
using System.Linq;
using System.Text;
using System.IO;
using System.Data;
using System.Diagnostics;
using System.Data.SqlClient;
using System.Xml;
using DbnetWebLibrary;
using System.Net;
//using System.Net.Mail;

namespace DescargaArchivos1
{
    class Program
    {
        static System.Data.DataRow drInfo;
        static private int MAXCOL = 10;
        static private string vFechaHora;
        static void Main(string[] args)
        {
            try
            {
                vFechaHora = System.DateTime.Now.ToString().Replace(":","").Replace("/","").Replace(" ","_");
                #region CLCS
                if (args[2] == "CS")
                {
                    
                    DataTable dtInfo = new System.Data.DataTable();
                    string sXBRL64;
                    Conexion con = new Conexion().CrearInstancia();

                    ComparacionXBRL vComp = new ComparacionXBRL();
                    RescateDeConceptos conc = new RescateDeConceptos();
                    for (int i = 0; i < MAXCOL; i++)
                        dtInfo.Columns.Add(i.ToString());

                    StreamReader reader = new StreamReader(args[1].ToString(), Encoding.GetEncoding("iso8859-1"));
                    string linea = reader.ReadLine();
                    string lineaAcum = "";
                    int swTexto = 0;
                    int numeLine = 0;
                    while (linea != null)
                    {
                        if (linea.Length == 0)
                        {
                            if (swTexto == 1)
                                lineaAcum = lineaAcum + '\n';
                            else
                            {
                                drInfo = dtInfo.NewRow();
                                dtInfo.Rows.Add(drInfo);
                            }

                            linea = reader.ReadLine();
                            numeLine++;

                            if (linea != null)
                                linea = linea.Replace("'", string.Empty);
                        }
                        else if (linea[linea.Length - 1] != ';' && (swTexto == 0 || linea.Split(';').Length < 3))
                        {
                            if (swTexto == 1)
                                linea = linea.Replace(";", "::");
                            else
                            {
                                string[] tmps = linea.Split(';');
                                string ultimo = tmps[tmps.Length - 1];
                                if (ultimo[0] == '"')
                                    swTexto = 1;
                                else
                                    linea = linea + ";";
                            }
                            if (swTexto == 1)
                            {
                                lineaAcum = lineaAcum + '\n' + linea;
                                linea = reader.ReadLine().Replace("'", string.Empty);
                            }
                        }
                        else
                        {
                            if (swTexto == 1)
                            {
                                linea = lineaAcum + '\n' + linea;
                                lineaAcum = "";
                                swTexto = 0;
                            }
                            string[] campos = linea.Split(';');
                            int largoCampos = campos.Length;

                            drInfo = dtInfo.NewRow();
                            for (int i = 0; i < largoCampos && i < MAXCOL; i++)
                            {

                                drInfo[i] = campos[i];
                            }

                            dtInfo.Rows.Add(drInfo);

                            linea = reader.ReadLine();
                            numeLine++;
                        }
                    }
                    reader.Close();

                    for (int i = 0; i < dtInfo.Rows.Count; i++)
                    {
                        if (dtInfo.Rows[i][1].ToString().Length > 0)
                        {
                            dtInfo.Rows[i][7] = dtInfo.Rows[i][7].ToString().Replace("%rut%", dtInfo.Rows[i][1].ToString().Substring(0, dtInfo.Rows[i][1].ToString().IndexOf("-")));
                            dtInfo.Rows[i][7] = dtInfo.Rows[i][7].ToString().Replace("%tipo%", dtInfo.Rows[i][4].ToString());
                            dtInfo.Rows[i][7] = dtInfo.Rows[i][7].ToString().Replace("%periodo%", args[0]);
                            dtInfo.Rows[i][7] = dtInfo.Rows[i][7].ToString().Replace("%tipo1%", dtInfo.Rows[i][5].ToString());

                            dtInfo.Rows[i][8] = dtInfo.Rows[i][8].ToString().Replace("%rut%", dtInfo.Rows[i][1].ToString().Substring(0, dtInfo.Rows[i][1].ToString().IndexOf("-")));
                            dtInfo.Rows[i][8] = dtInfo.Rows[i][8].ToString().Replace("%tipo%", dtInfo.Rows[i][4].ToString());
                            dtInfo.Rows[i][8] = dtInfo.Rows[i][8].ToString().Replace("%periodo%", args[0]);
                            dtInfo.Rows[i][8] = dtInfo.Rows[i][8].ToString().Replace("%tipo1%", dtInfo.Rows[i][5].ToString());
                        }
                    }

                    string vPathCentral = "";
                    try
                    {
                        Microsoft.Win32.RegistryKey key = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("Software\\DBNeT\\Prisma\\CHL", false);
                        vPathCentral = key.GetValue("pathCentral").ToString();
                    }
                    catch(Exception ex)
                    {
                        Console.ForegroundColor = ConsoleColor.Yellow;
                        Console.WriteLine("***** No se pudo obtener el valor para Software\\DBNeT\\Prisma\\CHL\\pathCentral en el registro");
                        Console.WriteLine(ex.Message);
                        Console.WriteLine(ex.StackTrace);
                        Console.ForegroundColor = ConsoleColor.Gray;

                        vPathCentral = "C:\\DBNeT\\dbax_central\\";
                        //DbnetGlobal.Path = Path.GetFullPath("setting.config");
                    }

                    Console.WriteLine("La ruta vPathCentral obtenida es" + vPathCentral);

                    //ServicePointManager.Expect100Continue = true;
                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                    //ServicePointManager.ServerCertificateValidationCallback =
                    //   new RemoteCertificateValidationCallback(
                    //        delegate
                    //        { return true; }
                    //    );

                    StreamWriter archivoInsert = new StreamWriter(vPathCentral + @"out\INS_" + args[0] + "_CS.sql",true);
                    using (System.Net.WebClient Client = new System.Net.WebClient())
                    {
                        
                        for (int i = 0; i < dtInfo.Rows.Count; i++)
                        {
                            //Si la línea del CSV no está en blanco
                            if (dtInfo.Rows[i][1].ToString().Length > 0)
                            {
                                string NombCuadroTmp = dtInfo.Rows[i][7].ToString().Substring(dtInfo.Rows[i][7].ToString().IndexOf("archivo=") + 8);

                                NombCuadroTmp = NombCuadroTmp.Substring(0, NombCuadroTmp.IndexOf("&&rut="));

                                string nombXbrlTmp = dtInfo.Rows[i][8].ToString().Substring(dtInfo.Rows[i][8].ToString().IndexOf("archivo=") + 8);
                                nombXbrlTmp = nombXbrlTmp.Substring(0, nombXbrlTmp.IndexOf("&&rut="));

                                string directorioTmp = vPathCentral + @"out\" + args[0] + "\\" + dtInfo.Rows[i][1].ToString().Substring(0, dtInfo.Rows[i][1].ToString().IndexOf("-")) + dtInfo.Rows[i][4].ToString() + "_" + args[0] + "\\";

                                if (!Directory.Exists(directorioTmp))
                                    Directory.CreateDirectory(directorioTmp);
                                try
                                {
                                    Console.WriteLine("Descargando " + dtInfo.Rows[i][7].ToString());

                                    Process procesoMail = new Process();
                                    procesoMail.StartInfo.FileName = vPathCentral + @"bin\curl.exe";
                                    procesoMail.StartInfo.Arguments = "--user-agent 'Mozilla/6.0' --output " + directorioTmp + NombCuadroTmp + " \"" + dtInfo.Rows[i][7].ToString() + "\"";

                                    Console.ForegroundColor = ConsoleColor.Green;
                                    Console.WriteLine(procesoMail.StartInfo.FileName);
                                    Console.WriteLine(procesoMail.StartInfo.Arguments);
                                    Console.ForegroundColor = ConsoleColor.Gray;

                                    procesoMail.Start();
                                    procesoMail.WaitForExit();

                                    //Client.DownloadFile(dtInfo.Rows[i][7].ToString(), directorioTmp + NombCuadroTmp);
                                }
                                catch (Exception ex)
                                {
                                    Console.ForegroundColor = ConsoleColor.Red;
                                    Console.WriteLine(ex.Message);
                                    Console.WriteLine(ex.StackTrace);
                                    Console.WriteLine(ex.InnerException);
                                    Environment.Exit(-1);
                                }
                                FileInfo FileProp = new FileInfo(directorioTmp + NombCuadroTmp);

                                long FileLeng = FileProp.Length;
                                if (FileLeng < 100)
                                {
                                    System.Threading.Thread.Sleep(1000);
                                    Console.ForegroundColor = ConsoleColor.Yellow;
                                    Console.WriteLine("El largo del archivo es " + FileLeng);
                                    Console.ForegroundColor = ConsoleColor.Gray;

                                    Log.putLog("Eliminando " + directorioTmp + NombCuadroTmp, true, vFechaHora);
                                    File.Delete(directorioTmp + NombCuadroTmp);

                                    Process procesoMail = new Process();
                                    procesoMail.StartInfo.FileName = vPathCentral + @"bin\curl.exe";
                                    procesoMail.StartInfo.Arguments = "--user-agent 'Mozilla/6.0' --output " + directorioTmp + NombCuadroTmp.Replace(".xls", ".xlsx") + " \"" + dtInfo.Rows[i][7].ToString().Replace(".xls", ".xlsx") + "\"";
                                    procesoMail.Start();
                                    procesoMail.WaitForExit();

                                    //Client.DownloadFile(dtInfo.Rows[i][7].ToString().Replace(".xls", ".xlsx"), directorioTmp + NombCuadroTmp.Replace(".xls", ".xlsx"));

                                    FileProp = new FileInfo(directorioTmp + NombCuadroTmp.Replace(".xls", ".xlsx"));
                                    FileLeng = FileProp.Length;
                                    if (FileLeng < 100)
                                    {
                                        System.Threading.Thread.Sleep(1000);
                                        File.Delete(directorioTmp + NombCuadroTmp.Replace(".xls", ".xlsx"));
                                    }
                                }

                                try
                                {
                                    Console.WriteLine("Descargando " + dtInfo.Rows[i][8].ToString());

                                    Process procesoMail = new Process();
                                    procesoMail.StartInfo.FileName = vPathCentral + @"bin\curl.exe";
                                    procesoMail.StartInfo.Arguments = "--user-agent 'Mozilla/6.0' --output " + directorioTmp + "Estados_financieros_(XBRL)" + nombXbrlTmp + " \"" + dtInfo.Rows[i][8].ToString() + "\"";
                                    procesoMail.Start();
                                    procesoMail.WaitForExit();

                                    //Client.DownloadFile(dtInfo.Rows[i][8].ToString(), directorioTmp + "Estados_financieros_(XBRL)" + nombXbrlTmp);
                                }
                                catch (Exception ex)
                                {
                                    Console.ForegroundColor = ConsoleColor.Red;
                                    Console.WriteLine(ex.Message);
                                    Console.WriteLine(ex.StackTrace);
                                    Console.WriteLine(ex.InnerException);
                                    Environment.Exit(-1);
                                }
                                FileProp = new FileInfo(directorioTmp + "Estados_financieros_(XBRL)" + nombXbrlTmp);
                                string NombXBRL = directorioTmp + "Estados_financieros_(XBRL)" + nombXbrlTmp;
                                FileLeng = FileProp.Length;
                                if (FileLeng < 100)
                                {
                                    System.Threading.Thread.Sleep(1000);
                                    Log.putLog("Eliminando " + directorioTmp + "Estados_financieros_(XBRL)" + nombXbrlTmp, true, vFechaHora);
                                    File.Delete(directorioTmp + "Estados_financieros_(XBRL)" + nombXbrlTmp);

                                    Process procesoMail = new Process();
                                    procesoMail.StartInfo.FileName = vPathCentral + @"bin\curl.exe";
                                    procesoMail.StartInfo.Arguments = "--user-agent 'Mozilla/6.0' --output " + directorioTmp + "Estados_financieros_(XBRL)" + nombXbrlTmp.Replace(".zip", ".xbrl") + " \"" + dtInfo.Rows[i][7].ToString().Replace(".zip", ".xbrl") + "\"";
                                    procesoMail.Start();
                                    procesoMail.WaitForExit();
                                    //Client.DownloadFile(dtInfo.Rows[i][8].ToString().Replace(".zip", ".xbrl"), directorioTmp + "Estados_financieros_(XBRL)" + nombXbrlTmp.Replace(".zip", ".xbrl"));

                                    FileProp = new FileInfo(directorioTmp + "Estados_financieros_(XBRL)" + nombXbrlTmp.Replace(".zip", ".xbrl"));
                                    FileLeng = FileProp.Length;
                                    if (FileLeng < 100)
                                    {
                                        System.Threading.Thread.Sleep(1000);
                                        File.Delete(directorioTmp + "Estados_financieros_(XBRL)" + nombXbrlTmp.Replace(".zip", ".xbrl"));
                                    }

                                    NombXBRL = directorioTmp + "Estados_financieros_(XBRL)" + nombXbrlTmp.Replace(".zip", ".xbrl");
                                }
                                Log.putLog("Descargando archivo " + NombXBRL, true, vFechaHora);

                                if (Directory.EnumerateFiles(directorioTmp, "*").Count() == 0)
                                {
                                    Log.putLog("Existe el directorio " + directorioTmp + " y está vacío. Se elimina", true, vFechaHora);
                                    System.Threading.Thread.Sleep(1000);
                                    Directory.Delete(directorioTmp);
                                }
                                else
                                {
                                    Log.putLog("No existe el directorio. Se creará", true, vFechaHora);
                                    //Directory.CreateDirectory(directorioTmp);
                                    DirectoryInfo di = new DirectoryInfo(directorioTmp);
                                    string archivos = "";

                                    if (!directorioTmp.EndsWith("\\"))
                                        directorioTmp = directorioTmp + "\\";

                                    foreach (FileInfo fi in di.GetFiles())
                                    {
                                        archivos += directorioTmp + fi + " ";
                                    }

                                    System.Threading.Thread.Sleep(1000);

                                    string vPathBackEnd = "";
                                    try
                                    {
                                        Microsoft.Win32.RegistryKey key = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("Software\\DBNeT\\Prisma\\CHL", false);
                                        vPathBackEnd = key.GetValue("pathBackEnd").ToString();
                                    }
                                    catch
                                    {
                                        vPathBackEnd = "C:\\DBNeT\\dbax\\";
                                        //DbnetGlobal.Path = Path.GetFullPath("setting.config");
                                    }

                                    Process proceso = new Process();
                                    proceso.StartInfo.FileName = vPathBackEnd + "bin\\zip.exe ";
                                    if (directorioTmp.EndsWith("\\"))
                                        directorioTmp = directorioTmp.Substring(0, directorioTmp.Length - 1);

                                    proceso.StartInfo.Arguments = "-jD " + directorioTmp + ".zip " + archivos;
                                    proceso.Start();
                                    proceso.WaitForExit();
                                    //sXBRL64=con.StringEjecutarQuery(
                                    sXBRL64 = con.StringEjecutarQuery(vComp.GetBase64XBRL(dtInfo.Rows[i][1].ToString().Substring(0, dtInfo.Rows[i][1].ToString().IndexOf("-")) + dtInfo.Rows[i][4].ToString(), args[0], NombXBRL.Substring(NombXBRL.LastIndexOf("\\") + 1)));
                                    if (sXBRL64.Length == 0)
                                        sXBRL64 = con.StringEjecutarQuery(vComp.GetBase64XBRL(dtInfo.Rows[i][1].ToString().Substring(0, dtInfo.Rows[i][1].ToString().IndexOf("-")) + dtInfo.Rows[i][4].ToString(), args[0], NombXBRL.Substring(NombXBRL.LastIndexOf("\\") + 1).Remove(NombXBRL.Substring(NombXBRL.LastIndexOf("\\") + 1).LastIndexOf("_"), 2)));

                                    Log.putLog(vComp.GetBase64XBRL(dtInfo.Rows[i][1].ToString().Substring(0, dtInfo.Rows[i][1].ToString().IndexOf("-")) + dtInfo.Rows[i][4].ToString(), args[0], NombXBRL.Substring(NombXBRL.LastIndexOf("\\") + 1)), true, vFechaHora);
                                    Log.putLog("Se obtuvo versión anterior del XBRL desde base de datos, con largo " + sXBRL64.Length, true, vFechaHora);
                                    if (vComp.VerificarXBRL(NombXBRL, sXBRL64))
                                    {

                                        Log.putLog(NombXBRL, true, vFechaHora);
                                        // con.EjecutarQuery(vComp.insInstDocu(dtInfo.Rows[i][1].ToString().Substring(0, dtInfo.Rows[i][1].ToString().IndexOf("-")) + dtInfo.Rows[i][4].ToString(), args[0], "ACT"));
                                        string vInstVers = con.StringEjecutarQuery(conc.getSigPersVersInst(dtInfo.Rows[i][1].ToString().Substring(0, dtInfo.Rows[i][1].ToString().IndexOf("-")) + dtInfo.Rows[i][4].ToString(), args[0]));
                                        Log.putLog("VersInst :" + vInstVers, true, vFechaHora);
                                        string query = "exec prc_create_dbax_tras_arch  'XBRL', 'CL-CS','" + args[0] + "\\" + dtInfo.Rows[i][1].ToString().Substring(0, dtInfo.Rows[i][1].ToString().IndexOf("-")) + dtInfo.Rows[i][4].ToString() + "_" + args[0] + ".zip'," + vInstVers + ",''";
                                        archivoInsert.WriteLine(query);
                                    }
                                }

                                if (Directory.Exists(directorioTmp))
                                    Directory.Delete(directorioTmp, true);
                            }
                        }
                    }
                    archivoInsert.Close();
                #endregion
                }
                else 
                {
                    ComprobarXBRLCI(args[0]);
                }
            }
            catch (Exception ex)
            {
                Log.putLog(ex.Message, true, vFechaHora);
                Log.putLog(ex.StackTrace.ToString(), true, vFechaHora);
                Correo vCorreo = new Correo();
                vCorreo.enviarCorreo("Error en Main\nMensaje de error: " + ex.Message + "\nMensaje de StackTrace " + ex.StackTrace.ToString());
            }
        }
        public static void ComprobarXBRLCI(string vPeriodo)
        {
            
            Conexion con0 = new Conexion().CrearInstancia();

            SqlConnection conCentral;

            XmlDocument xmldoc = new XmlDocument();
            string baseDir = "", configPath="";
            try
            {
                baseDir = System.Web.HttpRuntime.AppDomainAppPath;
                configPath = Path.Combine(baseDir, "settingCentral.config");
                xmldoc.Load(configPath);
            }
            catch
            {
                baseDir = Environment.ExpandEnvironmentVariables("%ProgramFiles%");
                configPath = Path.Combine(baseDir, "DBNeTSrvSetting\\settingCentral.config");
                xmldoc.Load(configPath);
            }
            finally
            {
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

                conCentral = new SqlConnection("Data Source=" + DataServer + ";Initial Catalog=" + DataBase + ";Persist Security Info=True;User ID=" + User + ";Password=" + descPassword + "");
            }

            try
            {
                String query = " select	* " +
                               " from	dbax_arch_pend " +
                               " where	corr_inst = '" + vPeriodo + "'" +
                               " and    fech_carg is null " +
                               " and    fech_svs is not null " +
                               " and    fech_xbrl is not null " +
                               " and    fech_desc is not null " +
                               " order by codi_pers asc";
                con0.declararConexion();
                SqlDataAdapter ada = new SqlDataAdapter(query, con0.con.ConnectionString);
                DataTable dtArchivosPendientes = new DataTable();
                ada.Fill(dtArchivosPendientes);
                con0.CerrarConexion();

                string vPathCentral = "";
                try
                {
                    Microsoft.Win32.RegistryKey key = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("Software\\DBNeT\\Prisma\\CHL", false);
                    vPathCentral = key.GetValue("pathCentral").ToString();
                }
                catch
                {
                    vPathCentral = "C:\\DBNeT\\dbax_central\\";
                    //DbnetGlobal.Path = Path.GetFullPath("setting.config");
                }

                if (dtArchivosPendientes.Rows.Count > 0)
                {
                    //Se decomprimen archivos zip actualizados (dbax_central.dbax_arch_pend) en directorio OUT a directorio TMP para comparar los contenidos del XBRL
                    if (Directory.Exists(vPathCentral + @"out\" + vPeriodo + "_CI"))
                    {
                        //foreach (string vZipEnOut in Directory.GetFileSystemEntries(@"C:\DBNeT\dbax_central\out\" + vPeriodo + "_CI"))
                        for (int i = 0; i < dtArchivosPendientes.Rows.Count; i++)
                        {
                            string vZipEnOut = vPathCentral + @"out\" + vPeriodo + @"_CI\" + dtArchivosPendientes.Rows[i]["codi_pers"].ToString() + "_" + vPeriodo + ".zip";
                            string vRutPeriodo = vZipEnOut.Substring(vZipEnOut.LastIndexOf("\\") + 1).Replace(".zip", "");
                            try
                            {
                                if (!Directory.Exists(vPathCentral + @"tmp\" + vPeriodo + @"_CI\" + vRutPeriodo))
                                    Directory.CreateDirectory(vPathCentral + @"tmp\" + vPeriodo + @"_CI\" + vRutPeriodo);
                                //else
                                //    Ejecuta_Proceso_DOS("del", @"C:\DBNeT\dbax_central\tmp\" + vPeriodo + @"_CI\" + vRutPeriodo + @"\*.*");
                            }
                            catch (Exception ex)
                            {
                                Correo vCorreo = new Correo();
                                vCorreo.enviarCorreo("Error en ComprobarXBRLCI\nOcurrio un problema creando directorio " + Directory.Exists(vPathCentral + @"tmp\" + vPeriodo + @"_CI\" + vRutPeriodo));
                                Log.putLog("Error en ComprobarXBRLCI\nOcurrio un problema creando directorio " + Directory.Exists(vPathCentral+@"tmp\" + vPeriodo + @"_CI\" + vRutPeriodo), true, vFechaHora);
                            }
                            string vProceso = vPathCentral + @"bin\unzip.exe";
                            string vParametros = " -ojqq " + vZipEnOut + @" -d " + vPathCentral + "tmp\\" + vPeriodo + @"_CI\" + vRutPeriodo;
                            Ejecuta_Proceso_DOS(vProceso, vParametros);
                        }
                    }

                    string sXBRL64;
                    string vCodiPers;

                    string vPathTemp = vPathCentral + @"tmp\" + vPeriodo + "_CI";
                    Log.putLog("vPathTemp: " + vPathTemp, true, vFechaHora);

                    Conexion con = new Conexion().CrearInstancia();
                    // Log.putLog(con.conectar.ToString());

                    ComparacionXBRL vComp = new ComparacionXBRL();
                    RescateDeConceptos conc = new RescateDeConceptos();
                    Log.putLog("Se crea StreamWriter para: " + vPathCentral +  @"out\INS_" + vPeriodo + "_CI.sql", true, vFechaHora);
                    StreamWriter archivoInsert = new StreamWriter(vPathCentral + @"out\INS_" + vPeriodo + "_CI.sql", true);

                    Log.putLog("Se encontraron " + Directory.GetFileSystemEntries(vPathTemp).Count() + " archivos", true, vFechaHora);
                    foreach (string vCarp in Directory.GetFileSystemEntries(vPathTemp))
                    {
                        Log.putLog("Proceso directorio: " + vCarp, true, vFechaHora);
                        vCodiPers = vCarp.Substring(vCarp.LastIndexOf("\\") + 1, (vCarp.Length + 1) - vCarp.LastIndexOf("_"));
                        Log.putLog("Procesando " + vCarp + ", empresa " + vCodiPers, true, vFechaHora);
                        foreach (string vFile in Directory.GetFileSystemEntries(vCarp))
                        {
                            //if (vCodiPers == "99598300")
                            //{
                            if (vFile.ToLower().EndsWith(".zip") || vFile.ToLower().EndsWith(".xbrl") || vFile.Contains("Estados_financieros_(XBRL)"))
                            {
                                Log.putLog("Procesando " + vFile, true, vFechaHora);

                                FileInfo FileProp = new FileInfo(vFile);

                                sXBRL64 = con.StringEjecutarQuery(vComp.GetBase64XBRL(vCodiPers, vPeriodo, vFile.Substring(vFile.LastIndexOf("\\") + 1)));
                                Log.putLog("Se obtuvo versión anterior del XBRL desde base de datos, con largo " + sXBRL64.Length, true, vFechaHora);

                                /*Si el archivo es de un largo aceptable y al mismo tiempo es distinto a lo almacenado en la base de datos, se procesa.*/
                                //if(1==1)
                                if (FileProp.Length > 100 && vComp.VerificarXBRL(vFile, sXBRL64))
                                {
                                    Log.putLog(vComp.GetBase64XBRL(vCodiPers, vPeriodo, vFile.Substring(vFile.LastIndexOf("\\") + 1)), true, vFechaHora);

                                    Log.putLog("Largo en DB: " + vComp.CodificarArchivo(vFile).Length.ToString(), true, vFechaHora);
                                    Log.putLog("Largo en archivo descargado: " + sXBRL64.Length.ToString(), true, vFechaHora);

                                    Log.putLog("La empresa " + vCodiPers + " en el periodo " + vPeriodo + " tiene cambios en el archivo XBRL", true, vFechaHora);
                                    // con.EjecutarQuery(vComp.insInstDocu(dtInfo.Rows[i][1].ToString().Substring(0, dtInfo.Rows[i][1].ToString().IndexOf("-")) + dtInfo.Rows[i][4].ToString(), args[0], "ACT"));
                                    //string vInstVers = con.StringEjecutarQuery(conc.getSigPersVersInst(vCodiPers, vPeriodo));
                                    
                                    conCentral.Open();
                                    SqlCommand Command = new SqlCommand();
                                    Command.Connection = conCentral;
                                    query = "select isnull(max(vers_arch),0) + 1 from dbax_tras_arch where path_arch like '" + vPeriodo + "_CI\\" + vCodiPers + "_" + vPeriodo + "%'";
                                    Command.CommandText = query;
                                    string vInstVers = Command.ExecuteScalar().ToString();
                                    conCentral.Close();

                                    Log.putLog("VersInst :" + vInstVers, true, vFechaHora);

                                    query = "exec prc_create_dbax_tras_arch  'XBRL', 'CL-CI','" + vPeriodo + "_CI\\" + vCodiPers + "_" + vPeriodo + ".zip','" + vInstVers + "','" + FileProp.LastWriteTime.ToString() + "'";
                                    archivoInsert.WriteLine(query);
                                }
                                else
                                {
                                    query = "select isnull(max(1),0) from dbax_tras_arch " +
                                                    "where path_arch like '" + vPeriodo + "%" + vCodiPers + "%' ";
                                    conCentral.Open();
                                    SqlCommand Command = new SqlCommand();
                                    Command.Connection = conCentral;
                                    Command.CommandText = query;
                                    string vTemp = Command.ExecuteScalar().ToString();
                                    conCentral.Close();
                                    if (vTemp == "0")
                                    {
                                        query = "INSERT INTO dbax_tras_arch (codi_arch,tipo_arch,path_arch,vers_arch, codi_taxo, fech_envi) " +
                                                "select max(codi_arch)+1 , 'XBRL', '" + vPeriodo + "_CI\\" + vCodiPers + "_" + vPeriodo + ".zip', 1, 'CL-CI', '" + FileProp.LastWriteTime.ToString() + "' " +
                                                "from dbax_tras_arch " +
                                                "where not exists (	select 1  " +
                                                "                    from dbax_tras_arch  " +
                                                "                    where path_arch = '" + vPeriodo + "_CI\\" + vCodiPers + "_" + vPeriodo + ".zip' " +
                                                "                    and   vers_arch = 1)  " +
                                                "having count(*) > 1 ";
                                        conCentral.Open();
                                        Command = new SqlCommand();
                                        Command.Connection = conCentral;
                                        Command.CommandText = query;
                                        Command.ExecuteNonQuery();
                                        conCentral.Close();

                                        Log.putLog("La empresa " + vCodiPers + " en el periodo " + vPeriodo + " NO tiene cambios en el archivo XBRL. Se insertó registro en central.", true, vFechaHora);

                                        //ASC = archivo sin cambios
                                        con0.AbrirConexion();
                                        Command = new SqlCommand();
                                        Command.Connection = con0.con;
                                        query = " exec SP_AX_updArchPend " + vPeriodo + ",'" + vCodiPers + "','DEL'";
                                        Command.CommandText = query;
                                        Command.ExecuteNonQuery();
                                        con0.CerrarConexion();
                                    }
                                    else
                                    {
                                        query = "update dbax_tras_arch " +
                                                "set    fech_envi = '" + FileProp.LastWriteTime + "' " +
                                                "where     path_arch like '" + vPeriodo + "%" + vCodiPers + "%' " +
                                                "and		 vers_arch = (select max(vers_arch) from dbax_tras_arch " +
                                                "                        where     path_arch like '" + vPeriodo + "%" + vCodiPers + "%') ";
                                        conCentral.Open();
                                        Command = new SqlCommand();
                                        Command.Connection = conCentral;
                                        Command.CommandText = query;
                                        Command.ExecuteNonQuery();
                                        conCentral.Close();
                                        Log.putLog("La empresa " + vCodiPers + " en el periodo " + vPeriodo + " NO tiene cambios en el archivo XBRL. Se actualizó fecha en central.", true, vFechaHora);

                                        //ASC = archivo sin cambios
                                        con0.AbrirConexion();
                                        Command = new SqlCommand();
                                        Command.Connection = con0.con;
                                        query = " exec SP_AX_updArchPend " + vPeriodo + ",'" + vCodiPers + "','DEL'";
                                        Command.CommandText = query;
                                        Command.ExecuteNonQuery();
                                        con0.CerrarConexion();
                                    }
                                }
                            }
                        }
                    }
                    archivoInsert.Close();
                    Log.putLog("Eliminando carpeta: " + vPathTemp, true, vFechaHora);
                    Directory.Delete(vPathTemp, true);
                }
                else
                {
                    Log.putLog("No existen archivos pendientes para el periodo " + vPeriodo, true, vFechaHora);
                }
            }
            catch (Exception ex)
            {
                Log.putLog("Mensaje de error: " + ex.Message + "\nMensaje de StackTrace " + ex.StackTrace.ToString(), true, vFechaHora);
                Correo vCorreo = new Correo();
                vCorreo.enviarCorreo("Mensaje de error: " + ex.Message + "\nMensaje de StackTrace " + ex.StackTrace.ToString() + "\n " + con0.con.ConnectionString + " " + conCentral.ConnectionString);
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

                Log.putLog("Comando Ejecutado : " + proceso + " " + parametros, true, vFechaHora);
                
                System.Diagnostics.Process p = System.Diagnostics.Process.Start(pinfo);
                p.WaitForExit();
                Log.putLog("Proceso Terminado\n", true, vFechaHora);
            }
            catch (Exception ex)
            {
                salida += ex.Message;
                Correo vCorreo = new Correo();
                vCorreo.enviarCorreo("Error en funcion Ejecuta_Proceso_DOS\nMensaje de error: " + ex.Message + "\nMensaje de StackTrace " + ex.StackTrace.ToString());
                Log.putLog("Error en funcion Ejecuta_Proceso_DOS\nMensaje de error: " + ex.Message + "\nMensaje de StackTrace " + ex.StackTrace.ToString(), true, vFechaHora);
            }
            return salida;
        }
            //public static void enviarCorreo(String vMensaje)
            //{
            //    MailMessage mail = new MailMessage("alertaprisma@prismafinanciero.com", "mauricio.ahumada@dbnetcorp.com");
            //    SmtpClient client = new SmtpClient();
            //    client.Port = 25;
            //    client.DeliveryMethod = SmtpDeliveryMethod.Network;
            //    client.UseDefaultCredentials = false;
            //    client.Credentials = new System.Net.NetworkCredential("demo@smtp.suiteelectronica.com", "demosuite");
            //    client.Host = "smtp.suiteelectronica.com";
            //    mail.Subject = "Alerta de operación - PrismaFinanciero.";
            //    mail.Body = vMensaje;
            //    client.Send(mail);
            //}

        }
}
