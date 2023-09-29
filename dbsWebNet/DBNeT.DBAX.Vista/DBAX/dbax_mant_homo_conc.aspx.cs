using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Modelo;
using Resources;
using DBNeT.DBAX.Modelo.BE;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Controlador;

public partial class DBAX_dbax_homo_conc : System.Web.UI.Page
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
    string _gsCodiHoco = string.Empty;
    DbaxHomoConcController _goDbaxHomoConcController;
    ListaValoresController _goListaValoresController;
    DbaxTipoTaxoController _goDbaxTipoTaxoController;
    DbaxTaxoVersController _goDbaxTaxoVersController;
    protected void Page_Load(object sender, EventArgs e)
    {
        _goDbaxHomoConcController = new DbaxHomoConcController();
        this.RecuperaSessionWeb();
        this.lblError.Text = string.Empty;
        this.Multilenguaje();
        if (Session["BTN_AGRE_MODO"] != null)
        { 
            _gsModo = Session["BTN_AGRE_MODO"].ToString(); 
        }
        else
        {
            _gsModo = Session["P_MODO_REPO"].ToString(); 
        }
        if (Session["CODI_HOCO"] != null)
        {
            _gsCodiHoco = Session["CODI_HOCO"].ToString(); 
        }
        if (!IsPostBack)
        {
            switch (_gsModo)
            {
                case "CI":
                    //this.ddlPrefTaxo.Enabled = false;
                    this.ddlVersTaxo.Enabled = false;
                    this.ddlVersTaxoDest.Enabled = false;
                    CargaTipoTaxo();
                    break;
                case "M":
                    var loHomoConc = _goDbaxHomoConcController.readDbaxHomoConc("S", 0, 0, null, _gsCodiHoco, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                    Session["oHomoConc"] = loHomoConc;
                    CargaTipoTaxo();
                    Helper.ddlSelecciona(ddlTipoTaxo, loHomoConc.TIPO_TAXO);
                    ddlTipoTaxo_SelectedIndexChanged(null, null);
                    //CargaPrefTaxo();
                    //Helper.ddlSelecciona(ddlPrefTaxo, loHomoConc.PREF_CONC);
                    //ddlPrefConc_SelectedIndexChanged(null, null);
                    //CargaVersTaxo();
                    Helper.ddlSelecciona(ddlVersTaxo, loHomoConc.VERS_TAXO);
                    Helper.ddlSelecciona(ddlVersTaxoDest, loHomoConc.VERS_TAXO_DEST);
                    break;
            }
        }
    }
    private void Multilenguaje()
    {
        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
        this.btnEliminar.ToolTip = multilenguaje_base.tt_btnEliminar;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
        this.lblTitulo.Text = multilenguaje.TITU_DBAX_MANT_HOMO_CONC;
        //this.lblPrefTaxo.Text = multilenguaje.lblPrefTaxo;
        this.lblTipoTaxo.Text = multilenguaje.lblTipoTaxo;
        this.lblVersTaxo.Text = multilenguaje.lblVersTaxoOrig;
        this.lblVersTaxoDest.Text = multilenguaje.lblVersTaxoDest;
    }
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            DbaxHomoConcBE loHomoConcBE;

            if (Session["oHomoConc"] != null)
            { loHomoConcBE = (DbaxHomoConcBE)Session["oHomoConc"]; }
            else
            { loHomoConcBE = new DbaxHomoConcBE(); }
            //loHomoConcBE.PREF_CONC = this.ddlPrefTaxo.SelectedValue;
            loHomoConcBE.TIPO_TAXO = this.ddlTipoTaxo.SelectedValue;
            loHomoConcBE.VERS_TAXO = this.ddlVersTaxo.SelectedValue;
            loHomoConcBE.VERS_TAXO_DEST = this.ddlVersTaxoDest.SelectedValue;
            switch (_gsModo)
            {
                case "CI":
                    _goDbaxHomoConcController.createDbaxHomoConc(loHomoConcBE);
                    break;
                case "M":
                    _goDbaxHomoConcController.updateDbaxHomoConc(loHomoConcBE);
                    break;
            }
        }
        catch (Exception ex)
        {
            this.lblError.Text += ex.Message;
        }
        finally
        {
            btnVolver_Click(null, null);
        }
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            DbaxHomoConcBE loHomoConc = (DbaxHomoConcBE)Session["oHomoConc"];
            _goDbaxHomoConcController.deleteDbaxHomoConc(loHomoConc.CODI_HOCO);
        }
        catch (Exception ex)
        { lblError.Text += ex.Message; }
        finally
        { btnVolver_Click(null, null); }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        this.Session.Remove("BTN_AGRE_MODO");
        this.Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_DBAX_HOMO_CONC&MODO=" + Session["P_MODO_REPO"].ToString());
    }
    private void CargaTipoTaxo()
    {
        _goDbaxTipoTaxoController = new DbaxTipoTaxoController();
        var loTipoTaxo = _goDbaxTipoTaxoController.readDbaxTipoTaxoDt("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        if (loTipoTaxo.Rows.Count > 0)
        { 
            Helper.ddlCarga(ddlTipoTaxo, loTipoTaxo); 
        }
        else
        { 
            //this.ddlPrefTaxo.Enabled = false; 
            this.ddlVersTaxo.Enabled = false; 
            this.ddlVersTaxoDest.Enabled = false; 
        }
        SysParamController _loSysaParam = new SysParamController();
        var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_DEFE_TAXO", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        //ddlTipoTaxo.SelectedValue = loResultado.PARAM_VALUE;
    }
    private void CargaVersTaxo()
    {
        this.ddlVersTaxo.Enabled = true;
        this.ddlVersTaxoDest.Enabled = true;
        _goDbaxTaxoVersController = new DbaxTaxoVersController();
        var loVersTaxo = _goDbaxTaxoVersController.readDbaxTaxoVersDt("LV", 0, 0, null, this.ddlTipoTaxo.SelectedValue);
        if (loVersTaxo.Rows.Count > 1)
        {
            this.ddlVersTaxo.Enabled = true;
            this.ddlVersTaxoDest.Enabled = true;
            Helper.ddlCarga(ddlVersTaxo, loVersTaxo);
            Helper.ddlCarga(ddlVersTaxoDest, loVersTaxo);
        }
        else
        {
            this.ddlVersTaxo.Enabled = false;
            this.ddlVersTaxoDest.Enabled = false;
        }
    }
    protected void ddlTipoTaxo_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.ddlVersTaxo.Items.Clear();
        this.ddlVersTaxoDest.Items.Clear();
        this.ddlVersTaxo.Enabled = false;
        this.ddlVersTaxoDest.Enabled = false;
        CargaVersTaxo();
    }
    protected void btnEjecutar_Click(object sender, ImageClickEventArgs e)
    {
        MantencionParametros para = new MantencionParametros();
        try
        {
            para.SP_AX_insEstadoBarra("OK", "Proceso de homologación iniciado", "N", _goSessionWeb.CODI_USUA);
            DbaxHomoConcBE loHomoConcBE = null;
            if (Session["oHomoConc"] != null)
            { loHomoConcBE = (DbaxHomoConcBE)Session["oHomoConc"]; }

            string lsTipoTaxo = loHomoConcBE.TIPO_TAXO;
            string lsPrefConc = loHomoConcBE.PREF_CONC;
            DateTime ldFeinConc = (DateTime)loHomoConcBE.FECH_HOCO;
            _goDbaxHomoConcController.ejecutarHomologacion(lsTipoTaxo, lsPrefConc, ldFeinConc);
            para.SP_AX_insEstadoBarra("OK", "Proceso de homologación finalizado", "S", _goSessionWeb.CODI_USUA);
        }
        catch (Exception)
        { }
    }
}