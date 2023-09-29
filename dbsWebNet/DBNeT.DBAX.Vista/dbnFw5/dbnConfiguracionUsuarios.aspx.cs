using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Resources;
using System.Data;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Framework.Seguridad;
using DBNeT.Base.Modelo;

public partial class dbnConfiguracionUsuarios : System.Web.UI.Page
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
    string _gsCodiUsua;
    UsuaSistController oUsuasistController;
    UsuaSistBE oUsuasistBE;
    ListaValoresControllers _goListaValoresController;

    protected void Page_Load(object sender, EventArgs e)
    {
        oUsuasistController = new UsuaSistController();
        RecuperaSessionWeb();
        #region Rescatar Modo (Ingreso o Mantención)

        if (Session["CODI_USUA"] != null)
        {_gsCodiUsua = Session["CODI_USUA"].ToString();}

        if (Session["BTN_AGRE_MODO"] != null)
        { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
        else
        { _gsModo = Session["P_MODO_REPO"].ToString(); }
        #endregion
        if (!IsPostBack)
       { 
            this.cargarMultilenguaje();
            #region Carga de Combobox
            CargaDdls();
            #endregion
            if (_gsModo == "M")
            {
                var loUsuaSist = oUsuasistController.readUsuaSist("S", 0, 0, null, _gsCodiUsua, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                Session["oUsuaSist"] = loUsuaSist;
                this.txbUsuario.Text = loUsuaSist.CODI_USUA;
                this.txbUsuario.Enabled = false;
                this.txbNombre.Text = loUsuaSist.NOMB_USUA;
                this.txbEmail.Text = loUsuaSist.MAIL_USUA;
                this.txbFechaInicio.Text = loUsuaSist.FECH_USUA.ToShortDateString();
                this.txbFechaTermino.Text = loUsuaSist.FETE_USUA.ToShortDateString();
                this.txbPersona.Text = loUsuaSist.CODI_PERS;
                this.txbEmpresa.Text = loUsuaSist.CODI_EMPR.ToString();
                this.txbCentroCosto.Text = loUsuaSist.CODI_CECO;
                this.txbOficina.Text = loUsuaSist.CODI_OFIC;
                this.txbRol.Text = loUsuaSist.CODI_ROUS;
                this.txbClave.Text = loUsuaSist.PASS_USUA;
                this.txtCodiEmex.Text = loUsuaSist.CODI_EMEX;
                this.aplicaCkb(loUsuaSist.USUA_ESTA, ckbUsuaBloq);
                this.aplicaCkb(loUsuaSist.USUA_NOCA, ckbUsuaNoca);

                #region Se invocan los Metodos TextChange cuando se le asignan los datos a los txt
                try
                { txbPersona_TextChanged(null, null); }
                catch
                { }
                try
                { txbEmpresa_TextChanged(null, null); }
                catch { }
                try
                { txbCentroCosto_TextChanged(null, null); }
                catch
                { }
                try
                { txbOficina_TextChanged(null, null); }
                catch
                { }
                try
                { txbRol_TextChanged(null, null); }
                catch
                { }
                try
                { txtCodiEmex_TextChanged(null, null); }
                catch
                { }
                #endregion
            }
        }
    }
    private void cargarMultilenguaje()
    {
        /* Titulo */
        this.lblTitulo.Text = multilenguaje_base.L_TITU_MANT_USUA;
        /* Label's */
        this.lblUsuario.Text = multilenguaje_base.lblMantUsua_Usuario;
        this.lblNombre.Text = multilenguaje_base.lblMantUsua_Nombre;
        this.lblFechaInicio.Text = multilenguaje_base.lblMantUsua_FechaInicio;
        this.lblFechaTermino.Text = multilenguaje_base.lblMantUsua_FechaTermino;
        this.lblEmail.Text = multilenguaje_base.lblMantUsua_Email;
        this.lblPersona.Text = multilenguaje_base.lblMantUsua_Persona;
        this.lblCentCost.Text = multilenguaje_base.lblMantUsua_CentroCosto;
        this.lblOficina.Text = multilenguaje_base.lblMantUsua_Oficina;
        this.lblEmpresa.Text = multilenguaje_base.lblMantUsua_Empresa;
        this.lblRol.Text = multilenguaje_base.lblMantUsua_Rol;
        this.lblClave.Text = multilenguaje_base.lblMantUsua_Clave;
        this.lblConfClave.Text = multilenguaje_base.lblMantUsua_ConfirmarClave;
        this.lblMonitor.Text = multilenguaje_base.lblMonitorConFiltro;
        this.lblCodiEmex.Text = multilenguaje_base.CODI_EMEX;
        /* Botones */
        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
        this.btnEliminar.ToolTip = multilenguaje_base.tt_btnEliminar;
    }

    private void CargaDdls()
    {
        CargaDdlCentCost();
        CargaDdlPersona();
        CargaDdlEmpr();
        CargaddlOficEmpr();
        CargaDdlSysRous();
        CargaDdlEmprExte();
    }
    private void CargaDdlCentCost()
    {
        try
        {
            _goListaValoresController = new ListaValoresControllers();
            var dtDatos = _goListaValoresController.readCentCost("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            Helper.ddlCarga(ddlCentCost, dtDatos);
        }
        catch
        { this.lblError.Text += "No se pudo cargar Centro Costo.<br/>"; }
    }
    private void CargaDdlPersona()
    {
        try
        {
            _goListaValoresController = new ListaValoresControllers();
            var listaPersonas = _goListaValoresController.readPersonas("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            Helper.ddlCarga(ddlPersona, listaPersonas);
        }
        catch
        { lblError.Text += "No se pudo Cargar Personas.<br/>"; }
    }
    private void CargaDdlEmpr()
    {
        try
        {
            _goListaValoresController = new ListaValoresControllers();
            var listaEmpresa = _goListaValoresController.readEmpr("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            Helper.ddlCarga(ddlEmpresa, listaEmpresa);
        }
        catch
        { lblError.Text += "No se pudo cargar empresa.<br/>"; }
    }
    private void CargaddlOficEmpr()
    {
        try
        {
            _goListaValoresController = new ListaValoresControllers();
            var listaOficina = _goListaValoresController.readOficEmpr("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            Helper.ddlCarga(ddlOficina, listaOficina);
        }
        catch
        { lblError.Text += "No se pudo cargar Sucursal.<br/>"; }
    }
    private void CargaDdlSysRous()
    {
        try
        {
            _goListaValoresController = new ListaValoresControllers();
            var listaRol = _goListaValoresController.readSysRous("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            Helper.ddlCarga(ddlRol, listaRol);
        }
        catch
        { lblError.Text += "No se pudo cargar los Roles.<br/>"; }
    }
    private void CargaDdlEmprExte()
    {
        try
        {
            _goListaValoresController = new ListaValoresControllers();
            var loListaValores = _goListaValoresController.readEmprExte("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            Helper.ddlCarga(ddlEmprExte, loListaValores);
        }
        catch
        { lblError.Text += "No se pudo cargar Holding.<br/>"; }
    }

    protected void btnActualizar_Click(object sender, EventArgs e)
    {
        try
        {
            this.validaFormulario();
            if (this.lblError.Text.Length == 0)
            {
                oUsuasistController = new UsuaSistController();
                oUsuasistBE = new UsuaSistBE();
                if (Session["oUsuaSist"] != null)
                { oUsuasistBE = (UsuaSistBE)Session["oUsuaSist"]; }
                oUsuasistBE.CODI_USUA = this.txbUsuario.Text;
                oUsuasistBE.NOMB_USUA = this.txbNombre.Text;
                oUsuasistBE.MAIL_USUA = this.txbEmail.Text;
                oUsuasistBE.FECH_USUA = DateTime.Parse(this.txbFechaInicio.Text);//.ToString("yyyy-mm-dd")*/;
                oUsuasistBE.FETE_USUA = DateTime.Parse(this.txbFechaTermino.Text);
                oUsuasistBE.CODI_PERS = this.txbPersona.Text;
                oUsuasistBE.CODI_EMPR = this.txbEmpresa.Text == string.Empty ? 0 : Convert.ToInt32(this.txbEmpresa.Text);
                oUsuasistBE.CODI_CECO = this.txbCentroCosto.Text;
                oUsuasistBE.CODI_OFIC = this.txbOficina.Text;
                oUsuasistBE.CODI_ROUS = this.txbRol.Text;
                oUsuasistBE.CODI_EMEX = this.txtCodiEmex.Text;
                oUsuasistBE.USUA_NOCA = this.compruebaCKB(this.ckbUsuaNoca);
                oUsuasistBE.USUA_ESTA = this.compruebaCKB(this.ckbUsuaBloq);
                string pass_encr = Encriptacion.Encriptar(this.txbClave.Text);
                try
                {
                    if (_gsModo == "CI" || _gsModo == null)
                    {
                        if (this.txbClave.Text.Trim().Length >= 1 && this.txbConfClave.Text.Trim().Length >= 1 && this.txbClave.Text.Equals(this.txbConfClave.Text))
                        { oUsuasistBE.PASS_USUA = Encriptacion.Encriptar(this.txbClave.Text); oUsuasistController.createUsuaSist(oUsuasistBE); }
                        else
                        { oUsuasistController.createUsuaSist(oUsuasistBE); }
                    }
                    else if (_gsModo == "M" || _gsModo == "CE")
                    {
                        if (this.txbClave.Text.Trim().Length >= 1 && this.txbConfClave.Text.Trim().Length >= 1 && this.txbClave.Text.Equals(this.txbConfClave.Text))
                        { oUsuasistBE.PASS_USUA = Encriptacion.Encriptar(Convert.ToString(this.txbClave.Text)); oUsuasistController.updateUsuaSist(oUsuasistBE); }
                        else
                        { oUsuasistController.updateUsuaSist(oUsuasistBE); }
                    }
                }
                catch (System.Data.SqlClient.SqlException ex)
                { this.lblError.Text = ex.Message; }
            }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnEliminar_Click(object sender, EventArgs e)
    {
        try
        { oUsuasistController = new UsuaSistController(); oUsuasistController.deleteUsuaSist(this.txbUsuario.Text,_goSessionWeb.CODI_EMPR,_goSessionWeb.CODI_EMEX); }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, EventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("CODI_USUA");
        Session.Remove("oUsuaSist");
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=" + Session["tsListado"].ToString() + "&MODO=" + Session["P_MODO_REPO"].ToString(), true);
    }

    protected void txbPersona_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlPersona, this.txbPersona.Text);
    }
    protected void txbEmpresa_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlEmpresa, this.txbEmpresa.Text);
    }
    protected void txbCentroCosto_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlCentCost, this.txbCentroCosto.Text);
    }
    protected void txbOficina_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlOficina, txbOficina.Text);
    }
    protected void txbRol_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlRol, this.txbRol.Text);
    }
    protected void txtCodiEmex_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlEmprExte, this.txtCodiEmex.Text);
    }

    protected void ddlPersona_SelectedIndexChanged(object sender, EventArgs e)
    { this.txbPersona.Text = this.ddlPersona.SelectedValue.ToString(); }
    protected void ddlEmpresa_SelectedIndexChanged(object sender, EventArgs e)
    { this.txbEmpresa.Text = this.ddlEmpresa.SelectedValue.ToString(); }
    protected void ddlCentCost_SelectedIndexChanged(object sender, EventArgs e)
    { this.txbCentroCosto.Text = this.ddlCentCost.SelectedValue.ToString(); }
    protected void ddlOficina_SelectedIndexChanged(object sender, EventArgs e)
    { this.txbOficina.Text = this.ddlOficina.SelectedValue.ToString(); }
    protected void ddlRol_SelectedIndexChanged(object sender, EventArgs e)
    { this.txbRol.Text = this.ddlRol.SelectedValue.ToString(); }
    protected void ddlCodiEmex_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtCodiEmex.Text = this.ddlEmprExte.SelectedValue;
    }
    
    private string compruebaCKB(CheckBox ckb)
    {
        string lsValor = string.Empty;
        if (ckb.Checked)
        { lsValor = "N"; }
        else
        { lsValor = "S"; }
        return lsValor;
    }
    private void aplicaCkb(string tsValor, CheckBox ckb)
    {
        if (tsValor == "N")
        {
            ckb.Checked = true;
        }
        else if (tsValor == "S")
        {
            ckb.Checked = false;
        }
    }

    private void validaFormulario()
    {
        this.lblError.Text = string.Empty;
        this.lblError.Text = "ERROR<br/>";
        int x = 0;
        if (this.txbUsuario.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Usuario : Se debe Ingresar un código de Usuario <br/>"; }
        if (this.txbNombre.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Nombre : Se debe ingresar un Nombre a este usuario <br/>"; }
        if (this.txbFechaInicio.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Fecha inicio: Se debe ingresar una fecha de inicio para el Usuario <br/>"; }
        if (this.txbFechaTermino.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Fecha Termino: Se Debe Ingresar una fecha de termino para el Usuario <br/>"; }
        if (this.txbPersona.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Persona : Se debe Asignar a una persona a este usuario. <br/>"; }

        if (x > 0)
        { lblError.Visible = true; }
        else
        { lblError.Text = string.Empty; }
    }
    }