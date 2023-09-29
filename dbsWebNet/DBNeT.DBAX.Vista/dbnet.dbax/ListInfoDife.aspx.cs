using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.IO;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;


public partial class ListInfoDife : System.Web.UI.Page
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
    GuardarXBRL GuarXBRL = new GuardarXBRL();
    GeneradorGrupo geneGru = new GeneradorGrupo();
    public string GrupoEmpr = "", SegmEmpr = "", TipoTaxonomia = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        lb_error.Visible = false;
        if (!IsPostBack)
        {
            //llenado de combobox de  grupo
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

            llenado_de_periodos();
            llenado_de_grilla();
        }
    }

    private void llenado_de_grilla()
    {
        Grilla_Empr.DataSource = GenExcel.GetEmpresas("1", "1", ddl_CorrInst.SelectedValue,Filtro_Empresa.Text, ddl_Grupo.SelectedValue.ToString(), ddl_Segmento.SelectedValue.ToString(),ddl_TipoTaxonomia.SelectedValue, "C").Tables[0];
        Grilla_Empr.DataBind();

        //Grilla_Empr.Columns[1].Visible = false;
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
      
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void Filtro_Empresa_TextChanged(object sender, EventArgs e)
    {
        llenado_de_grilla();
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList(string prefixText, int count, string contextKey)
    {
        GeneracionExcel GenExcel = new GeneracionExcel();
        string gGrupoEmpr = "", gSegmEmpr = "";
        gGrupoEmpr = (string)HttpContext.Current.Session["grupoEmpr"];
        gSegmEmpr = (string)HttpContext.Current.Session["SegmEmpr"];
        DataTable dt = GenExcel.GetEmpresas("1", "1", "", prefixText, gGrupoEmpr, gSegmEmpr, "", "P").Tables[0];
        string[] resultados = new string[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            resultados[i] = dt.Rows[i][1].ToString();
        }
        return resultados;
    }

    protected void Grilla_Empr_RowDataBound(object sender, GridViewRowEventArgs e)
    {
       // e.Row.Cells[1].Visible = false;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DropDownList ddl1;
            DataTable dtVersiones = GenExcel.getVersInst(e.Row.Cells[1].Text, ddl_CorrInst.SelectedValue);
            if (dtVersiones.Rows.Count > 1)
            {
                ddl1 = (DropDownList)e.Row.FindControl("ddl_Version");
                ddl1.DataSource = dtVersiones;
                ddl1.DataTextField = "vers_inst";
                ddl1.DataValueField = "vers_inst1";
                ddl1.DataBind();
            }
            else
            {
                e.Row.Enabled = false;
            }
        }
    }
    protected void ddl_CorrInst_SelectedIndexChanged(object sender, EventArgs e)
    {
        
    }
    protected void Grilla_Grupo_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string vHTML = GuarXBRL.Obtener_Html(Grilla_Empr.Rows[e.RowIndex].Cells[1].Text, ddl_CorrInst.SelectedValue, ((DropDownList)Grilla_Empr.Rows[e.RowIndex].Cells[3].Controls[1]).SelectedValue);
        Session["vHTML"] = vHTML;
        string pScript = "<script type=\"text/javascript\"> " +
                    "window.open(\"" + "\\ListadoDiferencias.aspx\",\"" + "_blank\",\"width=750, height=400, scrollbars=yes,toolbar=no,menubar=no,resizable\");" +
                    "</script>";
        ClientScript.RegisterStartupScript(typeof(Page), "PaginaDestino", pScript);
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
    protected void Grilla_Empr_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Grilla_Empr.PageIndex = e.NewPageIndex;
        Grilla_Empr.DataBind();
        llenado_de_grilla();

    }
    protected void ddl_Grupo_SelectedIndexChanged(object sender, EventArgs e)
    {
        GrupoEmpr = ddl_Grupo.SelectedValue.ToString();
        Session["GrupoEmpr"] = GrupoEmpr;
        llenado_de_grilla();
    }
    protected void ddl_Segmento_SelectedIndexChanged(object sender, EventArgs e)
    {
        SegmEmpr = ddl_Segmento.SelectedValue.ToString();
        Session["SegmEmpr"] = SegmEmpr;
        llenado_de_grilla();
    }
    protected void ddl_TipoTaxonomia_SelectedIndexChanged(object sender, EventArgs e)
    {
        TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue;
        llenado_de_grilla();
    }
    protected void Buscar_Click(object sender, ImageClickEventArgs e)
    {
        llenado_de_grilla();
    }
}