using System;
using System.Data;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Modelo;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Controlador;
using DBNeT.Base.Framework.Seguridad;
using Resources;

public partial class dbnCambioClave : System.Web.UI.Page
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
    LoginController _goLoginController;
    UsuaSistBE _goUsuaSistBE;
    UsuaSistController _goUsuaSistController;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        this.CargaMultiLenguaje();
        this.RecuperaSessionWeb();
        this._goUsuaSistController = new UsuaSistController();

        if (!IsPostBack)
        {
            var loUsuario = this._goUsuaSistController.readUsuaSist("S", 0, 0, null, _goSessionWeb.CODI_USUA, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            this.txtCodiUsua.Text = _goSessionWeb.CODI_USUA;
            this.txtNombUsua.Text = loUsuario.NOMB_USUA;
            this.txtCodiUsua.Enabled = false;
            this.txtNombUsua.Enabled = false;
        }
    }
    private void CargaMultiLenguaje()
    {
        lblTitulo.Text = multilenguaje_base.TITU_CAMB_CLAV;
        lblUsuario.Text = multilenguaje_base.CODI_USUA;
        lblPassAntigua.Text = multilenguaje_base.PASS_USUA_OLD;
        lblPassConfirma.Text = multilenguaje_base.PASS_USUA_REPE;
        lblPassNueva.Text = multilenguaje_base.PASS_USUA;
        /* Botones */
        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
    }
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        _goLoginController = new LoginController();
        var loUsuario = this._goUsuaSistController.readUsuaSist("S", 0, 0, null, _goSessionWeb.CODI_USUA, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        if(loUsuario.PASS_USUA.Equals(Encriptacion.Encriptar(this.txtPassAntigua.Text)))
        {
            _goUsuaSistBE = new UsuaSistBE();
            _goUsuaSistBE.CODI_USUA = _goSessionWeb.CODI_USUA;
            _goUsuaSistBE.NOMB_USUA = this.txtNombUsua.Text;
            _goUsuaSistBE.PASS_USUA = VerificaClave();
            _goLoginController.updatePassUsua(Encriptacion.Encriptar(this.txtPassNueva.Text), 30, _goSessionWeb.CODI_USUA);
        }
        btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/dbnFw5/dbnIndex.aspx",true);
    }
    private string VerificaClave()
    {
        string lsPassEncriptada = string.Empty;
        if (this.txtPassNueva.Text.Equals(this.txtPassNuevaConfirmar.Text))
        {lsPassEncriptada = Encriptacion.Encriptar(this.txtPassNueva.Text);}
        return lsPassEncriptada;
    }
}