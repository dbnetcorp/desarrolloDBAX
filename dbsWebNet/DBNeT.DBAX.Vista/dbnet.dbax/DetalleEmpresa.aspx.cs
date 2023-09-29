using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Diagnostics;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;
using System.IO;

public partial class Website_Home : System.Web.UI.Page
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
    MantencionIndicadores MantIndi = new MantencionIndicadores();
    MantencionParametros para = new MantencionParametros();
    GuardarXBRL Gxbrl = new GuardarXBRL();
    private string CodiPers, CorrInst, VersInst, TipoTaxo, vTipoTaxo;

    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        

        lb_error.Text = "";
        lb_error.Visible = false;
        if (!IsPostBack)
        {
            VariablesSession Ses = new VariablesSession();
            Ses = (VariablesSession)Session["par1"];
            CodiPers = Ses.CodiPers;
            CorrInst = Ses.CorrInst;
            vTipoTaxo = Ses.TipoTaxo;
            VersInst = GenExcel.getUltPersVersInst(CodiPers, CorrInst);
            lblTipoTaxo.Text = vTipoTaxo;
            DataTable dt = GenExcel.GetArchivosXbrl(CodiPers, CorrInst, VersInst);
            GeneracionHTML genHtml = new GeneracionHTML();
            gv_Archivos.DataSource = dt;
            gv_Archivos.DataBind();

            DataTable dtPersona = GenExcel.GetEmpresas(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), "", CodiPers, "", "", "", "P").Tables[0];
            DataTable dtMoneda = genHtml.getCodiMone(CodiPers, CorrInst).Tables[0];
            DataTable dt_Contextos = MantIndi.getContextoFechas(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CorrInst, "TrimestreAcumuladoActual");

            lbNombEmpr.Text = dtPersona.Rows[0]["desc_peho"].ToString();
            lblRutEmpr.Text = dtPersona.Rows[0]["codi_pers"].ToString();
            lbDescGrup.Text = dtPersona.Rows[0]["desc_grup"].ToString();
            lbDescSegm.Text = dtPersona.Rows[0]["desc_segm"].ToString();
            lblMoneda.Text = dtMoneda.Rows[0]["codi_mone"].ToString();
            TipoTaxo = dtPersona.Rows[0]["tipo_taxo"].ToString();

            lbFechInst.Text = CorrInst + " (" + dt_Contextos.Rows[0]["fini_cntx"].ToString() + " - " + dt_Contextos.Rows[0]["ffin_cntx"].ToString() + ")";

            DataTable dtIndicadores = MantIndi.getListaIndicadores(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), TipoTaxo, "", "S");
            dtIndicadores.Columns.Add();
            dtIndicadores.Columns[dtIndicadores.Columns.Count - 1].ColumnName = "ValoCntx";
            for (int i = 0; i < dtIndicadores.Rows.Count; i++)
            {
                DataTable temp = GenExcel.getValoConc(CodiPers, CorrInst, VersInst, "indi", dtIndicadores.Rows[i]["Nombre"].ToString(), dt_Contextos.Rows[0]["fini_cntx"].ToString(), dt_Contextos.Rows[0]["ffin_cntx"].ToString());
                dtIndicadores.Rows[i][dtIndicadores.Columns.Count - 1] = temp.Rows[0][0].ToString();
            }
            gv_Indicadores.DataSource = dtIndicadores;
            gv_Indicadores.DataBind();

            DataTable dtReportes = GenExcel.getInformesUsables(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CodiPers, CorrInst, VersInst, "R",lblTipoTaxo.Text);
            gv_Reportes.DataSource = dtReportes;
            gv_Reportes.DataBind();
            CodiPers = lblRutEmpr.Text;
            CorrInst = lbFechInst.Text.Substring(0, 6).ToString();
            vTipoTaxo = lblTipoTaxo.Text;
        }  
    }
    protected void RowCreated(object sender, GridViewRowEventArgs e)
    {
        // only apply changes if its DataRow
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // when mouse is over the row, save original color to new attribute, and change it to highlight yellow color
            e.Row.Attributes.Add("onmouseover",
          "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#CCCCCC'");

            // when mouse leaves the row, change the bg color to its original value   
            e.Row.Attributes.Add("onmouseout",
            "this.style.backgroundColor=this.originalstyle;");
        }
    }

    protected void gv_Archivos_Click(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            int indexRow = e.RowIndex;
            GridViewRow row = gv_Archivos.Rows[indexRow];
            DataTable dt = new DataTable();
            dt = GenExcel.GetArchivosXbrl(CodiPers, CorrInst, GenExcel.getUltPersVersInst(CodiPers, CorrInst), ((Label)(row.Cells[1].Controls[1])).Text);
            string contenido64 = dt.Rows[0]["Contenido"].ToString();
            string tsRutaZip = para.getPath("DBAX_PATH_ZIPP");

            string tsRutaTemporal = para.getPath("DBAX_PATH_TEMP");
            
            byte[] contenido = Gxbrl.Rescata_Archivos_XBRL(contenido64);            

            Response.Clear();
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[1].Controls[1])).Text);
            Response.BinaryWrite(contenido);
            Response.End();
        }
        catch (Exception ex)
        { lb_error.Visible = true; lb_error.Text = ex.Message; }
    }
    protected void gv_Archivos_Click(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            CodiPers = lblRutEmpr.Text;
            CorrInst = lbFechInst.Text.Substring(0, 6).ToString();
            vTipoTaxo = lblTipoTaxo.Text;
            GridViewRow row = gv_Archivos.Rows[Convert.ToInt32(e.CommandArgument)];
            DataTable dt = new DataTable();
            string lsError = string.Empty;
            string pScript = string.Empty;
            dt = GenExcel.GetArchivosXbrl(CodiPers, CorrInst, GenExcel.getUltPersVersInst(CodiPers, CorrInst), ((Label)(row.Cells[1].Controls[1])).Text);
            string contenido64 = dt.Rows[0]["Contenido"].ToString();
            //string tsRutaPdf = para.getPathWebb() + "temp/";
            string tsRutaTemporal = para.getPathWebb() + "temp/";
            
            string tsNombreArchivo = dt.Rows[0]["Archivos"].ToString();
            byte[] contenido = Gxbrl.Rescata_Archivos_XBRL(contenido64);

            if (tsNombreArchivo.Contains(".pdf"))
            {
                try
                {

                    lsError += DescomprimirZipController.CrearCarpeta(tsRutaTemporal, tsRutaTemporal);
                    lsError += DescomprimirZipController.CrearArchivo(tsRutaTemporal + "\\" + tsNombreArchivo, contenido64);
                    lsError += "<br/>";
                    lsError += DescomprimirZipController.Descromprimir2(tsRutaTemporal, tsNombreArchivo, tsRutaTemporal);
                    Session["RUTA_PDFF"] = tsRutaTemporal + "\\" + tsNombreArchivo.Replace(".zip", "");

                    pScript = "window.open(\"../temp/" + tsNombreArchivo.Replace(".zip", "") + "\",\"" + "_blank\",\"width=800,height=600,scrollbars=yes,toolbar=no\");";// +
                    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
                    //ScriptManager.RegisterStartupScript(typeof(string),, "Visualizador PDF", pScript);                    
                    lb_error.Visible = true;
                    lb_error.Text = lsError;   
                }
                catch (Exception)
                { }
            }
            else if (tsNombreArchivo.Contains(".html"))
            {
                DescomprimirZipController.CrearArchivo(tsRutaTemporal + tsNombreArchivo, contenido64);
                pScript = "window.open(\"../temp/" + tsNombreArchivo + "\",\"" + "_blank\",\"width=800,height=600,scrollbars=yes,toolbar=no\");";// +
                ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
            }
            else
            {
                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[1].Controls[1])).Text);
                Response.BinaryWrite(contenido);
                Response.End();
            }
        }
        catch (Exception ex)
        { lb_error.Visible = true; lb_error.Text = ex.Message;}
    }

    protected void gv_ReportesClick(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            //Metodo que envia los datos del informe a Consulta Empresa Periodo
            GridViewRow row = gv_Reportes.Rows[Convert.ToInt32(e.CommandArgument)];
            VariablesSession vSes = new VariablesSession();
            CodiPers = lblRutEmpr.Text;
            CorrInst = lbFechInst.Text.Substring(0, 6).ToString();
            vTipoTaxo = lblTipoTaxo.Text;
            vSes.VariablesPersonaInstanciaInforme(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CodiPers, CorrInst, ((Label)(row.Cells[1].Controls[1])).Text,vTipoTaxo);
            Session["par1"] = vSes;
            Response.Redirect("ConsultaEmpresaPeriodo.aspx", true);
        }
        catch (Exception ex)
        {lb_error.Visible = true; lb_error.Text = ex.Message;}
    }
}