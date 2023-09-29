using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Controlador;
using DBNeT.DBAX.Modelo.BE;
using DBNeT.Base.Modelo;
using Resources;

public partial class dbax_mant_defi_ramo : System.Web.UI.Page
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
    DbaxDefiRamoController _goDefiRamoController;
    DbaxDefiSegmController _goDefiSegmController;
    DecodificaUnicode _goDecoUni;
    string _gsCodiSegm = string.Empty, _gsCodiRamo = string.Empty, _gsTipoRamo = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Multilenguaje();
        this.lblError.Text = string.Empty;
        this.RecuperaSessionWeb();
        _goDefiRamoController = new DbaxDefiRamoController();
        _goDefiSegmController = new DbaxDefiSegmController();
        _goDecoUni = new DecodificaUnicode();
        if (Session["BTN_AGRE_MODO"] != null)
        { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
        else
        { _gsModo = Session["P_MODO_REPO"].ToString(); }

        if (Session["CODI_SEGM"] != null)
        { _gsCodiSegm = _goDecoUni.DecodeUnicode(Session["CODI_SEGM"].ToString()); }
        if (Session["CODI_RAMO"] != null)
        { _gsCodiRamo = _goDecoUni.DecodeUnicode(Session["CODI_RAMO"].ToString()); }
        if (Session["TIPO_RAMO"] != null)
        { _gsTipoRamo = _goDecoUni.DecodeUnicode(Session["TIPO_RAMO"].ToString()); }

        if (!IsPostBack)
        {
            CargaDdl();
            switch (_gsModo)
            {
                case "CI":
                    break;
                case "M":
                    var loDefiRamo = _goDefiRamoController.readDbaxDefiRamo("S", 0, 0, null, _gsCodiSegm, _gsCodiRamo, _gsTipoRamo, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                    Session["oDefiRamo"] = loDefiRamo;
                    this.txtCodiRamo.Text = loDefiRamo.CODI_RAMO;
                    this.ddlCodiSegm.SelectedValue= loDefiRamo.CODI_SEGM;
                    this.txtDescRamo.Text = loDefiRamo.DESC_RAMO;
                    Helper.ddlSelecciona(ddlCodiRamoSupe, loDefiRamo.CODI_RAMO_SUPE);
                    Helper.ddlSelecciona(ddlCodiSegm, loDefiRamo.CODI_SEGM);
                    this.txtTipoRamo.Text = loDefiRamo.TIPO_RAMO;
                    this.txtNumeRamo.Text = loDefiRamo.NUME_RAMO.ToString();
                    this.txtCodiConc.Text = loDefiRamo.CODI_CONC;
                    this.txtCodiRamo.Enabled = false;
                    this.ddlCodiSegm.Enabled = false;
                    break;
            }
        }
    }
    private void Multilenguaje()
    {
        this.lblCodiSegm.Text = multilenguaje.lblCodiSegm;
        this.lblCodiRamo.Text = multilenguaje.lblCodiRamo;
        this.lblCodiRamoSupe.Text = multilenguaje.lblCodiRamoSupe;
        this.lblDescRamo.Text = multilenguaje.lblDescRamo;
        this.lblTitulo.Text = multilenguaje.TITU_DBAX_MANT_DEFI_RAMO;
        this.lblTipoRamo.Text = "Tipo Ramo";
        this.lblCodiConc.Text = multilenguaje.lblCodiConc;
        this.lblNumeRamo.Text = "Número de Ramo";
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            DbaxDefiRamoBE loDefiRamoBE;
            if (Session["oDefiRamo"] != null)
            { loDefiRamoBE = (DbaxDefiRamoBE)Session["oDefiRamo"]; }
            else
            { loDefiRamoBE = new DbaxDefiRamoBE(); }
            loDefiRamoBE.CODI_RAMO = this.txtCodiRamo.Text;
            loDefiRamoBE.CODI_SEGM = this.ddlCodiSegm.SelectedValue;
            loDefiRamoBE.DESC_RAMO = this.txtDescRamo.Text;
            loDefiRamoBE.CODI_RAMO_SUPE = ddlCodiRamoSupe.SelectedValue;
            loDefiRamoBE.TIPO_RAMO = txtTipoRamo.Text.Trim();
            loDefiRamoBE.CODI_CONC = txtCodiConc.Text.Trim();
            loDefiRamoBE.NUME_RAMO = txtNumeRamo.Text.Trim();

            switch (_gsModo)
            {
                case "CI":
                    _goDefiRamoController.createDbaxDefiRamo(loDefiRamoBE);
                    break;
                case "M":
                    _goDefiRamoController.updateDbaxDefiRamo(loDefiRamoBE);
                    break;
            }
        }
        catch (Exception ex)
        { this.lblError.Text += ex.Message; }
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            _goDefiRamoController.deleteDbaxDefiRamo(this.ddlCodiSegm.SelectedValue, txtCodiRamo.Text, this.txtTipoRamo.Text);
        }
        catch (Exception ex)
        { lblError.Text += ex.Message; }
        finally
        { btnVolver_Click(null, null); }

    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("oDefiRamo");
        Session.Remove("BTN_AGRE_MODO");
        this.Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_DBAX_DEFI_RAMO&MODO=" + Session["P_MODO_REPO"].ToString());
    }

    private void CargaDdl()
    {
        _goDefiRamoController = new DbaxDefiRamoController();
        var loDefiRamo = _goDefiRamoController.readDbaxDefiRamoDt("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlCodiRamoSupe, loDefiRamo);

        _goDefiSegmController = new DbaxDefiSegmController();
        var loDefiSegm = _goDefiSegmController.readDbaxDefiSegmDt("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlCodiSegm, loDefiSegm);
    }
    private void ValidaFormulario()
    {
        this.lblError.Text = string.Empty;
        this.lblError.Text = "ERROR<br/>";
        this.lblError.Text += "<img src=\"../librerias/img/imgWarn.png\" border=\"0\" class=\"dbnEstado\" /> <br/>";
        int x = 0;
        if (txtNumeRamo.Text.Trim().Length == 0)
        { x++; lblError.Text += "Debe Ingresar un Número de Ramo"; }

        if (x > 0)
        { lblError.Visible = true; }
        else
        { lblError.Text = string.Empty; }
    }
}