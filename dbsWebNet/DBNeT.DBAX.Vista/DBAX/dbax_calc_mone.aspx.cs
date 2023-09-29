using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;

public partial class DBAX_dbax_calc_mone : System.Web.UI.Page
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
 
    CalculoMonedaController _goCalcMoneController;
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Multilenguaje();
        this.RecuperaSessionWeb();
        _goCalcMoneController = new CalculoMonedaController();
        this.lblError.Text = string.Empty;
        if (!IsPostBack)
        {
            DataTable dtCorrInst = _goCalcMoneController.getPersCorrInst("");
            Helper.ddlCarga(ddlCorrInst, dtCorrInst, "desc_inst", "corr_inst");
        }
    }
    private void Multilenguaje()
    {
        this.lblTitulo.Text = "Cálculo de  Moneda";
        this.lblCorrInst.Text = "Correlativo de Período";
    }
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        SysParamController _loSysaParam = new SysParamController();
        var lsRutaBinario = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_XBRL_BINA", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        try
        {
            _goCalcMoneController = new CalculoMonedaController();

            string rutaArchivo = lsRutaBinario.PARAM_VALUE + "\\CalculoMoneda.exe";
            _goCalcMoneController.prc_create_calc_mone(rutaArchivo, ddlCorrInst.SelectedValue, _goSessionWeb.CODI_USUA,_goSessionWeb.CODI_EMPR,_goSessionWeb.CODI_EMEX);
        }
        catch (Exception ex)
        { lblError.Text += ex.Message; }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {

    }
}