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

public partial class Website_ManEmpresaPersona : System.Web.UI.Page
{
    GeneradorGrupo geneGru = new GeneradorGrupo();
    string GrupoE;
    public static string GrupoEmpr = "", SegmentoEmpr = "", TipoTaxonomia = "";
    protected void Page_Load(object sender, EventArgs e)
    {
       lb_error.Visible = false;

       if (!IsPostBack)
       {
           //llenado de combobox grupo
           DataTable dt = new DataTable();

           dt = geneGru.getGrupos().Tables[0];
           ddl_Grupo.DataSource = dt;
           ddl_Grupo.DataTextField = dt.Columns["desc_grup"].ToString();
           ddl_Grupo.DataValueField = dt.Columns["codi_grup"].ToString();
           ddl_Grupo.DataBind();

           dt = geneGru.getSegmentos().Tables[0];
           ddl_Segmento.DataSource = dt;
           ddl_Segmento.DataTextField = dt.Columns["desc_segm"].ToString();
           ddl_Segmento.DataValueField = dt.Columns["codi_segm"].ToString();
           ddl_Segmento.DataBind();

           dt = geneGru.getTiposTaxonomia().Tables[0];
           ddl_TipoTaxonomia.DataSource = dt;
           ddl_TipoTaxonomia.DataTextField = dt.Columns["desc_tipo"].ToString();
           ddl_TipoTaxonomia.DataValueField = dt.Columns["tipo_taxo"].ToString();
           ddl_TipoTaxonomia.DataBind();

           llenado_de_empresa();
       }
    }
    protected void llenado_de_empresa() 
    {
        try
        {
            GeneracionExcel cont = new GeneracionExcel();

            DataSet ds = cont.GetEmpresas("1", "1", "",Filtro_Empresa.Text, ddl_Grupo.SelectedValue.ToString(), ddl_Segmento.SelectedValue.ToString(),TipoTaxonomia, "P");
            Grilla_Empr_desc.DataSource = ds;
            Grilla_Empr_desc.DataBind();
            Grilla_Empr_desc.Columns[0].Visible = false;
            Grilla_Empr_desc.Columns[3].Visible = false;
            Grilla_Empr_desc.Columns[5].Visible = false;
            Grilla_Empr_desc.Columns[7].Visible = false;
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void Filtro_Empresa_TextChanged(object sender, EventArgs e)
    {
        llenado_de_empresa();
    }
    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string[] GetCompletionList(string prefixText, int count, string contextKey)
    {
        GeneracionExcel GenExcel = new GeneracionExcel();
        DataTable dt = GenExcel.GetEmpresas("1", "1","",prefixText, GrupoEmpr, SegmentoEmpr,"", "P").Tables[0];
        string[] resultados = new string[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            resultados[i] = dt.Rows[i][1].ToString();
        }
        return resultados;
    }
    protected void Grilla_Empr_desc_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        Grilla_Empr_desc.EditIndex = -1;
        llenado_de_empresa();
    }
    protected void Grilla_Empr_desc_RowEditing(object sender, GridViewEditEventArgs e)
    {
        int indexRow = e.NewEditIndex;
        Label lblGrupo = (Label)Grilla_Empr_desc.Rows[indexRow].FindControl("lbl_DescGrup");
        GrupoE = lblGrupo.Text;

        GridViewRow row = Grilla_Empr_desc.Rows[indexRow];
        Grilla_Empr_desc.EditIndex = e.NewEditIndex;
        llenado_de_empresa();
    }
    protected void Grilla_Empr_desc_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string codi_empr = "1";
            string codi_emex = "1";
            GeneracionExcel cont = new GeneracionExcel();
            int indexRow = e.RowIndex;
            GridViewRow row = Grilla_Empr_desc.Rows[indexRow];
            string rut_pers = ((Label)(row.Cells[0].Controls[1])).Text;
            string des_pers = ((TextBox)(row.Cells[2].Controls[1])).Text;
            string gru_pers = ((DropDownList)(row.Cells[4].Controls[1])).Text;
            string segm_pers = ((DropDownList)(row.Cells[6].Controls[1])).Text;
            string tipo_taxo = ((DropDownList)(row.Cells[8].Controls[1])).Text;
            cont.UpdDescEmpr(codi_emex, codi_empr, rut_pers, des_pers, gru_pers, segm_pers, tipo_taxo);
            Grilla_Empr_desc.EditIndex = -1;
            llenado_de_empresa();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void Grilla_Empr_desc_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Grilla_Empr_desc.PageIndex = e.NewPageIndex;
        Grilla_Empr_desc.DataBind();
        llenado_de_empresa();
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
    protected void ddl_Grupo_SelectedIndexChanged(object sender, EventArgs e)
    {
        GrupoEmpr = ddl_Grupo.SelectedValue.ToString();
        llenado_de_empresa();
    }
    protected void ddl_Segmento_SelectedIndexChanged(object sender, EventArgs e)
    {
        SegmentoEmpr = ddl_Segmento.SelectedValue.ToString();
        llenado_de_empresa();
    }
    protected void Grilla_Empr_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        // e.Row.Cells[1].Visible = false;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DropDownList ddlt_CodiGrup = (DropDownList)e.Row.FindControl("ddl_GrupoE");
            DropDownList ddlt_Codisegm = (DropDownList)e.Row.FindControl("ddl_segmE");
            DropDownList ddlt_TipoTaxo = (DropDownList)e.Row.FindControl("ddl_TipoTaxoE");
            Label lblt_CodiGrup = (Label)e.Row.FindControl("lbl_CodiGrup");
            Label lblt_CodiSegm = (Label)e.Row.FindControl("lbl_Codisegm");
            Label lblt_TipoTaxo = (Label)e.Row.FindControl("lbl_TipoTaxo");

            if (ddlt_CodiGrup != null)
            {
                DataTable dtGrup = geneGru.getGrupos().Tables[0];

                ddlt_CodiGrup.DataSource = dtGrup;
                ddlt_CodiGrup.DataTextField = dtGrup.Columns["desc_grup"].ToString();
                ddlt_CodiGrup.DataValueField = dtGrup.Columns["codi_grup"].ToString();
                ddlt_CodiGrup.DataBind();

                DataTable dtSegm = geneGru.getSegmentos().Tables[0];

                ddlt_Codisegm.DataSource = dtSegm;
                ddlt_Codisegm.DataTextField = dtSegm.Columns["desc_segm"].ToString();
                ddlt_Codisegm.DataValueField = dtSegm.Columns["codi_segm"].ToString();
                ddlt_Codisegm.DataBind();

                DataTable dtTipo = geneGru.getTiposTaxonomia().Tables[0];

                ddlt_TipoTaxo.DataSource = dtTipo;
                ddlt_TipoTaxo.DataTextField = dtTipo.Columns["desc_tipo"].ToString();
                ddlt_TipoTaxo.DataValueField = dtTipo.Columns["tipo_taxo"].ToString();
                ddlt_TipoTaxo.DataBind();

                ddlt_CodiGrup.SelectedValue = lblt_CodiGrup.Text;
                ddlt_Codisegm.SelectedValue = lblt_CodiSegm.Text;
                ddlt_TipoTaxo.SelectedValue = lblt_TipoTaxo.Text;
            }
        }
    }
    protected void ddl_TipoTaxonomia_SelectedIndexChanged(object sender, EventArgs e)
    {
        TipoTaxonomia = ddl_TipoTaxonomia.SelectedValue;
        llenado_de_empresa();
    }
    protected void Buscar_Click(object sender, ImageClickEventArgs e)
    {
        llenado_de_empresa();
    }
}