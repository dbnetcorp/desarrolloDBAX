using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Modelo;
using DBNeT.Base.Framework.Helper;

public partial class dbnFw5_dbnConfiguracionCode : System.Web.UI.Page
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
    SysCodeBE _goSysCodeBE;
    SysCodeController _goSysCodeController;
    string _gsDomainCode = string.Empty, _gsCode = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _goSysCodeBE = new SysCodeBE();
        _goSysCodeController = new SysCodeController(); 
        CargaMultilenguaje();

        #region Obtencion de valores
        if (Session["DOMAIN_CODE"] != null)
        { _gsDomainCode = Session["DOMAIN_CODE"].ToString(); }
        if (Session["CODE"] != null)
        { _gsCode = Session["CODE"].ToString(); }

        if (Session["BTN_AGRE_MODO"] != null)
        { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
        else
        { _gsModo = Session["P_MODO_REPO"].ToString(); }
        #endregion

        #region IsPostBack
        if (!IsPostBack)
        {
            if (_gsModo.ToUpper() == "M" || _gsModo.ToUpper() == "CE")
            {
                var loResultado = _goSysCodeController.readSysCode("S", 0, 0, null, _gsDomainCode, _gsCode, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                Session["oSysCode"] = loResultado;
                this.txtCode.Text = loResultado.CODE;
                this.txtCodeDesc.Text = loResultado.CODE_DESC;
                this.txtCode.Enabled = false;
            }
        }
        #endregion
    }
    private void CargaMultilenguaje()
    {
        lblTitulo.Text = "Edición de Code";
        lblCode.Text = "Código";
        lblCodeDesc.Text = "Descripción";
    }


    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            if (Session["oSysCode"] == null)
            { _goSysCodeBE = new SysCodeBE(); _goSysCodeBE.DOMAIN_CODE = DBHelper.devuelveInt(Session["DOMAIN_CODE"]); _goSysCodeBE.CODE = this.txtCode.Text; }
            else
            { _goSysCodeBE = (SysCodeBE)Session["oSysCode"]; }
            _goSysCodeBE.CODE_DESC = this.txtCodeDesc.Text;

            if (_gsModo.ToUpper() == "CI")
            { _goSysCodeController.createSysCode(_goSysCodeBE); }
            else if (_gsModo.ToUpper() == "CE" || _gsModo.ToUpper() == "M")
            { _goSysCodeController.updateSysCode(_goSysCodeBE); }
        }
        catch (Exception ex)
        { }
        finally
        { btnVolver_Click(null, null); }
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            _goSysCodeController = new SysCodeController();
            _goSysCodeController.deleteSysCode(DBHelper.devuelveInt(_gsDomainCode), _gsCode);
        }
        catch (Exception ex)
        { }
        finally
        { btnVolver_Click(null, null); }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("CODE");
        Session.Remove("oSysCode");
        this.Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado="+Session["tsListado"].ToString()+"&MODO="+Session["P_MODO_REPO"].ToString(), true);
    }
}