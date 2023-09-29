using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.Base.Framework.Helper;

public partial class dbnFw5_dbnConfiguracionDominio : System.Web.UI.Page
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
    SysDomainBE _goSysDomainBE;
    SysDomainController _goSysDomainController;
    string _gsDomainCode = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        this.CargaMultilenguaje();
        _goSysDomainController = new SysDomainController();
        
        if (Session["BTN_AGRE_MODO"] != null)
        { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
        else
        { _gsModo = Session["P_MODO_REPO"].ToString(); }

        if (Session["DOMAIN_CODE"] != null)
        { _gsDomainCode = Session["DOMAIN_CODE"].ToString(); }
        #region IsPostback
        if (!IsPostBack)
        {
            if (_gsModo.ToUpper() == "M" || _gsModo.ToUpper() == "CE")
            {
                var loResultado = _goSysDomainController.readSysDomain("S", 0, 0, null, _gsDomainCode, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                Session["oSysDomain"] = loResultado;
                this.txtDomainCode.Text = loResultado.DOMAIN_CODE.ToString();
                this.txtDomainName.Text = loResultado.DOMAIN_NAME;
                this.txtDomainCode.Enabled = false;
            }
        }
        #endregion
    }
    private void CargaMultilenguaje()
    {
        lblTitulo.Text = "Edición de Dominio";
        lblDomainCode.Text = "Código Dominio";
        lblDomainName.Text = "Nombre Dominio";
    }
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            _goSysDomainController = new SysDomainController();
            if (Session["oSysDomain"] == null)
            { _goSysDomainBE = new SysDomainBE(); _goSysDomainBE.DOMAIN_CODE = DBHelper.devuelveInt(this.txtDomainCode.Text); }
            else
            { _goSysDomainBE = (SysDomainBE)Session["oSysDomain"]; }
            _goSysDomainBE.DOMAIN_NAME = DBHelper.devuelveString(this.txtDomainName.Text);
            if (_gsModo.ToUpper() == "CI")
            { _goSysDomainController.createSysDomain(_goSysDomainBE); }
            else if (_gsModo.ToUpper() == "M" || _gsModo.ToUpper() == "CE")
            { _goSysDomainController.updateSysDomain(_goSysDomainBE); }
        }
        catch
        { }
        finally
        { btnVolver_Click(null, null); }
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            _goSysDomainController = new SysDomainController();
            _goSysDomainController.deleteSysDomain(DBHelper.devuelveInt(this.txtDomainCode.Text));
        }
        catch (Exception ex)
        { }
        finally
        { btnVolver_Click(null, null); }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("DOMAIN_CODE");
        Session.Remove("BTN_AGRE_MODO");
        this.Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado="+Session["tsListado"].ToString()+"&MODO="+Session["P_MODO_REPO"].ToString(), true);
    }
}