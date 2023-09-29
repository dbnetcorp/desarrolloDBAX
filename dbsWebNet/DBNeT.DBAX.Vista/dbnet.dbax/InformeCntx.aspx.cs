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


public partial class Website_InformeCntx : System.Web.UI.Page
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
    MantencionCntx cntx = new MantencionCntx();

    protected void Page_Load(object sender, EventArgs e)
    {
        this.RecuperaSessionWeb();
        try
        {
            lb_error.Text = "";
            if (!IsPostBack)
            {
                #region cargaInforme
                    DataSet ds = cntx.getInformes(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString());
                    ddl_CodiInfo.DataSource = ds;
                    ddl_CodiInfo.DataTextField = ds.Tables[0].Columns[1].ToString();
                    ddl_CodiInfo.DataValueField = ds.Tables[0].Columns[0].ToString();
                    ddl_CodiInfo.DataBind();
                #endregion
                #region cargaContextos
                    DataTable dt = cntx.getContextos(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString()).Tables[0];

                    NombreCntx.DataSource = dt;
                    NombreCntx.DataTextField = dt.Columns[0].ToString();
                    NombreCntx.DataValueField = dt.Columns[0].ToString();
                    NombreCntx.DataBind();
                #endregion
                LLenado_grilla(ddl_CodiInfo.SelectedValue);            
            }
            orden.Text = cntx.getMaxOrdenColumna(ddl_CodiInfo.SelectedValue,_goSessionWeb.CODI_EMPR.ToString() ,_goSessionWeb.CODI_EMEX ).ToString();
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.ToString();
        }
    }

    protected void Informe_SelectedIndexChanged(object sender, EventArgs e)
    {
        LLenado_grilla(ddl_CodiInfo.SelectedValue.ToString());
    }
    protected void agregar(object sender, ImageClickEventArgs e)
    {
        try
        {
            MantencionCntx cntx = new MantencionCntx();
            if (cntx.verificar_orden(ddl_CodiInfo.SelectedValue.ToString(), orden.Text, _goSessionWeb.CODI_EMPR.ToString()))
            {
                cntx.GuardarInfoCntx(_goSessionWeb.CODI_EMEX.ToString(), _goSessionWeb.CODI_EMPR.ToString(), ddl_CodiInfo.SelectedValue.ToString(), "0", "0", NombreCntx.SelectedValue.ToString(), orden.Text);
                LLenado_grilla(ddl_CodiInfo.SelectedValue.ToString());
                orden.Text = "";
            }
            else
            {
                lb_error.Text = "Ya existe un orden con ese valor";
            }
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.ToString();
        }
    }
    protected void LLenado_grilla(string informe)
    {
        //MantencionCntx cntx = new MantencionCntx();
        GeneracionExcel Excel = new GeneracionExcel();

        DataTable dtInforme = Excel.getInforme(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_CodiInfo.SelectedValue, "C");

        if (dtInforme.Rows[0]["codi_emex"].ToString() == "0")
        {
            agregarCntxInfo.Enabled = false;
            agregarCntxInfo.Visible = false;
        }
        else
        {
            agregarCntxInfo.Enabled = true;
            agregarCntxInfo.Visible = true;
        }

        DataSet dt = Excel.getInformesContextos(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), "201212", ddl_CodiInfo.SelectedValue);
        Grilla_Cntx.DataSource = dt;
        Grilla_Cntx.DataBind();
        Grilla_Cntx.Columns[1].Visible = false;
    }

    protected void Grilla_Informe_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        Grilla_Cntx.EditIndex = -1;
        LLenado_grilla(ddl_CodiInfo.SelectedValue.ToString());
    }
    protected void Grilla_Informe_RowEditing(object sender, GridViewEditEventArgs e)
    {
        int indexRow = e.NewEditIndex;
        GridViewRow row = Grilla_Cntx.Rows[indexRow];
        Grilla_Cntx.EditIndex = e.NewEditIndex;
        LLenado_grilla(ddl_CodiInfo.SelectedValue.ToString());
    }
    protected void Grilla_Informe_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            MantencionCntx cntx = new MantencionCntx();
            int indexRow = e.RowIndex;
            GridViewRow row = Grilla_Cntx.Rows[indexRow];
            string CodiCntx = ((Label)(row.Cells[1].Controls[1])).Text;
            cntx.delInfoCntx(_goSessionWeb.CODI_EMEX, _goSessionWeb.CODI_EMPR.ToString(), ddl_CodiInfo.SelectedValue, CodiCntx);
            LLenado_grilla(ddl_CodiInfo.SelectedValue.ToString());
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
        }
    }
    protected void Grilla_Informe_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            MantencionCntx cntx = new MantencionCntx();
            int indexRow = e.RowIndex;
            GridViewRow row = Grilla_Cntx.Rows[indexRow];
            int OrdeCntxAct = Convert.ToInt32(((TextBox)(row.Cells[0].Controls[3])).Text);
            int OrdeCntxAnt = Convert.ToInt32(((Label)(row.Cells[0].Controls[1])).Text);
            string CodiCntx = ((Label)(row.Cells[1].Controls[1])).Text;
            cntx.UpdOrdenInforme("1", "1", ddl_CodiInfo.SelectedValue, CodiCntx, OrdeCntxAnt, OrdeCntxAct);
            Grilla_Cntx.EditIndex = -1;
            LLenado_grilla(ddl_CodiInfo.SelectedValue.ToString());
        }
        catch (Exception ex)
        {
            lb_error.Visible = true;
            lb_error.Text = ex.Message;
            Grilla_Cntx.EditIndex = -1;
        }
    }
}