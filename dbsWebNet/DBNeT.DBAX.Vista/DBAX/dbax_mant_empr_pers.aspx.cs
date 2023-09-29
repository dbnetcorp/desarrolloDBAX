using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Modelo;
using DBNeT.DBAX.Modelo.BE;
using DBNeT.DBAX.Controlador;
using Resources;
using DBNeT.Base.Controlador;

public partial class dbax_mant_empr_pers : System.Web.UI.Page
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
        { Response.Redirect("~/dbnFw5/dbnLogin.aspx"); }
        else
        { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
    }
    private void GuardaSessionWeb()
    { Session["sessionWeb"] = _goSessionWeb; }
    #endregion
    DbaxDefiPersController _goDbaxDefiPersController;
    DbaxDefiGrupController _goDbaxDefiGrupController;
    DbaxDefiSegmController _goDbaxDefiSegmController;
    DbaxTipoTaxoController _goDbaxTipoTaxoController;
    DbaxDefiPehoController _goDbaxDefiPehoController;
    ListaValoresController _goListaValoresController;
    string _gsCodiPers = string.Empty;
    string _gsDescPers = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        this.Multilenguaje();
        this.lblError.Text = string.Empty;
        
        _goDbaxDefiPersController = new DbaxDefiPersController();
        _goDbaxDefiPehoController = new DbaxDefiPehoController();
        _goListaValoresController = new ListaValoresController();
        if (Session["CODI_PERS"] != null)
        { _gsCodiPers = Session["CODI_PERS"].ToString(); }
        if (Session["BTN_AGRE_MODO"] != null)
        { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
        else
        { _gsModo = Session["P_MODO_REPO"].ToString(); }
        if (!IsPostBack)
        {
            this.CargaDdl();
            switch(_gsModo)
            {
                case "M":    
                    this.txtCodiPers.Enabled = false;
                    //this.txtNombPers.Enabled = false;
                    var loREsultado = _goDbaxDefiPersController.readDbaxDefiPers("L", 1, 1, null, _gsCodiPers, _gsDescPers, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                    var loDefiPeho = _goDbaxDefiPehoController.readDbaxDefiPeho("L", 1, 1, null, _gsCodiPers, _gsDescPers, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                    Session["oDbaxDefiPeho"] = loDefiPeho;
                    Session["oDbaxDefiPers"] = loREsultado;
                    
                    this.txtCodiPers.Text = loREsultado.CODI_PERS.ToString();
                    this.txtNombPers.Text = loREsultado.DESC_PERS;
                    this.txtDescPers.Text = loDefiPeho.DESC_EMPR;
                    Helper.ddlSelecciona(ddlCodiGrup, loREsultado.CODI_GRUP);
                    Helper.ddlSelecciona(ddlCodiSegm, loREsultado.CODI_SEGM);
                    Helper.ddlSelecciona(ddlTipoTaxo, loREsultado.TIPO_TAXO);
                    var loPartBurs = _goListaValoresController.readParticipacionBursatil();
                    Helper.ddlCarga(ddlPartBurs, loPartBurs);
                    this.ddlPartBurs.SelectedValue = loREsultado.PRES_BURS;
                    Helper.aplicaCkb(loREsultado.EMIS_BONO, ckbEmisBono,"SI","NO");
                    Helper.aplicaCkb(loREsultado.EMPR_VIGE, ckbEmprVige,"SI","NO");
                break;
            }
        }
    }
    private void Multilenguaje()
    {
        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
        this.btnEliminar.ToolTip = multilenguaje_base.tt_btnEliminar;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
        this.lblRepoTitulo.Text = multilenguaje.TITU_DBAX_MANT_EMPR_PERS;
        this.lblCodiGroup.Text = multilenguaje.lblCodiGroup;
        this.lblCodiPers.Text = multilenguaje.lblCodiPers;
        this.lblCodiSegm.Text = multilenguaje.lblCodiSegm;
        this.lblDescPers.Text = multilenguaje.lblDescPers;
        this.lblEmisBono.Text = multilenguaje.lblEmisBono;
        this.lblPresBurs.Text = multilenguaje.lblPresBurs;
        this.lblTipoTaxo.Text = multilenguaje.lblTipoTaxo;
        this.lblDescPeho.Text = multilenguaje.lblDescPeho;
        this.lblEmprVige.Text = multilenguaje.EMPR_VIGE;
    }
    private void CargaDdl()
    {
        _goDbaxDefiGrupController = new DbaxDefiGrupController();
        var loResultadoGrup = _goDbaxDefiGrupController.readDbaxDefiGrupDt("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlCodiGrup, loResultadoGrup);

        _goDbaxDefiSegmController = new DbaxDefiSegmController();
        var loResultadoSeg = _goDbaxDefiSegmController.readDbaxDefiSegmDt("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlCodiSegm, loResultadoSeg);

        _goDbaxTipoTaxoController = new DbaxTipoTaxoController();
        var loResultadoTipo = _goDbaxTipoTaxoController.readDbaxTipoTaxoDt("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlTipoTaxo, loResultadoTipo);
        SysParamController _loSysaParam = new SysParamController();
        var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_DEFE_TAXO", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        ddlTipoTaxo.SelectedValue = loResultado.PARAM_VALUE;

        _goListaValoresController = new ListaValoresController();
        var loPartBurs = _goListaValoresController.readParticipacionBursatil();
        Helper.ddlCarga(ddlPartBurs, loPartBurs);
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            DbaxDefiPersBE loDbaxDefiPers;
            DbaxDefiPehoBE loDbaxDefiPeho;
            if (Session["oDbaxDefiPers"] != null)
            { loDbaxDefiPers = (DbaxDefiPersBE)Session["oDbaxDefiPers"]; }
            else
            { loDbaxDefiPers = new DbaxDefiPersBE(); }
            if (Session["oDbaxDefiPeho"] != null)
            { loDbaxDefiPeho = (DbaxDefiPehoBE)Session["oDbaxDefiPeho"]; }
            else
            { loDbaxDefiPeho = new DbaxDefiPehoBE(); }
            loDbaxDefiPers.CODI_PERS = this.txtCodiPers.Text;
            loDbaxDefiPers.CODI_GRUP = this.ddlCodiGrup.SelectedValue;
            loDbaxDefiPers.CODI_SEGM = this.ddlCodiSegm.SelectedValue;
            loDbaxDefiPers.TIPO_TAXO = this.ddlTipoTaxo.SelectedValue;
            loDbaxDefiPers.PRES_BURS = this.ddlPartBurs.SelectedValue;
            loDbaxDefiPers.EMIS_BONO = Helper.CompruebaCkb(ckbEmisBono);
            loDbaxDefiPers.EMPR_VIGE = Helper.CompruebaCkb(ckbEmprVige);
            loDbaxDefiPers.DESC_PERS = this.txtNombPers.Text;
            loDbaxDefiPeho.DESC_EMPR = this.txtDescPers.Text;

            switch (_gsModo)
            {
                case "CI":
                    _goDbaxDefiPersController.createDbaxDefiPers(loDbaxDefiPers);
                    break;
                case "M":
                    _goDbaxDefiPersController.updateDbaxDefiPers(loDbaxDefiPers);
                    _goDbaxDefiPehoController.updateDbaxDefiPeho(loDbaxDefiPeho);
                    break;
            }
        }
        catch (Exception)
        { lblError.Text += "No se puede Ingresar una Empresa con un rut Duplicado"; }
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            switch (_gsModo)
            {
                case "M":
                    _goDbaxDefiPersController.deleteDbaxDefiPers(Convert.ToInt32(this._gsCodiPers));
                    break;
            }
        }
        catch (Exception ex)
        { lblError.Text += ex.Message; }
    } 
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        this.Session.Remove("CODI_PERS");
        this.Session.Remove("oDbaxDefiPers");
        this.Session.Remove("oDbaxDefiPeho");
        this.Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_DBAX_DEFI_PERS&MODO=" + Session["P_MODO_REPO"].ToString());
    }

    private void ValidaFormulario()
    {
        this.lblError.Text = string.Empty;
        this.lblError.Text = "ERROR<br/>";
        this.lblError.Text += "<img src=\"../librerias/img/imgWarn.png\" border=\"0\" class=\"dbnEstado\" /> <br/>";
        int x = 0;

        if (x > 0)
        { lblError.Visible = true; }
        else
        { lblError.Text = string.Empty; }
    }
    protected void ddlCodiGrup_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void ddlCodiSegm_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void ddlTipoTaxo_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}