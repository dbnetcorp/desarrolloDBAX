using System;
using System.Data;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;

public partial class dbnBusquedaReportes : System.Web.UI.Page
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
        { Response.Redirect("~/dbnFw5/dbnSesionExpirada.aspx",true); }
        else
        { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
    }
    private void GuardaSessionWeb()
    { Session["sessionWeb"] = _goSessionWeb; }
    #endregion
    
    DbnRepoRousController _goRepoRous;
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
    }

    protected void CargaReportesDiv()
    {
        _goRepoRous = new DbnRepoRousController();
        var dt = _goRepoRous.readRepoRousBusqueda(_goSessionWeb.CODI_MODU, txtBusqueda.Text.Trim());
        foreach (DataRow item in dt.Rows)
        {
            if (item["object_type"].ToString().ToUpper() == "B")
            {
                ImageButton img = new ImageButton();
                img.ID = item["object_brief"].ToString();
                img.ImageUrl = "~/librerias/img/botones/dbs_repo.jpg";
                img.PostBackUrl = "~/dbnFw5/" + item["object_prog"].ToString() + ".aspx";
                HyperLink hp = new HyperLink();
                hp.Text = item["object_brief"].ToString();
                hp.NavigateUrl = "~/dbnFw5/" + item["object_prog"].ToString() + ".aspx";
                hp.CssClass = "dbnIndex";
                Label lbl = new Label();
                lbl.Text = "<br/>" + item["object_desc"].ToString();
                lbl.CssClass = "dbnLabel";
                divHijo.Controls.Add(img);
                divHijo.Controls.Add(hp);
                divHijo.Controls.Add(lbl);
                divHijo.Controls.Add(new HtmlGenericControl("br/"));
            }
            else if (item["object_type"].ToString().ToUpper() == "W")
            {
                ImageButton img = new ImageButton();
                img.ID = item["object_brief"].ToString();
                img.ImageUrl = "~/librerias/img/botones/dbs_repo.jpg";
                img.PostBackUrl = "~/dbnFw5/dbnFw5Listador.aspx?listado=" + item["object_prog"].ToString() + "&" + item["par0"].ToString() + "=" + item["val0"].ToString();
                HyperLink hp = new HyperLink();
                hp.Text = item["object_brief"].ToString();
                hp.NavigateUrl = "~/dbnFw5/dbnFw5Listador.aspx?listado=" + item["object_prog"].ToString() + "&" + item["par0"].ToString() +"="+ item["val0"].ToString();
                hp.CssClass = "dbnIndex";
                Label lbl = new Label();
                lbl.Text = "<br/>" + item["object_desc"].ToString();
                lbl.CssClass = "dbnLabel";
                divHijo.Controls.Add(img);
                divHijo.Controls.Add(hp);
                divHijo.Controls.Add(lbl);
                divHijo.Controls.Add(new HtmlGenericControl("br/"));
            }
        }
        divLink.Controls.Add(divHijo);
    }
    protected void btnBusqueda_Click(object sender, ImageClickEventArgs e)
    {
        CargaReportesDiv();
    }
}