using System;
using System.Collections.Specialized;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Xml.Linq;
using System.IO;
using System.Xml;
using DBNeT.DBAX.Controlador;
using System.Text;

public partial class GeneracionExcel
{
    Conexion con = new Conexion().CrearInstancia();
    RescateDeConceptos modConc = new RescateDeConceptos();
    GeneracionHTML modHtml = new GeneracionHTML();
    ModeloMantencionCntx Contextos = new ModeloMantencionCntx();
    ModeloGruposEmpresas Empr = new ModeloGruposEmpresas();
    ComparacionXBRL modComp = new ComparacionXBRL();
    MantencionIndicadores vModIndi = new MantencionIndicadores();
    DbaxEmpresaPeriodoController vModEmp = new DbaxEmpresaPeriodoController();

    /// <summary>
    /// Obtiene descripcion y formato de conceptos para un informe particular
    /// </summary>
    /// 
    public DataSet getInfoDescConc(string CodiEmex, string CodiEmpr, string CodiInfo, string TipoInfo)
    {
        //return con.TraerResultados0(modConc.getInfoDescConc(CodiEmex, CodiEmpr, CodiInfo));
        return con.TraerResultados0(modConc.getInfoDescConc(CodiEmex, CodiEmpr, CodiInfo, TipoInfo));
    }
    public DataSet getInfoDescConcConTipos(string CodiEmex, string CodiEmpr, string CodiInfo, string TipoInfo)
    {
        //return con.TraerResultados0(modConc.getInfoDescConc(CodiEmex, CodiEmpr, CodiInfo));
        return con.TraerResultados0(modConc.getInfoDescConcConTipos(CodiEmex, CodiEmpr, CodiInfo, TipoInfo));
    }
    /// <summary>
    /// Obtiene las empresas por filtro, grupo, segmento y tipo
    /// </summary>
    public DataSet GetEmpresas(string CodiEmex, string CodiEmpr, string CorrInst, string Cadena, string Grupo, string Segmento, string Tipo, string parametro)
    {
        return con.TraerResultados0(Empr.GetEmpresas(CodiEmex, CodiEmpr, CorrInst, Cadena, Grupo, Segmento, Tipo, parametro));
    }
    /// <summary>
    /// Obtiene las empresas por filtro, grupo, segmento y tipo
    /// </summary>
    public DataSet GetEmpresas(string CodiEmex, string CodiEmpr, string CorrInst, string Cadena, string Grupo, string Segmento, string Tipo, string parametro, string TipoDeCarga)
    {
        return con.TraerResultados0(Empr.GetEmpresas(CodiEmex, CodiEmpr, CorrInst, Cadena, Grupo, Segmento, Tipo, parametro, TipoDeCarga));
    }
    /// <summary>
    /// Obtiene las empresas por filtro, grupo, segmento, tipo y usuario. Se utiliza para traer las empresas externas cargados por un usuario
    /// </summary>
    public DataSet GetEmpresas(string CodiEmex, string CodiEmpr, string CorrInst, string Cadena, string Grupo, string Segmento, string Tipo, string parametro, string TipoDeCarga, string CargUsua)
    {
        return con.TraerResultados0(Empr.GetEmpresas(CodiEmex, CodiEmpr, CorrInst, Cadena, Grupo, Segmento, Tipo, parametro, TipoDeCarga, CargUsua));
    }
    /// <summary>
    /// Obtiene los contextos y las fechas asociadas para un informe dado
    /// </summary>
    public DataSet getInformesContextos(string CodiEmex, string CodiEmpr, string CorrInst, string CodiInfo)
    {
        return con.TraerResultados0(Contextos.getInformesContextos(CodiEmex, CodiEmpr, CorrInst, CodiInfo));
    }
    public void GeneradorHTML(string ruta, DataTable tabla, string informe)
    {
        modHtml.GeneracionHTML_Informes(ruta, tabla, informe,FileMode.Create,"",3);

    }
    public void GeneradorHTML(string ruta, DataTable tabla, string informe, string vDescInfo, bool vEncabezado, string vCorrInst, string vDescPers)
    {
        modHtml.GeneracionHTML_Informes(ruta, tabla, informe, FileMode.Create, vDescInfo, 3, vEncabezado, vCorrInst, vDescPers);

    }
    public void GeneradorHTMLTranspuesto(string ruta, DataTable tabla, string informe)
    {
        modHtml.GeneracionHTML_InformesTranspuesto(ruta, tabla, informe);

    }
    /// <summary>
    /// Obtiene tabla con reporte para una empresa
    /// </summary>
    /// 
    public DataTable getDatosReporte(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string VersInst, string CodiInfo, string TipoInfo, string CodiMone)
    {
        DataTable dt_Contextos = getInformesContextos(CodiEmex, CodiEmpr, CorrInst, CodiInfo).Tables[0];
        DataTable dt_DescConc = getInfoDescConc(CodiEmex, CodiEmpr, CodiInfo, TipoInfo).Tables[0];
        dt_DescConc = modHtml.getDatosReporte(CodiEmex, CodiEmpr, CodiPers, CorrInst, VersInst, CodiInfo, dt_Contextos, dt_DescConc, CodiMone).Copy();
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene tabla con reporte para una empresa
    /// </summary>
    /// 
    public DataTable getDatosReporteConTipos(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string VersInst, string CodiInfo, string TipoInfo, string CodiMone)
    {
        DataTable dt_Contextos = getInformesContextos(CodiEmex, CodiEmpr, CorrInst, CodiInfo).Tables[0];
        DataTable dt_DescConc = getInfoDescConcConTipos(CodiEmex, CodiEmpr, CodiInfo, TipoInfo).Tables[0];
        dt_DescConc = modHtml.getDatosReporte(CodiEmex, CodiEmpr, CodiPers, CorrInst, VersInst, CodiInfo, dt_Contextos, dt_DescConc, CodiMone).Copy();
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene tabla con reporte para una empresa
    /// </summary>
    /// 
    public DataTable getDatosReporteConTipos(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string VersInst, string CodiInfo, string TipoInfo, string CodiMone, DataTable dtContextosSimples)
    {
        DataTable dt_Contextos = getInformesContextos(CodiEmex, CodiEmpr, CorrInst, CodiInfo).Tables[0];
        DataTable dt_DescConc = getInfoDescConcConTipos(CodiEmex, CodiEmpr, CodiInfo, TipoInfo).Tables[0];
        dt_DescConc = modHtml.getDatosReporte(CodiEmex, CodiEmpr, CodiPers, CorrInst, VersInst, CodiInfo, dt_Contextos, dt_DescConc, CodiMone).Copy();
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene tabla con reporte para varias empresas (recibe una coleccion)
    /// </summary>
    /// 
    public DataTable getDatosReporte(string CodiEmex, string CodiEmpr, StringCollection Empresas, string CorrInst, string CodiCntx, string CodiInfo, string TipoInfo, string TipoTaxo, int nulo, string CodiMone)
    {
        DataTable dt_Contextos = con.TraerResultados0(Contextos.getContextoFechas(CodiEmex, CodiEmpr, CorrInst, CodiCntx)).Tables[0];
        DataTable dt_DescConc = getInfoDescConc(CodiEmex, CodiEmpr, CodiInfo, TipoInfo).Tables[0];
        dt_DescConc = modHtml.getDatosReporte(CodiEmex, CodiEmpr, CodiInfo, CorrInst, dt_DescConc, Empresas, dt_Contextos.Rows[0]["fini_cntx"].ToString(), dt_Contextos.Rows[0]["ffin_cntx"].ToString(),CodiMone).Copy();
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene tabla con reporte para varias empresas (recibe un diccionario)
    /// </summary>
    /// 
    public DataTable getDatosReporte(string CodiEmex, string CodiEmpr, Dictionary<string, string> Empresas, string CorrInst, string CodiCntx, string CodiInfo, string TipoInfo, string CodiMone)
    {
        DataTable dt_Contextos = con.TraerResultados0(Contextos.getContextoFechas(CodiEmex, CodiEmpr, CorrInst, CodiCntx)).Tables[0];
        DataTable dt_DescConc = getInfoDescConc(CodiEmex, CodiEmpr, CodiInfo, TipoInfo).Tables[0];
        dt_DescConc = modHtml.getDatosReporte(CodiEmex, CodiEmpr, CodiInfo, CorrInst, dt_DescConc, Empresas, dt_Contextos.Rows[0]["fini_cntx"].ToString(), dt_Contextos.Rows[0]["ffin_cntx"].ToString(), CodiMone, TipoInfo).Copy();
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene tabla con reporte para una empresa en un contexto en varios períodos
    /// </summary>
    public DataTable getDatosReporte(string CodiEmex, string CodiEmpr, string PeriIni, string PeriFin, string CodiCntx, string CodiInfo, string TipoInfo, string CodiPers, string CodiMone)
    {
        DataTable dt_Periodos = getPeriodosEnRango(PeriIni, PeriFin);
        DataTable dt_DescConc = getInfoDescConc(CodiEmex, CodiEmpr, CodiInfo, TipoInfo).Tables[0];
        dt_DescConc = modHtml.getDatosReporte(CodiEmex, CodiEmpr, CodiCntx, CodiInfo, CodiPers, dt_Periodos, dt_DescConc,CodiMone);
        return dt_DescConc;
    }
    /// <summary>
    /// Obteiene tabla con los periodos comprendidos entre un rango de fechas con formato (MM-AAAA)
    /// </summary>
    public DataTable getPeriodosEnRango(string PeriIni, string PeriFin)
    {
        DataTable dt_Periodos = con.TraerResultados0(Contextos.getPeriRango(PeriIni, PeriFin)).Tables[0];
        return dt_Periodos;
    }
    /// <summary>
    /// Retorna una tabla con una lista de empresas (filtrada) y los documentos reportados por dichas empresas
    /// </summary>
    /// 
    public DataTable getEmpresasDocumentos(string CodiEmex, string CodiEmpr, string CorrInst, string DescPers, string Grupo, string Segmento, string Tipo)
    {
        /*DataTable dt_Contextos = getInformesContextos(CodiEmex, CodiEmpr, CorrInst, CodiInfo).Tables[0];
        DataTable dt_DescConc = getInfoDescConc(CodiEmex, CodiEmpr, CodiInfo).Tables[0];
        dt_DescConc = modHtml.getDatosReporte(CodiEmex, CodiEmpr, CodiPers, CorrInst, VersInst, CodiInfo, dt_Contextos, dt_DescConc).Copy();*/
        DataTable dt = GetEmpresas(CodiEmex, CodiEmpr, CorrInst, DescPers, Grupo, Segmento, Tipo, "E").Tables[0];
        DataTable dtArchivos = getEmpresasDocumentosPorColumna(CodiEmex, CodiEmpr, CorrInst, DescPers, Grupo, Segmento, Tipo, "Análisis_Razonado");
        dt = modHtml.AnexaColumna(dt, dtArchivos, "Anal_Razo");
        dtArchivos = getEmpresasDocumentosPorColumna(CodiEmex, CodiEmpr, CorrInst, DescPers, Grupo, Segmento, Tipo, "Declaración_de_responsabilidad");
        dt = modHtml.AnexaColumna(dt, dtArchivos, "Decl_Resp");
        dtArchivos = getEmpresasDocumentosPorColumna(CodiEmex, CodiEmpr, CorrInst, DescPers, Grupo, Segmento, Tipo, "Estados_financieros_(PDF)");
        dt = modHtml.AnexaColumna(dt, dtArchivos, "Esta_PDF");
        dtArchivos = getEmpresasDocumentosPorColumna(CodiEmex, CodiEmpr, CorrInst, DescPers, Grupo, Segmento, Tipo, "Estados_financieros_(XBRL)");
        dt = modHtml.AnexaColumna(dt, dtArchivos, "Esta_XBRL");
        dtArchivos = getEmpresasDocumentosPorColumna(CodiEmex, CodiEmpr, CorrInst, DescPers, Grupo, Segmento, Tipo, "Hechos_Relevantes");
        dt = modHtml.AnexaColumna(dt, dtArchivos, "Hech_Rele");
        dtArchivos = getEmpresasDocumentosPorColumna(CodiEmex, CodiEmpr, CorrInst, DescPers, Grupo, Segmento, Tipo, "VisualizacionXBRL");
        dt = modHtml.AnexaColumna(dt, dtArchivos, "Visu_XBRL");
        return dt;
    }
    public DataTable getEmpresasDocumentosExt(string CodiEmex, string CodiEmpr, string CorrInst, string DescPers, string Grupo, string Segmento, string Tipo, string UsuaCarg)
    {
        /*DataTable dt_Contextos = getInformesContextos(CodiEmex, CodiEmpr, CorrInst, CodiInfo).Tables[0];
        DataTable dt_DescConc = getInfoDescConc(CodiEmex, CodiEmpr, CodiInfo).Tables[0];
        dt_DescConc = modHtml.getDatosReporte(CodiEmex, CodiEmpr, CodiPers, CorrInst, VersInst, CodiInfo, dt_Contextos, dt_DescConc).Copy();*/
        DataTable dt = GetEmpresas(CodiEmex, CodiEmpr, CorrInst, DescPers, Grupo, Segmento, Tipo, "E", "Externo",UsuaCarg).Tables[0];
        DataTable dtArchivos = getEmpresasDocumentosPorColumna(CodiEmex, CodiEmpr, CorrInst, DescPers, Grupo, Segmento, Tipo, "XBRL_Temporal", "Externo", UsuaCarg);
        dt = modHtml.AnexaColumna(dt, dtArchivos, "xbrl_exte");
        dtArchivos = getEmpresasDocumentosPorColumna(CodiEmex, CodiEmpr, CorrInst, DescPers, Grupo, Segmento, Tipo, "HTML_Completo", "Externo",UsuaCarg);
        dt = modHtml.AnexaColumna(dt, dtArchivos, "visu_html");
        
        return dt;
    }
    /// <summary>
    /// Retorna una tabla con una unica columna con los archivos cargados
    /// </summary>
    /// 
    public DataTable getEmpresasDocumentosPorColumna(string CodiEmex, string CodiEmpr, string CorrInst, string DescPers, string Grupo, string Segmento, string Tipo, string NombDocu)
    {
        return con.TraerResultados0(modHtml.getEmpresasDocumentosPorColumna(CodiEmex, CodiEmpr, CorrInst, DescPers, Grupo, Segmento, Tipo, NombDocu)).Tables[0];
    }
    /// <summary>
    /// Obtiene los informes  de las empresas a generar
    /// </summary>
    /// 
    public DataTable getEmpresasDocumentosPorColumna(string CodiEmex, string CodiEmpr, string CorrInst, string DescPers, string Grupo, string Segmento, string Tipo, string NombDocu, string MaxiVers)
    {
        return con.TraerResultados0(modHtml.getEmpresasDocumentosPorColumna(CodiEmex, CodiEmpr, CorrInst, DescPers, Grupo, Segmento, Tipo, NombDocu,MaxiVers)).Tables[0];
    }
    /// <summary>
    /// Obtiene los informes  de las empresas por usuario (se usa para cargas externas)
    /// </summary>
    /// 
    public DataTable getEmpresasDocumentosPorColumna(string CodiEmex, string CodiEmpr, string CorrInst, string DescPers, string Grupo, string Segmento, string Tipo, string NombDocu, string MaxiVers, string UsuaCarg)
    {
        return con.TraerResultados0(modHtml.getEmpresasDocumentosPorColumna(CodiEmex, CodiEmpr, CorrInst, DescPers, Grupo, Segmento, Tipo, NombDocu, MaxiVers,UsuaCarg)).Tables[0];
    }
    public void ObtenerInfoEmpr(string CodiEmex, string CodiEmpr,string CodiPers,string CorrInst,string VersInst, string IFRS13)
    {
        try
        {
            // DataSet ds = con.TraerResultados0(modConc.ObtenerEmprInfor(CodiPers, CorrInst, VersInst));
            int vCont=99;
            MantencionParametros para = new MantencionParametros();
            ComparacionXBRL vComp = new ComparacionXBRL();
            DataTable ds = getInformesUsables(CodiEmex, CodiEmpr, CodiPers, CorrInst, VersInst, "R", "");

            if (ds.Rows.Count == 0)
                throw new System.Exception("No se encontraron informes usables para esta carga");

            for (int i = 0; i < ds.Rows.Count; i++)
            {
                //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 1");
                //if ((IFRS13 == "true" && ds.Rows[i]["codi_info"].ToString().Equals("pre_cl-ci_ifrs-13_2013-03-28_role-823000|D")))
                if ((!ds.Rows[i]["codi_info"].ToString().Equals("pre_cl-ci_ifrs-13_2013-03-28_role-823000|D")) || (IFRS13.ToUpper() == "TRUE" && ds.Rows[i]["codi_info"].ToString().Equals("pre_cl-ci_ifrs-13_2013-03-28_role-823000|D")))
                {
                    if (i == 0)
                        vCont = 1;
                    else if (i + 1 == ds.Rows.Count)
                    {
                        vCont = 2;
                    }
                    else
                    {
                        vCont = 99;
                    }
                    //if (ds.Rows[i]["codi_info"].ToString().Contains("834120"))
                    //{
                    Console.WriteLine("Generando HTML informe: " + ds.Rows[i]["codi_info"].ToString());
                    Log.putLog("Generando HTML informe: " + ds.Rows[i]["codi_info"].ToString());
                    //if (ds.Rows[i]["codi_info"].ToString() == "pre_cl-cs_cuadro-602_role-906022(2018)|D")
                    //    Console.WriteLine(ds.Rows[i]["codi_info"].ToString());
                                       
                    crear_html(CodiEmex, CodiEmpr, ds.Rows[i]["codi_info"].ToString(), CodiPers, CorrInst, VersInst, vCont);
                    
                    //}
                }
            }
            string sRutaXML = @para.getPathWebb() + @"\librerias\sheets\Reporte" + "_" + CodiPers + "_" + CorrInst + "_" + VersInst + ".html";
            //Log.putLog("Guardando archivo en DB: " + CodiPers + ", " + CorrInst + ", " + VersInst + ", " + vComp.CodificarArchivo(sRutaXML) + ", " + "HTML_Completo_" + ", " + sRutaXML.Substring(sRutaXML.LastIndexOf("\\") + 1) + ", " + "html");
            con.EjecutarQuery(vComp.SetBase64XBRL(CodiPers, CorrInst, VersInst, vComp.CodificarArchivo(sRutaXML), "HTML_Completo_" + sRutaXML.Substring(sRutaXML.LastIndexOf("\\") + 1), "html"));
            File.Delete(sRutaXML);
        }
        catch (Exception ex)
        {
            Log.putLog(ex.Message);
            throw new Exception("Ocurrio un error en metodo ObtenerInfoEmpr." + ex.Message);
        }
    }
    public string ObtenerInfoEmprString(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string VersInst, string IFRS13)
    {
        string vHtml = "";
        string vCodiInfoAnt="";
        bool bDivAbierto = false;
        try
        {
            // DataSet ds = con.TraerResultados0(modConc.ObtenerEmprInfor(CodiPers, CorrInst, VersInst));
            int vCont = 99;
            MantencionParametros para = new MantencionParametros();
            ComparacionXBRL vComp = new ComparacionXBRL();
            MantencionCntx vCntx = new MantencionCntx();

            DataTable dtContextosSimples = vCntx.getContextosPorEmpresaInstanciaVersion(CodiPers, CorrInst, VersInst, "C");
            DataTable dtContextosDimension = vCntx.getContextosPorEmpresaInstanciaVersion(CodiPers, CorrInst, VersInst, "D");

            

            Console.WriteLine(dtContextosSimples.Rows.Count);
            Console.WriteLine(dtContextosDimension.Rows.Count);

            DataTable ds = getInformesUsables(CodiEmex, CodiEmpr, CodiPers, CorrInst, VersInst, "R", "");

            if (ds.Rows.Count == 0)
                throw new System.Exception("No se encontraron informes usables para esta carga");

            vHtml += "<html>";
            vHtml += "<head>";
            vHtml += "<meta http-equiv=\"cache-control\" content=\"no-cache\"/>";
            vHtml += "<link rel=\"StyleSheet\" type=\"text/css\" href=\"test.css\">";

            vHtml += "</head>";
            vHtml += "<body>";

            vHtml += "<script> " +
                    "function mostrarInfo(myDIV) { " +
                    "    var x = document.getElementById(myDIV); " +
                    "    if (x.style.display === \"none\") { " +
                    "        x.style.display = \"block\"; " +
                    "    } else { " +
                    "        x.style.display = \"none\"; " +
                    "    } " +
                    "} " +
                    "</script>";

            for (int i = 0; i < ds.Rows.Count; i++)
            {
                //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 1");
                //if ((IFRS13 == "true" && ds.Rows[i]["codi_info"].ToString().Equals("pre_cl-ci_ifrs-13_2013-03-28_role-823000|D")))
                if ((!ds.Rows[i]["codi_info"].ToString().Equals("pre_cl-ci_ifrs-13_2013-03-28_role-823000|D")) || (IFRS13.ToUpper() == "TRUE" && ds.Rows[i]["codi_info"].ToString().Equals("pre_cl-ci_ifrs-13_2013-03-28_role-823000|D")))
                {
                    if (i == 0)
                        vCont = 1;
                    else if (i + 1 == ds.Rows.Count)
                    {
                        vCont = 2;
                    }
                    else
                    {
                        vCont = 99;
                    }
                    if (ds.Rows[i]["codi_info"].ToString().Contains("pre_cl-cs_nota-1_role-810000(2018)"))
                    {
                        Console.WriteLine("Generando HTML informe: " + ds.Rows[i]["codi_info"].ToString());
                    }
                    Log.putLog("Generando HTML informe: " + ds.Rows[i]["codi_info"].ToString());
                    //if (ds.Rows[i]["codi_info"].ToString() == "pre_cl-cs_cuadro-602_role-906022(2018)|D")
                    //    Console.WriteLine(ds.Rows[i]["codi_info"].ToString());

                    string[] vCTInfo = ds.Rows[i]["codi_info"].ToString().Split('|');

                    if (vCTInfo[0].ToString() != vCodiInfoAnt)
                    {
                        if (bDivAbierto)
                        {
                            vHtml += "</div>";
                        }

                        vHtml += "<br/>";
                        vHtml += "<span id=\"span_" + vCTInfo[0].ToString() + "\" onclick=\"mostrarInfo('div_" + vCTInfo[0].ToString() + "');\">" + ds.Rows[i]["desc_info"].ToString() + "</span>";
                        vHtml += "<div id =\"div_" + vCTInfo[0].ToString() + "\" style=\"display: none;\">";
                        bDivAbierto = true;
                        vCodiInfoAnt = vCTInfo[0].ToString();
                        
                        
                    }
                    vHtml += crear_htmlString(CodiEmex, CodiEmpr, ds.Rows[i]["codi_info"].ToString(), CodiPers, CorrInst, VersInst, vCont, dtContextosSimples, dtContextosDimension);
                }
            }

            para = new MantencionParametros();
            string sRutaXML = @para.getPathWebb() + @"\librerias\sheets\Reporte" + "_" + CodiPers + "_" + CorrInst + "_" + VersInst + ".html";

            Log.putLog("Escribiendo archivo " + sRutaXML);
            modHtml.escribeArchivo(sRutaXML, vHtml);

            //Log.putLog("Guardando archivo en DB: " + CodiPers + ", " + CorrInst + ", " + VersInst + ", " + vComp.CodificarArchivo(sRutaXML) + ", " + "HTML_Completo_" + ", " + sRutaXML.Substring(sRutaXML.LastIndexOf("\\") + 1) + ", " + "html");
            con.EjecutarQuery(vComp.SetBase64XBRL(CodiPers, CorrInst, VersInst, vComp.CodificarArchivo(sRutaXML), "HTML_Completo_" + sRutaXML.Substring(sRutaXML.LastIndexOf("\\") + 1), "html"));
            File.Delete(sRutaXML);
        }
        catch (Exception ex)
        {
            Log.putLog(ex.Message);
            throw new Exception("Ocurrio un error en metodo ObtenerInfoEmpr." + ex.Message);
        }
        return vHtml;
    }
    /// <summary>
    /// Metodo que llama a la generación del html
    /// </summary>
    public void  crear_html(string CodiEmex, string CodiEmpr,string informe, string empresa, string corr_inst, string vers_inst,int vCont)
    {
        try
        {
            string[] vCTInfo;
            string vPrefDime, vCodiDime, vCodiInfo;
            DataTable dt, dtTipoTaxo, dtCodiDime, dt_DimeAxis, dtCodiMemb;
            vCodiInfo = informe.Substring(0, informe.IndexOf("|"));
            MantencionParametros para = new MantencionParametros();
            string sRutaXML = @para.getPathWebb() + @"\librerias\sheets\Reporte" + "_" + empresa + "_" + corr_inst + "_" + vers_inst + ".html";
            vCTInfo = modHtml.getCodiInfoTipo(informe);
            if (vCTInfo[1] == "C")
            {
                dtTipoTaxo = getInforme(CodiEmex, CodiEmpr, vCodiInfo, "C");
                dt = getDatosReporteConTipos(CodiEmex, CodiEmpr, empresa, corr_inst, vers_inst, vCodiInfo, "C", "MONE_LOCA");
                
                modHtml.GeneracionHTML_InformesTextosDiferentes(sRutaXML, dt, vCodiInfo, FileMode.Append, dtTipoTaxo.Rows[0]["desc_info"].ToString(), vCont);
            }
            else
            {
                dtTipoTaxo = getInforme(CodiEmex, CodiEmpr, vCodiInfo, "D");
                dtCodiDime = getDimensionesUsables(CodiEmex, CodiEmpr, vCodiInfo).Tables[0];



                for (int i = 0; i < dtCodiDime.Rows.Count; i++)
                {
                    if (vCodiInfo.Contains("cuadro") && !vCodiInfo.EndsWith("(2017)"))
                    {
                        if (vCodiInfo.EndsWith("(2018)"))
                        {
                            vPrefDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(0, dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":"));
                            vCodiDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":") + 1);
                            dt_DimeAxis = vModEmp.GetEjesDimension(vCodiInfo, vPrefDime, vCodiDime);
                            dtCodiMemb = vModEmp.GetMiembTaxoDimension(empresa, corr_inst, vers_inst, vCodiInfo, dt_DimeAxis.Rows[0]["pref_axis"].ToString(), dt_DimeAxis.Rows[0]["codi_axis"].ToString());
                            foreach (DataRow item in dtCodiMemb.Rows)
                            {
                                dt = new DataTable();
                                dt = vModEmp.GenerarDimensionesCuadros2018(empresa, corr_inst, vers_inst, vCodiInfo, dtCodiDime.Rows[i]["codi_dime"].ToString(), dtTipoTaxo.Rows[0]["tipo_taxo"].ToString(), "MONE_LOCA", item["orde_memb"].ToString());
                                if (dt.Columns.Count > 2)
                                    modHtml.GeneracionHTMLDimensiones(sRutaXML, dt, dt_DimeAxis.Rows.Count, FileMode.Append,dtCodiDime.Rows[i]["desc_dime"].ToString() + " " + item[1].ToString(), vCont);
                            }
                        }
                        else
                        {

                            vPrefDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(0, dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":"));
                            vCodiDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":") + 1);
                            dt_DimeAxis = vModEmp.GetEjesDimension(vCodiInfo, vPrefDime, vCodiDime);
                            dtCodiMemb = vModEmp.GetMiembDimension(empresa, corr_inst, vers_inst, vCodiInfo, dt_DimeAxis.Rows[0]["pref_axis"].ToString(), dt_DimeAxis.Rows[0]["codi_axis"].ToString());
                            foreach (DataRow item in dtCodiMemb.Rows)
                            {
                                dt = vModEmp.GenerarDimensionesCuadros(empresa, corr_inst, vers_inst, vCodiInfo, dtCodiDime.Rows[i]["codi_dime"].ToString(), dtTipoTaxo.Rows[0]["tipo_taxo"].ToString(), "MONE_LOCA", item["orde_memb"].ToString());
                                if (dt.Columns.Count > 2)
                                    modHtml.GeneracionHTMLDimensiones(sRutaXML, dt, dt_DimeAxis.Rows.Count, FileMode.Append,dtCodiDime.Rows[i]["desc_dime"].ToString(), vCont);
                            }
                        }
                        
                    }
                    else
                    {
                        //Genera dimensión para impresión en HTML
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 2");
                        dt = vModEmp.GenerarDimensiones(empresa, corr_inst, vers_inst, vCodiInfo, dtCodiDime.Rows[i]["codi_dime"].ToString(), dtTipoTaxo.Rows[0]["tipo_taxo"].ToString(), "MONE_LOCA");
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 3");
                        vPrefDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(0, dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":"));
                        vCodiDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":") + 1);
                        dt_DimeAxis = vModEmp.GetEjesDimension(vCodiInfo, vPrefDime, vCodiDime);
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 4");
                        DataTable dtDimeDeta = getDetalleDimension(vCodiInfo, vPrefDime, vCodiDime);
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 5");
                        if (dtDimeDeta.Rows[0]["dime_tran"].ToString() == "1")
                        {
                            dt.Columns.Remove("negr_conc");
                            dt = modHtml.GenerateTransposedTable(dt);
                        }

                        if (dt.Columns.Count > 2)
                            modHtml.GeneracionHTMLDimensiones(sRutaXML, dt, dt_DimeAxis.Rows.Count, FileMode.Append, dtCodiDime.Rows[i]["desc_dime"].ToString(), vCont);
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 6");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Log.putLog(ex.Message);
            throw new Exception("Problema en funcion crear_html." + ex.Message);
        }
      // modHtml.GeneracionHTML_Informes(sRutaXML, dt, informe);
    }
    /// <summary>
    /// Metodo que llama a la generación del html
    /// </summary>
    public string crear_htmlString(string CodiEmex, string CodiEmpr, string informe, string empresa, string corr_inst, string vers_inst, int vCont, DataTable dtContextosSimples, DataTable dtContextosDimension)
    {
        string vHtml = "";
        try
        {
            string[] vCTInfo;
            string vPrefDime, vCodiDime, vCodiInfo;
            DataTable dt, dtTipoTaxo, dtCodiDime, dt_DimeAxis, dtCodiMemb;
            vCodiInfo = informe.Substring(0, informe.IndexOf("|"));
            MantencionParametros para = new MantencionParametros();
            vCTInfo = modHtml.getCodiInfoTipo(informe);
            if (vCTInfo[1] == "C")
            {
                dtTipoTaxo = getInforme(CodiEmex, CodiEmpr, vCodiInfo, "C");
                dt = getDatosReporteConTipos(CodiEmex, CodiEmpr, empresa, corr_inst, vers_inst, vCodiInfo, "C", "MONE_LOCA", dtContextosSimples);

                vHtml += modHtml.GeneracionHTML_InformesTextosDiferentes(dt, vCodiInfo, dtTipoTaxo.Rows[0]["desc_info"].ToString(), vCont);
            }
            else
            {
                dtTipoTaxo = getInforme(CodiEmex, CodiEmpr, vCodiInfo, "D");
                dtCodiDime = getDimensionesUsables(CodiEmex, CodiEmpr, vCodiInfo).Tables[0];

                for (int i = 0; i < dtCodiDime.Rows.Count; i++)
                {
                    if (vCodiInfo.Contains("cuadro") && !vCodiInfo.EndsWith("(2017)"))
                    {
                        if (vCodiInfo.EndsWith("(2018)"))
                        {
                            vPrefDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(0, dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":"));
                            vCodiDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":") + 1);
                            dt_DimeAxis = vModEmp.GetEjesDimension(vCodiInfo, vPrefDime, vCodiDime);
                            dtCodiMemb = vModEmp.GetMiembTaxoDimension(empresa, corr_inst, vers_inst, vCodiInfo, dt_DimeAxis.Rows[0]["pref_axis"].ToString(), dt_DimeAxis.Rows[0]["codi_axis"].ToString());
                            foreach (DataRow item in dtCodiMemb.Rows)
                            {
                                dt = new DataTable();
                                dt = vModEmp.GenerarDimensionesCuadros2018(empresa, corr_inst, vers_inst, vCodiInfo, dtCodiDime.Rows[i]["codi_dime"].ToString(), dtTipoTaxo.Rows[0]["tipo_taxo"].ToString(), "MONE_LOCA", item["orde_memb"].ToString());
                                if (dt.Columns.Count > 2)
                                    vHtml += modHtml.GeneracionHTMLDimensiones(dt, dt_DimeAxis.Rows.Count, dtCodiDime.Rows[i]["desc_dime"].ToString() + " " + item[1].ToString(), vCont);
                            }
                        }
                        else
                        {

                            vPrefDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(0, dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":"));
                            vCodiDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":") + 1);
                            dt_DimeAxis = vModEmp.GetEjesDimension(vCodiInfo, vPrefDime, vCodiDime);
                            dtCodiMemb = vModEmp.GetMiembDimension(empresa, corr_inst, vers_inst, vCodiInfo, dt_DimeAxis.Rows[0]["pref_axis"].ToString(), dt_DimeAxis.Rows[0]["codi_axis"].ToString());
                            foreach (DataRow item in dtCodiMemb.Rows)
                            {
                                dt = vModEmp.GenerarDimensionesCuadros(empresa, corr_inst, vers_inst, vCodiInfo, dtCodiDime.Rows[i]["codi_dime"].ToString(), dtTipoTaxo.Rows[0]["tipo_taxo"].ToString(), "MONE_LOCA", item["orde_memb"].ToString());
                                if (dt.Columns.Count > 2)
                                    vHtml += modHtml.GeneracionHTMLDimensiones(dt, dt_DimeAxis.Rows.Count, dtCodiDime.Rows[i]["desc_dime"].ToString(), vCont);
                            }
                        }

                    }
                    else
                    {
                        //Genera dimensión para impresión en HTML
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 2");
                        dt = vModEmp.GenerarDimensiones(empresa, corr_inst, vers_inst, vCodiInfo, dtCodiDime.Rows[i]["codi_dime"].ToString(), dtTipoTaxo.Rows[0]["tipo_taxo"].ToString(), "MONE_LOCA");
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 3");
                        vPrefDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(0, dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":"));
                        vCodiDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":") + 1);
                        dt_DimeAxis = vModEmp.GetEjesDimension(vCodiInfo, vPrefDime, vCodiDime);
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 4");
                        DataTable dtDimeDeta = getDetalleDimension(vCodiInfo, vPrefDime, vCodiDime);
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 5");
                        if (dtDimeDeta.Rows[0]["dime_tran"].ToString() == "1")
                        {
                            dt.Columns.Remove("negr_conc");
                            dt = modHtml.GenerateTransposedTable(dt);
                        }

                        if (dt.Columns.Count > 2)
                        {
                            vHtml += modHtml.GeneracionHTMLDimensiones(dt, dt_DimeAxis.Rows.Count, dtCodiDime.Rows[i]["desc_dime"].ToString(), vCont);
                        }
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 6");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Log.putLog(ex.Message);
            throw new Exception("Problema en funcion crear_html." + ex.Message);
        }
        return vHtml;
        // modHtml.GeneracionHTML_Informes(sRutaXML, dt, informe);
    }
    /// <summary>
    /// Metodo que llama a la generación del html
    /// </summary>
    public void crear_html2(string CodiEmex, string CodiEmpr, string informe, string empresa, string corr_inst, string vers_inst, int vCont)
    {
        try
        {
            string[] vCTInfo;
            string vPrefDime, vCodiDime, vCodiInfo;
            DataTable dt, dtTipoTaxo, dtCodiDime, dt_DimeAxis, dtCodiMemb;
            vCodiInfo = informe.Substring(0, informe.IndexOf("|"));
            MantencionParametros para = new MantencionParametros();
            string sRutaXML = @para.getPathWebb() + @"\librerias\sheets\Reporte" + "_" + empresa + "_" + corr_inst + "_" + vers_inst + ".html";
            vCTInfo = modHtml.getCodiInfoTipo(informe);
            if (vCTInfo[1] == "C")
            {
                dtTipoTaxo = getInforme(CodiEmex, CodiEmpr, vCodiInfo, "C");
                dt = getDatosReporteConTipos(CodiEmex, CodiEmpr, empresa, corr_inst, vers_inst, vCodiInfo, "C", "MONE_LOCA");
                
                modHtml.GeneracionHTML_InformesTextosDiferentes(sRutaXML, dt, vCodiInfo, FileMode.Append, dtTipoTaxo.Rows[0]["desc_info"].ToString(), vCont);
            }
            else
            {
                dtTipoTaxo = getInforme(CodiEmex, CodiEmpr, vCodiInfo, "D");
                dtCodiDime = getDimensionesUsables(CodiEmex, CodiEmpr, vCodiInfo).Tables[0];
                for (int i = 0; i < dtCodiDime.Rows.Count; i++)
                {
                    if (vCodiInfo.Contains("cuadro") && !vCodiInfo.EndsWith("(2017)"))
                    {
                        if (vCodiInfo.EndsWith("(2018)"))
                        {
                            vPrefDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(0, dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":"));
                            vCodiDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":") + 1);
                            dt_DimeAxis = vModEmp.GetEjesDimension(vCodiInfo, vPrefDime, vCodiDime);
                            dtCodiMemb = vModEmp.GetMiembTaxoDimension(empresa, corr_inst, vers_inst, vCodiInfo, dt_DimeAxis.Rows[0]["pref_axis"].ToString(), dt_DimeAxis.Rows[0]["codi_axis"].ToString());
                            foreach (DataRow item in dtCodiMemb.Rows)
                            {
                                dt = new DataTable();
                                dt = vModEmp.GenerarDimensionesCuadros2018(empresa, corr_inst, vers_inst, vCodiInfo, dtCodiDime.Rows[i]["codi_dime"].ToString(), dtTipoTaxo.Rows[0]["tipo_taxo"].ToString(), "MONE_LOCA", item["orde_memb"].ToString());
                                if (dt.Columns.Count > 2)
                                    modHtml.GeneracionHTMLDimensiones(sRutaXML, dt, dt_DimeAxis.Rows.Count, FileMode.Append, dtCodiDime.Rows[i]["desc_dime"].ToString() + " " + item[1].ToString(), vCont);
                            }
                        }
                        else
                        {
                            vPrefDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(0, dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":"));
                            vCodiDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":") + 1);
                            dt_DimeAxis = vModEmp.GetEjesDimension(vCodiInfo, vPrefDime, vCodiDime);
                            dtCodiMemb = vModEmp.GetMiembDimension(empresa, corr_inst, vers_inst, vCodiInfo, dt_DimeAxis.Rows[0]["pref_axis"].ToString(), dt_DimeAxis.Rows[0]["codi_axis"].ToString());
                            foreach (DataRow item in dtCodiMemb.Rows)
                            {
                                dt = vModEmp.GenerarDimensionesCuadros(empresa, corr_inst, vers_inst, vCodiInfo, dtCodiDime.Rows[i]["codi_dime"].ToString(), dtTipoTaxo.Rows[0]["tipo_taxo"].ToString(), "MONE_LOCA", item["orde_memb"].ToString());
                                if (dt.Columns.Count > 2)
                                    modHtml.GeneracionHTMLDimensiones(sRutaXML, dt, dt_DimeAxis.Rows.Count, FileMode.Append, dtCodiDime.Rows[i]["desc_dime"].ToString(), vCont);
                            }
                        }
                    }
                    else
                    {
                        //Genera dimensión para impresión en HTML
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 2");
                        dt = vModEmp.GenerarDimensiones(empresa, corr_inst, vers_inst, vCodiInfo, dtCodiDime.Rows[i]["codi_dime"].ToString(), dtTipoTaxo.Rows[0]["tipo_taxo"].ToString(), "MONE_LOCA");
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 3");
                        vPrefDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(0, dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":"));
                        vCodiDime = dtCodiDime.Rows[i]["codi_dime"].ToString().Substring(dtCodiDime.Rows[i]["codi_dime"].ToString().IndexOf(":") + 1);
                        dt_DimeAxis = vModEmp.GetEjesDimension(vCodiInfo, vPrefDime, vCodiDime);
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 4");
                        DataTable dtDimeDeta = getDetalleDimension(vCodiInfo, vPrefDime, vCodiDime);
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 5");
                        if (dtDimeDeta.Rows[0]["dime_tran"].ToString() == "1")
                        {
                            dt.Columns.Remove("negr_conc");
                            dt = modHtml.GenerateTransposedTable(dt);
                        }

                        if (dt.Columns.Count > 2)
                            modHtml.GeneracionHTMLDimensiones(sRutaXML, dt, dt_DimeAxis.Rows.Count, FileMode.Append, dtCodiDime.Rows[i]["desc_dime"].ToString(), vCont);
                        //Log.putLog(System.DateTime.Now.ToString() + " GeneracionExcel 6");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Log.putLog(ex.Message);
            throw new Exception("Problema en funcion crear_html." + ex.Message);
        }
        // modHtml.GeneracionHTML_Informes(sRutaXML, dt, informe);
    }
    /// <summary>
    /// Inserta nueva dfescripciòn empresa
    /// </summary>
    public void UpdDescEmpr(string codi_emex, string codi_empr, string codi_pers, string desc_empr, string codi_grup, string codi_segm, string tipo_taxo)
    {
        con.TraerResultados0(modConc.UpdDescEmpr(codi_emex, codi_empr, codi_pers, desc_empr, codi_grup, codi_segm, tipo_taxo));
    }
    /// <summary>
    /// MeTODO  QUE EXTRAE LOS PERÍODOS
    /// </summary>
    public DataTable getPersCorrInst(string CodiPers)
    {
        return con.TraerResultados0(modConc.getPersCorrInst(CodiPers)).Tables[0];
    }
    /// <summary>
    /// MeTODO  QUE EXTRAE LOS PERÍODOS  FILTRADOS POR OTROS PERÍODOS
    /// </summary>
    public DataTable getPersCorrInst(string CodiPers, string CorrInst)
    {
        return con.TraerResultados0(modConc.getPersCorrInst(CodiPers, CorrInst)).Tables[0];
    }
    /// <summary>
    /// Obtiene listado de versiones cargadas para una persona/instancia
    /// </summary>
    public DataTable getVersInst(string CodiPers, string CorrInst)
    {
        return con.TraerResultados0(modConc.getPersVersInst(CodiPers, CorrInst)).Tables[0];
    }
    /// <summary>
    /// Obtiene los valores ingresados para una empresa, instancia, version, prefijo, concepto, contexto
    /// </summary>
    public DataTable getValoEmprInstVersPrefConcCntx(string CodiPers, string CorrInst, string VersInst, string PrefConc, string CodiConc, string CodiCntx)
    {
        return con.TraerResultados0(modConc.getValoEmprInstVersPrefConcCntx(CodiPers, CorrInst, VersInst, PrefConc, CodiConc, CodiCntx)).Tables[0];
    }
    /// <summary>
    /// Actualiza los valores de la tabla dbax_inst_conc y se insertan registros en dbax_inst_modi
    /// </summary>
    public void updValorInstConc(string CodiPers, string CorrInst, string VersInst, string PrefConc, string CodiConc, string CodiCntx, string ValoCntx, string ValoRefe, string ValoInte)
    {
        con.EjecutarQuery(modConc.updValorInstConc(CodiPers, CorrInst, VersInst, PrefConc, CodiConc, CodiCntx,ValoCntx, ValoRefe, ValoInte));
    }
    /// <summary>
    /// Inserta los valores en la tabla dbax_inst_conc
    /// </summary>
    public void insValorEdicionInstConc(string CodiPers, string CorrInst, string VersInst, string PrefConc, string CodiConc, string CodiCntx, string ValoCntx, string ValoRefe, string ValoInte)
    {
        con.EjecutarQuery(modConc.insValorEdicionInstConc(CodiPers, CorrInst, VersInst, PrefConc, CodiConc, CodiCntx, ValoCntx, ValoRefe, ValoInte));
    }
    /// <summary>
    /// Devuelve [1,0] dependiendo de si la versión pasada por parámetros es la ultima (se consideran las de dbax_arch_temp)
    /// </summary>
    public DataTable getEsUltimaVers(string CodiPers, string CorrInst, string VersInst)
    {
        return con.TraerResultados0(modConc.getEsUltimaVers(CodiPers, CorrInst, VersInst)).Tables[0];
    }
    /// <summary>
    /// Obtiene listado de versiones externas cargadas para una persona/instancia
    /// </summary>
    public DataTable getVersInstExte(string CodiPers, string CorrInst, string UsuaCarg)
    {
        return con.TraerResultados0(modConc.getPersVersInstExte(CodiPers, CorrInst, UsuaCarg)).Tables[0];
    }
    /// <summary>
    /// Obtiene ultima version para una empresa/instancia
    /// </summary>
    public string getUltPersVersInst(string CodiPers, string CorrInst)
    {
        return con.StringEjecutarQuery(modConc.getUltPersVersInst(CodiPers, CorrInst));
    }
    /// <summary>
    /// Obtiene todos los informes definidos por Emex, Empr y Tipo de taxonomia
    /// </summary>
    public DataSet getInformes(string CodiEmex, string CodiEmpr, string Tipo)
    {
        return con.TraerResultados0(modConc.getInformes(CodiEmex, CodiEmpr, Tipo));
    }
    /// <summary>
    /// Obtiene todos los informes definidos por Emex, Empr, Tipo de taxonomia, Tipo
    /// </summary>
    public DataSet getInformes(string CodiEmex, string CodiEmpr, string TipoTaxo, string TipoInfo)
    {
        return con.TraerResultados0(modConc.getInformes(CodiEmex, CodiEmpr, TipoTaxo, TipoInfo));
    }
    public DataSet getInformesActivos(string CodiEmex, string CodiEmpr, string TipoTaxo, string TipoInfo)
    {
        return con.TraerResultados0(modConc.getInformesActivos(CodiEmex, CodiEmpr, TipoTaxo, TipoInfo));
    }
    /// <summary>
    /// Obtiene datos de un informe (por codiinfo)
    /// </summary>
    public DataTable getInforme(string CodiEmex, string CodiEmpr, string CodiInfo, string TipoInfo)
    {
        return con.TraerResultadosT0(modConc.getInforme(CodiEmex, CodiEmpr, CodiInfo, TipoInfo));
    }
    /// <summary>
    /// Obtiene todos los informes definidos y usables para una empresa
    /// </summary>
    public DataTable getInformesUsables(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string VersInst, string TipoInfo, string TipoTaxo)
    {
        return con.TraerResultados0(modConc.getInformesUsables(CodiEmex, CodiEmpr, CodiPers, CorrInst, VersInst, TipoInfo,TipoTaxo)).Tables[0];
    }
    /// <summary>
    /// Obtiene lista de archivos
    /// </summary>
    public DataTable GetArchivosXbrl(string corr_inst)
    {
        return con.TraerResultados0(modHtml.GetArchivosXBRL(corr_inst)).Tables[0];
    }
    /// <summary>
    /// Obtiene lista de archivos para una empresa, periodo y version
    /// </summary>
    public DataTable GetArchivosXbrl(string codi_pers, string corr_inst, string vers_inst)
    {
        return con.TraerResultados0(modHtml.GetArchivosXBRL(codi_pers, corr_inst, vers_inst)).Tables[0];
    }
    /// <summary>
    /// Obtiene el contenido de un archivo específico
    /// </summary>
    public DataTable GetArchivosXbrl(string codi_pers, string corr_inst, string vers_inst, string NombArch)
    {
        return  con.TraerResultados0(modHtml.GetArchivosXBRL(codi_pers, corr_inst, vers_inst, NombArch)).Tables[0];
    }
    /// <summary>
    /// Obtiene todos los informes definidos
    /// </summary>
    public int getMaxOrdeConc(string codi_emex, string codi_empr, string codi_info)
    {
        DataTable dt = con.TraerResultadosT0(modConc.getMaxOrdeConc(codi_emex, codi_empr, codi_info));
        return Convert.ToInt32(dt.Rows[0][0].ToString());
    }
    /// <summary>
    /// Obtiene todos las dimensines por informe
    /// </summary>
    public DataSet getDimensionesUsables(string codi_emex, string codi_empr, string Informe)
    {
        return con.TraerResultados0(modConc.getDimensionesUsables(codi_emex, codi_empr, Informe));

    }
    /// <summary>
    /// Obtiene el detalle del encabezado de una dimension
    /// </summary>
    public DataTable getDetalleDimension(string codi_info, string pref_dime, string codi_dime)
    {
        return con.TraerResultadosT0(modConc.getDetalleDimension(codi_info, pref_dime, codi_dime));

    }
    /// <summary>
    /// Obtiene todos los informes de dimension
    /// </summary>
    public DataTable getInformesDimension(string tipo_info, string codi_pers, string corr_inst)
    {
        return con.TraerResultados0(modConc.getInformesDimension(tipo_info, codi_pers,corr_inst)).Tables[0];
    }
    /// <summary>
    /// Obtiene todos los informes de dimension por un tipo de taxonomia
    /// </summary>
    public DataTable getInformesDimension(string tipo_taxo, string tipo_info, string codi_pers, string corr_inst)
    {
        return con.TraerResultados0(modConc.getInformesDimension(tipo_taxo, tipo_info, codi_pers, corr_inst)).Tables[0];
    }
    // logica de dimensiones con un eje
    /// <summary>
    /// Generador de data table  con los conceptos  del html par la dimension
    /// </summary>
    /// 
    public DataTable getInformesMiembros(string CodiPers, string CorrInst, string VersInst, string CodiInfo, string dimension, string tsEje, string codi_mone, string tipo_taxo)
    {
        DataTable dt_DescConc = getInfoDimensionDescConc(CodiInfo, dimension, tipo_taxo).Tables[0]; //extrae los conceptos
        if (dt_DescConc.Rows.Count > 0)
        {
            DataTable dtCodiConc = dt_DescConc.Copy();
           // DataTable dt_Miembros = getMiembrosEje(CodiPers, CorrInst, VersInst, CodiInfo, dimension, tipo_taxo, dtCodiConc.Rows[0]["codi_conc"].ToString(), dtCodiConc.Rows[0]["pref_conc"].ToString()).Tables[0]; //extrae los miembros

            dt_DescConc.Columns.Remove("orde_conc");
            dt_DescConc.Columns.Remove("codi_conc");
            dt_DescConc.Columns.Remove("pref_conc");
            dt_DescConc.Columns.Remove("sald_ini");
            //dt_DescConc = modHtml.getDatosDimension(CodiPers, CorrInst, VersInst, CodiInfo, dt_Miembros, dt_DescConc, dimension, codi_mone, dtCodiConc, tipo_taxo).Copy();
        }
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene los miembros de un eje.
    /// </summary>
    /// 
    public DataSet getMiembrosEje(string CodiPers,string CorrInst,string VersInst,string CodiInfo,string PrefAxis, string CodiAxis)
    {
        return con.TraerResultados0(Contextos.getInformesMiembros(CodiPers, CorrInst, VersInst, CodiInfo, PrefAxis, CodiAxis));

    }
    //public DataSet getMiembrosEje(string tsCodiPers, string tsCorrInst, string tsVersInst, string CodiInfo, string dimension, string tipo_taxo, string codi_conc, string pref_conc)
    //{
    //    return con.TraerResultados0(Contextos.getInformesMiembros(tsCodiPers, tsCorrInst, tsVersInst, CodiInfo, dimension, tipo_taxo, codi_conc, pref_conc));

    //}
    /// <summary>
    /// Obtiene descripcion y formato de conceptos para un informe particular de dimension
    /// </summary>
    /// 
    public DataSet getInfoDimensionDescConc(string CodiInfo, string dimension, string tipo_taxo)
    {
        return con.TraerResultados0(modConc.getInfoDimensionDescConc(CodiInfo, dimension, tipo_taxo));
    }
    /// <summary>
    /// Metodo para imprimir  en html
    /// </summary>
    public void GeneradorHTMLDimesion(string par1, DataTable par2, string par3)
    {
        modHtml.GeneracionHTML_Dimension(par1, par2, par3);

    }
    /// <summary>
    /// Metodo para imprimir  en html mejorado
    /// </summary>
    public void GeneradorHTMLDimensiones(string ruta, DataTable tabla, int numeEjes)
    {
        modHtml.GeneracionHTMLDimensiones(ruta, tabla, numeEjes,FileMode.Create,"",3);
    }
    /// <summary>
    /// Metodo para imprimir  en html mejorado
    /// </summary>
    public void GeneradorHTMLDimensiones(string ruta, DataTable tabla, int numeEjes, bool vConEncabezado, string vCorrInst, string vDescInfo, string vDescPers)
    {
        modHtml.GeneracionHTMLDimensiones(ruta, tabla, numeEjes, FileMode.Create, vDescInfo, 3, vConEncabezado, vCorrInst, vDescPers);
    }
    /// <summary>
    /// Metodo para extraer personas de dbax_inst_arch
    /// </summary>
    public DataSet GetPersArch(string periodo, string version)
    {
        return con.TraerResultados0(modConc.GetPersArch(periodo, version));
    }
    /// <summary>
    /// Metodo para generar el script de la base de datos de la  dbax_inst_arch
    /// </summary>
    /// 
    public DataSet GetArchXBRL(string persona, string periodo, string version)
    {
        return con.TraerResultados0(modConc.GetArchXBRL(persona, periodo, version));

    }
    /// <summary>
    /// Metodo para imprimir archivo
    /// </summary>
    /// 
    public void GeneArchivo(DataTable tabla)
    {
        modConc.ImprimeArchivo(tabla);
    }
    /// <summary>
    /// Trae códigos y descripción de todos los conceptos informadas en una versión
    /// </summary>
    /// 
    public DataTable getConcEmprInstVers(string CodiPers, string CorrInst, string VersInst)
    {
        return con.TraerResultados0(modConc.getConcEmprInstVers(CodiPers, CorrInst, VersInst)).Tables[0];
    }
    /// <summary>
    /// Trae códigos y descripción de todos los conceptos informadas en una versión (filtradas por codigo y despripcion)
    /// </summary>
    /// 
    public DataTable getConcEmprInstVers(string CodiPers, string CorrInst, string VersInst, string TextBusq)
    {
        return con.TraerResultados0(modConc.getConcEmprInstVers(CodiPers, CorrInst, VersInst, TextBusq)).Tables[0];
    }
    /// <summary>
    /// Trae los ejes de una dimensión
    /// </summary>
    /// 
    public DataTable getEjesPorDimension(string CodiInfo, string prefDime, string CodiDime)
    {
        return con.TraerResultados0(modConc.getEjesPorDimension(CodiInfo, prefDime, CodiDime)).Tables[0];
    }
    /// <summary>
    /// Trae los miembros de un eje
    /// </summary>
    /// 
    public DataTable getMiembrosPorEje(string prefAxis, string CodiAxis)
    {
        return con.TraerResultados0(modConc.getMiembrosPorEje(prefAxis, CodiAxis)).Tables[0];
    }
    /// <summary>
    /// Trae los miembros de un eje  mas los miembros personalizados
    /// </summary>
    /// 
    public DataTable getMiembrosPorEjeEmpresaInstanciaVersion(string CodiPers, string CorrInst, string VersInst, string prefAxis, string CodiAxis)
    {
        return con.TraerResultados0(modConc.getMiembrosPorEjeEmpresaInstanciaVersion(CodiPers, CorrInst, VersInst, prefAxis, CodiAxis)).Tables[0];
    }
    /// <summary>
    /// Trae conceptos de una dimensión
    /// </summary>
    /// 
    public DataTable getConcPorDime(string CodiInfo, string prefDime, string CodiDime)
    {
        return con.TraerResultados0(modConc.getConcPorDime(CodiInfo, prefDime, CodiDime)).Tables[0];
    }
    /// <summary>
    /// Trae los informes correspondientes a cuadros técnicos
    /// </summary>
    /// 
    public DataTable getInformesCuadrosTecnicos()
    {
        return con.TraerResultados0(modConc.getInformesCuadrosTecnicos()).Tables[0];
    }
    /// <summary>
    /// Trae descripción y código de los cuadros técnicos
    /// </summary>
    /// 
    public DataTable getCuadrosTecnicos()
    {
        return con.TraerResultados0(modConc.getCuadrosTecnicos()).Tables[0];
    }
    /// <summary>
    /// Trae descripción y código de los cuadros técnicos por informe
    /// </summary>
    /// 
    public DataTable getCuadrosTecnicos(string CodiInfo)
    {
        return con.TraerResultados0(modConc.getCuadrosTecnicos(CodiInfo)).Tables[0];
    }
    /// <summary>
    /// Trae la definición de un concepto
    /// </summary>
    /// 
    public DataTable getConceptoPrefConc(string prefConc, string codiConc)
    {
        return con.TraerResultados0(modConc.getConceptoPrefConc(prefConc, codiConc)).Tables[0];
    }
    /// <summary>
    /// Inserta datos para generacion de excel multiempresa
    /// </summary>
    public void insEmpresaParaInforme(string codi_pers, string desc_pers, string corr_inst)
    {
        con.EjecutarQuery(modHtml.insEmpresaParaInforme(codi_pers, desc_pers, corr_inst));
    }
    /// <summary>
    /// Obtiene el valor de un único concepto para una empresa/instancia/version, dentro de un rango de fechas
    /// </summary>
    public DataTable getValoConc(string CodiPers, string CorrInst, string VersInst, string PrefConc, string CodiConc, string FiniCntx, string FfinCntx)
    {
        return con.TraerResultadosT0(modHtml.getValoConc(CodiPers, CorrInst, VersInst, PrefConc, CodiConc, FiniCntx, FfinCntx));
    }
    public void DelInstDocuVers(string codi_pers, string corr_inst, string vers_inst)
    {
        con.EjecutarQuery(modComp.DelInstDocuVers(codi_pers, corr_inst, vers_inst));
    }
    internal void DelInstDocuVersExte(string codi_pers, string corr_inst, string pCodiUsua, string pDbgxEmpr, string pDbgxCorr, string pDbgxVers)
    {
        con.EjecutarQuery(modComp.DelInstDocuVersExte(codi_pers, corr_inst, pCodiUsua, pDbgxEmpr, pDbgxCorr, pDbgxVers));
    }
    //public string getUltPersVersInstExt(string codi_pers, string corr_inst, string vMinVers, string vMaxVers)
    //{
    //    con.StringEjecutarQuery(modComp.getUltPersVersInstExt(codi_pers, corr_inst, vMinVers, vMaxVers));
    //}
    public DataTable GetArchivosXbrlExte(string codi_pers, string corr_inst, string pNombArch, string pUsuaCarg)
    {
        return con.TraerResultados0(modHtml.GetArchivosXBRLExt(codi_pers, corr_inst, pNombArch, pUsuaCarg)).Tables[0];
    }
}