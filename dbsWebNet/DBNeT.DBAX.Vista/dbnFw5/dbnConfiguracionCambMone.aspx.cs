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
 
public partial class dbnConfiguracionCambMone : System.Web.UI.Page 
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
    public void GuardaSessionWeb()
    { 
        Session["sessionWeb"] = _goSessionWeb;
    }
    private void ddlSelecciona(DropDownList ddl, string codigo)
    {
        int d = 0;
        if (codigo.Trim().Length > 0)
        {
            foreach (ListItem item in ddl.Items)
            {
                if (item.Value == codigo)
                {
                    ddl.SelectedIndex = d;break;
                }
                else
                {
                    d++;
                }
            }
        }
    }
    #endregion
 
    #region Parametros
    string _gsCodiMone;
    string _gs_codi_mone = string.Empty, _gsCodiMone1 = string.Empty, _gsFechCamo = string.Empty;
    #endregion
 
    DbnCambMoneBE _goDbnCambMoneBE;
    DbnCambMoneController _goDbnCambMoneController;
 
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _goListaValores = new ListaValoresControllers();
        _goDbnCambMoneController = new DbnCambMoneController();
 
        try
        {
            #region Rescatar Modo (Ingreso o Mantencion)
            if (Session["BTN_AGRE_MODO"] != null)
            { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
            else
            { _gsModo = Session["P_MODO_REPO"].ToString(); }
            #endregion

            if (Session["CODI_MONE"] != null && Session["CODI_MONE1"] != null && Session["FECH_CAMO"] != null)
            { _gsCodiMone = Session["CODI_MONE"].ToString(); _gsCodiMone1 = Session["CODI_MONE1"].ToString(); _gsFechCamo = Session["FECH_CAMO"].ToString(); }
            if (!IsPostBack)
            {
                #region Carga Multilenguaje
                cargaMultilenguaje();
                #endregion
                #region Carga Lista de Valores
                CargaDdl();
                #endregion
                #region Carga Datos
                if (_gsModo == "M" || _gsModo == "CE")
                {
                    var loDbnCambMone = this._goDbnCambMoneController.readDbnCambMone("S", 0, 0, null, _gsCodiMone, _gsCodiMone1,_gsFechCamo.ToString(), null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                    Helper.ddlSelecciona(ddlCodiMone, loDbnCambMone.CODI_MONE);
                    Helper.ddlSelecciona(ddlCodiMone1, loDbnCambMone.CODI_MONE1);
                    this.txtFechCamo.Text = loDbnCambMone.FECH_CAMO.ToString();
                    this.txtValoCamo.Text = loDbnCambMone.VALO_CAMO.ToString();
                    this.ddlCodiMone.Enabled = false;
                    this.ddlCodiMone1.Enabled = false;
                    this.txtFechCamo.Enabled = false;
                }
                #endregion
            }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
    }
 
    private void cargaMultilenguaje()
    {
        this.lblTitulo.Text = multilenguaje_base.L_TITU_DBN_CONF_CAMB_MONE;
        this.lblCodiMone.Text = multilenguaje_base.CODI_MONE;
        this.lblCodiMone1.Text = multilenguaje_base.CODI_MONE1;
        this.lblFechCamo.Text = multilenguaje_base.FECH_CAMO;
        this.lblValoCamo.Text = multilenguaje_base.VALO_CAMO;
        //this.lblCodiEmex.Text = multilenguaje_base.CODI_EMEX;
    }
    private void limpiarTxt()
    {
        this.txtFechCamo.Text = string.Empty;
        this.txtValoCamo.Text = string.Empty;
    }
    private void CargaDdl()
    {
        DbnDefiMoneController loDefiMone = new DbnDefiMoneController();
        var lores = loDefiMone.readDbnDefiMoneDt("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlCodiMone, lores);
        Helper.ddlCarga(ddlCodiMone1, lores);
        ListaValoresControllers loLista = new ListaValoresControllers();
        //var loResultado = loLista.readEmprExte("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        //Helper.ddlCarga(ddlCodiEmex, loResultado);
    }
 
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        _goDbnCambMoneBE = new DbnCambMoneBE();
        _goDbnCambMoneBE.CODI_MONE = this.ddlCodiMone.SelectedValue;
        _goDbnCambMoneBE.CODI_MONE1 = this.ddlCodiMone1.SelectedValue;
        
        _goDbnCambMoneBE.FECH_CAMO = Convert.ToDateTime(this.txtFechCamo.Text);
        _goDbnCambMoneBE.VALO_CAMO = Convert.ToDecimal(this.txtValoCamo.Text);
        _goDbnCambMoneBE.CODI_EMEX = _goSessionWeb.CODI_EMEX;
 
        if (_gsModo == "CI" )
        { this._goDbnCambMoneController.createDbnCambMone(_goDbnCambMoneBE); }
        else if (_gsModo == "M" )
        { this._goDbnCambMoneController.updateDbnCambMone(_goDbnCambMoneBE); }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        if (this.ddlCodiMone.SelectedIndex > 0)
        {
            _goDbnCambMoneController.deleteDbnCambMone(this.ddlCodiMone.SelectedValue, this.ddlCodiMone1.SelectedValue,Convert.ToDateTime(this.txtFechCamo.Text));
        }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("CODI_MONE");
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=" + Session["tsListado"].ToString() + "&MODO=" + Session["P_MODO_REPO"].ToString(), true);
    }
}