using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Resources;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Modelo.DAC;
using System.Data;

public partial class dbnMantencionEmpresa : System.Web.UI.Page
{
    #region DBNeTFW5 - General
    /// <summary>
    /// Variables y metodos generales
    /// </summary>

    private string _gsModo = string.Empty;
    private SessionWeb _goSessionWeb;
    ListaValoresControllers _goListaValores;

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
    int _giCodiEmpr;
    #endregion

    EmprBE _goEmpreBE;
    EmprController _goEmprController;

    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _goListaValores = new ListaValoresControllers();
        _goEmprController = new EmprController();
        this.lblError.Text = string.Empty;
        this.btnActualizar.Enabled = true;
        try
        {
            #region Rescatar Modo (Ingreso o Mantención)

            if (Session["CODI_EMPR"] != null)
                _giCodiEmpr = Convert.ToInt32(Session["CODI_EMPR"]);
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
                #region Carga Lista de Valors
                cargaDdlComuna();
                cargaDdlCiudad();
                cargaDdlGiro();
                #endregion
                #region Carga Datos
                if (_gsModo != "CI")
                {
                    var loEmpr = this._goEmprController.readEmpr("S", 0, 0, null, _giCodiEmpr.ToString(), null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                    Session["oEmpresa"] = loEmpr;
                    this.txtCodigo.Text = loEmpr.CODI_EMPR.ToString();
                    //this.txtAsuntoMail.Text = loEmpr.ASUN_FACT_EMPR;
                    this.txtCiudad.Text = loEmpr.CODI_CIUD;
                    this.txtComuna.Text = loEmpr.CODI_COMU;
                    //this.txtCuerpo.Text = loEmpr.TEXT_FACT_EMPR;
                    this.txtDireccion.Text = loEmpr.DIRE_EMPR;
                    this.txtDv.Text = loEmpr.DIGI_EMPR;
                    this.txtGiro.Text = loEmpr.GIRO_EMPR;
                    this.txtNombre.Text = loEmpr.NOMB_EMPR;
                    this.txtNombreFantasia.Text = loEmpr.NFAN_EMPR;
                    this.txtRut.Text = loEmpr.RUTT_EMPR.ToString();
                    this.txtCodigo.Enabled = false;

                    Helper.ddlSelecciona(this.ddlComuna, this.txtComuna.Text);
                    Helper.ddlSelecciona(this.ddlCiudad, this.txtCiudad.Text);
                    Helper.ddlSelecciona(this.ddlGiro, this.txtGiro.Text);
                    this.txtDv_TextChanged(null, null);
                }
                #endregion
            }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
    }

    private void cargaMultilenguaje()
    {
        //this.lblAsuntoMail.Text = multilenguaje_base.lblConfEmprAsuntEmail;
        this.lblCiudad.Text = multilenguaje_base.lblConfEmprCiudad;
        this.lblCodigo.Text = multilenguaje_base.lblConfEmprCodigo;
        this.lblComuna.Text = multilenguaje_base.lblConfEmprComuna;
        //this.lblCuerpoMail.Text = multilenguaje_base.lblConfEmprCuerpoMail;
        this.lblDireccion.Text = multilenguaje_base.lblConfEmprDireccion;
        this.lblGiro.Text = multilenguaje_base.lblConfEmprGiro;
        this.lblNombre.Text = multilenguaje_base.lblConfEmprNombre;
        this.lblNombreFantasia.Text = multilenguaje_base.lblConfEmprNFan;
        this.lblRut.Text = multilenguaje_base.lblConfEmprRut;
        this.lblTitulo.Text = multilenguaje_base.L_TITU_MANT_EMPR;
        /* Botones */
        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
        this.btnEliminar.ToolTip = multilenguaje_base.tt_btnEliminar;
    }

    private void cargaDdlComuna()
    {
        _goListaValores = new ListaValoresControllers();
        var lista = _goListaValores.readComunas("LV", 0, 0, "", "", "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlComuna, lista);
    }
    private void cargaDdlCiudad()
    {
        this.ddlCiudad.Items.Clear();
        var loCiudad = _goListaValores.readCiudad("LV", 0, 0, "", "", "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlCiudad, loCiudad);
    }
    private void cargaDdlGiro()
    {
        this.ddlGiro.Items.Clear();
        var loGiro = _goListaValores.readGiro("LV", 0, 0, "", "", "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlGiro, loGiro);
    }

    private void limpiarTxt()
    {
        //this.txtAsuntoMail.Text = string.Empty;
        this.txtCiudad.Text = string.Empty;
        this.txtCodigo.Text = string.Empty;
        this.txtComuna.Text = string.Empty;
        //this.txtCuerpo.Text = string.Empty;
        this.txtDireccion.Text = string.Empty;
        this.txtDv.Text = string.Empty;
        this.txtGiro.Text = string.Empty;
        this.txtNombre.Text = string.Empty;
        this.txtNombreFantasia.Text = string.Empty;
        this.txtRut.Text = string.Empty;
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
       { 
            ValiErro loValiErro = new ValiErro();
            if (this.lblError.Text.Trim().Length == 0 && this.lblErroRut.Text.Trim().Length == 0)
            {
                if (Session["oEmpresa"] != null)
                { _goEmpreBE = (EmprBE)Session["oEmpresa"]; }
                else
                {_goEmpreBE = new EmprBE();}
                _goEmpreBE.CODI_EMPR = Convert.ToInt32(this.txtCodigo.Text);
                _goEmpreBE.NOMB_EMPR = this.txtNombre.Text;
                _goEmpreBE.RUTT_EMPR = Convert.ToInt32(this.txtRut.Text);
                _goEmpreBE.DIGI_EMPR = this.txtDv.Text;
                _goEmpreBE.NFAN_EMPR = this.txtNombreFantasia.Text;
                _goEmpreBE.DIRE_EMPR = this.txtDireccion.Text;
                _goEmpreBE.CODI_COMU = this.txtComuna.Text;
                _goEmpreBE.CODI_CIUD = this.txtCiudad.Text;
                _goEmpreBE.GIRO_EMPR = this.txtGiro.Text;
                //_goEmpreBE.ASUN_FACT_EMPR = this.txtAsuntoMail.Text;
                //_goEmpreBE.TEXT_FACT_EMPR = this.txtCuerpo.Text;
                _goEmpreBE.FECA_EMPR = DateTime.Now.Date;
                _goEmpreBE.FEMU_EMPR = DateTime.Now.Date;
                _goEmpreBE.CODI_EMEX = this._goSessionWeb.CODI_EMEX;
                loValiErro.p_corr_sess = (int)_goSessionWeb.CORR_SESS;

                ValiErro loValidaAccion = new ValiErro();
                if (_gsModo == string.Empty || _gsModo == "CI")
                { loValidaAccion = this._goEmprController.createEmpr(_goEmpreBE, loValiErro); }
                else if (_gsModo == "M" && _giCodiEmpr != 0 || _gsModo == "CE" && _giCodiEmpr != 0)
                { loValidaAccion = this._goEmprController.updateEmpr(_goEmpreBE, loValiErro); }

                if (loValidaAccion.p_codi_erro.Length > 0)
                { lblError.Text = multilenguaje_exception.ResourceManager.GetString("error-"+loValidaAccion.p_codi_erro); } //loValidaAccion.p_codi_erro + "<br/> Mensaje: " + loValidaAccion.p_mens_erro; }
            }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        if (this.txtCodigo.Text.Length > 0)
        {
            _goEmprController.deleteEmpr(Convert.ToInt32(this.txtCodigo.Text));
        }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("CODI_EMPR");
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=" + Session["tsListado"].ToString() + "&MODO=" + Session["P_MODO_REPO"].ToString(), true);
    }

    protected void ddlComuna_SelectedIndexChanged(object sender, EventArgs e)
    { 
        this.txtComuna.Text = this.ddlComuna.SelectedValue;
    }
    protected void ddlCiudad_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtCiudad.Text = this.ddlCiudad.SelectedValue;
    }
    protected void ddlGiro_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtGiro.Text = this.ddlGiro.SelectedValue;
    }
    protected void txtComuna_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(this.ddlComuna, this.txtComuna.Text);
    }
    protected void txtCiudad_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(this.ddlCiudad, this.txtCiudad.Text);
    }
    protected void txtGiro_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(this.ddlGiro, this.txtGiro.Text);
    }

    protected void txtDv_TextChanged(object sender, EventArgs e)
    {
        Validaciones loValidaciones = new Validaciones();
        this.lblErroRut.Text = string.Empty;
        if (this.txtRut.Text.Trim().Length > 0)
        {
            var lsResultado = loValidaciones.ValidaRut(Convert.ToInt32(this.txtRut.Text), this.txtDv.Text);
            if (lsResultado == true)
            { lblErroRut.Visible = false; }
            else
            { lblErroRut.Visible = true; lblErroRut.Text = "Debe ingresar un Rut Valido"; }
        }
        else
        {
            this.lblErroRut.Text = "Rut Invalido o Nulo";
        }

    }
}