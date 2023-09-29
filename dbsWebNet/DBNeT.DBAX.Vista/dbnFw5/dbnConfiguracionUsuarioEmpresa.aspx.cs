using System;
using System.Data;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.Base.Modelo.BE;
using Resources;

public partial class dbnConfiguracionUsuarioEmpresa : System.Web.UI.Page
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
    string _gsCodiUsua = string.Empty;
    string _gsCodiEmpr = string.Empty;
    string _gsCodiEmex = string.Empty;
    ListaValoresControllers _goListaValoresController;
    UsuaEmprController _goUsuaEmprController;
    UsuaEmprBE _goUsuaEmprBE;
    

    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        multilenguaje();

        if(Session["CODI_EMPR"] != null)
        _gsCodiEmpr = Session["CODI_EMPR"].ToString();
        if(Session["CODI_USUA"] != null)
            _gsCodiUsua = Session["CODI_USUA"].ToString();
        if (Session["CODI_EMEX"] != null)
            _gsCodiEmex = Session["CODI_EMEX"].ToString();

            if (Session["BTN_AGRE_MODO"] != null)
                _gsModo = Session["BTN_AGRE_MODO"].ToString();
            else
                _gsModo = Session["P_MODO_REPO"].ToString();
        if (!IsPostBack)
        {
            if (_gsCodiEmpr != null && _gsCodiUsua != null)
            {
                _goUsuaEmprController = new UsuaEmprController();
                var loUsuaEmpr = _goUsuaEmprController.readUsuaEmpr("S", 0, 0, null, _gsCodiUsua, _gsCodiEmpr, _gsCodiEmex, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                Session["oUsuaEmpr"] = loUsuaEmpr;
                this.txtUsuario.Text = loUsuaEmpr.CODI_USUA;
                this.txtEmpresa.Text = loUsuaEmpr.CODI_EMPR.ToString();
                this.txtEmex.Text    = loUsuaEmpr.CODI_EMEX;
            }
            //Carga de Consulta
            CargaDdlUsuario();
            CargaDdlEmpresa();
            CargaDdlEmex();
            txtUsuario_TextChanged(null, null);
            txtEmpresa_TextChanged(null, null);
            txtEmex_TextChanged(null, null);
        }
    }
    private void multilenguaje()
    {
        this.lblTitulo.Text = multilenguaje_base.L_TITU_MANT_USUA_EMPR;
        this.lblEmpresa.Text = multilenguaje_base.CODI_EMPR;
        this.lblUsuario.Text = multilenguaje_base.CODI_USUA;
        this.LblEmex.Text = multilenguaje_base.CODI_EMEX;
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            this.ValidaFormulario();
            if (this.lblError.Text.Trim().Length == 0)
            {
                _goUsuaEmprBE = new UsuaEmprBE();
                if (Session["oUsuaEmpr"] != null)
                { _goUsuaEmprBE = (UsuaEmprBE)Session["oUsuaEmpr"]; }
                _goUsuaEmprBE.CODI_EMPR = Convert.ToInt32(this.txtEmpresa.Text);
                _goUsuaEmprBE.CODI_USUA = this.txtUsuario.Text;
                _goUsuaEmprBE.CODI_EMEX = this.txtEmex.Text;

                _goUsuaEmprController = new UsuaEmprController();
                if (_gsModo.ToUpper() == "CI")
                {
                    _goUsuaEmprController.createUsuaEmpr(_goUsuaEmprBE);
                }
                if (_gsModo.ToUpper() == "M")
                {
                    _goUsuaEmprController.updateUsuaEmpr(_goUsuaEmprBE);
                }
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
            _goUsuaEmprBE = new UsuaEmprBE();
            _goUsuaEmprBE.CODI_EMPR = Convert.ToInt32(this.txtEmpresa.Text);
            _goUsuaEmprBE.CODI_USUA = this.txtUsuario.Text;

            _goUsuaEmprController = new UsuaEmprController();
            _goUsuaEmprController.deleteUsuaEmpr(_goUsuaEmprBE.CODI_EMPR, _goUsuaEmprBE.CODI_USUA, _goUsuaEmprBE.CODI_EMEX);
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("oUsuaEmpr");
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=" + Session["tsListado"].ToString() + "&MODO=" + Session["P_MODO_REPO"].ToString(), true);
    }

    private void CargaDdlUsuario()
    {
        _goListaValoresController = new ListaValoresControllers();
        var loResultado = _goListaValoresController.readUsuaSist("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA,_goSessionWeb.CODI_EMPR,_goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlUsuario, loResultado);
    }
    private void CargaDdlEmpresa()
    {
        _goListaValoresController = new ListaValoresControllers();
        var loResultado = _goListaValoresController.readEmpr("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlEmpresa, loResultado);
    }
    private void CargaDdlEmex()
    {
        _goListaValoresController = new ListaValoresControllers();
        var loResultado = _goListaValoresController.readEmprExte("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlEmex, loResultado);
    }

    protected void ddlUsuario_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtUsuario.Text = this.ddlUsuario.SelectedValue.ToString();
    }
    protected void ddlEmpresa_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtEmpresa.Text = this.ddlEmpresa.SelectedValue.ToString();
    }

    protected void ddlEmex_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtEmex.Text = this.ddlEmex.SelectedValue.ToString();
    }

    private void ValidaFormulario()
    {
        this.lblError.Text = string.Empty;
        this.lblError.Text = "ERROR :<br/>";
        this.lblError.Text += "<img src=\"../librerias/img/imgWarn.png\" border=\"0\" class=\"dbnEstado\" /> <br/>";
        int x = 0;
        if (this.txtUsuario.Text.Trim().Length > 0)                                    
        { }
        else
        { x++; this.lblError.Text += "Usuario: Se debe seleccionar un Usuario. <br/>"; }
        if (this.txtEmpresa.Text.Trim().Length > 0)
        { }
        else
        { x++; this.lblError.Text += "Empresa: Se debe seleccionar una Empresa. <br/>"; }

        if (x > 0)
        { lblError.Visible = true; }
        else
        { lblError.Text = string.Empty; }
    }
    protected void txtUsuario_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlUsuario, this.txtUsuario.Text);
    }
    protected void txtEmpresa_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlEmpresa, this.txtEmpresa.Text);
    }
    protected void txtEmex_TextChanged(object sender, EventArgs e)
    {
        Helper.ddlSelecciona(ddlEmex, this.txtEmex.Text);
    }
}