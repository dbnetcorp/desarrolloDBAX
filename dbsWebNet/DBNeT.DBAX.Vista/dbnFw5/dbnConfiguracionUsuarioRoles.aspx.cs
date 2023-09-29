using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Modelo;

public partial class dbnFw5_dbnConfiguracionUsuarioRoles : System.Web.UI.Page
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
    SysUsroController _goSysUsroController;
    SysUsroBE _goSysUsroBE;
    ListaValoresControllers _goListaValoresController;
    string _gsUsuario = string.Empty, _gsRol = string.Empty, _gsModulo = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _goSysUsroController = new SysUsroController();
        _goSysUsroBE = new SysUsroBE();
        _goListaValoresController = new ListaValoresControllers();
        CargaMultilenguaje();

        if (Session["CODI_USUA"] != null)
        { _gsUsuario = Session["CODI_USUA"].ToString(); }
        if (Session["CODI_MODU"] != null)
        { _gsModulo = Session["CODI_MODU"].ToString(); }
        if (Session["CODI_ROUS"] != null)
        { _gsRol = Session["CODI_ROUS"].ToString(); }

        if (Session["BTN_AGRE_MODO"] != null)
        { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
        else
        { _gsModo = Session["P_MODO_REPO"].ToString(); }
        if (!IsPostBack)
        {
            this.txtModulo.Enabled = false;
            this.txtUsuario.Enabled = false;
            this.txtRol.Enabled = false;
            CargaDdlModulo();
            CargaDdlRol();
            CargaDdlUsuario();

            if (_gsModo.ToUpper() == "M" || _gsModo.ToUpper() == "CE")
            {
                var loResultado = _goSysUsroController.readSysUsro("S", 0, 0, null, _gsRol, _gsUsuario, _gsModulo, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                Session["oSysUsRo"] = loResultado;
                this.ddlModulo.SelectedValue = loResultado.CODI_MODU;
                this.ddlRol.SelectedValue = loResultado.CODI_ROUS;
                this.ddlUsuario.SelectedValue = loResultado.CODI_USUA;
                this.ddlModulo.Enabled = false;
                this.ddlUsuario.Enabled = false;
                ddlModulo_SelectedIndexChanged(null, null);
                ddlRol_SelectedIndexChanged(null, null);
                ddlUsuario_SelectedIndexChanged(null, null);
            }
        }
    }

    private void CargaMultilenguaje()
    {
        lblUsuario.Text = "Usuario";
        lblTitulo.Text = "Edición Usuario Rol";
        lblRol.Text = "Rol";
        lblModulo.Text = "Módulo";
    }
    private void CargaDdlUsuario()
    {
        var loResultado = _goListaValoresController.readUsuaSist("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlUsuario, loResultado);
    }
    private void CargaDdlRol()
    {
        var loResultado = _goListaValoresController.readSysRous("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlRol, loResultado);
    }
    private void CargaDdlModulo()
    {
        var loResultado = _goListaValoresController.readSysModule("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlModulo, loResultado);
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            _goSysUsroController = new SysUsroController();
            if (Session["oSysUsRo"] == null)
            { _goSysUsroBE = new SysUsroBE(); _goSysUsroBE.CODI_USUA = ddlUsuario.SelectedValue; _goSysUsroBE.CODI_MODU = ddlModulo.SelectedValue; }
            else
            { _goSysUsroBE = (SysUsroBE)Session["oSysUsRo"]; }
            _goSysUsroBE.CODI_ROUS = ddlRol.SelectedValue;
            if (_gsModo.ToUpper() == "CI")
            { _goSysUsroController.createSysUsro(_goSysUsroBE); }
            else
            { _goSysUsroController.updateSysUsro(_goSysUsroBE); }

        }
        catch (Exception ex)
        {
        }
        finally
        { btnVolver_Click(null, null); }
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {

            _goSysUsroController = new SysUsroController();
            _goSysUsroController.deleteSysUsro(ddlUsuario.SelectedValue, ddlModulo.SelectedValue, ddlRol.SelectedValue);
        }
        catch (Exception ex)
        { }
        finally
        { btnVolver_Click(null, null); }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("oSysUsRo");
        Session.Remove("CODI_USUA");
        Session.Remove("CODI_ROUS");
        Session.Remove("CODI_MODU");
        this.Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_USUA_ROUS&MODO=" + Session["P_MODO_REPO"].ToString(),true);
    }

    protected void ddlUsuario_SelectedIndexChanged(object sender, EventArgs e)
    {this.txtUsuario.Text = ddlUsuario.SelectedValue;}
    protected void ddlRol_SelectedIndexChanged(object sender, EventArgs e)
    {this.txtRol.Text = ddlRol.SelectedValue;}
    protected void ddlModulo_SelectedIndexChanged(object sender, EventArgs e)
    {this.txtModulo.Text = ddlModulo.SelectedValue;}
    
}