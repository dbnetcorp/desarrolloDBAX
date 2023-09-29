using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Resources;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.DBAX.Controlador;
using DBNeT.DBAX.Modelo;
using DBNeT.DBAX.Modelo.BE;
using DBNeT.DBAX.Modelo.DAC;
 
public partial class dbax_mant_desc_conc : System.Web.UI.Page 
{
    #region Pagina Base 
    private string _gsModo = string.Empty;
    private SessionWeb _goSessionWeb;
 
    private void RecuperaSessionWeb()
    {
        if (Session["sessionWeb"] == null)
        {Response.Redirect("~/dbnFw5/dbnLogin.aspx");}
        else
        { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
    }
    public void GuardaSessionWeb()
    { 
        Session["sessionWeb"] = _goSessionWeb;
    }
    #endregion
 
    #region Parametros
    string _gsCodiConc;
    string _gsCodiLang;
    string _gsPrefConc;
    #endregion
 
    DbaxDescConcBE _goDbaxDescConcBE;
    DbaxDescConcController _goDbaxDescConcController;
    DbneDefiLangController _goDbneDefiLangController;
 
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _goDbaxDescConcController = new DbaxDescConcController();
        this.lblError.Text = string.Empty;
        try
        {
            #region Rescatar Modo (Ingreso o Mantencion)
            if (Session["BTN_AGRE_MODO"] != null)
            { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
            else
            { _gsModo = Session["P_MODO_REPO"].ToString(); }

            if (Session["CODI_CONC"] != null && Session["CODI_LANG"] != null && Session["PREF_CONC"] != null)
            {
                _gsCodiConc = Session["CODI_CONC"].ToString();
    		    _gsCodiLang = Session["CODI_LANG"].ToString();
    		    _gsPrefConc = Session["PREF_CONC"].ToString();
            }
            
            #endregion
 
            if (!IsPostBack)
            {
                #region Carga Multilenguaje
                cargaMultilenguaje();
                #endregion 
                CargaDdl();
                #region Carga Datos
                if (_gsModo == "M")
                {
                    var loDbaxDescConc = this._goDbaxDescConcController.readDbaxDescConc("S", 0, 0, null, _gsCodiConc ,_gsPrefConc,_gsCodiLang, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                    this.txtPrefConc.Text = loDbaxDescConc.PREF_CONC;
                    this.txtCodiConc.Text = loDbaxDescConc.CODI_CONC;
                    Helper.ddlSelecciona(this.ddlCodiLang,loDbaxDescConc.CODI_LANG);
                    this.txtDescConc.Text = loDbaxDescConc.DESC_CONC;
                    this.txtPrefConc.Enabled = false;
                    this.txtCodiConc.Enabled = false;
                }
                #endregion
            }
        }
        catch (Exception ex)
        { throw ex; }
    }
 
    private void cargaMultilenguaje()
    {
        this.lblTitulo.Text = multilenguaje.TITU_DBAX_MANT_DESC_CONC;
        if (this.lblTitulo.Text == "") this.lblTitulo.Text = "TIT_DBAX_DESC_CONC";
        this.lblPrefConc.Text = multilenguaje.lblPrefConc;
        if (this.lblPrefConc.Text == "") this.lblPrefConc.Text = "PREF_CONC";
        this.lblCodiConc.Text = multilenguaje.lblCodiConc;
        if (this.lblCodiConc.Text == "") this.lblCodiConc.Text = "CODI_CONC";
        this.lblCodiLang.Text = multilenguaje.lblCodiLang;
        if (this.lblCodiLang.Text == "") this.lblCodiLang.Text = "CODI_LANG";
        this.lblDescConc.Text = multilenguaje.lblDescConc;
        if (this.lblDescConc.Text == "") this.lblDescConc.Text = "DESC_CONC";
    }
    private void limpiarTxt()
    {
        this.txtPrefConc.Text = string.Empty;
        this.txtCodiConc.Text = string.Empty;
        this.txtDescConc.Text = string.Empty;
    }
    private void CargaDdl()
    {
        _goDbneDefiLangController = new DbneDefiLangController();
        Helper.ddlCarga(ddlCodiLang, _goDbneDefiLangController.readDbneDefiLangDt("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX));
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        _goDbaxDescConcBE = new DbaxDescConcBE();
        _goDbaxDescConcBE.PREF_CONC = this.txtPrefConc.Text;
        _goDbaxDescConcBE.CODI_CONC = this.txtCodiConc.Text;
        _goDbaxDescConcBE.CODI_LANG = this.ddlCodiLang.SelectedValue;
        _goDbaxDescConcBE.DESC_CONC = this.txtDescConc.Text;

        try
        {
            if (_gsModo == "CI")
            { this._goDbaxDescConcController.createDbaxDescConc(_goDbaxDescConcBE); }
            else if (_gsModo == "M")
            { this._goDbaxDescConcController.updateDbaxDescConc(_goDbaxDescConcBE); }
        }
        catch (Exception ex)
        { this.lblError.Text += ex.Message; }
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        if (this.txtCodiConc.Text.Length > 0 && this.ddlCodiLang.SelectedIndex > 0 && this.txtPrefConc.Text.Length > 0)
        {
            _goDbaxDescConcController.deleteDbaxDescConc(this.txtCodiConc.Text, this.ddlCodiLang.SelectedValue, this.txtPrefConc.Text);
            btnVolver_Click(null, null);
        }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("CODI_CONC");
        Session.Remove("PREF_CONC");
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_DBAX_DESC_CONC&MODO=" + Session["P_MODO_REPO"].ToString());
    }
}