using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;

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
    MantencionCntx Contextos = new MantencionCntx();
    GeneradorGrupo geneGru = new GeneradorGrupo();
    RescateDeConceptos rescConc = new RescateDeConceptos();
    public string CorrInst = "", TipoTaxonomia = "", GrupoEmpr = "", SegmEmpr = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.Remove("par1");
        this.RecuperaSessionWeb();
        lb_error.Visible = false;
        if (!IsPostBack)
        {
            DataTable dt = geneGru.getGrupos().Tables[0];
            ddl_Grupo.DataSource = dt;
            ddl_Grupo.DataTextField = dt.Columns["desc_grup"].ToString();
            ddl_Grupo.DataValueField = dt.Columns["codi_grup"].ToString();
            ddl_Grupo.DataBind();

            dt = geneGru.getSegmentos().Tables[0];
            ddl_Segmento.DataSource = dt;
            ddl_Segmento.DataTextField = dt.Columns["desc_segm"].ToString();
            ddl_Segmento.DataValueField = dt.Columns["codi_segm"].ToString();
            ddl_Segmento.DataBind();

            dt = geneGru.getTiposTaxonomia().Tables[0];
            ddl_TipoTaxonomia.DataSource = dt;
            ddl_TipoTaxonomia.DataTextField = dt.Columns["desc_tipo"].ToString();
            ddl_TipoTaxonomia.DataValueField = dt.Columns["tipo_taxo"].ToString();
            ddl_TipoTaxonomia.DataBind();
            SysParamController _loSysaParam = new SysParamController();
            var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_DEFE_TAXO", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            this.ddl_TipoTaxonomia.SelectedValue = loResultado.PARAM_VALUE;
            Session["TipoTaxo"] = TipoTaxonomia;

            llenado_de_periodos();
            //llenado_de_empresa();
            //llenado_gridview();

            if (Session["CorrInst"] != null)
                if (Session["CorrInst"].ToString() != string.Empty)
                    this.ddl_CorrInst.SelectedValue = Session["CorrInst"].ToString();
            if (Session["GrupoEmpr"] != null)
                if (Session["GrupoEmpr"].ToString() != string.Empty)
                    this.ddl_Grupo.SelectedValue = Session["GrupoEmpr"].ToString();
            if (Session["TipoTaxo"] != null)
                if (Session["TipoTaxo"].ToString() != string.Empty)
                    this.ddl_TipoTaxonomia.SelectedValue = Session["TipoTaxo"].ToString();
            if (Session["SegmEmpr"] != null)
                if (Session["SegmEmpr"].ToString() != string.Empty)
                    this.ddl_Segmento.SelectedValue = Session["SegmEmpr"].ToString();

            llenado_grillas();
        }
    }
    protected void ddl_Grupo_SelectedIndexChanged(object sender, EventArgs e)
    {
        GrupoEmpr = ddl_Grupo.SelectedValue.ToString();
        Session["GrupoEmpr"] = GrupoEmpr;
        llenado_grillas();
    }
    protected void ddl_Segmento_SelectedIndexChanged(object sender, EventArgs e)
    {
        SegmEmpr = ddl_Segmento.SelectedValue.ToString();
        Session["SegmEmpr"] = SegmEmpr;
        llenado_grillas();
    }
    protected void llenado_grillas()
    {
        if (rb_VersInst.SelectedValue == "N")
        {
            Grilla_Empresas.Visible = false;
            Grilla_EmpExte.Visible = true;
            llenado_gridviewExt();

        }
        else
        {
            Grilla_Empresas.Visible = true;
            Grilla_EmpExte.Visible = false;
            llenado_gridview();
        }
    }
    protected void llenado_gridview()
    {
        try
        {
            DataTable dt = GenExcel.getEmpresasDocumentos(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_CorrInst.SelectedValue, Filtro_Empresa.Text, ddl_Grupo.SelectedValue, ddl_Segmento.SelectedValue, ddl_TipoTaxonomia.SelectedValue);

            Grilla_Empresas.DataSource = dt;
            Grilla_Empresas.DataBind();
            Grilla_Empresas.Columns[3].Visible = false;
            Grilla_Empresas.Columns[5].Visible = false;
            Grilla_Empresas.Columns[7].Visible = false;
            Grilla_Empresas.Columns[9].Visible = false;
            Grilla_Empresas.Columns[11].Visible = false;
            Grilla_Empresas.Columns[13].Visible = false;
        }
        catch (Exception ex)
        {
            DataTable dt = GenExcel.getEmpresasDocumentos(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_CorrInst.SelectedValue, Filtro_Empresa.Text, ddl_Grupo.SelectedValue, ddl_Segmento.SelectedValue, ddl_TipoTaxonomia.SelectedValue);

            Grilla_Empresas.DataSource = dt;
            Grilla_Empresas.DataBind();
            //Grilla_Empresas.Columns[1].Visible = false;
            Grilla_Empresas.Columns[3].Visible = false;
            Grilla_Empresas.Columns[5].Visible = false;
            Grilla_Empresas.Columns[7].Visible = false;
            Grilla_Empresas.Columns[9].Visible = false;
            Grilla_Empresas.Columns[11].Visible = false;
            Grilla_Empresas.Columns[13].Visible = false;
            lb_error.Visible = true;
            lb_error.Text = "ocurrio un error.";
        }
        //lblProcesado.Text = "Ultima búsqueda " + this.ddl_CorrInst.SelectedItem.Text;
    }
    private void llenado_gridviewExt()
    {
        try
        {
            DataTable dt = GenExcel.getEmpresasDocumentosExt(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_CorrInst.SelectedValue, Filtro_Empresa.Text, ddl_Grupo.SelectedValue, ddl_Segmento.SelectedValue, ddl_TipoTaxonomia.SelectedValue, _goSessionWeb.CODI_USUA);

            Grilla_EmpExte.DataSource = dt;
            Grilla_EmpExte.DataBind();
            Grilla_EmpExte.Columns[3].Visible = false;
            Grilla_EmpExte.Columns[5].Visible = false; 
         //   Grilla_EmpExte.Columns[6].Visible = false;
        }
        catch (Exception ex)
        {
            DataTable dt = GenExcel.getEmpresasDocumentosExt(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_CorrInst.SelectedValue, Filtro_Empresa.Text, ddl_Grupo.SelectedValue, ddl_Segmento.SelectedValue, ddl_TipoTaxonomia.SelectedValue, _goSessionWeb.CODI_USUA);

            Grilla_EmpExte.DataSource = dt;
            Grilla_EmpExte.DataBind();
            Grilla_EmpExte.Columns[3].Visible = false;
            Grilla_EmpExte.Columns[5].Visible = false;
            Grilla_EmpExte.Columns[6].Visible = false;
            lb_error.Visible = true;
            lb_error.Text = "ocurrio un error.";
        }
        lblProcesado.Text = "Ultima búsqueda " + this.ddl_CorrInst.SelectedItem.Text;
    }
    protected void llenado_de_periodos()
    {
        try
        {
            DataTable dt = GenExcel.getPersCorrInst("");
            ddl_CorrInst.DataSource = dt;
            ddl_CorrInst.DataTextField = dt.Columns["desc_inst"].ToString();
            ddl_CorrInst.DataValueField = dt.Columns["corr_inst"].ToString();
            ddl_CorrInst.DataBind();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void Filtro_Empresa_TextChanged(object sender, EventArgs e)
    {
        //llenado_de_empresa();
        llenado_grillas();
    }
    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList(string prefixText, int count, string contextKey)
    {
        GeneracionExcel GenExcel = new GeneracionExcel();
        string gGrupoEmpr = "", gSegmEmpr = "";
        gGrupoEmpr = (string)HttpContext.Current.Session["grupoEmpr"];
        gSegmEmpr = (string)HttpContext.Current.Session["SegmEmpr"];
        DataTable dt = GenExcel.GetEmpresas("1", "1", "", prefixText, gGrupoEmpr, gSegmEmpr, "", "P").Tables[0];
        string[] resultados = new string[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            resultados[i] = dt.Rows[i][1].ToString();
        }
        return resultados;
    }
    protected void ddl_CodiEmpr_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void ddl_CorrInst_SelectedIndexChanged(object sender, EventArgs e)
    {
        CorrInst = ddl_CorrInst.SelectedValue.ToString();
        Session["CorrInst"] = CorrInst;
        llenado_grillas();
    }
    protected void Grilla_Empr_desc_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Grilla_Empresas.PageIndex = e.NewPageIndex;
        Grilla_Empresas.DataBind();
        llenado_gridview();
    }

    protected void Grilla_EmpExte_desc_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Grilla_EmpExte.PageIndex = e.NewPageIndex;
        Grilla_EmpExte.DataBind();
        llenado_gridviewExt();
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
    protected void RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)(e.Row.Cells[3].Controls[1])).Text == "")
            {
                ((ImageButton)(e.Row.Cells[4].Controls[0])).Visible = false;
            }

            if (((Label)(e.Row.Cells[5].Controls[1])).Text == "")
            {
                ((ImageButton)(e.Row.Cells[6].Controls[0])).Visible = false;
            }

            if (((Label)(e.Row.Cells[7].Controls[1])).Text == "")
            {
                ((ImageButton)(e.Row.Cells[8].Controls[0])).Visible = false;
            }

            if (((Label)(e.Row.Cells[9].Controls[1])).Text == "")
            {
                ((ImageButton)(e.Row.Cells[10].Controls[0])).Visible = false;
            }

            if (((Label)(e.Row.Cells[11].Controls[1])).Text == "")
            {
                ((ImageButton)(e.Row.Cells[12].Controls[0])).Visible = false;
            }

            if (((Label)(e.Row.Cells[13].Controls[1])).Text == "")
            {
                ((ImageButton)(e.Row.Cells[14].Controls[0])).Visible = false;
            }
        }
    }
    protected void RowDataBoundExte(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)(e.Row.Cells[3].Controls[1])).Text == "")
            {
                ((ImageButton)(e.Row.Cells[4].Controls[0])).Visible = false;
            }

            if (((Label)(e.Row.Cells[5].Controls[1])).Text == "")
            {
                ((ImageButton)(e.Row.Cells[6].Controls[0])).Visible = false;
            }
        }
    }

    protected void Grilla_Empresas_SelectedIndexChanged(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            MantencionParametros para = new MantencionParametros();
            string tsRutaTemporal = para.getPathWebb() + "temp";
            DescomprimirZipController.CrearCarpeta(tsRutaTemporal, tsRutaTemporal);

            if (e.CommandName == "anal_razo")
            {
                GridViewRow row = Grilla_Empresas.Rows[Convert.ToInt32(e.CommandArgument)];

                GuardarXBRL Gxbrl = new GuardarXBRL();
                DataTable dt = GenExcel.GetArchivosXbrl(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, GenExcel.getUltPersVersInst(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue), ((Label)(row.Cells[3].Controls[1])).Text);
                string contenido64 = dt.Rows[0]["Contenido"].ToString();


                //byte[] contenido = Gxbrl.Rescata_Archivos_XBRL(contenido64);
                string tsNombreArchivo = dt.Rows[0]["Archivos"].ToString();
                //Response.Clear();
                //Response.ContentType = "application/pdf";
                //Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[3].Controls[1])).Text);
                //Response.BinaryWrite(contenido);
                //Response.End();
                
                DescomprimirZipController.CrearArchivo(tsRutaTemporal + "\\" + tsNombreArchivo, contenido64);
                DescomprimirZipController.Descromprimir2(tsRutaTemporal, tsNombreArchivo, tsRutaTemporal);
                string pScript = "window.open(\"../temp/" + tsNombreArchivo.Replace(".zip", "") + "\",\"" + "_blank\",\"width=800,height=600,scrollbars=yes,toolbar=no\");";// +
                ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
            }
            else if (e.CommandName == "Decl_Resp")
            {
                GridViewRow row = Grilla_Empresas.Rows[Convert.ToInt32(e.CommandArgument)];

                GuardarXBRL Gxbrl = new GuardarXBRL();
                DataTable dt = GenExcel.GetArchivosXbrl(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, GenExcel.getUltPersVersInst(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue), ((Label)(row.Cells[5].Controls[1])).Text);
                string contenido64 = dt.Rows[0]["Contenido"].ToString();

                //byte[] contenido = Gxbrl.Rescata_Archivos_XBRL(contenido64);
                string tsNombreArchivo = dt.Rows[0]["Archivos"].ToString();
                //Response.Clear();
                //Response.ContentType = "application/pdf";
                //Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[5].Controls[1])).Text);
                //Response.BinaryWrite(contenido);
                //Response.End();

                DescomprimirZipController.CrearArchivo(tsRutaTemporal + "\\" + tsNombreArchivo, contenido64);
                DescomprimirZipController.Descromprimir2(tsRutaTemporal, tsNombreArchivo, tsRutaTemporal);
                string pScript = "window.open(\"../temp/" + tsNombreArchivo.Replace(".zip", "") + "\",\"" + "_blank\",\"width=800,height=600,scrollbars=yes,toolbar=no\");";// +
                ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
            }
            else if (e.CommandName == "Esta_PDF")
            {
                GridViewRow row = Grilla_Empresas.Rows[Convert.ToInt32(e.CommandArgument)];

                GuardarXBRL Gxbrl = new GuardarXBRL();
                DataTable dt = GenExcel.GetArchivosXbrl(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, GenExcel.getUltPersVersInst(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue), ((Label)(row.Cells[7].Controls[1])).Text);
                string contenido64 = dt.Rows[0]["Contenido"].ToString();

                //byte[] contenido = Gxbrl.Rescata_Archivos_XBRL(contenido64);
                string tsNombreArchivo = dt.Rows[0]["Archivos"].ToString();
                //Response.Clear();
                //Response.ContentType = "application/pdf";
                //Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[7].Controls[1])).Text);
                //Response.BinaryWrite(contenido);
                //Response.End();

                DescomprimirZipController.CrearArchivo(tsRutaTemporal + "\\" + tsNombreArchivo, contenido64);
                DescomprimirZipController.Descromprimir2(tsRutaTemporal, tsNombreArchivo, tsRutaTemporal);
                string pScript = "window.open(\"../temp/" + tsNombreArchivo.Replace(".zip", "") + "\",\"" + "_blank\",\"width=800,height=600,scrollbars=yes,toolbar=no\");";// +
                ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
            }
            else if (e.CommandName == "Esta_XBRL")
            {
                GridViewRow row = Grilla_Empresas.Rows[Convert.ToInt32(e.CommandArgument)];

                GuardarXBRL Gxbrl = new GuardarXBRL();
                DataTable dt = GenExcel.GetArchivosXbrl(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, GenExcel.getUltPersVersInst(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue), ((Label)(row.Cells[9].Controls[1])).Text);
                string contenido64 = dt.Rows[0]["Contenido"].ToString();

                byte[] contenido = Gxbrl.Rescata_Archivos_XBRL(contenido64);

                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[9].Controls[1])).Text);
                Response.BinaryWrite(contenido);
                Response.End();
            }
            else if (e.CommandName == "Hech_Rele")
            {
                GridViewRow row = Grilla_Empresas.Rows[Convert.ToInt32(e.CommandArgument)];

                GuardarXBRL Gxbrl = new GuardarXBRL();
                DataTable dt = GenExcel.GetArchivosXbrl(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, GenExcel.getUltPersVersInst(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue), ((Label)(row.Cells[11].Controls[1])).Text);
                string contenido64 = dt.Rows[0]["Contenido"].ToString();

                //byte[] contenido = Gxbrl.Rescata_Archivos_XBRL(contenido64);
                string tsNombreArchivo = dt.Rows[0]["Archivos"].ToString();
                //Response.Clear();
                //Response.ContentType = "application/pdf";
                //Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[11].Controls[1])).Text);
                //Response.BinaryWrite(contenido);
                //Response.End();

                DescomprimirZipController.CrearArchivo(tsRutaTemporal + "\\" + tsNombreArchivo, contenido64);
                DescomprimirZipController.Descromprimir2(tsRutaTemporal, tsNombreArchivo, tsRutaTemporal);
                string pScript = "window.open(\"../temp/" + tsNombreArchivo.Replace(".zip", "") + "\",\"" + "_blank\",\"width=800,height=600,scrollbars=yes,toolbar=no\");";// +
                ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
            }
            else if (e.CommandName == "empr_deta")
            {
                GridViewRow row = Grilla_Empresas.Rows[Convert.ToInt32(e.CommandArgument)];
                VariablesSession vSes = new VariablesSession();
                vSes.VariablesPersonaInstancia("1", "1", ((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, ddl_TipoTaxonomia.SelectedValue);
                Session["par1"] = vSes;

                Response.Redirect("DetalleEmpresa.aspx", true);
            }
            else if (e.CommandName == "Visu_XBRL")
            {
                GridViewRow row = Grilla_Empresas.Rows[Convert.ToInt32(e.CommandArgument)];

                GuardarXBRL Gxbrl = new GuardarXBRL();
                DataTable dt = GenExcel.GetArchivosXbrl(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, GenExcel.getUltPersVersInst(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue), ((Label)(row.Cells[13].Controls[1])).Text);
                string contenido64 = dt.Rows[0]["Contenido"].ToString();

                string tsNombreArchivo = dt.Rows[0]["Archivos"].ToString();
                DescomprimirZipController.CrearArchivo(tsRutaTemporal + "\\" + tsNombreArchivo, contenido64);
                String pScript = "window.open(\"../temp/" + tsNombreArchivo + "\",\"" + "_blank\",\"width=800,height=600,scrollbars=yes,toolbar=no\");";// +
                ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
            }
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void Grilla_EmpresasExte_SelectedIndexChanged(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            MantencionParametros para = new MantencionParametros();
            string tsRutaTemporal = para.getPathWebb() + "temp/";
            DescomprimirZipController.CrearCarpeta(tsRutaTemporal, tsRutaTemporal);
            string vMinVers, vMaxVers;

            //if (e.CommandName == "anal_razo")
            //{
            //    GridViewRow row = Grilla_Empresas.Rows[Convert.ToInt32(e.CommandArgument)];

            //    GuardarXBRL Gxbrl = new GuardarXBRL();
            //    DataTable dt = GenExcel.GetArchivosXbrl(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, GenExcel.getUltPersVersInst(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue), ((Label)(row.Cells[3].Controls[1])).Text);
            //    string contenido64 = dt.Rows[0]["Contenido"].ToString();


            //    byte[] contenido = Gxbrl.Rescata_Archivos_XBRL(contenido64);
            //    string tsNombreArchivo = dt.Rows[0]["Archivos"].ToString();
            //    //Response.Clear();
            //    //Response.ContentType = "application/pdf";
            //    //Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[3].Controls[1])).Text);
            //    //Response.BinaryWrite(contenido);
            //    //Response.End();

            //    DescomprimirZipController.CrearArchivo(tsRutaTemporal + "\\" + tsNombreArchivo, contenido64);
            //    DescomprimirZipController.Descromprimir2(tsRutaTemporal, tsNombreArchivo, tsRutaTemporal);
            //    string pScript = "window.open(\"../temp/" + tsNombreArchivo.Replace(".zip", "") + "\",\"" + "_blank\",\"width=800,height=600,scrollbars=yes,toolbar=no\");";// +
            //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
            //}
            //else if (e.CommandName == "Decl_Resp")
            //{
            //    GridViewRow row = Grilla_Empresas.Rows[Convert.ToInt32(e.CommandArgument)];

            //    GuardarXBRL Gxbrl = new GuardarXBRL();
            //    DataTable dt = GenExcel.GetArchivosXbrl(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, GenExcel.getUltPersVersInst(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue), ((Label)(row.Cells[5].Controls[1])).Text);
            //    string contenido64 = dt.Rows[0]["Contenido"].ToString();

            //    byte[] contenido = Gxbrl.Rescata_Archivos_XBRL(contenido64);
            //    string tsNombreArchivo = dt.Rows[0]["Archivos"].ToString();
            //    //Response.Clear();
            //    //Response.ContentType = "application/pdf";
            //    //Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[5].Controls[1])).Text);
            //    //Response.BinaryWrite(contenido);
            //    //Response.End();

            //    DescomprimirZipController.CrearArchivo(tsRutaTemporal + "\\" + tsNombreArchivo, contenido64);
            //    DescomprimirZipController.Descromprimir2(tsRutaTemporal, tsNombreArchivo, tsRutaTemporal);
            //    string pScript = "window.open(\"../temp/" + tsNombreArchivo.Replace(".zip", "") + "\",\"" + "_blank\",\"width=800,height=600,scrollbars=yes,toolbar=no\");";// +
            //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
            //}
            //else if (e.CommandName == "Esta_PDF")
            //{
            //    GridViewRow row = Grilla_Empresas.Rows[Convert.ToInt32(e.CommandArgument)];

            //    GuardarXBRL Gxbrl = new GuardarXBRL();
            //    DataTable dt = GenExcel.GetArchivosXbrl(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, GenExcel.getUltPersVersInst(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue), ((Label)(row.Cells[7].Controls[1])).Text);
            //    string contenido64 = dt.Rows[0]["Contenido"].ToString();

            //    byte[] contenido = Gxbrl.Rescata_Archivos_XBRL(contenido64);
            //    string tsNombreArchivo = dt.Rows[0]["Archivos"].ToString();
            //    //Response.Clear();
            //    //Response.ContentType = "application/pdf";
            //    //Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[7].Controls[1])).Text);
            //    //Response.BinaryWrite(contenido);
            //    //Response.End();

            //    DescomprimirZipController.CrearArchivo(tsRutaTemporal + "\\" + tsNombreArchivo, contenido64);
            //    DescomprimirZipController.Descromprimir2(tsRutaTemporal, tsNombreArchivo, tsRutaTemporal);
            //    string pScript = "window.open(\"../temp/" + tsNombreArchivo.Replace(".zip", "") + "\",\"" + "_blank\",\"width=800,height=600,scrollbars=yes,toolbar=no\");";// +
            //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
            //}
    if (e.CommandName == "xbrl_exte")
            {
                GridViewRow row = Grilla_EmpExte.Rows[Convert.ToInt32(e.CommandArgument)];

                GuardarXBRL Gxbrl = new GuardarXBRL();
                DataTable dt = GenExcel.GetArchivosXbrlExte(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, ((Label)(row.Cells[3].Controls[1])).Text, _goSessionWeb.CODI_USUA);
                string contenido64 = dt.Rows[0]["Contenido"].ToString();

                byte[] contenido = Gxbrl.Rescata_Archivos_XBRL(contenido64);

                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[3].Controls[1])).Text);
                Response.BinaryWrite(contenido);
                Response.End();
            }
            //else if (e.CommandName == "Hech_Rele")
            //{
            //    GridViewRow row = Grilla_Empresas.Rows[Convert.ToInt32(e.CommandArgument)];

            //    GuardarXBRL Gxbrl = new GuardarXBRL();
            //    DataTable dt = GenExcel.GetArchivosXbrl(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, GenExcel.getUltPersVersInst(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue), ((Label)(row.Cells[11].Controls[1])).Text);
            //    string contenido64 = dt.Rows[0]["Contenido"].ToString();

            //    byte[] contenido = Gxbrl.Rescata_Archivos_XBRL(contenido64);
            //    string tsNombreArchivo = dt.Rows[0]["Archivos"].ToString();
            //    //Response.Clear();
            //    //Response.ContentType = "application/pdf";
            //    //Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[11].Controls[1])).Text);
            //    //Response.BinaryWrite(contenido);
            //    //Response.End();

            //    DescomprimirZipController.CrearArchivo(tsRutaTemporal + "\\" + tsNombreArchivo, contenido64);
            //    DescomprimirZipController.Descromprimir2(tsRutaTemporal, tsNombreArchivo, tsRutaTemporal);
            //    string pScript = "window.open(\"../temp/" + tsNombreArchivo.Replace(".zip", "") + "\",\"" + "_blank\",\"width=800,height=600,scrollbars=yes,toolbar=no\");";// +
            //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
            //}
            //else if (e.CommandName == "empr_deta")
            //{
            //    GridViewRow row = Grilla_Empresas.Rows[Convert.ToInt32(e.CommandArgument)];
            //    VariablesSession vSes = new VariablesSession();
            //    vSes.VariablesPersonaInstancia("1", "1", ((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, ddl_TipoTaxonomia.SelectedValue);
            //    Session["par1"] = vSes;

            //    Response.Redirect("DetalleEmpresa.aspx", true);
            //}
            else if (e.CommandName == "visu_html")
            {
                GridViewRow row = Grilla_EmpExte.Rows[Convert.ToInt32(e.CommandArgument)];

                GuardarXBRL Gxbrl = new GuardarXBRL();
                DataTable dt = GenExcel.GetArchivosXbrlExte(((Label)(row.Cells[1].Controls[1])).Text, ddl_CorrInst.SelectedValue, ((Label)(row.Cells[5].Controls[1])).Text, _goSessionWeb.CODI_USUA);
                string contenido64 = dt.Rows[0]["Contenido"].ToString();

                string tsNombreArchivo = dt.Rows[0]["Archivos"].ToString();
                DescomprimirZipController.CrearArchivo(tsRutaTemporal + tsNombreArchivo, contenido64);
                String pScript = "window.open(\"../temp/" + tsNombreArchivo + "\",\"" + "_blank\",\"width=800,height=600,scrollbars=yes,toolbar=no\");";// +
                ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
            }
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }

    protected void ddl_TipoTaxonomia_SelectedIndexChanged(object sender, EventArgs e)
    {
        TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue;
        Session["TipoTaxo"] = TipoTaxonomia;
        llenado_grillas();
    }
    protected void Buscar_Click(object sender, ImageClickEventArgs e)
    {
        llenado_grillas();
    }
    protected void rb_VersInst_SelectedIndexChanged(object sender, EventArgs e)
    {
        llenado_grillas();
    }
}