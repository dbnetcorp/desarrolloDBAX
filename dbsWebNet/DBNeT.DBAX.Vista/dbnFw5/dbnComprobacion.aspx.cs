using System;
using System.Data;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.IO;
using System.Web.UI.HtmlControls;
using DBNeT.Base.Controlador;

public partial class dbnComprobacion : System.Web.UI.Page
{
    DataTable dt = new DataTable();
    GridView grilla1;
    DataTable dtG = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        dt = (DataTable)Session["dt"];
        dtG = (DataTable)Session["dtGrilla"];
        grilla1 = (GridView)Session["grilla1"];
        
    }
    protected void btnSi_Click(object sender, EventArgs e)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            StringWriter sw = new StringWriter(sb);
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            Page page = new Page();
            HtmlForm form = new HtmlForm();

            grilla1.DataSource = dt;
            grilla1.DataBind();

            grilla1.EnableViewState = false;
            page.EnableEventValidation = false;
            page.DesignerInitialize();
            //Asi se Agrega componentes de un CSS a la grilla
            //grilla1.Style.Add("width", "700");
            //grilla1.Style.Add("background-color", "#F5F5F5");
            form.Controls.Add(grilla1);
            page.Controls.Add(form);
            page.RenderControl(htw);
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/vnd.ms-excel";
            Response.AddHeader("Content-Disposition", "attachment;filename= Listado.xls");
            Response.Charset = "UTF-8";
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentEncoding = System.Text.Encoding.Default;
            Response.Write(sb.ToString());
            Response.End();
        }
        catch (Exception ex)
        { throw ex; }
    }
    protected void btnNo_Click(object sender, EventArgs e)
    {
        try
        {   
            StringBuilder sb = new StringBuilder();
            StringWriter sw = new StringWriter(sb);
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            Page page = new Page();
            HtmlForm form = new HtmlForm();

            grilla1.DataSource = dtG;
            grilla1.DataBind();

            grilla1.EnableViewState = false;
            page.EnableEventValidation = false;
            page.DesignerInitialize();
            //Asi se Agrega componentes de un CSS a la grilla
            //grilla1.Style.Add("width", "700");
            //grilla1.Style.Add("background-color", "#F5F5F5");
            form.Controls.Add(grilla1);
            page.Controls.Add(form);
            page.RenderControl(htw);
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/vnd.ms-excel";
            Response.AddHeader("Content-Disposition", "attachment;filename= Listado.xls");
            Response.Charset = "UTF-8";
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentEncoding = System.Text.Encoding.Default;
            Response.Write(sb.ToString());
            Response.End();
        }
        catch (Exception ex)
        { throw ex; }
    }
}