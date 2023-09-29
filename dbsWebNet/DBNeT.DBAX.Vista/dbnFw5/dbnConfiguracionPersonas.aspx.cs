using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using DBNeT.Base.Modelo;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Controlador;
using DBNeT.Base.Framework.Conector;
using Resources;

public partial class dbnConfiguracionPersonas : System.Web.UI.Page
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
    string _gsCodiPers;
    PersonasBE _goPersonasBE;
    PersonasController _goPersonasController;
    ListaValoresControllers _goListaValoresController;
    

    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _goPersonasController = new PersonasController();
        cargaMultilenguaje();
        #region Rescatar Modo (Ingreso o Mantención)
        if (Session["CODI_PERS"] != null) {
            _gsCodiPers = Session["CODI_PERS"].ToString();
        } 
        
        if (Session["BTN_AGRE_MODO"] != null)
            _gsModo = Session["BTN_AGRE_MODO"].ToString();
        else
            _gsModo = Session["P_MODO_REPO"].ToString();

        #endregion        
        #region IsPostBack
        if (!IsPostBack)
        {
            this.cargaDdlComuna();
            this.cargaDdlPais();
            this.cargaDdlCodiPers1();
            this.cargaDdlSuscursal();
            if (_gsModo.ToUpper() == "M" ||_gsModo.ToUpper() =="CE")
            {
                var loPersona = _goPersonasController.readPersonas("S", 0, 0, "", _gsCodiPers, "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                Session["oPersona"] = loPersona;
                try
                {
                    this.txtCodigo.Text = loPersona.CODI_PERS;
                    this.txtCodigo.Enabled = false;
                    this.txtComuna.Text = loPersona.CODI_COMU;
                    this.txtDireccion.Text = loPersona.DIRE_PERS;
                    this.txtIngreso.Text = loPersona.FECH_PERS.ToShortDateString();
                    this.txtMail.Text = loPersona.CODI_MAIL;
                    this.txtNombre.Text = loPersona.NOMB_PERS;
                    this.txtNombreFantasia.Text = loPersona.NFAN_PERS;
                    this.txtObservaciones.Text = loPersona.COME_PERS;
                    this.txtPais.Text = loPersona.CODI_PAIS;
                    this.txtRut.Text = loPersona.RUTT_PERS.ToString();
                    this.txtTelefono.Text = loPersona.FONO_PERS;
                    this.txtCodiPers1.Text = loPersona.CODI_PERS1;
                    this.txtDV.Text = loPersona.DGTO_PERS;
                    this.txtSuscursal.Text = loPersona.CODI_OFIC;

                    if (loPersona.EMPR_PERS == "S")
                        this.ckbEmpresa.Checked = true;
                    else
                        this.ckbEmpresa.Checked = false;

                    if (loPersona.EMPL_PERS == "S")
                        this.ckbPersona.Checked = true;
                    else
                        this.ckbPersona.Checked = false;
                }
                catch (Exception ex)
                { this.lblError.Text = ex.Message; }
                txtComuna_TextChanged(null, null);
                txtPais_TextChanged(null, null);
                txtCodiPers1_TextChanged(null, null);
                txtDV_TextChanged(null, null);
                txtSuscursal_TextChanged(null, null);
            }
        }
        #endregion
    }
    private void cargaMultilenguaje()
    {
        this.lblCodigo.Text = multilenguaje_base.lblCodigoMantPers;
        this.lblComuna.Text = multilenguaje_base.lblComunaMantPers;
        this.lblDireccion.Text = multilenguaje_base.lblDireccionMantPers;
        this.lblEmpresa.Text = multilenguaje_base.lblEmpresaCkbMantPers;
        this.lblIngreso.Text = multilenguaje_base.lblIngresoMantPers;
        this.lblMail.Text = multilenguaje_base.lblMailMantPers;
        this.lblNombre.Text = multilenguaje_base.lblNombreMantPers;
        this.lblNombreFantasia.Text = multilenguaje_base.lblNombFantMantPers;
        this.lblObservaciones.Text = multilenguaje_base.lblObservacionesMantPers;
        this.lblPais.Text = multilenguaje_base.lblPaisMantPers;
        this.lblPersona.Text = multilenguaje_base.lblPersonaCkbMantPers;
        this.lblRut.Text = multilenguaje_base.lblRutMantPers;
        this.lblTelefono.Text = multilenguaje_base.lblTelefonosMantPers;
        this.lblTitulo.Text = multilenguaje_base.L_TITU_PERSONAS;
        this.lblSuscursal.Text = multilenguaje_base.CODI_OFIC;
        /* Botones */
        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
        this.btnEliminar.ToolTip = multilenguaje_base.tt_btnEliminar;
        this.lblCodiPers1.Text = multilenguaje_base.CODI_PERS1;
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            this.ValidaFormulario();
            if (this.lblError.Text.Trim().Length == 0 && lblErrorRut.Text.Trim().Length == 0)
            {
                _goPersonasBE = new PersonasBE();
                if (Session["oPersona"] != null)
                { _goPersonasBE = (PersonasBE)Session["oPersona"]; }
                _goPersonasBE.CODI_EMEX = _goSessionWeb.CODI_EMEX;
                _goPersonasBE.CODI_EMPR = _goSessionWeb.CODI_EMPR;
                _goPersonasBE.CODI_PERS = this.txtRut.Text;
                _goPersonasBE.RUTT_PERS = Convert.ToInt32(this.txtRut.Text);
                _goPersonasBE.NOMB_PERS = this.txtNombre.Text;
                _goPersonasBE.NFAN_PERS = this.txtNombreFantasia.Text;
                _goPersonasBE.DIRE_PERS = this.txtDireccion.Text;
                _goPersonasBE.CODI_COMU = this.txtComuna.Text;
                _goPersonasBE.FECH_PERS = DateTime.Parse(this.txtIngreso.Text);
                _goPersonasBE.CODI_PAIS = this.txtPais.Text;
                _goPersonasBE.FONO_PERS = this.txtTelefono.Text;
                _goPersonasBE.TIPO_DESC = this.txtObservaciones.Text;
                _goPersonasBE.CODI_MAIL = this.txtMail.Text;
                _goPersonasBE.DGTO_PERS = this.txtDV.Text;
                _goPersonasBE.CODI_OFIC = this.txtSuscursal.Text;
                if (this.ckbEmpresa.Checked)
                    _goPersonasBE.EMPR_PERS = "S";
                else
                    _goPersonasBE.EMPR_PERS = "N";
                if (this.ckbPersona.Checked)
                    _goPersonasBE.EMPL_PERS = "S";
                else
                    _goPersonasBE.EMPL_PERS = "N";
                _goPersonasBE.CODI_PERS1 = this.txtCodiPers1.Text;
                _goPersonasController = new PersonasController();

                if (_gsModo == null || _gsModo == "CI")
                { _goPersonasController.createPersonas(_goPersonasBE);}
                else if (_gsModo == "M" || _gsModo == "CE")
                { _goPersonasController.updatePersonas(_goPersonasBE);}
            }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            _goPersonasController = new PersonasController();
            _goPersonasController.deletePersonas(_goSessionWeb.CODI_EMEX, this.txtCodigo.Text);
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("CODI_PERS");
        Session.Remove("oPersona");
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=" + Session["tsListado"].ToString() + "&MODO=" + Session["P_MODO_REPO"].ToString(), true);
    }
    
    protected void ddlComuna_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtComuna.Text = this.ddlComuna.SelectedValue;  
    }
    protected void ddlPais_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtPais.Text = this.ddlPais.SelectedValue;
    }
    protected void ddlPersonas_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtCodiPers1.Text = this.ddlPersonas.SelectedValue.ToString();
    }
    protected void ddlSuscursal_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtSuscursal.Text = this.ddlSuscursal.SelectedValue.ToString();
    }

    private void cargaDdlComuna()
    {
        _goListaValoresController = new ListaValoresControllers();
        var listaComuna = _goListaValoresController.readComunas("LV", 0, 0, "", "", "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlComuna, listaComuna);
    }
    private void cargaDdlPais()
    {
        _goListaValoresController = new ListaValoresControllers();
        var listaPais = _goListaValoresController.readPais("LV", 0, 0, "", "", "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlPais, listaPais);
    }
    private void cargaDdlCodiPers1()
    {
        _goListaValoresController = new ListaValoresControllers();
        var lista = _goListaValoresController.readPersonas("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlPersonas, lista);
    }
    private void cargaDdlSuscursal()
    {
        _goListaValoresController = new ListaValoresControllers();
        var loResultado = _goListaValoresController.readOficEmpr("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlSuscursal, loResultado);
    }

    protected void txtComuna_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlComuna, this.txtComuna.Text);
    }
    protected void txtPais_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(this.ddlPais, this.txtPais.Text);
    }
    protected void txtCodiPers1_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlPersonas, this.txtCodiPers1.Text);
    }
    protected void txtSuscursal_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(this.ddlSuscursal, this.txtSuscursal.Text);
    }

    protected void txtDV_TextChanged(object sender, EventArgs e)
    {
        this.txtCodigo.Text = this.txtRut.Text;
        Validaciones loValidaciones = new Validaciones();
        if (this.txtRut.Text.Trim().Length > 0)
        {
            this.txtCodigo.Text = this.txtRut.Text;
            var lbvalido = loValidaciones.ValidaRut(Convert.ToInt32(this.txtRut.Text), this.txtDV.Text);
            if (lbvalido == true)
            { lblErrorRut.Text = string.Empty; }
            else
            { lblErrorRut.Text = "Rut no Valido"; }
        }
        else
        {this.txtCodigo.Text = string.Empty;}
    }
    
    private void ValidaFormulario()
    {
        this.lblError.Text = string.Empty;
        this.lblError.Text = "ERROR<br/>";
        int x = 0;
        if (this.txtCodigo.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Código : Se debe Ingresar un código <br/>"; }
        if (this.txtNombre.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Nombre : Se debe ingresar un Nombre. <br/>"; }
        if (this.txtNombreFantasia.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Nombre Fantasía: Se debe ingresar nombre de fantasía. <br/>"; }
        if (this.txtIngreso.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Fecha Ingreso: Se Debe Ingresar la fecha de Inicio. <br/>"; }
        if (this.txtTelefono.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Teléfono : Se debe agregar un Número. <br/>"; }

        if (x > 0)
        { lblError.Visible = true; }
        else
        { lblError.Text = string.Empty; }
    }
}