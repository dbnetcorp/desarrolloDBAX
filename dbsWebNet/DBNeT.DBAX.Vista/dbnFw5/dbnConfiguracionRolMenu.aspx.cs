using System;
using System.Data;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Resources;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;

public partial class dbnConfiguracionRolMenu : System.Web.UI.Page
{
    #region DBNeTFW5 - General
    /// <summary>
    /// Variables y metodos generales
    /// </summary>

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

    ListaValoresControllers _goListaValoresController;
    SysRousController _goSysRousController;
    public string _gsElMenu = "";
    MenuController _goMenuController;

    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        this.CargaMultilenguaje();
        this.lblError.Text = "";
        if (!IsPostBack)
        {
            if (Session["BTN_AGRE_MODO"] != null)
                _gsModo = Session["BTN_AGRE_MODO"].ToString();
            else if (Session["P_MODO_REPO"] != null)
                _gsModo = Session["P_MODO_REPO"].ToString();
            else
                _gsModo = "M";
            CargaDdlModulo();
            CargaDdlRoles();
        }
    }
    public void CargaMultilenguaje()
    {
        this.lblTitulo.Text = multilenguaje_base.L_TITU_ROL_MENU;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
    }
    
    private void CargaDdlModulo()
    {
        _goListaValoresController = new ListaValoresControllers();
        var loResultado1 = _goListaValoresController.readSysModule("LV", 0, 0, "", null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        ddlModulo.DataSource = loResultado1;
        ddlModulo.DataValueField = "Codigo";
        ddlModulo.DataTextField = "Valor";
        ddlModulo.DataBind();
    }

    private void CargaDdlRoles()
    {
        _goListaValoresController = new ListaValoresControllers();
        var loResultado2 = _goListaValoresController.readSysRous("LVA", 0, 0, "", ddlModulo.SelectedValue, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        ddlRol.DataSource = loResultado2;
        ddlRol.DataValueField = "Codigo";
        ddlRol.DataTextField = "Valor";
        ddlRol.DataBind();
    }

    private void FormaMenu()
    {
        _goSysRousController = new SysRousController();
        var loResultado = _goSysRousController.readRousMenu(_goSessionWeb.CODI_MODU, this.ddlRol.SelectedValue);
        _gsElMenu = "<table border='0'  cellspacing='0'  style='border-collapse:collapse;'>";
        for (int i = 0; i < loResultado.Rows.Count; i++)
        {
            DataRow dr = loResultado.Rows[i];
            string espacio = "";

            if (dr["object_level"].ToString() != "")
            {
                for (int x = 0; x < Convert.ToInt32(dr["object_level"].ToString()); x++)
                    espacio += "&nbsp;&nbsp;&nbsp;";
                _gsElMenu += "<tr><td>" + espacio + "<input id='rolmn[]' name='rolmn[]' type='checkbox' class='dbnLov' value='" + dr["object_name"].ToString() + "' " + (dr["comp"].ToString() != "0" ? "checked" : "") + ">&nbsp;<span class='" + (dr["object_type"].ToString() == "M" ? "dbnLabel" : "dbnTexto") + "'>" + dr["object_brief"].ToString() + "</span></td></tr>";
            }
        }
        _gsElMenu += "</table>"; 
    }

    protected void ddlRol_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.FormaMenu();
    }
    protected void ddlModulo_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.CargaDdlRoles();
        try
        {
            this.ddlRol.SelectedIndex = 0;
            this.FormaMenu();
        }
        catch { }
    }
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            _goMenuController = new MenuController();
            _goMenuController.deleteSysFuro(_goSessionWeb.CODI_MODU, this.ddlRol.SelectedValue);
            _goMenuController.deleteSysRelation(_goSessionWeb.CODI_MODU, this.ddlRol.SelectedValue);
            string lsNombMenu = string.Empty;
            if (txtMenu.Value != "")
            {
                string[] campos = txtMenu.Value.Split('|');
                for (int x = 0; x < campos.Length - 1; x++)
                {
                    lsNombMenu = campos[x].ToString();
                    _goMenuController.createSysFuro(this.ddlRol.SelectedValue, _goSessionWeb.CODI_MODU, lsNombMenu);
                    _goMenuController.createSysRelation(this.ddlRol.SelectedValue, _goSessionWeb.CODI_MODU, lsNombMenu);
                }
            }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }        
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Response.Redirect("~/dbnFw5/dbnIndex.aspx",true);
    }
}