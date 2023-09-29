using System;
using System.Data;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;

public partial class dbnIndexReportes : System.Web.UI.Page
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
        { Response.Redirect("~/dbnFw5/dbnLogin.aspx"); }
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
        lblTitulo.Text = "Reportes Disponibles";
        if (!IsPostBack)
        { CargaReportesDiv(); }

    }

    protected void CargaReportesDiv()
    {
        _goRepoRous = new DbnRepoRousController();
        var dt = _goRepoRous.readRepoRousBusqueda(_goSessionWeb.CODI_ROUS, txtBusqueda.Text.Trim());
        foreach (DataRow item in dt.Rows)
        {

            HyperLink hp = new HyperLink();
            hp.Text = item["TITU_REPO"].ToString();
            hp.NavigateUrl = "~/dbnFw5/dbnFw5Listador.aspx?listado="+item["codi_repo"].ToString()+"&modo="+item["modo"].ToString();
            hp.CssClass = "dbnLabel";
            divHijo.Controls.Add(hp);
            HtmlGenericControl br = new HtmlGenericControl("br");
            Label lbl = new Label();
            lbl.Text = item["DESC_REPO"].ToString();
            lbl.CssClass = "dbnLabel";
            divHijo.Controls.Add(lbl);
            divHijo.Controls.Add(br);
        }
        divLink.Controls.Add(divHijo);
    }
    protected void btnBusqueda_Click(object sender, ImageClickEventArgs e)
    {
        CargaReportesDiv();
    }
}