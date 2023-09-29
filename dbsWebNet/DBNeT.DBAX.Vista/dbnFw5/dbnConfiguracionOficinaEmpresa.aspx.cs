using System;
using System.Data;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Resources;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Modelo.DAC;
 
public partial class dbnConfiguracionOficinaEmpresa : System.Web.UI.Page 
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
    #region Parametros
    string _gsCodiOfic;
    ListaValoresControllers _goListaValoresController; 
    OficEmprBE _goOficEmprBE;
    OficEmprController _goOficEmprController;
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _goListaValores = new ListaValoresControllers();
        _goOficEmprController = new OficEmprController();
        try
        {
            #region Rescatar Modo (Ingreso o Mantencion)
            if (Session["CODI_OFIC"] != null)
            {
                _gsCodiOfic = Session["CODI_OFIC"].ToString();
            }
            if (Session["BTN_AGRE_MODO"] != null)
                _gsModo = Session["BTN_AGRE_MODO"].ToString();
            else
                _gsModo = Session["P_MODO_REPO"].ToString();
 
            #endregion
            if (!IsPostBack)
            {
                #region Carga Multilenguaje
                cargaMultilenguaje();
                #endregion
                #region Carga Lista de Valores
                this.DdlCargaComuna();
                this.DdlCargaCiudad();
                this.DdlCargaCentCost();
                #endregion
                #region Carga Datos
                if (_gsModo != "CI")
                {
                    var loOficEmpr = this._goOficEmprController.readOficEmpr("S", 0, 0, null, _gsCodiOfic , null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                    Session["oOficEmpr"] = loOficEmpr;
                    this.txtCodiOfic.Text = loOficEmpr.CODI_OFIC;
                    this.txtDescOfic.Text = loOficEmpr.DESC_OFIC;
                    this.txtCodiCeco.Text = loOficEmpr.CODI_CECO;
                    this.txtDireOfic.Text = loOficEmpr.DIRE_OFIC;
                    this.txtCodiCiud.Text = loOficEmpr.CODI_CIUD;
                    this.txtCodiComu.Text = loOficEmpr.CODI_COMU;
                    this.txtCodiOfic.Enabled = false;
                    
                    //Helper.ddlSelecciona(this.ddlComuna, this.txtComuna.Text);
                }
                #endregion
                txtCodiComu_TextChanged(null, null);
                txtCodiCeco_TextChanged(null, null);
                txtCodiCiud_TextChanged(null, null);
            }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
    }

    #region Carga Multilenguaje
    private void cargaMultilenguaje()
    {
        this.lblTitulo.Text = multilenguaje_base.L_TITU_OFIC_EMPR;
        if (this.lblTitulo.Text == "") this.lblTitulo.Text = "TIT_OFIC_EMPR";
        this.lblCodiOfic.Text = multilenguaje_base.ResourceManager.GetString("CODI_OFIC");
        if (this.lblCodiOfic.Text == "") this.lblCodiOfic.Text = "CODI_OFIC";
        this.lblDescOfic.Text = multilenguaje_base.ResourceManager.GetString("DESC_OFIC");
        if (this.lblDescOfic.Text == "") this.lblDescOfic.Text = "DESC_OFIC";
        this.lblCodiCeco.Text = multilenguaje_base.ResourceManager.GetString("CODI_CECO");
        if (this.lblCodiCeco.Text == "") this.lblCodiCeco.Text = "CODI_CECO";
        this.lblDireOfic.Text = multilenguaje_base.ResourceManager.GetString("DIRE_OFIC");
        if (this.lblDireOfic.Text == "") this.lblDireOfic.Text = "DIRE_OFIC";
        this.lblCodiCiud.Text = multilenguaje_base.ResourceManager.GetString("CODI_CIUD");
        if (this.lblCodiCiud.Text == "") this.lblCodiCiud.Text = "CODI_CIUD";
        this.lblCodiComu.Text = multilenguaje_base.ResourceManager.GetString("CODI_COMU");
        if (this.lblCodiComu.Text == "") this.lblCodiComu.Text = "CODI_COMU";
        /* Botones */
        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
        this.btnEliminar.ToolTip = multilenguaje_base.tt_btnEliminar;
    }
    #endregion
    private void limpiarTxt()
    {
        this.txtCodiOfic.Text = string.Empty;
        this.txtDescOfic.Text = string.Empty;
        this.txtCodiCeco.Text = string.Empty;
        this.txtDireOfic.Text = string.Empty;
        this.txtCodiCiud.Text = string.Empty;
        this.txtCodiComu.Text = string.Empty;
        this.ddlCodiCeco.SelectedIndex = 0;
        this.ddlComuna.SelectedIndex = 0;
        this.ddlCiudad.SelectedIndex = 0;
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            this.validaFormulario();
            if (this.lblError.Text.Length == 0)
            {
                _goOficEmprBE = new OficEmprBE();
                if (Session["oOficEmpr"] != null)
                { _goOficEmprBE = (OficEmprBE)Session["oOficEmpr"]; }
                _goOficEmprBE.CODI_EMEX = _goSessionWeb.CODI_EMEX;
                _goOficEmprBE.CODI_EMPR = _goSessionWeb.CODI_EMPR;
                _goOficEmprBE.CODI_OFIC = this.txtCodiOfic.Text;
                _goOficEmprBE.DESC_OFIC = this.txtDescOfic.Text;
                _goOficEmprBE.CODI_CECO = this.txtCodiCeco.Text;
                _goOficEmprBE.DIRE_OFIC = this.txtDireOfic.Text;
                _goOficEmprBE.CODI_CIUD = this.txtCodiCiud.Text;
                _goOficEmprBE.CODI_COMU = this.txtCodiComu.Text;

                if (_gsModo == "CI")
                { this._goOficEmprController.createOficEmpr(_goOficEmprBE); }
                else if (_gsModo == "M" || _gsModo == "CE")
                { this._goOficEmprController.updateOficEmpr(_goOficEmprBE); }
                this.btnVolver_Click(null, null);
            }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        if (this.txtCodiOfic.Text.Length > 0)
        {
            _goOficEmprController.deleteOficEmpr(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR, this.txtCodiOfic.Text);
        }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("CODI_EMEX");
        Session.Remove("CODI_EMPR");
        Session.Remove("CODI_OFIC");
        Session.Remove("oOficEmpr");
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=" + Session["tsListado"].ToString() + "&MODO=" + Session["P_MODO_REPO"].ToString(), true);
    }

    protected void ddlCodiCeco_SelectedIndexChanged(object sender, EventArgs e)
    { this.txtCodiCeco.Text = this.ddlCodiCeco.SelectedValue.ToString(); }
    protected void ddlCiudad_SelectedIndexChanged(object sender, EventArgs e)
    { this.txtCodiCiud.Text = this.ddlCiudad.SelectedValue.ToString() ;}
    protected void ddlComuna_SelectedIndexChanged(object sender, EventArgs e)
    { this.txtCodiComu.Text = this.ddlComuna.SelectedValue.ToString(); }

    //Carga de Lista de Valores
    private void DdlCargaCentCost()
    {
        _goListaValoresController = new ListaValoresControllers();
        var loResultado = _goListaValoresController.readCentCost("LV", 0, 0, null, null, null, null, null, null, null, 0, null);
        Helper.ddlCarga(ddlCodiCeco, loResultado);
    }
    private void DdlCargaCiudad()
    {
        _goListaValoresController = new ListaValoresControllers();
        var loResultado = _goListaValoresController.readCiudad("LV", 0, 0, null, null, null, null, null, null, null, 0, null);
        Helper.ddlCarga(ddlCiudad, loResultado);
    }
    private void DdlCargaComuna()
    {
        _goListaValoresController = new ListaValoresControllers();
        var loResultado = _goListaValoresController.readComunas("LV", 0, 0, null, null, null, null, null, null, null, 0, null);
        Helper.ddlCarga(ddlComuna, loResultado);
    }
    //Se selecciona la opcion del Combobox
    protected void txtCodiCeco_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlCodiCeco, this.txtCodiCeco.Text);
    }
    protected void txtCodiCiud_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlCiudad, txtCodiCiud.Text);
    }
    protected void txtCodiComu_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(this.ddlComuna, this.txtCodiComu.Text);
    }

    private void validaFormulario()
    {
        this.lblError.Text = string.Empty;
        this.lblError.Text = "ERROR<br/>";
        this.lblError.Text += "<img src=\"../librerias/img/imgWarn.png\" border=\"0\" class=\"dbnEstado\" /> <br/>";
        int x = 0;

        if (this.txtCodiOfic.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Código Oficina : Se debe Ingresar el código de la suscursal<br/>"; }
        if(this.txtDescOfic.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Código Suscursal : Se debe Ingresar descripcion de la suscursal<br/>"; }
        if(this.txtCodiComu.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Código Comuna : Se debe seleccionar una comuna<br/>"; }
        if(this.txtCodiCiud.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Código Ciudad : Se debe seleccionar una ciudad <br/>"; }
        if(this.txtCodiCeco.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Código Centro Costo : Se debe seleccionar un centro costo <br/>"; }
        if (x > 0)
        { lblError.Visible = true; }
        else
        { lblError.Text = string.Empty; }
    }
}