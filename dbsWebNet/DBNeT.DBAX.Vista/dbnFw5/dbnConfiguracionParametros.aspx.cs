using System;
using System.Data;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;
using Resources;

public partial class dbnParametros : System.Web.UI.Page
{
    string _gsModo;
    string _gsParamName = string.Empty;
    SysParamController _gsSysParam = new SysParamController();
    SysParamBE parametrosBE;
    SessionWeb _goSessionWeb;
    #region SessionWeb
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
    protected void Page_Load(object sender, EventArgs e)
    {
        RecuperaSessionWeb();
        this.CargaMultilenguaje();
	    #region Rescatar Modo (Ingreso o Mantención)

	    if (Session["PARAM_NAME"] != null)
	    {
		    _gsParamName = Session["PARAM_NAME"].ToString();
        }
        if (Session["BTN_AGRE_MODO"] != null)
            _gsModo = Session["BTN_AGRE_MODO"].ToString();
        else
            _gsModo = Session["P_MODO_REPO"].ToString();

	    #endregion
        #region IsPosBack
        if (!IsPostBack)
        {
            if (_gsModo == "M")
            {
                var listaSysParam = _gsSysParam.readParametro("S", 0, 0, null, _gsParamName, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                Session["oSysParam"] = listaSysParam;
                try
                {
                    this.txtParam_name.Text = listaSysParam.PARAM_NAME;
                    this.txtParam_desc.Text = listaSysParam.PARAM_DESC;
                    this.txtParam_value.Text = listaSysParam.PARAM_VALUE;
                    this.txtParam_name.Enabled = false;
                }
                catch (Exception es)
                {throw es;}
            }
            else {this.limpar();}
        }
        #endregion
    }
    /// <summary>
    /// Metodo para la carga de los MultiLenguajes
    /// </summary>
    public void CargaMultilenguaje()
    {
        this.Title = multilenguaje_base.L_TITU_SYS_PARAM;
        this.lblTitulo.Text = multilenguaje_base.L_TITU_SYS_PARAM;
        this.lblParamName.Text = multilenguaje_base.lblParamName;
        this.lblDescripcion.Text = multilenguaje_base.lblParamDesc;
        this.lblValor.Text = multilenguaje_base.lblParamValue;

        /* Botones */
        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
        this.btnEliminar.ToolTip = multilenguaje_base.tt_btnEliminar;
    }
    private void limpar()
    {
        this.txtParam_name.Text = string.Empty;
        this.txtParam_value.Text = string.Empty;
        this.txtParam_desc.Text = string.Empty;
    }
    protected void btnActualizar_Click(object sender, EventArgs e)
    {
        try
        {
            this.ValidaFormulario();
            if (this.lblError.Text.Trim().Length == 0)
            {
                if (this.txtParam_name.Text.Trim().Length >= 1)
                {
                    parametrosBE = new SysParamBE();
                    if (Session["oSysParam"] != null)
                    { parametrosBE = (SysParamBE)Session["oSysParam"]; }
                    parametrosBE.PARAM_NAME = this.txtParam_name.Text;
                    parametrosBE.PARAM_VALUE = this.txtParam_value.Text;
                    parametrosBE.PARAM_DESC = this.txtParam_desc.Text;

                    if (_gsParamName.Length == 0)
                    {
                        _gsSysParam.createParametros(parametrosBE);
                        this.limpar();
                    }
                    else if (_gsParamName.Trim().Length >= 1)
                    {
                        _gsSysParam.updateParametros(parametrosBE);
                        this.limpar();
                    }
                }
            }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnEliminar_Click(object sender, EventArgs e)
    {
        try
        {
            if (this.txtParam_name.Text != null)
                _gsSysParam.deleteParametros(this.txtParam_name.Text);
            this.limpar();
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
        if (this.lblError.Text.Length == 0)
            btnVolver_Click(null, null);
    }
    protected void btnVolver_Click(object sender, EventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("PARAM_NAME");
        Session.Remove("oSysParam");
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=" + Session["tsListado"].ToString() + "&MODO=" + Session["P_MODO_REPO"].ToString(), true);
    }

    private void ValidaFormulario()
    {
        this.lblError.Text = string.Empty;
        this.lblError.Text = "ERROR<br/>";
        this.lblError.Text += "<img src=\"../librerias/img/imgWarn.png\" border=\"0\" class=\"dbnEstado\" /> <br/>";
        int x = 0;
        if (this.txtParam_value.Text.Trim().Length > 0)
        { }
        else
        { x++; this.lblError.Text += "Valor Parametro: Se debe Ingresar un valor <br/>"; }
        if (this.txtParam_name.Text.Trim().Length > 0)
        { }
        else
        { x++; this.lblError.Text += "Nombre Parametro: Se debe Ingresar un Nombre<br/>"; }
        if (this.txtParam_desc.Text.Trim().Length > 0)
        { }
        else
        { x++; this.lblError.Text += "Descripción Parametro: Se debe Ingresar una descripción<br/>"; }

        if (x > 0)
        { lblError.Visible = true; }
        else
        { lblError.Text = string.Empty; }
    }
}