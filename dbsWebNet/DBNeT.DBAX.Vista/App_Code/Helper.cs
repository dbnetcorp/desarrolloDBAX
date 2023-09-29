using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for Helper
/// </summary>
public static class Helper
{
    public static void ddlSelecciona(DropDownList ddl, string codigo)
    {
        try
        {
            ddl.SelectedValue = codigo;
        }
        catch (Exception ex)
        {
            ddl.SelectedIndex = 0;
        }
      
    }
    public static void ddlCarga(DropDownList ddl, DataTable dt)
    {
        ddl.Items.Clear();
        ddl.DataTextField = "VALOR";
        ddl.DataValueField = "CODIGO";
        ddl.DataSource = dt;
        ddl.DataBind();
    }
    public static void ckbCarga(CheckBoxList ckbList, DataTable dt)
    {
        ckbList.Items.Clear();
        ckbList.DataTextField = "VALOR";
        ckbList.DataValueField = "CODIGO";
        ckbList.DataSource = dt;
        ckbList.DataBind();
    }

    public static void ddlCarga(DropDownList ddl, DataTable dt, string tsCodigo, string tsValor)
    {
        ddl.Items.Clear();
        ddl.Items.Add(new ListItem("Seleccione", ""));
        if (dt.Rows[0][0] == "" && dt.Rows[0][1] == "")
        { dt.Rows.RemoveAt(0); }
        foreach (DataRow item in dt.Rows)
        {
            ddl.Items.Add(new ListItem(item[tsCodigo].ToString(), item[tsValor].ToString()));
        }
    }
    public static string ckbModoSeleccionado(CheckBox ckb)
    {
        string lsModo = string.Empty;
        if (ckb.Checked)
        { lsModo = ckb.Text; }
        return lsModo;
    }
    public static string[] stringSpli(string tsValorTotal, string tsSeparador)
    {
        string[] lsSeparado = tsValorTotal.Split('-');
        return lsSeparado;
    }
    public static string CompruebaCkb(CheckBox ckb)
    {
        string lsValor = string.Empty;
        if (ckb.Checked)
        { lsValor = "SI"; }
        else
        { lsValor = "NO"; }
        return lsValor;
    }
    public static void aplicaCkb(string tsValor, CheckBox ckb, string valorSeleccionado, string valorNoseleccionado)
    {
        if (tsValor == valorSeleccionado)
        {
            ckb.Checked = true;
        }
        else if (tsValor == valorNoseleccionado)
        {
            ckb.Checked = false;
        }
    }
}