// Decompiled with JetBrains decompiler
// Type: DbnetWebLibrary.DbnetSecurity
// Assembly: DbnetWebLibrary, Version=1.0.4846.32991, Culture=neutral, PublicKeyToken=null
// MVID: C0BBA738-7D4D-4EF6-BC01-69A3EC828016
// Assembly location: C:\dbnet\SVN_desarrolloDBAX\dbsWebNet\DBNeT.DBAX.Wss\Bin\DbnetWebLibrary.dll

using System;

namespace DbnetWebLibrary
{
  public class DbnetSecurity
  {
    private DbnetSecurity()
    {
    }

    public static string encr_vari(string string_original)
    {
      string str1 = (string) null;
      int num1 = 12;
      int num2 = 10;
      int num3 = num1 - num2;
      int num4 = 0;
      int length = string_original.Length;
      string[] strArray1 = new string[length + 1];
      string[] strArray2 = new string[length + 1];
      string[] strArray3 = new string[64];
      int index1 = 0;
      if (length <= 0)
        return (string) null;
      for (int index2 = 48; index2 <= 57; ++index2)
      {
        ++index1;
        strArray3[index1] = Convert.ToString((char) index2);
      }
      for (int index3 = 65; index3 <= 90; ++index3)
      {
        ++index1;
        strArray3[index1] = Convert.ToString((char) index3);
      }
      for (int index4 = 97; index4 <= 122; ++index4)
      {
        ++index1;
        strArray3[index1] = Convert.ToString((char) index4);
      }
      int index5 = index1 + 1;
      strArray3[index5] = "*";
      int index6 = 1;
      while (index6 < length + 1 && num4 == 0)
      {
        strArray1[index6] = string_original.Substring(index6 - 1, 1);
        int index7 = 1;
        while (num4 == 0 && index7 <= index5 - 1)
        {
          if (strArray1[index6] == strArray3[index7])
            num4 = 1;
          else
            ++index7;
        }
        if (num4 == 1)
        {
          int num5 = index7;
          int index8 = index6 % 3 != 0 ? (index6 % 2 != 0 ? (num5 + num2 + index6) % index5 : (num5 + num1 + index6) % index5) : (num5 + num3 + index6) % index5;
          if (index8 == 0)
            index8 = index5;
          strArray2[index6] = strArray3[index8];
          str1 += strArray2[index6];
          num4 = 0;
          ++index6;
        }
        else
          num4 = 2;
      }
      if (num4 == 2)
        return (string) null;
      int index9;
      int index10;
      if (length % 3 == 0)
      {
        index9 = index5 - 1 - num2;
        index10 = num1 + num2;
      }
      else if (length % 2 == 0)
      {
        index9 = index5 - 1 - num1;
        index10 = num1 - num2;
      }
      else
      {
        index9 = num1;
        index10 = index5 - 1 - (num1 + num2);
      }
      string str2 = strArray3[index9];
      string str3 = strArray3[index10];
      return str2 + str1 + str3;
    }

    public static string dese_vari(string string_encrip)
    {
      string str1 = "";
      int num1 = 0;
      int num2 = 0;
      int num3 = 0;
      int index1 = 1;
      int index2 = 1;
      string[] strArray = new string[64];
      int length1 = string_encrip.Length;
      string str2 = string_encrip.Substring(1, length1 - 2);
      int length2 = str2.Length;
      int index3 = 0;
      if (length2 > 0)
      {
        for (int index4 = 48; index4 <= 57; ++index4)
        {
          ++index3;
          strArray[index3] = Convert.ToString((char) index4);
        }
        for (int index5 = 65; index5 <= 90; ++index5)
        {
          ++index3;
          strArray[index3] = Convert.ToString((char) index5);
        }
        for (int index6 = 97; index6 <= 122; ++index6)
        {
          ++index3;
          strArray[index3] = Convert.ToString((char) index6);
        }
        int index7 = index3 + 1;
        strArray[index7] = "*";
        while (num2 == 0 && index1 < index7)
        {
          if (string_encrip.Substring(0, 1) == strArray[index1])
            num2 = 1;
          else
            ++index1;
        }
        while (num3 == 0 && index2 < index7)
        {
          if (string_encrip.Substring(length1 - 1, 1) == strArray[index2])
            num3 = 1;
          else
            ++index2;
        }
        if (num2 == 1 && num3 == 1)
        {
          int num4;
          int num5;
          if (length2 % 3 == 0)
          {
            num4 = index7 - 1 - index1;
            num5 = index2 - num4;
          }
          else if (length2 % 2 == 0)
          {
            num5 = index7 - 1 - index1;
            num4 = num5 - index2;
          }
          else
          {
            num5 = index1;
            num4 = index7 - 1 - index2 - num5;
          }
          int num6 = num5 - num4;
          int num7 = 1;
          while (num7 < length2 + 1 && num1 == 0)
          {
            int index8 = 1;
            while (num1 == 0 && index8 < index7)
            {
              int num8 = index8;
              int index9 = num7 % 3 != 0 ? (num7 % 2 != 0 ? (num8 + num4 + num7) % index7 : (num8 + num5 + num7) % index7) : (num8 + num6 + num7) % index7;
              if (index9 == 0)
                index9 = index7;
              if (str2.Substring(num7 - 1, 1) == strArray[index9])
                num1 = 1;
              else
                ++index8;
            }
            if (num1 == 1)
            {
              str1 += strArray[index8];
              num1 = 0;
              ++num7;
            }
            else
              num1 = 2;
          }
          if (num1 != 2)
            ;
        }
      }
      return str1;
    }
  }
}
