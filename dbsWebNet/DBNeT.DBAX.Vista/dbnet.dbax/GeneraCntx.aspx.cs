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

public partial class Website_MantencionCntx : System.Web.UI.Page
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
    MantencionCntx Contextos = new MantencionCntx();
    GeneracionExcel GenExcel = new GeneracionExcel();
    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        lb_error.Text = string.Empty;

        if (!IsPostBack)
        {
            DataSet ds = Contextos.getCodificacionFechas("D");
            ddl_FechIni1.DataSource = ds;
            ddl_FechIni1.DataTextField = ds.Tables[0].Columns["desc_fech"].ToString();
            ddl_FechIni1.DataValueField = ds.Tables[0].Columns["codi_fech"].ToString();
            ddl_FechIni1.DataBind();

            ddl_FechFin1.DataSource = ds;
            ddl_FechFin1.DataTextField = ds.Tables[0].Columns["desc_fech"].ToString();
            ddl_FechFin1.DataValueField = ds.Tables[0].Columns["codi_fech"].ToString();
            ddl_FechFin1.DataBind();

            ds = Contextos.getCodificacionFechas("A");
            ddl_FechIni2.DataSource = ds;
            ddl_FechIni2.DataTextField = ds.Tables[0].Columns["desc_fech"].ToString();
            ddl_FechIni2.DataValueField = ds.Tables[0].Columns["codi_fech"].ToString();
            ddl_FechIni2.DataBind();

            ddl_FechFin2.DataSource = ds;
            ddl_FechFin2.DataTextField = ds.Tables[0].Columns["desc_fech"].ToString();
            ddl_FechFin2.DataValueField = ds.Tables[0].Columns["codi_fech"].ToString();
            ddl_FechFin2.DataBind();

            DataTable dt_CorrInst = GenExcel.getPersCorrInst("");
            ddl_CorrInst.DataSource = dt_CorrInst;
            ddl_CorrInst.DataTextField = dt_CorrInst.Columns["desc_inst"].ToString();
            ddl_CorrInst.DataValueField = dt_CorrInst.Columns["corr_inst"].ToString();
            ddl_CorrInst.DataBind();
            LLenado_grilla();
        }
    }

    protected void agregar_Click_cntx(object sender, ImageClickEventArgs e)
    {
        try
        {
            string vDiaiCntx = "", vAnoiCntx = "", vDiatCntx = "", vAnotCntx = "";
            MantencionCntx cntx = new MantencionCntx();

            vDiaiCntx = ddl_FechIni1.SelectedValue.ToString();
            vAnoiCntx = ddl_FechIni2.SelectedValue.ToString();

            if (ddl_FechFin1.SelectedValue.ToString() != "0" && ddl_FechFin2.SelectedValue.ToString() != "0")
            {
                vDiatCntx = ddl_FechFin1.SelectedValue.ToString();
                vAnotCntx = ddl_FechFin2.SelectedValue.ToString();
            }

            cntx.insCntx(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), Nombre_cntx.Text, Nombre_cntx.Text.Replace(" ", ""), vDiaiCntx, vAnoiCntx, vDiatCntx, vAnotCntx);
            LLenado_grilla();
            Nombre_cntx.Text = "";
        }
        catch (Exception)
        {
            lb_error.Visible = true;
            lb_error.Text = "Ya existe este contexto";
        }
    }
    protected void LLenado_grilla()
    {
        DataSet dt = Contextos.getContextos(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), Convert.ToInt32(ddl_CorrInst.SelectedValue.ToString()));
        Grilla_Cntx.DataSource = dt;
        Grilla_Cntx.DataBind();
        Grilla_Cntx.Columns[0].Visible = false; //Codigo contexto
        Grilla_Cntx.Columns[2].Visible = false; //Codigo dia inicio
        Grilla_Cntx.Columns[4].Visible = false; //Codigo año inicio
        Grilla_Cntx.Columns[7].Visible = false; //Codigo año termino
        Grilla_Cntx.Columns[9].Visible = false; //Codigo año termino

        Grilla_Cntx.Columns[12].Visible = false; //CodiEmex
        Grilla_Cntx.Columns[13].Visible = false; //CodiEmpr

        
    }
    protected void Grilla_Cntx_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            MantencionCntx cntx = new MantencionCntx();
            int indexRow = e.RowIndex;
            GridViewRow row = Grilla_Cntx.Rows[indexRow];
            cntx.delCntx(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ((Label)(row.Cells[1].Controls[1])).Text);
            LLenado_grilla();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
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
    protected void ddl_FechIni1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddl_FechIni1.SelectedValue != "0" && ddl_FechIni2.SelectedValue != "0")
        {
            DataTable dt_Contextos = Contextos.getFechasCntx(ddl_CorrInst.SelectedValue.ToString(), ddl_FechIni1.SelectedValue.ToString(), ddl_FechIni2.SelectedValue.ToString()).Tables[0];
            lb_FechIni.Text = dt_Contextos.Rows[0]["Fecha"].ToString();
            ddl_FechFin1.Enabled = true;
            ddl_FechFin2.Enabled = true;
        }
        else
        {
            lb_FechIni.Text = "";
            ddl_FechFin1.Enabled = false;
            ddl_FechFin2.Enabled = false;
        }
    }
    protected void ddl_FechFin1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddl_FechFin1.SelectedValue != "0" && ddl_FechFin2.SelectedValue != "0")
        {
            DataTable dt_Contextos = Contextos.getFechasCntx(ddl_CorrInst.SelectedValue.ToString(), ddl_FechFin1.SelectedValue.ToString(), ddl_FechFin2.SelectedValue.ToString()).Tables[0];
            lb_FechFin.Text = dt_Contextos.Rows[0]["Fecha"].ToString();
        }
        else
        {
            lb_FechFin.Text = "";
        }
    }
    protected void ddl_CorrInst_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddl_FechIni1_SelectedIndexChanged(null, null);
        ddl_FechFin1_SelectedIndexChanged(null, null);
        LLenado_grilla();
    }
    protected void Grilla_Cntx_RowEditing(object sender, GridViewEditEventArgs e)
    {
        int indexRow = e.NewEditIndex;
        Label CodiEmex = (Label)Grilla_Cntx.Rows[indexRow].FindControl("lb_codi_emex");
        GridViewRow row = Grilla_Cntx.Rows[indexRow];
        Grilla_Cntx.EditIndex = e.NewEditIndex;
        LLenado_grilla();
    }
    protected void Grilla_Cntx_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        Grilla_Cntx.EditIndex = -1;
        LLenado_grilla();
    }
    protected void Grilla_Cntx_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            MantencionCntx cntx = new MantencionCntx();
            GridViewRow row = Grilla_Cntx.Rows[e.RowIndex];
            string CodiCntx = ((Label)(row.Cells[0].Controls[1])).Text;
            string Desc_Cntx = ((TextBox)(row.Cells[1].Controls[1])).Text;
            string CodiDiai = ((DropDownList)(row.Cells[3].Controls[1])).Text;
            string CodiAnoi = ((DropDownList)(row.Cells[5].Controls[1])).Text;
            string CodiDiat = ((DropDownList)(row.Cells[8].Controls[1])).Text;
            string CodiAnot = ((DropDownList)(row.Cells[10].Controls[1])).Text;
            if (Desc_Cntx != "" && CodiDiai != "" && CodiAnoi != "" && ((CodiDiat == "0" && CodiAnot == "0") || (CodiDiat != "0" && CodiAnot != "0")))
            {
                cntx.UpdContexto(_goSessionWeb.CODI_EMPR.ToString(),_goSessionWeb.CODI_EMEX , CodiCntx, Desc_Cntx, CodiDiai, CodiAnoi, CodiDiat, CodiAnot);
            }
            else
            {
                throw new System.ArgumentException("Hay problemas con la definicion del contexto.");
            }
            Grilla_Cntx.EditIndex = -1;
            LLenado_grilla();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void Grilla_Cntx_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        // e.Row.Cells[1].Visible = false;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            #region deshabilito y cambio boton de edición
            int fila = e.Row.RowIndex;
            Label CodiEmex = (Label)e.Row.FindControl("lb_codi_emex");
            if (CodiEmex.Text == "0")
            {
                e.Row.Cells[14].Enabled = false;
                e.Row.Cells[15].Enabled = false;
                ((LinkButton)e.Row.Cells[14].Controls[1]).Text = "<img alt=\"No se puede editar\" src=\"../librerias/img/NoEdit.png\"/>";
                ((LinkButton)e.Row.Cells[15].Controls[1]).Text = "<img alt=\"No se puede eliminar\" src=\"../librerias/img/NoBorrar.png\"  width=\"20\"/>";
            }
            #endregion

            DropDownList ddlt_Diai = (DropDownList)e.Row.FindControl("ddl_DiaiCntx");
            DropDownList ddlt_Anoi = (DropDownList)e.Row.FindControl("ddl_AnoiCntx");
            DropDownList ddlt_Diat = (DropDownList)e.Row.FindControl("ddl_DiatCntx");
            DropDownList ddlt_Anot = (DropDownList)e.Row.FindControl("ddl_AnotCntx");
            Label lblt_Diai = (Label)e.Row.FindControl("lb_CodiDiai");
            Label lblt_Anoi = (Label)e.Row.FindControl("lb_CodiAnoi");
            Label lblt_Diat = (Label)e.Row.FindControl("lb_CodiDiat");
            Label lblt_Anot = (Label)e.Row.FindControl("lb_CodiAnot");

            if (ddlt_Diai != null && ddlt_Anoi != null)
            {
                DataTable dtDia = Contextos.getCodificacionFechas("D").Tables[0];

                ddlt_Diai.DataSource = dtDia;
                ddlt_Diai.DataTextField = dtDia.Columns["desc_fech"].ToString();
                ddlt_Diai.DataValueField = dtDia.Columns["codi_fech"].ToString();
                ddlt_Diai.DataBind();

                DataTable dtAnoi = Contextos.getCodificacionFechas("A").Tables[0];
                ddlt_Anoi.DataSource = dtAnoi;
                ddlt_Anoi.DataTextField = dtAnoi.Columns["desc_fech"].ToString();
                ddlt_Anoi.DataValueField = dtAnoi.Columns["codi_fech"].ToString();
                ddlt_Anoi.DataBind();

                /*DataTable dtSegm = Contextos.getCodificacionFechas("A").Tables[0];

                ddlt_Codisegm.DataSource = dtSegm;
                ddlt_Codisegm.DataTextField = dtSegm.Columns["desc_segm"].ToString();
                ddlt_Codisegm.DataValueField = dtSegm.Columns["codi_segm"].ToString();
                ddlt_Codisegm.DataBind();*/

                ddlt_Diai.SelectedValue = lblt_Diai.Text;
                ddlt_Anoi.SelectedValue = lblt_Anoi.Text;
                //ddlt_Codisegm.SelectedValue = lblt_CodiSegm.Text;

                if (ddlt_Diat != null && ddlt_Anot != null)
                {
                    dtDia = Contextos.getCodificacionFechas("D").Tables[0];

                    ddlt_Diat.DataSource = dtDia;
                    ddlt_Diat.DataTextField = dtDia.Columns["desc_fech"].ToString();
                    ddlt_Diat.DataValueField = dtDia.Columns["codi_fech"].ToString();
                    ddlt_Diat.DataBind();

                    DataTable dtAnot = Contextos.getCodificacionFechas("A").Tables[0];
                    ddlt_Anot.DataSource = dtAnot;
                    ddlt_Anot.DataTextField = dtAnot.Columns["desc_fech"].ToString();
                    ddlt_Anot.DataValueField = dtAnot.Columns["codi_fech"].ToString();
                    ddlt_Anot.DataBind();

                    /*DataTable dtSegm = Contextos.getCodificacionFechas("A").Tables[0];

                    ddlt_Codisegm.DataSource = dtSegm;
                    ddlt_Codisegm.DataTextField = dtSegm.Columns["desc_segm"].ToString();
                    ddlt_Codisegm.DataValueField = dtSegm.Columns["codi_segm"].ToString();
                    ddlt_Codisegm.DataBind();*/

                    ddlt_Diat.SelectedValue = lblt_Diat.Text;
                    ddlt_Anot.SelectedValue = lblt_Anot.Text;
                    //ddlt_Codisegm.SelectedValue = lblt_CodiSegm.Text;
                }
            }

            
        }
    }
    protected void Grilla_Cntx_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Grilla_Cntx.PageIndex = e.NewPageIndex;
        Grilla_Cntx.DataBind();
        LLenado_grilla();
    
    }
}