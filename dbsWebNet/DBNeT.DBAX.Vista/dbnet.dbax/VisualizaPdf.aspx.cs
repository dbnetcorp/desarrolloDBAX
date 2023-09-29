using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class VizualizaPdf : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["RUTA_PDFF"] != null)
        {
            string lsRuta = Session["RUTA_PDFF"].ToString();
            FileStream fs = new FileStream(lsRuta, FileMode.Open, FileAccess.Read);
            byte[] bytes = new byte[(int)fs.Length];
            fs.Read(bytes,0,(int)fs.Length);

            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition","attachment; filename="+"PDF.pdf");
            Response.BinaryWrite(bytes);
            //Response.Flush();
            Response.End();
            fs.Close();
            fs.Dispose();
            fs = null;
            
            //Response.TransmitFile(lsRuta);
            //myFrame.Attributes.Add("src", lsRuta);
        }
    }
}