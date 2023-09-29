using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Modelo;
using DBNeT.Base.Modelo;
using DBNeT.Base.Controlador;

public partial class Website_Login : System.Web.UI.UserControl
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
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        this.lblUsuario.Text = _goSessionWeb.CODI_USUA;
        MantencionParametros para = new MantencionParametros();
        lbVers.Text = para.getVersion();
    }

    protected void cerrar_sesion_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        this.RecuperaSessionWeb();
    }
    protected void irAHome(object sender, EventArgs e)
    {
        Response.Redirect("~/dbnet.dbax/Home.aspx");

    }

}