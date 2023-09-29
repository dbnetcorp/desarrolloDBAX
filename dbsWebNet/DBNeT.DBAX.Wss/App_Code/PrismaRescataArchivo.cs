using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Data;
using DbnetWebLibrary;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

[WebService(Namespace = "http://www.prismafinanciero.com/PrismaRescataArchivo")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]

public class ServicioPrismaRescata : WebService
{
    OleDbConnection conn = new OleDbConnection();
    private static string p_archivo_log = "";
    private static string p_codi_usua = "";
    private static string p_pass_usua = "";
    private static string p_base_dato = "";
    private static string p_serv_name = "";
    private static string p_path_out_central = "";
    public ServicioPrismaRescata()
    {
        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
        p_codi_usua = ConfigurationManager.AppSettings.Get("User");
        p_pass_usua = ConfigurationManager.AppSettings.Get("Password");
        p_base_dato = ConfigurationManager.AppSettings.Get("DataBase");
        p_serv_name = ConfigurationManager.AppSettings.Get("DataServer");
        p_archivo_log = ConfigurationManager.AppSettings.Get("RutaArchivoLog");
        conn.ConnectionString = @"Provider=SQLOLEDB.1;Persist Security Info=False;User ID=" + p_codi_usua + ";Password=" + p_pass_usua + ";Initial Catalog=" + p_base_dato + ";Data Source=" + p_serv_name + ";Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=VICTOR;Use Encryption for Data=False;Tag with column collation when possible=False";

        p_path_out_central = ConfigurationManager.AppSettings.Get("PathOutCentral");
    }

    [WebMethod]
    public RespuestaArchivos getArchivos(string pCodi_usua, string pPass_usua, string pVers_tras)
    {
        RespuestaArchivos res = new RespuestaArchivos();
        try
        {
            if (!Directory.Exists(Path.GetDirectoryName(p_archivo_log)))
            {
                res.Mensaje = "p_archivo_log mal definido";
                res.Estado = "ERR";
                return res;
            }

            //using (TextWriter streamWriter = new StreamWriter(p_archivo_log, true))
            //{
            //    string vFecha = DateTime.Now.Year.ToString("0000") + "-" +
            //                DateTime.Now.Month.ToString("00") + "-" +
            //                DateTime.Now.Day.ToString("00") + " " +
            //                DateTime.Now.Hour.ToString("00") + ":" +
            //                DateTime.Now.Minute.ToString("00") + ":" +
            //                DateTime.Now.Second.ToString("00") + " ";

            //    streamWriter.WriteLine("Conexion realizada correctamente");
            //}

            DataTable dt = DbnetTool.Ejecuta_Select(conn, "dbo.prc_dbax_resc_arch '" + pCodi_usua + "', '" + pPass_usua + "'");
            int cant = dt.Rows.Count;
            res.VersTras = "1";
            res.CantArch = cant.ToString();
            res.CorrSess = "999999";

            res.Archivos = new ArchivoXbrl[cant];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                res.Archivos[i] = new ArchivoXbrl(dt.Rows[i]["codi_arch"].ToString(), dt.Rows[i]["path_arch"].ToString());
            }

            res.Estado = "OK";
            return res;
        }
        catch (Exception ex)
        {
            return new RespuestaArchivos("ERR", ex.Message);
        }
    }

    [WebMethod]
    public RespuestaXBRL getArchivo(string pCorr_sess, string pCodi_usua, string pCodi_arch, string pNomb_arch)
    {
        RespuestaXBRL res = new RespuestaXBRL();
        try
        {
            res.ArchivoBytes = File.ReadAllBytes(p_path_out_central + pNomb_arch);

            using (TextWriter streamWriter = new StreamWriter(p_archivo_log, true))
            {
                string vFecha = DateTime.Now.Year.ToString("0000") + "-" +
                            DateTime.Now.Month.ToString("00") + "-" +
                            DateTime.Now.Day.ToString("00") + " " +
                            DateTime.Now.Hour.ToString("00") + ":" +
                            DateTime.Now.Minute.ToString("00") + ":" +
                            DateTime.Now.Second.ToString("00") + " ";

                streamWriter.WriteLine(vFecha + conn.ConnectionString);
            }

            DbnetTool.Ejecuta_Select(conn, "insert into dbax_tras_usua (codi_usua, codi_arch, fech_carg) values ('" + pCodi_usua + "','" + pCodi_arch + "', getdate())");
            res.Estado = "OK";
            return res;
        }
        catch (Exception ex)
        {
            return new RespuestaXBRL("ERR",ex.Message);
        }
    }
}

public class RespuestaArchivos
{
    public string Estado;
    public string Mensaje;
    public string CorrSess;
    public string VersTras;
    public string CantArch;
    public ArchivoXbrl[] Archivos;

    public RespuestaArchivos() { }
    public RespuestaArchivos(string pEstado, string pMensaje) { Estado = pEstado; Mensaje = pMensaje; }
}

public class ArchivoXbrl
{
    public string CodiArch;
    public string ArchXbrl;

    public ArchivoXbrl() { }
    public ArchivoXbrl(string pCodiArch, string pPathArch)
    {
        CodiArch = pCodiArch;
        ArchXbrl = pPathArch;
    }
}

public class RespuestaXBRL
{
    public string Estado;
    public string Mensaje;
    public byte[] ArchivoBytes;

    public RespuestaXBRL() { }
    public RespuestaXBRL(string pEstado, string pMensaje) { Estado = pEstado; Mensaje = pMensaje; }
}