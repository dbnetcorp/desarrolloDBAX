using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Resources;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.DBAX.Modelo.BE;
using DBNeT.Base.Controlador;

public partial class DBAX_dbax_mant_defi_segm : System.Web.UI.Page
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
    DbaxDefiSegmController _goDefiSegmController;
    DecodificaUnicode _goDecoUni;
    string _gsCodiSegm = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        _goDefiSegmController = new DbaxDefiSegmController();
        _goDecoUni = new DecodificaUnicode();
        this.lblError.Text = string.Empty;
        this.RecuperaSessionWeb();
        this.Multilenguaje();

        if (Session["codi_segm"] != null)
        { _gsCodiSegm = _goDecoUni.DecodeUnicode(Session["CODI_SEGM"].ToString()); }

        if (Session["BTN_AGRE_MODO"] != null)
        { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
        else
        { _gsModo = Session["P_MODO_REPO"].ToString(); }
        
        if (!IsPostBack)
        {
            switch (_gsModo)
            {
                case "CI":
                    break;
                case "M":
                    this.txtCodiSegm.Enabled = false;
                    var loDefiSegm = _goDefiSegmController.readDbaxDefiSegm("S", 0, 0, null, _gsCodiSegm, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                    this.txtCodiSegm.Text = loDefiSegm.CODI_SEGM;
                    this.txtDescSegm.Text = loDefiSegm.DESC_SEGM;
                    break;
            }
        }
    }
    private void Multilenguaje()
    {
        lblTitulo.Text = multilenguaje.TITU_DBAX_MANT_DEFI_SEGM;
        lblCodiSegm.Text = multilenguaje.lblCodiSegm;
        lblDescSegm.Text = multilenguaje.lblDescSegm;
    }

    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            DbaxDefiSegmBE loDefiSegmBE = new DbaxDefiSegmBE();
            loDefiSegmBE.CODI_SEGM = this.txtCodiSegm.Text;
            loDefiSegmBE.DESC_SEGM = this.txtDescSegm.Text;
            switch (_gsModo)
            {
                case "CI":
                        _goDefiSegmController.createDbaxDefiSegm(loDefiSegmBE);
                    break;
                case "M":
                    _goDefiSegmController.updateDbaxDefiSegm(loDefiSegmBE);
                    break;
            }

        }
        catch (Exception)
        { lblError.Text += "No se puede ingresar un Segmento Duplicado"; }
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            switch (_gsModo)
            {
                case "M":
                    _goDefiSegmController.deleteDbaxDefiSegm(this.txtCodiSegm.Text);
                    break;
            }
        }
        catch (Exception ex)
        { throw ex; }
        finally
        { btnVolver_Click(null, null); }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("codi_segm");
        this.Response.Redirect("~/dbnfw5/dbnFw5Listador.aspx?listado=L_DBAX_DEFI_SEGM&MODO=" + Session["P_MODO_REPO"]);
    }
}