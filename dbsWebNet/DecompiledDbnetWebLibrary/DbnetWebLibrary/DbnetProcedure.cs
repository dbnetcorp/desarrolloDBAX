// Decompiled with JetBrains decompiler
// Type: DbnetWebLibrary.DbnetProcedure
// Assembly: DbnetWebLibrary, Version=1.0.4846.32991, Culture=neutral, PublicKeyToken=null
// MVID: C0BBA738-7D4D-4EF6-BC01-69A3EC828016
// Assembly location: C:\dbnet\SVN_desarrolloDBAX\dbsWebNet\DBNeT.DBAX.Wss\Bin\DbnetWebLibrary.dll

using System;
using System.Data;
using System.Data.OleDb;

namespace DbnetWebLibrary
{
  public class DbnetProcedure
  {
    private OleDbCommand sp;
    private string[] nombres;
    private string[] valores;
    private string[] tipos;
    private int[] largos;
    private string[] inout;

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1)
    {
      this.nombres = new string[1];
      this.valores = new string[1];
      this.tipos = new string[1];
      this.largos = new int[1];
      this.inout = new string[1];
      this.nombres[0] = nombre1;
      this.valores[0] = valor1;
      this.tipos[0] = tipo1;
      this.largos[0] = largo1;
      this.inout[0] = inout1;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1,
      string nombre2,
      string valor2,
      string tipo2,
      int largo2,
      string inout2)
    {
      this.nombres = new string[2];
      this.valores = new string[2];
      this.tipos = new string[2];
      this.largos = new int[2];
      this.inout = new string[2];
      this.nombres[0] = nombre1;
      this.nombres[1] = nombre2;
      this.valores[0] = valor1;
      this.valores[1] = valor2;
      this.tipos[0] = tipo1;
      this.tipos[1] = tipo2;
      this.largos[0] = largo1;
      this.largos[1] = largo2;
      this.inout[0] = inout1;
      this.inout[1] = inout2;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1,
      string nombre2,
      string valor2,
      string tipo2,
      int largo2,
      string inout2,
      string nombre3,
      string valor3,
      string tipo3,
      int largo3,
      string inout3)
    {
      this.nombres = new string[3];
      this.valores = new string[3];
      this.tipos = new string[3];
      this.largos = new int[3];
      this.inout = new string[3];
      this.nombres[0] = nombre1;
      this.nombres[1] = nombre2;
      this.nombres[2] = nombre3;
      this.valores[0] = valor1;
      this.valores[1] = valor2;
      this.valores[2] = valor3;
      this.tipos[0] = tipo1;
      this.tipos[1] = tipo2;
      this.tipos[2] = tipo3;
      this.largos[0] = largo1;
      this.largos[1] = largo2;
      this.largos[2] = largo3;
      this.inout[0] = inout1;
      this.inout[1] = inout2;
      this.inout[2] = inout3;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1,
      string nombre2,
      string valor2,
      string tipo2,
      int largo2,
      string inout2,
      string nombre3,
      string valor3,
      string tipo3,
      int largo3,
      string inout3,
      string nombre4,
      string valor4,
      string tipo4,
      int largo4,
      string inout4)
    {
      this.nombres = new string[4];
      this.valores = new string[4];
      this.tipos = new string[4];
      this.largos = new int[4];
      this.inout = new string[4];
      this.nombres[0] = nombre1;
      this.nombres[1] = nombre2;
      this.nombres[2] = nombre3;
      this.nombres[3] = nombre4;
      this.valores[0] = valor1;
      this.valores[1] = valor2;
      this.valores[2] = valor3;
      this.valores[3] = valor4;
      this.tipos[0] = tipo1;
      this.tipos[1] = tipo2;
      this.tipos[2] = tipo3;
      this.tipos[3] = tipo4;
      this.largos[0] = largo1;
      this.largos[1] = largo2;
      this.largos[2] = largo3;
      this.largos[3] = largo4;
      this.inout[0] = inout1;
      this.inout[1] = inout2;
      this.inout[2] = inout3;
      this.inout[3] = inout4;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1,
      string nombre2,
      string valor2,
      string tipo2,
      int largo2,
      string inout2,
      string nombre3,
      string valor3,
      string tipo3,
      int largo3,
      string inout3,
      string nombre4,
      string valor4,
      string tipo4,
      int largo4,
      string inout4,
      string nombre5,
      string valor5,
      string tipo5,
      int largo5,
      string inout5)
    {
      this.nombres = new string[5];
      this.valores = new string[5];
      this.tipos = new string[5];
      this.largos = new int[5];
      this.inout = new string[5];
      this.nombres[0] = nombre1;
      this.nombres[1] = nombre2;
      this.nombres[2] = nombre3;
      this.nombres[3] = nombre4;
      this.nombres[4] = nombre5;
      this.valores[0] = valor1;
      this.valores[1] = valor2;
      this.valores[2] = valor3;
      this.valores[3] = valor4;
      this.valores[4] = valor5;
      this.tipos[0] = tipo1;
      this.tipos[1] = tipo2;
      this.tipos[2] = tipo3;
      this.tipos[3] = tipo4;
      this.tipos[4] = tipo5;
      this.largos[0] = largo1;
      this.largos[1] = largo2;
      this.largos[2] = largo3;
      this.largos[3] = largo4;
      this.largos[4] = largo5;
      this.inout[0] = inout1;
      this.inout[1] = inout2;
      this.inout[2] = inout3;
      this.inout[3] = inout4;
      this.inout[4] = inout5;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1,
      string nombre2,
      string valor2,
      string tipo2,
      int largo2,
      string inout2,
      string nombre3,
      string valor3,
      string tipo3,
      int largo3,
      string inout3,
      string nombre4,
      string valor4,
      string tipo4,
      int largo4,
      string inout4,
      string nombre5,
      string valor5,
      string tipo5,
      int largo5,
      string inout5,
      string nombre6,
      string valor6,
      string tipo6,
      int largo6,
      string inout6)
    {
      this.nombres = new string[6];
      this.valores = new string[6];
      this.tipos = new string[6];
      this.largos = new int[6];
      this.inout = new string[6];
      this.nombres[0] = nombre1;
      this.nombres[1] = nombre2;
      this.nombres[2] = nombre3;
      this.nombres[3] = nombre4;
      this.nombres[4] = nombre5;
      this.nombres[5] = nombre6;
      this.valores[0] = valor1;
      this.valores[1] = valor2;
      this.valores[2] = valor3;
      this.valores[3] = valor4;
      this.valores[4] = valor5;
      this.valores[5] = valor6;
      this.tipos[0] = tipo1;
      this.tipos[1] = tipo2;
      this.tipos[2] = tipo3;
      this.tipos[3] = tipo4;
      this.tipos[4] = tipo5;
      this.tipos[5] = tipo6;
      this.largos[0] = largo1;
      this.largos[1] = largo2;
      this.largos[2] = largo3;
      this.largos[3] = largo4;
      this.largos[4] = largo5;
      this.largos[5] = largo6;
      this.inout[0] = inout1;
      this.inout[1] = inout2;
      this.inout[2] = inout3;
      this.inout[3] = inout4;
      this.inout[4] = inout5;
      this.inout[5] = inout6;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1,
      string nombre2,
      string valor2,
      string tipo2,
      int largo2,
      string inout2,
      string nombre3,
      string valor3,
      string tipo3,
      int largo3,
      string inout3,
      string nombre4,
      string valor4,
      string tipo4,
      int largo4,
      string inout4,
      string nombre5,
      string valor5,
      string tipo5,
      int largo5,
      string inout5,
      string nombre6,
      string valor6,
      string tipo6,
      int largo6,
      string inout6,
      string nombre7,
      string valor7,
      string tipo7,
      int largo7,
      string inout7)
    {
      this.nombres = new string[7];
      this.valores = new string[7];
      this.tipos = new string[7];
      this.largos = new int[7];
      this.inout = new string[7];
      this.nombres[0] = nombre1;
      this.nombres[1] = nombre2;
      this.nombres[2] = nombre3;
      this.nombres[3] = nombre4;
      this.nombres[4] = nombre5;
      this.nombres[5] = nombre6;
      this.nombres[6] = nombre7;
      this.valores[0] = valor1;
      this.valores[1] = valor2;
      this.valores[2] = valor3;
      this.valores[3] = valor4;
      this.valores[4] = valor5;
      this.valores[5] = valor6;
      this.valores[6] = valor7;
      this.tipos[0] = tipo1;
      this.tipos[1] = tipo2;
      this.tipos[2] = tipo3;
      this.tipos[3] = tipo4;
      this.tipos[4] = tipo5;
      this.tipos[5] = tipo6;
      this.tipos[6] = tipo7;
      this.largos[0] = largo1;
      this.largos[1] = largo2;
      this.largos[2] = largo3;
      this.largos[3] = largo4;
      this.largos[4] = largo5;
      this.largos[5] = largo6;
      this.largos[6] = largo7;
      this.inout[0] = inout1;
      this.inout[1] = inout2;
      this.inout[2] = inout3;
      this.inout[3] = inout4;
      this.inout[4] = inout5;
      this.inout[5] = inout6;
      this.inout[6] = inout7;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1,
      string nombre2,
      string valor2,
      string tipo2,
      int largo2,
      string inout2,
      string nombre3,
      string valor3,
      string tipo3,
      int largo3,
      string inout3,
      string nombre4,
      string valor4,
      string tipo4,
      int largo4,
      string inout4,
      string nombre5,
      string valor5,
      string tipo5,
      int largo5,
      string inout5,
      string nombre6,
      string valor6,
      string tipo6,
      int largo6,
      string inout6,
      string nombre7,
      string valor7,
      string tipo7,
      int largo7,
      string inout7,
      string nombre8,
      string valor8,
      string tipo8,
      int largo8,
      string inout8)
    {
      this.nombres = new string[8];
      this.valores = new string[8];
      this.tipos = new string[8];
      this.largos = new int[8];
      this.inout = new string[8];
      this.nombres[0] = nombre1;
      this.nombres[1] = nombre2;
      this.nombres[2] = nombre3;
      this.nombres[3] = nombre4;
      this.nombres[4] = nombre5;
      this.nombres[5] = nombre6;
      this.nombres[6] = nombre7;
      this.nombres[7] = nombre8;
      this.valores[0] = valor1;
      this.valores[1] = valor2;
      this.valores[2] = valor3;
      this.valores[3] = valor4;
      this.valores[4] = valor5;
      this.valores[5] = valor6;
      this.valores[6] = valor7;
      this.valores[7] = valor8;
      this.tipos[0] = tipo1;
      this.tipos[1] = tipo2;
      this.tipos[2] = tipo3;
      this.tipos[3] = tipo4;
      this.tipos[4] = tipo5;
      this.tipos[5] = tipo6;
      this.tipos[6] = tipo7;
      this.tipos[7] = tipo8;
      this.largos[0] = largo1;
      this.largos[1] = largo2;
      this.largos[2] = largo3;
      this.largos[3] = largo4;
      this.largos[4] = largo5;
      this.largos[5] = largo6;
      this.largos[6] = largo7;
      this.largos[7] = largo8;
      this.inout[0] = inout1;
      this.inout[1] = inout2;
      this.inout[2] = inout3;
      this.inout[3] = inout4;
      this.inout[4] = inout5;
      this.inout[5] = inout6;
      this.inout[6] = inout7;
      this.inout[7] = inout8;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1,
      string nombre2,
      string valor2,
      string tipo2,
      int largo2,
      string inout2,
      string nombre3,
      string valor3,
      string tipo3,
      int largo3,
      string inout3,
      string nombre4,
      string valor4,
      string tipo4,
      int largo4,
      string inout4,
      string nombre5,
      string valor5,
      string tipo5,
      int largo5,
      string inout5,
      string nombre6,
      string valor6,
      string tipo6,
      int largo6,
      string inout6,
      string nombre7,
      string valor7,
      string tipo7,
      int largo7,
      string inout7,
      string nombre8,
      string valor8,
      string tipo8,
      int largo8,
      string inout8,
      string nombre9,
      string valor9,
      string tipo9,
      int largo9,
      string inout9)
    {
      this.nombres = new string[9];
      this.valores = new string[9];
      this.tipos = new string[9];
      this.largos = new int[9];
      this.inout = new string[9];
      this.nombres[0] = nombre1;
      this.nombres[1] = nombre2;
      this.nombres[2] = nombre3;
      this.nombres[3] = nombre4;
      this.nombres[4] = nombre5;
      this.nombres[5] = nombre6;
      this.nombres[6] = nombre7;
      this.nombres[7] = nombre8;
      this.nombres[8] = nombre9;
      this.valores[0] = valor1;
      this.valores[1] = valor2;
      this.valores[2] = valor3;
      this.valores[3] = valor4;
      this.valores[4] = valor5;
      this.valores[5] = valor6;
      this.valores[6] = valor7;
      this.valores[7] = valor8;
      this.valores[8] = valor9;
      this.tipos[0] = tipo1;
      this.tipos[1] = tipo2;
      this.tipos[2] = tipo3;
      this.tipos[3] = tipo4;
      this.tipos[4] = tipo5;
      this.tipos[5] = tipo6;
      this.tipos[6] = tipo7;
      this.tipos[7] = tipo8;
      this.tipos[8] = tipo9;
      this.largos[0] = largo1;
      this.largos[1] = largo2;
      this.largos[2] = largo3;
      this.largos[3] = largo4;
      this.largos[4] = largo5;
      this.largos[5] = largo6;
      this.largos[6] = largo7;
      this.largos[7] = largo8;
      this.largos[8] = largo9;
      this.inout[0] = inout1;
      this.inout[1] = inout2;
      this.inout[2] = inout3;
      this.inout[3] = inout4;
      this.inout[4] = inout5;
      this.inout[5] = inout6;
      this.inout[6] = inout7;
      this.inout[7] = inout8;
      this.inout[8] = inout9;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1,
      string nombre2,
      string valor2,
      string tipo2,
      int largo2,
      string inout2,
      string nombre3,
      string valor3,
      string tipo3,
      int largo3,
      string inout3,
      string nombre4,
      string valor4,
      string tipo4,
      int largo4,
      string inout4,
      string nombre5,
      string valor5,
      string tipo5,
      int largo5,
      string inout5,
      string nombre6,
      string valor6,
      string tipo6,
      int largo6,
      string inout6,
      string nombre7,
      string valor7,
      string tipo7,
      int largo7,
      string inout7,
      string nombre8,
      string valor8,
      string tipo8,
      int largo8,
      string inout8,
      string nombre9,
      string valor9,
      string tipo9,
      int largo9,
      string inout9,
      string nombre10,
      string valor10,
      string tipo10,
      int largo10,
      string inout10)
    {
      this.nombres = new string[10];
      this.valores = new string[10];
      this.tipos = new string[10];
      this.largos = new int[10];
      this.inout = new string[10];
      this.nombres[0] = nombre1;
      this.nombres[1] = nombre2;
      this.nombres[2] = nombre3;
      this.nombres[3] = nombre4;
      this.nombres[4] = nombre5;
      this.nombres[5] = nombre6;
      this.nombres[6] = nombre7;
      this.nombres[7] = nombre8;
      this.nombres[8] = nombre9;
      this.nombres[9] = nombre10;
      this.valores[0] = valor1;
      this.valores[1] = valor2;
      this.valores[2] = valor3;
      this.valores[3] = valor4;
      this.valores[4] = valor5;
      this.valores[5] = valor6;
      this.valores[6] = valor7;
      this.valores[7] = valor8;
      this.valores[8] = valor9;
      this.valores[9] = valor10;
      this.tipos[0] = tipo1;
      this.tipos[1] = tipo2;
      this.tipos[2] = tipo3;
      this.tipos[3] = tipo4;
      this.tipos[4] = tipo5;
      this.tipos[5] = tipo6;
      this.tipos[6] = tipo7;
      this.tipos[7] = tipo8;
      this.tipos[8] = tipo9;
      this.tipos[9] = tipo10;
      this.largos[0] = largo1;
      this.largos[1] = largo2;
      this.largos[2] = largo3;
      this.largos[3] = largo4;
      this.largos[4] = largo5;
      this.largos[5] = largo6;
      this.largos[6] = largo7;
      this.largos[7] = largo8;
      this.largos[8] = largo9;
      this.largos[9] = largo10;
      this.inout[0] = inout1;
      this.inout[1] = inout2;
      this.inout[2] = inout3;
      this.inout[3] = inout4;
      this.inout[4] = inout5;
      this.inout[5] = inout6;
      this.inout[6] = inout7;
      this.inout[7] = inout8;
      this.inout[8] = inout9;
      this.inout[9] = inout10;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1,
      string nombre2,
      string valor2,
      string tipo2,
      int largo2,
      string inout2,
      string nombre3,
      string valor3,
      string tipo3,
      int largo3,
      string inout3,
      string nombre4,
      string valor4,
      string tipo4,
      int largo4,
      string inout4,
      string nombre5,
      string valor5,
      string tipo5,
      int largo5,
      string inout5,
      string nombre6,
      string valor6,
      string tipo6,
      int largo6,
      string inout6,
      string nombre7,
      string valor7,
      string tipo7,
      int largo7,
      string inout7,
      string nombre8,
      string valor8,
      string tipo8,
      int largo8,
      string inout8,
      string nombre9,
      string valor9,
      string tipo9,
      int largo9,
      string inout9,
      string nombre10,
      string valor10,
      string tipo10,
      int largo10,
      string inout10,
      string nombre11,
      string valor11,
      string tipo11,
      int largo11,
      string inout11)
    {
      this.nombres = new string[11];
      this.valores = new string[11];
      this.tipos = new string[11];
      this.largos = new int[11];
      this.inout = new string[11];
      this.nombres[0] = nombre1;
      this.nombres[1] = nombre2;
      this.nombres[2] = nombre3;
      this.nombres[3] = nombre4;
      this.nombres[4] = nombre5;
      this.nombres[5] = nombre6;
      this.nombres[6] = nombre7;
      this.nombres[7] = nombre8;
      this.nombres[8] = nombre9;
      this.nombres[9] = nombre10;
      this.nombres[10] = nombre11;
      this.valores[0] = valor1;
      this.valores[1] = valor2;
      this.valores[2] = valor3;
      this.valores[3] = valor4;
      this.valores[4] = valor5;
      this.valores[5] = valor6;
      this.valores[6] = valor7;
      this.valores[7] = valor8;
      this.valores[8] = valor9;
      this.valores[9] = valor10;
      this.valores[10] = valor11;
      this.tipos[0] = tipo1;
      this.tipos[1] = tipo2;
      this.tipos[2] = tipo3;
      this.tipos[3] = tipo4;
      this.tipos[4] = tipo5;
      this.tipos[5] = tipo6;
      this.tipos[6] = tipo7;
      this.tipos[7] = tipo8;
      this.tipos[8] = tipo9;
      this.tipos[9] = tipo10;
      this.tipos[10] = tipo11;
      this.largos[0] = largo1;
      this.largos[1] = largo2;
      this.largos[2] = largo3;
      this.largos[3] = largo4;
      this.largos[4] = largo5;
      this.largos[5] = largo6;
      this.largos[6] = largo7;
      this.largos[7] = largo8;
      this.largos[8] = largo9;
      this.largos[9] = largo10;
      this.largos[10] = largo11;
      this.inout[0] = inout1;
      this.inout[1] = inout2;
      this.inout[2] = inout3;
      this.inout[3] = inout4;
      this.inout[4] = inout5;
      this.inout[5] = inout6;
      this.inout[6] = inout7;
      this.inout[7] = inout8;
      this.inout[8] = inout9;
      this.inout[9] = inout10;
      this.inout[10] = inout11;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1,
      string nombre2,
      string valor2,
      string tipo2,
      int largo2,
      string inout2,
      string nombre3,
      string valor3,
      string tipo3,
      int largo3,
      string inout3,
      string nombre4,
      string valor4,
      string tipo4,
      int largo4,
      string inout4,
      string nombre5,
      string valor5,
      string tipo5,
      int largo5,
      string inout5,
      string nombre6,
      string valor6,
      string tipo6,
      int largo6,
      string inout6,
      string nombre7,
      string valor7,
      string tipo7,
      int largo7,
      string inout7,
      string nombre8,
      string valor8,
      string tipo8,
      int largo8,
      string inout8,
      string nombre9,
      string valor9,
      string tipo9,
      int largo9,
      string inout9,
      string nombre10,
      string valor10,
      string tipo10,
      int largo10,
      string inout10,
      string nombre11,
      string valor11,
      string tipo11,
      int largo11,
      string inout11,
      string nombre12,
      string valor12,
      string tipo12,
      int largo12,
      string inout12)
    {
      this.nombres = new string[12];
      this.valores = new string[12];
      this.tipos = new string[12];
      this.largos = new int[12];
      this.inout = new string[12];
      this.nombres[0] = nombre1;
      this.nombres[1] = nombre2;
      this.nombres[2] = nombre3;
      this.nombres[3] = nombre4;
      this.nombres[4] = nombre5;
      this.nombres[5] = nombre6;
      this.nombres[6] = nombre7;
      this.nombres[7] = nombre8;
      this.nombres[8] = nombre9;
      this.nombres[9] = nombre10;
      this.nombres[10] = nombre11;
      this.nombres[11] = nombre12;
      this.valores[0] = valor1;
      this.valores[1] = valor2;
      this.valores[2] = valor3;
      this.valores[3] = valor4;
      this.valores[4] = valor5;
      this.valores[5] = valor6;
      this.valores[6] = valor7;
      this.valores[7] = valor8;
      this.valores[8] = valor9;
      this.valores[9] = valor10;
      this.valores[10] = valor11;
      this.valores[11] = valor12;
      this.tipos[0] = tipo1;
      this.tipos[1] = tipo2;
      this.tipos[2] = tipo3;
      this.tipos[3] = tipo4;
      this.tipos[4] = tipo5;
      this.tipos[5] = tipo6;
      this.tipos[6] = tipo7;
      this.tipos[7] = tipo8;
      this.tipos[8] = tipo9;
      this.tipos[9] = tipo10;
      this.tipos[10] = tipo11;
      this.tipos[11] = tipo12;
      this.largos[0] = largo1;
      this.largos[1] = largo2;
      this.largos[2] = largo3;
      this.largos[3] = largo4;
      this.largos[4] = largo5;
      this.largos[5] = largo6;
      this.largos[6] = largo7;
      this.largos[7] = largo8;
      this.largos[8] = largo9;
      this.largos[9] = largo10;
      this.largos[10] = largo11;
      this.largos[11] = largo12;
      this.inout[0] = inout1;
      this.inout[1] = inout2;
      this.inout[2] = inout3;
      this.inout[3] = inout4;
      this.inout[4] = inout5;
      this.inout[5] = inout6;
      this.inout[6] = inout7;
      this.inout[7] = inout8;
      this.inout[8] = inout9;
      this.inout[9] = inout10;
      this.inout[10] = inout11;
      this.inout[11] = inout12;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1,
      string nombre2,
      string valor2,
      string tipo2,
      int largo2,
      string inout2,
      string nombre3,
      string valor3,
      string tipo3,
      int largo3,
      string inout3,
      string nombre4,
      string valor4,
      string tipo4,
      int largo4,
      string inout4,
      string nombre5,
      string valor5,
      string tipo5,
      int largo5,
      string inout5,
      string nombre6,
      string valor6,
      string tipo6,
      int largo6,
      string inout6,
      string nombre7,
      string valor7,
      string tipo7,
      int largo7,
      string inout7,
      string nombre8,
      string valor8,
      string tipo8,
      int largo8,
      string inout8,
      string nombre9,
      string valor9,
      string tipo9,
      int largo9,
      string inout9,
      string nombre10,
      string valor10,
      string tipo10,
      int largo10,
      string inout10,
      string nombre11,
      string valor11,
      string tipo11,
      int largo11,
      string inout11,
      string nombre12,
      string valor12,
      string tipo12,
      int largo12,
      string inout12,
      string nombre13,
      string valor13,
      string tipo13,
      int largo13,
      string inout13)
    {
      this.nombres = new string[13];
      this.valores = new string[13];
      this.tipos = new string[13];
      this.largos = new int[13];
      this.inout = new string[13];
      this.nombres[0] = nombre1;
      this.nombres[1] = nombre2;
      this.nombres[2] = nombre3;
      this.nombres[3] = nombre4;
      this.nombres[4] = nombre5;
      this.nombres[5] = nombre6;
      this.nombres[6] = nombre7;
      this.nombres[7] = nombre8;
      this.nombres[8] = nombre9;
      this.nombres[9] = nombre10;
      this.nombres[10] = nombre11;
      this.nombres[11] = nombre12;
      this.nombres[12] = nombre13;
      this.valores[0] = valor1;
      this.valores[1] = valor2;
      this.valores[2] = valor3;
      this.valores[3] = valor4;
      this.valores[4] = valor5;
      this.valores[5] = valor6;
      this.valores[6] = valor7;
      this.valores[7] = valor8;
      this.valores[8] = valor9;
      this.valores[9] = valor10;
      this.valores[10] = valor11;
      this.valores[11] = valor12;
      this.valores[12] = valor13;
      this.tipos[0] = tipo1;
      this.tipos[1] = tipo2;
      this.tipos[2] = tipo3;
      this.tipos[3] = tipo4;
      this.tipos[4] = tipo5;
      this.tipos[5] = tipo6;
      this.tipos[6] = tipo7;
      this.tipos[7] = tipo8;
      this.tipos[8] = tipo9;
      this.tipos[9] = tipo10;
      this.tipos[10] = tipo11;
      this.tipos[11] = tipo12;
      this.tipos[12] = tipo13;
      this.largos[0] = largo1;
      this.largos[1] = largo2;
      this.largos[2] = largo3;
      this.largos[3] = largo4;
      this.largos[4] = largo5;
      this.largos[5] = largo6;
      this.largos[6] = largo7;
      this.largos[7] = largo8;
      this.largos[8] = largo9;
      this.largos[9] = largo10;
      this.largos[10] = largo11;
      this.largos[11] = largo12;
      this.largos[12] = largo13;
      this.inout[0] = inout1;
      this.inout[1] = inout2;
      this.inout[2] = inout3;
      this.inout[3] = inout4;
      this.inout[4] = inout5;
      this.inout[5] = inout6;
      this.inout[6] = inout7;
      this.inout[7] = inout8;
      this.inout[8] = inout9;
      this.inout[9] = inout10;
      this.inout[10] = inout11;
      this.inout[11] = inout12;
      this.inout[12] = inout13;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    public DbnetProcedure(
      OleDbConnection dbConn,
      string nombre_proc,
      string nombre1,
      string valor1,
      string tipo1,
      int largo1,
      string inout1,
      string nombre2,
      string valor2,
      string tipo2,
      int largo2,
      string inout2,
      string nombre3,
      string valor3,
      string tipo3,
      int largo3,
      string inout3,
      string nombre4,
      string valor4,
      string tipo4,
      int largo4,
      string inout4,
      string nombre5,
      string valor5,
      string tipo5,
      int largo5,
      string inout5,
      string nombre6,
      string valor6,
      string tipo6,
      int largo6,
      string inout6,
      string nombre7,
      string valor7,
      string tipo7,
      int largo7,
      string inout7,
      string nombre8,
      string valor8,
      string tipo8,
      int largo8,
      string inout8,
      string nombre9,
      string valor9,
      string tipo9,
      int largo9,
      string inout9,
      string nombre10,
      string valor10,
      string tipo10,
      int largo10,
      string inout10,
      string nombre11,
      string valor11,
      string tipo11,
      int largo11,
      string inout11,
      string nombre12,
      string valor12,
      string tipo12,
      int largo12,
      string inout12,
      string nombre13,
      string valor13,
      string tipo13,
      int largo13,
      string inout13,
      string nombre14,
      string valor14,
      string tipo14,
      int largo14,
      string inout14)
    {
      this.nombres = new string[14];
      this.valores = new string[14];
      this.tipos = new string[14];
      this.largos = new int[14];
      this.inout = new string[14];
      this.nombres[0] = nombre1;
      this.nombres[1] = nombre2;
      this.nombres[2] = nombre3;
      this.nombres[3] = nombre4;
      this.nombres[4] = nombre5;
      this.nombres[5] = nombre6;
      this.nombres[6] = nombre7;
      this.nombres[7] = nombre8;
      this.nombres[8] = nombre9;
      this.nombres[9] = nombre10;
      this.nombres[10] = nombre11;
      this.nombres[11] = nombre12;
      this.nombres[12] = nombre13;
      this.nombres[13] = nombre14;
      this.valores[0] = valor1;
      this.valores[1] = valor2;
      this.valores[2] = valor3;
      this.valores[3] = valor4;
      this.valores[4] = valor5;
      this.valores[5] = valor6;
      this.valores[6] = valor7;
      this.valores[7] = valor8;
      this.valores[8] = valor9;
      this.valores[9] = valor10;
      this.valores[10] = valor11;
      this.valores[11] = valor12;
      this.valores[12] = valor13;
      this.valores[13] = valor14;
      this.tipos[0] = tipo1;
      this.tipos[1] = tipo2;
      this.tipos[2] = tipo3;
      this.tipos[3] = tipo4;
      this.tipos[4] = tipo5;
      this.tipos[5] = tipo6;
      this.tipos[6] = tipo7;
      this.tipos[7] = tipo8;
      this.tipos[8] = tipo9;
      this.tipos[9] = tipo10;
      this.tipos[10] = tipo11;
      this.tipos[11] = tipo12;
      this.tipos[12] = tipo13;
      this.tipos[13] = tipo14;
      this.largos[0] = largo1;
      this.largos[1] = largo2;
      this.largos[2] = largo3;
      this.largos[3] = largo4;
      this.largos[4] = largo5;
      this.largos[5] = largo6;
      this.largos[6] = largo7;
      this.largos[7] = largo8;
      this.largos[8] = largo9;
      this.largos[9] = largo10;
      this.largos[10] = largo11;
      this.largos[11] = largo12;
      this.largos[12] = largo13;
      this.largos[13] = largo14;
      this.inout[0] = inout1;
      this.inout[1] = inout2;
      this.inout[2] = inout3;
      this.inout[3] = inout4;
      this.inout[4] = inout5;
      this.inout[5] = inout6;
      this.inout[6] = inout7;
      this.inout[7] = inout8;
      this.inout[8] = inout9;
      this.inout[9] = inout10;
      this.inout[10] = inout11;
      this.inout[11] = inout12;
      this.inout[12] = inout13;
      this.inout[13] = inout14;
      this.sp = new OleDbCommand(nombre_proc, dbConn);
      this.sp.CommandTimeout = 900;
      this.sp.CommandType = CommandType.StoredProcedure;
      this.param_procedures();
    }

    private void param_procedures()
    {
      for (int index = 0; index < this.nombres.Length; ++index)
        this.sp.Parameters.Add(this.crea_param(this.nombres[index], this.tipos[index], this.largos[index], this.valores[index], this.inout[index]));
      this.sp.ExecuteNonQuery();
    }

    private OleDbParameter crea_param(
      string nombre,
      string tipo,
      int largo,
      string valor,
      string inout)
    {
      OleDbParameter oleDbParameter = new OleDbParameter();
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        oleDbParameter.ParameterName = "@" + nombre;
      else
        oleDbParameter.ParameterName = nombre;
      if (inout.ToUpper() == "OUT")
        oleDbParameter.Direction = ParameterDirection.Output;
      if (inout.ToUpper() == "INOUT")
        oleDbParameter.Direction = ParameterDirection.InputOutput;
      switch (tipo.ToUpper())
      {
        case "DECIMAL":
          oleDbParameter.OleDbType = OleDbType.Numeric;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToDecimal(valor);
            break;
          }
          break;
        case "SHORT":
          oleDbParameter.OleDbType = OleDbType.SmallInt;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToInt16(valor);
            break;
          }
          break;
        case "INT":
          oleDbParameter.OleDbType = OleDbType.Integer;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToInt32(valor);
            break;
          }
          break;
        case "LONG":
          oleDbParameter.OleDbType = OleDbType.BigInt;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToInt32(valor);
            break;
          }
          break;
        case "BYTE":
          oleDbParameter.OleDbType = OleDbType.Binary;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToByte(valor);
            break;
          }
          break;
        case "SBYTE":
          oleDbParameter.OleDbType = OleDbType.TinyInt;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToSByte(valor);
            break;
          }
          break;
        case "DOUBLE":
          oleDbParameter.OleDbType = OleDbType.Double;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToDouble(valor);
            break;
          }
          break;
        case "USHORT":
          oleDbParameter.OleDbType = OleDbType.UnsignedSmallInt;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToUInt16(valor);
            break;
          }
          break;
        case "UINT":
          oleDbParameter.OleDbType = OleDbType.UnsignedInt;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToUInt32(valor);
            break;
          }
          break;
        case "ULONG":
          oleDbParameter.OleDbType = OleDbType.UnsignedBigInt;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToUInt64(valor);
            break;
          }
          break;
        case "CHAR":
          oleDbParameter.OleDbType = OleDbType.Char;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToChar(valor);
            break;
          }
          break;
        case "STRING":
          oleDbParameter.OleDbType = OleDbType.VarChar;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) valor;
            break;
          }
          break;
        case "VARCHAR":
          oleDbParameter.OleDbType = OleDbType.VarChar;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) valor;
            break;
          }
          break;
        case "BOOL":
          oleDbParameter.OleDbType = OleDbType.Boolean;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToBoolean(valor);
            break;
          }
          break;
        case "DATE":
          oleDbParameter.OleDbType = OleDbType.DBDate;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToDateTime(valor);
            break;
          }
          break;
        case "TIMESPAN":
          oleDbParameter.OleDbType = OleDbType.DBTime;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) valor;
            break;
          }
          break;
        case "DATETIME":
          oleDbParameter.OleDbType = OleDbType.DBTimeStamp;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToDateTime(valor);
            break;
          }
          break;
        case "OBJECT":
          oleDbParameter.OleDbType = OleDbType.Variant;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) valor;
            break;
          }
          break;
        case "FLOAT":
          oleDbParameter.OleDbType = OleDbType.Single;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) Convert.ToSingle(valor);
            break;
          }
          break;
        default:
          oleDbParameter.OleDbType = OleDbType.Variant;
          if (inout.ToUpper() == "IN" || inout.ToUpper() == "INOUT")
          {
            if (valor == "" || valor == null)
              oleDbParameter.Value = (object) DBNull.Value;
            else
              oleDbParameter.Value = (object) valor;
            break;
          }
          break;
      }
      oleDbParameter.Size = largo;
      return oleDbParameter;
    }

    public string return_String(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return this.sp.Parameters[nombre_parametro].Value.ToString();
    }

    public char return_Char(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToChar(this.sp.Parameters[nombre_parametro].Value);
    }

    public short return_Short(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToInt16(this.sp.Parameters[nombre_parametro].Value);
    }

    public int return_Int(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToInt32(this.sp.Parameters[nombre_parametro].Value);
    }

    public long return_Long(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToInt64(this.sp.Parameters[nombre_parametro].Value);
    }

    public double return_Double(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToDouble(this.sp.Parameters[nombre_parametro].Value);
    }

    public Decimal return_Decimal(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToDecimal(this.sp.Parameters[nombre_parametro].Value);
    }

    public ushort return_UShort(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToUInt16(this.sp.Parameters[nombre_parametro].Value);
    }

    public uint return_UInt(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToUInt32(this.sp.Parameters[nombre_parametro].Value);
    }

    public ulong return_ULong(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToUInt64(this.sp.Parameters[nombre_parametro].Value);
    }

    public bool return_Bool(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToBoolean(this.sp.Parameters[nombre_parametro].Value);
    }

    public DateTime return_Date(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToDateTime(this.sp.Parameters[nombre_parametro].Value);
    }

    public byte return_Byte(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToByte(this.sp.Parameters[nombre_parametro].Value);
    }

    public sbyte return_SByte(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToSByte(this.sp.Parameters[nombre_parametro].Value);
    }

    public float return_Float(string nombre_parametro)
    {
      if (DbnetGlobal.Base_dato == "SQLSERVER")
        nombre_parametro = "@" + nombre_parametro;
      return Convert.ToSingle(this.sp.Parameters[nombre_parametro].Value);
    }
  }
}
