// Decompiled with JetBrains decompiler
// Type: DbnetWebLibrary.DbnetUtiles
// Assembly: DbnetWebLibrary, Version=1.0.4846.32991, Culture=neutral, PublicKeyToken=null
// MVID: C0BBA738-7D4D-4EF6-BC01-69A3EC828016
// Assembly location: C:\dbnet\SVN_desarrolloDBAX\dbsWebNet\DBNeT.DBAX.Wss\Bin\DbnetWebLibrary.dll

using System;
using System.Data;
using System.Xml;

namespace DbnetWebLibrary
{
  public class DbnetUtiles
  {
    public static DataTable RecuperaLabel(string archivo)
    {
      DataTable dataTable = new DataTable();
      XmlTextReader archivo1 = (XmlTextReader) null;
      try
      {
        archivo1 = new XmlTextReader(archivo);
        dataTable = DbnetUtiles.FormateaLabel((XmlReader) archivo1);
      }
      catch (Exception ex)
      {
        Console.WriteLine(ex.Message);
        DbnetGlobal.Mensaje_Error = ex.Message;
      }
      finally
      {
        archivo1?.Close();
      }
      return dataTable;
    }

    private static DataTable FormateaLabel(XmlReader archivo)
    {
      DataTable dataTable = new DataTable();
      string columnName = "";
      string str1 = "";
      string str2 = "";
      int num = 0;
      dataTable.Clear();
      DataRow row = dataTable.NewRow();
      while (archivo.Read())
      {
        switch (archivo.NodeType)
        {
          case XmlNodeType.Element:
            switch (archivo.Name.ToUpper())
            {
              case "LABEL":
                str2 = archivo.Name.ToUpper();
                columnName = "";
                str1 = "";
                num = 1;
                break;
              case "CODIGO":
                if (num == 1)
                {
                  str2 = archivo.Name.ToUpper();
                  break;
                }
                break;
              case "DESCRIPCION":
                if (num == 1)
                {
                  str2 = archivo.Name.ToUpper();
                  break;
                }
                break;
            }
            break;
          case XmlNodeType.Text:
            switch (str2)
            {
              case "CODIGO":
                columnName = archivo.Value.ToString();
                str2 = "";
                break;
              case "DESCRIPCION":
                str1 = archivo.Value.ToString();
                str2 = "";
                break;
            }
            break;
          case XmlNodeType.EndElement:
            switch (archivo.Name.ToUpper())
            {
              case "LABEL":
                if (columnName != "" && str1 != "")
                {
                  dataTable.Columns.Add(new DataColumn(columnName, typeof (string)));
                  row[columnName] = (object) str1;
                }
                num = 0;
                break;
            }
            break;
        }
      }
      dataTable.Rows.Add(row);
      return dataTable;
    }
  }
}
