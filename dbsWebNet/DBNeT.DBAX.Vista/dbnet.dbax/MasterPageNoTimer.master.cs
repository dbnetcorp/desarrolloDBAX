using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Threading;
using DBNeT.Base.Modelo;
using DBNeT.Base.Controlador;
using System.Configuration;

public partial class Website_MasterPage : System.Web.UI.MasterPage
{
    #region Pagina Base 
    private string _gsModo = string.Empty;
    private SessionWeb _goSessionWeb;

    private void RecuperaSessionWeb()
    {
        if (Session["sessionWeb"] == null)
        { Response.Redirect("~/dbnFw5/dbnSesionExpirada.aspx", true); }
        else
        { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
    }
    private void GuardaSessionWeb()
    { Session["sessionWeb"] = _goSessionWeb; }
    #endregion
    public string _gsRol = string.Empty;
    public string _gsIcono = string.Empty;
    public string _gsBanner = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _gsRol = _goSessionWeb.CODI_ROUS;
    }
    /*
         //XmlDataSource1.DataFile = "~/librerias/xml-menus/" + _goSessionWeb.CODI_ROUS + ".xml";
        CargaLabel();

        try
        {
            string _loModulo = ConfigurationManager.AppSettings.Get("Modulo").ToLower();
            _gsIcono = "\"../librerias/img/botones/logo_" + _loModulo + ".ico\"";
            banner.ImageUrl = "~/librerias/img/botones/banner2_" + _loModulo + ".jpg";
        }
        catch { }

        // Seteo de Titulo
        try
        {
            Page.Title = ConfigurationManager.AppSettings.Get("Titulo");
        }
        catch { }

    }
    protected void btnFinSesion_Click(object sender, EventArgs e)
    {
        _goLoginController = new LoginController();
        _goLoginController.updateFeteSess(_goSessionWeb.CORR_SESS, DateTime.Now);
        Session.RemoveAll();
        this.RecuperaSessionWeb();
    }
    private void CargaLabel()
    {
        _goSessionWeb = (SessionWeb)Session["sessionweb"];
        this.lblEmpresa.Text = _goSessionWeb.NOMB_EMPR;
        this.lblUsuario.Text = _goSessionWeb.CODI_USUA;
    
    }*/
}
