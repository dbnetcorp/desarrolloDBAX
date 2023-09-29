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

            llenado_de_periodos();
            llenado_de_empresa();
            llenado_de_versiones();
        }
    }

    protected void llenado_de_empresa()
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
                llenado_de_versiones();
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
    protected void llenado_de_periodos()
    {
        try
        {
            DataTable dt = GenExcel.getPersCorrInst(ddl_CodiEmpr.SelectedValue);

            ddl_CorrInst.DataSource = dt;
            ddl_CorrInst.DataTextField = dt.Columns["desc_inst"].ToString();
            ddl_CorrInst.DataValueField = dt.Columns["corr_inst"].ToString();
            ddl_CorrInst.DataBind();
            //llenado_de_empresa();
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
            DataTable dt = GenExcel.getVersInst(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue);
            if (dt.Rows.Count > 0)
            {
                ddl_VersInst.Enabled = true;
                ddl_VersInst.DataSource = dt;
                ddl_VersInst.DataTextField = dt.Columns["vers_inst"].ToString();
                ddl_VersInst.DataValueField = dt.Columns["vers_inst"].ToString();
                ddl_VersInst.DataBind();
                Buscar_Click(null, null);
            }
            else
            {
                ddl_VersInst.Items.Clear();
                ddl_VersInst.Enabled = false;
                gv_Archivos.Visible = false;
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
            llenado_de_versiones();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void Filtro_Empresa_TextChanged(object sender, EventArgs e)
    {llenado_de_empresa();}

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList(string prefixText, int count, string contextKey)
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

    protected void gv_Archivos_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            int indexRow = e.RowIndex;
            GridViewRow row = gv_Archivos.Rows[indexRow];
            DataTable dt = new DataTable();
            dt = GenExcel.GetArchivosXbrl(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue, ((Label)(row.Cells[1].Controls[1])).Text);
            string contenido64 = dt.Rows[0]["Contenido"].ToString();
           
            byte[] contenido = Gxbrl.Rescata_Archivos_XBRL(contenido64);

            Response.Clear();
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[1].Controls[1])).Text); 
            Response.BinaryWrite(contenido);
            Response.End();
            
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void ddl_CorrInst_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            llenado_de_versiones();
            try
            {
                DataTable dt = GenExcel.GetArchivosXbrl(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue);
                gv_Archivos.DataSource = dt;
                gv_Archivos.DataBind();
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
            DataTable dt = GenExcel.GetArchivosXbrl(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue);
            gv_Archivos.DataSource = dt;
            gv_Archivos.DataBind();
            Buscar_Click(null, null);
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
        llenado_de_empresa();
    }
    protected void ddl_Segmento_Select(object sender, EventArgs e)
    {
        SegmEmpr = ddl_Segmento.SelectedValue.ToString();
        Session["SegmEmpr"] = SegmEmpr;
        llenado_de_empresa();
    }
    protected void ddl_TipoTaxonomia_SelectedIndexChanged(object sender, EventArgs e)
    {
        TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue;
        Session["TipoTaxonomia"] = TipoTaxonomia;
        llenado_de_empresa();
    }
    protected void Buscar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            gv_Archivos.Visible = true;
            DataTable dt = GenExcel.GetArchivosXbrl(ddl_CodiEmpr.SelectedValue, ddl_CorrInst.SelectedValue, ddl_VersInst.SelectedValue);
            gv_Archivos.DataSource = dt;
            gv_Archivos.DataBind();
        }
        catch
        {
            lb_error.Text = "";
            lb_error.Visible = true;
            lb_error.Text = "No se encontraron datos cargados para la empresa y periodo seleccionados";
        }
    }
}