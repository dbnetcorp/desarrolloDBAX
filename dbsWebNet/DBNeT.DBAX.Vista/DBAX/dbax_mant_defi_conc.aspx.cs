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
 
public partial class dbax_mant_defi_conc : System.Web.UI.Page 
{
    #region Pagina Base 
    private string _gsModo = string.Empty;
    private SessionWeb _goSessionWeb;
    ListaValoresControllers _goListaValores;
    private void RecuperaSessionWeb()
    {
        if (Session["sessionWeb"] == null)
        {Response.Redirect("~/dbnFw5/dbnLogin.aspx");}
        else
        {_goSessionWeb = (SessionWeb)Session["sessionWeb"];}
    }
    public void GuardaSessionWeb()
    { Session["sessionWeb"] = _goSessionWeb; }
    #endregion
 
    #region Parametros
    string _gsCodiConc;
    string _gsPrefConc;
    #endregion
 
    DbaxDefiConcBE _goDbaxDefiConcBE;
    DbaxDefiConcController _goDbaxDefiConcController;
    DbaxTipoConcController _goDbaxTipoConcController;
    DbaxTipoTaxoController _goDbaxTipoTaxoController;
 
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _goListaValores = new ListaValoresControllers();
        _goDbaxDefiConcController = new DbaxDefiConcController();
        this.lblError.Text = string.Empty;
 
        try
        {
            #region Rescatar Modo (Ingreso o Mantencion)
            if (Session["BTN_AGRE_MODO"] != null)
            { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
            else
            { _gsModo = Session["P_MODO_REPO"].ToString(); }

            if (Session["CODI_CONC"] != null && Session["PREF_CONC"] != null)
            { _gsCodiConc = Session["CODI_CONC"].ToString(); _gsPrefConc = Session["PREF_CONC"].ToString(); }

            #endregion
            if (!IsPostBack)
            {
                CargaDdl();
                #region Carga Multilenguaje
                cargaMultilenguaje();
                #endregion
                #region Carga Datos
                switch(_gsModo)
                {
                    case "M":
                        var loDbaxDefiConc = this._goDbaxDefiConcController.readDbaxDefiConc("S", 0, 0, _gsCodiConc,null,_gsPrefConc , null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                        this.txtPrefConc.Text = _gsPrefConc;
                        this.txtCodiConc.Text = _gsCodiConc;
                        Helper.ddlSelecciona(ddlTipoConc,loDbaxDefiConc.TIPO_CONC);
                        this.txtTipoPeri.Text = loDbaxDefiConc.TIPO_PERI;
                        this.txtTipoValo.Text = loDbaxDefiConc.TIPO_VALO;
                        this.txtTipoCuen.Text = loDbaxDefiConc.TIPO_CUEN;
                        this.txtCodiNume.Text = loDbaxDefiConc.CODI_NUME;
                        Helper.ddlSelecciona(ddlTipoTaxo, loDbaxDefiConc.TIPO_TAXO);
                        this.txtPrefConc.Enabled = false;
                        this.txtCodiConc.Enabled = false;
                    break;
                }
                #endregion
            }
        }
        catch (Exception ex)
        { throw ex; }
    }

    public void CargaDdl()
    {
        _goDbaxTipoConcController = new DbaxTipoConcController();
        Helper.ddlCarga(ddlTipoConc, _goDbaxTipoConcController.readDbaxTipoConcDt("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX));

        _goDbaxTipoTaxoController = new DbaxTipoTaxoController();
        Helper.ddlCarga(ddlTipoTaxo, _goDbaxTipoTaxoController.readDbaxTipoTaxoDt("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX));
        SysParamController _loSysaParam = new SysParamController();
        var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_DEFE_TAXO", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        ddlTipoTaxo.SelectedValue = loResultado.PARAM_VALUE;
    }
    private void cargaMultilenguaje()
    {
        this.lblTitulo.Text = multilenguaje.TITU_DBAX_MANT_DEFI_CONC;
        if (this.lblTitulo.Text == "") this.lblTitulo.Text = "TIT_DBAX_DEFI_CONC";
        this.lblPrefConc.Text = multilenguaje.lblPrefConc;
        if (this.lblPrefConc.Text == "") this.lblPrefConc.Text = "PREF_CONC";
        this.lblCodiConc.Text = multilenguaje.lblCodiConc;
        if (this.lblCodiConc.Text == "") this.lblCodiConc.Text = "CODI_CONC";
        this.lblTipoConc.Text = multilenguaje.lblTipoConc;
        if (this.lblTipoConc.Text == "") this.lblTipoConc.Text = "TIPO_CONC";
        this.lblTipoPeri.Text = multilenguaje.lblTipoPeri;
        if (this.lblTipoPeri.Text == "") this.lblTipoPeri.Text = "TIPO_PERI";
        this.lblTipoValo.Text = multilenguaje.lblTipoValo;
        if (this.lblTipoValo.Text == "") this.lblTipoValo.Text = "TIPO_VALO";
        this.lblTipoCuen.Text = multilenguaje.lblTipoCuen;
        if (this.lblTipoCuen.Text == "") this.lblTipoCuen.Text = "TIPO_CUEN";
        this.lblCodiNume.Text = multilenguaje.lblCodiNume;
        if (this.lblCodiNume.Text == "") this.lblCodiNume.Text = "CODI_NUME";
        this.lblTipoTaxo.Text = multilenguaje.lblTipoTaxo;
        if (this.lblTipoTaxo.Text == "") this.lblTipoTaxo.Text = "TIPO_TAXO";
    }
 
    private void limpiarTxt()
    {
        this.txtPrefConc.Text = string.Empty;
        this.txtCodiConc.Text = string.Empty;
        this.ddlTipoConc.SelectedIndex = 0;
        this.txtTipoPeri.Text = string.Empty;
        this.txtTipoValo.Text = string.Empty;
        this.txtTipoCuen.Text = string.Empty;
        this.txtCodiNume.Text = string.Empty;
        this.ddlTipoTaxo.SelectedIndex = 0;
    }
 
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        _goDbaxDefiConcBE = new DbaxDefiConcBE();
        _goDbaxDefiConcBE.PREF_CONC = this.txtPrefConc.Text;
        _goDbaxDefiConcBE.CODI_CONC = this.txtCodiConc.Text;
        _goDbaxDefiConcBE.TIPO_CONC = this.ddlTipoConc.SelectedValue;
        _goDbaxDefiConcBE.TIPO_PERI = this.txtTipoPeri.Text;
        _goDbaxDefiConcBE.TIPO_VALO = this.txtTipoValo.Text;
        _goDbaxDefiConcBE.TIPO_CUEN = this.txtTipoCuen.Text;
        _goDbaxDefiConcBE.CODI_NUME = this.txtCodiNume.Text;
        _goDbaxDefiConcBE.TIPO_TAXO = this.ddlTipoTaxo.SelectedValue;

        try
        {
            switch (_gsModo)
            {
                case "CI":
                    this._goDbaxDefiConcController.createDbaxDefiConc(_goDbaxDefiConcBE);
                    break;
                case "M":
                    this._goDbaxDefiConcController.updateDbaxDefiConc(_goDbaxDefiConcBE);
                    break;
            }
        }
        catch (Exception ex)
        { lblError.Text += ex.Message; }
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        if (this.txtCodiConc.Text.Length > 0 && this.txtPrefConc.Text.Length > 0)
        {
            _goDbaxDefiConcController.deleteDbaxDefiConc(this.txtCodiConc.Text, this.txtPrefConc.Text);
            btnVolver_Click(null, null);
        }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("MODO");
        Session.Remove("CODI_CONC");
        Session.Remove("PREF_CONC");
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_DBAX_DEFI_CONC&MODO=" + Session["P_MODO_REPO"].ToString());
    }
}