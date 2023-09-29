using System;
using System.Data;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Resources;
using DBNeT.Base.Modelo;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Controlador;

public partial class dbnConfiguracionRoles : System.Web.UI.Page
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
    string _gsCodiRous = string.Empty;
    SysRousBE _goSysRousBE;
    SysRousController _goSysRousController;
    ModuloController _goModuloController;
    
    
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();

        if (Session["CODI_ROUS"] != null)
        { 
            _gsCodiRous = Session["CODI_ROUS"].ToString();
        }

        if (Session["BTN_AGRE_MODO"] != null)
            _gsModo = Session["BTN_AGRE_MODO"].ToString();
        else
            _gsModo = Session["P_MODO_REPO"].ToString();

        _goSysRousController = new SysRousController();
        CargaDdlModulo();
        this.CargaMultilenguaje();
        if (_gsModo.ToUpper() == "CI")
        { this.txtCodigoRol.Enabled = true; }
        if (!IsPostBack)
        {
            if (_gsModo == "M" || _gsModo == "CE")
            {
                var loRous = _goSysRousController.readSysRous("S", 0, 0, null, _gsCodiRous, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                Session["oRous"] = loRous;
                this.txtCodigoRol.Text = loRous.CODI_ROUS;
                this.txtDescripcion.Text = loRous.DESC_ROUS;
                this.txtCodigoRol.Enabled = false;
            }
        }
    }

    private void CargaMultilenguaje()
    {
        this.lblCodigoModulo.Text = multilenguaje_base.CODI_MODU;
        this.lblCodigoRol.Text = multilenguaje_base.CODI_ROUS;
        this.lblDescripcion.Text = multilenguaje_base.DESC_ROUS;
        this.lblTitulo.Text = multilenguaje_base.L_TITU_MANT_ROLES;
        /* Botones */
        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
        this.btnEliminar.ToolTip = multilenguaje_base.tt_btnEliminar;
    }
    private void CargaDdlModulo()
    {
        _goModuloController = new ModuloController();
        Helper.ddlCarga(ddlModulo, _goModuloController.readModulo());
    }
    private void LimpiaCampos()
    {
        this.txtDescripcion.Text = string.Empty;
        this.txtCodigoRol.Text = string.Empty;
        this.ddlModulo.SelectedIndex = 0;
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            this.ValidaFormulario();
            if (this.lblError.Text.Trim().Length == 0)
            {
                _goSysRousBE = new SysRousBE();
                if (Session["oRous"] != null)
                { _goSysRousBE = (SysRousBE)Session["oRous"]; }
                _goSysRousBE.CODI_ROUS = this.txtCodigoRol.Text;
                _goSysRousBE.DESC_ROUS = this.txtDescripcion.Text;
                _goSysRousBE.CODI_MODU = this.ddlModulo.SelectedValue;

                if (_gsModo == null || _gsModo == "CI")
                { _goSysRousController.createSysRous(_goSysRousBE); LimpiaCampos(); }
                else if (_gsModo == "M" || _gsModo == "CE")
                { _goSysRousController.updateSysRous(_goSysRousBE); LimpiaCampos(); }
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
            _goSysRousController = new SysRousController();
            _goSysRousController.deleteSysRous(this.txtCodigoRol.Text);
        }
        catch(Exception ex)
        { lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("CODI_ROUS");
        Session.Remove("oRous");
        LimpiaCampos();
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=" + Session["tsListado"].ToString() + "&MODO=" + Session["P_MODO_REPO"].ToString(), true);
    }

    private void ValidaFormulario()
    {
        this.lblError.Text = string.Empty;
        this.lblError.Text = "ERROR<br/>";
        this.lblError.Text += "<img src=\"../librerias/img/imgWarn.png\" border=\"0\" class=\"dbnEstado\" /> <br/>";
        int x = 0;
        if (this.txtCodigoRol.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Código : Se debe Ingresar un código de Rol<br/>"; }
        if (this.txtDescripcion.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Descripción : Se debe ingresar una descripción.<br/>"; }
        
        if (x > 0)
        { lblError.Visible = true; }
        else
        { lblError.Text = string.Empty; }
    }
}