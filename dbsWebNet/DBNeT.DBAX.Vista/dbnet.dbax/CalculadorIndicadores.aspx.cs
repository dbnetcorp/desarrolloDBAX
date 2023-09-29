using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.IO;
using System.Data;
using DbnetWebLibrary;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Modelo;

public partial class Website_CalculadorIndicadores : System.Web.UI.Page
{
    #region Pagina Base
    private string _gsModo = string.Empty;
    protected SessionWeb _goSessionWeb;
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
    MantencionIndicadores Indicador = new MantencionIndicadores();
    MantencionParametros para = new MantencionParametros();
    public string grupoEmpr = "", SegmEmpr = "";

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

            llenado_de_periodos();
            //llenado_de_empresa();
            CargaTipoTaxo();

            ddlTipoTaxo_SelectedIndexChanged(null, null);
        }
    }
    protected void CargaTipoTaxo()
    {
        GeneradorGrupo geneGru = new GeneradorGrupo();
        DataTable dt = geneGru.getTiposTaxonomia().Tables[0];
        ddlTipoTaxo.DataSource = dt;
        ddlTipoTaxo.DataTextField = dt.Columns["desc_tipo"].ToString();
        ddlTipoTaxo.DataValueField = dt.Columns["tipo_taxo"].ToString();
        ddlTipoTaxo.DataBind();
        this.ddlTipoTaxo.SelectedIndex = 2;
    }
    //protected void llenado_de_empresa()
    //{
    //    try
    //    {
    //        DataTable ds = GenExcel.GetEmpresas("1", "1", "", Filtro_Empresa.Text, ddl_Grupo.SelectedValue.ToString(), ddl_Segmento.SelectedValue.ToString(), "", "P").Tables[0];
    //        ddl_CodiEmpr.DataSource = ds;
    //        ddl_CodiEmpr.DataTextField = ds.Columns["desc_peho"].ToString();
    //        ddl_CodiEmpr.DataValueField = ds.Columns["codi_pers"].ToString();
    //        ddl_CodiEmpr.DataBind();
    //    }
    //    catch (Exception ex)
    //    {
    //        lb_error.Visible = true;
    //        lb_error.Text = ex.Message;
    //    }
    //}

    protected void llenado_de_periodos()
    {
        try
        {
            DataTable dt = GenExcel.getPersCorrInst("");
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
    protected void Filtro_Empresa_TextChanged(object sender, EventArgs e)
    {
        //llenado_de_empresa();
    }
    protected void ddl_Grupo_Select(object sender, EventArgs e)
    {
        grupoEmpr = ddl_Grupo.SelectedValue.ToString();
        Session["grupoEmpr"] = grupoEmpr;
        //llenado_de_empresa();
    }
    protected void ddl_Segmento_Select(object sender, EventArgs e)
    {
        SegmEmpr = ddl_Segmento.SelectedValue.ToString();
        Session["SegmEmpr"] = SegmEmpr;
        //llenado_de_empresa();
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList(string prefixText, int count, string contextKey)
    {
        GeneracionExcel GenExcel = new GeneracionExcel();
        string _gGrupoEmpr = (string)HttpContext.Current.Session["grupoEmpr"];
        string _gSegmEmpr = (string)HttpContext.Current.Session["SegmEmpr"];
        DataTable dt = GenExcel.GetEmpresas("1", "1", "", prefixText, _gGrupoEmpr, _gSegmEmpr, "", "P").Tables[0];
        string[] resultados = new string[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            resultados[i] = dt.Rows[i][1].ToString();
        }
        return resultados;
    }

    protected void Calcular_Indi_Click_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            for (int c = 0; c < CheckBoxList1.Items.Count; c++)
            {
                if (CheckBoxList1.Items[c].Selected)
                {
                    Indicador.InsDatosCalIndicadores(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_CorrInst.SelectedValue.ToString(), ddl_Grupo.SelectedValue.ToString(), ddl_Segmento.SelectedValue.ToString(), CheckBoxList1.Items[c].Value.ToString(), ddlTipoTaxo.SelectedValue.ToString());
                    para.SP_AX_insEstadoBarra("Wait", "Calculo de indicadores solicitado", "N",_goSessionWeb.CODI_USUA);
                }
            }
            //Indicador.Gatilla_Servicio(); // gatilla que el servicio corra
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void ckbTodos_CheckedChanged(object sender, EventArgs e)
    {
        if (ckbTodos.Checked)
        {
            for (int i = 0; i < CheckBoxList1.Items.Count; i++)
            { CheckBoxList1.Items[i].Selected = true; }
        }
        else
        {
            for (int i = 0; i < CheckBoxList1.Items.Count; i++)
            { CheckBoxList1.Items[i].Selected = false; }
        }
    }
    protected void bt_Volver_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_LIST_INDI&MODO=M", true);
    }
    protected void ddlTipoTaxo_SelectedIndexChanged(object sender, EventArgs e)
    {
        MantencionIndicadores Indicador = new MantencionIndicadores();
        DataTable dt = Indicador.getListaIndicadores(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddlTipoTaxo.SelectedValue.ToString(),"");
        CheckBoxList1.Items.Clear();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            CheckBoxList1.Items.Add(new ListItem(dt.Rows[i]["Descripción"].ToString(), dt.Rows[i]["Nombre"].ToString(), true));
        }
    }
}