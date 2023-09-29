using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.Base.Controlador;

public partial class dbax_calc_actu : System.Web.UI.Page
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
    GeneracionExcel GenExcel;
    GeneradorGrupo geneGru;
    ValoresActualizadosController _goValoActu;
    protected void Page_Load(object sender, EventArgs e)
    {
        this.lblTitulo.Text = "Cálculo de Valores Actualizados";
        this.RecuperaSessionWeb();
        GenExcel = new GeneracionExcel();
        geneGru = new GeneradorGrupo();
        _goValoActu = new ValoresActualizadosController();
        if (!IsPostBack)
        {
            CargaTipoTaxo();
            CargaSegmento();
            CargaPeriodoDesde();
            CargaPeriodoHasta();
            CargaPeriodoActualizado();
        }
    }
    protected void CargaTipoTaxo()
    {
        SysParamController _loSysaParam = new SysParamController();
        var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_DEFE_TAXO", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        var dt = geneGru.getTiposTaxonomia().Tables[0];
        ddlTipoTaxo.DataSource = dt;
        ddlTipoTaxo.DataTextField = dt.Columns["desc_tipo"].ToString();
        ddlTipoTaxo.DataValueField = dt.Columns["tipo_taxo"].ToString();
        ddlTipoTaxo.DataBind();
        ddlTipoTaxo.SelectedValue = loResultado.PARAM_VALUE;

    }
    protected void CargaSegmento()
    {
        var dt = geneGru.getSegmentos().Tables[0];
        ddlSegmento.DataSource = dt;
        ddlSegmento.DataTextField = dt.Columns["desc_segm"].ToString();
        ddlSegmento.DataValueField = dt.Columns["codi_segm"].ToString();
        ddlSegmento.DataBind();
    }
    protected void CargaPeriodoDesde()
    {
        var dt = GenExcel.getPersCorrInst("");

        ddlPeriodoDesde.DataSource = dt;
        ddlPeriodoDesde.DataTextField = dt.Columns["desc_inst"].ToString();
        ddlPeriodoDesde.DataValueField = dt.Columns["corr_inst"].ToString();
        ddlPeriodoDesde.DataBind();
    }
    protected void CargaPeriodoHasta()
    {
        var dt = GenExcel.getPersCorrInst("");

        ddlPeriodoHasta.DataSource = dt;
        ddlPeriodoHasta.DataTextField = dt.Columns["desc_inst"].ToString();
        ddlPeriodoHasta.DataValueField = dt.Columns["corr_inst"].ToString();
        ddlPeriodoHasta.DataBind();
    }
    protected void CargaPeriodoActualizado()
    {
        var dt = GenExcel.getPersCorrInst("");

        ddlPeriodoActualizado.DataSource = dt;
        ddlPeriodoActualizado.DataTextField = dt.Columns["desc_inst"].ToString();
        ddlPeriodoActualizado.DataValueField = dt.Columns["corr_inst"].ToString();
        ddlPeriodoActualizado.DataBind();
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            SysParamController _loSysaParam = new SysParamController();
            var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_XBRL_BINA", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);

            string rutaArchivo = loResultado.PARAM_VALUE + "\\CalculoValoresActualizados.exe";

            string lsArgumentos = "\"" + _goSessionWeb.CODI_EMEX + "\" \"" + _goSessionWeb.CODI_EMPR + "\" \"" + ddlTipoTaxo.SelectedValue + "\" \"" + ddlSegmento.SelectedValue + "\" \"" + ddlPeriodoDesde.SelectedValue + "\" \"" + ddlPeriodoHasta.SelectedValue + "\" \""+ddlPeriodoActualizado.SelectedValue+"\" ";
            _goValoActu.create_dbax_calc_actu(rutaArchivo, _goSessionWeb.CODI_USUA, lsArgumentos, _goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR);
        }
        catch (Exception ex)
        { throw ex; }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/dbnet.dbax/Home.aspx", true);
    }
}