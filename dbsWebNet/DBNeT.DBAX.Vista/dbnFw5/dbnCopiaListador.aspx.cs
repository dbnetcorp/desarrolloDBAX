using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;

public partial class dbnCopiaListador : System.Web.UI.Page
{
    #region DBNeTFW5 - General
    /// <summary>
    /// Variables y metodos generales
    /// </summary>

    private string _gsModo = string.Empty;
    private SessionWeb _goSessionWeb;

    private void RecuperaSessionWeb()
    {
        if (Session["sessionWeb"] == null)
        { Response.Redirect("~/dbnFw5/dbnSesionExpirada.aspx",true); }
        else
        { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
    }
    private void GuardaSessionWeb()
    { Session["sessionWeb"] = _goSessionWeb; }
    #endregion
    DbnListRepoController _goDbnListRepoController;
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        this.lblError.Text = string.Empty;
        _goDbnListRepoController = new DbnListRepoController();
        if (!IsPostBack)
        {
            CargaDdlListadores();
        }
        this.MultiLenguaje();
    }

    private void CargaDdlListadores()
    {
        _goDbnListRepoController = new DbnListRepoController();
        var loResultado = _goDbnListRepoController.readReporteDt("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlRepoOrigen, loResultado);
    }
    private void MultiLenguaje()
    {
        lblRepoOrigen.Text = "Reporte Origen";
        lblRepoDestino.Text = "Reporte Destino";
        lblTitulo.Text = "Copia de Reportes";
    }
    private void LimpiarCampos()
    {
        this.txtRepoDestino.Text = string.Empty;
        this.ddlRepoOrigen.SelectedIndex = 0;
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            ValiErro loValiErro = new ValiErro();
            _goDbnListRepoController = new DbnListRepoController();
            if (this.txtRepoDestino.Text.Trim().Length > 0)
            { loValiErro = _goDbnListRepoController.createCopiaReporte(this.ddlRepoOrigen.SelectedValue, this.txtRepoDestino.Text, loValiErro); }
            string script = "<script languaje=\"javascript\">alert(\"" + loValiErro.p_mens_erro + "\");</script>";
            ScriptManager.RegisterStartupScript(this, typeof(Page), "alerta", script, false);
            if (loValiErro.p_codi_erro == "0")
            { this.LimpiarCampos(); }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        this.Response.Redirect("~/dbnFw5/dbnIndex.aspx", true);
    }
}