using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Website_ListadoDiferencias : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string contenido = Session["vHTML"].ToString();
        Response.Clear();
       // Response.ContentType = "application/pdf";
        //Response.AddHeader("Content-Disposition", @"attachment; filename=  " + ((Label)(row.Cells[1].Controls[1])).Text);str
        Response.Write(contenido);
        Response.End();
    }
}