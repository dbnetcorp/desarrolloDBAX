using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;
using DBNeT.DBAX.Controlador;
using System.IO;

public partial class DBAX_dbax_ejec_proc : System.Web.UI.Page
{
    #region Pagina Base
    private string _gsModo = string.Empty;
    private SessionWeb _goSessionWeb;
    private GuardarXBRL vGuarXBRL = new GuardarXBRL();
      Conexion con = new Conexion().CrearInstancia();
     ComparacionXBRL vComp = new ComparacionXBRL();
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
    MantencionParametros para = new MantencionParametros();
    dbax_dbne_procController _goDbaxDbneProc;
    protected void Page_Load(object sender, EventArgs e)
    {
        this.lblTitulo.Text = "Ejecución de Procesos";
        this.RecuperaSessionWeb();
   
        if (!IsPostBack)
        {
     
            
        }
        LlenarGrilla();
    }
    protected void rbtCarga_CheckedChanged(object sender, EventArgs e)
    {
        if (rbtSubir.Checked == true)
        { cargaxbrl.Visible = true;
        Label.Visible = true;
        Grilla_Subir.Visible = true;
        LlenarGrilla();
        Mensaje.Text = "";
       
         
        }
        else
        { cargaxbrl.Visible = false;
        Label.Visible = false;
        }


    }
    protected void btnActualizar_Click(object sender, ImageClickEventArgs e)
    {
        SysParamController _loSysaParam = new SysParamController();
        _goDbaxDbneProc = new dbax_dbne_procController();

        try
        {
            if (rbtSubir.Checked)
            {
                if (FileUpload1.FileName.Trim().Length != 0 && (Path.GetExtension(FileUpload1.FileName.ToLower()) == ".zip"))
                {
                    string lsNombreArchivo = FileUpload1.FileName;
                   //var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_XBRL_PATH", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                  // FileUpload1.SaveAs(loResultado.PARAM_VALUE + "\\" + lsNombreArchivo);
                   String vRutaTempW = para.getPathWebb();
                   if (!vRutaTempW.EndsWith(Path.DirectorySeparatorChar.ToString()))
                   {
                       vRutaTempW += Path.DirectorySeparatorChar.ToString();
                   }

                   vRutaTempW += "temp\\";

                   // GuardarXBRL vGuarXBRL = new GuardarXBRL();

                    FileUpload1.PostedFile.SaveAs(vRutaTempW + FileUpload1.FileName);
                    

                   string pRutaTemppDireXbrl = ""; //ME entrega el directorio donde queda descomprimido el XBRL o me devuelve 1 en caso que no tenga permisos
                   pRutaTemppDireXbrl = vGuarXBRL.ValidaPermisoXBRLExte(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), _goSessionWeb.CODI_USUA, vRutaTempW, FileUpload1.FileName);
                   System.IO.File.Delete(pRutaTemppDireXbrl + "\\" + FileUpload1.FileName);
 //*******************************************************************************************************************************************************************************************************************
                   string sXBRL64;
                   //vGuarXBRL.CargarArchXml(pRutaTemppDireXbrl);                         
                   foreach (string vFile in Directory.GetFileSystemEntries(pRutaTemppDireXbrl, "*.xbrl"))
                   {
                    
                       sXBRL64 = con.StringEjecutarQuery(vComp.GetBase64XBRL(pRutaTemppDireXbrl.Substring(pRutaTemppDireXbrl.LastIndexOf("\\") + 1, 9), pRutaTemppDireXbrl.Substring(pRutaTemppDireXbrl.LastIndexOf("_") + 1, 6), vFile.Substring(vFile.LastIndexOf("\\") + 1)));
                       if (vComp.VerificarXBRL(vFile, sXBRL64))
                       {
                           Mensaje.Text = "";
                           var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_XBRL_BINA", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                           var loResultadoCMD = "dbax.ComparaXBRL.exe";

                           _goDbaxDbneProc.prc_create_dbne_proc(loResultado.PARAM_VALUE + "\\" + loResultadoCMD.ToString(), "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX, "execCMD");

                          // Mensaje.ForeColor = System.Drawing.Color.Green;
                          // Mensaje.Text = "Archivo Subido Correctamente";

                       }
                       else
                       {

                           Mensaje.ForeColor = System.Drawing.Color.Red;
                           Mensaje.Text = "Este Archivo fue Ingresado Anteriormente.";
                       }
                   }
                }
                else
                {
                    Mensaje.ForeColor = System.Drawing.Color.Red;
                    Mensaje.Text = "Debe ingresar archivo *.zip";
                }

//********************************************************************************************************************************************************************************************************************                   
                   
           
            }
            else if (rbtEjecuta.Checked)
            {
                var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_XBRL_BINA", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                var loResultadoCMDVida = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_ETLL_VIDA", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                var loResultadoCMDGene = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_ETLL_GENE", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);

                _goDbaxDbneProc.prc_create_dbne_proc(loResultado.PARAM_VALUE + "\\" + loResultadoCMDGene.PARAM_VALUE, "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX, "execCMD");
                _goDbaxDbneProc.prc_create_dbne_proc(loResultado.PARAM_VALUE + "\\" + loResultadoCMDVida.PARAM_VALUE, "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX, "execCMD");
            }
            else if (rbtRescata.Checked)
            {
                var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_XBRL_BINA", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                var loResultadoCMD = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_RESC_XBRL", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);

                _goDbaxDbneProc.prc_create_dbne_proc(loResultado.PARAM_VALUE + "\\" + loResultadoCMD.PARAM_VALUE, "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX, "execCMD");
            }
        }
        catch (Exception ex)
        {
            Mensaje.ForeColor = System.Drawing.Color.Red;
            Mensaje.Text = "Ha Ocurrido un problema, Avise a su Administrador del Servicio "+ex.ToString();
        }
    }
    protected void LlenarGrilla()
    {
         Grilla_Subir.DataSource = vGuarXBRL.GetEmpresaEstadoCargExte(_goSessionWeb.CODI_EMEX.ToString(), _goSessionWeb.CODI_EMPR.ToString(), _goSessionWeb.CODI_USUA);
        Grilla_Subir.DataBind();
    }

    protected void Grilla_Subir_desc_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Grilla_Subir.PageIndex = e.NewPageIndex;
        Grilla_Subir.DataBind();
        LlenarGrilla();
    }

}