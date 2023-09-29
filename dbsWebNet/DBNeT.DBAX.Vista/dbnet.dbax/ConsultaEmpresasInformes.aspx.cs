using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.Base.Controlador;
using System.IO;

public partial class ConsultaEmpresasInformes : System.Web.UI.Page
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
        this.lb_error.Text = string.Empty;
        if (!IsPostBack)
        {
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
            SysParamController _loSysaParam = new SysParamController();
            var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_DEFE_TAXO", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            this.ddl_TipoTaxonomia.SelectedValue = loResultado.PARAM_VALUE;

            llenado_de_periodos();
            llenado_de_empresa();
            //llenado_de_contextos();
            llenado_de_informes();
            llenado_de_moneda();
        }
        if (ckbTodos.Checked)
        {
            //SeleccionaTodos();
        }
    }

    protected void llenado_de_moneda()
    {
        ParaEmprController _loParaEmpr = new ParaEmprController();
        DataTable dtParaEmpr = _loParaEmpr.readParaEmprDt("L", 1, 100, null, "mone", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        this.ddlTipoMone.Items.Clear();
        foreach (DataRow item in dtParaEmpr.Rows)
        {
            this.ddlTipoMone.Items.Add(new ListItem(item["desc_paem"].ToString() + " (" + item["valo_paem"].ToString() + ")", item["codi_paem"].ToString()));
        }
        this.ddlTipoMone.DataBind();
        var loResu = _loParaEmpr.readParaEmpr("S", 0, 0, null, "ALL", "MONE_LOCA", null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlSelecciona(ddlTipoMone, loResu.CODI_PAEM);
    }
    protected void ddl_TipoTaxonomia_SelectedIndexChanged(object sender, EventArgs e)
    {
        TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue;
        llenado_de_empresa();
        llenado_de_informes();
    }
    protected void llenado_de_empresa()
    {
        try
        {
            DataSet ds = GenExcel.GetEmpresas(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), "", "", ddl_Grupo.SelectedValue.ToString(), ddl_Segmento.SelectedValue.ToString(), ddl_TipoTaxonomia.SelectedValue, "P");
            Grilla_Empresas.DataSource = ds;
            Grilla_Empresas.DataBind();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenado_de_informes()
    {
        try
        {
            DataTable ds = GenExcel.getInformesActivos(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_TipoTaxonomia.SelectedValue, "").Tables[0];
            //ddl_CodiInfo.Items.Clear();
            //Grilla_Informes.DataSource = ds;
            //Grilla_Informes.DataBind();
            /*ddl_CodiInfo.DataSource = ds;
            ddl_CodiInfo.DataTextField = ds.Columns["desc_info"].ToString();
            ddl_CodiInfo.DataValueField = ds.Columns["codi_info"].ToString() + "|" + ds.Columns["tipo_info"].ToString();
            ddl_CodiInfo.DataBind();*/
            DataTable dt = new DataTable();
            dt.Columns.Add("codi_info");
            dt.Columns.Add("desc_info");
            for (int i = 0; i < ds.Rows.Count; i++)
            {
                DataRow row = dt.NewRow();
                row["codi_info"] = ds.Rows[i]["codi_info"].ToString() + "|" + ds.Rows[i]["tipo_info"].ToString();
                row["desc_info"] = ds.Rows[i]["desc_info"].ToString();
                dt.Rows.Add(row);
                //ddl_CodiInfo.Items.Add(new ListItem(ds.Rows[i]["desc_info"].ToString(), ds.Rows[i]["codi_info"].ToString() + "|" + ds.Rows[i]["tipo_info"].ToString()));
            }
            Grilla_Informes.DataSource = dt;
            Grilla_Informes.DataBind();
           // llenado_de_contextos();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
   
  
    protected void ddl_Grupo_SelectedIndexChanged(object sender, EventArgs e)
    {
        GrupoEmpr = ddl_Grupo.SelectedValue.ToString();
        Session["GrupoEmpr"] = GrupoEmpr;
        llenado_de_empresa();
        //llenado_de_periodos();
        //ib_Rescatar_Click(null, null);
    }
    protected void ddl_Segmento_SelectedIndexChanged(object sender, EventArgs e)
    {
        SegmEmpr = ddl_Segmento.SelectedValue.ToString();
        Session["SegmEmpr"] = SegmEmpr;
        llenado_de_empresa();
        //llenado_de_periodos();
        //ib_Rescatar_Click(null, null);
    }
    protected void ckbTodos_CheckedChanged(object sender, EventArgs e)
    {
        foreach (GridViewRow fila in Grilla_Empresas.Rows)
        {
            CheckBox seleccion = (CheckBox)fila.FindControl("chkEmpr");
            if (((CheckBox)sender).Checked == true) { seleccion.Checked = true; }
            else { seleccion.Checked = false; }
        }
    }
    protected void Procesar_Click(object sender, ImageClickEventArgs e)
    {
        MantencionParametros para = new MantencionParametros();
        DbaxEmpresaPeriodoController EmprPerio = new DbaxEmpresaPeriodoController();
        string sRutaXML = string.Empty;
        string sRutaXML2 = string.Empty;
        DataTable dt_DescConc, dtDime;
        try
        {
            if (!Directory.Exists(para.getPathWebb() + @"\librerias\sheets\" + _goSessionWeb.CODI_USUA))
                Directory.CreateDirectory(para.getPathWebb() + @"\librerias\sheets\" + _goSessionWeb.CODI_USUA);
            Dictionary<string, string> Informes = new Dictionary<string, string>();
            for (int i = 0; i < Grilla_Informes.Rows.Count; i++)
            {
                CheckBox chkInfo = (CheckBox)Grilla_Informes.Rows[i].Cells[0].FindControl("chkInfo");

                if (chkInfo != null)
                {
                    if (chkInfo.Checked)
                    {
                        Informes.Add(((Label)Grilla_Informes.Rows[i].Cells[1].FindControl("lbCodiInfo")).Text, ((Label)Grilla_Informes.Rows[i].Cells[1].FindControl("lbDescInfo")).Text);
                    }
                }
            }
            Dictionary<string, string> Empresas = new Dictionary<string, string>();
            for (int i = 0; i < Grilla_Empresas.Rows.Count; i++)
            {
                CheckBox chkDelete = (CheckBox)Grilla_Empresas.Rows[i].Cells[0].FindControl("chkEmpr");

                if (chkDelete != null)
                {
                    if (chkDelete.Checked)
                    {

                        
                        Empresas.Add(((Label)Grilla_Empresas.Rows[i].Cells[1].FindControl("lbCodiPers")).Text, ((Label)Grilla_Empresas.Rows[i].Cells[1].FindControl("lbDescPers")).Text);
                    }
                }
            }


            string vEmpresasDesactualizadas = "";
            foreach (KeyValuePair<string, string> kvp in Empresas)
            {
                //  GenExcel.insEmpresaParaInforme(kvp.Key, kvp.Value, ddl_CorrInst.SelectedValue.ToString());


                DataTable dt = GenExcel.getEsUltimaVers(kvp.Key, ddl_CorrInst.SelectedValue, GenExcel.getUltPersVersInst(kvp.Key, ddl_CorrInst.SelectedValue));
                if (dt.Rows.Count > 0 && dt.Rows[0][0].ToString() != "0")
                {
                    vEmpresasDesactualizadas += "[" + kvp.Key.ToString() + "] " + kvp.Value.ToString() + ", ";
                }
            }

            if (vEmpresasDesactualizadas.Length != 0)
            {
                lb_error.Visible = true;       
                lb_error.Text = "Seleccionó la(s) siguiente(s) empresa(s) que pueden tener datos desactualizados: " + vEmpresasDesactualizadas.Substring(0, (vEmpresasDesactualizadas.Length - 2));
            }


            foreach (KeyValuePair<string, string> kvpEmpr in Empresas)
            {
                foreach (KeyValuePair<string, string> kvpInfo in Informes)
                {
                    GenExcel.insEmpresaParaInforme(kvpEmpr.Key, kvpInfo.Key, ddl_CorrInst.SelectedValue.ToString());
                    
                }
            }
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void chkMoneOrig_CheckedChanged(object sender, EventArgs e)
    {
        if (chkMoneOrig.Checked)
        {
            ddlTipoMone.Enabled = false;
            ddlTipoMone.Visible = false;

        }
        else
        {
            ddlTipoMone.Enabled = true;
            ddlTipoMone.Visible = true;
        }
    }
    protected void Grilla_Empr_desc_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Grilla_Empresas.PageIndex = e.NewPageIndex;
        Grilla_Empresas.DataBind();
        llenado_de_empresa();
    }
    protected void RowCreated(object sender, GridViewRowEventArgs e)
    {
        // only apply changes if its DataRow
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // when mouse is over the row, save original color to new attribute, and change it to highlight yellow color
            e.Row.Attributes.Add("onmouseover",
          "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#CCCCCC'");

            // when mouse leaves the row, change the bg color to its original value   
            e.Row.Attributes.Add("onmouseout",
            "this.style.backgroundColor=this.originalstyle;");
        }
    }
    protected void llenado_de_periodos()
    {
        try
        {
            DataTable dt = GenExcel.getPersCorrInst("");
            ddl_CorrInst.DataSource = dt;
            ddl_CorrInst.DataTextField = dt.Columns["desc_inst"].ToString();
            ddl_CorrInst.DataValueField = dt.Columns["corr_inst"].ToString();
            ddl_CorrInst.DataBind();
            //llenado_de_versiones();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void Grilla_Informes_desc_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Grilla_Informes.PageIndex = e.NewPageIndex;
        Grilla_Informes.DataBind();
        llenado_de_informes();
    }
    protected DataTable llenado_de_Dimension(string Informe)
    {
        DataTable ds = new DataTable(); ;
        try
        {
            ds = GenExcel.getDimensionesUsables(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), Informe).Tables[0];
            return ds;
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
            return ds;
        }
    }

}