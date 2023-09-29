using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Resources;
using DBNeT.DBAX.Controlador;
using DBNeT.DBAX.Modelo.BE;
using DBNeT.Base.Modelo;

public partial class DBAX_dbax_mant_homo_deta : System.Web.UI.Page
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
    DbaxHomoDetaController _goHomoDetaController;
    DbaxHomoConcController _goHomoConcController;
    string _gsCodiHoco = string.Empty, _gsPrefConc = string.Empty, _gsCodiConc = string.Empty,_gsPrefconc1 = string.Empty, _gsCodiConc1 = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        this.txtCodiHoco.Enabled = false;
        this.txtTaxoDest.Enabled = false;
        this.txtTaxoOrig.Enabled = false;
        this.RecuperaSessionWeb();
        this.lblError.Text = string.Empty;
        _goHomoDetaController = new DbaxHomoDetaController();
        this.Multilenguaje();
        if (Session["CODI_HOCO"] != null)
        { _gsCodiHoco = Session["CODI_HOCO"].ToString(); }
        
        if (Session["PREF_CONC"] != null)
        { _gsPrefConc = Session["PREF_CONC"].ToString(); }
        
        if (Session["CODI_CONC"] != null)
        { _gsCodiConc = Session["CODI_CONC"].ToString(); }
        
        if (Session["PREF_CONC1"] != null)
        { _gsPrefconc1 = Session["PREF_CONC1"].ToString(); }
        
        if (Session["CODI_CONC1"] != null)
        { _gsCodiConc1 = Session["CODI_CONC1"].ToString(); }


        if (Session["BTN_AGRE_MODO"] != null)
        { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
        else
        { _gsModo = Session["P_MODO_REPO"].ToString(); }

        if (!IsPostBack)
        {
            switch (_gsModo)
            {
                case "CI":
                    this.txtCodiHoco.Enabled = false;
                        _goHomoConcController = new DbaxHomoConcController();
                        var loHomoConc = _goHomoConcController.readDbaxHomoConc("S", 0, 0, null, _gsCodiHoco, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                        Session["oHomoConc"] = loHomoConc;
                        this.txtCodiHoco.Text = loHomoConc.CODI_HOCO.ToString();
                        this.txtTaxoOrig.Text = loHomoConc.VERS_TAXO.ToString();
                        this.txtTaxoDest.Text = loHomoConc.VERS_TAXO_DEST.ToString();
                        CargaPrefConc(loHomoConc.VERS_TAXO);
                        CargaPrefConc1(loHomoConc.VERS_TAXO);
                    break;
                case "M":
                        _goHomoConcController = new DbaxHomoConcController();
                        var loHomoConc1 = _goHomoConcController.readDbaxHomoConc("S", 0, 0, null, _gsCodiHoco, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                        Session["oHomoConc"] = loHomoConc1;
                        this.txtCodiHoco.Text = loHomoConc1.CODI_HOCO.ToString();
                        //Carga de los texbox versión de taxonomía
                        this.txtTaxoOrig.Text = loHomoConc1.VERS_TAXO.ToString();
                        this.txtTaxoDest.Text = loHomoConc1.VERS_TAXO_DEST.ToString();
                        //Carga DropDownList con la taxonomía para cada uno
                        CargaPrefConc(loHomoConc1.VERS_TAXO);
                        CargaPrefConc1(loHomoConc1.VERS_TAXO_DEST);
                        
                        //Selecciona el Prefijo de Cada DropDownList
                        Helper.ddlSelecciona(ddlPrefConc, _gsPrefConc);
                        Helper.ddlSelecciona(ddlPrefConc1, _gsPrefconc1);
                        
                        //Ejectua los eventos para cargar los conceptos
                        ddlPrefConc_SelectedIndexChanged(null, null);
                        ddlPrefConc1_SelectedIndexChanged(null, null);
                        
                        //selecciona los conceptos asociados a los prefijos
                        Helper.ddlSelecciona(ddlCodiConc, _gsCodiConc);
                        Helper.ddlSelecciona(ddlCodiConc1, _gsCodiConc1);
                    break;
            }
        }
    }
    private void Multilenguaje()
    {
        this.lblRepoTitulo.Text = multilenguaje.TITU_DBAX_MANT_HOMO_DETA;
        this.lblCodiHoco.Text = multilenguaje.lblCodiHoco;
        this.lblCodiConc.Text = multilenguaje.lblCodiConc;
        this.lblCodiConc1.Text = multilenguaje.lblCodiConc1;
        this.lblPrefConc.Text = multilenguaje.lblPrefConcOri;
        this.lblPrefConc1.Text = multilenguaje.lblPrefConc1;
        this.lblTaxoOrig.Text = multilenguaje.lblVersTaxoOrig;
        this.lblTaxoDest.Text = multilenguaje.lblVersTaxoDest;
    }

    private void CargaPrefConc(string tsVersTaxo)
    {
        ListaValoresController loListaValores = new ListaValoresController();
        var loPrefConc = loListaValores.readPrefConc("LV", 0, 0, null, tsVersTaxo, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        if (loPrefConc.Rows.Count > 1)
        { Helper.ddlCarga(ddlPrefConc, loPrefConc); }
        else
        { this.ddlPrefConc.Enabled = false; }
    }
    private void CargaCodiConc()
    {
      
        DbaxHomoConcBE loHomoConc = (DbaxHomoConcBE)Session["oHomoConc"];
        ListaValoresController loListaValores = new ListaValoresController();
        var loCodiConc = loListaValores.readCodiConc("LV", 0, 0, null, loHomoConc.VERS_TAXO, this.ddlPrefConc.SelectedValue, Filtro_ConcOrig.Text, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        if (loCodiConc.Rows.Count > 1)
        {
            this.ddlCodiConc.Enabled = true;
            Helper.ddlCarga(ddlCodiConc, loCodiConc); 
        }
        else
        { this.ddlCodiConc.Enabled = false; }
    }

    private void CargaPrefConc1(string tsVersTaxo)
    {
        ListaValoresController loListaValores = new ListaValoresController();
        var loPrefConc = loListaValores.readPrefConc("LV", 0, 0, null, tsVersTaxo, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        if (loPrefConc.Rows.Count > 1)
        { 
            Helper.ddlCarga(ddlPrefConc1, loPrefConc);
        }
        else
        { this.ddlPrefConc.Enabled = false; }
    }
    private void CargaCodiConc1()
    {

        DbaxHomoConcBE loHomoConc = (DbaxHomoConcBE)Session["oHomoConc"];
        ListaValoresController loListaValores = new ListaValoresController();
        var loCodiConc1 = loListaValores.readCodiConc("LV", 0, 0, null, loHomoConc.VERS_TAXO_DEST, this.ddlPrefConc1.SelectedValue, Filtro_ConcDest.Text, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        if (loCodiConc1.Rows.Count > 1)
        {
            this.ddlCodiConc1.Enabled = true;
            Helper.ddlCarga(ddlCodiConc1, loCodiConc1);
        }
        else
        { this.ddlCodiConc1.Enabled = false; }
    }

    protected void ddlPrefConc_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["prefijo"] = this.ddlPrefConc.SelectedValue;
        CargaCodiConc();
    }
    protected void ddlPrefConc1_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["Prefijo1"] = this.ddlPrefConc1.SelectedValue;
        CargaCodiConc1();
    }
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            if (ddlCodiConc.Text == string.Empty ||
                ddlCodiConc1.Text == string.Empty ||
                ddlPrefConc.Text == string.Empty ||
                ddlPrefConc1.Text == string.Empty ||
                ddlCodiConc.SelectedIndex == 0 ||
                ddlCodiConc1.SelectedIndex == 0)
            {
                this.lblError.Text = "Debe seleccionar prefijo y concepto origen y destino";
            }
            else
            {
                this.lblError.Text = string.Empty;
                DbaxHomoDetaBE loHomoDeta = new DbaxHomoDetaBE();
                loHomoDeta.CODI_HOCO = Convert.ToInt32(this.txtCodiHoco.Text);
                loHomoDeta.CODI_CONC = this.ddlCodiConc.SelectedValue;
                loHomoDeta.CODI_CONC1 = this.ddlCodiConc1.SelectedValue;
                loHomoDeta.PREF_CONC = this.ddlPrefConc.SelectedValue;
                loHomoDeta.PREF_CONC1 = this.ddlPrefConc1.SelectedValue;
                switch (_gsModo)
                {
                    case "CI":
                        _goHomoDetaController.createDbaxHomoDeta(loHomoDeta);
                        break;
                    case "M":
                        _goHomoDetaController.updateDbaxHomoDeta(loHomoDeta);
                        break;

                }
                btnVolver_Click(null, null);
            }
        }
        catch (Exception ex)
        { this.lblError.Text += ex.Message; }
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            switch (_gsModo)
            {
                case "M":
                    _goHomoDetaController.deleteDbaxHomoDeta(Convert.ToInt32(this.txtCodiHoco.Text.Trim()), this.ddlPrefConc.SelectedValue, this.ddlCodiConc.SelectedValue, ddlPrefConc1.SelectedValue, ddlCodiConc1.SelectedValue);
                    break;
            }
            btnVolver_Click(null, null);
        }
        catch (Exception)
        { }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        this.Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_DBAX_HOMO_DETA&MODO=" + Session["P_MODO_REPO"].ToString());
    }
    protected void Filtro_ConcOrig_TextChanged(object sender, EventArgs e)
    {
        CargaCodiConc();

       
    }
    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionListOrig(string prefixText, int count, string contextKey)
    {
        DbaxHomoConcBE loHomoConc = (DbaxHomoConcBE)HttpContext.Current.Session["oHomoConc"];
        string PrefConc = "";
        PrefConc = (string)HttpContext.Current.Session["Prefijo"];
        SessionWeb _goSessionWeb = (SessionWeb)HttpContext.Current.Session["sessionWeb"];
        ListaValoresController loListaValores = new ListaValoresController();
        var loCodiConc = loListaValores.readCodiConc("LV", 0, 0, null, loHomoConc.VERS_TAXO, PrefConc, prefixText, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        string[] resultados = new string[loCodiConc.Rows.Count];
        for (int i = 0; i < loCodiConc.Rows.Count; i++)
        {
            resultados[i] = loCodiConc.Rows[i][1].ToString();
        }
        return resultados;
    }
    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionListDest(string prefixText, int count, string contextKey)
    {
        DbaxHomoConcBE loHomoConc = (DbaxHomoConcBE)HttpContext.Current.Session["oHomoConc"];
        string PrefConc = "";
        PrefConc = (string)HttpContext.Current.Session["Prefijo1"];
        SessionWeb _goSessionWeb = (SessionWeb)HttpContext.Current.Session["sessionWeb"];
        ListaValoresController loListaValores = new ListaValoresController();
        var loCodiConc = loListaValores.readCodiConc("LV", 0, 0, null, loHomoConc.VERS_TAXO_DEST, PrefConc, prefixText, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        string[] resultados = new string[loCodiConc.Rows.Count];
        for (int i = 0; i < loCodiConc.Rows.Count; i++)
        {
            resultados[i] = loCodiConc.Rows[i][1].ToString();
        }
        return resultados;
    }
    protected void Filtro_ConcDest_TextChanged(object sender, EventArgs e)
    {
        CargaCodiConc1();
      
    }
}