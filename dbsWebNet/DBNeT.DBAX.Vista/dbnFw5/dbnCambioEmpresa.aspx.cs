using System;
using System.Data;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;
using Resources;
using DBNeT.Base.WebLibrary;

public partial class dbnCambioEmpresa : System.Web.UI.Page
{
    #region DBNeTFW5 - General
    /// <summary>
    /// Variables y metodos generales
    /// </summary>

    private string _gsModo = string.Empty;
    private SessionWeb _goSessionWeb;
    private ListaValoresControllers _goListaValores;

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

    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();

        if (!IsPostBack)
        {
            this.CargaMultilenguaje();
            this.cargarddlEmpresa();

            this.txtCodiEmpr.Text = _goSessionWeb.CODI_EMPR.ToString();
            Helper.ddlSelecciona(ddlCodiEmpr, txtCodiEmpr.Text);
        }
    }

    /// <summary>
    /// Metodo para la carga de los MultiLenguajes
    /// </summary>
    public void CargaMultilenguaje()
    {
        this.Title = multilenguaje_base.L_TITU_CAMBIO_EMPRESA;
        this.lblTitulo.Text = multilenguaje_base.L_TITU_CAMBIO_EMPRESA;
        this.lblCodiEmpr.Text = multilenguaje_base.CODI_EMPR;

        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
    }

    private void cargarddlEmpresa()
    {
        _goListaValores = new ListaValoresControllers();
        var listaEmpresa = _goListaValores.readEmpr("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlCodiEmpr, listaEmpresa);
    }
    private void limpiar()
    {
        _goSessionWeb.CODI_EMPR = Convert.ToInt32(txtCodiEmpr.Text);
        this.txtCodiEmpr.Text = _goSessionWeb.CODI_EMPR.ToString();
    }

    protected void btnActualizar_Click(object sender, EventArgs e)
    {
        this.GuardaSessionWeb();
        this.btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/dbnFw5/dbnIndex.aspx",true);
    }
    protected void ddlCodiEmpr_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (this.ddlCodiEmpr.SelectedIndex > 0)
        {

            this.txtCodiEmpr.Text = this.ddlCodiEmpr.SelectedValue;
            _goSessionWeb.CODI_EMPR = Convert.ToInt32(this.txtCodiEmpr.Text);
            _goSessionWeb.NOMB_EMPR = this.ddlCodiEmpr.SelectedItem.ToString();
            this.GuardaSessionWeb();
            this.btnActualizar_Click(null, null);
        }
        else
        { }
    }
    protected void txtCodiEmpr_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(this.ddlCodiEmpr, txtCodiEmpr.Text);
    }
}