using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.IO;
using System.Net;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;

public partial class Website_listadoIndicadores : System.Web.UI.Page
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
    GeneracionExcel genExcel = new GeneracionExcel();
    GeneradorGrupo geneGru = new GeneradorGrupo();
    string TipoTaxonomia = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        //MantencionIndicadores Indicador = new MantencionIndicadores();
        lb_error.Text = "";
        lb_error.Visible = false;
        if (!IsPostBack)
        {
            DataTable dt = geneGru.getTiposTaxonomia().Tables[0];
            ddl_TipoTaxonomia.DataSource = dt;
            ddl_TipoTaxonomia.DataTextField = dt.Columns["desc_tipo"].ToString();
            ddl_TipoTaxonomia.DataValueField = dt.Columns["tipo_taxo"].ToString();
            ddl_TipoTaxonomia.DataBind();
            SysParamController _loSysaParam = new SysParamController();
            var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_DEFE_TAXO", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            ddl_TipoTaxonomia.SelectedValue = loResultado.PARAM_VALUE;

            //DataTable dt = Indicador.getListaIndicadores("1","1", "");
            llenado_de_grilla();
        }
    }

    protected void gv_Reportes_SelectedIndexChanged(object sender, EventArgs e)
    {
        VariablesSession varSes = new VariablesSession();
        //varSes.VariablesInforme("1","1",gv_Reportes.Rows[gv_Reportes.SelectedIndex].Cells[1].Text);
        varSes.VariablesInforme(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ((Label)(gv_Reportes.Rows[gv_Reportes.SelectedIndex].Cells[1].Controls[1])).Text, ((Label)(gv_Reportes.Rows[gv_Reportes.SelectedIndex].Cells[6].Controls[1])).Text);
        Session["par1"] = varSes;
        Response.Redirect("PlantillasXbrl.aspx");
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

    protected void ddl_TipoTaxonomia_SelectedIndexChanged(object sender, EventArgs e)
    {
        TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue;
        llenado_de_grilla();
    }

    protected void llenado_de_grilla()
    {
        try
        {
            gv_Reportes.Dispose();
            DataSet ds = genExcel.getInformes(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_TipoTaxonomia.SelectedValue);
            gv_Reportes.DataSource = ds;
            gv_Reportes.DataBind();
            gv_Reportes.Columns[1].Visible = false;
            gv_Reportes.Columns[4].Visible = false;
         }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void bt_insInfoDefi(object sender, ImageClickEventArgs e)
    {
        Session.Remove("par1");
        Response.Redirect("PlantillasXbrl.aspx");
    }
}