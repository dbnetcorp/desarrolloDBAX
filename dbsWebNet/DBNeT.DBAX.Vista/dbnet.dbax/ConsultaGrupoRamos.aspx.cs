using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Modelo;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Controlador;

public partial class ConsultaGrupoRamos : System.Web.UI.Page
{
    #region Pagina Base
    private string _gsModo = string.Empty;
    private SessionWeb _goSessionWeb;

    private void RecuperaSessionWeb()
    {
        if (Session["sessionWeb"] == null)
        { Response.Redirect("~/dbnFw5/dbnLogin.aspx"); }
        else
        { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
    }
    public void GuardaSessionWeb()
    { Session["sessionWeb"] = _goSessionWeb; }
    #endregion
    GeneracionExcel GenExcel = new GeneracionExcel();
    GrupoRamosController _goGrupoRamosController;

    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _goGrupoRamosController = new GrupoRamosController();
        this.lblError.Text = string.Empty;
        if (!IsPostBack)
        {
            this.lblError.Visible = false;
            CargaSegmento();
            CargaPeriodos();
            CargaCuadro();
            CargaDimension();
            CargaConcepto();
            CargaMoneda();
        }
    }
    
    protected void CargaSegmento()
    {
        DataTable dt = this._goGrupoRamosController.getSegmentos();
        if (dt.Rows.Count > 0)
        { Helper.ddlCarga(ddlSegmentos, dt, "desc_segm", "codi_segm"); }
    }
    protected void CargaCuadro()
    {
        DataTable dt = this._goGrupoRamosController.getCuadros();
        if (dt.Rows.Count > 0)
        { Helper.ddlCarga(ddlCuadros, dt, "desc_info", "codi_dein"); }
    }
    protected void CargaDimension()
    {
        DataTable dt = this._goGrupoRamosController.getDimension(this.ddlCuadros.SelectedValue);
        if (dt.Rows.Count > 0)
        { Helper.ddlCarga(ddlDimension, dt, "codi_dime", "desc_dime"); }
    }
    protected void CargaConcepto()
    {
        DataTable dt = this._goGrupoRamosController.getConceptos(this.ddlCuadros.SelectedValue, this.ddlDimension.SelectedValue);
        if (dt.Rows.Count > 0)
        { Helper.ddlCarga(ddlConcepto, dt, "desc_conc", "codi_conc"); }
    }
    protected void CargaPeriodos()
    {
        DataTable dt = _goGrupoRamosController.getPeriodos("",0);
        Helper.ddlCarga(ddlPeriodos, dt, "desc_inst", "corr_inst");
    }
    protected void CargaMoneda()
    {
        ParaEmprController _loParaEmpr = new ParaEmprController();
        DataTable dtParaEmpr = _loParaEmpr.readParaEmprDt("L", 1, 100, null, "mone", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        this.ddlMoneda.Items.Clear();
        foreach (DataRow item in dtParaEmpr.Rows)
        {
            this.ddlMoneda.Items.Add(new ListItem(item["desc_paem"].ToString() + " (" + item["valo_paem"].ToString() + ")", item["codi_paem"].ToString()));
        }
        this.ddlMoneda.DataBind();
        var loResu = _loParaEmpr.readParaEmpr("S", 0, 0, null, "ALL", "MONE_LOCA", null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlSelecciona(ddlMoneda, loResu.CODI_PAEM);
    }

    protected void guardarArchivo(object sender, ImageClickEventArgs e)
    {
        try
        {
            tb_html.Text = "<html><head><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" /></head><body>" + tb_html.Text + "</body></html>";
            Response.Clear();
            Response.ContentType = "application/excel";
            Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ddlCuadros.SelectedValue + ".xls");
            Response.Write(HttpUtility.UrlDecode(tb_html.Text, Encoding.GetEncoding("utf-8")));
            //Response.Flush();
            Response.End();
        }
        catch (Exception ex)
        {
            lblError.Visible = true;
            lblError.Text = ex.Message;
        }
    }
    protected void ddlDimension_SelectedIndexChanged(object sender, EventArgs e)
    {
        CargaConcepto();
    }
    protected void ddlCuadros_SelectedIndexChanged(object sender, EventArgs e)
    {
        CargaDimension();
        this.ddlConcepto.Items.Clear();
    }
    protected void btnProcesar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            MantencionParametros loPara = new MantencionParametros();
            string lsRuta = @loPara.getPathWebb() + @"\\librerias\sheets\" + ddlCuadros.SelectedValue + "_" + ddlConcepto.SelectedValue + "_" + ddlPeriodos.SelectedValue + "_"+ddlMoneda.SelectedValue+".html";
            string lsRuta2 = @"..\\librerias\\sheets\\" + ddlCuadros.SelectedValue + "_" + ddlConcepto.SelectedValue + "_" + ddlPeriodos.SelectedValue + "_" + ddlMoneda.SelectedValue + ".html";
            ruta_html.Text = lsRuta2;
            DataTable dtInformeRamosConcepto = this._goGrupoRamosController.getInformeRamosEmpresa(this.ddlSegmentos.SelectedValue, ddlConcepto.SelectedValue,ddlCuadros.SelectedValue,ddlDimension.SelectedValue, Convert.ToInt32(ddlPeriodos.SelectedValue),ddlMoneda.SelectedValue);
            this._goGrupoRamosController.generaHTML(lsRuta, dtInformeRamosConcepto);
        }
        catch (Exception ex)
        { this.lblError.Visible = true; lblError.Text = ex.Message; }
    }
}