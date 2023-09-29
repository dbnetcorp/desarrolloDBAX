using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.IO;
using System.Data;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.Base.Controlador;

public partial class ConsultaEmpresaPeriodo : System.Web.UI.Page
{
    #region Pagina Base
    private string _gsModo = string.Empty;
    private SessionWeb _goSessionWeb;

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
    GeneracionExcel GenExcel = new GeneracionExcel();
    MantencionCntx Contextos = new MantencionCntx();
    GeneradorGrupo geneGru = new GeneradorGrupo();
    public string GrupoEmpr = "", SegmEmpr = "", TipoTaxonomia = "";
    private string Modo, CodiPers, CorrInst, VersInst, CodiInfo, vTipoTaxo;

    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb(); 
        SysParamController _loSysaParam = new SysParamController();
        var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_DEFE_TAXO", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        //this.lb_error.Text = string.Empty;
        VariablesSession Ses = new VariablesSession();
        Ses = (VariablesSession)Session["par1"];

        if(Ses!=null)
        {
            Modo = "M";
            CodiPers = Ses.CodiPers;
            CorrInst = Ses.CorrInst;
            CodiInfo = Ses.CodiInfo;
            vTipoTaxo = Ses.TipoTaxo;
            VersInst = GenExcel.getUltPersVersInst(CodiPers, CorrInst);
        }else{
            Modo="I";
        }
   
        if (!IsPostBack)
        {
            Response.Cache.SetExpires(DateTime.Now);
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetValidUntilExpires(false);

            //if (rbl_TipoRepo.SelectedValue == "Informe")
            //{ 
            //    ddl_Dime.Enabled = false; 
            //}

            DataTable dt = geneGru.getGrupos().Tables[0];
            ddl_Grupo.DataSource = dt;
            ddl_Grupo.DataTextField = dt.Columns["desc_grup"].ToString();
            ddl_Grupo.DataValueField = dt.Columns["codi_grup"].ToString();
            ddl_Grupo.DataBind();

            dt = geneGru.getSegmentos().Tables[0];
            ddl_Segmento.DataSource = dt;
            ddl_Segmento.DataTextField = dt.Columns["desc_segm"].ToString();
            ddl_Segmento.DataValueField = dt.Columns["codi_segm"].ToString();
            ddl_Segmento.DataBind();

            dt = geneGru.getTiposTaxonomia().Tables[0];
            ddl_TipoTaxonomia.DataSource = dt;
            ddl_TipoTaxonomia.DataTextField = dt.Columns["desc_tipo"].ToString();
            ddl_TipoTaxonomia.DataValueField = dt.Columns["tipo_taxo"].ToString();
            ddl_TipoTaxonomia.DataBind();

            if (Ses == null)
            {
                this.ddl_TipoTaxonomia.SelectedValue = loResultado.PARAM_VALUE;
            }
            else
            {
                Helper.ddlSelecciona(ddl_TipoTaxonomia, vTipoTaxo);
            }
            llenado_de_moneda();

            //rbl_tipoInfo.SelectedValue = "R";

            if (Modo != "M")
            {
                llenado_de_periodos();
                llenado_de_empresa();
                
            }
            else 
            {
                llenado_de_periodos(CorrInst);
                llenado_de_empresa(CodiPers, VersInst, CodiInfo);
                Ses = null;
                Procesar_Click(null, null);
            }
            //ib_Rescatar_Click(null,null);
        }
    }
    protected void llenado_de_empresa()
    {
        try
        {
            DataSet ds = GenExcel.GetEmpresas(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), "", Filtro_Empresa.Text, ddl_Grupo.SelectedValue.ToString(), ddl_Segmento.SelectedValue.ToString(), ddl_TipoTaxonomia.SelectedValue, "P");

            ddl_CodiEmpr.DataSource = ds;
            ddl_CodiEmpr.DataTextField = ds.Tables[0].Columns["desc_peho"].ToString();
            ddl_CodiEmpr.DataValueField = ds.Tables[0].Columns["codi_pers"].ToString();
            ddl_CodiEmpr.DataBind();

            ddl_CodiEmpr_SelectedIndexChanged(null, null);
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenado_de_empresa(string vCodiEmpr, string vVersInst, string vCodiInfo)
    {
        try
        {
            DataSet ds = GenExcel.GetEmpresas(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), "", vCodiEmpr, ddl_Grupo.SelectedValue.ToString(), ddl_Segmento.SelectedValue.ToString(), ddl_TipoTaxonomia.SelectedValue, "P");

            ddl_CodiEmpr.DataSource = ds;
            ddl_CodiEmpr.DataTextField = ds.Tables[0].Columns["desc_peho"].ToString();
            ddl_CodiEmpr.DataValueField = ds.Tables[0].Columns["codi_pers"].ToString();
            ddl_CodiEmpr.DataBind();
            ddl_CodiEmpr.SelectedValue = vCodiEmpr;

            llenado_de_versiones(vVersInst, vCodiInfo);
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenado_de_periodos()
    {
        try
        {
            DataTable dt = GenExcel.getPersCorrInst(ddl_CodiEmpr.SelectedValue);

            ddl_CorrInst.DataSource = dt;
            ddl_CorrInst.DataTextField = dt.Columns["desc_inst"].ToString();
            ddl_CorrInst.DataValueField = dt.Columns["corr_inst"].ToString();
            ddl_CorrInst.DataBind();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenado_de_periodos(string vCorrInst)
    {
        try
        {
            DataTable dt = GenExcel.getPersCorrInst(ddl_CodiEmpr.SelectedValue);

            ddl_CorrInst.DataSource = dt;
            ddl_CorrInst.DataTextField = dt.Columns["desc_inst"].ToString();
            ddl_CorrInst.DataValueField = dt.Columns["corr_inst"].ToString();
            ddl_CorrInst.DataBind();
            ddl_CorrInst.SelectedValue = vCorrInst;
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenado_de_versiones()
    {
        try
        {
            DataTable dt = new DataTable();
            if (rb_VersInst.SelectedValue == "S")
            {
                dt = GenExcel.getVersInst(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue);
                
            }
            else
            {
                dt = GenExcel.getVersInstExte(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, _goSessionWeb.CODI_USUA);
            }

            if (dt.Rows.Count > 0)
            {
                ddl_VersInst.DataSource = dt;
                ddl_VersInst.DataTextField = dt.Columns["vers_inst"].ToString();
                ddl_VersInst.DataValueField = dt.Columns["vers_inst"].ToString();
                ddl_VersInst.DataBind();
                ddl_VersInst_SelectedIndexChanged(null, null);
            }
            else
            {
                ddl_VersInst.Items.Clear();
                lb_error.Text = "";
                lb_error.Visible = true;
                lb_error.Text = "No se encontraron datos para la empresa y periodo seleccionados. Pruebe seleccionado otra empresa, periodo, etc.";
            }
        }
        catch (Exception ex)
        {
            lb_error.Text = "";
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenado_de_versiones(string vVersInst, string CodiInfo)
    {
        try
        {
            DataTable dt = GenExcel.getVersInst(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue);
            if (dt.Rows.Count > 0)
            {
                ddl_VersInst.DataSource = dt;
                ddl_VersInst.DataTextField = dt.Columns["vers_inst"].ToString();
                ddl_VersInst.DataValueField = dt.Columns["vers_inst"].ToString();
                ddl_VersInst.DataBind();
                ddl_VersInst.SelectedValue = vVersInst;

                llenado_de_informes(CodiInfo);
            }
            else
            {
                lb_error.Text = "";
                lb_error.Visible = true;
                lb_error.Text = "No se encontraron datos para la empresa y periodo seleccionados";
            }
        }
        catch (Exception ex)
        {
            lb_error.Text = "";
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenado_de_informes()
    {
        try
        {
            DataTable ds = GenExcel.getInformesUsables(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue, rbl_tipoInfo.SelectedValue,ddl_TipoTaxonomia.SelectedValue);

            ddl_CodiInfo.DataSource = ds;
            ddl_CodiInfo.DataTextField = ds.Columns[1].ToString();
            ddl_CodiInfo.DataValueField = ds.Columns[0].ToString();
            ddl_CodiInfo.DataBind();
            ddl_CodiInfo_SelectedIndexChanged(null, null);
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            if (ddl_VersInst.SelectedValue.Length == 0)
                lb_error.Text = "No existen datos para la selección actual.";
            else
                lb_error.Text = "Ocurrió un error recuperando los informes usables para la seleccion actual.";
        }
    }
    protected void llenado_de_informes(string vCodiInfo)
    {
        try
        {
            DataTable ds = GenExcel.getInformesUsables(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue, rbl_tipoInfo.SelectedValue, ddl_TipoTaxonomia.SelectedValue);

            ddl_CodiInfo.DataSource = ds;
            ddl_CodiInfo.DataTextField = ds.Columns[1].ToString();
            ddl_CodiInfo.DataValueField = ds.Columns[0].ToString();
            ddl_CodiInfo.DataBind();

            ddl_CodiInfo.SelectedValue = vCodiInfo;
            ddl_CodiInfo_SelectedIndexChanged(null, null);
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenado_de_informes_Dimension()
    {
        try
        {
            DataTable dt = GenExcel.getInformesDimension(ddl_TipoTaxonomia.SelectedValue, rbl_tipoInfo.SelectedValue,ddl_CodiEmpr.SelectedValue,ddl_CorrInst.SelectedValue);
          
                ddl_Dime.Enabled = true;
                ddl_CodiInfo.DataSource = dt;
                ddl_CodiInfo.DataTextField = dt.Columns[1].ToString();
                ddl_CodiInfo.DataValueField = dt.Columns[0].ToString();
                ddl_CodiInfo.DataBind();
                ddl_CodiInfo_SelectedIndexChanged(null, null);
       
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenado_de_Dimension(string Informe)
    {
        try
        {
            DataTable ds = GenExcel.getDimensionesUsables(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), Informe).Tables[0];
            if (ds.Rows.Count > 0)
            {
                ddl_Dime.DataSource = ds;
                ddl_Dime.DataTextField = ds.Columns["desc_dime"].ToString();
                ddl_Dime.DataValueField = ds.Columns["codi_dime"].ToString();
                ddl_Dime.DataBind();
                ddl_Dime_SelectedIndexChanged(null,null);
            }
            else
            {
                ddl_Dime.Enabled = false;
            }
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenado_de_moneda()
    {
        ParaEmprController _loParaEmpr = new ParaEmprController();
        DataTable dtParaEmpr = _loParaEmpr.readParaEmprDt("L", 1, 100, null, "mone", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        this.ddlTipoMone.Items.Clear();
        foreach (DataRow item in dtParaEmpr.Rows)
        {
            this.ddlTipoMone.Items.Add(new ListItem(item["desc_paem"].ToString()+" ("+item["valo_paem"].ToString()+")",item["codi_paem"].ToString()));
        }
        this.ddlTipoMone.DataBind();
        var loResu = _loParaEmpr.readParaEmpr("S", 0, 0, null, "ALL", "MONE_LOCA", null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlSelecciona(ddlTipoMone, loResu.CODI_PAEM);
    }
    protected void Procesar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            string vCodiInfo;
            vCodiInfo = ddl_CodiInfo.SelectedValue.Substring(0, ddl_CodiInfo.SelectedValue.IndexOf("|"));
            DataTable dt_DescConc = new DataTable();
            if (rbl_TipoRepo.SelectedValue == "Informe")
            {
                MantencionParametros para = new MantencionParametros();
                Conexion con = new Conexion();
                string sRutaXML = string.Empty;
                string sRutaXML2 = string.Empty;
                
                if(chkMoneOrig.Checked)
                    dt_DescConc = GenExcel.getDatosReporte(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue, vCodiInfo, "C", "MONE_ORIG");
                else
                    dt_DescConc = GenExcel.getDatosReporte(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue, vCodiInfo, "C", ddlTipoMone.SelectedValue);

                if (ckbTraspuesto.Checked)
                {
                    dt_DescConc.Columns.Remove("negr_conc");
                    dt_DescConc.Columns.Remove("nive_conc");
                    DataTable ldTraspuesto = TrasponerDT.Transponer2(dt_DescConc);
                    sRutaXML = @para.getPathWebb() + @"\librerias\sheets\" + vCodiInfo + "_" + ddl_CodiEmpr.SelectedValue + "_" + ddl_CorrInst.SelectedValue + "_" + ddl_VersInst.SelectedValue + "_t.html";
                    sRutaXML2 = "..\\librerias\\sheets\\" + vCodiInfo + "_" + ddl_CodiEmpr.SelectedValue + "_" + ddl_CorrInst.SelectedValue + "_" + ddl_VersInst.SelectedValue + "_t.html";
                    ruta_html.Text = sRutaXML2;
                    GenExcel.GeneradorHTMLTranspuesto(sRutaXML, ldTraspuesto, vCodiInfo);
                }
                else
                {
                    sRutaXML = @para.getPathWebb() + @"\librerias\sheets\" + vCodiInfo + "_" + ddl_CodiEmpr.SelectedValue + "_" + ddl_CorrInst.SelectedValue + "_" + ddl_VersInst.SelectedValue + ".html";
                    sRutaXML2 = "..\\librerias\\sheets\\" + vCodiInfo + "_" + ddl_CodiEmpr.SelectedValue + "_" + ddl_CorrInst.SelectedValue + "_" + ddl_VersInst.SelectedValue + ".html";
                    ruta_html.Text = sRutaXML2;
                    GenExcel.GeneradorHTML(sRutaXML, dt_DescConc, vCodiInfo,ddl_CodiInfo.SelectedItem.ToString(), true, ddl_CorrInst.SelectedValue, ddl_CodiEmpr.SelectedItem.ToString());
                }
            }
            else
            {
                DbaxEmpresaPeriodoController EmprPerio= new DbaxEmpresaPeriodoController();
                //dimesiones  con un eje
                MantencionParametros para = new MantencionParametros();
                string sRutaXML = @para.getPathWebb() + @"\librerias\sheets\" + vCodiInfo + "_" + para.getPostFijo(ddl_Dime.SelectedValue, ":") + "_" + ddl_CodiEmpr.SelectedValue + "_" + ddl_CorrInst.SelectedValue + "_" + ddl_VersInst.SelectedValue + ".html";
                string sRutaXML2 = "..\\librerias\\sheets\\" + vCodiInfo + "_" + para.getPostFijo(ddl_Dime.SelectedValue, ":") + "_" + ddl_CodiEmpr.SelectedValue + "_" + ddl_CorrInst.SelectedValue + "_" + ddl_VersInst.SelectedValue + ".html";
                ruta_html.Text = sRutaXML2;
                if(chkMoneOrig.Checked)
                    dt_DescConc = EmprPerio.GenerarDimensiones(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue, vCodiInfo, ddl_Dime.SelectedValue, ddl_TipoTaxonomia.SelectedValue, "MONE_ORIG");
                else
                    dt_DescConc = EmprPerio.GenerarDimensiones(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue, vCodiInfo, ddl_Dime.SelectedValue, ddl_TipoTaxonomia.SelectedValue, ddlTipoMone.SelectedValue);
                string vPrefDime = ddl_Dime.SelectedValue.Substring(0, ddl_Dime.SelectedValue.IndexOf(":"));
                string CodiDime = ddl_Dime.SelectedValue.Substring(ddl_Dime.SelectedValue.IndexOf(":") + 1);

                DataTable dt_DimeAxis = EmprPerio.GetEjesDimension(vCodiInfo, vPrefDime, CodiDime);
                if (ckbTraspuesto.Checked)
                {
                    dt_DescConc.Columns.Remove("negr_conc");
                    dt_DescConc = EmprPerio.GenerateTransposedTable(dt_DescConc);
                }
                GenExcel.GeneradorHTMLDimensiones(sRutaXML, dt_DescConc, dt_DimeAxis.Rows.Count, true, ddl_CorrInst.SelectedValue, ddl_CodiInfo.SelectedItem.ToString(), ddl_CodiEmpr.SelectedItem.ToString());
            }
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void guardarArchivo(object sender, ImageClickEventArgs e)
    {
        try
        {
            tb_html.Text = "<html><head><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" /></head><body>" + tb_html.Text + "</body></html>";
            Response.Clear();
            Response.ContentType = "application/excel";
            Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ddl_CodiInfo.SelectedValue.Substring(0, ddl_CodiInfo.SelectedValue.IndexOf("|")) + ".xls");
            Response.Write(HttpUtility.UrlDecode(tb_html.Text,Encoding.GetEncoding("utf-8")));
            //Response.Flush();
            Response.End();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void Filtro_Empresa_TextChanged(object sender, EventArgs e)
    {
        llenado_de_empresa();
        //UpdatePanel2.Update();
    }
    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList(string prefixText, int count, string contextKey)
    {
        GeneracionExcel GenExcel = new GeneracionExcel();
        string gGrupoEmpr = "", gSegmEmpr = "";
        gGrupoEmpr = (string)HttpContext.Current.Session["grupoEmpr"];
        gSegmEmpr = (string)HttpContext.Current.Session["SegmEmpr"];
        DataTable dt = GenExcel.GetEmpresas("1", "1","", prefixText, gGrupoEmpr, gSegmEmpr,"", "P").Tables[0];
        string[] resultados = new string[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            resultados[i] = dt.Rows[i][1].ToString();
        }
        return resultados;
    }
    protected void ddl_CodiEmpr_SelectedIndexChanged(object sender, EventArgs e)
    {
        llenado_de_versiones();
        //if (rbl_TipoRepo.SelectedValue == "Informe")
        //{ 
        //llenado_de_informes();
        //}
        //else
        //{ 
        //    llenado_de_informes_Dimension(); 
        //}
    }
    protected void ib_Rescatar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
     
            string sRutaXML2 = "";
            string vCodiInfo;
            MantencionParametros para = new MantencionParametros();
            vCodiInfo = ddl_CodiInfo.SelectedValue.Substring(0, ddl_CodiInfo.SelectedValue.IndexOf("|"));

            if (rbl_TipoRepo.SelectedValue == "Informe")
            {
                if (ckbTraspuesto.Checked)
                {
                    sRutaXML2 = @para.getPathWebb() + @"\librerias\sheets\" + vCodiInfo + "_" + ddl_CodiEmpr.SelectedValue + "_" + ddl_CorrInst.SelectedValue + "_" + ddl_VersInst.SelectedValue + "_t.html";
                }
                else
                {
                    sRutaXML2 = @para.getPathWebb() + @"\librerias\sheets\" + vCodiInfo + "_" + ddl_CodiEmpr.SelectedValue + "_" + ddl_CorrInst.SelectedValue + "_" + ddl_VersInst.SelectedValue + ".html";
                }
            }
            else
            {
                
                sRutaXML2 = @para.getPathWebb() + @"\librerias\sheets\" + vCodiInfo + "_" + para.getPostFijo(ddl_Dime.SelectedValue, ":") + "_" + ddl_CodiEmpr.SelectedValue + "_" + ddl_CorrInst.SelectedValue + "_" + ddl_VersInst.SelectedValue + ".html";
            }

            if (!File.Exists(sRutaXML2))
            {
                Procesar_Click(null, null);
            }
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void ddl_VersInst_SelectedIndexChanged(object sender, EventArgs e)
    {
        esUltimaVersion();
        llenado_de_informes();
    }
    protected void ddl_CorrInst_SelectedIndexChanged(object sender, EventArgs e)
    {
        llenado_de_versiones();
    }
    protected void rbl_tipoInfo_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (rbl_TipoRepo.SelectedValue != "Dimension")
        //{ 
        llenado_de_informes();
        //}
        //else
        //{ 
        //    llenado_de_informes_Dimension(); 
        //}
    }
    protected void rbl_rbl_TipoRepo_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (rbl_TipoRepo.SelectedValue == "Dimension")
        //{
        //    llenado_de_informes_Dimension();
        //    ddl_Dime.Enabled = true;
        //    //rbl_tipoInfo.Enabled = false;

        //}
        //else
        //{
        //    ddl_Dime.Enabled = false;
        llenado_de_informes();
        //    rbl_tipoInfo.Enabled = true;
        //}
    }
    protected void ddl_CodiInfo_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddl_CodiInfo.SelectedValue.ToString() == "")
        {
            Procesar.Enabled = false;
            Procesar.Visible = false;

            ib_Rescatar.Enabled = false;
            ib_Rescatar.Visible = false;
        }
        else
        {
            Procesar.Enabled = true;
            Procesar.Visible = true;

            ib_Rescatar.Enabled = true;
            ib_Rescatar.Visible = true;
        }

        ckbTraspuesto.Checked = false;
        string vTipoInfo;
        vTipoInfo = ddl_CodiInfo.SelectedValue.Substring(ddl_CodiInfo.SelectedValue.IndexOf("|") + 1);
        if (vTipoInfo == "D")
        {
            ddl_Dime.Enabled = true;
            rbl_TipoRepo.SelectedIndex = 0;
            llenado_de_Dimension(ddl_CodiInfo.SelectedValue.Substring(0, ddl_CodiInfo.SelectedValue.IndexOf("|")));
        }
        else
        {
            ddl_Dime.Items.Clear();
            ddl_Dime.Enabled = false;
            rbl_TipoRepo.SelectedIndex = 1;
        }
        UpdatePanel2.Update();
    }
    protected void ddl_Dime_SelectedIndexChanged(object sender, EventArgs e)
    {
        string vPrefDime = ddl_Dime.SelectedValue.Substring(0, ddl_Dime.SelectedValue.IndexOf(":"));
        string vCodiDime = ddl_Dime.SelectedValue.Substring(ddl_Dime.SelectedValue.IndexOf(":") + 1);
        DataTable dtDimeDeta = GenExcel.getDetalleDimension(ddl_CodiInfo.SelectedValue.Substring(0, ddl_CodiInfo.SelectedValue.IndexOf("|")), vPrefDime, vCodiDime);

        if (dtDimeDeta.Rows[0]["dime_tran"].ToString() == "1")
            ckbTraspuesto.Checked = true;
        else
            ckbTraspuesto.Checked = false;
    }
    protected void ddl_Grupo_SelectedIndexChanged(object sender, EventArgs e)
    {
        GrupoEmpr = ddl_Grupo.SelectedValue.ToString();
        Session["GrupoEmpr"] = GrupoEmpr;
        llenado_de_empresa();
    }
    protected void ddl_Segmento_SelectedIndexChanged(object sender, EventArgs e)
    {
        SegmEmpr = ddl_Segmento.SelectedValue.ToString();
        Session["SegmEmpr"] = SegmEmpr;
        llenado_de_empresa();
    }
    protected void ddl_TipoTaxonomia_SelectedIndexChanged(object sender, EventArgs e)
    {
        TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue;
        llenado_de_empresa();
    }
    protected void rb_VersInst_SelectedIndexChanged(object sender, EventArgs e)
    {
        
        llenado_de_versiones();
    }
    protected void chkMoneOrig_CheckedChanged(object sender, EventArgs e)
    {
        if (chkMoneOrig.Checked)
        {
            ddlTipoMone.Enabled = false;
            ddlTipoMone.Visible= false;
            
        }
        else
        {
            ddlTipoMone.Enabled = true;
            ddlTipoMone.Visible = true;
        }
    }

    protected void esUltimaVersion()
    {
        DataTable dt = GenExcel.getEsUltimaVers(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue);
        if (dt.Rows.Count > 0 && dt.Rows[0][0].ToString() != "0")
        {
            lb_error.Text = "";
            lb_error.Visible = true;
            lb_error.Text = "La versión seleccionada puede no corresponder a los ultimos datos disponibles en la SVS";
        }
        else
        {
            lb_error.Text = "";
            lb_error.Visible = false;
        }
    }
}