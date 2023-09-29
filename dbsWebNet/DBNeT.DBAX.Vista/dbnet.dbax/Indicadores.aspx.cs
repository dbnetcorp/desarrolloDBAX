using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Text;
using DBNeT.Base.Modelo;
using DBNeT.Base.Controlador;
using DBNeT.DBAX.Controlador;


public partial class DragAndDrop : System.Web.UI.Page
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
    //RescateDeConceptos Concepto = new RescateDeConceptos();
    MantencionIndicadores Indicador = new MantencionIndicadores();
    DbaxTaxoVersController _goDbaxTaxoVersController;
    GeneradorGrupo geneGru = new GeneradorGrupo();
    static string vVersTaxo = "", vTipoTaxo = "";
    static DataTable dtConceptos;
    static string CodiEmex = "", CodiEmpr = "";
    static bool vBusqExac = false;
    string vModo = "I";
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        lb_error.Visible = false;
        if (Session["BTN_AGRE_MODO"] != null)
        { vModo = Session["BTN_AGRE_MODO"].ToString(); }
        else
        { vModo = Session["P_MODO_REPO"].ToString(); }

        if (vModo != "M")
        {
            Session["codi_indi"] = "";
            bt_Borrar.Visible = false;
        }

        if (!IsPostBack)
        {
            DataSet ds = Indicador.ObtenerTipoIndicadores();
            ddl_TipoIndi.DataSource = ds;
            ddl_TipoIndi.DataTextField = ds.Tables[0].Columns[1].ToString();
            ddl_TipoIndi.DataValueField = ds.Tables[0].Columns[0].ToString();
            ddl_TipoIndi.DataBind();

            DataTable dt = new DataTable();
            //llenado_de_prefijos();
            llenado_de_TipoTaxonomia();


            SysParamController _loSysaParam = new SysParamController();
            var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_DEFE_TAXO1", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
            CodiEmex = _goSessionWeb.CODI_EMEX;
            CodiEmpr = _goSessionWeb.CODI_EMPR.ToString();

            //if(loResultado)
            ddl_TipoTaxonomia.SelectedValue = loResultado.PARAM_VALUE;
            //ddl_VersTaxo.Enabled = false;
            //ddl_PrefConc.Enabled = false;
            if (vModo == "M")
            {
                ddl_TipoTaxonomia.Enabled = false;
                DataTable dt_EncabezadoIndicador = Indicador.getEncabezadoIndicador(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), Session["codi_indi"].ToString());
                //lb_error.Visible = true;
                //lb_error.Text = _goSessionWeb.CODI_EMEX + "," + _goSessionWeb.CODI_EMPR.ToString();
                if (dt_EncabezadoIndicador.Rows[0]["codi_emex"].ToString() == "0")
                {
                    bt_Aceptar2.Enabled = false;
                    bt_Aceptar2.Visible = false;
                    bt_Borrar.Enabled = false;
                    bt_Borrar.Visible = false;
                    lb_error.Visible = true;
                    lb_error.Text = "Este indicador está definido a nivel de sistema. No es posible editarlo";
                }
                tb_NombForm.Text = Session["codi_indi"].ToString();
                ddl_TipoIndi.SelectedValue = dt_EncabezadoIndicador.Rows[0]["tipo_conc"].ToString();
                ddl_TipoTaxonomia.SelectedValue = dt_EncabezadoIndicador.Rows[0]["tipo_taxo"].ToString();
                vTipoTaxo = ddl_TipoTaxonomia.SelectedValue;
                tb_Descripcion.Text = dt_EncabezadoIndicador.Rows[0]["desc_indi"].ToString();
                tb_FormDefi.Text = dt_EncabezadoIndicador.Rows[0]["form_indi"].ToString();
                //tb_RefeMini.Text = dt_EncabezadoIndicador.Rows[0]["refe_mini"].ToString();
                //tb_RefeMaxi.Text = dt_EncabezadoIndicador.Rows[0]["refe_maxi"].ToString();
                if (dt_EncabezadoIndicador.Rows[0]["visu_indi"].ToString() == "S")
                    cb_VisoRepo.Checked = true;
                else
                    cb_VisoRepo.Checked = false;
                if (dt_EncabezadoIndicador.Rows[0]["apli_hold"].ToString() == "S")
                    cb_ApliHold.Checked = true;
                else
                    cb_ApliHold.Checked = false;
                ddl_TipoTaxonomia_SelectedIndexChanged(null, null);
                tb_NombForm.ReadOnly = true;
                Analiza();
            }
            crearListaConceptos(ddl_VersTaxo.SelectedValue, tb_filtroConcepto.Text);
        }
    }
    public void crearListaConceptos(string vPrefijo, string vConcepto)
    {
        try
        {
            DataTable dtConceptos2 = new DataTable();
            DataRow[] FilaConcepto;
            try
            {
                FilaConcepto = dtConceptos.Select("desc_conc = '" + tb_filtroConcepto.Text + "'");
                dtConceptos = Indicador.getConceptosPorTaxonomia(CodiEmex, CodiEmpr, ddl_VersTaxo.SelectedValue, "", FilaConcepto[0]["codi_info"].ToString(), FilaConcepto[0]["orde_conc"].ToString(), FilaConcepto[0]["pref_conc"].ToString(), FilaConcepto[0]["codi_conc"].ToString(), ddl_TipoTaxonomia.Text).Tables[0];
            }
            catch
            {
                dtConceptos = Indicador.getConceptosPorTaxonomia(CodiEmex, CodiEmpr, ddl_VersTaxo.SelectedValue, tb_filtroConcepto.Text, "", "", "", "", ddl_TipoTaxonomia.Text).Tables[0];
            }
            for (int i = 0; i < dtConceptos.Rows.Count; i++)
            {
                DataRow dr = dtConceptos.Rows[i];
                string var = dr["desc_conc"].ToString();
                string varCO = dr["codi_info"].ToString() + dr["orde_conc"].ToString() + "__" + dr["pref_conc"].ToString() + "|" + dr["codi_conc"].ToString();

                Label r = new Label();
                
                r.ID = "tb_" + varCO;
                r.Text = var;
                r.CssClass = "dbnLabel";
                HtmlGenericControl pre = new HtmlGenericControl("pre");
                pre.Controls.Add(r);
                HtmlGenericControl li = new HtmlGenericControl("li");
                li.Attributes.Add("id", varCO);
                li.Attributes.Add("class", "elemento ui-draggable");
                
                listaConceptos.Controls.Add(li);
                li.Controls.Add(pre);
            }

            dtConceptos = Indicador.getConceptos(CodiEmex, CodiEmpr, vConcepto, "P", Session["codi_indi"].ToString()).Tables[0];
            for (int i = 0; i < dtConceptos.Rows.Count; i++)
            {
                DataRow dr = dtConceptos.Rows[i];
                string var = dr["desc_conc"].ToString();
                string varCO = dr["pref_conc"].ToString() + "|" + dr["codi_conc"].ToString();

                Label r = new Label();
                r.ID = "tb_" + varCO;
                r.Text = var;
                r.CssClass = "dbnLabel";

                HtmlGenericControl li = new HtmlGenericControl("li");
                li.Attributes.Add("id", varCO);
                li.Attributes.Add("class", "elemento ui-draggable");
                listaIndicadores.Controls.Add(li);
                li.Controls.Add(r);
            }
        }
        catch
        {
        }
    }
    public void CrearVariables(string Concep)
    {
        try
        {
            MantencionCntx cntx = new MantencionCntx();
            HtmlGenericControl h1 = new HtmlGenericControl("h1");
            h1.Attributes.Add("class", "ui-widget-header");
            h1.InnerText = "Variable " + Concep;
            HtmlGenericControl divSelect = new HtmlGenericControl("div");
            divSelect.Attributes.Add("class", "ui-widget-content");
            string vDetaCntx;
           
            HtmlGenericControl div = new HtmlGenericControl("div");
            div.Attributes.Add("class", "ui-widget-content");
            HtmlGenericControl ol = new HtmlGenericControl("ol");
            HtmlGenericControl li = new HtmlGenericControl("li");
            li.ID = Concep;
            //li.TagName = Concep;
            li.Attributes.Add("class", "placeholder");

            HtmlGenericControl select = new HtmlGenericControl("select");
            select.ID = "select_" + Concep;
            if (_goSessionWeb.CODI_ROUS != "ROL_DBAX_ADMI")
            {
                select.Attributes.Add("disabled", "true");
            }
            select.Attributes.Add("onchange", "actualizaPeriodo('bodyCP_" + Concep + "','" + Concep + "');");
            DataTable dtContexto = cntx.getContextos(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString()).Tables[0];

            if (vModo == "M")
            {
                //li.Attributes.Clear();
                try
                {
                    li.InnerText = Indicador.getDetalleIndicador(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), Session["codi_indi"].ToString(), Concep).Rows[0]["desc_conc"].ToString();
                    vDetaCntx = Indicador.getDetalleIndicador(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), Session["codi_indi"].ToString(), Concep).Rows[0]["codi_emex"].ToString() + "|" + Indicador.getDetalleIndicador(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), Session["codi_indi"].ToString(), Concep).Rows[0]["codi_empr"].ToString() + "|" + Indicador.getDetalleIndicador(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), Session["codi_indi"].ToString(), Concep).Rows[0]["codi_cntx"].ToString();
                    tb_Resultados.Text = tb_Resultados.Text + "bodyCP_" + Concep + "|" + Indicador.getDetalleIndicador(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), Session["codi_indi"].ToString(), Concep).Rows[0]["pref_conc"].ToString() + "|" + Indicador.getDetalleIndicador(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), Session["codi_indi"].ToString(), Concep).Rows[0]["codi_conc"].ToString() + "|" + vDetaCntx + "/";

                    foreach (DataRow drFila in dtContexto.Rows)
                    {
                        HtmlGenericControl option = new HtmlGenericControl("option");
                        option.InnerText = drFila["desc_cntx"].ToString();
                        option.Attributes.Add("value",drFila["codi_emex"].ToString() + "|" + drFila["codi_empr"].ToString() + "|" + drFila["codi_cntx"].ToString());

                        if (option.Attributes["value"].ToString() == vDetaCntx)
                        {
                            option.Attributes.Add("selected", "selected");
                        }
                        select.Controls.Add(option);
                    }
                }
                catch
                {
                    foreach (DataRow drFila in dtContexto.Rows)
                    {
                        HtmlGenericControl option = new HtmlGenericControl("option");
                        //option.InnerText = drFila[0].ToString();
                        option.InnerText = drFila["desc_cntx"].ToString();
                        option.Attributes.Add("value", drFila["codi_emex"].ToString() + "|" + drFila["codi_empr"].ToString() + "|" + drFila["codi_cntx"].ToString());
                        select.Controls.Add(option);
                    }
                }
            }
            else
            {
                foreach (DataRow drFila in dtContexto.Rows)
                {
                    HtmlGenericControl option = new HtmlGenericControl("option");
                    option.InnerText = drFila["desc_cntx"].ToString();
                    option.Attributes.Add("value", drFila["codi_emex"].ToString() + "|" + drFila["codi_empr"].ToString() + "|" + drFila["codi_cntx"].ToString());
                    if (option.Attributes["value"].ToString() == "0|0|CierreTrimestreActual")
                    {
                        option.Attributes.Add("selected", "selected");
                    }
                    select.Controls.Add(option);
                }
            }

            ol.Controls.Add(li);
            div.Controls.Add(ol);
            cart.Controls.Add(h1);
            divSelect.Controls.Add(select);
            cart.Controls.Add(divSelect);
            cart.Controls.Add(div);
        }
        catch(Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    public void LimpiarVariables()
    {
        try
        {
            cart.Controls.Clear();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    public void Analiza()
    {
        try
        {
            LimpiarVariables();
            tb_Resultados.Text = "";
            //Indicador.setCadenaVariables(tb_FormDefi.Text);
            Indicador.setCadenaFormula(tb_FormDefi.Text);
            string[] Letras = new string[Indicador.getNumeroVariablesFormula()];
            Indicador.getVariablesFormula().CopyTo(Letras, 0);

            TraduceFormula();

            for (int i = 0; i < Indicador.getNumeroVariablesFormula(); i++)
            {
                CrearVariables(Letras[i]);
            }
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    //A partir de la fórmula definida se crean controles para mostrar la fórmula con las variables reemplazadas por los conceptos.
    public void TraduceFormula()
    {
        //Para cada carácter de la fórmula...
        for (int i = 0; i < tb_FormDefi.Text.Length; i++)
        {
            HtmlGenericControl span = new HtmlGenericControl("span");

            //Si el caracter actual representa una variable
            if (System.Text.RegularExpressions.Regex.IsMatch(tb_FormDefi.Text[i].ToString(), "^[a-zA-Z]+$"))
            {
                //Creo el control y se asigno sus atributos
                span.Attributes.Add("id", "ConceptoVariable" + tb_FormDefi.Text[i].ToString());
                span.Attributes.Add("class", "TextosNormales");
                //En caso que esté editando las variables ya las tengo asignadas, solo las voy a buscar
                if (vModo == "M")
                {
                    try
                    {
                        span.InnerText = "[" + Indicador.getDetalleIndicador(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), Session["codi_indi"].ToString(), tb_FormDefi.Text[i].ToString()).Rows[0]["desc_conc"].ToString() + "]";
                    }
                    catch
                    {
                        span.InnerText = tb_FormDefi.Text[i].ToString();
                    }
                }
                else
                {
                    //Si es inserción inicialmente el control llevará la letra de la variable
                    span.InnerText = tb_FormDefi.Text[i].ToString();
                }
            }
            else
            {
                //Si es un signo (no variable) lo creo con otros estilos para diferenciarlo.
                span.Attributes.Add("id", "SignoFormula" + i);
                span.Attributes.Add("style", "font-size: 20px; font-weight: bolder; color: #AA0000;");
                span.InnerText = tb_FormDefi.Text[i].ToString();
            }
            //Agrego el control a la pagina
            divVariables.Controls.Add(span);
        }
    }
    protected void AnalizaFormula(object sender, ImageClickEventArgs e)
    {
        Analiza();
        crearListaConceptos(ddl_TipoTaxonomia.SelectedValue, tb_filtroConcepto.Text);
    }
    protected void bt_Aceptar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            Indicador.setEncabezadoIndicador(vModo, _goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), tb_NombForm.Text, ddl_TipoIndi.SelectedValue, tb_Descripcion.Text, tb_FormDefi.Text, ddl_TipoTaxonomia.SelectedValue, "", "",cb_VisoRepo.Checked,cb_ApliHold.Checked);
            Indicador.setCadenaVariables(tb_Resultados.Text);
            Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_LIST_INDI&MODO=" + Session["P_MODO_REPO"].ToString(), true);
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void bt_Borrar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            //Indicador.setEncabezadoIndicador(vModo, _goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), tb_NombForm.Text, ddl_TipoIndi.SelectedValue, tb_Descripcion.Text, tb_FormDefi.Text, ddl_TipoTaxonomia.SelectedValue);
            //lb_error.Visible = true;
            //lb_error.Text = string.Empty;
            //lb_error.Text = _goSessionWeb.CODI_EMEX + "," + _goSessionWeb.CODI_EMPR.ToString() + "," + tb_NombForm.Text;
            Indicador.delIndicador(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), tb_NombForm.Text);
            Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_LIST_INDI&MODO=" + Session["P_MODO_REPO"].ToString());
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void tb_FormDefi_TextChanged(object sender, EventArgs e)
    {
        Analiza();
        crearListaConceptos(ddl_TipoTaxonomia.SelectedValue, tb_filtroConcepto.Text);
       
    }
    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList(string prefixText, int count, string contextKey)
    {
        MantencionIndicadores Indicador = new MantencionIndicadores();
        //string gValortaxo = "";
        //gValortaxo = (string)HttpContext.Current.Session["vVersTaxo"];
        //DataTable dt = Indicador.getConceptos("1", "1", vVersTaxo, prefixText, "indicadores", "", "").Tables[0];
        dtConceptos = Indicador.getConceptosPorTaxonomia(CodiEmex, CodiEmpr, vVersTaxo, prefixText, "", "", "", "", vTipoTaxo).Tables[0];
        //DataTable dt = Indicador.getConceptos("1","1",prefixText, "T", "").Tables[0];
        string[] resultados = new string[dtConceptos.Rows.Count];
        for (int i = 0; i < dtConceptos.Rows.Count; i++)
        {
            resultados[i] = dtConceptos.Rows[i][0].ToString();
        }
       return resultados;
    }
    protected void tb_filtroConcepto_TextChanged(object sender, EventArgs e)
    {
        crearListaConceptos(ddl_TipoTaxonomia.SelectedValue, tb_filtroConcepto.Text);
    }
    /*protected void ddl_PrefConc_SelectedIndexChanged(object sender, EventArgs e)
    {
        crearListaConceptos(ddl_TipoTaxonomia.SelectedValue, tb_filtroConcepto.Text);
        vVersTaxo = ddl_TipoTaxonomia.SelectedValue;
        Session["vVersTaxo"] = vVersTaxo;
    }*/
    protected void ddl_TipoTaxonomia_SelectedIndexChanged(object sender, EventArgs e)
    {
        vTipoTaxo = ddl_TipoTaxonomia.SelectedValue;
        llenado_version_taxonomia();
    }
    /*protected void llenado_de_prefijos()
    {
        DataTable dt = Indicador.getPrefConc(ddl_VersTaxo.SelectedValue);
        ddl_PrefConc.DataSource = dt;
        ddl_PrefConc.DataTextField = dt.Columns["pref_conc"].ToString();
        ddl_PrefConc.DataValueField = dt.Columns["pref_conc"].ToString();
        ddl_PrefConc.DataBind();
    }*/
    protected void llenado_de_TipoTaxonomia()
    {
        DataTable dt = geneGru.getTiposTaxonomia().Tables[0];
        ddl_TipoTaxonomia.DataSource = dt;
        ddl_TipoTaxonomia.DataTextField = dt.Columns["desc_tipo"].ToString();
        ddl_TipoTaxonomia.DataValueField = dt.Columns["tipo_taxo"].ToString();
        ddl_TipoTaxonomia.DataBind();
        //ddl_TipoTaxonomia_SelectedIndexChanged(null,null);
    }
    protected void bt_Volver_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/dbnFw5/dbnFw5Listador.aspx?listado=L_LIST_INDI&MODO=M", true);
    }
    protected void ddl_VersTaxo_SelectedIndexChanged(object sender, EventArgs e)
    {
        vVersTaxo = ddl_VersTaxo.SelectedValue;
        crearListaConceptos(ddl_VersTaxo.SelectedValue, tb_filtroConcepto.Text);
        UpdatePanel1.Update();
    }
    protected void llenado_version_taxonomia()
    {
        //this.ddl_VersTaxo.Enabled = true;
        _goDbaxTaxoVersController = new DbaxTaxoVersController();
        var loVersTaxo = _goDbaxTaxoVersController.readDbaxTaxoVersDt("LV", 0, 0, null, this.ddl_TipoTaxonomia.SelectedValue);
        if (loVersTaxo.Rows.Count > 1)
        {
            //this.ddl_PrefConc.Items.Clear();
            //this.ddl_VersTaxo.Enabled = true;
            Helper.ddlCarga(ddl_VersTaxo, loVersTaxo);
        }
        else
        {
            //this.ddl_VersTaxo.Enabled = false;
        }
        if (vModo=="CI")
            crearListaConceptos(ddl_VersTaxo.SelectedValue, tb_filtroConcepto.Text);
        UpdatePanel4.Update();
    }
   
}