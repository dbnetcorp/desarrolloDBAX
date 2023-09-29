using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Controlador;
using DBNeT.Base.Framework.Seguridad;
using DBNeT.Base.Modelo;
using DBNeT.Base.Modelo.BE;
using Resources;
using DBNeT.Base.WebLibrary;

public partial class dbnLogin : System.Web.UI.Page
{
    LoginController _goLoginController;
    UsuaSistBE _goUsuasistBE;
    DbnetSesion _DbnetContext;
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
    private void ddlSelecciona(DropDownList ddl, string codigo)
    {
        int d = 0;
        if (codigo.Trim().Length > 0)
        {
            foreach (ListItem item in ddl.Items)
            {
                if (item.Value == codigo)
                { ddl.SelectedIndex = d; break; }
                else
                { d++; }
            }
        }
    }
    #endregion
    protected void Page_Load(object sender, EventArgs e)
    {
        FormsAuthentication.SignOut();
        _goSessionWeb = new SessionWeb();
        _goUsuasistBE = new UsuaSistBE();
        this._DbnetContext = new DbnetSesion();
        cargaMultilenguaje();
        if (!IsPostBack)
        {
            this.lblError.Text = string.Empty;
            //this.lblError2.Text = string.Empty;
            //this.lblError3.Text = string.Empty;
            //this.lblCaduca.Visible = false;
            //this.lblClaveNueva.Visible = false;
            //this.lblConfirmarClave.Visible = false;
            //this.txtClave1.Visible = false;
            //this.txtClave2.Visible = false;
            //this.btnActualizar.Visible = false;
        }
        this.txtUsuario.Focus();
    }

    private void cargaMultilenguaje()
    {
        this.lblUsuario.Text = multilenguaje_base.lblLoginUser;
        this.lblPassword.Text = multilenguaje_base.lblLoginPassword;
        //this.lblCaduca.Text = multilenguaje_base.lblLoginCaduca;
        //this.lblClaveNueva.Text = multilenguaje_base.lblLoginPasswordNew;
        //this.lblConfirmarClave.Text = multilenguaje_base.lblLoginPasswordConf;
    }
    protected void btnLogin_Click(object sender, ImageClickEventArgs e)
    {
        //this.lblError2.Text = string.Empty;
        //this.lblError.Text = string.Empty;
        //this.lblError3.Text = string.Empty;
        //this.lblCaduca.Text = string.Empty;
        _goLoginController = new LoginController();
        try
        {
            string errorUsuario = "";
            string errorPassword = "";
            string gsErrortxtUsuario = "";
            string gsErrorTxtPassword = "";
            bool lbValidaUsuario = validaUsuario(out errorUsuario);
            bool lbValidaPassword = _goUsuasistBE.validaPassword(Convert.ToInt32(this.txtPassword.Text.Trim().Length), Encriptacion.Encriptar(this.txtPassword.Text), _goSessionWeb.PASS_ENCR, out errorPassword);
            bool lbValidatxtUsuario = _goUsuasistBE.validatxtUsuario(this.txtUsuario.Text.Trim().Length, out gsErrortxtUsuario);
            bool lbValidatxtPassword = _goUsuasistBE.validatxtPassword(this.txtPassword.Text.Trim().Length, out gsErrorTxtPassword);
            string sessionwebCodiUsua = "";
            string error3 = "";
            if (lbValidatxtUsuario && lbValidatxtPassword)
            {
                if (lbValidaUsuario && lbValidaPassword)
                {
                    _goSessionWeb.CODI_USUA = this.txtUsuario.Text;
                    if (_goUsuasistBE.validaRous(_goLoginController.readModulo(_goSessionWeb.CODI_ROUS), _goLoginController.readRol(this.txtUsuario.Text), out sessionwebCodiUsua, this.txtUsuario.Text, out error3))
                    {
                        //_goSessionWeb.CODI_ROUS = sessionwebCodiUsua;
                        #region Usuario Caducado
                        if (_goLoginController.readEstadoUsuario(_goSessionWeb.CODI_USUA) == "S")
                        {
                            #region Fecha Vigencia Clave
                            if (_goLoginController.readFechaVigencia(_goSessionWeb.CODI_USUA) == "1")
                            {
                                int lnNumLetras, lnNumNumeros, lnLargo;
                                lnNumLetras = _goLoginController.readSecuNumeLetr();
                                lnNumNumeros = _goLoginController.readSecuNumeNume();
                                lnLargo = _goLoginController.readSecuLargMini();
                                //lblCaduca.Visible = true;
                                //lblCaduca.Text = "Su Clave Actual se encuentra Caducada, por favor cambie su contraseña completando los campos a continuación: ";
                                //lblCaduca.Text += "<br>Su Clave debe tener al menos " + lnNumLetras + "letra(s) </br>";
                                //lblCaduca.Text += +lnNumNumeros + " número(s) y un largo no inferior a " + lnLargo + " caracteres";

                                _goLoginController.createUsuaSistEven(_goSessionWeb.CODI_USUA, "CLCA", DateTime.Now.ToString());
                                _goLoginController.updateCaducaUsuario(_goSessionWeb.CODI_USUA, "S");

                                this.txtUsuario.Visible = false;
                                this.lblUsuario.Visible = false;
                                this.lblPassword.Text = multilenguaje_base.lblLoginPasswordActu;
                                //this.txtClave1.Visible = true;
                                //this.txtClave2.Visible = true;
                                //this.lblClaveNueva.Visible = true;
                                //this.lblConfirmarClave.Visible = true;
                                btnLogin.Visible = false;
                                //btnActualizar.Visible = true;
                            }
                            else
                            {
                                Decimal ldCorrSess = _goLoginController.readCorrSess(_goSessionWeb.CODI_USUA);
                                _goSessionWeb.CORR_SESS = ldCorrSess;

                                _goLoginController.updateErroLogi(_goSessionWeb.CODI_USUA);
                                _goLoginController.createUsuaSistEventCorrSess(_goSessionWeb.CORR_SESS, _goSessionWeb.CODI_USUA, "LOGI", DateTime.Now.ToString());

                                int liDiasAviso = _goLoginController.readSecuAvisExpi();
                                int liDiasRestantes = _goLoginController.readFechVigeUsua(_goSessionWeb.CODI_USUA);
                                if (liDiasRestantes <= liDiasAviso)
                                { Response.Write(@"<script language='javascript'>alert('En " + liDiasRestantes + " dia(s) mas su password caducara, recuerde cambiarla.')</script>"); }
                                this.GuardaSessionWeb();
                                FormsAuthentication.RedirectFromLoginPage(_goSessionWeb.CODI_USUA, false);
                                this.Response.Redirect("~/dbnet.dbax/Home.aspx");
                            }
                            #endregion
                        }
                        //Else VAlida Estado
                        else
                        {
                            _goLoginController.createUsuaSistEven(this.txtUsuario.Text, "USBL", DateTime.Now.ToString());
                            this.lblError.Text = "Ha excedido el número de intentos fallidos de ingreso. <br />Por seguridad este usuario ha sido bloqueado, contacte al administrador.";
                        }
                    }
                    #endregion
                    //Else Valida Rous
                    else
                    {//lblError3.Text = error3;
                    }
                }
                // Else Valida A && B
                else
                {
                    //lblError2.Text = errorUsuario;
                    //lblError3.Text = errorPassword;

                    _goLoginController.createUsuaSistEven(this.txtUsuario.Text,"LOGE",DateTime.Now.ToString());
                    #region VALIDA ERROR LOGUEO
                    if (_goLoginController.readSecuErroLogi(this.txtUsuario.Text) >= _goLoginController.readSecuErroBloq())
                    {
                        _goLoginController.updateActualizaEstadoUsuario(txtUsuario.Text, "N");
                        lblError.Text = "Ha Excedido el número de Intentos de Fallos de ingresos </br> <br>Por Seguridad  este usuario  a sido Bloqueado </br> Contacte al Administrador";
                        _goLoginController.createUsuaSistEven(this.txtUsuario.Text, "USBL", DateTime.Now.ToString());
                    }
                    else
                        _goLoginController.updateErroLogi2(this.txtUsuario.Text);
                    #endregion
                }
            }
            else
            {
                //lblError2.Text = gsErrortxtUsuario; lblError3.Text = gsErrorTxtPassword;
            }
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
        Session["oSessionWeb"] = _goSessionWeb;
    }
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        _goSessionWeb = (SessionWeb)Session["oSessionWeb"];
        _goLoginController = new LoginController();
        try
        {
            string lsLetras = "[a-zA-Z]", lsNumeros = "[0-9]";
            string lsNumPass = _goLoginController.readSecuRepePass();
            string lsPassRepe = "";
            string lsErrorPassword = "";
            int liNumLetras = _goLoginController.readSecuNumeLetr();
            int liNumNumeros = _goLoginController.readSecuNumeNume();
            int liLargMini = _goLoginController.readSecuLargMini();
            int liDiasVige = _goLoginController.readSecuDiasVige();

            bool lbValiPass = _goUsuasistBE.validaPassword(Convert.ToInt32(this.txtPassword.Text.Trim().Length), Encriptacion.Encriptar(this.txtPassword.Text), _goSessionWeb.PASS_ENCR, out lsErrorPassword);
            if (_goLoginController.readSecuErroLogi(this.txtUsuario.Text) <= _goLoginController.readSecuErroBloq())
            {
                //#region If Valida Contraseña
                //if (lbValiPass)
                //{
                //    if (/*txtClave1.Text.Trim() == txtClave2.Text.Trim()*/)
                //    {
                //        #region IF Verifica Contraseña con los parametros
                //        if ((Regex.Matches(this.txtClave1.Text, lsLetras).Count >= liNumLetras) && (Regex.Matches(this.txtClave1.Text, lsNumeros).Count >= liNumNumeros) && (this.txtClave1.Text.Trim().Length >= liLargMini))
                //        {
                //            lsPassRepe = _goLoginController.readSecuRepePass();
                //            if (lsPassRepe == "1")
                //            {
                //                lblError.Text += "<br>La clave ingresada ya fue usada en los ultimos " + lsNumPass;
                //                lblError.Text += " cambios de clave, ingrese una nueva.";
                //            }
                //            else
                //            {
                //                _goLoginController.createUsuaSistEven(this.txtUsuario.Text, "CCLU", DateTime.Now.ToString());
                //                _goLoginController.updatePassUsua(Encriptacion.Encriptar(this.txtClave1.Text), liDiasVige, this.txtUsuario.Text);
                //                Response.Redirect("~/dbnFw5/dbnLogin.aspx");
                //            }
                //        }
                //        #endregion
                //        #region ELSE Verifica Contraseña con los parametros
                //        else
                //        {
                //            lblError.Text = "La Clave Ingresada no se ajusta a las políticas  de seguridad <br /> ";
                //            lblError.Text += "Debe tener al Menos " + liNumLetras + " Letras,";
                //            lblError.Text += liNumNumeros + " números y un largo  no inferior a " + liLargMini + " caracteres";
                //        }
                //        #endregion
                //    }
                //    else
                //    { lblError.Text = "Las Contraseñas deben Coincidir."; }
                //}
                //#endregion
                #region Else Valida Contraseña
                //else
                //{
                //    _goLoginController.updateErroLogi2(this.txtUsuario.Text);
                //    //this.lblError3.Text = lsErrorPassword;
                //}
                #endregion
            }
            else
            {
                _goLoginController.createUsuaSistEven(this.txtUsuario.Text, "CCLU", DateTime.Now.ToString());
                lblError.Text += "Ha Excedido  el número de intentos fallidos de ingreso, <br>  Por su Seguridad este usuario a sido Bloqueado,</br> <br>Contacte al Administrador</br>";
            }
        }
        catch (Exception)
        { /*lblError3.Text = ex.Message; */}
    }
    private bool validaUsuario(out string psError)
    {
        string lsError = "";
        bool lbUsuario = false;
        _goLoginController = new LoginController();
        if (this.txtUsuario.Text.Trim().Length > 0)
        {
            var lista = _goLoginController.readUsuario(this.txtUsuario.Text.Trim());
            _goSessionWeb.CODI_USUA = lista.CODI_USUA;
            _goSessionWeb.PASS_ENCR = lista.PASS_ENCR;
            _goSessionWeb.CODI_CECO = lista.CODI_CECO;
            _goSessionWeb.CODI_EMEX = lista.CODI_EMEX;
            _goSessionWeb.CODI_EMPR = lista.CODI_EMPR;
            _goSessionWeb.CODI_MODU = lista.CODI_MODU;
            _goSessionWeb.CODI_CULT = lista.CODI_CULT;
            _goSessionWeb.CODI_ROUS = lista.CODI_ROUS;
            _goSessionWeb.NOMB_EMPR = lista.NOMB_EMPR;
            _goSessionWeb.P_EXIS = lista.P_EXIS;
            _goSessionWeb.P_MENS = lista.P_MENS;

            _DbnetContext.Codi_usua = lista.CODI_USUA;
            _DbnetContext.Pass_usua = lista.PASS_ENCR;
            _DbnetContext.Codi_ceco = lista.CODI_CECO;
            _DbnetContext.Codi_emex = lista.CODI_EMEX;
            _DbnetContext.Codi_empr = lista.CODI_EMPR;
            _DbnetContext.Codi_modu = lista.CODI_MODU;
            _DbnetContext.Codi_rous = lista.CODI_ROUS;
            _DbnetContext.Nomb_Empr = lista.NOMB_EMPR;

            

            Session["contexto"] = _DbnetContext;
            if (_goSessionWeb.P_EXIS != null)
            {
                if (this.txtUsuario.Text == lista.CODI_USUA)
                    lbUsuario = true;
                else
                { lsError = "Usuario Inválido"; lbUsuario = false; }
            }
            else
                lsError = "No existe este usuario";
        }
        else
            lsError = "El Campo usuario no tiene caracteres";

        psError = lsError;
        return lbUsuario;
    }
}