// Decompiled with JetBrains decompiler
// Type: DbnetWebLibrary.asObject
// Assembly: DbnetWebLibrary, Version=1.0.4846.32991, Culture=neutral, PublicKeyToken=null
// MVID: C0BBA738-7D4D-4EF6-BC01-69A3EC828016
// Assembly location: C:\dbnet\SVN_desarrolloDBAX\dbsWebNet\DBNeT.DBAX.Wss\Bin\DbnetWebLibrary.dll

using System;
using System.Text.RegularExpressions;

namespace DbnetWebLibrary
{
  public class asObject
  {
    private string[] objeto = new string[100];
    private string[] valor = new string[100];
    private int[] texto = new int[100];
    private int contador = 0;

    public void Set(string objeto, string valor, int texto, string error)
    {
      if (valor == "")
        throw new Exception("El campo " + error + " no puede estar vacio");
      if (texto == 1)
        valor = valor.ToString().Replace(',', '.');
      string input = valor.Replace("-", "");
      if (texto == 1 && !Regex.IsMatch(input, "^\\d{0,20}\\.{0,1}?\\d{1,4}$") && !Regex.IsMatch(input, "^\\d{0,20}\\,{0,1}?\\d{1,4}$"))
        throw new Exception("El campo " + error + " debe ser numerico y distinto a vacio.");
      this.objeto[this.contador] = objeto;
      this.valor[this.contador] = valor;
      this.texto[this.contador] = texto;
      ++this.contador;
    }

    public void Set(string objeto, string valor, int texto)
    {
      if (texto == 1)
        valor = valor.ToString().Replace(",", ".");
      if (texto == 1 && valor == "")
        valor = "0";
      string input = valor.Replace("-", "");
      if (texto == 1 && !Regex.IsMatch(input, "^\\d{0,20}\\.{0,1}?\\d{1,6}$") && !Regex.IsMatch(input, "^\\d{0,20}\\,{0,1}?\\d{1,6}$"))
        throw new Exception("Esta tratando de ingresar un Caracter en un valor numerico '" + valor + "'");
      this.objeto[this.contador] = objeto;
      this.valor[this.contador] = valor;
      this.texto[this.contador] = texto;
      ++this.contador;
    }

    public string getObjeto(int indice) => this.objeto[indice];

    public string getValor(int indice)
    {
      if (this.valor[indice] == "nulo")
        return "NULL";
      if (this.texto[indice] != 1)
        return "'" + this.valor[indice] + "'";
      return this.valor[indice] == "" ? "0" : this.valor[indice].Replace(',', '.');
    }

    public int getContador() => this.contador;

    public void Clear()
    {
      for (int index = 0; index < this.contador; ++index)
      {
        this.objeto[index] = "";
        this.valor[index] = "";
        this.texto[index] = 0;
      }
      this.contador = 0;
    }
  }
}
