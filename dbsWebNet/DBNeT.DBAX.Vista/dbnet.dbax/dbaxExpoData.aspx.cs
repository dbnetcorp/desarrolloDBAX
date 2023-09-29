using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.IO;
using System.Data;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.DBAX.Controlador;
using System.Diagnostics;
using System.Xml;

public partial class dbaxExpoData : System.Web.UI.Page
{
    #region Pagina Base
    private string _gsModo = string.Empty;
    private SessionWeb _goSessionWeb;
    //private string ruta_arc = @"C:\DBNeT\DBAX\dbnProc\dbax.ExpoData";
    //private string ruta_exe = @"C:\DBNeT\DBAX\dbnProc\dbax.ExpoData\bin\Release";
    private string ruta_arc;
    private string ruta_exe;

    private void RecuperaSessionWeb()
    {
        if (Session["sessionWeb"] == null)
        { Response.Redirect("~/dbnFw5/dbnLogin.aspx"); }
        else
        { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
    }
    public void GuardaSessionWeb()
    { Session["sessionWeb"] = _goSessionWeb; }
    #endregion
    
    //Ver si sirven
    ModeloExpoData expoData = new ModeloExpoData(); 
    
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        DateTime localDate = DateTime.Now;

        //Asignamos las rutas
        XmlDocument xmldoc = new XmlDocument();

        string baseDir = System.Web.HttpRuntime.AppDomainAppPath;
        string configPath = Path.Combine(baseDir, "setting.config");
        xmldoc.Load(configPath);
        
        XmlNode archivos_desc = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "RutaArchivosExpoData" + "']");
        XmlNode archivos_descAttribute = archivos_desc.Attributes.GetNamedItem("value");
        ruta_arc = archivos_descAttribute.Value.ToString();

        XmlNode server = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "RutaExpoData" + "']");
        XmlNode serverAttribute = server.Attributes.GetNamedItem("value");
        ruta_exe = serverAttribute.Value.ToString();
        
        if (!IsPostBack)
        {
            DataTable dt = expoData.getTiposEmpresa().Tables[0];
            ddl_TipoTaxonomia.DataSource = dt;
            ddl_TipoTaxonomia.DataTextField = dt.Columns["desc_tipo"].ToString();
            ddl_TipoTaxonomia.DataValueField = dt.Columns["tipo_taxo"].ToString();
            ddl_TipoTaxonomia.DataBind();
            
        }

        //Extraemos el proceso en curso
        DataTable dt2 = expoData.getEstadoProceso(_goSessionWeb.CODI_USUA).Tables[0];
        string estado_desc = "";

        if (dt2.Rows.Count > 0)
        {
            estado_desc = dt2.Rows[0]["desc_proc"].ToString();
            string id_semaforo = dt2.Rows[0]["corr_proc"].ToString();
            string[] txt_expodata = estado_desc.Split(new[] { "-->" }, StringSplitOptions.None);
            string[] var_expodata = txt_expodata[0].Split('_');

            //Estado en verde, mostramos el archivo
            if ((var_expodata.Count() == 2) && var_expodata[0].Equals("<!--expoData"))
            {
                linkArchivo.CommandArgument = var_expodata[1];
                linkArchivo.Visible = true;
                linkArchivo.Enabled = true;
            }

            //Si existe un proceso en curso
            if ((txt_expodata.Count() >= 2) && txt_expodata[1].Contains("amarillo"))
            {
                //Desativamos los campos
                ddl_TipoTaxonomia.Enabled = false;
                ddl_Segmento.Enabled = false;
                ddl_CorrInst.Enabled = false;
                tipoFiltro.Enabled = false;
                ddl_CodiInfo.Enabled = false;
                ddl_CodiEmpr.Enabled = false;
                Procesar.Enabled = false;

                //Revisamos que esté corriendo el proceso
                int procesos = Process.GetProcessesByName("dbax.ExpoData").Length;

                if (procesos == 0)
                {
                    expoData.actualizarProcesoRojo(id_semaforo, localDate.ToString());
                    Log.putLog("[" + localDate.ToString() + "] Cierre no manejado de la aplicación. Se actualiza en rojo el semaforo: "+id_semaforo+"");
                }

            }

            contMensaje.InnerHtml = estado_desc;

        }
        
    }

    protected void ddl_TipoTaxonomia_SelectedIndexChanged(object sender, EventArgs e)
    {
        String TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue.ToString();

        DataTable dt = expoData.getSegmentos(TipoTaxonomia).Tables[0];
        ddl_Segmento.DataSource = dt;
        //------------------------Placeholder------------------------------//
        dt.Rows.InsertAt(this.crearPlaceholder(dt.NewRow()), 0);

        // Cargamos los segmentos
        ddl_Segmento.DataTextField = dt.Columns["desc_segm"].ToString();
        ddl_Segmento.DataValueField = dt.Columns["codi_segm"].ToString();
        ddl_Segmento.DataBind();

    }

    protected void ddl_Segmento_SelectedIndexChanged(object sender, EventArgs e)
    {
        String SegmEmpr = ddl_Segmento.SelectedValue.ToString();
        String TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue.ToString();

        if(!SegmEmpr.Trim().Equals("") && !TipoTaxonomia.Trim().Equals(""))
        {
            //Asignamos los periodos
            DataTable dt2 = expoData.getEmpresas(TipoTaxonomia, SegmEmpr).Tables[0];
            ddl_CodiEmpr.DataSource = dt2;
            ddl_CodiEmpr.DataTextField = dt2.Columns["desc_pers"].ToString();
            ddl_CodiEmpr.DataValueField = dt2.Columns["codi_pers"].ToString();
            ddl_CodiEmpr.DataBind();

            //Asignamos las empresas
            DataTable dt3 = expoData.getPeriodos(TipoTaxonomia, SegmEmpr).Tables[0];
            ddl_CorrInst.DataSource = dt3;
            ddl_CorrInst.DataTextField = dt3.Columns["corr_inst"].ToString();
            ddl_CorrInst.DataValueField = dt3.Columns["corr_inst"].ToString();
            ddl_CorrInst.DataBind();
        }
        
    }

    protected void ddl_CorrInst_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.prepararProceso();    
    }

    protected void tipoFiltro_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.prepararProceso();
    }

    protected void ddl_CodiEmpr_SelectedIndexChanged(object sender, EventArgs e)
    {
        
    }

    protected void ddl_CodiInfo_SelectedIndexChanged(object sender, EventArgs e)
    {
        
    }

    protected void linkArchivo_Click(object sender, EventArgs e)
    {
        System.IO.FileInfo _file = new System.IO.FileInfo(ruta_arc + "/" + linkArchivo.CommandArgument);

        if (_file.Exists == true)
        {
            System.Web.HttpResponse Response = System.Web.HttpContext.Current.Response;
            Response.Clear();
            Response.AddHeader("Content-Disposition", "attachment; filename=" + _file.Name);
            Response.AddHeader("Content-Length", _file.Length.ToString());
            Response.ContentType = "application/octet-stream";
            Response.TransmitFile(ruta_arc + "/" + linkArchivo.CommandArgument);
            Response.End();

        }
        else
        {
            LabelArchivo.Text = "Error: No existe el archivo.";
        }
    }

    protected DataRow crearPlaceholder(DataRow row)
    {
        DataRow placeholder = row;
        placeholder[0] = "";
        placeholder[1] = "-- Seleccione un elemento --";

        return placeholder;
    }

    protected void prepararProceso()
    {
        List<string> Periodo = periodoDatos();
        String SegmEmpr = ddl_Segmento.SelectedValue.ToString();
        String TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue.ToString();
        String TipoFiltroTxt = tipoFiltro.SelectedValue.ToString();

        if ((Periodo.Count > 0) && (!TipoFiltroTxt.Equals("")))
        {
            //Cargamos los informes
            DataTable dt4 = expoData.getInformes(TipoTaxonomia, SegmEmpr, Periodo, TipoFiltroTxt).Tables[0];
            ddl_CodiInfo.DataSource = dt4;
            ddl_CodiInfo.DataTextField = dt4.Columns["desc_info"].ToString();
            ddl_CodiInfo.DataValueField = dt4.Columns["codi_info"].ToString();
            ddl_CodiInfo.DataBind();

        }    
    }

    protected void Procesar_Click(object sender, ImageClickEventArgs e)
    {
        //Validamos que no existan procesos en curso
        DataTable dt = expoData.getEstadoProceso(_goSessionWeb.CODI_USUA).Tables[0];
        
        List<string> Periodo  = periodoDatos();
        List<string> Empresa  = empresaDatos();
        List<string> Informes = informeDatos();
        String SegmEmpr = ddl_Segmento.SelectedValue.ToString();
        String TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue.ToString();

        if ((Periodo.Count > 0) && (Empresa.Count > 0) && !SegmEmpr.Equals("") && !TipoTaxonomia.Equals(""))
        {
            SysParamController _loSysaParam = new SysParamController();
            dbax_dbne_procController _goDbaxDbneProc = new dbax_dbne_procController();

            var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_EXPO_DATA", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            var ruta_bin = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_XBRL_BINA", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);

            //Creamos el proceso
            DateTime localDate = DateTime.Now;
            DataTable res = expoData.crearProceso(_goSessionWeb.CODI_USUA, localDate.ToString()).Tables[0];
            
            //Ejecutamos el proceso
            ProcessStartInfo startInfo = new ProcessStartInfo();
            startInfo.CreateNoWindow = false;
            startInfo.UseShellExecute = false;
            startInfo.FileName = ruta_exe + @"\dbax.ExpoData.exe";
            startInfo.WindowStyle = ProcessWindowStyle.Hidden;
            startInfo.Arguments = string.Join(",", Informes) + " " + string.Join(",", Empresa) + " " + string.Join(",", Periodo) + " " + ruta_arc + " " + _goSessionWeb.CODI_USUA + " " + res.Rows[0]["corr_proc"].ToString();

            Process.Start(startInfo);

            //Recargamos la pantalla
            Response.Redirect(Request.RawUrl);
        }
        else
        {
            LabelError.Text = "Debe seleccionar todos los campos para poder generar el archivo.";
        }
        
    }

    protected List<string> periodoDatos()
    {
        List<string> Periodo = new List<string>();
        foreach (int i in ddl_CorrInst.GetSelectedIndices())
        {
            Periodo.Add(ddl_CorrInst.Items[i].Value.ToString());
        }

        return Periodo;
    }

    protected List<string> empresaDatos()
    {
        List<string> Empresa = new List<string>();
        foreach (int i in ddl_CodiEmpr.GetSelectedIndices())
        {
            Empresa.Add(ddl_CodiEmpr.Items[i].Value.ToString());
        }

        return Empresa;
    }

    protected List<string> informeDatos()
    {
        List<string> Informes = new List<string>();
        foreach (int i in ddl_CodiInfo.GetSelectedIndices())
        {
            Informes.Add(ddl_CodiInfo.Items[i].Value.ToString());
        }

        return Informes;
    }


}