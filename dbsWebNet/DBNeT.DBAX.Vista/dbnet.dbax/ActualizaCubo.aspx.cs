using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DbnetWebLibrary;
using DBNeT.Base.Modelo;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Controlador;
using System.Data;

public partial class dbax_ActualizaCubo : System.Web.UI.Page
{
    private string _gsModo = string.Empty;
    private SessionWeb _goSessionWeb;
    CalculoMonedaController _goCalcMoneController;
    MantencionCubo _goMantCuboController;
    dbax_dbne_procController _goActualizaCubo;
    private void RecuperaSessionWeb()
    {
        if (Session["sessionWeb"] == null)
        { Response.Redirect("~/dbnFw5/dbnLogin.aspx"); }
        else
        { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
    }
    public void GuardaSessionWeb()
    { Session["sessionWeb"] = _goSessionWeb; }

    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dtProcCubo;
        this.Multilenguaje();
        this.RecuperaSessionWeb();
        _goCalcMoneController = new CalculoMonedaController();
        _goMantCuboController = new MantencionCubo();
        this.lblError.Text = string.Empty;
        if (!IsPostBack)
        {
            DataTable dtCorrInst = _goCalcMoneController.getPersCorrInst("");
            Helper.ddlCarga(ddlCorrInst, dtCorrInst, "desc_inst", "corr_inst");
        }
        dtProcCubo = _goMantCuboController.getProcEsta("dbax.ActualizaCubo.exe");
        if (dtProcCubo.Rows.Count > 0)
        {
            if (dtProcCubo.Rows[0]["esta_proc"].ToString() == "P")
            {
                lblError.Text = "La actualización del cubo se encuentra pendiende";
            }
            else if (dtProcCubo.Rows[0]["esta_proc"].ToString() == "I")
            {
                lblError.Text = "La actualización del cubo generada con fecha:" + dtProcCubo.Rows[0]["fech_crea"].ToString() + " se encuentra en proceso";
            }
            else if (dtProcCubo.Rows[0]["esta_proc"].ToString() == "T")
            {
                lblError.Text = "La actualización del cubo generada con fecha:" + dtProcCubo.Rows[0]["fech_crea"].ToString() + " finalizó con éxito";
            }
            else if (dtProcCubo.Rows[0]["esta_proc"].ToString() == "E")
            {
                lblError.Text = "La actualización del cubo generada con fecha:" + dtProcCubo.Rows[0]["fech_crea"].ToString() + " finalizó con errores";
            }
            else
                lblError.Text = "";
        }
        else
            lblError.Text = "";
       
    }
    private void Multilenguaje()
    {
        this.lblTitulo.Text = "Actualización del Cubo";
        this.lblCorrInst.Text = "Correlativo de Período";
        this.lblTipoActu.Text = "Actualizar";
    }
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        SysParamController _loSysaParam = new SysParamController();
        var lsRutaBinario = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_XBRL_BINA", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        try
        {
            _goActualizaCubo = new dbax_dbne_procController();

            string rutaArchivo = lsRutaBinario.PARAM_VALUE + "\\dbax.ActualizaCubo.exe";
            if (rbTipoActu.SelectedValue.Equals("T"))
            {
                _goActualizaCubo.prc_create_dbne_proc(rutaArchivo, ddlCorrInst.SelectedValue, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX, "1 T");
            }
            _goActualizaCubo.prc_create_dbne_proc(rutaArchivo,ddlCorrInst.SelectedValue, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX,ddlCorrInst.SelectedValue + " P");
        }
        catch (Exception ex)
        { lblError.Text += ex.Message; }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_LIST_INDI&MODO=M", true);
    }


    protected void rbTipoActu_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbTipoActu.SelectedValue.Equals("T"))
        {
            lblCorrInst.Visible = false;
            lblTipoActu.Visible = false;
        }
        else
        {
            lblCorrInst.Visible = true;
            lblTipoActu.Visible = true;
        }
    }
}