using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Resources;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Modelo.DAC;
 
public partial class dbnConfiguracionParametroEmpresa : System.Web.UI.Page 
{
    #region Pagina Base 
    private string _gsModo = string.Empty;
    private SessionWeb _goSessionWeb;
    private ListaValoresControllers _goListaValores;

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
    #region Parametros
    string _gsTipoComo;
    string _gsCodiPaem;
    #endregion
 
    ParaEmprBE _goParaEmprBE;
    ParaEmprController _goParaEmprController;
 
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _goListaValores = new ListaValoresControllers();
        _goParaEmprController = new ParaEmprController();
        try
        {
            #region Rescatar Modo (Ingreso o Mantencion)
 
            if (Session["TIPO_COMO"] != null && Session["CODI_PAEM"] != null)
            {
                _gsTipoComo = Session["TIPO_COMO"].ToString();
    		    _gsCodiPaem = Session["CODI_PAEM"].ToString();
            }
            if (Session["BTN_AGRE_MODO"] != null)
            { _gsModo = Session["BTN_AGRE_MODO"].ToString(); }
            else
            { _gsModo = Session["P_MODO_REPO"].ToString(); }
 
            #endregion
            if (!IsPostBack)
            {
                #region Carga Multilenguaje
                cargaMultilenguaje();
                //CargaEmprExte();
                #endregion
                #region Carga Datos
                if (_gsModo == "M" || _gsModo == "CE")
                {
                    var loParaEmpr = this._goParaEmprController.readParaEmpr("S", 0, 0, null, _gsTipoComo ,_gsCodiPaem , null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                    Session["oParaEmpr"] = loParaEmpr;
                    this.txtCodiPaem.Text = loParaEmpr.CODI_PAEM;
                    this.txtTipoComo.Text = loParaEmpr.TIPO_COMO;
                    this.txtDescPaem.Text = loParaEmpr.DESC_PAEM;
                    this.txtValoPaem.Text = loParaEmpr.VALO_PAEM;
                    ValidaCkbObli(loParaEmpr.OBLI_PAEM);
                    this.txtCodiPaem.Enabled = false;
                    this.txtTipoComo.Enabled = false;
                }
                #endregion
            }
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
    }
    private void cargaMultilenguaje()
    {
        this.lblTitulo.Text = multilenguaje_base.ResourceManager.GetString("TIT_PARA_EMPR");
        if (this.lblTitulo.Text == "") this.lblTitulo.Text = "TIT_PARA_EMPR";
        this.lblCodiPaem.Text = multilenguaje_base.ResourceManager.GetString("CODI_PAEM");
        if (this.lblCodiPaem.Text == "") this.lblCodiPaem.Text = "CODI_PAEM";
        this.lblTipoComo.Text = multilenguaje_base.ResourceManager.GetString("TIPO_COMO");
        if (this.lblTipoComo.Text == "") this.lblTipoComo.Text = "TIPO_COMO";
        this.lblDescPaem.Text = multilenguaje_base.ResourceManager.GetString("DESC_PAEM");
        if (this.lblDescPaem.Text == "") this.lblDescPaem.Text = "DESC_PAEM";
        this.lblValoPaem.Text = multilenguaje_base.ResourceManager.GetString("VALO_PAEM");
        if (this.lblValoPaem.Text == "") this.lblValoPaem.Text = "VALO_PAEM";
        this.lblObliPaem.Text = multilenguaje_base.ResourceManager.GetString("OBLI_PAEM");
        if (this.lblObliPaem.Text == "") this.lblObliPaem.Text = "OBLI_PAEM";
        //this.lblCodiEmex.Text = multilenguaje_base.CODI_EMEX;

        /* Botones */
        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
        this.btnEliminar.ToolTip = multilenguaje_base.tt_btnEliminar;
    }

    //private void CargaEmprExte()
    //{
    //    _goListaValores = new ListaValoresControllers();
    //    var loEmprExte = _goListaValores.readEmprExte("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
    //    Helper.ddlCarga(ddlCodiEmex, loEmprExte);
    //}

    private void limpiarTxt()
    {
        this.txtCodiPaem.Text = string.Empty;
        this.txtTipoComo.Text = string.Empty;
        this.txtDescPaem.Text = string.Empty;
        this.txtValoPaem.Text = string.Empty;
        this.ckbObligatorio.Checked = false;
    }
    private void ValidaCkbObli(string tsValor)
    {
        if (tsValor == "S")
            this.ckbObligatorio.Checked = true;
        else
            this.ckbObligatorio.Checked = false;
    }
    private string ValidaCkb()
    {
        string lsObligatorio = string.Empty;
        if (ckbObligatorio.Checked)
        { lsObligatorio = "S"; }
        else
        { lsObligatorio = "N"; }
        return lsObligatorio;
    }
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            this.ValidaFormulario();
            if (this.lblError.Text.Trim().Length == 0)
            {
                _goParaEmprBE = new ParaEmprBE();
                if (Session["oParaEmpr"] != null)
                {_goParaEmprBE = (ParaEmprBE)Session["oParaEmpr"];} 
                _goParaEmprBE.CODI_EMPR = _goSessionWeb.CODI_EMPR;
                _goParaEmprBE.CODI_PAEM = this.txtCodiPaem.Text;
                _goParaEmprBE.TIPO_COMO = this.txtTipoComo.Text;
                _goParaEmprBE.DESC_PAEM = this.txtDescPaem.Text;
                _goParaEmprBE.VALO_PAEM = this.txtValoPaem.Text;
                _goParaEmprBE.OBLI_PAEM = ValidaCkb();
                _goParaEmprBE.CODI_EMEX = _goSessionWeb.CODI_EMEX;

                if (_gsModo == "CI")
                { this._goParaEmprController.createParaEmpr(_goParaEmprBE); }
                else if (_gsModo == "M" || _gsModo == "CE")
                { this._goParaEmprController.updateParaEmpr(_goParaEmprBE); }
            }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnEliminar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            if (this.txtCodiPaem.Text.Length > 0)
            {
                _goParaEmprController.deleteParaEmpr(_goSessionWeb.CODI_EMPR, this.txtTipoComo.Text, this.txtCodiPaem.Text,_goSessionWeb.CODI_EMEX);
            }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("CODI_EMPR");
        Session.Remove("TIPO_COMO");
        Session.Remove("CODI_PAEM");
        Session.Remove("oSysParam");
        this.limpiarTxt();
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=" + Session["tsListado"].ToString() + "&MODO=" + Session["P_MODO_REPO"].ToString(), true);
    }

    private void ValidaFormulario()
    {
        this.lblError.Text = string.Empty;
        this.lblError.Text = "ERROR :<br/>";
        this.lblError.Text += "<img src=\"../librerias/img/imgWarn.png\" border=\"0\" class=\"dbnEstado\" /> <br/>";
        int x = 0;
        if (this.txtCodiPaem.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Codigo Empresa : Se debe Ingresar un código de Usuario <br/>"; }
        if (this.txtDescPaem.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Descripcion : Se debe ingresar un Nombre a este usuario <br/>"; }
        if (this.txtTipoComo.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Tipo Como: Se debe ingresar una fecha de inicio para el Usuario <br/>"; }
        if (this.txtValoPaem.Text.Trim().Length > 0)
        { }
        else
        { x++; lblError.Text += "Valor Parametro: Se Debe Ingresar una fecha de termino para el Usuario <br/>"; }
        
        if (x > 0)
        { lblError.Visible = true; }
        else
        { lblError.Text = string.Empty; }
    }
}