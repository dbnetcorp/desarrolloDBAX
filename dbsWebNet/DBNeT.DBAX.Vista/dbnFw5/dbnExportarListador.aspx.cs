using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Modelo;

public partial class dbnFw5_dbnExportarListador : System.Web.UI.Page
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
        { Response.Redirect("~/IF/Error.aspx", true); }
        else
        { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
    }
    private void GuardaSessionWeb()
    { Session["sessionWeb"] = _goSessionWeb; }
    #endregion
    DbnListRepoController _goDbnListRepoController;

    ExportarListadorController _goExportarListadorController;
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        _goDbnListRepoController = new DbnListRepoController();
        lblTitulo.Text = "Exportar Reportes";
        lblReporte.Text = "Reportes";
        if (!IsPostBack)
        {
            this.CargaDdl();
        }
    }

    private void CargaDdl()
    {
        _goDbnListRepoController = new DbnListRepoController();
        var loResultado = _goDbnListRepoController.readReporteDt("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        Helper.ddlCarga(ddlReportes, loResultado);
    }
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            _goExportarListadorController = new ExportarListadorController();
            _goExportarListadorController.GeneraReporte(this.ddlReportes.SelectedValue, _goSessionWeb.PATH);
            string ruta = _goSessionWeb.PATH+"/librerias/archivos/" + this.ddlReportes.SelectedValue + ".sql";
            Response.Clear();
            Response.Buffer = true; // arroja el pdf completo  no por parte  almacena todo en un buffer y luego lo suelta
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("content-disposition", @"attachment; filename= " + this.ddlReportes.SelectedValue + ".sql");
            FileStream fs = new FileStream(ruta, FileMode.Open);
            BinaryReader br = new BinaryReader(fs);
            Byte[] dataBytes = br.ReadBytes((int)(fs.Length - 1));
            Response.BinaryWrite(dataBytes);
            //Response.Flush();
            fs.Close();
            Response.End();
        }
        catch (Exception ex)
        { this.lblError.Text =  ex.Message; }
    }
    protected void btnVolver_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/dbnWeb/dbnHome.aspx", true);
    }
}