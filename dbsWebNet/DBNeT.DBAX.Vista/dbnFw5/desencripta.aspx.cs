using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Framework.Seguridad;
public partial class dbnFw5_desencripta : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblDesencripta.Text = "Desencripta";
        lblEncripta.Text = "Encripta";
    }
    protected void btnEncripta_Click(object sender, EventArgs e)
    {
        lblEncriptaClave.Text =  Encriptacion.Encriptar(this.txtencripta.Text);
    }
    protected void btnDesencripta_Click(object sender, EventArgs e)
    {
        lbldesencriptaClave.Text =  Encriptacion.Desencriptar(this.txtdesencripta.Text);
    }
}