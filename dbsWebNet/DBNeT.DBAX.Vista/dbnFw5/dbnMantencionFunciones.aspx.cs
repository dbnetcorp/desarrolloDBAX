using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Modelo;

public partial class dbnMantencionFunciones : System.Web.UI.Page
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
    SysObjectBE _goSysObjectBE;
    SysObjectController _goSysObjectController;
    SysCodeController _goSysCodeController;
    string _gsObjectName = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _goSysObjectController = new SysObjectController();
        _goSysObjectBE = new SysObjectBE();
        this.CargaMultilenguaje();

        if (Session["BTN_AGRE_MODO"] != null)
        { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
        else
        { _gsModo = Session["P_MODO_REPO"].ToString(); _gsObjectName = Session["OBJECT_NAME"].ToString(); }
        #region IsPostBack
        if (!IsPostBack)
        {
            CargaDdlTipo();
            if(_gsModo.ToUpper() == "M" || _gsModo.ToUpper() == "CE")
            {
                var loResultado = _goSysObjectController.readSysObject("S", 0, 0, null, _gsObjectName, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                Session["oSysObject"] = loResultado;
                txtAbreviatura.Text = loResultado.OBJECT_SINGLE;
                txtArch.Text = loResultado.OBJECT_PROG;
                txtCodigo.Text = loResultado.OBJECT_NAME;
                txtCodiModu.Text = loResultado.CODI_MODU;
                txtDescripcion.Text = loResultado.OBJECT_DESC;
                txtMenu.Text = loResultado.OBJECT_RELA;
                txtOrden.Text = loResultado.OBJECT_ORUN;
                txtPara1.Text = loResultado.PAR0;
                txtPara2.Text = loResultado.PAR1;
                txtPara3.Text = loResultado.PAR2;
                txtResumen.Text = loResultado.OBJECT_BRIEF;
                ddlTipo.SelectedValue = loResultado.OBJECT_TYPE;
                txtValo1.Text = loResultado.VAL0;
                txtValo2.Text = loResultado.VAL1;
                txtValo3.Text = loResultado.VAL2;
            }
        }
        #endregion
    }

    private void CargaMultilenguaje()
    {
        lblTitulo.Text = "Mantención de funciones";
        lblAbreviatura.Text = "Abreviatura";
        lblArch.Text = "Arch";
        lblCodigo.Text = "Código";
        lblDescripcion.Text = "Descripción";
        lblMenu.Text = "Menú";
        lblModulo.Text = "Módulo";
        lblOrden.Text = "Orden";
        lblParametro1.Text = "Parámetro 1";
        lblParametro2.Text = "Parámetro 2";
        lblParametro3.Text = "Parámetro 3";
        lblResumen.Text = "Resumen";
        lblTipo.Text = "Tipo";
        lblValo2.Text = "Valor 2";
        lblValo3.Text = "Valor 3";
        lblValo1.Text = "Valor 1";
    }
    private void CargaDdlTipo()
    {
        _goSysCodeController = new SysCodeController();
        var loResultado = _goSysCodeController.readSysCodeDt("LV",0,0,null,null,null, null,null,null,_goSessionWeb.CODI_USUA,_goSessionWeb.CODI_EMPR,_goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlTipo, loResultado);
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            _goSysObjectBE = new SysObjectBE();
            if (Session["oSysObject"] == null)
            { _goSysObjectBE = new SysObjectBE(); }
            else
            { _goSysObjectBE = (SysObjectBE)Session["oSysObject"]; }
            _goSysObjectBE.CODI_MODU = this.txtCodiModu.Text.Trim();
            _goSysObjectBE.OBJECT_RELA = this.txtMenu.Text.Trim();
            _goSysObjectBE.OBJECT_NAME = this.txtCodigo.Text.Trim();
            _goSysObjectBE.OBJECT_TYPE = this.ddlTipo.SelectedValue;
            _goSysObjectBE.OBJECT_PROG = this.txtArch.Text.Trim();
            _goSysObjectBE.OBJECT_BRIEF = this.txtDescripcion.Text.Trim();
            _goSysObjectBE.OBJECT_SINGLE = this.txtAbreviatura.Text.Trim();
            _goSysObjectBE.OBJECT_DESC = this.txtDescripcion.Text.Trim();
            _goSysObjectBE.OBJECT_ORUN = this.txtOrden.Text.Trim();
            _goSysObjectBE.PAR0 = this.txtPara1.Text.Trim();
            _goSysObjectBE.PAR1 = this.txtPara2.Text.Trim();
            _goSysObjectBE.PAR2 = this.txtPara3.Text.Trim();
            if (_gsModo.ToUpper() == "CI")
            { _goSysObjectController.createSysObject(_goSysObjectBE); }
            else if (_gsModo.ToUpper() == "CE" || _gsModo.ToUpper() == "M")
            { _goSysObjectController.updateSysObject(_goSysObjectBE); }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
        finally
        { btnVolver_Click(null, null); }
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            _goSysObjectController = new SysObjectController();
            _goSysObjectController.deleteSysObject(this.txtCodigo.Text.Trim());
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
        finally
        { btnVolver_Click(null, null); }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("OBJECT_NAME");
        Session.Remove("oSysObject");
        this.Response.Redirect("~/dbnFw5/dbnfw5Listador.aspx?listado=" + Session["tsListado"].ToString() + "&modo=" + Session["P_MODO_REPO"].ToString(), true);
    }
}