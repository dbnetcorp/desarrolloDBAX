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
using DBNeT.Base.Controlador;
using DBNeT.Base.Modelo;

public partial class PlantillasXbrl : System.Web.UI.Page
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
    GeneracionExcel cont = new GeneracionExcel();
    MantencionIndicadores man = new MantencionIndicadores();
    GeneradorGrupo geneGru = new GeneradorGrupo();

    string CodiInfo = "", TipoInfo = "";
    static string TipoTaxonomia = "";
    string vModo = "I";
    VariablesSession Ses;
    DataTable dtInforme;
    static DataTable dtConceptos;
    public static string CodiEmex = "", CodiEmpr = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        Grilla_informe.Page.MaintainScrollPositionOnPostBack = true;
        this.lblTitulo.Text = "Creación de Reportes";
        
        CodiEmex = _goSessionWeb.CODI_EMEX;
        CodiEmpr = _goSessionWeb.CODI_EMPR.ToString();
        
        // Se rescata valor de Sesion
        Ses = (VariablesSession)Session["par1"];
        if(Ses!=null)
        {
            vModo = "M";
            CodiInfo = Ses.CodiInfo;
            TipoInfo = Ses.TipoInfo;
            //Ses = new VariablesSession();
        }
        else{vModo="I";}
        lb_error.Visible = false;

        if (!IsPostBack)
        {
            //ViewState.Add("ref",Request.UrlReferrer.AbsoluteUri);
            llenado_de_TiposTaxo();
            
            if (vModo == "M")
            {
                tb_CodiInfo.Enabled = false;

                ddl_TipoTaxonomia.Enabled = false;
                dtInforme = cont.getInforme(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CodiInfo, TipoInfo);
                if (dtInforme.Rows[0]["codi_emex"].ToString() == "0")
                {
                    tb_CodiCort.Enabled = false;
                    bt_Aceptar2.Visible = false;
                    bt_Borrar.Visible = false;
                    tb_CodiInfo.Enabled = false;
                    tb_DescInfo.Enabled = false;
                    agregar.Visible = false;
                    tb_filtroConcepto.Enabled = false;
                    cb_conceptos.Enabled = false;
                    cb_nivel.Enabled = false;
                    tb_orden.Enabled = false;
                    chk_InfoVige.Enabled = false;
                }

                chk_InfoVige.Checked = Convert.ToBoolean(dtInforme.Rows[0]["indi_vige"].ToString().Replace("0","false").Replace("1","true"));
                tb_DescInfo.Text = dtInforme.Rows[0]["desc_info"].ToString();
                tb_CodiInfo.Text = dtInforme.Rows[0]["codi_info"].ToString();
                tb_CodiCort.Text = dtInforme.Rows[0]["codi_cort"].ToString().ToUpper();
                SysParamController _loSysaParam = new SysParamController();
                var loResultado = _loSysaParam.readParametro("S", 0, 0, null, "DBAX_DEFE_TAXO", null, null, null, null, _goSessionWeb.CODI_USUA, _goSessionWeb.CODI_EMPR, _goSessionWeb.CODI_EMEX);
                ddl_TipoTaxonomia.SelectedValue = dtInforme.Rows[0]["tipo_taxo"].ToString();
                llenadoConceptos(); ;
                llenado_de_grilla();
            }
            else
            {
                llenadoConceptos();
            }
        }
        tb_orden.Text = cont.getMaxOrdeConc(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CodiInfo).ToString();
    }
    protected void llenado_de_grilla()
    {
        if (TipoInfo == null)
            TipoInfo = "C";
        MantencionIndicadores conc = new MantencionIndicadores();
        DataSet dt = conc.getConceptosInformes(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CodiInfo, TipoInfo);
        Grilla_informe.DataSource = dt;
        Grilla_informe.DataBind();

        dtInforme = cont.getInforme(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CodiInfo, TipoInfo);

        if (dtInforme.Rows[0]["codi_emex"].ToString() == "0")
        {
            Grilla_informe.Columns[0].Visible = false;
            Grilla_informe.Columns[Grilla_informe.Columns.Count - 1].Visible = false;
        }
        Grilla_informe.Columns[1].Visible = false;
        Grilla_informe.Columns[2].Visible = false;
    }
    protected void cb_informe_SelectedIndexChanged(object sender, EventArgs e)
    {
        llenado_de_grilla();
        llamado_check();
    }
    protected void Grilla_Informe_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        Grilla_informe.EditIndex = -1;
        llenado_de_grilla();
        llamado_check();
    }
    protected void Grilla_Informe_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            MantencionIndicadores man = new MantencionIndicadores();
            int indexRow = e.RowIndex;
            GridViewRow row = Grilla_informe.Rows[indexRow];
            string OrdeConc =  "";
            string PrefConc = ((Label)(row.Cells[1].Controls[1])).Text;
            string CodiConc = ((Label)(row.Cells[2].Controls[1])).Text;
            try
            { OrdeConc = ((TextBox)(row.Cells[3].Controls[1])).Text; }
            catch
            { OrdeConc = ((Label)(row.Cells[3].Controls[1])).Text; }

            man.delInfoConc(_goSessionWeb.CODI_EMEX.ToString(), _goSessionWeb.CODI_EMPR.ToString(), CodiInfo, PrefConc, CodiConc, OrdeConc);
            llenado_de_grilla();
            llamado_check();
            tb_orden.Text = cont.getMaxOrdeConc(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CodiInfo).ToString();
        }
        catch (Exception ex)
        { lb_error.Visible = true; lb_error.Text = ex.Message; }
    }
    protected void Grilla_Informe_RowEditing(object sender, GridViewEditEventArgs e) 
    {
        int indexRow = e.NewEditIndex;
        GridViewRow row = Grilla_informe.Rows[indexRow];
        string VAR2 = ((Label)(row.Cells[1].Controls[1])).Text;
        Grilla_informe.EditIndex = e.NewEditIndex;
        llenado_de_grilla();
        llamado_check();
    }
    protected void Grilla_Informe_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        MantencionIndicadores man = new MantencionIndicadores();
        int indexRow = e.RowIndex;
        GridViewRow row = Grilla_informe.Rows[indexRow];
        string OrdeConc ="", NiveConc = "";
        string PrefConc = ((Label)(row.Cells[1].Controls[1])).Text;
        string CodiConc = ((Label)(row.Cells[2].Controls[1])).Text;

        try
        {OrdeConc = ((TextBox)(row.Cells[3].Controls[1])).Text;}
        catch
        {OrdeConc = ((Label)(row.Cells[3].Controls[1])).Text;}

        try
        {NiveConc = ((TextBox)(row.Cells[6].Controls[1])).Text;}
        catch
        {NiveConc = ((Label)(row.Cells[6].Controls[1])).Text;}
        
        string vNegrita = "";
        if (((CheckBox)(row.Cells[7].Controls[1])).Checked)
        { vNegrita = "1"; }
        else
        { vNegrita = "0"; }

        man.ModificarConceptos(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CodiInfo, PrefConc, CodiConc, OrdeConc, NiveConc, vNegrita);

        Grilla_informe.EditIndex = -1;  
        llenado_de_grilla();
        llamado_check();
    }
    protected void agregar_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            if (vModo == "I")
            {
                bt_Aceptar2_Click(null, null);
            }
            Ses = (VariablesSession)Session["par1"];
            MantencionIndicadores man = new MantencionIndicadores();
            DataTable dtPrefConc = man.getPrefConcPorCodiConc(_goSessionWeb.CODI_EMEX.ToString(), _goSessionWeb.CODI_EMPR.ToString(), cb_conceptos.SelectedValue);
            man.insInfoConc(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), Ses.CodiInfo, dtPrefConc.Rows[0]["pref_conc"].ToString(), cb_conceptos.SelectedValue.ToString(), tb_orden.Text, cb_nivel.SelectedValue.ToString());
            llenado_de_grilla();
            tb_orden.Text = cont.getMaxOrdeConc(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CodiInfo).ToString();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true; 
            lb_error.Text = ex.Message;
        }
    }
    protected void llamado_check()
    {
        try
        {
            CheckBox chkSel;
            for (int i = 0; i < Grilla_informe.Rows.Count; i++)
            {
                chkSel = (CheckBox)Grilla_informe.Rows[i].Cells[7].FindControl("negrita");
                string PrefConc = ((Label)Grilla_informe.Rows[i].Cells[1].Controls[1]).Text;
                string CodiConc = ((Label)Grilla_informe.Rows[i].Cells[2].Controls[1]).Text;
                string OrdeConc = "";
                try
                {OrdeConc = ((Label)Grilla_informe.Rows[i].Cells[3].Controls[1]).Text;}
                catch
                {OrdeConc = ((TextBox)Grilla_informe.Rows[i].Cells[3].Controls[1]).Text;}

                if (chekear_cheked(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CodiInfo, PrefConc, CodiConc, OrdeConc))
                {chkSel.Checked = true;}
                else
                {}
            }
        }
        catch (Exception ex)
        { lb_error.Visible = true; lb_error.Text = ex.Message; }
    }
    protected Boolean chekear_cheked(string CodiEmex, string CodiEmpr, string CodiInfo, string PrefConc, string CodiConc, string OrdeConc)
    {
        try
        {
            MantencionIndicadores man = new MantencionIndicadores();
            DataSet dt = man.getConceptosInformes(CodiEmex, CodiEmpr, CodiInfo, TipoInfo);
            for (int j = 0; j < dt.Tables[0].Rows.Count; j++)
            {
                DataRow dr = dt.Tables[0].Rows[j];
                string vCodiConc = dr["codi_conc"].ToString();
                string vPrefConc = dr["codi_conc"].ToString();
                if (vPrefConc == PrefConc && vCodiConc == CodiConc)
                {
                    string conc = dr["negr_conc"].ToString();
                    if (conc == "1")
                    {return true;}
                }
            }
            return false;
        }
        catch (Exception ex)
        { lb_error.Visible = true; lb_error.Text = ex.Message; return false;}
    }
    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList(string prefixText, int count, string contextKey)
    {
        MantencionIndicadores Indicador = new MantencionIndicadores();
        //string valortaxo = ddl_TipoTaxonomia.SelectedValue;
        //DataTable dt = Indicador.getConceptos("1", "1", valortaxo, prefixText,"RepoXBRL","","").Tables[0];
        dtConceptos = Indicador.getConceptosPorTaxonomia(CodiEmex, CodiEmpr, "", prefixText, "", "", "", "", TipoTaxonomia).Tables[0];
        string[] resultados = new string[dtConceptos.Rows.Count];
        for (int i = 0; i < dtConceptos.Rows.Count; i++)
        {
            resultados[i] = dtConceptos.Rows[i][0].ToString();
        }  
        return resultados;
    }
    protected void tb_filtroConcepto_TextChanged(object sender, EventArgs e)
    {
        //DataSet ds = man.getConceptos(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(),tb_filtroConcepto.Text,"","","299");

        //MantencionIndicadores Indicador = new MantencionIndicadores();
        llenadoConceptos();
        /*DataTable ds = Indicador.getConceptos("1", "1", valortaxo, tb_filtroConcepto.Text).Tables[0];
        cb_conceptos.DataSource = ds;
        cb_conceptos.DataTextField = ds.Columns[0].ToString();
        cb_conceptos.DataValueField = ds.Columns[2].ToString();
        cb_conceptos.DataBind();*/
    }
    protected void RowCreated(object sender, GridViewRowEventArgs e)
    {
        // only apply changes if its DataRow
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // when mouse is over the row, save original color to new attribute, and change it to highlight yellow color
            e.Row.Attributes.Add("onmouseover",
          "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#CCCCCC'");

            // when mouse leaves the row, change the bg color to its original value   
            e.Row.Attributes.Add("onmouseout",
            "this.style.backgroundColor=this.originalstyle;");
        }
    }
    protected void OcultarControles()
    {
        Label15.Visible = false;
        tb_filtroConcepto.Visible = false;
        Label19.Visible = false;
        //ddl_PrefConc.Visible = false;
        Label16.Visible = false;
        cb_conceptos.Visible = false;
        Label17.Visible = false;
        tb_orden.Visible = false;
        Label18.Visible = false;
        cb_nivel.Visible = false;
        autocompleteDropDownPanel.Visible = false;
        agregar.Visible = false;
        Grilla_informe.Visible = false;
    }
    protected void VerControles()
    {
        Label15.Visible = true;
        tb_filtroConcepto.Visible = true;
        Label19.Visible = true;
        //ddl_PrefConc.Visible = true;
        Label16.Visible = true;
        cb_conceptos.Visible = true;
        Label17.Visible = true;
        tb_orden.Visible = true;
        Label18.Visible = true;
        cb_nivel.Visible = true;
        autocompleteDropDownPanel.Visible = true;
        agregar.Visible = true;
        Grilla_informe.Visible = true;
    }
    protected void Boton_CancelarInformeN(object sender, ImageClickEventArgs e)
    {VerControles();}
    protected void tb_DescInfo_TextChanged(object sender, EventArgs e)
    {
        string ls1 = tb_DescInfo.Text.Substring(0, 1).ToUpper();
        string ls2 = tb_DescInfo.Text.Substring(1);
        string lsTexto = ls1 + ls2;
        tb_DescInfo.Text = lsTexto;
        if (CodiInfo == "")
        {
            CodiInfo = tb_DescInfo.Text.Replace(" ", "");
        }
    }
    protected void delInfoDefi(object sender, ImageClickEventArgs e)
    {
        man.delInfoDefi(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CodiInfo);
        bt_Volver_Click(null, null);
    }
    protected void ddl_TipoTaxonomia_SelectedIndexChanged(object sender, EventArgs e)
    {
        TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue;
        tb_filtroConcepto.Text = "";
        llenadoConceptos();
        if (vModo == "M")
        { llenado_de_grilla(); }
    }
    protected void bt_Aceptar2_Click(object sender, ImageClickEventArgs e)
    {
        TipoInfo = "C";
        if (vModo == "I")
        {
            CodiInfo = man.getCodiInfo(tb_DescInfo.Text);
            if (man.getInfoDefi(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR, this.tb_DescInfo.Text).Rows.Count == 0)
            {
                man.insInfoDefi(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), tb_DescInfo.Text, ddl_TipoTaxonomia.SelectedValue, chk_InfoVige.Checked.ToString().ToUpper().Replace("TRUE", "1").Replace("FALSE", "0"), tb_CodiCort.Text); 
            }
            if (Ses == null)
                Ses = new VariablesSession();
            Ses.CodiInfo = CodiInfo;
            Ses.TipoTaxo = ddl_TipoTaxonomia.SelectedValue;
            Session["par1"] = Ses;
        }
        else
        {
            man.updInfoDefi(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CodiInfo, tb_DescInfo.Text, chk_InfoVige.Checked.ToString().ToUpper().Replace("TRUE", "1").Replace("FALSE", "0"), tb_CodiCort.Text);
        }
        vModo = "M";

        dtInforme = cont.getInforme(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), CodiInfo, TipoInfo);

        if (dtInforme.Rows[0]["codi_emex"].ToString() != "0")
        {
            bt_Borrar.Visible = true;
        }

        //bt_Volver_Click(null, null);
    }

    protected void llenadoConceptos()
    {
        DataTable dtConceptos2 = new DataTable();
        DataRow[] FilaConcepto;
        try
        {
            FilaConcepto = dtConceptos.Select("desc_conc = '" + tb_filtroConcepto.Text + "'");
            dtConceptos = man.getConceptosPorTaxonomia(CodiEmex, CodiEmpr, "", "", FilaConcepto[0]["codi_info"].ToString(), FilaConcepto[0]["orde_conc"].ToString(), FilaConcepto[0]["pref_conc"].ToString(), FilaConcepto[0]["codi_conc"].ToString(), "").Tables[0];
        }
        catch
        {
            dtConceptos = man.getConceptosPorTaxonomia(CodiEmex, CodiEmpr, "", tb_filtroConcepto.Text, "", "", "", "", ddl_TipoTaxonomia.SelectedValue.ToString()).Tables[0];
        }

        //DataTable dt = man.getConceptos(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_TipoTaxonomia.SelectedValue, tb_filtroConcepto.Text,"RepoXBRL","","").Tables[0];
        //DataTable dt = man.getConceptosPorTaxonomia(CodiEmex, CodiEmpr, "", tb_filtroConcepto.Text, "", "", "", "", ddl_TipoTaxonomia.SelectedValue).Tables[0];
        cb_conceptos.DataSource = dtConceptos;
        cb_conceptos.DataTextField = dtConceptos.Columns["desc_conc"].ToString();
        cb_conceptos.DataValueField = dtConceptos.Columns["codi_conc"].ToString();
        cb_conceptos.DataBind();

        for(int i=0; i<=cb_conceptos.Items.Count-1; i++)
        {
            cb_conceptos.Items[i].Attributes.Add("Title", dtConceptos.Rows[i]["codi_conc"].ToString());
        }
    }
    protected void llenado_de_TiposTaxo()
    {
        DataTable dt = geneGru.getTiposTaxonomia().Tables[0];
        ddl_TipoTaxonomia.DataSource = dt;
        ddl_TipoTaxonomia.DataTextField = dt.Columns["desc_tipo"].ToString();
        ddl_TipoTaxonomia.DataValueField = dt.Columns["tipo_taxo"].ToString();
        ddl_TipoTaxonomia.DataBind();

        ddl_TipoTaxonomia.SelectedIndex = 1;
        TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue;
    }
    protected void bt_Volver_Click(object sender, ImageClickEventArgs e)
    {
        Session.Remove("par1");
        Response.Redirect("listadoReportes.aspx",true);
    }
    protected void rb_ConcIndi_SelectedIndexChanged(object sender, EventArgs e)
    {
        //Si es indicador, ocultaré los filtro
        if (rb_ConcIndi.SelectedValue.ToString() == "I")
        {
            tb_filtroConcepto.Visible = false;
            autocompleteDropDownPanel.Visible = false;
            Label19.Visible = false;
            llenado_de_indicadores();
        }
        //Si es concepto me aseguro de mostrar los filtros
        else
        {
            tb_filtroConcepto.Visible = true;
            autocompleteDropDownPanel.Visible = true;
            Label19.Visible = true;
            llenadoConceptos();

        }
    }
    protected void llenado_de_indicadores()
    {
        DataTable dtConceptos = new DataTable();
        dtConceptos = man.getConceptos(CodiEmex, CodiEmpr, "", "P", "").Tables[0];

        cb_conceptos.DataSource = dtConceptos;
        cb_conceptos.DataTextField = dtConceptos.Columns["desc_conc"].ToString();
        cb_conceptos.DataValueField = dtConceptos.Columns["codi_conc"].ToString();
        cb_conceptos.DataBind();

        for (int i = 0; i <= cb_conceptos.Items.Count - 1; i++)
        {
            cb_conceptos.Items[i].Attributes.Add("Title", dtConceptos.Rows[i]["codi_conc"].ToString());
        }
    }
    protected void Procesar_Click(object sender, ImageClickEventArgs e)
    {
        man.insInfoDefi(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), _goSessionWeb.CODI_EMEX + "_" + _goSessionWeb.CODI_EMPR.ToString() + tb_CodiInfo.Text, "Copia " + tb_DescInfo.Text, ddl_TipoTaxonomia.SelectedValue, "1", "COPI_" + tb_CodiCort.Text);

        dtInforme = cont.getInforme(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), tb_CodiInfo.Text, TipoInfo);
        man.insCopiaInfoConc(dtInforme.Rows[0]["codi_emex"].ToString(), dtInforme.Rows[0]["codi_empr"].ToString(), tb_CodiInfo.Text, _goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), _goSessionWeb.CODI_EMEX + "_" + _goSessionWeb.CODI_EMPR.ToString() + tb_CodiInfo.Text);
        bt_Volver_Click(null, null);
    }
}