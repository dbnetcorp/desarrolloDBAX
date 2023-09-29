using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.IO;
using System.Net;
using DBNeT.Base.Modelo;

public partial class Website_listadoIndicadores : System.Web.UI.Page
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

    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        MantencionIndicadores Indicador = new MantencionIndicadores();
        DataTable dt = Indicador.getListaIndicadores(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), "", "");
        gv_Indicadores.DataSource = dt;
        gv_Indicadores.DataBind();
    }
    protected void gv_Indicadores_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["par1"] = gv_Indicadores.Rows[gv_Indicadores.SelectedIndex].Cells[1].Text;
        Session["par2"] = gv_Indicadores.Rows[gv_Indicadores.SelectedIndex].Cells[2].Text;

        Response.Redirect("Indicadores.aspx?modo=M");
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
}