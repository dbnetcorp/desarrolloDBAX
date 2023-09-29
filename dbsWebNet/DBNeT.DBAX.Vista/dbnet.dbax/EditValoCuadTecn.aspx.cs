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
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;

public partial class Website_Descarga_archivos : System.Web.UI.Page
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
    GuardarXBRL Gxbrl = new GuardarXBRL();
    GeneradorGrupo geneGru = new GeneradorGrupo();
    public string grupoEmpr = "", SegmEmpr = "", TipoTaxonomia = "";
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
            ddl_TipoTaxonomia.SelectedValue = loResultado.PARAM_VALUE;

            llenadoPeriodos();
        }
    }
    protected void llenadoEmpresas()
    {
        try
        {
            DataSet ds = GenExcel.GetEmpresas(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), "", Filtro_Empresa.Text, ddl_Grupo.SelectedValue.ToString(), ddl_Segmento.SelectedValue.ToString(), ddl_TipoTaxonomia.SelectedValue, "P");
            if (ds.Tables[0].Rows.Count > 0)
            {
                ddl_CodiEmpr.DataSource = ds;
                ddl_CodiEmpr.DataTextField = ds.Tables[0].Columns["desc_peho"].ToString();
                ddl_CodiEmpr.DataValueField = ds.Tables[0].Columns["codi_pers"].ToString();
                ddl_CodiEmpr.DataBind();
                llenadoVersiones();
            }
            else
            {
                lb_error.Text = "";
                lb_error.Visible = true;
                lb_error.Text = "No se encontraron empresas para la selección actual.";
            }
            //ddl_CodiEmpr_SelectedIndexChanged(null, null);
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenadoCuadros()
    {
        try
        {
            DataTable dtCuadros = GenExcel.getCuadrosTecnicos(ddlCodiInfo.SelectedValue.ToString());
            if (dtCuadros.Rows.Count > 0)
            {
                ddlCuadTecn.Enabled = true;
                ddlCuadTecn.DataSource = dtCuadros;
                ddlCuadTecn.DataTextField = dtCuadros.Columns["desc_conc"].ToString();
                ddlCuadTecn.DataValueField = dtCuadros.Columns["codigo"].ToString();
                ddlCuadTecn.DataBind();
                ddlCuadTecn_SelectedIndexChanged(null, null);
            }
            else
            {
                ddlCuadTecn.Items.Clear();
                ddlCuadTecn.Enabled = false;
                lb_error.Text = "";
                lb_error.Visible = true;
                lb_error.Text = "No se encontraron cuadros técnicos.";
            }
            //ddl_CodiEmpr_SelectedIndexChanged(null, null);
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenadoInformes()
    {
        try
        {
            DataTable dtInformes = GenExcel.getInformesCuadrosTecnicos();
            if (dtInformes.Rows.Count > 0)
            {
                ddlCodiInfo.Enabled = true;
                ddlCodiInfo.DataSource = dtInformes;
                ddlCodiInfo.DataTextField = dtInformes.Columns["desc_info"].ToString();
                ddlCodiInfo.DataValueField = dtInformes.Columns["codi_info"].ToString();
                ddlCodiInfo.DataBind();
                ddlCodiInfo_SelectedIndexChanged(null, null);
            }
            else
            {
                ddlCodiInfo.Items.Clear();
                ddlCodiInfo.Enabled = false;
                lb_error.Text = "";
                lb_error.Visible = true;
                lb_error.Text = "No se encontraron informes.";
            }
        }
        catch
        {
        }
    }
    protected void llenadoConceptos()
    {
        try
        {
            string[] vCodigos = ddlCuadTecn.SelectedValue.ToString().Split('#');
            DataTable dtConceptos = GenExcel.getConcPorDime(ddlCodiInfo.SelectedValue.ToString(), vCodigos[0], vCodigos[1]);
            if (dtConceptos.Rows.Count > 0)
            {
                ddl_CodiConc.Enabled = true;
                ddl_CodiConc.DataSource = dtConceptos;
                ddl_CodiConc.DataTextField = dtConceptos.Columns["desc_conc"].ToString();
                ddl_CodiConc.DataValueField = dtConceptos.Columns["codigo"].ToString();
                ddl_CodiConc.DataBind();
                ddl_CodiConc_SelectedIndexChanged(null,null);
            }
            else
            {
                ddl_CodiConc.Items.Clear();
                ddl_CodiConc.Enabled = false;
                lb_error.Text = "";
                lb_error.Visible = true;
                lb_error.Text = "No se encontraron conceptos para la selección actual.";
            }
            //ddl_CodiEmpr_SelectedIndexChanged(null, null);
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenadoPeriodos()
    {
        try
        {
            DataTable dt = GenExcel.getPersCorrInst(ddl_CodiEmpr.SelectedValue);

            ddl_CorrInst.DataSource = dt;
            ddl_CorrInst.DataTextField = dt.Columns["desc_inst"].ToString();
            ddl_CorrInst.DataValueField = dt.Columns["corr_inst"].ToString();
            ddl_CorrInst.DataBind();
            llenadoEmpresas();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenadoVersiones()
    {
        try
        {
            DataTable dt = GenExcel.getVersInst(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue);
            if (dt.Rows.Count > 0)
            {
                ddl_VersInst.Enabled = true;
                ddl_VersInst.DataSource = dt;
                ddl_VersInst.DataTextField = dt.Columns["vers_inst"].ToString();
                ddl_VersInst.DataValueField = dt.Columns["vers_inst"].ToString();
                ddl_VersInst.DataBind();
                ddl_VersInst_SelectedIndexChanged(null, null);
            }
            else
            {
                ddl_VersInst.Items.Clear();
                ddl_VersInst.Enabled = false;
            }
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void ddl_CodiEmpr_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            llenadoVersiones();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void Filtro_Empresa_TextChanged(object sender, EventArgs e)
    {
        llenadoEmpresas();
    }
    protected void Filtro_Concepto_TextChanged(object sender, EventArgs e)
    {
         llenadoConceptos();
    }
    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionListEmpresa(string prefixText, int count, string contextKey)
    {
        GeneracionExcel GenExcel = new GeneracionExcel();
        string _gGrupoEmpr = "", _gSegmEmpr = "";
        _gGrupoEmpr = (string)HttpContext.Current.Session["grupoEmpr"];
        _gSegmEmpr = (string)HttpContext.Current.Session["SegmEmpr"];
        DataTable dt = GenExcel.GetEmpresas("1", "1", "",prefixText, _gGrupoEmpr, _gSegmEmpr, "", "P").Tables[0];
        string[] resultados = new string[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            resultados[i] = dt.Rows[i][1].ToString();
        }
        return resultados;
    }
    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionListConcepto(string prefixText, int count, string contextKey)
    {
        GeneracionExcel GenExcel = new GeneracionExcel();
        string _gCodiEmpr = "", _gCorrInst = "", _gVersInst = "";
        _gCodiEmpr = (string)HttpContext.Current.Session["CodiEmpr1"];
        _gCorrInst = (string)HttpContext.Current.Session["CorrInst1"];
        _gVersInst = (string)HttpContext.Current.Session["VersInst1"];
        DataTable dt = GenExcel.getConcEmprInstVers(_gCodiEmpr, _gCorrInst, _gVersInst, prefixText);
        string[] resultados = new string[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            resultados[i] = dt.Rows[i]["desc_conc"].ToString();
        }
        return resultados;
    }
    protected void ddl_CorrInst_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            llenadoVersiones();
            try
            {

            }
            catch
            {
                lb_error.Text = "";
                lb_error.Visible = true;
                lb_error.Text = "No se encontraron datos cargados para la empresa y periodo seleccionados";
            }
        }
        catch (Exception ex)
        {
            lb_error.Text = "";
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void ddl_VersInst_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            Session["CodiEmpr1"] = ddl_CodiEmpr.SelectedValue;
            Session["CorrInst1"] = ddl_CorrInst.SelectedValue;
            Session["VersInst1"] = ddl_VersInst.SelectedValue;

            llenadoInformes();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
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
    protected void ddl_Grupo_Select(object sender, EventArgs e)
    {
        grupoEmpr = ddl_Grupo.SelectedValue.ToString();
        Session["grupoEmpr"] = grupoEmpr;
        llenadoEmpresas();
    }
    protected void ddl_Segmento_Select(object sender, EventArgs e)
    {
        SegmEmpr = ddl_Segmento.SelectedValue.ToString();
        Session["SegmEmpr"] = SegmEmpr;
        llenadoEmpresas();
    }
    protected void ddl_TipoTaxonomia_SelectedIndexChanged(object sender, EventArgs e)
    {
        TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue;
        Session["TipoTaxonomia"] = TipoTaxonomia;
        llenadoEmpresas();
    }
    protected void ddl_CodiConc_SelectedIndexChanged(object sender, EventArgs e)
    {
        txtValoDola.Text = "";
        txtValoPeso.Text = "";
        txtValoUF.Text = "";

        rescataConcepto();
        llenadoContextos();
    }
    protected void rescataConcepto()
    {
        try
        {
            string[] vCodigos = ddl_CodiConc.SelectedValue.ToString().Split('#');
            DataTable dtConceptos = GenExcel.getConceptoPrefConc(vCodigos[0], vCodigos[1]);
            if (dtConceptos.Rows.Count > 0)
            {
                lblCodiConc.Text = dtConceptos.Rows[0]["pref_conc"].ToString() + "_" + dtConceptos.Rows[0]["codi_conc"].ToString();
            }
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void ddlFechas_SelectedIndexChanged(object sender, EventArgs e)
    {
        llenadoContextos();
    }
    protected void llenadoContextos()
    {
        try
        {
            //string CntxDime = "0";
            //if (chkCntxDime.Checked)
            //    CntxDime = "1";
            //string[] vCodigos = ddl_CodiConc.SelectedValue.ToString().Split('#');
            //DataTable dtContextos = Contextos.getCntxEmprInstVersFech(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue, vCodigos[0],vCodigos[1], ddlFechas.SelectedValue, CntxDime);
            //if (dtContextos.Rows.Count > 0)
            //{
            //    ddlCodiCntx.Enabled = true;
            //    ddlCodiCntx.DataSource = dtContextos;
            //    ddlCodiCntx.DataTextField = dtContextos.Columns["codi_cntx"].ToString();
            //    ddlCodiCntx.DataValueField = dtContextos.Columns["codi_cntx"].ToString();
            //    ddlCodiCntx.DataBind();
            //    ddlCodiCntx_SelectedIndexChanged(null, null);
            //}
            //else
            //{
            //    ddlCodiCntx.Items.Clear();
            //    ddlCodiCntx.Enabled = false;

            //    txtValoPeso.Enabled = false;
            //    txtValoDola.Enabled = false;
            //    txtValoUF.Enabled = false;

            //    txtValoPeso.Text = "";
            //    txtValoDola.Text = "";
            //    txtValoUF.Text = "";
            //}

            string[] vMiembro1 = ddlMiembro1.SelectedValue.ToString().Split('#');
            string[] vMiembro2 = ddlMiembro2.SelectedValue.ToString().Split('#');
            string[] vCodigos = ddl_CodiConc.SelectedValue.ToString().Split('#');

            string[] vCodiDime = ddlCuadTecn.SelectedValue.ToString().Split('#');
            DataTable dtEjes = GenExcel.getEjesPorDimension(ddlCodiInfo.SelectedValue, vCodiDime[0].ToString(), vCodiDime[1].ToString());
            DataTable dtContextos = new DataTable();

            if (dtEjes.Rows.Count == 2)
            {
                dtContextos = Contextos.getCntxDimension2Ejes(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue, vMiembro1[3], vMiembro1[4], vMiembro1[0], vMiembro1[1], vMiembro1[2], vMiembro2[3], vMiembro2[4], vMiembro2[0], vMiembro2[1], vMiembro2[2], vCodigos[0], vCodigos[1]);
            }
            else
            {
                dtContextos = Contextos.getCntxDimension1Eje(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue, vMiembro1[3], vMiembro1[4], vMiembro1[0], vMiembro1[1], vMiembro1[2], vCodigos[0], vCodigos[1]);
            }

            if (dtContextos.Rows.Count > 0)
            {
                ddlCodiCntx.Enabled = true;
                ddlCodiCntx.DataSource = dtContextos;
                ddlCodiCntx.DataTextField = dtContextos.Columns["codi_cntx"].ToString();
                ddlCodiCntx.DataValueField = dtContextos.Columns["codi_cntx"].ToString();
                ddlCodiCntx.DataBind();
            }
            else
            {
                ddlCodiCntx.Items.Clear();
                ddlCodiCntx.Enabled = false;

                txtValoPeso.Enabled = false;
                txtValoDola.Enabled = false;
                txtValoUF.Enabled = false;

                txtValoPeso.Text = "";
                txtValoDola.Text = "";
                txtValoUF.Text = "";
            }
            
            

            ddlCodiCntx_SelectedIndexChanged(null, null);
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void llenadoRamos()
    {
        try
        {
            string[] vCodigos = ddlCuadTecn.SelectedValue.ToString().Split('#');
            DataTable dtConceptos = GenExcel.getConcPorDime(ddlCodiInfo.SelectedValue.ToString(), vCodigos[0], vCodigos[1]);
            if (dtConceptos.Rows.Count > 0)
            {
                ddl_CodiConc.Enabled = true;
                ddl_CodiConc.DataSource = dtConceptos;
                ddl_CodiConc.DataTextField = dtConceptos.Columns["desc_conc"].ToString();
                ddl_CodiConc.DataValueField = dtConceptos.Columns["codigo"].ToString();
                ddl_CodiConc.DataBind();
                ddl_CodiConc_SelectedIndexChanged(null, null);
            }
            else
            {
                ddl_CodiConc.Items.Clear();
                ddl_CodiConc.Enabled = false;
                lb_error.Text = "";
                lb_error.Visible = true;
                lb_error.Text = "No se encontraron conceptos para la selección actual.";
            }
            //ddl_CodiEmpr_SelectedIndexChanged(null, null);
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void chkCntxDime_CheckedChanged(object sender, EventArgs e)
    {
        llenadoContextos();
    }
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            if (ddlCodiCntx.Items.Count > 0)
            {
                string[] vCodigos = ddl_CodiConc.SelectedValue.ToString().Split('#');
                DataTable dtValores = GenExcel.getValoEmprInstVersPrefConcCntx(ddl_CodiEmpr.SelectedValue.ToString(), ddl_CorrInst.SelectedValue.ToString(), ddl_VersInst.SelectedValue.ToString(), vCodigos[0], vCodigos[1], ddlCodiCntx.SelectedValue.ToString());

                if (dtValores.Rows.Count > 0)
                {
                    GenExcel.updValorInstConc(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue, vCodigos[0].ToString(), vCodigos[1].ToString(), ddlCodiCntx.SelectedValue, txtValoPeso.Text, txtValoUF.Text, txtValoDola.Text);
                }
                else
                {
                    GenExcel.insValorEdicionInstConc(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue, vCodigos[0].ToString(), vCodigos[1].ToString(), ddlCodiCntx.SelectedValue, txtValoPeso.Text, txtValoUF.Text, txtValoDola.Text);
                }

                string message = "alert('Cambio ejecutado')";
                ScriptManager.RegisterClientScriptBlock((sender as Control), this.GetType(), "alert", message, true);
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {

    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {

    }
    protected void ddlCuadTecn_SelectedIndexChanged(object sender, EventArgs e)
    {
        string[] vCodigos = ddlCuadTecn.SelectedValue.ToString().Split('#');
        DataTable dtEjes = GenExcel.getEjesPorDimension(ddlCodiInfo.SelectedValue, vCodigos[0].ToString(), vCodigos[1].ToString());

        if (dtEjes.Rows.Count > 0)
        {
            lblEje1.Text = dtEjes.Rows[0]["desc_conc"].ToString();
            DataTable dtMiembros = GenExcel.getMiembrosPorEjeEmpresaInstanciaVersion(ddl_CodiEmpr.SelectedValue.ToString(), ddl_CorrInst.SelectedValue.ToString(), ddl_VersInst.SelectedValue.ToString(), dtEjes.Rows[0]["pref_axis"].ToString(), dtEjes.Rows[0]["codi_axis"].ToString());
            
            ddlMiembro1.Enabled = true;
            ddlMiembro1.DataSource = dtMiembros;
            ddlMiembro1.DataTextField = dtMiembros.Columns["desc_conc"].ToString();
            ddlMiembro1.DataValueField = dtMiembros.Columns["codigo"].ToString();
            ddlMiembro1.DataBind();
            //ddl_CodiConc_SelectedIndexChanged(null, null);

            lblEje2.Visible = false;
            ddlMiembro2.Items.Clear();
            ddlMiembro2.Visible = false;
        }

        if (dtEjes.Rows.Count == 2)
        {
            lblEje2.Text = dtEjes.Rows[1]["desc_conc"].ToString();
            DataTable dtMiembros = GenExcel.getMiembrosPorEjeEmpresaInstanciaVersion(ddl_CodiEmpr.SelectedValue.ToString(), ddl_CorrInst.SelectedValue.ToString(), ddl_VersInst.SelectedValue.ToString(), dtEjes.Rows[1]["pref_axis"].ToString(), dtEjes.Rows[1]["codi_axis"].ToString());

            ddlMiembro2.Enabled = true;
            ddlMiembro2.DataSource = dtMiembros;
            ddlMiembro2.DataTextField = dtMiembros.Columns["desc_conc"].ToString();
            ddlMiembro2.DataValueField = dtMiembros.Columns["codigo"].ToString();
            ddlMiembro2.DataBind();
            //ddl_CodiConc_SelectedIndexChanged(null, null);

            lblEje2.Visible = true;
            ddlMiembro2.Visible = true;
        }
        llenadoConceptos();
        llenadoContextos();
    }
    protected void ddlCodiInfo_SelectedIndexChanged(object sender, EventArgs e)
    {
        llenadoCuadros();
    }
    protected void ddlMiembro1_SelectedIndexChanged(object sender, EventArgs e)
    {
        llenadoContextos();
    }
    protected void ddlMiembro2_SelectedIndexChanged(object sender, EventArgs e)
    {
        llenadoContextos();
    }
    protected void ddlCodiCntx_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlCodiCntx.Items.Count > 0)
        {
            txtValoDola.Enabled = true;
            txtValoPeso.Enabled = true;
            txtValoUF.Enabled = true;

            txtValoDola.Text = "";
            txtValoPeso.Text = "";
            txtValoUF.Text = "";

            string[] vCodigos = ddl_CodiConc.SelectedValue.ToString().Split('#');
            DataTable dtValores = GenExcel.getValoEmprInstVersPrefConcCntx(ddl_CodiEmpr.SelectedValue.ToString(), ddl_CorrInst.SelectedValue.ToString(), ddl_VersInst.SelectedValue.ToString(), vCodigos[0], vCodigos[1], ddlCodiCntx.SelectedValue.ToString());

            if (dtValores.Rows.Count > 0)
            {
                txtValoPeso.Text = dtValores.Rows[0]["valo_cntx"].ToString();
                txtValoDola.Text = dtValores.Rows[0]["valo_inte"].ToString();
                txtValoUF.Text = dtValores.Rows[0]["valo_refe"].ToString();
            }
        }
        else
        {
            txtValoDola.Enabled = false;
            txtValoDola.Text = "";

            txtValoPeso.Enabled = false;
            txtValoPeso.Text = "";

            txtValoUF.Enabled = false;
            txtValoUF.Text = "";
        }
    }
}