using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Resources;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Modelo.DAC;

public partial class dbnConfiguracionCentroCosto : System.Web.UI.Page
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

    string _gsCodiCeco = string.Empty;
    CentCostController _goCentCostController;
    CentCostBE _goCentCostBE;

    protected void Page_Load(object sender, EventArgs e)
    {
        _goCentCostController = new CentCostController();
        this.RecuperaSessionWeb();
        this.cargaMultilenguaje();

        #region Rescatar Modo (Ingreso o Mantención)

        if (Session["CODI_CECO"] != null)
        { _gsCodiCeco = Session["CODI_CECO"].ToString();}
        if (Session["BTN_AGRE_MODO"] != null)
            _gsModo = Session["BTN_AGRE_MODO"].ToString();
        else
            _gsModo = Session["P_MODO_REPO"].ToString();

        #endregion
        #region ISPOSTBACK
        if (!IsPostBack)
        {
            var lista = _goCentCostController.readCentCost("S", 0, 0, "", _gsCodiCeco, "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            Session["oCentCost"] = lista;
            this.txtCodigo.Text = lista.CODI_CECO;
            this.txtDesde.Text = lista.FEIN_CECO.ToShortDateString();
            this.txtHasta.Text = lista.FETE_CECO.ToShortDateString();
            this.txtNombre.Text = lista.NOMB_CECO;
            this.txtNumeroCentro.Text = lista.NUME_CECO.ToString();
            this.txtSuperior.Text = lista.CODI_CECO1;
            this.txtNombreCorto.Text = lista.RESU_CECO;
            this.cargaDdlSuperior();
            if (_gsModo == "M" || _gsModo == "CE")
            { this.txtCodigo.Enabled = false; }
            txtSuperior_TextChanged(null, null);
        }
        #endregion
    }

    private void cargaMultilenguaje()
    {
        this.lblCodigo.Text = multilenguaje_base.lblMantCentCostCodigo;
        this.lblDesde.Text = multilenguaje_base.lblMantCentCostDesde;
        this.lblHasta.Text = multilenguaje_base.lblMantCentCostHasta;
        this.lblNombre.Text = multilenguaje_base.lblMantCentCostNombre;
        this.lblNombreCorto.Text = multilenguaje_base.lblMantCentCostNombreCorto;
        this.lblNumeroCentro.Text = multilenguaje_base.lblMantCentCostNumCeco;
        this.lblSuperior.Text = multilenguaje_base.lblMantCentCostSuperior;
        this.lblTitulo.Text = multilenguaje_base.L_TITU_MANT_CENT_COST;
        /* Botones */
        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
        this.btnEliminar.ToolTip = multilenguaje_base.tt_btnEliminar;
    }
    private void cargaDdlSuperior()
    {
        _goListaValores = new ListaValoresControllers();
        var lista = _goListaValores.readCentCost("LV", 0, 0, "", "", "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlSuperior, lista);
    }
    protected void txtSuperior_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlSuperior, this.txtSuperior.Text);
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            this.validaFormulario();
            if (this.lblError.Text.Trim().Length == 0)
            {
                _goCentCostBE = new CentCostBE();
                if (Session["oCentCost"] != null)
                { _goCentCostBE = (CentCostBE)Session["oCentCost"]; }
                _goCentCostBE.CODI_EMEX = _goSessionWeb.CODI_EMEX;
                _goCentCostBE.CODI_EMPR = _goSessionWeb.CODI_EMPR;
                _goCentCostBE.CODI_CECO = this.txtCodigo.Text;
                _goCentCostBE.NOMB_CECO = this.txtNombre.Text;
                _goCentCostBE.FEIN_CECO = DateTime.Parse(this.txtDesde.Text);
                _goCentCostBE.FETE_CECO = DateTime.Parse(this.txtHasta.Text);

                if (this.txtNumeroCentro.Text.Trim().Length > 0)
                { _goCentCostBE.NUME_CECO = Convert.ToInt32(this.txtNumeroCentro.Text); }
                _goCentCostBE.CODI_CECO1 = this.txtSuperior.Text;

                _goCentCostController = new CentCostController();

                if (_gsModo == null || _gsModo == "CI")
                { _goCentCostController.createCentCost(_goCentCostBE); btnVolver_Click(null, null); }
                else if (_gsModo == "M" || _gsModo == "CE")
                { _goCentCostController.updateCentCost(_goCentCostBE); btnVolver_Click(null, null); }
            }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            _goCentCostController.deleteCentCost(this.txtCodigo.Text, _goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR);
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("CODI_CECO");
        Session.Remove("oCentCost");
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=" + Session["tsListado"].ToString() + "&MODO=" + Session["P_MODO_REPO"].ToString(), true);
    }

    private void validaFormulario()
    {
        this.lblError.Text = string.Empty;
        this.lblError.Text = "ERROR<br/>";
        this.lblError.Text += "<img src=\"../librerias/img/imgWarn.png\" border=\"0\" class=\"dbnEstado\" /> <br/>";
        int x = 0;
        if (this.txtCodigo.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Código : Se debe Ingresar un código de Usuario <br/>"; }
        if (this.txtNombre.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Nombre : Se debe Ingresar Nombre para el Centro Costo<br/>"; }
        if (this.txtDesde.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Desde : Se debe Ingresar una fecha <br/>"; }
        if (this.txtHasta.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Hasta : Se debe Ingresar una fecha <br/>"; }
        if (this.txtSuperior.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Superior : Se debe Ingresar un Superior para el Centro Costo<br/>"; }
        
        if (x > 0)
        { lblError.Visible = true; }
        else
        { lblError.Text = string.Empty; }
    }
    protected void ddlSuperior_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtSuperior.Text = this.ddlSuperior.SelectedValue.ToString();
    }
}