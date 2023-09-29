using System;
using System.IO;
using Resources;
using System.Text;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Modelo;

public partial class dbnFw5Listador : System.Web.UI.Page
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
        { Response.Redirect("~/dbnFw5/dbnSesionExpirada.aspx", true); }
        else
        { _goSessionWeb = (SessionWeb)Session["sessionWeb"]; }
    }
    private void GuardaSessionWeb()
    { Session["sessionWeb"] = _goSessionWeb; }
    #endregion
    //Clases Controller
    ListadorController _goListadorController;
    DbnListColuController _goDbnlistcoluController;
    DbnListRepoController _goDbnlistrepoController;
    DbnListBotoController _goDbnlistbotoController;
    DbnRepoRousController _goDbnreporousController;
    DbnListErroController _goDbnListErroController;
    ValiErro _goValiErro;
    DataTable _gdDatosTabla = new DataTable();
    DataTable _gdDatosTablaTabular = new DataTable();
    //Clases BE
    DbnListBotoBE _goDbnlistbotoBE;
    CamposDinamicos _goBtnDinamicos;
    //Lista de Boton
    List<DbnListBotoBE> _gaBoton;
    //Lista de Reporte
    DbnListRepoBE _goReporte;
    //Lista de Columna
    List<DbnListColuBE> _gaColumna;
    //Lista de Nombres de TextBox
    List<CamposDinamicos> _gaBotonesDinamicos;
    //Session
    SesionListador _goSesionListador;
    string _gsProcRepo = string.Empty;
    string _gsTipoRepo = string.Empty;
    int _giAnchoGrilla = 0;
    //public event EventHandler chkSelect_CheckChanged;




    #region Funciones de Sesion Listador
    private void RecuperaSesionListador()
    {
        _goSesionListador = (SesionListador)Session["listadorFw5"];
        if (_goSesionListador == null)
        {
            this.ddlRegPag.SelectedValue = "10";
            _goSesionListador = new SesionListador();
            _goSesionListador.CargaNuevo(Request.QueryString["listado"], "1", this.modo(), this.ddlRegPag.SelectedValue);
            Session["listadorFw5"] = _goSesionListador;
        }
        else
        {
            if (Request.QueryString["listado"] != _goSesionListador.Actual.psListador)
            {
                _goSesionListador.Limpiar();
                this.ddlRegPag.SelectedValue = "10";
                _goSesionListador.CargaNuevo(Request.QueryString["listado"], "1", this.modo(), this.ddlRegPag.SelectedValue);
                Session["listadorFw5"] = _goSesionListador;
            }

            try
            {
                // Cambia la imagen cuando es un listado de que viene de otro listado papá
                if (_goSesionListador.iNivel > 1)
                    btnVolver.ImageUrl = "~/librerias/img/botones/page_volver.png";
            }
            catch { }
        }
    }
    void GuardaSesionListador()
    { Session["listadorFw5"] = _goSesionListador; }
    #endregion
    protected void Page_Load(object sender, EventArgs e)
    {
        // Recupera Session Siempre en El Load Debe Ir Primero
        RecuperaSesionListador();
        this.lblError.Text = string.Empty;
        this.lblCorrect.Text = string.Empty;
        RecuperaSessionWeb();
        Session["tsListado"] = Request.Params["listado"].ToString().ToUpper();
        _goSesionListador.Actual.psListador = Session["tsListado"].ToString().ToUpper();
        #region Carga de Botones segun Modo
        if (modo() != null)
        {
            _gsModo = modo();
            if (_gsModo.ToUpper() == "M" || _gsModo.ToUpper() == "CI")
            { this.btnAgregar.Visible = true; }
            else if (_gsModo.ToUpper() == "T")
            { ckbTranspuesto.Checked = true; this.ddlRegPag.SelectedValue = "1"; this.ddlRegPag.Enabled = false; }
            //Permisos Exportacion Excel Esconder
            _goDbnreporousController = new DbnRepoRousController();
            var _valida = _goDbnreporousController.readRepoRous("", 0, 0, "", _goSessionWeb.CODI_MODU, _goSessionWeb.CODI_ROUS, _goSesionListador.Actual.psListador, "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            if (_valida.EXPT_EXLS == "S")
            { this.btnExcel.Visible = false; }

            this.cargaBotonSP();
        }
        #endregion
        #region !IsPostBack
        if (!IsPostBack)
        {
            //Agregar validcacion si ROL tiene permisos para ver LISTADOR
            //_goDbnreporousController = new DbnRepoRousController();
            //var _valida = _goDbnreporousController.readRepoRous("", 0, 0, "", _goSessionWeb.CODI_MODU, _goSessionWeb.CODI_ROUS, "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            if (true)
            {
                try
                {
                    CargaDdlModuloCheck(Session["tsListado"].ToString());
                    Session["tsListado"] = _goSesionListador.Actual.psListador;
                    Session["tsBusqueda"] = "";
                    txtBusquedaAutoComplete1.Visible = false;
                    autoCompleteDropDownPanel1.Visible = false;

                    if (ckbTranspuesto.Checked)
                        this.ddlRegPag.SelectedValue = "1";
                    else
                        this.ddlRegPag.SelectedValue = _goSesionListador.Actual.psCantidad;

                    //this.pnlPadreBusqueda.Visible = true;
                    this.lblPaginaActual.Text = _goSesionListador.Actual.psPagina;
                    this.cargaReporteSP(int.Parse(this.lblPaginaActual.Text), int.Parse(this.ddlRegPag.SelectedValue), Session["tsBusqueda"].ToString(), _goSesionListador.Actual.psVal1, _goSesionListador.Actual.psVal2, _goSesionListador.Actual.psVal3, _goSesionListador.Actual.psVal4, _goSesionListador.Actual.psVal5);
                    //this.pnlPadreBusqueda.Visible = false;
                }
                catch (Exception ex)
                { lblError.Text = ex.Message.ToString(); }
            }
            else
            { 
                lblError.Text = "No posee permisos para ver el Informe, consulte al administrador"; 
            }

        }
        else
        { this.cargaReporteSP(); }
        #endregion
        this.cargaColumnaSP();
        this.cargaMultilenguaje();
        
    }

    private string modo()
    {
        string _lsModo = null;
        if (Request.Params["modo"] == null || Request.Params["modo"] == string.Empty)
        {
            _goDbnlistrepoController = new DbnListRepoController();
            var loResultado = _goDbnlistrepoController.readReporteBE("C", 0, 0, null, Request.Params["listado"].ToString().ToUpper(), null, null, null, null, null, 0, null);
            _lsModo = loResultado.MODO;
            if (_lsModo == "") _lsModo = "C";
        }
        else
        { _lsModo = Request.Params["modo"].ToString(); }
        return _lsModo;
    }
    //Carga Los Datos de la Table DBN_LIST_REPO
    private void cargaReporteSP()
    {
        this.cargaReporteSP(Convert.ToInt32(this.lblPaginaActual.Text), Convert.ToInt32(this.ddlRegPag.SelectedValue), Session["tsBusqueda"].ToString());
    }
    private void cargaReporteSP(int liPagina, int liRegPag, string lsCondicion)
    {
        this.cargaReporteSP(liPagina, liRegPag, lsCondicion, _goSesionListador.Actual.psVal1, _goSesionListador.Actual.psVal2, _goSesionListador.Actual.psVal3, _goSesionListador.Actual.psVal4, _goSesionListador.Actual.psVal5);
    }
    private void cargaReporteSP(int liPagina, int liRegPag, string lsCondicion, string lsPar1, string lsPar2, string lsPar3, string lsPar4, string lsPar5)
    {
        try
        {
            Session.Remove("LsProcRepo");
            _goListadorController = new ListadorController();
            _goDbnlistrepoController = new DbnListRepoController();
            #region Lista de reporte
            // Se Obtiene la definicion de Reporte desde una Coleccion
            _goReporte = _goDbnlistrepoController.readReporteBE("C", 0, 0, null, Session["tsListado"].ToString(), null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);

            if (_goReporte.PROC_REPO != string.Empty)
            { _gsProcRepo = _goReporte.PROC_REPO; _gsTipoRepo = "PROC"; }
            else if (_goSessionWeb.BASE_DATO == "SQLSERVER")
            { _gsProcRepo = _goReporte.SCRP_SQLS; _gsTipoRepo = "QRY"; }
            else if (_goSessionWeb.BASE_DATO == "ORACLE")
            { _gsProcRepo = _goReporte.SCRP_SQLO; _gsTipoRepo = "QRY"; }
            this.lblTitulo.Text = multilenguaje_base.ResourceManager.GetString(_goReporte.CODI_RESX);
            if (this.lblTitulo.Text == "")
                this.lblTitulo.Text = _goReporte.TITU_REPO;

            //Agrega el subtitulo a los reportes que son de detalle y tenga consulta SQL
            if (_goReporte.SUBT_CNTX.Trim().Length != 0)
            {
                try
                {
                    string lsQuery = _goReporte.SUBT_CNTX.Replace(":P_PAR1", _goSesionListador.Actual.psVal1).Replace(":P_PAR2", _goSesionListador.Actual.psVal2).Replace(":P_PAR3", _goSesionListador.Actual.psVal3).Replace(":P_PAR4", _goSesionListador.Actual.psVal4).Replace(":P_PAR5", _goSesionListador.Actual.psVal5).Replace(":P_CODI_EMEX", _goSessionWeb.CODI_EMEX.ToString()).Replace(":P_CODI_EMPR", _goSessionWeb.CODI_EMPR.ToString()).Replace(":P_CODI_USUA", _goSessionWeb.CODI_EMPR.ToString());
                    var loResultado = _goDbnlistrepoController.ejecutaSubtitulo(lsQuery);
                    lblSubtitulo.Text = loResultado.Rows[0][0].ToString();
                }
                catch
                { lblSubtitulo.Text = string.Empty; }
            }
            #endregion

            #region Enlace De Datos par Grilla
            try
            {
                //Se ejecuta el procedimiento del listado a ejecutar
                if (lsCondicion.Trim().Length == 0)
                    _gdDatosTabla = _goListadorController.readListador(_gsTipoRepo, _gsProcRepo, "L", liPagina, liRegPag, null, lsPar1, lsPar2, lsPar3, lsPar4, lsPar5, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                else
                    _gdDatosTabla = _goListadorController.readListador(_gsTipoRepo, _gsProcRepo, "L", liPagina, liRegPag, lsCondicion, lsPar1, lsPar2, lsPar3, lsPar4, lsPar5, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            }
            catch (Exception ex)
            {
                lblError.Text = "Problemas al ejecutar informe, consulte al administrador";
                _goDbnListErroController = new DbnListErroController();
                _goDbnListErroController.DbnlistRepoErroUpdate(ex.Message.ToString(), _goSesionListador.Actual.psListador);
                //lblError.Text = ex.Message.ToString();
            }

            #region Se rescata los totales de paginas del encabezado
            if (_gdDatosTabla.Rows.Count > 0)
            {
                DataRow item = _gdDatosTabla.Rows[0];
                int lnTotReg = Convert.ToInt32(item["TOT_REG"]);
                int lnRegPag = Convert.ToInt32(this.ddlRegPag.SelectedValue);
                int lnTotPag = Convert.ToInt32(lnTotReg / lnRegPag);
                if (lnTotReg % lnRegPag > 0)
                    lnTotPag++;

                lblTotalPaginas.Text = lnTotPag.ToString();
                lblPaginaActual.Text = liPagina.ToString();
                lblTotalRegistros.Text = lnTotReg.ToString();
            }
            else
            {
                lblTotalPaginas.Text = "1";
                lblPaginaActual.Text = "1";
                lblTotalRegistros.Text = "0";
            }
            #endregion
            #endregion

            // Se asignan datos a la Grilla
            Session["dtGrilla"] = _gdDatosTabla;
            #region Transponer Datos
            if (ckbTranspuesto.Checked)
            {
                _gdDatosTablaTabular = _gdDatosTabla.Copy();
                //Se remueven las columnas que no se van a ocupar
                _gdDatosTabla.Columns.Remove("TOT_REG");
                //Recupero las columnas para eliminarlas del DataTable
                _goDbnlistcoluController = new DbnListColuController();
                var Columnas = _goDbnlistcoluController.readColumas("C", 0, 0, "", Session["tsListado"].ToString(), "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);

                ListadorModel listadorModelo = new ListadorModel();
                _gdDatosTabla = listadorModelo.EliminarColumnas(Columnas, _gdDatosTabla).Copy();

                // Elimina las columnas marcadas sin marca de visible, en listados traspuestos
                for (int i = 0; i < Columnas.Count; i++)
                {
                    if (Columnas[i].INDI_VISI == "0" && _gdDatosTabla.Columns.IndexOf(Columnas[i].NOMB_COLU) > 1)
                    {
                        _gdDatosTabla.Columns.Remove(Columnas[i].NOMB_COLU);
                    }
                }

                _gdDatosTabla.Columns[0].ColumnName = "VALOR";
                //se transpone el datatable
                _gdDatosTabla = DBNeT.Base.Modelo.TrasponerDT.Transponer2(_gdDatosTabla).Copy();
                _gdDatosTabla.Columns[0].ColumnName = "Campo";
                _gdDatosTabla.Columns[1].ColumnName = "Valor";

                grilla.Visible = false;
                grillaTabular.Visible = true;
                grillaTabular.DataSource = _gdDatosTabla;
                grillaTabular.DataBind();
            }
            #endregion
            else
            {
                grilla.Visible = true; grilla.DataSource = _gdDatosTabla; grilla.DataBind();
                this.btnEditarTabular.Visible = false; this.btnDetalleTabular1.Visible = false; this.btnEjecutarTabular.Visible = false;
            }
        }
        catch (Exception ex)
        { lblError.Visible = true; lblError.Text = ex.Message; }
    }

    private void cargaReporteExcel(int liPagina, int liRegPag, string lsCondicion, string lsPar1, string lsPar2, string lsPar3, string lsPar4, string lsPar5)
    {
        DataTable dt;
        _goListadorController = new ListadorController();
        _goDbnlistrepoController = new DbnListRepoController();
        #region Lista de reporte
        // Se Obtiene la definicion de Reporte desde una Coleccion
        _goReporte = _goDbnlistrepoController.readReporteBE("C", 0, 0, lsCondicion, Session["tsListado"].ToString(), lsPar2, lsPar3, lsPar4, lsPar5, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        if (_goReporte.PROC_REPO != string.Empty)
        { _gsProcRepo = _goReporte.PROC_REPO; _gsTipoRepo = "PROC"; }
        else
        { }
        this.lblTitulo.Text = multilenguaje_base.ResourceManager.GetString(_goReporte.CODI_RESX);
        if (this.lblTitulo.Text == "")
            this.lblTitulo.Text = _goReporte.TITU_REPO;
        #endregion|

        #region Enlace De Datos par Grilla
        // Se ejecuta el procedimiento del listado a ejecutar
        if (lsCondicion.Trim().Length == 0)
            dt = _goListadorController.readListador(_gsTipoRepo, _gsProcRepo, "L", liPagina, liRegPag, "", lsPar1, lsPar2, lsPar3, lsPar4, lsPar5, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        else
            dt = _goListadorController.readListador(_gsTipoRepo, _gsProcRepo, "L", liPagina, liRegPag, lsCondicion, lsPar1, lsPar2, lsPar3, lsPar4, lsPar5, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        // Se rescata los totales de paginas del encabezado
        if (dt.Rows.Count > 0)
        {
            DataRow item = dt.Rows[0];
            int PAG_MAX = Convert.ToInt32(item["PAG_MAX"].ToString());
            int lnModulo = (Convert.ToInt32(item["TOT_REG"].ToString()) % Convert.ToInt32(this.ddlRegPag.SelectedValue));

            if (lnModulo >= 1)
            {
                if (PAG_MAX == 0)
                { lblTotalPaginas.Text = "1"; }
                else
                { lblTotalPaginas.Text = (PAG_MAX + 1).ToString(); }
            }
            else
            { lblTotalPaginas.Text = PAG_MAX.ToString(); }
            lblTotalRegistros.Text = item["TOT_REG"].ToString();
        }
        else
        {
            lblTotalPaginas.Text = "1";
            lblPaginaActual.Text = "1";
            lblTotalRegistros.Text = "0";
        }
        #endregion
        // Se asignan datos a la Grilla
        grillaExport.DataSource = dt;
        grillaExport.DataBind();
    }
    private DataTable CargaReporteSP(int liPagina, int liRegPag, string lsCondicion, string lsPar1, string lsPar2, string lsPar3, string lsPar4, string lsPar5)
    {
        Session.Remove("LsProcRepo");
        DataTable dt;
        _goListadorController = new ListadorController();
        _goDbnlistrepoController = new DbnListRepoController();
        #region Lista de reporte
        // Se Obtiene la definicion de Reporte desde una Coleccion
        _goReporte = _goDbnlistrepoController.readReporteBE("C", 0, 0, null, Session["tsListado"].ToString(), null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);

        Session["LsProcRepo"] = _goReporte.PROC_REPO;
        this.lblTitulo.Text = multilenguaje_base.ResourceManager.GetString(_goReporte.CODI_RESX);
        if (this.lblTitulo.Text == "")
            this.lblTitulo.Text = _goReporte.TITU_REPO;
        #endregion|

        #region Enlace De Datos par Grilla
        // Se ejecuta el procedimiento del listado a ejecutar
        if (lsCondicion.Trim().Length == 0)
            dt = _goListadorController.readListador(_gsTipoRepo, _gsProcRepo, "L", liPagina, liRegPag, "", lsPar1, lsPar2, lsPar3, lsPar4, lsPar5, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        else
            dt = _goListadorController.readListador(_gsProcRepo, _gsProcRepo, "L", liPagina, liRegPag, lsCondicion, lsPar1, lsPar2, lsPar3, lsPar4, lsPar5, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        // Se rescata los totales de paginas del encabezado
        #endregion
        // Se asignan datos a la Grilla
        return dt;
    }
    //Carga Boton y columna
    private void cargaBotonSP()
    {
        _gaBoton = new List<DbnListBotoBE>();
        _goDbnlistbotoController = new DbnListBotoController();
        _gaBoton = _goDbnlistbotoController.readBotones("C1", 0, 0, "", Session["tsListado"].ToString(), null, _gsModo, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        #region Foreach para Asignar Los datos de la Lista a la BE
        string str = "";
        string str2 = "";
        int i = 0;
        _giAnchoGrilla = 0;
        foreach (var liBotonesBE in _gaBoton)
        {
            if (!ckbTranspuesto.Checked)
            {
                if (liBotonesBE.NOMB_BOTO == "btnEliminar")
                {
                    grilla.Columns[0].Visible = true;
                    grilla.Width =  + 30;
                }
                else if (liBotonesBE.NOMB_BOTO == "btnCheck") //Check
                {

                    if (liBotonesBE.INDI_VISI == "1")
                    {
                        btnchkProcesar.Visible = true;
                        ddlListaEje.Visible = true;
                    }
                    else if (liBotonesBE.INDI_VISI == "0")
                    { }

                }
                else
                {
                    ButtonField btnField = new ButtonField();
                    btnField.ButtonType = ButtonType.Image;
                    btnField.DataTextField = liBotonesBE.CODI_PAR1;
                    btnField.ImageUrl = "~/librerias/img/botones/" + liBotonesBE.IMAG_BOTO;
                    btnField.CommandName = liBotonesBE.NOMB_BOTO + "-" + liBotonesBE.CODI_BOTO;
                    btnField.ControlStyle.CssClass = liBotonesBE.CLAS_CSS + "-" + liBotonesBE.CODI_BOTO;
                    if (liBotonesBE.INDI_VISI == "1")
                    {
                        btnField.Visible = true;
                        _giAnchoGrilla = _giAnchoGrilla + 20;
                    }
                    else if (liBotonesBE.INDI_VISI == "0")
                        btnField.Visible = false;
                    grilla.Columns.Add(btnField);
                }
                str += "$(\"." + liBotonesBE.CLAS_CSS + "-" + liBotonesBE.CODI_BOTO + "\").attr(\"title\", \"" + liBotonesBE.DESC_BOTO + "\");";
                grilla.DataBind();
            }
            else
            { CargaBotonesTranspuesto(liBotonesBE, i, out str2); i++; str += str2; }
        }

        if (btnchkProcesar.Visible)
        {grilla.Columns[0].Visible = true;}
        else
        {grilla.Columns[0].Visible = false;}

        Page.ClientScript.RegisterClientScriptBlock(GetType(), "tittle", "<script> $(function () { " + str + "}) </script>");
        #endregion
    }

    private void cargaColumnaSP()
    {
        _gaColumna = new List<DbnListColuBE>();
        _gaBotonesDinamicos = new List<CamposDinamicos>();
        _goDbnlistcoluController = new DbnListColuController();
        _gaColumna = _goDbnlistcoluController.readColumas("C", 0, 0, "", Session["tsListado"].ToString(), "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        //Tabla Creada a travez del CODE-BEHIND
        Table tbl = new Table();
        int liCb = 0;
        int liFF = 0;
        foreach (var liColumnaBE in _gaColumna)
        {
            #region Texto (Bounfield)
            if (liColumnaBE.TIPO_COLU == "texto")
            {
                #region Creación de Columnas y asignación de Propiedades
                BoundField lbfColumna;
                lbfColumna = new BoundField();

                //Se Asgina El Archivo de Recurso, Sino se encuentra se Remplaza por el Nombre Ingresado en La BD
                lbfColumna.HeaderText = multilenguaje_base.ResourceManager.GetString(liColumnaBE.CODI_RESX);
                if (lbfColumna.HeaderText.Trim().Length == 0)
                { lbfColumna.HeaderText = liColumnaBE.NOMB_COLU; }

                //Código de Columna
                lbfColumna.DataField = liColumnaBE.CODI_COLU;
                //Ancho de la Columna
                lbfColumna.ItemStyle.Width = int.Parse(liColumnaBE.ANCH_COLU);
                //Clase de Hoja de Estilo
                lbfColumna.ItemStyle.CssClass = liColumnaBE.CLAS_CSS;
                //Formato Aca estaba el maldito poblema de ORACLE AHI QUE ASIFNAR FORMATO A LAS COLUMNAS.
                lbfColumna.DataFormatString = liColumnaBE.FORM_COLU;
                //lbfColumna.ItemStyle.Height = 26;
                // Alineacion
                if (liColumnaBE.ALIN_COLU == "L")
                { lbfColumna.ItemStyle.HorizontalAlign = HorizontalAlign.Left; }
                else if (liColumnaBE.ALIN_COLU == "C")
                { lbfColumna.ItemStyle.HorizontalAlign = HorizontalAlign.Center; }
                else if (liColumnaBE.ALIN_COLU == "R")
                { lbfColumna.ItemStyle.HorizontalAlign = HorizontalAlign.Right; }
                else if (liColumnaBE.ALIN_COLU == "J")
                { lbfColumna.ItemStyle.HorizontalAlign = HorizontalAlign.Justify; }
                #endregion
                #region Componentes de Buscador Dinamico
                if (liColumnaBE.INDI_BUSQ == "1")
                {
                    //Se Crea un TableRow por cada Registro 
                    TableRow tblR = new TableRow();
                    //Se Crea un TableCell por cada Registro, el tblC1 es para los Label
                    TableCell tblC1 = new TableCell();
                    //Se Crea un TableCell por cada Registro, el tblC1 es para los Textbox o Otros controles 
                    TableCell tblC2 = new TableCell();
                    //Se Crea un TableCell por cada Registro, el TblC3 es para los Buscadores con la Clausula Between
                    TableCell tblC3 = new TableCell();
                    tblC1.Width = 80;
                    tblC2.Width = 150;
                    tblC3.Width = 150;
                    #region TIPO_BUSQ == S
                    if (liColumnaBE.TIPO_BUSQ == "S" && liColumnaBE.INDI_BUSQ == "1")
                    {
                        _goBtnDinamicos = new CamposDinamicos();
                        _goBtnDinamicos.TIPO_COLU = "S";
                        Label lblIndiBusq = new Label();
                        lblIndiBusq.Text = liColumnaBE.NOMB_COLU;
                        lblIndiBusq.CssClass = "lblIzquierdo";
                        tblC1.Controls.Add(lblIndiBusq);

                        TextBox txt = new TextBox();
                        _goBtnDinamicos.ID_TXT = "txtBusq" + liColumnaBE.CODI_COLU;
                        txt.ID = _goBtnDinamicos.ID_TXT;
                        _goBtnDinamicos.COLU_BUSQ = liColumnaBE.COLU_BUSQ;
                        txt.CssClass = "dbnTextboxIzquierda";
                        _goBtnDinamicos.TIPO_CONT = "TXT";
                        tblC2.Controls.Add(txt);

                        _gaBotonesDinamicos.Add(_goBtnDinamicos);
                    }
                    #endregion
                    #region TIPO_BUSQ == N
                    if (liColumnaBE.TIPO_BUSQ == "N" && liColumnaBE.INDI_BUSQ == "1")
                    {
                        _goBtnDinamicos = new CamposDinamicos();
                        _goBtnDinamicos.TIPO_COLU = "N";
                        Label lblIndiBusq = new Label();
                        lblIndiBusq.Text = liColumnaBE.NOMB_COLU;
                        lblIndiBusq.CssClass = "lblIzquierdo";
                        tblC1.Controls.Add(lblIndiBusq);

                        TextBox txt = new TextBox();
                        _goBtnDinamicos.ID_TXT = "txtBusq" + liColumnaBE.CODI_COLU;
                        txt.ID = _goBtnDinamicos.ID_TXT;
                        _goBtnDinamicos.COLU_BUSQ = liColumnaBE.COLU_BUSQ;
                        txt.CssClass = "dbnTextboxNumerico";
                        _goBtnDinamicos.TIPO_CONT = "TXT";
                        tblC2.Controls.Add(txt);

                        _gaBotonesDinamicos.Add(_goBtnDinamicos);
                    }
                    #endregion
                    #region TIPO_BUSQ == NN
                    if (liColumnaBE.TIPO_BUSQ == "NN" && liColumnaBE.INDI_BUSQ == "1")
                    {
                        _goBtnDinamicos = new CamposDinamicos();
                        _goBtnDinamicos.TIPO_COLU = "NN";
                        Label lblIndiBusq = new Label();
                        lblIndiBusq.Text = liColumnaBE.NOMB_COLU;
                        lblIndiBusq.CssClass = "lblIzquierdo";
                        tblC1.Controls.Add(lblIndiBusq);

                        TextBox txt = new TextBox();
                        _goBtnDinamicos.ID_TXT = "txtBusq" + liColumnaBE.CODI_COLU + "N1";
                        txt.ID = _goBtnDinamicos.ID_TXT;
                        txt.CssClass = "dbnTextboxNumerico";
                        _goBtnDinamicos.TIPO_CONT = "TXT";
                        _goBtnDinamicos.COLU_BUSQ = liColumnaBE.COLU_BUSQ;
                        tblC2.Controls.Add(txt);
                        _gaBotonesDinamicos.Add(_goBtnDinamicos);

                        _goBtnDinamicos = new CamposDinamicos();
                        _goBtnDinamicos.TIPO_COLU = "NN";
                        TextBox txt1 = new TextBox();
                        _goBtnDinamicos.ID_TXT = "txtBusq" + liColumnaBE.CODI_COLU + "N2";
                        txt1.ID = _goBtnDinamicos.ID_TXT;
                        txt1.CssClass = "dbnTextboxNumerico";
                        _goBtnDinamicos.TIPO_CONT = "TXT";
                        _goBtnDinamicos.COLU_BUSQ = liColumnaBE.COLU_BUSQ;
                        tblC3.Controls.Add(txt1);

                        _gaBotonesDinamicos.Add(_goBtnDinamicos);
                    }
                    #endregion
                    #region TIPO_BUSQ == F
                    if (liColumnaBE.TIPO_BUSQ == "F" && liColumnaBE.INDI_BUSQ == "1")
                    {
                        _goBtnDinamicos = new CamposDinamicos();
                        _goBtnDinamicos.TIPO_COLU = "F";
                        Label lblIndiBusq = new Label();
                        lblIndiBusq.Text = liColumnaBE.NOMB_COLU;
                        lblIndiBusq.CssClass = "lblIzquierdo";
                        tblC1.Controls.Add(lblIndiBusq);


                        _goBtnDinamicos.ID_TXT = this.txtBusquedaFecha1.ClientID;
                        _goBtnDinamicos.COLU_BUSQ = liColumnaBE.COLU_BUSQ;
                        _goBtnDinamicos.TIPO_CONT = "TXT";
                        this.txtBusquedaFecha1.CssClass = "dbnTextbox";
                        this.txtBusquedaFecha1.Width = 116;
                        this.txtBusquedaFecha1.Visible = true;
                        tblC2.Controls.Add(this.txtBusquedaFecha1);

                        _gaBotonesDinamicos.Add(_goBtnDinamicos);
                    }
                    #endregion
                    #region TIPO_BUSQ == FF
                    if (liColumnaBE.TIPO_BUSQ == "FF" && liColumnaBE.INDI_BUSQ == "1" && liFF == 0)
                    {
                        _goBtnDinamicos = new CamposDinamicos();
                        Label lblIndiBusq = new Label();
                        _goBtnDinamicos.TIPO_COLU = "FF";
                        lblIndiBusq.Text = liColumnaBE.NOMB_COLU;
                        lblIndiBusq.CssClass = "lblIzquierdo";
                        tblC1.Controls.Add(lblIndiBusq);

                        _goBtnDinamicos.ID_TXT = this.txtBusquedaFechaFecha1.ID;
                        _goBtnDinamicos.COLU_BUSQ = liColumnaBE.COLU_BUSQ;
                        _goBtnDinamicos.TIPO_CONT = "TXT";
                        _gaBotonesDinamicos.Add(_goBtnDinamicos);
                        this.txtBusquedaFechaFecha1.CssClass = "dbnTextbox";
                        this.txtBusquedaFechaFecha1.Width = 116;
                        this.txtBusquedaFechaFecha1.Visible = true;
                        tblC2.Controls.Add(this.txtBusquedaFechaFecha1);

                        _goBtnDinamicos = new CamposDinamicos();
                        _goBtnDinamicos.TIPO_COLU = "FF";
                        _goBtnDinamicos.ID_TXT = this.txtBusquedaFechaFecha2.ID;
                        _goBtnDinamicos.COLU_BUSQ = liColumnaBE.COLU_BUSQ;
                        _goBtnDinamicos.TIPO_CONT = "TXT";
                        this.txtBusquedaFechaFecha2.CssClass = "dbnTextbox";
                        this.txtBusquedaFechaFecha2.Width = 116;
                        this.txtBusquedaFechaFecha2.Visible = true;
                        tblC3.Controls.Add(this.txtBusquedaFechaFecha2);

                        _gaBotonesDinamicos.Add(_goBtnDinamicos);
                    }
                    #endregion
                    #region TIPO_BUSQ == CK
                    if (liColumnaBE.TIPO_BUSQ.ToUpper() == "CK" && liColumnaBE.INDI_BUSQ == "1")
                    {
                        _goBtnDinamicos = new CamposDinamicos();
                        Label lblIndiBusq = new Label();
                        _goBtnDinamicos.TIPO_COLU = "FF";
                        lblIndiBusq.Text = liColumnaBE.NOMB_COLU;
                        lblIndiBusq.CssClass = "lblIzquierdo";
                        tblC1.Controls.Add(lblIndiBusq);

                        CheckBox ck = new CheckBox();
                        _goBtnDinamicos.ID_TXT = "ck" + liColumnaBE.CODI_COLU;
                        ck.ID = _goBtnDinamicos.ID_TXT;
                        _goBtnDinamicos.COLU_BUSQ = liColumnaBE.COLU_BUSQ;
                        _goBtnDinamicos.VERD_BUSQ = liColumnaBE.VERD_BUSQ;
                        _goBtnDinamicos.FALS_BUSQ = liColumnaBE.FALS_BUSQ;
                        _goBtnDinamicos.TIPO_CONT = "CK";
                        _gaBotonesDinamicos.Add(_goBtnDinamicos);
                        tblC2.Controls.Add(ck);
                    }
                    #endregion
                    #region TIPO_BUSQ == CB
                    if (liColumnaBE.TIPO_BUSQ.ToUpper() == "CB" && liColumnaBE.INDI_BUSQ == "1")
                    {
                        _goBtnDinamicos = new CamposDinamicos();
                        Label lblIndiBusq = new Label();
                        _goBtnDinamicos.TIPO_CONT = "CB";
                        lblIndiBusq.Text = liColumnaBE.NOMB_COLU;
                        lblIndiBusq.CssClass = "lblIzquierdo";
                        tblC1.Controls.Add(lblIndiBusq);
                        tblC2.Width = 400;
                        tblC2.ColumnSpan = 2;
                        _goBtnDinamicos.COLU_BUSQ = liColumnaBE.COLU_BUSQ;
                        ListadorController listController = new ListadorController();

                        ddlLista.Visible = true;
                        DataTable dt = listController.readProc(liColumnaBE.CODI_LIVA);
                        Helper.ddlCarga(ddlLista, dt);
                        _goBtnDinamicos.CODI_LIVA = liColumnaBE.CODI_LIVA;
                        _goBtnDinamicos.ID_TXT = ddlLista.ID;
                        _gaBotonesDinamicos.Add(_goBtnDinamicos);
                        tblC2.Controls.Add(ddlLista);
                    }
                    #endregion
                    #region TIPO_BUSQ == AU
                    if (liColumnaBE.TIPO_BUSQ.ToUpper() == "AU" && liColumnaBE.INDI_BUSQ == "1" && liCb == 0)
                    {
                        _goBtnDinamicos = new CamposDinamicos();
                        Label lblIndiBusq = new Label();
                        _goBtnDinamicos.TIPO_CONT = "AU";
                        lblIndiBusq.Text = liColumnaBE.NOMB_COLU;
                        lblIndiBusq.CssClass = "lblIzquierdo";
                        tblC1.Controls.Add(lblIndiBusq);
                        tblC2.Width = 400;
                        _goBtnDinamicos.COLU_BUSQ = liColumnaBE.COLU_BUSQ;

                        txtBusquedaAutoComplete1.Visible = true;
                        autoCompleteDropDownPanel1.Visible = true;
                        txtBusquedaAutoComplete1.Width = 400;
                        _goBtnDinamicos.CODI_LIVA = liColumnaBE.CODI_LIVA;
                        _goBtnDinamicos.ID_TXT = txtBusquedaAutoComplete1.ID;
                        _gaBotonesDinamicos.Add(_goBtnDinamicos);
                        tblC2.Controls.Add(txtBusquedaAutoComplete1);
                        tblC2.ColumnSpan = 2;
                    }
                    #endregion
                    tblR.Controls.Add(tblC1);
                    tblR.Controls.Add(tblC2);
                    tblR.Controls.Add(tblC3);
                    tbl.Controls.Add(tblR);
                    pnlBusqueda.Controls.Add(tbl);
                    Session["lsBotonesDinamicos"] = _gaBotonesDinamicos;
                }
                #endregion
                // Se Agrega la Columna de Tipo BounField a la Grilla
                grilla.Columns.Add(lbfColumna);
                grillaExport.Columns.Add(lbfColumna);
                grilla.DataBind();
                grillaExport.DataBind();
                // Visibilidad
                if (liColumnaBE.INDI_VISI == "0")
                { lbfColumna.Visible = false; }
                else if (liColumnaBE.INDI_VISI == "1")
                { lbfColumna.Visible = true; _giAnchoGrilla = _giAnchoGrilla + int.Parse(liColumnaBE.ANCH_COLU); }
                else
                { lbfColumna.Visible = true; _giAnchoGrilla = _giAnchoGrilla + int.Parse(liColumnaBE.ANCH_COLU); }
            }
            #endregion
            #region Imagen (ImageField)
            else if (liColumnaBE.TIPO_COLU == "imagen")
            {
                ImageField img = new ImageField();
                img.DataImageUrlField = liColumnaBE.CODI_COLU;
                img.ControlStyle.CssClass = "ImageField";
                img.HeaderText = liColumnaBE.NOMB_COLU;
                grilla.Columns.Add(img);
                grilla.DataBind();
                _giAnchoGrilla = _giAnchoGrilla + 20;
            }
            #endregion
        }
        grilla.Width = _giAnchoGrilla;
    }
    private void CargaBotonesTranspuesto(DbnListBotoBE item, int tiBotonDetalle, out string str1)
    {
        string str = "";
        if (item.NOMB_BOTO == "btnEditar")
        { this.btnEditarTabular.Visible = true; }
        if (item.NOMB_BOTO == "btnDetalle")
        {
            if (tiBotonDetalle == 0)
            { this.btnDetalleTabular1.Visible = true; this.btnDetalleTabular1.CssClass = item.CLAS_CSS + "-" + item.CODI_BOTO; this.btnDetalleTabular1.CommandName = item.NOMB_BOTO + "-" + item.CODI_BOTO; tiBotonDetalle += 1; this.btnDetalleTabular1.ImageUrl = "~/librerias/img/botones/" + item.IMAG_BOTO; }
            else if (tiBotonDetalle == 1)
            { this.btnDetalleTabular2.Visible = true; this.btnDetalleTabular2.CssClass = item.CLAS_CSS + "-" + item.CODI_BOTO; this.btnDetalleTabular2.CommandName = item.NOMB_BOTO + "-" + item.CODI_BOTO; tiBotonDetalle += 1; this.btnDetalleTabular2.ImageUrl = "~/librerias/img/botones/" + item.IMAG_BOTO; }
            else if (tiBotonDetalle == 2)
            { this.btnDetalleTabular3.Visible = true; this.btnDetalleTabular3.CssClass = item.CLAS_CSS + "-" + item.CODI_BOTO; this.btnDetalleTabular3.CommandName = item.NOMB_BOTO + "-" + item.CODI_BOTO; tiBotonDetalle += 1; this.btnDetalleTabular3.ImageUrl = "~/librerias/img/botones/" + item.IMAG_BOTO; }
            else if (tiBotonDetalle == 3)
            { this.btnDetalleTabular4.Visible = true; this.btnDetalleTabular4.CssClass = item.CLAS_CSS + "-" + item.CODI_BOTO; this.btnDetalleTabular4.CommandName = item.NOMB_BOTO + "-" + item.CODI_BOTO; tiBotonDetalle += 1; this.btnDetalleTabular4.ImageUrl = "~/librerias/img/botones/" + item.IMAG_BOTO; }
            else if (tiBotonDetalle == 4)
            { this.btnDetalleTabular5.Visible = true; this.btnDetalleTabular5.CssClass = item.CLAS_CSS + "-" + item.CODI_BOTO; this.btnDetalleTabular5.CommandName = item.NOMB_BOTO + "-" + item.CODI_BOTO; tiBotonDetalle += 1; this.btnDetalleTabular5.ImageUrl = "~/librerias/img/botones/" + item.IMAG_BOTO; }
            else if (tiBotonDetalle == 5)
            { this.btnDetalleTabular6.Visible = true; this.btnDetalleTabular6.CssClass = item.CLAS_CSS + "-" + item.CODI_BOTO; this.btnDetalleTabular6.CommandName = item.NOMB_BOTO + "-" + item.CODI_BOTO; tiBotonDetalle += 1; this.btnDetalleTabular6.ImageUrl = "~/librerias/img/botones/" + item.IMAG_BOTO; }
            else if (tiBotonDetalle == 6)
            { this.btnDetalleTabular7.Visible = true; this.btnDetalleTabular7.CssClass = item.CLAS_CSS + "-" + item.CODI_BOTO; this.btnDetalleTabular7.CommandName = item.NOMB_BOTO + "-" + item.CODI_BOTO; tiBotonDetalle += 1; this.btnDetalleTabular7.ImageUrl = "~/librerias/img/botones/" + item.IMAG_BOTO; }
            else if (tiBotonDetalle == 7)
            { this.btnDetalleTabular8.Visible = true; this.btnDetalleTabular8.CssClass = item.CLAS_CSS + "-" + item.CODI_BOTO; this.btnDetalleTabular8.CommandName = item.NOMB_BOTO + "-" + item.CODI_BOTO; tiBotonDetalle += 1; this.btnDetalleTabular8.ImageUrl = "~/librerias/img/botones/" + item.IMAG_BOTO; }
            else if (tiBotonDetalle == 8)
            { this.btnDetalleTabular9.Visible = true; this.btnDetalleTabular9.CssClass = item.CLAS_CSS + "-" + item.CODI_BOTO; this.btnDetalleTabular9.CommandName = item.NOMB_BOTO + "-" + item.CODI_BOTO; tiBotonDetalle += 1; this.btnDetalleTabular9.ImageUrl = "~/librerias/img/botones/" + item.IMAG_BOTO; }
            else if (tiBotonDetalle == 9)
            { this.btnDetalleTabular10.Visible = true; this.btnDetalleTabular10.CssClass = item.CLAS_CSS + "-" + item.CODI_BOTO; this.btnDetalleTabular10.CommandName = item.NOMB_BOTO + "-" + item.CODI_BOTO; tiBotonDetalle += 1; this.btnDetalleTabular10.ImageUrl = "~/librerias/img/botones/" + item.IMAG_BOTO; }
            str += "$(\"." + item.CLAS_CSS + "-" + item.CODI_BOTO + "\").attr(\"title\", \"" + item.DESC_BOTO + "\");\n";
        }
        if (item.NOMB_BOTO == "btnEjecutar")
        { this.btnEjecutarTabular.Visible = true; }
        str1 = str;
    }
    private void cargaMultilenguaje()
    {
        this.btnAgregar.ToolTip = multilenguaje_base.tt_btnAgregar;
        this.btnExcel.ToolTip = multilenguaje_base.tt_btnExcel;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
        this.btnPrimeraPagina.ToolTip = multilenguaje_base.tt_btnPrimeraPagina;
        this.btnUltimaPagina.ToolTip = multilenguaje_base.tt_btnUltimaPagina;
        this.btnPaginaAnterior.ToolTip = multilenguaje_base.tt_btnPaginaAnterior;
        this.btnPaginaSiguiente.ToolTip = multilenguaje_base.tt_btnPaginaSiguiente;
        this.btnAgregar.ToolTip = multilenguaje_base.tt_btnAgregar;
        this.lblPaginas.Text = multilenguaje_base.lblPaginas;
        this.lblTotalRegistro.Text = multilenguaje_base.lblTotalRegistros;
        this.lblRegPag.Text = multilenguaje_base.lblRegPag;
        this.lblBusqueda.Text = multilenguaje_base.lblBusqueda;
        this.ckbConsulta.Text = multilenguaje_base.ckbBusquedaExacta;
    }
    protected void grilla_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        //this.cargaReporteSP();
        int index = Convert.ToInt32(e.CommandArgument);
        this.Session.Remove("BTN_AGRE_MODO");
        //PDF
        #region btnarch1 btnpdf
        if (e.CommandName.Contains("btnArch1"))
        { btnArch1(_goDbnlistbotoBE, index, e, e.CommandName.ToString()); }
        #endregion
        //PDF_FIR
        #region btnarch2 btnpdf_fir
        else if (e.CommandName.Contains("btnArch2"))
        { btnArch2(_goDbnlistbotoBE, index, e, e.CommandName.ToString()); }
        #endregion
        #region btnEditar
        if (e.CommandName.Contains("btnEditar"))
        { btnEditar(_goDbnlistbotoBE, index, e, e.CommandName.ToString()); }
        #endregion
        #region btnDetalle
        else if (e.CommandName.Contains("btnDetalle"))
        { btnDetalle(_goDbnlistbotoBE, index, e, e.CommandName.ToString()); }
        #endregion
        #region btnEjecutar
        else if (e.CommandName.Contains("btnEjecutar"))
        { btnEjecutar(_goDbnlistbotoBE, index, e, e.CommandName.ToString()); }
        #endregion
    }
    private DbnListBotoBE cicloDataTable(int index, GridViewCommandEventArgs e, string tsBoton)
    {
        #region Foreach para Pasar los Parametros de la Lista a la BE
        if (e != null)
        {
            foreach (var item in _gaBoton)
            {
                if (item.NOMB_BOTO + "-" + item.CODI_BOTO == e.CommandName)
                {
                    _goDbnlistbotoBE = new DbnListBotoBE(); _goDbnlistbotoBE.CODI_PAR1 = item.CODI_PAR1;
                    _goDbnlistbotoBE.CODI_PAR2 = item.CODI_PAR2; _goDbnlistbotoBE.CODI_PAR3 = item.CODI_PAR3;
                    _goDbnlistbotoBE.CODI_PAR4 = item.CODI_PAR4; _goDbnlistbotoBE.CODI_PAR5 = item.CODI_PAR5;
                    _goDbnlistbotoBE.CODI_REPO = item.CODI_REPO; _goDbnlistbotoBE.CODI_BOTO = item.CODI_BOTO;
                    _goDbnlistbotoBE.PAGE_BOTO = item.PAGE_BOTO; _goDbnlistbotoBE.NOMB_BOTO = item.NOMB_BOTO;
                    _goDbnlistbotoBE.LIST_DETA = item.LIST_DETA; _goDbnlistbotoBE.DESC_BOTO = item.DESC_BOTO;
                    _goDbnlistbotoBE.TIPO_BOTO = item.TIPO_BOTO; _goDbnlistbotoBE.CLAS_CSS = item.CLAS_CSS;
                    _goDbnlistbotoBE.NOMB_BOTO = item.NOMB_BOTO; _goDbnlistbotoBE.IMAG_BOTO = item.IMAG_BOTO;
                    _goDbnlistbotoBE.PROC_BOTO = item.PROC_BOTO;
                }
            }
        }
        else
        {
            foreach (var item in _gaBoton)
            {
                //if (item.NOMB_BOTO + "-" + item.CODI_BOTO ==  tsBoton)
                if (item.NOMB_BOTO.Contains(tsBoton))
                {
                    _goDbnlistbotoBE = new DbnListBotoBE(); _goDbnlistbotoBE.CODI_PAR1 = item.CODI_PAR1;
                    _goDbnlistbotoBE.CODI_PAR2 = item.CODI_PAR2; _goDbnlistbotoBE.CODI_PAR3 = item.CODI_PAR3;
                    _goDbnlistbotoBE.CODI_PAR4 = item.CODI_PAR4; _goDbnlistbotoBE.CODI_PAR5 = item.CODI_PAR5;
                    _goDbnlistbotoBE.CODI_REPO = item.CODI_REPO; _goDbnlistbotoBE.CODI_BOTO = item.CODI_BOTO;
                    _goDbnlistbotoBE.PAGE_BOTO = item.PAGE_BOTO; _goDbnlistbotoBE.NOMB_BOTO = item.NOMB_BOTO;
                    _goDbnlistbotoBE.LIST_DETA = item.LIST_DETA; _goDbnlistbotoBE.DESC_BOTO = item.DESC_BOTO;
                    _goDbnlistbotoBE.TIPO_BOTO = item.TIPO_BOTO; _goDbnlistbotoBE.CLAS_CSS = item.CLAS_CSS;
                    _goDbnlistbotoBE.NOMB_BOTO = item.NOMB_BOTO; _goDbnlistbotoBE.IMAG_BOTO = item.IMAG_BOTO;
                    _goDbnlistbotoBE.PROC_BOTO = item.PROC_BOTO;
                }
            }
        }
        #endregion
        #region Se Recorre la Grilla Obteniendo Las Columnas y Obteniendo el Indice y asignandose a las Propiedades de Values
        if (ckbTranspuesto.Checked)
        {
            int[] idx = { -1, -1, -1, -1, -1 };
            for (int i = 0; i < _gdDatosTablaTabular.Columns.Count; i++)
            {
                DataColumn dc = _gdDatosTablaTabular.Columns[i];
                if (_goDbnlistbotoBE.CODI_PAR1.ToUpper() == dc.ColumnName.ToUpper()) idx[0] = i;
                if (_goDbnlistbotoBE.CODI_PAR2.ToUpper() == dc.ColumnName.ToUpper()) idx[1] = i;
                if (_goDbnlistbotoBE.CODI_PAR3.ToUpper() == dc.ColumnName.ToUpper()) idx[2] = i;
                if (_goDbnlistbotoBE.CODI_PAR4.ToUpper() == dc.ColumnName.ToUpper()) idx[3] = i;
                if (_goDbnlistbotoBE.CODI_PAR5.ToUpper() == dc.ColumnName.ToUpper()) idx[4] = i;
            }
            if (idx[0] != -1)
                _goDbnlistbotoBE.VAL_PAR1 = _gdDatosTablaTabular.Rows[index][idx[0]].ToString();
            if (idx[1] != -1)
                _goDbnlistbotoBE.VAL_PAR2 = _gdDatosTablaTabular.Rows[index][idx[1]].ToString();
            if (idx[2] != -1)
                _goDbnlistbotoBE.VAL_PAR3 = _gdDatosTablaTabular.Rows[index][idx[2]].ToString();
            if (idx[3] != -1)
                _goDbnlistbotoBE.VAL_PAR4 = _gdDatosTablaTabular.Rows[index][idx[3]].ToString();
            if (idx[4] != -1)
                _goDbnlistbotoBE.VAL_PAR5 = _gdDatosTablaTabular.Rows[index][idx[4]].ToString();
        }
        else
        {
            int[] idx = { -1, -1, -1, -1, -1 };
            for (int i = 0; i < _gdDatosTabla.Columns.Count; i++)
            {
                DataColumn dc = _gdDatosTabla.Columns[i];
                if (_goDbnlistbotoBE.CODI_PAR1.ToUpper() == dc.ColumnName.ToUpper()) idx[0] = i;
                if (_goDbnlistbotoBE.CODI_PAR2.ToUpper() == dc.ColumnName.ToUpper()) idx[1] = i;
                if (_goDbnlistbotoBE.CODI_PAR3.ToUpper() == dc.ColumnName.ToUpper()) idx[2] = i;
                if (_goDbnlistbotoBE.CODI_PAR4.ToUpper() == dc.ColumnName.ToUpper()) idx[3] = i;
                if (_goDbnlistbotoBE.CODI_PAR5.ToUpper() == dc.ColumnName.ToUpper()) idx[4] = i;
            }
            if (idx[0] != -1)
                _goDbnlistbotoBE.VAL_PAR1 = _gdDatosTabla.Rows[index][idx[0]].ToString();
            if (idx[1] != -1)
                _goDbnlistbotoBE.VAL_PAR2 = _gdDatosTabla.Rows[index][idx[1]].ToString();
            if (idx[2] != -1)
                _goDbnlistbotoBE.VAL_PAR3 = _gdDatosTabla.Rows[index][idx[2]].ToString();
            if (idx[3] != -1)
                _goDbnlistbotoBE.VAL_PAR4 = _gdDatosTabla.Rows[index][idx[3]].ToString();
            if (idx[4] != -1)
                _goDbnlistbotoBE.VAL_PAR5 = _gdDatosTabla.Rows[index][idx[4]].ToString();
        }
        #endregion
        return _goDbnlistbotoBE;
    }
    protected void ddlRegPag_SelectedIndexChanged(object sender, EventArgs e)
    { btnPrimeraPagina_Click(null, null); }

    protected void btnAgregar_Click(object sender, EventArgs e)
    {
        _goDbnlistrepoController = new DbnListRepoController();
        string lsPagina = _goDbnlistrepoController.readPagina(Session["tsListado"].ToString());
        this.GuardaSessionWeb();
        Session["P_MODO_REPO"] = this.modo();
        Session["BTN_AGRE_MODO"] = "CI";
        if (lsPagina.Trim().Length > 0)
            Response.Redirect(lsPagina, true);
        else
            Response.Redirect("~/dbnFw5/dbnIndex.aspx", true);
    }
    protected void btnVolver_Click(object sender, EventArgs e)
    {
        if (_goSesionListador.iNivel == 1)
        { Response.Redirect("~/dbnFw5/dbnIndex.aspx", true); }
        else
        {
            _goSesionListador.EliminaActual();
            GuardaSesionListador();
            Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=" + _goSesionListador.Actual.psListador + "&modo=" + _goSesionListador.Actual.psModo, true);
        }
    }
    protected void btnPrimeraPagina_Click(object sender, EventArgs e)
    {
        this.lblPaginaActual.Text = "1";
        this.cargaReporteSP(int.Parse(this.lblPaginaActual.Text), int.Parse(this.ddlRegPag.SelectedValue), Session["tsBusqueda"].ToString(), _goSesionListador.Actual.psVal1, _goSesionListador.Actual.psVal2, _goSesionListador.Actual.psVal3, _goSesionListador.Actual.psVal4, _goSesionListador.Actual.psVal5);

        _goSesionListador.Actual.psPagina = this.lblPaginaActual.Text;
        _goSesionListador.Actual.psCantidad = this.ddlRegPag.SelectedValue;
        GuardaSesionListador();
    }
    protected void btnPaginaAnterior_Click(object sender, EventArgs e)
    {
        int lipaginaActual = Convert.ToInt32(this.lblPaginaActual.Text);
        int lipaginaAnterior = (lipaginaActual - 1);
        if (lipaginaActual > 1)
        {
            this.lblPaginaActual.Text = lipaginaAnterior.ToString();
            this.cargaReporteSP(int.Parse(this.lblPaginaActual.Text), int.Parse(this.ddlRegPag.SelectedValue), Session["tsBusqueda"].ToString(), _goSesionListador.Actual.psVal1, _goSesionListador.Actual.psVal2, _goSesionListador.Actual.psVal3, _goSesionListador.Actual.psVal4, _goSesionListador.Actual.psVal5);
        }
        else
        {
            string scr = "<script>alert('Primera Página');</script>";
            Page.ClientScript.RegisterStartupScript(typeof(Page), "msgError", scr);
            this.cargaReporteSP(int.Parse(this.lblPaginaActual.Text), int.Parse(this.ddlRegPag.SelectedValue), Session["tsBusqueda"].ToString(), _goSesionListador.Actual.psVal1, _goSesionListador.Actual.psVal2, _goSesionListador.Actual.psVal3, _goSesionListador.Actual.psVal4, _goSesionListador.Actual.psVal5);
        }
        _goSesionListador.Actual.psPagina = this.lblPaginaActual.Text;
        _goSesionListador.Actual.psCantidad = this.ddlRegPag.SelectedValue;
        GuardaSesionListador();
    }
    protected void btnPaginaSiguiente_Click(object sender, EventArgs e)
    {
        int paginaActual = Convert.ToInt32(this.lblPaginaActual.Text);
        int paginaUltima = Convert.ToInt32(this.lblTotalPaginas.Text);
        if (paginaActual < paginaUltima)
        {
            this.lblPaginaActual.Text = (Convert.ToInt32(this.lblPaginaActual.Text) + 1).ToString();
            this.cargaReporteSP(int.Parse(this.lblPaginaActual.Text), int.Parse(this.ddlRegPag.SelectedValue), Session["tsBusqueda"].ToString(), _goSesionListador.Actual.psVal1, _goSesionListador.Actual.psVal2, _goSesionListador.Actual.psVal3, _goSesionListador.Actual.psVal4, _goSesionListador.Actual.psVal5);
        }
        else
        {
            string scr = "<script>alert('Ultima Página');</script>";
            Page.ClientScript.RegisterStartupScript(typeof(Page), "msgError", scr);
            this.cargaReporteSP(int.Parse(this.lblPaginaActual.Text), int.Parse(this.ddlRegPag.SelectedValue), Session["tsBusqueda"].ToString(), _goSesionListador.Actual.psVal1, _goSesionListador.Actual.psVal2, _goSesionListador.Actual.psVal3, _goSesionListador.Actual.psVal4, _goSesionListador.Actual.psVal5);
        }
        _goSesionListador.Actual.psPagina = this.lblPaginaActual.Text;
        _goSesionListador.Actual.psCantidad = this.ddlRegPag.SelectedValue;
        GuardaSesionListador();
    }
    protected void btnUltimaPagina_Click(object sender, EventArgs e)
    {
        this.lblPaginaActual.Text = this.lblTotalPaginas.Text;
        this.cargaReporteSP(Convert.ToInt32(this.lblPaginaActual.Text), int.Parse(this.ddlRegPag.SelectedValue), Session["tsBusqueda"].ToString(), _goSesionListador.Actual.psVal1, _goSesionListador.Actual.psVal2, _goSesionListador.Actual.psVal3, _goSesionListador.Actual.psVal4, _goSesionListador.Actual.psVal5);

        if (this.lblPaginaActual.Text == this.lblTotalPaginas.Text)
        { ClientScript.RegisterStartupScript(typeof(Page), "Alerta", "<script language = 'JavaScript'>alert('Es la última Página');</script>"); }
        _goSesionListador.Actual.psPagina = this.lblPaginaActual.Text;
        _goSesionListador.Actual.psCantidad = this.ddlRegPag.SelectedValue;
        GuardaSesionListador();
    }
    protected void btnExcel_Click(object sender, EventArgs e)
    {
        try
        {
            this.cargaReporteSP();
            if (Convert.ToInt32(this.lblTotalRegistros.Text) > 1000)
            {
                Session["grilla1"] = grillaExport;
                Session["dt"] = CargaReporteSP(Convert.ToInt32(this.lblPaginaActual.Text), Convert.ToInt32(this.lblTotalRegistros.Text), Session["tsBusqueda"].ToString(), _goSesionListador.Actual.psVal1, _goSesionListador.Actual.psVal2, _goSesionListador.Actual.psVal3, _goSesionListador.Actual.psVal4, _goSesionListador.Actual.psVal5);
                ClientScript.RegisterStartupScript(typeof(Page), "PaginaDestino", "<SCRIPT LANGUAGE='JavaScript'>window.open('../dbnFw5/dbnComprobacion.aspx', '', 'width=470px, height=150px, margin= 0 auto, position:absolute, top:50%, left:50%, margin-top:-100px, margin-left:-100%,location=no,toolbars=no,scroolbars=yes'); </SCRIPT>");
            }
            else
            { ExportXls(Convert.ToInt32(this.lblTotalRegistros.Text)); }
        }
        catch (Exception ex)
        { this.lblError.Text = ex.Message; }
    }
    private void ExportXls(int cantidad)
    {
        this.cargaReporteExcel(1, cantidad, Session["tsBusqueda"].ToString(), _goSesionListador.Actual.psVal1, _goSesionListador.Actual.psVal2, _goSesionListador.Actual.psVal3, _goSesionListador.Actual.psVal4, _goSesionListador.Actual.psVal5);
        #region Export XLS in HTML
        try
        {
            StringBuilder sb = new StringBuilder();
            StringWriter sw = new StringWriter(sb);
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            Page page = new Page();
            HtmlForm form = new HtmlForm();

            grillaExport.EnableViewState = false;
            page.EnableEventValidation = false;
            page.DesignerInitialize();
            //Asi se Agrega componentes de un CSS a la grilla
            //grilla1.Style.Add("width", "700");
            //grilla1.Style.Add("background-color", "#F5F5F5");

            //form.Controls.Add(grillaExport);
            //page.Controls.Add(form);
            //page.RenderControl(htw);

            string test = "";

            StreamWriter sw2 = new StreamWriter(@"C:\DBNeT\DBAX\dbsWebNet\DBNeT.DBAX.Vista\log.txt");
            sw2.WriteLine("Inicio: " + System.DateTime.Now.ToString());
            for(int i = 0; i<grillaExport.Rows.Count;i++)
            {
                for (int j = 0; j < grillaExport.Columns.Count; j++)
                {
                    test += grillaExport.Rows[i].Cells[j].Text + ";";
                }
                test += "\n";
            }

            Response.Clear();
            Response.Buffer = true;
            //Response.ContentType = "application/vnd.ms-excel";
            Response.ContentType = "text/csv";
            Response.AddHeader("Content-Disposition", "attachment;filename= " + lblTitulo.Text + ".csv");
            Response.Charset = "iso-8859-1";
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentEncoding = System.Text.Encoding.Default;
            Response.Write(System.Web.HttpUtility.HtmlDecode(test));
            sw2.WriteLine("Fin: " + System.DateTime.Now.ToString());
            Response.End();
        }
        catch (Exception exp)
        {
            ClientScript.RegisterStartupScript(typeof(Page), "Alerta", "<script language = 'JavaScript'>alert('Filtre más la informacion por que se sobrepaso de los 65.536 registros del excel " + exp + "');</script>");
            return;
        }
        #endregion
    }
    public override void VerifyRenderingInServerForm(Control control) { }
    protected void btnConsultaDinamica_Click(object sender, EventArgs e)
    {
        try
        {
            Session.Remove("tsBusqueda");
            int liBetween = 0;
            foreach (var item in _gaBotonesDinamicos)
            {
                #region TXT
                if (item.TIPO_CONT == "TXT")
                {
                    TextBox txtDinamico = (TextBox)this.FindControl("ctl00$bodyCP$" + item.ID_TXT);
                    if (txtDinamico.Text.Trim().Length != 0)
                    {
                        #region "S"
                        if (item.TIPO_COLU == "S")
                        {
                            if (ckbConsulta.Checked)
                            { Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + item.COLU_BUSQ + " = '" + txtDinamico.Text + "' "; }
                            else
                            { Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + item.COLU_BUSQ + " LIKE '%" + txtDinamico.Text + "%' "; }
                        }
                        #endregion
                        #region "N"
                        else if (item.TIPO_COLU == "N")
                        {
                            if (ckbConsulta.Checked == true)
                                Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + item.COLU_BUSQ + " = '" + Convert.ToInt32(txtDinamico.Text) + "' ";
                            else
                                Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + item.COLU_BUSQ + " LIKE '%" + Convert.ToInt32(txtDinamico.Text) + "%' ";
                        }
                        #endregion
                        #region "NN"
                        else if (item.TIPO_COLU == "NN")
                        {
                            if (liBetween == 0)
                            {
                                Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + item.COLU_BUSQ + " BETWEEN '" + Convert.ToInt32(txtDinamico.Text) + "' ";
                                liBetween = 1;
                            }
                            else if (liBetween == 1)
                            {
                                if (txtDinamico.Text.Trim().Length != 0)
                                    Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + Convert.ToInt32(txtDinamico.Text) + " ";
                                else
                                    Session.Remove("tsBusqueda");
                                liBetween = 2;
                            }
                        }
                        #endregion
                        #region "F"
                        else if (item.TIPO_COLU == "F")
                        {
                            if (ckbConsulta.Checked == true)
                            { Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + item.COLU_BUSQ + " = '" + Convert.ToDateTime(txtDinamico.Text) + "' "; }
                            else
                            { Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + item.COLU_BUSQ + " LIKE '%" + Convert.ToDateTime(txtDinamico.Text) + "%' "; }
                        }
                        #endregion
                        #region "FF"
                        else if (item.TIPO_COLU == "FF")
                        {
                            if (liBetween == 0)
                            {
                                Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + item.COLU_BUSQ + " BETWEEN '" + Convert.ToDateTime(txtDinamico.Text) + "' ";
                                liBetween = 1;
                            }
                            else if (liBetween == 1)
                            {
                                if (txtDinamico.Text.Trim().Length != 0)
                                    Session["tsBusqueda"] = Session["tsBusqueda"] + " AND '" + Convert.ToDateTime(txtDinamico.Text) + "' ";
                                else
                                    Session.Remove("tsBusqueda");
                                liBetween = 2;
                            }
                        }
                        #endregion
                    }
                    else
                    { continue; }
                }
                #endregion
                #region CK
                if (item.TIPO_CONT == "CK")
                {
                    CheckBox ckbDinamico = (CheckBox)this.FindControl("ctl00$bodyCP$" + item.ID_TXT);
                    if (ckbDinamico.Checked)
                    { Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + item.COLU_BUSQ + " = '" + item.VERD_BUSQ + "' "; }
                    else
                    { Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + item.COLU_BUSQ + " = '" + item.FALS_BUSQ + "' "; }
                }
                #endregion
                #region CB
                if (item.TIPO_CONT == "CB")
                {
                    DropDownList ddlDinamico = (DropDownList)this.FindControl("ctl00$bodyCP$" + item.ID_TXT);
                    if (Session["posicion"] != null)
                        ddlDinamico.SelectedIndex = (int)Session["posicion"];
                    if (ddlDinamico.SelectedIndex > 0)
                        Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + item.COLU_BUSQ + " = '" + ddlDinamico.SelectedValue + "' ";
                    else
                        continue;
                }
                #endregion
                #region AU
                if (item.TIPO_CONT == "AU")
                {
                    TextBox txtDinamico = (TextBox)this.FindControl("ctl00$bodyCP$" + item.ID_TXT);
                    if (txtDinamico.Text.Trim().Length != 0)
                    {
                        if (ckbConsulta.Checked == true)
                            Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + item.COLU_BUSQ + " = '" + txtDinamico.Text + "' ";
                        else
                            Session["tsBusqueda"] = Session["tsBusqueda"] + " AND " + item.COLU_BUSQ + " LIKE '%" + txtDinamico.Text + "%' ";
                    }
                }
                #endregion
            }
            if (liBetween == 2 || liBetween == 0)
            {
                if (Session["tsBusqueda"] != null)
                { this.cargaReporteSP(Convert.ToInt32(this.lblPaginaActual.Text), Convert.ToInt32(this.ddlRegPag.SelectedValue), Session["tsBusqueda"].ToString(), _goSesionListador.Actual.psVal1, _goSesionListador.Actual.psVal2, _goSesionListador.Actual.psVal3, _goSesionListador.Actual.psVal4, _goSesionListador.Actual.psVal5); }
                else
                {
                    Session["tsBusqueda"] = string.Empty;
                    this.cargaReporteSP(Convert.ToInt32(this.lblPaginaActual.Text), Convert.ToInt32(this.ddlRegPag.SelectedValue), Session["tsBusqueda"].ToString(), _goSesionListador.Actual.psVal1, _goSesionListador.Actual.psVal2, _goSesionListador.Actual.psVal3, _goSesionListador.Actual.psVal4, _goSesionListador.Actual.psVal5);
                }
            }
            else
            { this.cargaReporteSP(Convert.ToInt32(this.lblPaginaActual.Text), Convert.ToInt32(this.ddlRegPag.SelectedValue), "", _goSesionListador.Actual.psVal1, _goSesionListador.Actual.psVal2, _goSesionListador.Actual.psVal3, _goSesionListador.Actual.psVal4, _goSesionListador.Actual.psVal5); }
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList(string prefixText, int count, string contextKey)
    {
        string[] resultados = new string[count];
        DataTable dt = new DataTable();
        ListValoController lista = new ListValoController();
        List<CamposDinamicos> botonesDinamicos = new List<CamposDinamicos>();
        botonesDinamicos = (List<CamposDinamicos>)HttpContext.Current.Session["lsBotonesDinamicos"];
        SessionWeb _goSessionWeb = new SessionWeb();
        _goSessionWeb = (SessionWeb)HttpContext.Current.Session["sessionWeb"];

        foreach (var item in botonesDinamicos)
        {
            if (item.ID_TXT == "txtBusquedaAutoComplete1" && item.TIPO_CONT == "AU" && prefixText.Length > 0 && contextKey == "1")
            { resultados = lista.readListValor(item.CODI_LIVA, count, prefixText, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX); }
            else
            { continue; }
        }
        return resultados;
    }

    void Application_Error(object sender, EventArgs e)
    {
        //There should be some checking done so that not all the errors
        //are cleared
        Context.ClearError();
    }
    protected void ckbTranspuesto_CheckedChanged(object sender, EventArgs e)
    {
        if (ckbTranspuesto.Checked)
        {
            cargaReporteSP(1, 1, Session["tsBusqueda"].ToString());
            this.ddlRegPag.SelectedValue = "1";
            this.ddlRegPag.Enabled = false;
            int i = 0;
            string str = "";
            string str2 = "";
            foreach (var item in _gaBoton)
            { CargaBotonesTranspuesto(item, i, out str2); i++; str += str2; }
            Page.ClientScript.RegisterClientScriptBlock(GetType(), "tittleBtn", "<script> $(function () { " + str + "}) </script>");
        }
        else
        { this.ddlRegPag.Enabled = true; this.ddlRegPag.SelectedValue = "10"; cargaReporteSP(); OcultarBotones(); }
    }
    private void OcultarBotones()
    {
        btnDetalleTabular1.Visible = false;
        btnDetalleTabular2.Visible = false;
        btnDetalleTabular3.Visible = false;
        btnDetalleTabular4.Visible = false;
        btnDetalleTabular5.Visible = false;
        btnDetalleTabular6.Visible = false;
        btnDetalleTabular7.Visible = false;
        btnDetalleTabular8.Visible = false;
        btnDetalleTabular9.Visible = false;
        btnDetalleTabular10.Visible = false;
        btnEditarTabular.Visible = false;
        btnEjecutarTabular.Visible = false;
    }
    protected void ddlLista_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["posicion"] = ddlLista.SelectedIndex;
        cargaReporteSP();
        if (Session["posicion"] != null)
        { ddlLista.SelectedIndex = (int)Session["posicion"]; }
    }

    

    //Funcionalidad de Botones del listador
    private void btnEditar(DbnListBotoBE toDbnlistbotoBE, int index, GridViewCommandEventArgs e, string tsBoton)
    {
        toDbnlistbotoBE = cicloDataTable(index, e, tsBoton);
        Session[toDbnlistbotoBE.CODI_PAR1] = toDbnlistbotoBE.VAL_PAR1;
        Session[toDbnlistbotoBE.CODI_PAR2] = toDbnlistbotoBE.VAL_PAR2;
        Session[toDbnlistbotoBE.CODI_PAR3] = toDbnlistbotoBE.VAL_PAR3;
        Session[toDbnlistbotoBE.CODI_PAR4] = toDbnlistbotoBE.VAL_PAR4;
        Session[toDbnlistbotoBE.CODI_PAR5] = toDbnlistbotoBE.VAL_PAR5;

        Session["P_MODO_REPO"] = this.modo();
        if (Session["tsListado"].ToString() == toDbnlistbotoBE.CODI_REPO)
            Response.Redirect(toDbnlistbotoBE.PAGE_BOTO, true);
    }
    private void btnDetalle(DbnListBotoBE toDbnlistbotoBE, int index, GridViewCommandEventArgs e, string tsBoton)
    {
        toDbnlistbotoBE = cicloDataTable(index, e, tsBoton);
        Session[toDbnlistbotoBE.CODI_PAR1] = toDbnlistbotoBE.VAL_PAR1;
        Session[toDbnlistbotoBE.CODI_PAR2] = toDbnlistbotoBE.VAL_PAR2;
        Session[toDbnlistbotoBE.CODI_PAR3] = toDbnlistbotoBE.VAL_PAR3;
        Session[toDbnlistbotoBE.CODI_PAR4] = toDbnlistbotoBE.VAL_PAR4;
        Session[toDbnlistbotoBE.CODI_PAR5] = toDbnlistbotoBE.VAL_PAR5;
        var loResultado = _goDbnlistrepoController.readReporteBE("C", 0, 0, null, toDbnlistbotoBE.LIST_DETA, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);

        _goSesionListador.CargaNuevo(toDbnlistbotoBE.LIST_DETA, loResultado.MODO, "1", "10", toDbnlistbotoBE.CODI_PAR1, toDbnlistbotoBE.CODI_PAR2, toDbnlistbotoBE.CODI_PAR3, toDbnlistbotoBE.CODI_PAR4, toDbnlistbotoBE.CODI_PAR5, toDbnlistbotoBE.VAL_PAR1, toDbnlistbotoBE.VAL_PAR2, toDbnlistbotoBE.VAL_PAR3, toDbnlistbotoBE.VAL_PAR4, toDbnlistbotoBE.VAL_PAR5);
        _goSesionListador.Actual.psVal1 = toDbnlistbotoBE.VAL_PAR1;
        _goSesionListador.Actual.psVal2 = toDbnlistbotoBE.VAL_PAR2;
        _goSesionListador.Actual.psVal3 = toDbnlistbotoBE.VAL_PAR3;
        _goSesionListador.Actual.psVal4 = toDbnlistbotoBE.VAL_PAR4;
        _goSesionListador.Actual.psVal5 = toDbnlistbotoBE.VAL_PAR5; GuardaSesionListador();

        if (Session["tsListado"].ToString() == toDbnlistbotoBE.CODI_REPO)
            Response.Redirect(toDbnlistbotoBE.PAGE_BOTO + "?LISTADO=" + toDbnlistbotoBE.LIST_DETA + "&modo=" + loResultado.MODO, true);
    }
    private void btnEjecutar(DbnListBotoBE toDbnlistbotoBE, int index, GridViewCommandEventArgs e, string tsBoton)
    {
        toDbnlistbotoBE = cicloDataTable(index, e, tsBoton);
        _goSesionListador.CargaNuevo(_goDbnlistbotoBE.LIST_DETA, _gsModo, "1", "10", toDbnlistbotoBE.CODI_PAR1, toDbnlistbotoBE.CODI_PAR2, _goDbnlistbotoBE.CODI_PAR3, toDbnlistbotoBE.CODI_PAR4, toDbnlistbotoBE.CODI_PAR5, toDbnlistbotoBE.VAL_PAR1, toDbnlistbotoBE.VAL_PAR2, toDbnlistbotoBE.VAL_PAR3, toDbnlistbotoBE.VAL_PAR4, toDbnlistbotoBE.VAL_PAR5);
        _goSesionListador.Actual.psVal1 = toDbnlistbotoBE.VAL_PAR1; _goSesionListador.Actual.psVal2 = toDbnlistbotoBE.VAL_PAR2;
        _goSesionListador.Actual.psVal3 = toDbnlistbotoBE.VAL_PAR3; _goSesionListador.Actual.psVal4 = toDbnlistbotoBE.VAL_PAR4;
        _goSesionListador.Actual.psVal5 = toDbnlistbotoBE.VAL_PAR5; GuardaSesionListador();

        var loResultado = _goDbnlistrepoController.readReporteBE("C", 0, 0, null, toDbnlistbotoBE.VAL_PAR1, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        if (Session["tsListado"].ToString() == toDbnlistbotoBE.CODI_REPO)
            Response.Redirect(toDbnlistbotoBE.PAGE_BOTO + "?listado=" + toDbnlistbotoBE.VAL_PAR1 + "&modo=" + loResultado.MODO, true);
    }
    private void btnArch1(DbnListBotoBE toDbnlistbotoBE, int index, GridViewCommandEventArgs e, string tsBoton)
    {
        toDbnlistbotoBE = cicloDataTable(index, e, tsBoton);
        Session[toDbnlistbotoBE.CODI_PAR1] = toDbnlistbotoBE.VAL_PAR1;
        Session[toDbnlistbotoBE.CODI_PAR2] = toDbnlistbotoBE.VAL_PAR2;
        Session[toDbnlistbotoBE.CODI_PAR3] = toDbnlistbotoBE.VAL_PAR3;
        Session[toDbnlistbotoBE.CODI_PAR4] = toDbnlistbotoBE.VAL_PAR4;
        Session[toDbnlistbotoBE.CODI_PAR5] = toDbnlistbotoBE.VAL_PAR5;
        Session["P_MODO_REPO"] = this.modo();
        if (Session["tsListado"].ToString() == toDbnlistbotoBE.CODI_REPO)
        {
            string pScript = "window.open(\"" + toDbnlistbotoBE.PAGE_BOTO.Replace("~", "..") + "\",\"" + "Pop\",\"width=800,height=600,scrollbars=yes,toolbar=no,menubar=yes\");";// +
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
        }
    }
    private void btnArch2(DbnListBotoBE toDbnlistbotBE, int index, GridViewCommandEventArgs e, string tsBoton)
    {
        toDbnlistbotBE = cicloDataTable(index, e, tsBoton);
        Session["P_MODO_REPO"] = this.modo();
        Session[toDbnlistbotBE.CODI_PAR1] = toDbnlistbotBE.VAL_PAR1;
        Session[toDbnlistbotBE.CODI_PAR2] = toDbnlistbotBE.VAL_PAR2;
        Session[toDbnlistbotBE.CODI_PAR3] = toDbnlistbotBE.VAL_PAR3;
        Session[toDbnlistbotBE.CODI_PAR4] = toDbnlistbotBE.VAL_PAR4;
        Session[toDbnlistbotBE.CODI_PAR5] = toDbnlistbotBE.VAL_PAR5;
        if (Session["tsListado"].ToString() == toDbnlistbotBE.CODI_REPO)
        {
            string pScript = "window.open(\"" + toDbnlistbotBE.PAGE_BOTO.Replace("~", "..") + "\",\"" + "Pop\",\"width=800,height=600,scrollbars=yes,toolbar=no,menubar=yes\");";// +
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
        }
    }

    private void btnchkPro(DbnListBotoBE toDbnlistbotBE, int index, GridViewCommandEventArgs e, string tsBoton)
    {
        int linea = 0;
        int checkeds = 0;
        ValiErro _goValiErro = new ValiErro();

        foreach (GridViewRow grillas in grilla.Rows)
        {
            linea++;
            CheckBox seleccionado = (CheckBox)grillas.FindControl("chkSelect");
            if (seleccionado.Checked)
            {
                toDbnlistbotBE = cicloDataTable(linea -1, e, tsBoton);
                _goDbnlistrepoController.ejecutaCheck(this.ddlListaEje.SelectedValue, 0, 0, null, toDbnlistbotBE.VAL_PAR1, toDbnlistbotBE.VAL_PAR2, toDbnlistbotBE.VAL_PAR3, toDbnlistbotBE.VAL_PAR4, toDbnlistbotBE.VAL_PAR5, toDbnlistbotBE.CODI_PAR1, toDbnlistbotBE.CODI_PAR2, toDbnlistbotBE.CODI_PAR3, toDbnlistbotBE.CODI_PAR4, toDbnlistbotBE.CODI_PAR5, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX, _goValiErro);

                checkeds++;
            }
        }
        if (_goValiErro.p_codi_erro == "N")
        {
            this.lblCorrect.Text = "Ejecucion Correcta";
        }
        else if (_goValiErro.p_codi_erro == "S")
        {
            this.lblError.Text = "Errror:  " +_goValiErro.p_mens_erro;
        }

        if (checkeds == 0)
        {
            lblError.Text = "Debe Seleccionar algun Registro";
        }

    }


    private void CargaDdlModuloCheck(string tspar1)
    {
        ListaValoresControllers listavaloresController = new ListaValoresControllers();
        var lista = listavaloresController.readBtnCheck(null, 0, 0, null, tspar1, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        ddlListaEje.Items.Clear();
        Helper.ddlCarga(ddlListaEje, lista);
    }

    //ejecutaCheck
    protected void btnchkProcesar_Click(object sender, ImageClickEventArgs e)
    {
        if (this.ddlListaEje.SelectedValue.ToString() != "")
        btnchkPro(_goDbnlistbotoBE, 0, null, "btnCheck");
        else
            lblError.Text = "Debe Seleccionar Procedimiento";
    }

    //Eventos de botones tabulares
    protected void btnEditarTabular_Click(object sender, ImageClickEventArgs e)
    {
        btnEditar(_goDbnlistbotoBE, 0, null, "btnEditar");
    }

    protected void btnEjecutarTabular_Click(object sender, ImageClickEventArgs e)
    {
        btnEjecutar(_goDbnlistbotoBE, 0, null, "btnEjecutar");
    }

    protected void btnDetalleTabular1_Click(object sender, ImageClickEventArgs e)
    {
        btnDetalle(_goDbnlistbotoBE, 0, null, btnDetalleTabular1.CommandName);
    }
    protected void btnDetalleTabular2_Click(object sender, ImageClickEventArgs e)
    {
        btnDetalle(_goDbnlistbotoBE, 0, null, btnDetalleTabular2.CommandName);

    }
    protected void btnDetalleTabular3_Click(object sender, ImageClickEventArgs e)
    {
        btnDetalle(_goDbnlistbotoBE, 0, null, btnDetalleTabular3.CommandName);

    }
    protected void btnDetalleTabular4_Click(object sender, ImageClickEventArgs e)
    {
        btnDetalle(_goDbnlistbotoBE, 0, null, btnDetalleTabular4.CommandName);

    }
    protected void btnDetalleTabular5_Click(object sender, ImageClickEventArgs e)
    {
        btnDetalle(_goDbnlistbotoBE, 0, null, btnDetalleTabular5.CommandName);

    }
    protected void btnDetalleTabular6_Click(object sender, ImageClickEventArgs e)
    {
        btnDetalle(_goDbnlistbotoBE, 0, null, btnDetalleTabular6.CommandName);

    }
    protected void btnDetalleTabular7_Click(object sender, ImageClickEventArgs e)
    {
        btnDetalle(_goDbnlistbotoBE, 0, null, btnDetalleTabular7.CommandName);

    }
    protected void btnDetalleTabular8_Click(object sender, ImageClickEventArgs e)
    {
        btnDetalle(_goDbnlistbotoBE, 0, null, btnDetalleTabular8.CommandName);

    }
    protected void btnDetalleTabular9_Click(object sender, ImageClickEventArgs e)
    {
        btnDetalle(_goDbnlistbotoBE, 0, null, btnDetalleTabular9.CommandName);

    }
    protected void btnDetalleTabular10_Click(object sender, ImageClickEventArgs e)
    {
        btnDetalle(_goDbnlistbotoBE, 0, null, btnDetalleTabular10.CommandName);

    }


}