using System;
using System.Data;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Resources;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Modelo.DAC;
 
public partial class dbnConfiguracionDefiMone : System.Web.UI.Page 
{
    #region Pagina Base 
    private string _gsModo = string.Empty;
    private SessionWeb _goSessionWeb;
    private ListaValoresControllers _goListaValores;
 
    private void RecuperaSessionWeb()
    {
        if (Session["sessionWeb"] == null)
        {
            Response.Redirect("~/dbnFw5/dbnSesionExpirada.aspx",true);
        }
        else
        {
            _goSessionWeb = (SessionWeb)Session["sessionWeb"];
        }
    }
    #endregion
 
    #region Parametros
    string _gsCodiMone;
    #endregion
 
    DbnDefiMoneBE _goDbnDefiMoneBE;
    DbnDefiMoneController _goDbnDefiMoneController;
 
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _goListaValores = new ListaValoresControllers();
        _goDbnDefiMoneController = new DbnDefiMoneController();
 
        try
        {
            #region Rescatar Modo (Ingreso o Mantencion)
            if (Session["BTN_AGRE_MODO"] != null)
            { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
            else
            { _gsModo = Session["P_MODO_REPO"].ToString(); }
            #endregion
            if (Session["CODI_MONE"] != null)
            { _gsCodiMone = Session["CODI_MONE"].ToString(); }
            if (!IsPostBack)
            {
                CargaPais();
                #region Carga Multilenguaje
                cargaMultilenguaje();
                #endregion
                #region Carga Lista de Valores
                //cargaDdlComuna();
                #endregion
                #region Carga Datos
                if (_gsModo == "M" || _gsModo == "CE")
                {
                    var loDbnDefiMone = this._goDbnDefiMoneController.readDbnDefiMone("S", 0, 0, null,  _gsCodiMone, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                    this.txtCodiMone.Text = loDbnDefiMone.CODI_MONE;
                    this.txtNombMone.Text = loDbnDefiMone.NOMB_MONE;
                    Helper.ddlSelecciona(ddlCodiPais, loDbnDefiMone.CODI_PAIS);
                    this.txtRounMone.Text = loDbnDefiMone.ROUN_MONE.ToString();
                    this.txtCodiMone.Enabled = false;
                }
                #endregion
            }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
    }
 
    private void cargaMultilenguaje()
    {
        this.lblTitulo.Text = multilenguaje_base.L_TITU_DBN_CONF_DEFI_MONE;
        this.lblCodiMone.Text = multilenguaje_base.CODI_MONE;this.lblNombMone.Text = multilenguaje_base.NOMB_MONE;
        this.lblCodiPais.Text = multilenguaje_base.CODI_PAIS;
        this.lblRounMone.Text = multilenguaje_base.ROUN_MONE;
    }
    private void CargaPais()
    {
        ListaValoresControllers loListaValores = new ListaValoresControllers();
        var loResultado = loListaValores.readPais("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlCodiPais, loResultado);
    }
 
    private void limpiarTxt()
    {
        this.txtCodiMone.Text = string.Empty;
        this.txtNombMone.Text = string.Empty;
        this.txtRounMone.Text = string.Empty;
    }
 
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        _goDbnDefiMoneBE = new DbnDefiMoneBE();
        _goDbnDefiMoneBE.CODI_MONE = this.txtCodiMone.Text;
        _goDbnDefiMoneBE.NOMB_MONE = this.txtNombMone.Text;
        _goDbnDefiMoneBE.CODI_PAIS = this.ddlCodiPais.SelectedValue;
        _goDbnDefiMoneBE.ROUN_MONE = Convert.ToInt32(this.txtRounMone.Text);
 
        if (_gsModo == "CI" )
        { this._goDbnDefiMoneController.createDbnDefiMone(_goDbnDefiMoneBE); }
        else if (_gsModo == "M" || _gsModo == "CE" )
        { this._goDbnDefiMoneController.updateDbnDefiMone(_goDbnDefiMoneBE); }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        if (this.txtCodiMone.Text.Length > 0)
        {
            _goDbnDefiMoneController.deleteDbnDefiMone(this.txtCodiMone.Text);
        }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("CODI_MONE");
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=" + Session["tsListado"].ToString() + "&MODO=" + Session["P_MODO_REPO"].ToString(), true);
    }
}