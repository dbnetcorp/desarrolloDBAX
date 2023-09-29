// Decompiled with JetBrains decompiler
// Type: DbnetWebLibrary.DbnetContextOLD
// Assembly: DbnetWebLibrary, Version=1.0.4846.32991, Culture=neutral, PublicKeyToken=null
// MVID: C0BBA738-7D4D-4EF6-BC01-69A3EC828016
// Assembly location: C:\dbnet\SVN_desarrolloDBAX\dbsWebNet\DBNeT.DBAX.Wss\Bin\DbnetWebLibrary.dll

using System;
using System.Data.OleDb;

namespace DbnetWebLibrary
{
  public class DbnetContextOLD
  {
    private static OleDbConnection _dbConnection = (OleDbConnection) null;
    private static string _dbConnectionString = (string) null;
    private object _lisAux;
    private static int position = 0;
    private static string codi_emex = (string) null;
    private static int codi_empr = 1;
    private static string nomb_empr = (string) null;
    private static string codi_usua = (string) null;
    private static string codi_modu = (string) null;
    private static string codi_rous = (string) null;
    private static Decimal corr_sess = 0M;
    private static string nomb_serv = (string) null;
    private static string nomb_base = (string) null;
    private static string codi_cult = (string) null;
    private static string codi_pers = (string) null;
    private static string codi_ceco = (string) null;
    private static string usua_base_dato = (string) null;
    private static string pass_base_dato = (string) null;
    private static string login_apli = (string) null;
    private static string pass_usua = (string) null;
    private static string usua_segu = (string) null;
    private static string pass_segu = (string) null;
    private static string base_dato = "SQLSERVER";
    private static string clause_where = (string) null;
    private static string path = (string) null;
    private static string frm_modif = (string) null;
    private static string v_home = (string) null;
    private static string v_mensaje = (string) null;
    private static string v_path = (string) null;
    private static string v_key1 = (string) null;
    private static string v_key2 = (string) null;
    private static string v_key3 = (string) null;
    private static string v_key4 = (string) null;
    private static string v_key5 = (string) null;
    private static string v_val1 = (string) null;
    private static string v_val2 = (string) null;
    private static string v_val3 = (string) null;
    private static string v_val4 = (string) null;
    private static string v_val5 = (string) null;

    private DbnetContextOLD()
    {
    }

    public static OleDbConnection dbConnection
    {
      get
      {
        if (DbnetContextOLD._dbConnection == null)
        {
          DbnetContextOLD._dbConnection = new OleDbConnection();
          DbnetContextOLD._dbConnection.ConnectionString = DbnetContextOLD._dbConnectionString;
          DbnetContextOLD._dbConnection.InfoMessage += new OleDbInfoMessageEventHandler(DbnetContextOLD.oleDbConnection_InfoMessage);
          DbnetContextOLD._dbConnection.Open();
          try
          {
            new OleDbCommand().Connection = DbnetContextOLD.dbConnection;
            if (DbnetContextOLD.Base_dato == "SQLSERVER" && DbnetContextOLD.Corr_sess != 0M && DbnetContextOLD.Usua_base_dato != null)
            {
              OleDbCommand oleDbCommand = new OleDbCommand("", DbnetContextOLD.dbConnection);
              string str = "INSERT INTO SYS_CONNECTION (CORR_CONN, CODI_USEX, CODI_USUA, CORR_SESS, FEIN_CONN) VALUES (@@SPID,SYSTEM_USER,USER,'" + (object) DbnetContextOLD.Corr_sess + "',GETDATE())";
              oleDbCommand.CommandText = str;
              oleDbCommand.ExecuteNonQuery();
            }
            else if (!(DbnetContextOLD.Base_dato == "ORACLE") || !(DbnetContextOLD.Corr_sess != 0M) || DbnetContextOLD.Usua_base_dato == null)
              ;
          }
          catch (OleDbException ex)
          {
            DbnetContextOLD.Mensaje_Error = ex.Message.ToString();
          }
          catch (Exception ex)
          {
            DbnetContextOLD.Mensaje_Error = "Ha ocurrido un error accesando la base de datos: " + ex.Message.ToString();
          }
        }
        return DbnetContextOLD._dbConnection;
      }
    }

    public static void closeConnection()
    {
      if (DbnetContextOLD._dbConnection == null)
        return;
      if (DbnetContextOLD.Base_dato == "SQLSERVER" && DbnetContextOLD.Corr_sess != 0M)
      {
        OleDbCommand oleDbCommand = new OleDbCommand("", DbnetContextOLD.dbConnection);
        oleDbCommand.CommandText = " DELETE FROM sys_connection    ";
        oleDbCommand.CommandText += " WHERE corr_conn = @@SPID      ";
        oleDbCommand.CommandText += " and   codi_usex = SYSTEM_USER ";
        oleDbCommand.CommandText += " and   codi_usua = USER        ";
        oleDbCommand.ExecuteNonQuery();
      }
      else if (!(DbnetContextOLD.Base_dato == "ORACLE") || !(DbnetContextOLD.Corr_sess != 0M))
        ;
      DbnetContextOLD._dbConnection.Close();
      DbnetContextOLD._dbConnection = (OleDbConnection) null;
    }

    public static string dbConnectionString
    {
      get => DbnetContextOLD._dbConnectionString;
      set => DbnetContextOLD._dbConnectionString = value;
    }

    private static void oleDbConnection_InfoMessage(object sender, OleDbInfoMessageEventArgs e)
    {
    }

    public static string Codi_emex
    {
      get => DbnetContextOLD.codi_emex;
      set => DbnetContextOLD.codi_emex = value;
    }

    public object GetLis
    {
      get => this._lisAux;
      set => this._lisAux = value;
    }

    public static string Codi_cult
    {
      get => DbnetContextOLD.codi_cult;
      set => DbnetContextOLD.codi_cult = value;
    }

    public static string Codi_usua
    {
      get => DbnetContextOLD.codi_usua;
      set => DbnetContextOLD.codi_usua = value;
    }

    public static int Codi_empr
    {
      get => DbnetContextOLD.codi_empr;
      set => DbnetContextOLD.codi_empr = value;
    }

    public static string Codi_modu
    {
      get => DbnetContextOLD.codi_modu;
      set => DbnetContextOLD.codi_modu = value;
    }

    public static string Codi_pers
    {
      get => DbnetContextOLD.codi_pers;
      set => DbnetContextOLD.codi_pers = value;
    }

    public static string Codi_ceco
    {
      get => DbnetContextOLD.codi_ceco;
      set => DbnetContextOLD.codi_ceco = value;
    }

    public static string Base_dato
    {
      get => DbnetContextOLD.base_dato;
      set => DbnetContextOLD.base_dato = value;
    }

    public static string Codi_rous
    {
      get => DbnetContextOLD.codi_rous;
      set => DbnetContextOLD.codi_rous = value;
    }

    public static Decimal Corr_sess
    {
      get => DbnetContextOLD.corr_sess;
      set => DbnetContextOLD.corr_sess = value;
    }

    public static string Nomb_serv
    {
      get => DbnetContextOLD.nomb_serv;
      set => DbnetContextOLD.nomb_serv = value;
    }

    public static string Nomb_base
    {
      get => DbnetContextOLD.nomb_base;
      set => DbnetContextOLD.nomb_base = value;
    }

    public static string Login_aplicacion
    {
      get => DbnetContextOLD.login_apli;
      set => DbnetContextOLD.login_apli = value;
    }

    public static string Usua_base_dato
    {
      get => DbnetContextOLD.usua_base_dato;
      set => DbnetContextOLD.usua_base_dato = value;
    }

    public static string Pass_base_dato
    {
      get => DbnetContextOLD.pass_base_dato;
      set => DbnetContextOLD.pass_base_dato = value;
    }

    public static string Usua_segu
    {
      get => DbnetContextOLD.usua_segu;
      set => DbnetContextOLD.usua_segu = value;
    }

    public static string Pass_segu
    {
      get => DbnetContextOLD.pass_segu;
      set => DbnetContextOLD.pass_segu = value;
    }

    public static string Pass_usua
    {
      get => DbnetContextOLD.pass_usua;
      set => DbnetContextOLD.pass_usua = value;
    }

    public static string Nomb_Empr
    {
      get => DbnetContextOLD.nomb_empr;
      set => DbnetContextOLD.nomb_empr = value;
    }

    public static string Clause_Where
    {
      get => DbnetContextOLD.clause_where;
      set => DbnetContextOLD.clause_where = value;
    }

    public static int Position
    {
      set => DbnetContextOLD.position = value;
      get => DbnetContextOLD.position;
    }

    public static string Path
    {
      set => DbnetContextOLD.path = value;
      get => DbnetContextOLD.path;
    }

    public static string Modo_Consulta
    {
      set => DbnetContextOLD.frm_modif = value;
      get => DbnetContextOLD.frm_modif;
    }

    public static string Home
    {
      set => DbnetContextOLD.v_home = value;
      get => DbnetContextOLD.v_home;
    }

    public static string Mensaje_Error
    {
      set => DbnetContextOLD.v_mensaje = value;
      get => DbnetContextOLD.v_mensaje;
    }

    public static string Sys_path
    {
      set => DbnetContextOLD.v_path = value;
      get => DbnetContextOLD.v_path;
    }

    public static string Key1
    {
      set => DbnetContextOLD.v_key1 = value;
      get => DbnetContextOLD.v_key1;
    }

    public static string Key2
    {
      set => DbnetContextOLD.v_key2 = value;
      get => DbnetContextOLD.v_key2;
    }

    public static string Key3
    {
      set => DbnetContextOLD.v_key3 = value;
      get => DbnetContextOLD.v_key3;
    }

    public static string Key4
    {
      set => DbnetContextOLD.v_key4 = value;
      get => DbnetContextOLD.v_key4;
    }

    public static string Key5
    {
      set => DbnetContextOLD.v_key5 = value;
      get => DbnetContextOLD.v_key5;
    }

    public static string Val1
    {
      set => DbnetContextOLD.v_val1 = value;
      get => DbnetContextOLD.v_val1;
    }

    public static string Val2
    {
      set => DbnetContextOLD.v_val2 = value;
      get => DbnetContextOLD.v_val2;
    }

    public static string Val3
    {
      set => DbnetContextOLD.v_val3 = value;
      get => DbnetContextOLD.v_val3;
    }

    public static string Val4
    {
      set => DbnetContextOLD.v_val4 = value;
      get => DbnetContextOLD.v_val4;
    }

    public static string Val5
    {
      set => DbnetContextOLD.v_val5 = value;
      get => DbnetContextOLD.v_val5;
    }
  }
}
