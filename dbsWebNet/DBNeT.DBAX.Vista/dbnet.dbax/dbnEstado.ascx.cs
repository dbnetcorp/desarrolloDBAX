using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.ComponentModel;
using System.Drawing;
using System.Web.SessionState;
using System.Xml;
using System.Diagnostics;
using DbnetWebLibrary;
using System.IO;
using DBNeT.Base.Modelo;

    public partial class dbnEstado : System.Web.UI.UserControl
    {
        #region Pagina Base
        private string _gsModo = string.Empty;
        protected SessionWeb _goSessionWeb;
        private void RecuperaSessionWeb()
        {
            if (Session["sessionWeb"] == null)
            { Response.Redirect("~/dbnFw5/dbnLogin.aspx"); }
            else
            { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
        }
        public void GuardaSessionWeb()
        { 
            Session["sessionWeb"] = _goSessionWeb; 
        }
        #endregion
            
        MantencionParametros Para = new MantencionParametros();

        protected void Page_Load(object sender, System.EventArgs e)
        {
            this.RecuperaSessionWeb();
            try
            {
                lbEstado.Text = Para.SP_AX_getEstadoBarra(_goSessionWeb.CODI_USUA);
            }
            catch{
                lbEstado.Text = "";
                lbEstado.Text = "Ha ocurrido un error, compruebe la conexión con el servidor de base de datos";
            }
        }
        protected void Timer1_Tick(object sender, EventArgs e)
        {

        }
      
    }

 