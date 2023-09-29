using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace dbnet.WS_GXPrisma
{
    /// <summary>
    /// Descripción breve de Service1
    /// </summary>
    [WebService(Namespace = "http://www.dbnet.cl/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // Para permitir que se llame a este servicio Web desde un script, usando ASP.NET AJAX, quite la marca de comentario de la línea siguiente. 
    // [System.Web.Script.Services.ScriptService]
    public class WS_GXPrisma : System.Web.Services.WebService
    {
        GuardarXBRL vGuarXBRL = new GuardarXBRL();
        Conexion con = new Conexion().CrearInstancia();
        ComparacionXBRL vComp = new ComparacionXBRL();
        MantencionParametros para = new MantencionParametros();
        public string query = "";

        [WebMethod]
        public string EnvioXblrPrisma(string vXbrlBs64, string vNombArch, string vCodiUsua, string dbgx_empr, string dbgx_corr, string dbgx_vers)
        {
            string vRutaTempW = "";
            vRutaTempW = para.getPathWebb();
            if (!vRutaTempW.EndsWith(Path.DirectorySeparatorChar.ToString()))
            {
                vRutaTempW += Path.DirectorySeparatorChar.ToString();
            }

            vRutaTempW += "temp\\" + vCodiUsua + "\\";
            if (!Directory.Exists(vRutaTempW))
            {
                Directory.CreateDirectory(vRutaTempW);
            }
            byte[] contenido = vComp.DecodificarArchivoBytes(vXbrlBs64);
            vComp.guardaByteArchivo(vRutaTempW + vNombArch, contenido);
            vGuarXBRL.CargarXBRLExte("1", "1", vCodiUsua, vRutaTempW, vNombArch, true, dbgx_empr, dbgx_corr, dbgx_vers);
            return "s";
        }
        [WebMethod]
        public DataSet ObtenerEstadoCarga(string vCodiEmpr, string vCorrInst, string vFechCarg, string vCodiUsua, string pDbgxEmpr, string pDbgxCorr, string pDbgxVers)
        {
            DataSet ds= new DataSet();
            DataTable dt = new DataTable();
            ds.Tables.Add(vGuarXBRL.GetEmpresaEstadoCargExteVers("1", "1", vCodiEmpr, vCorrInst, vFechCarg, vCodiUsua, pDbgxEmpr, pDbgxCorr, pDbgxVers));
            return ds;
        }
        [WebMethod]
        public string ObtenerHTMLBs64(string vCodiEmpr, string vCorrInst)
        {
            string st = vGuarXBRL.GetBase64HTMLExte(vCodiEmpr, vCorrInst);
            return st;
        }
    }
}