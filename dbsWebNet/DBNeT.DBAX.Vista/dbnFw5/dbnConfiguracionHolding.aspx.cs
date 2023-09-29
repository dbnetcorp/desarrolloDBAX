using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Resources;
using DBNeT.Base.Modelo;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Controlador;

public partial class dbnConfiguracionHolding : System.Web.UI.Page
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
    EmprExteController _goEmprExteController;
    string _gsCODI_EMEX = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            _goEmprExteController = new EmprExteController();
            this.RecuperaSessionWeb();
            Multilenguaje();

            if (Session["BTN_AGRE_MODO"] != null)
                _gsModo = Session["BTN_AGRE_MODO"].ToString();
            else if (Session["P_MODO_REPO"] != null)
                _gsModo = Session["P_MODO_REPO"].ToString();
            else
                _gsModo = "CI";

            if (Session["CODI_EMEX"] != null)
                _gsCODI_EMEX = Session["CODI_EMEX"].ToString();

            if (!IsPostBack)
            {
                if (_gsCODI_EMEX != null && _gsModo == "M")
                {
                    var resultado = _goEmprExteController.readEmprExte("S", 0, 0, null, _gsCODI_EMEX, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                    Session["oHolding"] = resultado;
                    this.txtCodigoEmex.Text = resultado.CODI_EMEX;
                    this.txtNombEmex.Text = resultado.NOMB_EMEX;
                    this.txtCodigoEmex.Enabled = false;
                }
            }
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
    }

    private void Multilenguaje()
    {
        this.lblTitulo.Text = multilenguaje_base.L_TITU_HOLDING;
        this.lblCodigo.Text = multilenguaje_base.CODI_EMEX;
        this.lblDescripcion.Text = multilenguaje_base.NOMB_EMEX;
        this.lblCodigoDBSoft.Text = multilenguaje_base.CODI_DBSOFT;
        this.lblContratoDBSoft.Text = multilenguaje_base.CONT_DBSOFT;
    }
    private void Limpiar()
    {
        this.txtCodigoEmex.Text = string.Empty;
        this.txtNombEmex.Text = string.Empty;
    }
    private void ValidaFormulario()
    {
        this.lblError.Text = string.Empty;
        this.lblError.Text = "ERROR<br/>";
        this.lblError.Text += "<img src=\"../librerias/img/imgWarn.png\" border=\"0\" class=\"dbnEstado\" /> <br/>";
        int x = 0;
        if (this.txtCodigoEmex.Text.Trim().Length > 0)
        { }
        else
        { x++; this.lblError.Text += "Debe ingresar un código <br/>"; }

        if (this.txtNombEmex.Text.Trim().Length > 0)
        { }
        else
        { x++; this.lblError.Text += "Debe ingresar un nombre<br/>"; }

        if (x > 0)
        { lblError.Visible = true; }
        else
        { lblError.Text = string.Empty; }
    }
    
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            this.ValidaFormulario();
            if (this.lblError.Text.Trim().Length == 0)
            {
                EmprExteBE loEmprExteBE = new EmprExteBE();
                if (Session["oHolding"] != null)
                { loEmprExteBE = (EmprExteBE)Session["oHolding"]; }
                loEmprExteBE.CODI_EMEX = this.txtCodigoEmex.Text;
                loEmprExteBE.NOMB_EMEX = this.txtNombEmex.Text;
                loEmprExteBE.CODI_EMPR = this._goSessionWeb.CODI_EMPR;

                switch (_gsModo)
                {
                    case "CI":
                        _goEmprExteController.createEmprExte(loEmprExteBE);
                        break;
                    case "M":
                        _goEmprExteController.updateEmprExte(loEmprExteBE);
                        break;
                }
            }
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        this.ValidaFormulario();
        if (this.lblError.Text.Trim().Length == 0)
        {
            _goEmprExteController = new EmprExteController();
            _goEmprExteController.deleteEmprExte(this.txtCodigoEmex.Text);
        }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("CODI_EMEX"); 
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("oHolding");
        this.Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_EMPR_EXTE&MODO="+Session["P_MODO_REPO"].ToString(), true);
    }
}