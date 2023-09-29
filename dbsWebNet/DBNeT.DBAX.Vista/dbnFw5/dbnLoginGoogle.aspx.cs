using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using DotNetOpenAuth.OpenId;
using DotNetOpenAuth.OpenId.RelyingParty;
using DotNetOpenAuth.OpenId.Extensions.AttributeExchange;
using DotNetOpenAuth.OAuth;
using DBNeT.Base.Framework.Helper;
using DBNeT.Base.Framework.Seguridad;
using DBNeT.Base.Modelo;
using System.Configuration;
using DBNeT.Base.Controlador;

public partial class dbnLoginGoogle : System.Web.UI.Page
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
        { Response.Redirect("~/dbnFw5/dbnLogin.aspx", true); }
        else
        { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
    }
    private void GuardaSessionWeb()
    { Session["sessionWeb"] = _goSessionWeb; }
    #endregion
    LoginGoogleController _goLoginGoogleController;
    LoginController _goLoginController;
    private static readonly OpenIdRelyingParty relyingParty;
    protected string user;
    static dbnLoginGoogle()
    {
        HostMetaDiscoveryService googleAppsDiscovery = new HostMetaDiscoveryService
        { UseGoogleHostedHostMeta = true,};
        relyingParty = new OpenIdRelyingParty();
        relyingParty.DiscoveryServices.Insert(0, googleAppsDiscovery);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        _goLoginGoogleController = new LoginGoogleController();
        try
        {
            if (!IsPostBack)
            { _goSessionWeb = new SessionWeb();  }
            else
            { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
            this.CargaSettingConfig();
            IAuthenticationResponse authResponse = relyingParty.GetResponse();
            if (authResponse != null)
            {
                switch (authResponse.Status)
                {
                    case AuthenticationStatus.Authenticated:
                        FetchResponse fetch = authResponse.GetExtension<FetchResponse>();
                        if (fetch != null)
                        {Session["email"] = fetch.GetAttributeValue(WellKnownAttributes.Contact.Email);}
                        string lsEmail = Session["email"].ToString();
                        user = _goLoginGoogleController.getUsuario(lsEmail);
                        if (user != "")
                        {
                            try
                            {
                                if (validaUsuario())
                                {
                                    _goSessionWeb.LOGI_APLI = user;
                                    _goSessionWeb.CORR_SESS = _goLoginController.readCorrSess(user);
                                    this.GuardaSessionWeb();
                                    MenuXmlHtml _gsMenu = new MenuXmlHtml();
                                    string lsRol = _goLoginController.readRol(_goSessionWeb.CODI_MODU, _goSessionWeb.CODI_USUA);

                                    if (lsRol != "")
                                        _goSessionWeb.CODI_ROUS = lsRol;
                                    else
                                        _goSessionWeb.CODI_ROUS = "ROL_BASE_USER";
                                    
                                    _gsMenu.generaMenuH(_goSessionWeb.CODI_MODU, _goSessionWeb.CODI_ROUS); 
                                    
                                    FormsAuthentication.RedirectFromLoginPage(user, false);
                                    this.Response.Redirect("~/dbnFw5/dbnIndex.aspx", true);
                                }
                            }
                            catch (Exception ex)
                            { lblAviso.Text += "Error de Conexion (2): <br/> " + ex.Message; }
                        }
                        else
                        { lblAviso.Text += "Permiso Denegado."; }

                        break;
                    case AuthenticationStatus.Canceled:
                        break;
                    case AuthenticationStatus.Failed:
                        break;
                }
            }
            else
            {IAuthenticationRequest request = relyingParty.CreateRequest("dbnetcorp.com"); sendGoogleRequest(request);}
        }
        catch(Exception ex)
        {
            throw ex;
        }
    }
    private void CargaSettingConfig()
    {
        _goSessionWeb.BASE_DATO = ConfigurationManager.AppSettings.Get("ServerType");
        _goSessionWeb.NOMB_SERV = ConfigurationManager.AppSettings.Get("DataServer");
        _goSessionWeb.NOMB_BASE = ConfigurationManager.AppSettings.Get("DataBase");
        _goSessionWeb.USUA_SEGU = ConfigurationManager.AppSettings.Get("User");
        _goSessionWeb.USUA_BASE_DATO = ConfigurationManager.AppSettings.Get("Owner");
        _goSessionWeb.PASS_ENCR = ConfigurationManager.AppSettings.Get("Password");
        _goSessionWeb.PATH = ConfigurationManager.AppSettings.Get("Path");
        _goSessionWeb.CODI_MODU = ConfigurationManager.AppSettings.Get("Modulo");
    }
    private void sendGoogleRequest(IAuthenticationRequest request)
    {
        FetchRequest fetch = new FetchRequest();
        fetch.Attributes.Add(new AttributeRequest(WellKnownAttributes.Contact.Email, true));
        fetch.Attributes.Add(new AttributeRequest(WellKnownAttributes.Name.First, true));
        fetch.Attributes.Add(new AttributeRequest(WellKnownAttributes.Name.Last, true));
        request.AddExtension(fetch);

        request.RedirectToProvider();
    }
    private bool validaUsuario()
    {
        bool lbUsuario = false;
        _goLoginController = new LoginController();
        if (user.Trim().Length > 0)
        {
            var lista = _goLoginController.readUsuario(user);
            _goSessionWeb.CODI_USUA = lista.CODI_USUA;
            _goSessionWeb.PASS_ENCR = lista.PASS_ENCR;
            _goSessionWeb.CODI_CECO = lista.CODI_CECO;
            _goSessionWeb.CODI_EMEX = lista.CODI_EMEX;
            _goSessionWeb.CODI_EMPR = lista.CODI_EMPR;
            _goSessionWeb.CODI_MODU = lista.CODI_MODU;
            _goSessionWeb.CODI_CULT = lista.CODI_CULT;
            _goSessionWeb.CODI_ROUS = lista.CODI_ROUS;
            _goSessionWeb.NOMB_EMPR = lista.NOMB_EMPR;
            _goSessionWeb.P_EXIS = lista.P_EXIS;
            _goSessionWeb.P_MENS = lista.P_MENS;
            _goSessionWeb.PATH = ConfigurationManager.AppSettings.Get("Path").ToUpper();
            _goSessionWeb.BASE_DATO = ConfigurationManager.AppSettings.Get("ServerType").ToUpper();
            _goSessionWeb.CODI_MODU = ConfigurationManager.AppSettings.Get("Modulo").ToUpper();

            if (_goSessionWeb.P_EXIS != null)
            {
                if (user == lista.CODI_USUA)
                    lbUsuario = true;
                else
                { lbUsuario = false; }
            }
        }
        return lbUsuario;
    }
}