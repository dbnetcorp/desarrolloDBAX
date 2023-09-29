// Decompiled with JetBrains decompiler
// Type: DbnetWebLibrary.DbnetComprobaciones
// Assembly: DbnetWebLibrary, Version=1.0.4846.32991, Culture=neutral, PublicKeyToken=null
// MVID: C0BBA738-7D4D-4EF6-BC01-69A3EC828016
// Assembly location: C:\dbnet\SVN_desarrolloDBAX\dbsWebNet\DBNeT.DBAX.Wss\Bin\DbnetWebLibrary.dll

using System;
using System.Text.RegularExpressions;

namespace DbnetWebLibrary
{
  public class DbnetComprobaciones
  {
    private DbnetComprobaciones()
    {
    }

    public static bool Rutvalido(int rut, string ver)
    {
      int num1 = rut;
      int num2 = 2;
      int num3 = 0;
      while (num1 > 0)
      {
        num3 = num1 % 10 * num2 + num3;
        num1 /= 10;
        ++num2;
        if (num2 > 7)
          num2 = 2;
      }
      int num4 = 11 - num3 % 11;
      switch (num4)
      {
        case 10:
          return ver == "k" || ver == "K";
        case 11:
          return ver == "0";
        default:
          return Convert.ToString(num4) == ver;
      }
    }

    public static bool MailValido(string correo) => new Regex("^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$").IsMatch(correo);

    public static bool MayorIgual(int numero1, int numero2) => numero1 >= numero2;

    public static bool Igual(int numero1, int numero2) => numero1 == numero2;

    public static bool MenorIgual(int numero1, int numero2) => numero1 <= numero2;

    public static bool Menor(int numero1, int numero2) => numero1 < numero2;

    public static bool Mayor(int numero1, int numero2) => numero1 > numero2;

    private static string Comprueba(string comparacion, int numero1, int numero2)
    {
      switch (comparacion)
      {
        case "=":
        case "==":
          if (!DbnetComprobaciones.Igual(numero1, numero2))
            return " debe tener " + (object) numero2 + " caracteres";
          break;
        case "=>":
        case ">=":
          if (!DbnetComprobaciones.MayorIgual(numero1, numero2))
            return " debe tener " + (object) numero2 + " o mas caracteres";
          break;
        case "<=":
        case "=<":
          if (!DbnetComprobaciones.MenorIgual(numero1, numero2))
            return " debe tener " + (object) numero2 + " o menos caracteres";
          break;
        case ">":
          if (!DbnetComprobaciones.Mayor(numero1, numero2))
            return " debe tener mas de " + (object) numero2 + " caracteres";
          break;
        case "<":
          if (!DbnetComprobaciones.Menor(numero1, numero2))
            return " debe tener mas de " + (object) numero2 + " caracteres";
          break;
      }
      return "";
    }

    public static string ValidaCadena(
      string campo,
      string cadena,
      int tipo,
      string lista,
      string tamano)
    {
      if (cadena.Length == 0)
        return campo + " no puede ser Vacio";
      string[] strArray = tamano.Split(';');
      string str1 = "";
      string str2 = "";
      int numero2 = 0;
      for (int index = 0; index < strArray[0].Length && !char.IsDigit(strArray[0], index); ++index)
        str1 += strArray[0].Substring(index, 1);
      int int16 = (int) Convert.ToInt16(strArray[0].Replace(str1, ""));
      for (int index = 0; index < strArray[1].Length && !char.IsDigit(strArray[1], index); ++index)
        str2 += strArray[1].Substring(index, 1);
      if (str2 != "")
        numero2 = Convert.ToInt32(strArray[1].Replace(str2, ""));
      if (str2 == "")
      {
        string str3 = DbnetComprobaciones.Comprueba(str1, cadena.Length, int16);
        if (str3 != "")
          return campo + " " + str3;
      }
      else
      {
        string str4 = DbnetComprobaciones.Comprueba(str1, cadena.Length, int16);
        string str5 = DbnetComprobaciones.Comprueba(str2, cadena.Length, numero2);
        if (str4 != "" || str5 != "")
          return campo + " debe tener entre " + (object) int16 + " y " + (object) numero2 + " caracteres";
      }
      for (int index = 0; index < cadena.Length; ++index)
      {
        if (tipo == 1 && !char.IsDigit(cadena, index))
          return campo + " solo acepta numeros";
        if (tipo == 2 && !char.IsLetterOrDigit(cadena, index))
          return campo + " solo acepta numeros y/o letras";
        if (tipo == 3 && !char.IsLetter(cadena, index))
          return campo + " solo acepta letras";
        for (int startIndex = 0; startIndex < lista.Length; ++startIndex)
        {
          if (cadena.Substring(index, 1) == lista.Substring(startIndex, 1))
            return campo + " posee un caracter no valido";
        }
      }
      return "";
    }
  }
}
