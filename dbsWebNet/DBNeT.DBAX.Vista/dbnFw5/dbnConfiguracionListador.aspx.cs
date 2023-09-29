using System;
using System.Configuration;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Resources;
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo.BE;
using DBNeT.Base.Modelo;
using DBNeT.Framework.Helper;
using System.Text;

public partial class dbnConfiguracionListador : System.Web.UI.Page
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
    string _gsCodiRepo;
    DbnListBotoController _goDbnlistbotoController;
    DbnListColuController _goDbnlistcoluController;
    DbnListRepoController _goDbnlistrepoController;
    DbnRepoRousController _goDbnreporousController;
    ListadorController _goListadorController;
    List<DbnListBotoBE> _gaBotongridColumna;
    List<DbnListBotoBE> _gaBotongridBoton;
    List<DbnListBotoBE> _gaBotongridPrivilegios;
    DbnListBotoBE _goDbnlistbotoBE;
    DbnListRepoBE _goDbnlistrepoBE;
    DbnListColuBE _goDbnlistcoluBE;
    DbnRepoRousBE _goDbnreporousBE;
    MantencionListador _goMantencionListador;

    protected void Page_Load(object sender, EventArgs e)
    {
        this.lblError.Text = string.Empty;
        RecuperaSessionWeb();
        _goDbnlistbotoController = new DbnListBotoController();
        _goDbnlistcoluController = new DbnListColuController();
        _goDbnlistrepoController = new DbnListRepoController();
        _goMantencionListador = new MantencionListador();
        try
        {
            #region Rescatar Modo (Ingreso o Mantención)

            if (Session["BTN_AGRE_MODO"] != null)
                _gsModo = Session["BTN_AGRE_MODO"].ToString();
            else
            {
                _gsModo = Session["P_MODO_REPO"].ToString();
                if (Session["CODI_REPO"] != null)
                { _gsCodiRepo = Session["CODI_REPO"].ToString(); }
            }

            #endregion

            //Se Agregan los Botones a la Grilla
            this.CargaBotones();
            this.ddlRepoTipoRepo.SelectedValue = "Maestro";
            if (!IsPostBack)
            {
                //this.CargaCbbRol();
                CargaDdlModulo();
                CargaDdlCategoria();
                this.ddlPrivilegiosRol.Items.Clear();
                this.ddlPrivilegiosRol.Items.Add("Seleccione un Modulo");
                this.ddlPrivilegiosRol.Enabled = false;
                #region Procedimiento para Seleccionar desde la grilla lo que se desea editar o Eliminar
                if (Session["VAL_PAR1"] == null && Session["tipo"] == null)
                { }
                else
                {
                    #region Grilla Columna
                    if (Session["grilla"].ToString() == "columna")
                    {
                        if (Session["tipo"].ToString() == "editar")
                        { this.CargaTextBoxColumna(_goDbnlistcoluController.readColumasBE("M", 0, 0, "", _gsCodiRepo, Session["VAL_PAR1"].ToString(), "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX)); }
                        else if (Session["tipo"].ToString() == "eliminar")
                        { _goDbnlistcoluController.deleteColumna(_gsCodiRepo, Session["VAL_PAR1"].ToString()); }
                    }
                    #endregion
                    #region Grilla Boton
                    else if (Session["grilla"].ToString() == "boton")
                    {
                        if (Session["tipo"].ToString() == "editar")
                        { this.CargaTextBoxBoton(_goDbnlistbotoController.readBotonesBE("M", 0, 0, "", _gsCodiRepo, Session["VAL_PAR1"].ToString(), "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX)); }
                        else if (Session["tipo"].ToString() == "eliminar")
                        { _goDbnlistbotoController.deleteBoton(_gsCodiRepo, Session["VAL_PAR1"].ToString()); }
                    }
                    #endregion
                    #region Grilla Privilegios
                    else if (Session["grilla"].ToString() == "privilegios")
                    {
                        if (Session["tipo"].ToString() == "eliminar")
                        { _goDbnreporousController.deleteRepoRous(_gsCodiRepo, Session["VAL_PAR1"].ToString(), Session["VAL_PAR2"].ToString()); }
                    }
                    #endregion
                }
                #endregion
                this.CargaReporte(_goDbnlistrepoController.readReporteBE("C",0,0,null,_gsCodiRepo,null,null,null,null,_goSessionWeb.CODI_USUA,_goSessionWeb.CODI_EMPR,_goSessionWeb.CODI_EMEX));
                this.CargaMultienguaje();
                if (_gsModo.ToUpper() == "CI")
                { this.txtReporteCodigo.Enabled = true; }
                else
                { this.txtReporteCodigo.Enabled = false; }
            }
            this.CreacionGrillas();
            //Metodo que Carga los datos del Reporte ademas asigna los datos a las grillas
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
    }
    private void CargaMultienguaje()
    {
        #region Encabezado
        this.lblRepoTitulo.Text = multilenguaje_base.L_TITU_MANTENEDOR_LISTADOR;
        this.lblRepoCodigoMultilenguaje.Text = multilenguaje_base.lblCodigoMultilenguaje;
        this.lblRepoCodigoReporte.Text = multilenguaje_base.lblCodigoReporte;
        this.lblRepoFiltro.Text = multilenguaje_base.lblFiltro;
        this.lblRepoProcedimiento.Text = multilenguaje_base.lblProcedimiento;
        this.lblRepoTituloReporte.Text = multilenguaje_base.lblTituloReporte;
        this.lblRepoDescripcion.Text = multilenguaje_base.lblDescripcion;
        this.lblPageRepo.Text = multilenguaje_base.lblPageRepo;
        this.lblRepoCate.Text = multilenguaje_base.lblCateRepo;
        lblModo.Text = "Modo";
        this.lblTipoRepo.Text = "Tipo Reporte";
        #endregion
        #region DIV SQL
        this.lblOracle.Text = multilenguaje_base.lblOracle;
        this.lblSQLServer.Text = multilenguaje_base.lblSqlServer;
        this.lblSubtitulo.Text = "Subtitulo";
        #endregion
        #region Div Boton
        this.lblBotoClaseCss.Text = multilenguaje_base.lblBotoClaseCss;
        this.lblBotoCodigo.Text = multilenguaje_base.lblBotoCodigo;
        this.lblBotoCodigoMulti.Text = multilenguaje_base.lblBotoCodigoMulti;
        this.lblBotoDescripcion.Text = multilenguaje_base.lblBotoDescripcion;
        this.lblBotoOrden.Text = multilenguaje_base.lblBotoOrden;
        this.dbnLabelBotoProcedimiento.Text = multilenguaje_base.dbnLabelBotoProcedimiento;
        this.lblBotoParametro1.Text = multilenguaje_base.lblBotoParametro1;
        this.lblBotoParametro2.Text = multilenguaje_base.lblBotoParametro2;
        this.lblBotoParametro3.Text = multilenguaje_base.lblBotoParametro3;
        this.lblBotoParametro4.Text = multilenguaje_base.lblBotoParametro4;
        this.lblBotoParametro5.Text = multilenguaje_base.lblBotoParametro5;
        //this.lblBotoTipo.Text = multilenguaje_base.lblBotoTipo;
        this.lblBotoTitulo.Text = multilenguaje_base.lblBotoTitulo;
        this.lblBotoUrl.Text = multilenguaje_base.lblBotoUrl;
        this.lblBotoVisible.Text = multilenguaje_base.lblColuVisible;
        this.lblBotoModo.Text = multilenguaje_base.MODO;
        lblBotoDetalle.Text = multilenguaje_base.lblBotoDetalle;
        #endregion
        #region Div Columna
        this.lblColuAlineacion.Text = multilenguaje_base.lblColuAlineacion;
        this.lblColuAncho.Text = multilenguaje_base.lblColuAncho;
        this.lblColuClaseCss.Text = multilenguaje_base.lblColuClaseCss;
        this.lblColuCodigo.Text = multilenguaje_base.lblColuCodigo;
        this.lblColuCodigoBusqueda.Text = multilenguaje_base.lblColuCodigoBusqueda;
        this.lblColuCodigoMultilenguaje.Text = multilenguaje_base.lblColuCodigoMultilenguaje;
        this.lblColuDescripcion.Text = multilenguaje_base.lblColuDescripcion;
        this.lblColuFormato.Text = multilenguaje_base.lblColuFormato;
        this.lblColuImagen.Text = multilenguaje_base.lblColuImagen;
        this.lblColuOrden.Text = multilenguaje_base.lblColuOrden;
        this.lblColuTipoBusqueda.Text = multilenguaje_base.lblColuTipoBusqueda;
        this.lblColuTitulo.Text = multilenguaje_base.lblColuTitulo;
        this.lblColuVisible.Text = multilenguaje_base.lblColuVisible;
        this.lblColuTipoColu.Text = multilenguaje_base.lblColuTipoColumna;
        this.lblColuJQuery.Text = multilenguaje_base.lblColuJQuery;
        this.lblColuIndicadorBusqueda.Text = multilenguaje_base.lblColuIndiBusq;
        //this.lblBotoProcedimiento.Text = multilenguaje_base.lblBotoProcedimiento;
        this.lblBotoImagen.Text = multilenguaje_base.lblBotoImagen;
        this.lblColuIndi1.Text = multilenguaje_base.lblColuIndi1;
        this.lblColuIndi2.Text = multilenguaje_base.lblColuIndi2;
        this.lblColuLiVa.Text = multilenguaje_base.lblColuLiVa;
        #endregion
        #region Div Privilegios.
        this.lblPrivilegiosModulo.Text = multilenguaje_base.lblPrivilegiosModulo;
        this.lblPrivilegiosRol.Text = multilenguaje_base.lblPrivilegiosRol;
        this.lblPrivilegiosExcel.Text = multilenguaje_base.lblPrivilegiosExcel;
        #endregion
        /* Botones */
        this.btnActualizar.ToolTip = multilenguaje_base.tt_btnActualizar;
        this.btnVolver.ToolTip = multilenguaje_base.tt_btnVolver;
        this.btnEliminar.ToolTip = multilenguaje_base.tt_btnEliminar;
        this.btnProcesar.ToolTip = multilenguaje_base.tt_btnProcesar;
    }
    private void CargaDdlModulo()
    {
        ListaValoresControllers listavaloresController = new ListaValoresControllers();
        var lista = listavaloresController.readSysModule("LV", 0, 0, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        this.ddlPrivilegiosModulo.Items.Clear();
        Helper.ddlCarga(ddlPrivilegiosModulo, lista);
    }
    private void CargaDdlCategoria()
    {
        var loResultado = _goDbnlistrepoController.readCategorias();
        Helper.ddlCarga(ddlRepoCate, loResultado);
    }

    private void CargaCbbRol(string codi_modu)
    {
        ListaValoresControllers listavalores = new ListaValoresControllers();
        var lista = listavalores.readSysRous("LVA", 0, 0, null, codi_modu, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        this.ddlPrivilegiosRol.Items.Clear();
        this.ddlPrivilegiosRol.Items.Add(new ListItem("Seleccione una Opción"));
        if (lista.Rows.Count > 0)
        { Helper.ddlCarga(ddlPrivilegiosRol, lista); this.ddlPrivilegiosRol.Enabled = true; }
        else
        {
            this.ddlPrivilegiosRol.Items.Clear();
            this.ddlPrivilegiosRol.Items.Add(new ListItem("Seleccione un Módulo"));
            this.ddlPrivilegiosRol.Enabled = false;
        }
        this.ddlPrivilegiosRol.Enabled = true;
    }

    /// <summary> Carga Reporte
    /// Metodo Para Asignar Los Datos del Reporte a los TextBox
    /// </summary>
    /// <param name="listaReporte">Lista de Tipo DbnListRepoBE</param>
    private void CargaReporte(DbnListRepoBE item)
    {
        Session["oListRepo"] = item;
        this.txtReporteTituloReporte.Text = item.TITU_REPO;
        this.txtReporteCodigo.Text = item.CODI_REPO;
        this.txtReporteCodigoMultilenguaje.Text = item.CODI_RESX;
        this.txtReporteProcedimiento.Text = item.PROC_REPO;
        this.txtReporteDescripcion.Text = item.DESC_REPO;
        this.txaSubtitulo.Text = item.SUBT_CNTX;
        this.txaSQLServer.Text = item.SCRP_SQLS;
        this.txaOracle.Text = item.SCRP_SQLO;
        this.txtPageRepo.Text = item.PAGE_REPO;
        this.ddlModo.SelectedValue = item.MODO;
        this.ddlRepoCate.SelectedValue = item.CATE_LIST;
        this.ckbFiltro.Checked = _goMantencionListador.VerificaFiltroReporte(Convert.ToInt32(item.FILT_CKBB));
        this.ddlRepoTipoRepo.SelectedValue = item.TIPO_REPO;
    }
    /// <summary> Carga Reporte
    /// Metodo Para Asignar los datos al DataSource de la Grilla Columna
    /// </summary>
    /// <param name="listaColumna">DataTable</param>
    private void CargaColumna(DataTable listaColumna)
    {
        this.grillaColumna.DataSource = listaColumna;
        this.grillaColumna.DataBind();
    }
    /// <summary> Carga Boton
    /// Metodo para Asignar Los Datos al DataSource de la Grilla Boton
    /// </summary>
    /// <param name="listaBoton">DataTable</param>
    private void CargaBoton(DataTable listaBoton)
    {
        this.grillaBoton.DataSource = listaBoton;
        this.grillaBoton.DataBind();
    }
    /// <summary>
    /// Metodo para Asignar los Datos a La grillaPrivilegios
    /// </summary>
    /// <param name="listaPrivilegios">DataTable</param>
    private void CargaPrivilegios(DataTable listaPrivilegios)
    {
        this.grillaPrivilegios.DataSource = listaPrivilegios;
        this.grillaPrivilegios.DataBind();
    }

    private void CargaBotones()
    {
        CargaBotonGrillaColumna();
        CargaBotonGrillaBoton();
        CargaBotonGrillaPrivilegios();
    }
    private void CargaBotonGrillaColumna()
    {
        _gaBotongridColumna = new List<DbnListBotoBE>();
        _goDbnlistbotoController = new DbnListBotoController();
        _gaBotongridColumna = _goDbnlistbotoController.readBotones("C", 0, 0, "", "L_MANT_LIST_COLU", "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        #region Foreach para Asignar Los datos de la Lista a la BE
        //foreach (var liBotonesBE in _gaBotongridColumna)
        //{
        //    ButtonField btnField = new ButtonField();
        //    btnField.ButtonType = ButtonType.Image;
        //    btnField.DataTextField = liBotonesBE.CODI_PAR1;
        //    btnField.ImageUrl = "../librerias/img/botones/" + liBotonesBE.IMAG_BOTO;
        //    btnField.CommandName = liBotonesBE.NOMB_BOTO;
        //    btnField.ItemStyle.CssClass = liBotonesBE.CLAS_CSS; 
        //    if (liBotonesBE.INDI_VISI == "1")
        //        btnField.Visible = true;
        //    else if (liBotonesBE.INDI_VISI == "0")
        //        btnField.Visible = false;
        //    grillaColumna.Columns.Add(btnField);
        //    grillaColumna.DataBind();
        //}
        #endregion
    }
    private void CargaBotonGrillaBoton()
    {
        _gaBotongridBoton = new List<DbnListBotoBE>();
        _goDbnlistbotoController = new DbnListBotoController();
        _gaBotongridBoton = _goDbnlistbotoController.readBotones("C", 0, 0, "", "L_MANT_LIST_BOTO", "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        #region Foreach para Asignar Los datos de la Lista a la BE
        //foreach (var liBotonesBE in _gaBotongridBoton)
        //{
        //    ButtonField btnField = new ButtonField();
        //    btnField.ButtonType = ButtonType.Image;
        //    btnField.DataTextField = liBotonesBE.CODI_PAR1;
        //    btnField.ImageUrl = "../librerias/img/botones/" + liBotonesBE.IMAG_BOTO;
        //    btnField.CommandName = liBotonesBE.NOMB_BOTO;
        //    btnField.ItemStyle.CssClass = liBotonesBE.CLAS_CSS;
        //    if (liBotonesBE.INDI_VISI == "1")
        //        btnField.Visible = true;
        //    else if (liBotonesBE.INDI_VISI == "0")
        //        btnField.Visible = false;
        //    grillaBoton.Columns.Add(btnField);
        //    grillaBoton.DataBind();
        //}
        #endregion
    }
    private void CargaBotonGrillaPrivilegios()
    {
        _gaBotongridPrivilegios = new List<DbnListBotoBE>();
        _goDbnreporousController = new DbnRepoRousController();
        _gaBotongridPrivilegios = _goDbnlistbotoController.readBotones("C", 0, 0, "", "L_MANT_LIST_PRIV", "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        #region Foreach para asignar las propiedades a los botones
        //foreach (var item in _gaBotongridPrivilegios)
        //{
        //    ButtonField btnField = new ButtonField();
        //    btnField.ButtonType = ButtonType.Image;
        //    btnField.DataTextField = item.CODI_PAR1;
        //    btnField.ImageUrl = "../librerias/img/botones/" + item.IMAG_BOTO;
        //    btnField.CommandName = item.NOMB_BOTO;
        //    btnField.ItemStyle.CssClass = item.CLAS_CSS;
        //    if (item.INDI_VISI == "1")
        //        btnField.Visible = true;
        //    else if (item.INDI_VISI == "0")
        //        btnField.Visible = false;
        //    grillaPrivilegios.Columns.Add(btnField);
        //    grillaPrivilegios.DataBind();
        //}
        #endregion
    }

    private void CreacionGrillas()
    {
        this.CreaGrillaBoton();
        this.CreaGrillaColumna();
        this.CreaGrillaPrivilegios(); 
    }
    private void CreaGrillaColumna()
    {
        DataTable columna = _goDbnlistcoluController.readColumnasDt("C", 0, 0, "", _gsCodiRepo, "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        this.CargaColumna(columna);
    }
    private void CreaGrillaBoton()
    {
        DataTable boton = _goDbnlistbotoController.readBotonesDt("C", 0, 0, "", _gsCodiRepo, "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        this.CargaBoton(boton);
    }
    private void CreaGrillaPrivilegios()
    {
        DataTable ldPrivilegios = _goDbnreporousController.readRepoRousDt("C", 0, 0, "", _gsCodiRepo, "", "", "", "", _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
        this.CargaPrivilegios(ldPrivilegios);
    }

    private void CargaTextBoxColumna(DbnListColuBE item)
    {
            this.txtColuAncho.Text = item.ANCH_COLU;
            this.ddlClasCss.SelectedValue = item.CLAS_CSS;
            this.txtColuCodigo.Text = item.CODI_COLU;
            this.txtColuCodigoBusqueda.Text = item.COLU_BUSQ;
            this.txtColuCodigoMulti.Text = item.CODI_RESX;
            this.txtColuDescripcion.Text = item.DESC_COLU;
            this.txtColuImagen.Text = item.IMAG_COLU;
            this.txtColuOrden.Text = item.ORDE_COLU.ToString();
            this.txtColuTitulo.Text = item.NOMB_COLU;
            this.ddlColuAlineacion.SelectedValue = item.ALIN_COLU;
            this.ddlColuFormato.SelectedValue = item.FORM_COLU;
            this.ddlColuTipoBusqueda.SelectedValue = item.TIPO_BUSQ;
            this.ddlColuTipoColumna.SelectedValue= item.TIPO_COLU;
            this.ckbColuIndiBusqueda.Checked = _goMantencionListador.VerificaBusquedaAvanzada(_goMantencionListador.VerificaNull(item.INDI_BUSQ));
            this.ckbColuVisible.Checked = _goMantencionListador.VerificaVisible(_goMantencionListador.VerificaNull(item.INDI_VISI));
            this.txtColuIndi1.Text = item.VERD_BUSQ;
            this.txtColuIndi2.Text = item.FALS_BUSQ;
            this.txtColuLiVa.Text = item.CODI_LIVA;
    }
    private void CargaTextBoxBoton(DbnListBotoBE item)
    {
        this.ddlClaseCss.SelectedValue = item.CLAS_CSS;
        //Helper.ddlSelecciona(ddlTipoBoton, item.TIPO_BOTO);
        this.txtBotoCodigo.Text = item.CODI_BOTO;
        this.txtBotoCodMulti.Text = item.CODI_RESX;
        this.txtBotoDescripcion.Text = item.DESC_BOTO;
        this.txtBotoOrden.Text = item.ORDE_BOTO.ToString();
        this.txtBotoPara1.Text = item.CODI_PAR1;
        this.txtBotoPara2.Text = item.CODI_PAR2;
        this.txtBotoPara3.Text = item.CODI_PAR3;
        this.txtBotoPara4.Text = item.CODI_PAR4;
        this.txtBotoPara5.Text = item.CODI_PAR5;
        //this.ddlTipoBoton.SelectedValue = item.TIPO_BOTO;
        this.txtBotoProcedimiento.Text = item.PROC_BOTO;
        this.ddlNombreTitulo.SelectedValue = item.NOMB_BOTO;
        this.txtBotoUrl.Text = item.PAGE_BOTO;
        //this.ddlBotoImagen.SelectedValue = item.IMAG_BOTO;
        this.txtBotoImagen.Text = item.IMAG_BOTO;
        if(item.MODO_BOTO.Contains("(M)"))
        { ckbModoM.Checked = true;}
        if (item.MODO_BOTO.Contains("(CE)"))
        { ckbModoCE.Checked = true; }
        if (item.MODO_BOTO.Contains("(CI)"))
        { ckbModoCI.Checked = true; }
        if (item.MODO_BOTO.Contains("(C)"))
        { ckbModoC.Checked = true; }
        if (item.MODO_BOTO.Contains("(T)"))
        { ckbModoT.Checked = true; }
        this.txtBotoDetalle.Text = item.LIST_DETA;
        this.ckbBotoVisible.Checked = _goMantencionListador.VerificaVisible(_goMantencionListador.VerificaNull(item.INDI_VISI));
    }
    private void CargaTextBoxPrivilegios(DbnRepoRousBE item)
    {
        this.ddlPrivilegiosModulo.SelectedValue = item.CODI_MODU;
        this.ddlPrivilegiosRol.SelectedValue = item.CODI_ROUS;
    }
    
    /// <summary>
    /// Metodo para Limpiar los txt de las columnas y botones y los ddl dejarlos en index 0
    /// </summary>
    private void LimpiarTxt()
    {
        this.txtColuCodigo.Text = string.Empty;
        this.txtColuTitulo.Text = string.Empty;
        this.txtColuDescripcion.Text = string.Empty;
        this.txtColuCodigoMulti.Text = string.Empty;
        this.ddlClasCss.SelectedIndex = 0;
        this.ddlColuTipoColumna.SelectedIndex = 0;
        this.txtColuAncho.Text = string.Empty;
        this.ddlColuAlineacion.SelectedIndex = 0;
        this.ddlColuFormato.SelectedIndex = 0;
        this.ckbColuVisible.Checked = false;
        this.txtColuImagen.Text = string.Empty;
        this.txtColuJquery.Text = string.Empty;
        this.txtColuOrden.Text = string.Empty;
        this.ckbColuIndiBusqueda.Checked = false;
        this.ddlColuTipoBusqueda.SelectedIndex = 0;
        this.txtColuCodigoBusqueda.Text = string.Empty;
        this.txtColuIndi1.Text = string.Empty;
        this.txtColuIndi2.Text = string.Empty;
        this.txtColuLiVa.Text = string.Empty;

        this.ddlPrivilegiosModulo.SelectedIndex = 0;
        this.ddlPrivilegiosRol.SelectedIndex = 0;

        this.txtBotoCodigo.Text = string.Empty;
        this.ddlNombreTitulo.SelectedIndex = 0;
        this.txtBotoDescripcion.Text = string.Empty;
        //this.ddlTipoBoton.SelectedIndex = 0;
        this.txtBotoCodMulti.Text = string.Empty;
        this.ddlClaseCss.SelectedIndex = 0;
        //this.ddlBotoImagen.SelectedIndex = 0;
        this.txtBotoUrl.Text = string.Empty;
        this.txtBotoProcedimiento.Text = string.Empty;
        this.txtBotoPara1.Text = string.Empty;
        this.txtBotoPara2.Text = string.Empty;
        this.txtBotoPara3.Text = string.Empty;
        this.txtBotoPara4.Text = string.Empty;
        this.txtBotoPara5.Text = string.Empty;
        this.txtBotoDetalle.Text = string.Empty;
        //this.ddlBotoImagen.SelectedIndex = 0;
        this.txtBotoOrden.Text = string.Empty;
        this.ckbBotoVisible.Checked = false;
        this.ckbModoM.Checked = false;
        this.ckbModoCE.Checked = false;
        this.ckbModoCI.Checked = false;
        this.ckbModoC.Checked = false;
        this.ckbModoT.Checked = false;
    }
    private void DefaultTxt()
    {
        this.txtColuAncho.Text = "100";
        this.ddlColuTipoColumna.SelectedValue = "texto";
        this.ddlColuAlineacion.SelectedValue = "L";
        this.ddlColuFormato.SelectedIndex = 1;
        ckbColuVisible.Checked = true;
        ddlClasCss.SelectedValue = "Bounfield";

        ckbBotoVisible.Checked = true;
    }
    protected void ddlPrivilegiosModulo_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.CreacionGrillas();
        this.CargaCbbRol(this.ddlPrivilegiosModulo.SelectedValue);
    }

    protected void btnActualizar_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["oListRepo"] == null)
            { _goDbnlistrepoBE = new DbnListRepoBE(); }
            else
            { _goDbnlistrepoBE = (DbnListRepoBE)Session["oListRepo"]; }

            _goDbnlistrepoController = new DbnListRepoController();
            //Reporte
            _goDbnlistrepoBE.CODI_REPO = this.txtReporteCodigo.Text; 
            _goDbnlistrepoBE.CODI_RESX = this.txtReporteCodigoMultilenguaje.Text;
            _goDbnlistrepoBE.TITU_REPO = this.txtReporteTituloReporte.Text;
            _goDbnlistrepoBE.DESC_REPO = this.txtReporteDescripcion.Text;
            _goDbnlistrepoBE.PROC_REPO = this.txtReporteProcedimiento.Text;
            _goDbnlistrepoBE.SCRP_SQLO = this.txaOracle.Text;
            _goDbnlistrepoBE.SCRP_SQLS = this.txaSQLServer.Text;
            _goDbnlistrepoBE.SUBT_CNTX = this.txaSubtitulo.Text;
            _goDbnlistrepoBE.PAGE_REPO = this.txtPageRepo.Text;
            _goDbnlistrepoBE.MODO = this.ddlModo.SelectedValue;
            _goDbnlistrepoBE.CATE_LIST = this.ddlRepoCate.SelectedValue;
            _goDbnlistrepoBE.FILT_CKBB = _goMantencionListador.VerificaFiltroReporte(this.ckbFiltro.Checked).ToString();
            _goDbnlistrepoBE.TIPO_REPO = this.ddlRepoTipoRepo.SelectedValue;
            if (_gsModo == "CI" || _gsModo == null)
            { 
                _goDbnlistrepoController.createReporte(_goDbnlistrepoBE);
                this.txtReporteCodigo.Enabled = false; 
                _gsCodiRepo = this.txtReporteCodigo.Text;
                Session["CODI_REPO"] = _gsCodiRepo;
                Session["P_MODO_REPO"] = "M";
                this.EliminacionSession();
            }
            if (_gsModo == "M")
            { if (e != null) { _goDbnlistrepoController.updateReporte(_goDbnlistrepoBE); } }
            _gsCodiRepo = this.txtReporteCodigo.Text;
            Session["CODI_REPO"] = _gsCodiRepo;
            this.CargaReporte(_goDbnlistrepoController.readReporteBE("C",0,0,null,_gsCodiRepo,null,null,null,null,_goSessionWeb.CODI_USUA,_goSessionWeb.CODI_EMPR,_goSessionWeb.CODI_EMEX));
            this.CreacionGrillas();
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
    }
    protected void btnEliminar_Click(object sender, EventArgs e)
    {
        try
        {
            _goDbnlistbotoController = new DbnListBotoController();
            _goDbnlistcoluController = new DbnListColuController();
            _goDbnlistrepoController = new DbnListRepoController();
            _goDbnreporousController = new DbnRepoRousController();
            _goDbnlistbotoController.deleteBoton(this.txtReporteCodigo.Text);
            _goDbnlistcoluController.deleteColumna(this.txtReporteCodigo.Text);
            _goDbnreporousController.deleteRepoRous(this.txtReporteCodigo.Text);
            _goDbnlistrepoController.deleteReporte(this.txtReporteCodigo.Text);
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
        finally
        { LimpiarTxt(); Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=" + Session["tsListado"].ToString() + "&MODO=" + Session["P_MODO_REPO"].ToString(), true); } 
    }
    protected void btnVolver_Click(object sender, EventArgs e)
    {
        Session.Remove("BTN_AGRE_MODO");
        Session.Remove("CODI_REPO");
        this.EliminacionSession();
        LimpiarTxt();
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_MANT_LIST&MODO=" + Session["P_MODO_REPO"].ToString(), true);
    }
    protected void btnColuIngreso_Click(object sender, EventArgs e)
    {
        btnActualizar_Click(null, null);
        try
        {
            if (lblError.Text.Trim().Length == 0)
            {
                if (txtColuCodigo.Text.Trim().Length > 0)
                {
                    _goDbnlistcoluBE = new DbnListColuBE();
                    _goDbnlistcoluController = new DbnListColuController();
                    _goDbnlistcoluBE.CODI_REPO = this.txtReporteCodigo.Text;
                    _goDbnlistcoluBE.ANCH_COLU = this.txtColuAncho.Text;
                    _goDbnlistcoluBE.ALIN_COLU = this.ddlColuAlineacion.SelectedValue;
                    _goDbnlistcoluBE.CLAS_CSS = this.ddlClasCss.SelectedValue;
                    _goDbnlistcoluBE.CODI_COLU = this.txtColuCodigo.Text;
                    _goDbnlistcoluBE.CODI_RESX = this.txtColuCodigoMulti.Text;
                    _goDbnlistcoluBE.COLU_BUSQ = this.txtColuCodigoBusqueda.Text;
                    _goDbnlistcoluBE.DESC_COLU = this.txtColuDescripcion.Text;
                    _goDbnlistcoluBE.FORM_COLU = this.ddlColuFormato.SelectedValue;
                    _goDbnlistcoluBE.IMAG_COLU = this.txtColuImagen.Text;
                    _goDbnlistcoluBE.INDI_BUSQ = _goMantencionListador.VerificaColumnaBusquedaAvanzada(this.ckbColuIndiBusqueda.Checked).ToString();
                    _goDbnlistcoluBE.INDI_VISI = _goMantencionListador.VerificaColuVisible(this.ckbColuVisible.Checked).ToString();
                    _goDbnlistcoluBE.JQRY_COLU = this.txtColuJquery.Text;
                    _goDbnlistcoluBE.NOMB_COLU = this.txtColuTitulo.Text;
                    _goDbnlistcoluBE.ORDE_COLU = DBHelper.devuelveInt(this.txtColuOrden.Text);
                    _goDbnlistcoluBE.TIPO_BUSQ = this.ddlColuTipoBusqueda.SelectedValue;
                    _goDbnlistcoluBE.TIPO_COLU = this.ddlColuTipoColumna.SelectedValue;
                    _goDbnlistcoluBE.VERD_BUSQ = this.txtColuIndi1.Text;
                    _goDbnlistcoluBE.FALS_BUSQ = this.txtColuIndi2.Text;
                    _goDbnlistcoluBE.CODI_LIVA = this.txtColuLiVa.Text;
                    _goDbnlistcoluController.createColumna(_goDbnlistcoluBE);
                }
            }
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
        finally
        { this.LimpiarTxt(); this.CreacionGrillas(); this.EliminacionSession(); DefaultTxt(); }
    }
    protected void btnColuActualiza_Click(object sender, EventArgs e)
    {
        btnActualizar_Click(null, null);
        try
        {
            if (lblError.Text.Trim().Length == 0)
            {
                if (this.txtColuCodigo.Text.Trim().Length > 0)
                {
                    _goDbnlistcoluBE = new DbnListColuBE();
                    _goDbnlistcoluController = new DbnListColuController();
                    _goDbnlistcoluBE.CODI_REPO = this.txtReporteCodigo.Text;
                    _goDbnlistcoluBE.ANCH_COLU = this.txtColuAncho.Text;
                    _goDbnlistcoluBE.ALIN_COLU = this.ddlColuAlineacion.SelectedValue;
                    _goDbnlistcoluBE.CLAS_CSS = this.ddlClasCss.SelectedValue;
                    _goDbnlistcoluBE.CODI_COLU = this.txtColuCodigo.Text;
                    _goDbnlistcoluBE.CODI_RESX = this.txtColuCodigoMulti.Text;
                    _goDbnlistcoluBE.COLU_BUSQ = this.txtColuCodigoBusqueda.Text;
                    _goDbnlistcoluBE.DESC_COLU = this.txtColuDescripcion.Text;
                    _goDbnlistcoluBE.FORM_COLU = this.ddlColuFormato.SelectedValue;
                    _goDbnlistcoluBE.IMAG_COLU = this.txtColuImagen.Text;
                    _goDbnlistcoluBE.INDI_BUSQ = _goMantencionListador.VerificaColumnaBusquedaAvanzada(this.ckbColuIndiBusqueda.Checked).ToString();
                    _goDbnlistcoluBE.INDI_VISI = _goMantencionListador.VerificaColuVisible(this.ckbColuVisible.Checked).ToString();
                    _goDbnlistcoluBE.JQRY_COLU = this.txtColuJquery.Text;
                    _goDbnlistcoluBE.NOMB_COLU = this.txtColuTitulo.Text;
                    _goDbnlistcoluBE.ORDE_COLU = DBHelper.devuelveInt(this.txtColuOrden.Text);
                    _goDbnlistcoluBE.TIPO_BUSQ = this.ddlColuTipoBusqueda.SelectedValue;
                    _goDbnlistcoluBE.TIPO_COLU = this.ddlColuTipoColumna.SelectedValue;
                    _goDbnlistcoluBE.VERD_BUSQ = this.txtColuIndi1.Text;
                    _goDbnlistcoluBE.FALS_BUSQ = this.txtColuIndi2.Text;
                    _goDbnlistcoluBE.CODI_LIVA = this.txtColuLiVa.Text;
                    _goDbnlistcoluController.updateColumna(_goDbnlistcoluBE);
                }
            }
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
        finally
        { this.LimpiarTxt(); this.CreacionGrillas(); this.EliminacionSession(); DefaultTxt(); }
    }
    protected void btnBotoIngresa_Click(object sender, EventArgs e)
    {
        btnActualizar_Click(null, null);
        try
        {

            if (lblError.Text.Trim().Length == 0)
            {
                if (this.txtBotoCodigo.Text.Trim().Length > 0)
                {
                    _goDbnlistbotoBE = new DbnListBotoBE();
                    _goDbnlistbotoController = new DbnListBotoController();
                    _goDbnlistbotoBE.CODI_REPO = this.txtReporteCodigo.Text;
                    _goDbnlistbotoBE.CODI_BOTO = this.txtBotoCodigo.Text;
                    _goDbnlistbotoBE.NOMB_BOTO = this.ddlNombreTitulo.SelectedValue;
                    _goDbnlistbotoBE.DESC_BOTO = this.txtBotoDescripcion.Text;
                    //_goDbnlistbotoBE.TIPO_BOTO = this.ddlTipoBoton.SelectedValue;
                    _goDbnlistbotoBE.CODI_RESX = this.txtBotoCodMulti.Text;
                    _goDbnlistbotoBE.CLAS_CSS = this.ddlClaseCss.SelectedValue;
                    _goDbnlistbotoBE.PAGE_BOTO = this.txtBotoUrl.Text;
                    _goDbnlistbotoBE.PROC_BOTO = this.txtBotoProcedimiento.Text;
                    _goDbnlistbotoBE.CODI_PAR1 = this.txtBotoPara1.Text;
                    _goDbnlistbotoBE.CODI_PAR2 = this.txtBotoPara2.Text;
                    _goDbnlistbotoBE.CODI_PAR3 = this.txtBotoPara3.Text;
                    _goDbnlistbotoBE.CODI_PAR4 = this.txtBotoPara4.Text;
                    _goDbnlistbotoBE.CODI_PAR5 = this.txtBotoPara5.Text;
                    //_goDbnlistbotoBE.IMAG_BOTO = this.ddlBotoImagen.SelectedValue;
                    _goDbnlistbotoBE.IMAG_BOTO = this.txtBotoImagen.Text;
                    _goDbnlistbotoBE.ORDE_BOTO = DBHelper.devuelveInt(this.txtBotoOrden.Text);
                    _goDbnlistbotoBE.INDI_VISI = _goMantencionListador.VerificaBotoVisible(this.ckbBotoVisible.Checked).ToString();
                    _goDbnlistbotoBE.MODO_BOTO = this.VerificaCkbModo();
                    _goDbnlistbotoBE.LIST_DETA = this.txtBotoDetalle.Text;
                    _goDbnlistbotoController.createBoton(_goDbnlistbotoBE);
                }
            }
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
        finally
        { this.LimpiarTxt(); this.CreacionGrillas(); this.EliminacionSession(); DefaultTxt(); }
    }
    protected void btnBotoActualiza_Click(object sender, EventArgs e)
    {
        btnActualizar_Click(null, null);
        try
        {
            if (lblError.Text.Trim().Length == 0)
            {
                if (this.txtBotoCodigo.Text.Trim().Length > 0)
                {
                    _goDbnlistbotoBE = new DbnListBotoBE();
                    _goDbnlistbotoController = new DbnListBotoController();
                    _goDbnlistbotoBE.CODI_REPO = this.txtReporteCodigo.Text;
                    _goDbnlistbotoBE.CODI_BOTO = this.txtBotoCodigo.Text;
                    _goDbnlistbotoBE.NOMB_BOTO = this.ddlNombreTitulo.SelectedValue;
                    _goDbnlistbotoBE.DESC_BOTO = this.txtBotoDescripcion.Text;
                    //_goDbnlistbotoBE.TIPO_BOTO = this.ddlTipoBoton.SelectedValue;
                    _goDbnlistbotoBE.CODI_RESX = this.txtBotoCodMulti.Text;
                    _goDbnlistbotoBE.CLAS_CSS = this.ddlClaseCss.SelectedValue;
                    _goDbnlistbotoBE.PAGE_BOTO = this.txtBotoUrl.Text;
                    _goDbnlistbotoBE.PROC_BOTO = this.txtBotoProcedimiento.Text;
                    _goDbnlistbotoBE.CODI_PAR1 = this.txtBotoPara1.Text;
                    _goDbnlistbotoBE.CODI_PAR2 = this.txtBotoPara2.Text;
                    _goDbnlistbotoBE.CODI_PAR3 = this.txtBotoPara3.Text;
                    _goDbnlistbotoBE.CODI_PAR4 = this.txtBotoPara4.Text;
                    _goDbnlistbotoBE.CODI_PAR5 = this.txtBotoPara5.Text;
                    //_goDbnlistbotoBE.IMAG_BOTO = this.ddlBotoImagen.SelectedValue;
                    _goDbnlistbotoBE.IMAG_BOTO = this.txtBotoImagen.Text;
                    _goDbnlistbotoBE.ORDE_BOTO = DBHelper.devuelveInt(this.txtBotoOrden.Text);
                    _goDbnlistbotoBE.INDI_VISI = _goMantencionListador.VerificaBotoVisible(this.ckbBotoVisible.Checked).ToString();
                    _goDbnlistbotoBE.MODO_BOTO = this.VerificaCkbModo();
                    _goDbnlistbotoBE.LIST_DETA = this.txtBotoDetalle.Text;
                    _goDbnlistbotoController.updateBoton(_goDbnlistbotoBE);
                }
            }
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
        finally
        { this.LimpiarTxt(); this.CreacionGrillas(); this.EliminacionSession(); DefaultTxt(); }
    }
    protected void btnPrivilegiosIngresar_Click(object sender, EventArgs e)
    {
        btnActualizar_Click(null, null);
        try
        {
            if (lblError.Text.Trim().Length == 0)
            {
                if (ddlPrivilegiosModulo.SelectedIndex > 0)
                {
                    _goDbnreporousBE = new DbnRepoRousBE();
                    _goDbnreporousController = new DbnRepoRousController();
                    _goDbnreporousBE.CODI_MODU = this.ddlPrivilegiosModulo.SelectedValue;
                    _goDbnreporousBE.CODI_REPO = this.txtReporteCodigo.Text;
                    _goDbnreporousBE.CODI_ROUS = this.ddlPrivilegiosRol.SelectedValue;
                    _goDbnreporousBE.EXPT_EXLS = _goMantencionListador.VerificaVisibleExcel(ckbValidaExcel.Checked);//this.ckbValidaExcel.Checked;
                    _goDbnreporousController.createRepoRous(_goDbnreporousBE);
                }
            }
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
        finally
        { this.LimpiarTxt(); this.CreacionGrillas(); this.EliminacionSession(); DefaultTxt(); }
    }

    private void RecorrerGrillas(GridViewCommandEventArgs e ,GridView loGrilla, string lsNombreGrilla, string tipoBoton, int index)
    {
        this.EliminacionSession();
        this.CreacionGrillas();
        List<DbnListBotoBE> laListaBotones = new List<DbnListBotoBE>(); 
        if (lsNombreGrilla == "columna")
        { laListaBotones = _gaBotongridColumna;}
        else if (lsNombreGrilla == "boton")
        { laListaBotones = _gaBotongridBoton;}
        else if (lsNombreGrilla == "privilegios")
        { laListaBotones = _gaBotongridPrivilegios;}
        
        foreach (var item in laListaBotones)
        {
            if (item.NOMB_BOTO == e.CommandName)
            {
                _goDbnlistbotoBE = new DbnListBotoBE();
                _goDbnlistbotoBE.CODI_PAR1 = item.CODI_PAR1;
                _goDbnlistbotoBE.CODI_PAR2 = item.CODI_PAR2;
                _goDbnlistbotoBE.CODI_PAR3 = item.CODI_PAR3;
                _goDbnlistbotoBE.CODI_PAR4 = item.CODI_PAR4;
                _goDbnlistbotoBE.CODI_PAR5 = item.CODI_PAR5;
                _goDbnlistbotoBE.CODI_REPO = item.CODI_REPO;
                _goDbnlistbotoBE.PAGE_BOTO = item.PAGE_BOTO;
                _goDbnlistbotoBE.NOMB_BOTO = item.NOMB_BOTO;
                _goDbnlistbotoBE.CODI_BOTO = item.CODI_BOTO;
                _goDbnlistbotoBE.DESC_BOTO = item.DESC_BOTO;
            }
        }
        int[] idx = { -1, -1, -1, -1, -1 };
        for (int i = 0; i < loGrilla.Columns.Count; i++)
        {
            if (loGrilla.Columns[i].GetType() == (new BoundField()).GetType())
            {
                BoundField bfColumna = (BoundField)loGrilla.Columns[i];
                if (_goDbnlistbotoBE.CODI_PAR1 == bfColumna.DataField) idx[0] = i;
                if (_goDbnlistbotoBE.CODI_PAR2 == bfColumna.DataField) idx[1] = i;
                if (_goDbnlistbotoBE.CODI_PAR3 == bfColumna.DataField) idx[2] = i;
                if (_goDbnlistbotoBE.CODI_PAR4 == bfColumna.DataField) idx[3] = i;
                if (_goDbnlistbotoBE.CODI_PAR5 == bfColumna.DataField) idx[4] = i;
            }
        }
        if (idx[0] != -1)
        { _goDbnlistbotoBE.VAL_PAR1 = loGrilla.Rows[index].Cells[idx[0]].Text; }
        if (idx[1] != -1)
        { _goDbnlistbotoBE.VAL_PAR2 = loGrilla.Rows[index].Cells[idx[1]].Text; }
        if (idx[2] != -1)
        { _goDbnlistbotoBE.VAL_PAR3 = loGrilla.Rows[index].Cells[idx[2]].Text; }
        if (idx[3] != -1)
        { _goDbnlistbotoBE.VAL_PAR4 = loGrilla.Rows[index].Cells[idx[3]].Text; }
        if (idx[4] != -1)
        { _goDbnlistbotoBE.VAL_PAR5 = loGrilla.Rows[index].Cells[idx[5]].Text; }
        Session["VAL_PAR1"] = _goDbnlistbotoBE.VAL_PAR1;
        Session["VAL_PAR2"] = _goDbnlistbotoBE.VAL_PAR2;
        Session["VAL_PAR3"] = _goDbnlistbotoBE.VAL_PAR3;
        Session["VAL_PAR4"] = _goDbnlistbotoBE.VAL_PAR4;
        Session["VAL_PAR5"] = _goDbnlistbotoBE.VAL_PAR5;
        Session["tipo"] = tipoBoton;
        Session["grilla"] = lsNombreGrilla;
        Response.Redirect(_goDbnlistbotoBE.PAGE_BOTO,true);

    }
    protected void grillaColumna_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int index = Convert.ToInt32(e.CommandArgument);
        #region btnEditar
        if (e.CommandName == "btnEditar")
        {
            RecorrerGrillas(e, this.grillaColumna, "columna", "editar", index);
        }
        #endregion
        #region btnEliminar
        else if (e.CommandName == "btnEliminar")
        {
            RecorrerGrillas(e, this.grillaColumna, "columna", "eliminar", index);
        }
        #endregion
    }
    protected void grillaBoton_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        this.CreacionGrillas();
        int index = Convert.ToInt32(e.CommandArgument);
        #region btnEditar
        if (e.CommandName == "btnEditar")
        { RecorrerGrillas(e, this.grillaBoton, "boton", "editar", index); }
        #endregion
        #region btnEliminar
        else if (e.CommandName == "btnEliminar")
        { RecorrerGrillas(e, this.grillaBoton, "boton", "eliminar", index); }
        #endregion
    }
    protected void grillaPrivilegios_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        this.CreacionGrillas();
        int index = Convert.ToInt32(e.CommandArgument);
        #region btnEliminar
        if (e.CommandName == "btnEliminar")
        { RecorrerGrillas(e, this.grillaPrivilegios, "privilegios", "eliminar", index); }
        #endregion
    }
    
    private string  VerificaCkbModo()
    {
        string lsModo = string.Empty;
        if (ckbModoC.Checked)
        {
            if (lsModo.Length == 0)
            { lsModo = "("+ckbModoC.Text+ ")"; }
            else
            { lsModo += "(" + ckbModoC.Text + ")"; }
        }
        if (ckbModoCE.Checked)
        {
            if (lsModo.Length == 0)
            { lsModo = "(" + ckbModoCE.Text + ")"; }
            else
            { lsModo += "(" + ckbModoCE.Text + ")"; }
        }
        if (ckbModoCI.Checked)
        {
            if (lsModo.Length == 0)
            { lsModo = "(" + ckbModoCI.Text + ")"; }
            else
            { lsModo += "(" + ckbModoCI.Text + ")"; }
        }
        if (ckbModoM.Checked)
        {
            if (lsModo.Length == 0)
            { lsModo = "(" + ckbModoM.Text + ")"; }
            else
            { lsModo += "(" + ckbModoM.Text + ")"; }
        }
        if (ckbModoT.Checked)
        {
            if (lsModo.Length == 0)
            { lsModo = "(" + ckbModoT.Text + ")"; }
            else
            { lsModo += "(" + ckbModoT.Text + ")"; }
        }
        return lsModo;
    }
    private void EliminacionSession()
    {
        Session.Remove("VAL_PAR1");
        Session.Remove("VAL_PAR2");
        Session.Remove("VAL_PAR3");
        Session.Remove("VAL_PAR4");
        Session.Remove("VAL_PAR5");
        Session.Remove("tipo");
        Session.Remove("grilla");
        Session.Remove("BTN_AGRE_MODO");
    }

    private DataTable EjecutaSQL()
    {
        DataTable loResultado = new DataTable();
        MantencionListador loMantencionListador = new MantencionListador();
        _goDbnlistrepoController = new DbnListRepoController();
        _goListadorController = new ListadorController();

        if(this.txtReporteProcedimiento.Text.Trim().Length > 0)
        { loResultado = _goListadorController.readListador("PROC", this.txtReporteProcedimiento.Text, "L", 1, 1, null, null, null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX); }
        else if (_goSessionWeb.BASE_DATO.ToUpper() == "SQLSERVER")
        {loResultado = _goDbnlistrepoController.EjecutaSQL(txaSQLServer.Text).Copy(); }
        else if (_goSessionWeb.BASE_DATO.ToUpper() == "ORACLE")
        {loResultado = _goDbnlistrepoController.EjecutaSQL(txaOracle.Text).Copy();}
        return loMantencionListador.NombresColumnas(loResultado).Copy();
    }
    protected void btnProcesar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            var loResultado = EjecutaSQL();
            _goDbnlistcoluController.createColumnaAuto(loResultado, this.txtReporteCodigo.Text);
        }
        catch (Exception ex)
        { lblError.Text = ex.Message; }
        finally
        { CreacionGrillas(); }
    }
    protected void btnEjecutar_Click(object sender, ImageClickEventArgs e)
    {
        if (this.ddlRepoTipoRepo.SelectedValue != "Detalle")
        {
            string pScript = "window.open(\"../dbnFw5/dbnFw5Listador.aspx?listado=" + this.txtReporteCodigo.Text + "&MODO="+ this.ddlModo.SelectedValue+"\",\"" + "Pop\",\"width=1024,height=650,scrollbars=yes,toolbar=no,menubar=no\");";// +
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", pScript, true);
        }
    }
}