// Decompiled with JetBrains decompiler
// Type: DbnetWebLibrary.DbnetTool
// Assembly: DbnetWebLibrary, Version=1.0.4846.32991, Culture=neutral, PublicKeyToken=null
// MVID: C0BBA738-7D4D-4EF6-BC01-69A3EC828016
// Assembly location: C:\dbnet\SVN_desarrolloDBAX\dbsWebNet\DBNeT.DBAX.Wss\Bin\DbnetWebLibrary.dll

using System;
using System.Collections;
using System.Data;
using System.Data.OleDb;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace DbnetWebLibrary
{
  public class DbnetTool
  {
    private DbnetTool()
    {
    }

    public static string SQL(string accion, string tabla, asObject objeto, string condicion)
    {
      string str1 = "";
      string str2 = "values (";
      string str3 = "(";
      string str4 = "";
      if (condicion != "")
        condicion = " where " + condicion;
      switch (accion)
      {
        case "I":
          for (int indice = 0; indice < objeto.getContador(); ++indice)
          {
            str3 = str3 + objeto.getObjeto(indice) + " ,";
            str2 = str2 + objeto.getValor(indice) + " ,";
          }
          string str5 = str2.Substring(0, str2.Length - 1).ToString() + ")";
          string str6 = str3.Substring(0, str3.Length - 1).ToString() + ")";
          return "insert into " + tabla + " " + str6 + " " + str5 + " " + condicion;
        case "U":
          for (int indice = 0; indice < objeto.getContador(); ++indice)
            str4 = str4 + objeto.getObjeto(indice) + "=" + objeto.getValor(indice) + " ,";
          string str7 = str4.Substring(0, str4.Length - 1).ToString();
          return "update " + tabla + " set " + str7 + " " + condicion;
        default:
          return str1;
      }
    }

    public static string recuperaMenu(string archivo)
    {
      StreamReader streamReader = new StreamReader(archivo);
      string str1 = "";
      for (string str2 = streamReader.ReadLine(); str2 != null; str2 = streamReader.ReadLine())
        str1 += str2;
      streamReader.Close();
      return str1;
    }

    public static bool ctrlSqlInjection(HtmlForm _form)
    {
      ControlCollection controls = _form.Controls;
      for (int index = 0; index < controls.Count; ++index)
      {
        if (controls[index] is TextBox && controls[index].ID != "txtWhere" && controls[index].ID != "Mnsg_erro" && controls[index].ID != "Mens_esta" && controls[index].ID != "SQLC_ALAR" && controls[index].ID != "SQLI_ALAR")
          DbnetTool.valida_texbox(((TextBox) controls[index]).Text);
      }
      return true;
    }

    private static void valida_texbox(string _textbox)
    {
      if (_textbox.ToLower().IndexOf(" union select ") != -1)
        throw new Exception("union select, no permitido");
      if (_textbox.ToLower().IndexOf(" or ") != -1)
        throw new Exception("or, no permitido");
      if (_textbox.ToLower().IndexOf("select") != -1)
        throw new Exception("select, no permitido");
      if (_textbox.ToLower().IndexOf("update") != -1)
        throw new Exception("update, no permitido");
      if (_textbox.ToLower().IndexOf("insert ") != -1)
        throw new Exception("insert, no permitido");
      if (_textbox.ToLower().IndexOf(";") != -1)
        throw new Exception("punto y coma, no permitido");
      if (_textbox.ToLower().IndexOf("'") != -1)
        throw new Exception("comillas simple, no permitido");
      if (_textbox.ToLower().IndexOf("\"") != -1)
        throw new Exception("comillas doble, no permitido");
      if (_textbox.ToLower().IndexOf(";delete ") != -1)
        throw new Exception("delete, no permitido");
      if (_textbox.ToLower().IndexOf(" delete ") != -1)
        throw new Exception("delete, no permitido");
      if (_textbox.ToLower().IndexOf(";alter ") != -1)
        throw new Exception("alter, no permitido");
      if (_textbox.ToLower().IndexOf(" alter ") != -1)
        throw new Exception("alter, no permitido");
      if (_textbox.ToLower().IndexOf(";drop ") != -1)
        throw new Exception("drop, no permitido");
      if (_textbox.ToLower().IndexOf(" drop ") != -1)
        throw new Exception("drop, no permitido");
    }

    public static void MsgError(string mensaje, Page pagina)
    {
      string script = "<script>alert(\"" + mensaje + "\");</script>";
      pagina.ClientScript.RegisterStartupScript(typeof (Page), "msgError", script);
    }

    public static void MsgAlerta(string mensaje, Page pagina)
    {
      string script = "<script>alert(\"" + mensaje + "\");</script>";
      pagina.ClientScript.RegisterStartupScript(typeof (Page), "msgError", script);
    }

    public static string Initcap(string sEntrada)
    {
      int num = 1;
      string str = "";
      if (sEntrada != null)
      {
        char[] charArray = sEntrada.ToCharArray();
        for (int index = 0; index < sEntrada.Length; ++index)
        {
          str = num != 1 ? str + charArray[index].ToString().ToLower() : str + charArray[index].ToString().ToUpper();
          num = charArray[index] != ' ' && charArray[index] != '.' && charArray[index] != ',' ? 0 : 1;
        }
      }
      return str;
    }

    public static string SelectInto(OleDbConnection dbConn, string query)
    {
      OleDbCommand oleDbCommand = new OleDbCommand();
      OleDbDataAdapter oleDbDataAdapter = new OleDbDataAdapter();
      DataTable dataTable = new DataTable();
      oleDbCommand.Connection = dbConn;
      oleDbCommand.CommandText = query;
      oleDbDataAdapter.SelectCommand = oleDbCommand;
      oleDbCommand.CommandTimeout = 900;
      dataTable.Clear();
      oleDbDataAdapter.Fill(dataTable);
      DataRow[] dataRowArray = dataTable.Select("", "");
      if (dataRowArray.Length < 1)
        return "";
      foreach (DataRow dataRow in dataRowArray)
      {
        IEnumerator enumerator = dataTable.Columns.GetEnumerator();
        try
        {
          if (enumerator.MoveNext())
          {
            DataColumn current = (DataColumn) enumerator.Current;
            return dataRow[current].ToString();
          }
        }
        finally
        {
          if (enumerator is IDisposable disposable)
            disposable.Dispose();
        }
      }
      return "";
    }

    public static DataTable Ejecuta_Select(OleDbConnection dbConn, string query)
    {
      OleDbCommand oleDbCommand = new OleDbCommand();
      OleDbDataAdapter oleDbDataAdapter = new OleDbDataAdapter();
      DataTable dataTable = new DataTable();
      oleDbCommand.Connection = dbConn;
      oleDbCommand.CommandText = query;
      oleDbDataAdapter.SelectCommand = oleDbCommand;
      oleDbCommand.CommandTimeout = 900;
      dataTable.Clear();
      oleDbDataAdapter.Fill(dataTable);
      return dataTable;
    }

    public static bool valida_certificacion(OleDbConnection dbConn, int codigo_empresa)
    {
      OleDbDataReader oleDbDataReader1 = new OleDbCommand("SELECT RUTT_EMPR,CLAV_ENCR FROM EMPR WHERE CODI_EMPR = " + (object) codigo_empresa, dbConn).ExecuteReader();
      oleDbDataReader1.Read();
      try
      {
        if (oleDbDataReader1.GetValue(oleDbDataReader1.GetOrdinal("RUTT_EMPR")) == DBNull.Value)
        {
          oleDbDataReader1.Close();
          return false;
        }
        if (oleDbDataReader1.GetValue(oleDbDataReader1.GetOrdinal("CLAV_ENCR")) == DBNull.Value)
        {
          oleDbDataReader1.Close();
          return false;
        }
        string str1 = oleDbDataReader1.GetValue(oleDbDataReader1.GetOrdinal("RUTT_EMPR")).ToString();
        string str2 = oleDbDataReader1.GetValue(oleDbDataReader1.GetOrdinal("CLAV_ENCR")).ToString();
        oleDbDataReader1.Close();
        OleDbDataReader oleDbDataReader2 = new OleDbCommand("SELECT CODE_DESC FROM SYS_CODE WHERE DOMAIN_CODE = 0 AND CODE = 'LIC'")
        {
          Connection = dbConn
        }.ExecuteReader();
        oleDbDataReader2.Read();
        string str3;
        try
        {
          str3 = oleDbDataReader2.GetValue(oleDbDataReader2.GetOrdinal("CODE_DESC")).ToString();
          oleDbDataReader2.Close();
        }
        catch
        {
          oleDbDataReader2.Close();
          str3 = "0";
        }
        if ((!(str3 == "1") ? DbnetSecurity.encr_vari("DBNeT" + str1) : DbnetSecurity.encr_vari("ASP" + str1)) == str2)
        {
          oleDbDataReader1.Close();
          return true;
        }
        oleDbDataReader1.Close();
        return false;
      }
      catch
      {
        return false;
      }
    }

    public static string SeteaMensaje(string mensaje) => DbnetTool.SeteaMensaje("N", mensaje);

    public static string SeteaMensaje(string tipo, string mensaje)
    {
      if (tipo == "N")
        return "<li>" + mensaje;
      return tipo == "R" ? "<b>" + mensaje + "</b>" : mensaje;
    }

    public static int Ejecuta_Proceso(
      string TipoProce,
      DbnetSesion ctx,
      string proceso,
      string parametros)
    {
      int num1 = 0;
      string str1 = "";
      int num2;
      try
      {
        ProcessStartInfo startInfo = new ProcessStartInfo();
        startInfo.UseShellExecute = true;
        startInfo.RedirectStandardOutput = false;
        startInfo.FileName = proceso;
        startInfo.Arguments = parametros;
        ProcessStartInfo processStartInfo = startInfo;
        processStartInfo.Arguments = processStartInfo.Arguments + " -h " + DbnetTool.SelectInto(ctx.dbConnection, "select param_value from sys_param where param_name='EGATE_HOME'");
        str1 += DbnetTool.SeteaMensaje("R", "Proceso Ejecutado:<br>");
        str1 += DbnetTool.SeteaMensaje("N", startInfo.FileName + startInfo.Arguments);
        num2 = Process.Start(startInfo).Id;
      }
      catch (Exception ex)
      {
        string str2 = str1 + "<br>" + ex.Message;
        num2 = num1;
      }
      return num2;
    }

    public static string Ejecuta_Proceso(DbnetSesion ctx, string proceso, string parametros)
    {
      string str = "";
      try
      {
        ProcessStartInfo startInfo = new ProcessStartInfo();
        startInfo.UseShellExecute = true;
        startInfo.RedirectStandardOutput = false;
        startInfo.FileName = proceso;
        startInfo.Arguments += " ";
        startInfo.Arguments += parametros;
        ProcessStartInfo processStartInfo = startInfo;
        processStartInfo.Arguments = processStartInfo.Arguments + " -h " + DbnetTool.SelectInto(ctx.dbConnection, "select param_value from sys_param where param_name='EGATE_HOME'");
        str += DbnetTool.SeteaMensaje("R", "Proceso Ejecutado:<br>");
        str += DbnetTool.SeteaMensaje("N", startInfo.FileName + startInfo.Arguments);
        Process.Start(startInfo);
      }
      catch (Exception ex)
      {
        str = str + "<br>" + ex.Message;
      }
      return str;
    }

    public static string Ejecuta_Proceso(
      DbnetSesion ctx,
      string proceso,
      string parametros,
      int cola,
      string so)
    {
      string str = "";
      try
      {
        parametros = parametros + " -h " + DbnetTool.SelectInto(ctx.dbConnection, "select param_value from sys_param where param_name='EGATE_HOME'");
        if (so == "unix")
        {
          proceso = proceso.Replace("\\", "/");
          parametros = parametros.Replace("\\", "/");
        }
        if (DbnetGlobal.Base_dato == "SQLSERVER")
        {
          string query = "Insert into se_pipe(pipe_stat, pipe_cmd, pipe_codi_usua, cola_proc)values ('P' ,'" + proceso + " " + parametros + "','" + ctx.Codi_usua + "','" + Convert.ToString(cola) + "')";
          DbnetTool.Ejecuta_Select(ctx.dbConnection, query);
        }
        else
        {
          string query = "Insert into se_pipe(pipe_id,pipe_stat, pipe_cmd, pipe_codi_usua, cola_proc)values (seq_se_pipe.nextval(),'P' ,'" + proceso + " " + parametros + "','" + ctx.Codi_usua + "','" + Convert.ToString(cola) + "')";
          DbnetTool.Ejecuta_Select(ctx.dbConnection, query);
        }
      }
      catch (Exception ex)
      {
        throw ex;
      }
      return str;
    }

    public static string Ejecuta_ProcesoPFX(DbnetSesion ctx, string proceso, string parametros)
    {
      string str = "";
      try
      {
        ProcessStartInfo startInfo = new ProcessStartInfo();
        startInfo.UseShellExecute = true;
        startInfo.RedirectStandardOutput = false;
        startInfo.FileName = proceso;
        startInfo.Arguments = parametros;
        str += DbnetTool.SeteaMensaje("R", "Proceso Ejecutado:<br>");
        str += DbnetTool.SeteaMensaje("N", startInfo.FileName + startInfo.Arguments);
        Process.Start(startInfo).WaitForExit();
      }
      catch (Exception ex)
      {
        str = str + "<br>" + ex.Message;
      }
      return str;
    }

    public static string Ejecuta_Proceso_Multiple(
      DbnetSesion ctx,
      string proceso,
      string parametros)
    {
      string str = "";
      try
      {
        ProcessStartInfo startInfo = new ProcessStartInfo();
        startInfo.UseShellExecute = true;
        startInfo.RedirectStandardOutput = false;
        startInfo.FileName = proceso;
        startInfo.Arguments = parametros;
        ProcessStartInfo processStartInfo = startInfo;
        processStartInfo.Arguments = processStartInfo.Arguments + " -h " + DbnetTool.SelectInto(ctx.dbConnection, "select param_value from sys_param where param_name='EGATE_HOME'");
        str += DbnetTool.SeteaMensaje("N", startInfo.FileName + startInfo.Arguments);
        Process.Start(startInfo);
      }
      catch (Exception ex)
      {
        str = str + "<br>" + ex.Message;
      }
      return str;
    }

    public static string Ejecuta_Proceso_Multiple(
      DbnetSesion ctx,
      string proceso,
      string parametros,
      int cola,
      string so)
    {
      string str = "";
      try
      {
        parametros = parametros + " -h " + DbnetTool.SelectInto(ctx.dbConnection, "select param_value from sys_param where param_name='EGATE_HOME'");
        if (so == "unix")
        {
          proceso = proceso.Replace("\\", "/");
          parametros = parametros.Replace("\\", "/");
        }
        if (DbnetGlobal.Base_dato == "SQLSERVER")
        {
          string query = "Insert into se_pipe(pipe_stat, pipe_cmd, pipe_codi_usua, cola_proc)values ('P' ,'" + proceso + " " + parametros + "','" + ctx.Codi_usua + "','" + Convert.ToString(cola) + "')";
          DbnetTool.Ejecuta_Select(ctx.dbConnection, query);
        }
        else
        {
          string query = "Insert into se_pipe(pipe_id,pipe_stat, pipe_cmd, pipe_codi_usua, cola_proc)values (seq_se_pipe.nextval(),'P' ,'" + proceso + " " + parametros + "','" + ctx.Codi_usua + "','" + Convert.ToString(cola) + "')";
          DbnetTool.Ejecuta_Select(ctx.dbConnection, query);
        }
      }
      catch (Exception ex)
      {
        throw ex;
      }
      return str;
    }

    public static string Ejecuta_Proc_Retorna_Error(
      DbnetSesion ctx,
      string proceso,
      string parametros)
    {
      string str1 = "";
      string str2;
      try
      {
        ProcessStartInfo startInfo = new ProcessStartInfo();
        startInfo.UseShellExecute = true;
        startInfo.RedirectStandardOutput = false;
        startInfo.FileName = proceso;
        startInfo.Arguments = parametros;
        ProcessStartInfo processStartInfo = startInfo;
        processStartInfo.Arguments = processStartInfo.Arguments + " -h " + DbnetTool.SelectInto(ctx.dbConnection, "select param_value from sys_param where param_name='EGATE_HOME'");
        Process process = Process.Start(startInfo);
        process.WaitForExit();
        if (process.ExitCode == 1)
        {
          str2 = "El proceso termino con Errores verifique el LOG Asociado en el directorio Log de la Suite";
        }
        else
        {
          str1 += DbnetTool.SeteaMensaje("R", "Proceso Ejecutado:<br>");
          str2 = str1 + DbnetTool.SeteaMensaje("N", startInfo.FileName + startInfo.Arguments);
        }
      }
      catch (Exception ex)
      {
        str2 = str1 + "<br>" + ex.Message;
      }
      return str2;
    }

    public static string Ejecuta_Proceso_Espera(DbnetSesion ctx, string proceso, string parametros)
    {
      string str = "";
      try
      {
        ProcessStartInfo startInfo = new ProcessStartInfo();
        startInfo.UseShellExecute = false;
        if (proceso.ToString() == "egateDTE")
        {
          string[] strArray1 = new string[5];
          char[] chArray = new char[1]{ ' ' };
          bool flag1 = false;
          bool flag2 = false;
          bool flag3 = false;
          bool flag4 = false;
          string[] strArray2 = parametros.Split(chArray);
          for (int index = 0; index < strArray2.Length; ++index)
          {
            if (strArray2[index].ToString() == "-te" && strArray2[index + 1].ToString() == "bd")
              flag1 = true;
            if (strArray2[index].ToString() == "-ts" && strArray2[index + 1].ToString() == "xml")
              flag2 = true;
            if (strArray2[index].ToString() == "-te" && strArray2[index + 1].ToString() == "flat")
              flag3 = true;
            if (strArray2[index].ToString() == "-ts" && strArray2[index + 1].ToString() == "bd")
              flag4 = true;
          }
          if (flag1 && flag2)
            proceso = "egateDTExml";
          if (flag3 && flag4)
            proceso = "egateDTEcarga";
        }
        startInfo.FileName = proceso;
        startInfo.Arguments = parametros;
        ProcessStartInfo processStartInfo = startInfo;
        processStartInfo.Arguments = processStartInfo.Arguments + " -h " + DbnetTool.SelectInto(ctx.dbConnection, "select param_value from sys_param where param_name='EGATE_HOME'");
        str += DbnetTool.SeteaMensaje("R", "Proceso Ejecutado:<br>");
        str += DbnetTool.SeteaMensaje("N", startInfo.FileName + startInfo.Arguments);
        Process process = Process.Start(startInfo);
        process.WaitForExit();
        process.Close();
        process.Dispose();
      }
      catch (Exception ex)
      {
        str = str + "<br>" + ex.Message;
      }
      return str;
    }

    public static string Ejecuta_Proceso_Espera(
      DbnetSesion ctx,
      string proceso,
      string parametros,
      int cola,
      string so)
    {
      string str = "";
      try
      {
        parametros = parametros + " -h " + DbnetTool.SelectInto(ctx.dbConnection, "select param_value from sys_param where param_name='EGATE_HOME'");
        if (so == "unix")
        {
          proceso = proceso.Replace("\\", "/");
          parametros = parametros.Replace("\\", "/");
        }
        if (DbnetGlobal.Base_dato == "SQLSERVER")
        {
          string query = "Insert into se_pipe(pipe_stat, pipe_cmd, pipe_codi_usua, cola_proc)values ('P' ,'" + proceso + " " + parametros + "','" + ctx.Codi_usua + "','" + Convert.ToString(cola) + "')";
          DbnetTool.Ejecuta_Select(ctx.dbConnection, query);
        }
        else
        {
          string query = "Insert into se_pipe(pipe_id,pipe_stat, pipe_cmd, pipe_codi_usua, cola_proc)values (seq_se_pipe.nextval(),'P' ,'" + proceso + " " + parametros + "','" + ctx.Codi_usua + "','" + Convert.ToString(cola) + "')";
          DbnetTool.Ejecuta_Select(ctx.dbConnection, query);
        }
      }
      catch (Exception ex)
      {
        throw ex;
      }
      return str;
    }

    public static string ConvertXML(
      XmlDocument InputXMLDocument,
      string XSLTFilePath,
      XsltArgumentList XSLTArgs)
    {
      StringWriter results = new StringWriter();
      XslCompiledTransform compiledTransform = new XslCompiledTransform();
      compiledTransform.Load(XSLTFilePath);
      compiledTransform.Transform((IXPathNavigable) InputXMLDocument.CreateNavigator(), XSLTArgs, (TextWriter) results);
      return results.ToString();
    }

    public static string ProcesaXslt(string _xmlPath, string _xslPath, string _archivoPath)
    {
      try
      {
        XmlDocument xmlDocument = new XmlDocument();
        xmlDocument.Load(_xmlPath);
        XPathDocument input = new XPathDocument((TextReader) new StringReader(xmlDocument.InnerXml));
        XslCompiledTransform compiledTransform = new XslCompiledTransform();
        compiledTransform.Load(_xslPath);
        XmlTextWriter results = new XmlTextWriter(_archivoPath, Encoding.Default);
        compiledTransform.Transform((IXPathNavigable) input, (XsltArgumentList) null, (XmlWriter) results);
        results.Close();
        return "";
      }
      catch (Exception ex)
      {
        return "<br>" + ex.Message;
      }
    }

    public static string Ejecuta_Proceso_Xslt(DbnetSesion ctx, string proceso, string parametros)
    {
      string str = "";
      try
      {
        ProcessStartInfo startInfo = new ProcessStartInfo();
        startInfo.UseShellExecute = false;
        startInfo.RedirectStandardOutput = true;
        startInfo.FileName = proceso;
        startInfo.Arguments = parametros;
        str += DbnetTool.SeteaMensaje("R", "Proceso Ejecutado:<br>");
        str += DbnetTool.SeteaMensaje("N", startInfo.FileName + startInfo.Arguments);
        Process.Start(startInfo).WaitForExit();
      }
      catch (Exception ex)
      {
        str = str + "<br>" + ex.Message;
      }
      return str;
    }

    public static string Ejecuta_Proceso_Xslt(
      DbnetSesion ctx,
      string proceso,
      string parametros,
      int cola,
      string so)
    {
      string str = "";
      try
      {
        if (so == "unix")
        {
          proceso = proceso.Replace("\\", "/");
          parametros = parametros.Replace("\\", "/");
        }
        if (DbnetGlobal.Base_dato == "SQLSERVER")
        {
          string query = "Insert into se_pipe(pipe_stat, pipe_cmd, pipe_codi_usua, cola_proc)values ('P' ,'" + proceso + " " + parametros + "','" + ctx.Codi_usua + "','" + Convert.ToString(cola) + "')";
          DbnetTool.Ejecuta_Select(ctx.dbConnection, query);
        }
        else
        {
          string query = "Insert into se_pipe(pipe_id,pipe_stat, pipe_cmd, pipe_codi_usua, cola_proc)values (seq_se_pipe.nextval(),'P' ,'" + proceso + " " + parametros + "','" + ctx.Codi_usua + "','" + Convert.ToString(cola) + "')";
          DbnetTool.Ejecuta_Select(ctx.dbConnection, query);
        }
      }
      catch (Exception ex)
      {
        throw ex;
      }
      return str;
    }

    public static DataTable DataView_To_DataTable(DataView obDataView)
    {
      DataTable dataTable = null != obDataView ? obDataView.Table.Clone() : throw new ArgumentNullException("DataView", "Invalid DataView object specified");
      int num = 0;
      string[] strArray = new string[dataTable.Columns.Count];
      foreach (DataColumn column in (InternalDataCollectionBase) dataTable.Columns)
        strArray[num++] = column.ColumnName;
      foreach (DataRowView dataRowView in obDataView)
      {
        DataRow row = dataTable.NewRow();
        try
        {
          foreach (string str in strArray)
            row[str] = dataRowView[str];
        }
        catch
        {
        }
        dataTable.Rows.Add(row);
      }
      return dataTable;
    }

    public static DataGrid Formatea_Grid(DataGrid Grilla)
    {
      for (int index = 0; index < Grilla.Columns.Count; ++index)
      {
        string headerText = Grilla.Columns[index].HeaderText;
        string str = "";
        switch (headerText)
        {
          case "total":
            str = Grilla.Columns[index].ItemStyle.CssClass;
            break;
          case "precio":
            str = Grilla.Columns[index].HeaderText;
            break;
          case "monto":
            str = Grilla.Columns[index].HeaderText;
            break;
        }
      }
      return Grilla;
    }

    public static string Nombre_Estandar(
      DbnetSesion ctx,
      string cod_empr,
      string tipodoc,
      string folio)
    {
      string query = "select rutt_emis,tipo_docu,foli_docu from dte_enca_docu " + "where codi_empr = " + cod_empr + " and foli_docu = " + folio + "  and tipo_docu = " + tipodoc;
      string str1 = "";
      DataTable dataTable = DbnetTool.Ejecuta_Select(ctx.dbConnection, query);
      if (dataTable.Rows.Count > 0)
      {
        DataRow row = dataTable.Rows[0];
        string str2 = row["rutt_emis"].ToString();
        string str3 = row["tipo_docu"].ToString();
        string str4 = row["foli_docu"].ToString();
        int num1 = 10 - str4.Length;
        int num2 = 0;
        string str5 = "E";
        string str6 = "T";
        string str7 = "F";
        string str8 = str2.Length != 9 ? str5 + "0" + str2 : str5 + str2;
        string str9 = str3.Length != 3 ? str6 + "0" + str3 : str6 + str3;
        for (; num2 < num1; ++num2)
          str7 += "0";
        string str10 = str7 + str4;
        str1 = str8 + str9 + str10;
      }
      return str1;
    }

    public static string Get_Param(DbnetSesion ctx, string ParametroBD, string ParametroEM)
    {
      string query1 = "select valo_paem  from para_empr where codi_empr = " + (object) ctx.Codi_empr + " and codi_paem = '" + ParametroEM + "' ";
      DataTable dataTable1 = DbnetTool.Ejecuta_Select(ctx.dbConnection, query1);
      string str;
      if (dataTable1.Rows.Count > 0)
      {
        str = dataTable1.Rows[0]["VALO_PAEM"].ToString();
      }
      else
      {
        string query2 = "select param_value  from sys_param where param_name = '" + ParametroBD + "' ";
        DataTable dataTable2 = DbnetTool.Ejecuta_Select(ctx.dbConnection, query2);
        str = dataTable2.Rows.Count <= 0 ? "%NULL%" : dataTable2.Rows[0]["PARAM_VALUE"].ToString();
      }
      return str;
    }

    public static void registraPagina(DbnetSesion ctx, string pagina)
    {
      if (!(DbnetTool.SelectInto(ctx.dbConnection, "SELECT PARAM_VALUE FROM sys_param WHERE PARAM_NAME ='SECU_AUDI_MENU'") == "S"))
        return;
      string query;
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        query = "INSERT INTO sys_sess_prog            (corr_sess, desc_opci, fech_opci, codi_usua) VALUES     (" + (object) ctx.Corr_sess + ",            '" + pagina + "',            GETDATE(),            '" + ctx.Codi_usua + "')";
      else
        query = "INSERT INTO sys_sess_prog            (corr_sess, desc_opci, fech_opci, codi_usua) VALUES     (" + (object) ctx.Corr_sess + ",            '" + pagina + "',            SYSDATE,            '" + ctx.Codi_usua + "')";
      DbnetTool.Ejecuta_Select(ctx.dbConnection, query);
    }
  }
}
