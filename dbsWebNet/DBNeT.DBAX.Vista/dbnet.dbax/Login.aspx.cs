using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

public partial class Website_Login : System.Web.UI.Page
{
    private string usuario;
    private string pass;
    UsuarioSistema usua = new UsuarioSistema();
    protected void Page_Load(object sender, EventArgs e)
    {
        lb_aviso.Text = "";
    }
   
    protected void bt_conectar_Click(object sender, ImageClickEventArgs e)
    {
        MantencionParametros para = new MantencionParametros();
        usuario = tb_usuario.Text;
        pass = tb_clave.Text;
        Boolean existe = usua.getValidaUsuario(usuario, pass);
        if (existe == true)
        {
            FormsAuthenticationTicket tkt;
            String cook, sNombre;
            HttpCookie ck;
            sNombre = usuario;
            tkt = new FormsAuthenticationTicket( 1, sNombre, DateTime.Now, DateTime.Now.AddMinutes(Convert.ToInt32(para.getTiempoDeSession())), false, 1 + "");
            cook = FormsAuthentication.Encrypt(tkt);
            ck = new HttpCookie(FormsAuthentication.FormsCookieName, cook);
            Page.Response.Cookies.Add(ck);
            Session["usuario"] = usuario;
            Response.Redirect("Home.aspx");
        }
        else
        {
            lb_aviso.Text = "El usuario o la contraseña no son válidos";
        }
    }
}