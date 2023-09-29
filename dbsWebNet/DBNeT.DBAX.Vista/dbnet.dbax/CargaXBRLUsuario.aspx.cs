using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.IO;
using System.Data;
using DBNeT.DBAX.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.Base.Controlador;
    
public partial class CargaXBRLUsuario : System.Web.UI.Page
{
    private string _gsModo = string.Empty, vRutaTempW = string.Empty, vNombArch = string.Empty, vCodiPers = string.Empty;
    private SessionWeb _goSessionWeb;
    private MantencionIndicadores vMantIndi = new MantencionIndicadores();
    private MantencionParametros para = new MantencionParametros();
    GuardarXBRL vGuarXBRL = new GuardarXBRL();
    private void RecuperaSessionWeb()
    {
        if (Session["sessionWeb"] == null)
        { Response.Redirect("~/dbnFw5/dbnLogin.aspx"); }
        else
        { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
    }
    public void GuardaSessionWeb()
    { Session["sessionWeb"] = _goSessionWeb; }
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
       // SysParamController _loSysaParam = new SysParamController();
        //var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_DEFE_TAXO", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        //this.lb_error.Text = string.Empty;
        VariablesSession Ses = new VariablesSession();
        Ses = (VariablesSession)Session["par1"];
        lb_error.Visible = false;
        //if (Ses != null)
        //{
        ////    Modo = "M";
        ////    CodiPers = Ses.CodiPers;
        ////    CorrInst = Ses.CorrInst;
        ////    CodiInfo = Ses.CodiInfo;
        ////    vTipoTaxo = Ses.TipoTaxo;
        ////    VersInst = GenExcel.getUltPersVersInst(CodiPers, CorrInst);
        //}
        //else
        //{
        //    //Modo = "I";
        //}
        if (!IsPostBack)
        {
            Response.Cache.SetExpires(DateTime.Now);
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetValidUntilExpires(false);
            fuXbrlUsua.Attributes.Add("onkeypress", "return false");
            fuXbrlUsua.Attributes.Add("onkeydown", "return false");
            //LlenarGrilla();
        }
        //else
        //{
            LlenarGrilla();
        //}
    }
    protected void Procesar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            string vMensErro;

            if (Path.GetExtension(fuXbrlUsua.FileName.ToLower()) == ".zip")
            {
                vRutaTempW = para.getPathWebb();
                if (!vRutaTempW.EndsWith(Path.DirectorySeparatorChar.ToString()))
                {
                    vRutaTempW += Path.DirectorySeparatorChar.ToString();
                }

                vRutaTempW += "temp\\";

                //if (!Directory.Exists(vRutaTempW))
                //Directory.CreateDirectory(vRutaTempW);
                fuXbrlUsua.PostedFile.SaveAs(vRutaTempW + fuXbrlUsua.FileName);

                vMensErro = vGuarXBRL.CargarXBRLExte(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), _goSessionWeb.CODI_USUA, vRutaTempW, fuXbrlUsua.FileName, chkIFRS13.Checked);

                if (vMensErro.Equals("1"))
                {
                    lb_error.Visible = true;
                    lb_error.Text = "El usuario no posee permisos para cargar el XBRL de esta empresa.";
                }
            }
            else 
            {
                lb_error.Visible = true;
                lb_error.Text = "Debe ingresar archivo *.zip";
            }
        }
        catch(Exception ex) {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
            lb_error.Text += "Ocurrió un error. Existen los directorios y objetos de DB";
        }
    }
    protected void LlenarGrilla()
    {
        Grilla_Empresas.DataSource = vGuarXBRL.GetEmpresaEstadoCargExte(_goSessionWeb.CODI_EMEX.ToString(), _goSessionWeb.CODI_EMPR.ToString(), _goSessionWeb.CODI_USUA);
        Grilla_Empresas.DataBind();
    }
    protected void Grilla_Empresas_desc_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Grilla_Empresas.PageIndex = e.NewPageIndex;
        Grilla_Empresas.DataBind();
        LlenarGrilla();
    }
}