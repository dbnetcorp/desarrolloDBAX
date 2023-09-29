// Decompiled with JetBrains decompiler
// Type: DbnetWebLibrary.ValidaForms
// Assembly: DbnetWebLibrary, Version=1.0.4846.32991, Culture=neutral, PublicKeyToken=null
// MVID: C0BBA738-7D4D-4EF6-BC01-69A3EC828016
// Assembly location: C:\dbnet\SVN_desarrolloDBAX\dbsWebNet\DBNeT.DBAX.Wss\Bin\DbnetWebLibrary.dll

using System;

namespace DbnetWebLibrary
{
  public class ValidaForms
  {
    public string validaFechaYYYYMMDD(string fecha, string separador)
    {
      string str1 = "";
      if (fecha.Length == 10)
      {
        if (fecha.Substring(4, 1) != separador || fecha.Substring(7, 1) != separador)
        {
          str1 += "Formato de fecha incorrecto<br>";
        }
        else
        {
          try
          {
            DateTime dateTime = new DateTime((int) Convert.ToInt16(fecha.Substring(0, 4), 10), (int) Convert.ToInt16(fecha.Substring(5, 2), 10), (int) Convert.ToInt16(fecha.Substring(8, 2), 10), 0, 0, 0, 0);
          }
          catch (Exception ex)
          {
            string str2 = str1 + "Formato de fecha incorrecto<br>";
            throw ex;
          }
        }
      }
      else
        str1 += "Formato de fecha incorrecto<br>";
      return str1;
    }

    public string validaFechaDDMMYYYY(string fecha, string separador)
    {
      string str1 = "";
      if (fecha.Length == 10)
      {
        if (fecha.Substring(2, 1) != separador || fecha.Substring(5, 1) != separador)
        {
          str1 += "Formato de fecha incorrecto<br>";
        }
        else
        {
          try
          {
            DateTime dateTime = new DateTime((int) Convert.ToInt16(fecha.Substring(6, 4), 10), (int) Convert.ToInt16(fecha.Substring(3, 2), 10), (int) Convert.ToInt16(fecha.Substring(0, 2), 10), 0, 0, 0, 0);
          }
          catch (Exception ex)
          {
            string str2 = str1 + "Formato de fecha incorrecto<br>";
            throw ex;
          }
        }
      }
      else
        str1 += "Formato de fecha incorrecto<br>";
      return str1;
    }

    public string validaRut(string rut, string digito)
    {
      string str1 = "";
      try
      {
        int int32 = Convert.ToInt32(rut);
        int num1 = 0;
        int num2 = 2;
        for (; int32 > 0; int32 /= 10)
        {
          num1 += int32 % 10 * num2;
          ++num2;
          if (num2 > 7)
            num2 = 2;
        }
        int num3 = 11 - num1 % 11;
        string str2;
        switch (num3)
        {
          case 10:
            str2 = "K";
            break;
          case 11:
            str2 = "0";
            goto label_11;
          default:
            str2 = num3.ToString();
            break;
        }
label_11:
        if (!str2.Equals(digito.ToUpper()))
          str1 += "<br>Rut Inválido";
      }
      catch (Exception ex)
      {
        string str3 = str1 + "<br>Rut Inválido";
        throw ex;
      }
      return str1;
    }

    public string generaWhereDynamic(
      string codi_empr,
      string tipo_docu,
      string fech_desd,
      string fech_hast,
      string foli_desd,
      string foli_hast,
      string codi_sucu,
      string rutt_rece)
    {
      string str = "";
      if (codi_empr != null && codi_empr != "")
        str = str + " codi_empr =" + codi_empr + " and ";
      if (tipo_docu != null && tipo_docu != "")
        str = str + " tipo_docu =" + tipo_docu + " and ";
      if (foli_desd != null && foli_desd != "")
        str = str + " foli_docu >=" + foli_desd + " and ";
      if (foli_hast != null && foli_hast != "" && foli_hast != "0")
        str = str + " foli_docu <=" + foli_hast + " and ";
      if (codi_sucu != null && codi_sucu != "")
        str = str + " codi_sucu =" + codi_sucu + " and ";
      if (fech_desd != null && fech_desd != "")
        str = str + " fech_emis >='" + fech_desd + "' and ";
      if (fech_hast != null && fech_hast != "")
        str = str + " fech_emis <='" + fech_hast + "' and ";
      if (rutt_rece != null && rutt_rece != "" && rutt_rece != "0")
        str = str + " rutt_rece =" + rutt_rece + " and ";
      if (str.Length > 0)
        str = str.Substring(0, str.Length - 5);
      return str;
    }
  }
}
