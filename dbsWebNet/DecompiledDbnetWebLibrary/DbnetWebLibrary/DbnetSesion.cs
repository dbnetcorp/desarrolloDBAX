// Decompiled with JetBrains decompiler
// Type: DbnetWebLibrary.DbnetSesion
// Assembly: DbnetWebLibrary, Version=1.0.4846.32991, Culture=neutral, PublicKeyToken=null
// MVID: C0BBA738-7D4D-4EF6-BC01-69A3EC828016
// Assembly location: C:\dbnet\SVN_desarrolloDBAX\dbsWebNet\DBNeT.DBAX.Wss\Bin\DbnetWebLibrary.dll

using System;
using System.Data;
using System.Data.OleDb;

namespace DbnetWebLibrary
{
  public class DbnetSesion
  {
    private OleDbConnection _dbConnection = (OleDbConnection) null;
    private string _dbConnectionString = (string) null;
    private int position = 0;
    private string codi_emex = (string) null;
    private int codi_empr = 1;
    private string nomb_empr = (string) null;
    private string codi_usua = (string) null;
    private string codi_modu = (string) null;
    private string codi_rous = (string) null;
    private Decimal corr_sess = 0M;
    private string codi_pers = (string) null;
    private string codi_ceco = (string) null;
    private string pass_usua = (string) null;
    private string clause_where = (string) null;
    private string frm_modif = (string) null;
    private string v_key1 = "";
    private string v_key2 = "";
    private string v_key3 = "";
    private string v_key4 = "";
    private string v_key5 = "";
    private string v_val1 = "";
    private string v_val2 = "";
    private string v_val3 = "";
    private string v_val4 = "";
    private string v_val5 = "";
    private string v_val6 = "";
    private string v_val7 = "";
    private bool parametroVolver = false;
    private bool volver = false;
    private bool v_popup = false;
    private object _lisAux;
    private DataTable _dtSelect = (DataTable) null;
    private DataTable _dtSelectInicial = (DataTable) null;
    private DataTable _dtGrilla = (DataTable) null;
    private int _nroPagina = 0;
    private int _totPagina = 0;
    private int _totRegistro = 0;
    private int _opBusqueda = 0;
    private string _TipoMonitor = "DTE";
    private int _regpag = 0;
    private string auxdbo = "";
    private string auxcon = "||";
    private string auxsql = "";
    private string auxstr = "to_char";
    private string auxvolver;
    private string notificaVigencia;

    public DbnetSesion()
    {
      this.auxvolver = string.Empty;
      this.notificaVigencia = string.Empty;
      this._dbConnection = new OleDbConnection();
    }

    public OleDbConnection dbConnection
    {
      get
      {
        if (this._dbConnection == null)
          this.openConnection();
        return this._dbConnection;
      }
    }

    public void openConnection() => this.openConnection(this._dbConnectionString);

    public void openConnection(string str)
    {
      this._dbConnection.ConnectionString = str;
      if (this._dbConnection != null)
      {
        this._dbConnection.Close();
        this._dbConnection.Open();
      }
      else
      {
        this._dbConnection = new OleDbConnection();
        this._dbConnection.ConnectionString = str;
        this._dbConnection.Open();
      }
      this._dbConnectionString = str;
      if (!(DbnetGlobal.Base_dato == "SQLSERVER"))
        return;
      OleDbCommand oleDbCommand = new OleDbCommand();
      oleDbCommand.Connection = this._dbConnection;
      oleDbCommand.CommandText = " DELETE FROM SYS_SESSION                      WHERE EXISTS (SELECT 1                                       FROM SYS_CONNECTION C           \t\t\t\t  WHERE C.CORR_SESS = SYS_SESSION.CORR_SESS \t\t\t\t  AND   C.CORR_CONN = @@SPID)     ";
      oleDbCommand.ExecuteNonQuery();
    }

    public void closeConnection()
    {
      if (this._dbConnection == null)
        return;
      if (DbnetGlobal.Base_dato == "SQLSERVER")
      {
        OleDbCommand oleDbCommand = new OleDbCommand();
        oleDbCommand.Connection = this._dbConnection;
        oleDbCommand.CommandText = " DELETE FROM SYS_SESSION\t\t\t\t\t   WHERE EXISTS (SELECT 1                                       FROM SYS_CONNECTION C           \t\t\t\t  WHERE C.CORR_SESS = SYS_SESSION.CORR_SESS \t\t\t\t  AND   C.CORR_CONN = @@SPID)     ";
        oleDbCommand.ExecuteNonQuery();
      }
      this._dbConnection.Close();
      this._dbConnection = (OleDbConnection) null;
    }

    public string dbConnectionString
    {
      get => this._dbConnectionString;
      set => this._dbConnectionString = value;
    }

    public string Codi_emex
    {
      get => this.codi_emex;
      set => this.codi_emex = value;
    }

    public object GetLis
    {
      get => this._lisAux;
      set => this._lisAux = value;
    }

    public string Codi_usua
    {
      get => this.codi_usua;
      set => this.codi_usua = value;
    }

    public int Codi_empr
    {
      get => this.codi_empr;
      set => this.codi_empr = value;
    }

    public string Codi_modu
    {
      get => this.codi_modu;
      set => this.codi_modu = value;
    }

    public string Codi_pers
    {
      get => this.codi_pers;
      set => this.codi_pers = value;
    }

    public string Codi_ceco
    {
      get => this.codi_ceco;
      set => this.codi_ceco = value;
    }

    public string Codi_rous
    {
      get => this.codi_rous;
      set => this.codi_rous = value;
    }

    public Decimal Corr_sess
    {
      get => this.corr_sess;
      set => this.corr_sess = value;
    }

    public string Pass_usua
    {
      get => this.pass_usua;
      set => this.pass_usua = value;
    }

    public string Nomb_Empr
    {
      get => this.nomb_empr;
      set => this.nomb_empr = value;
    }

    public string Clause_Where
    {
      get => this.clause_where;
      set => this.clause_where = value;
    }

    public int Position
    {
      set => this.position = value;
      get => this.position;
    }

    public bool PopUp
    {
      set => this.v_popup = value;
      get => this.v_popup;
    }

    public string Modo_Consulta
    {
      set => this.frm_modif = value;
      get => this.frm_modif;
    }

    public string Key1
    {
      set => this.v_key1 = value;
      get => this.v_key1;
    }

    public string Key2
    {
      set => this.v_key2 = value;
      get => this.v_key2;
    }

    public string Key3
    {
      set => this.v_key3 = value;
      get => this.v_key3;
    }

    public string Key4
    {
      set => this.v_key4 = value;
      get => this.v_key4;
    }

    public string Key5
    {
      set => this.v_key5 = value;
      get => this.v_key5;
    }

    public string Val1
    {
      set => this.v_val1 = value;
      get => this.v_val1;
    }

    public string Val2
    {
      set => this.v_val2 = value;
      get => this.v_val2;
    }

    public string Val3
    {
      set => this.v_val3 = value;
      get => this.v_val3;
    }

    public string Val4
    {
      set => this.v_val4 = value;
      get => this.v_val4;
    }

    public string Val5
    {
      set => this.v_val5 = value;
      get => this.v_val5;
    }

    public string Val6
    {
      set => this.v_val6 = value;
      get => this.v_val6;
    }

    public string Val7
    {
      set => this.v_val7 = value;
      get => this.v_val7;
    }

    public string Auxdbo
    {
      set => this.auxdbo = value;
      get => this.auxdbo;
    }

    public string Auxcon
    {
      set => this.auxcon = value;
      get => this.auxcon;
    }

    public string AuxSql
    {
      set => this.auxsql = value;
      get => this.auxsql;
    }

    public string AuxVolver
    {
      set => this.auxvolver = value;
      get => this.auxvolver;
    }

    public bool Volver
    {
      set => this.volver = value;
      get => this.volver;
    }

    public bool ParametroVolver
    {
      set => this.parametroVolver = value;
      get => this.parametroVolver;
    }

    public string NotificaVigencia
    {
      set => this.notificaVigencia = value;
      get => this.notificaVigencia;
    }

    public string AuxStr
    {
      set => this.auxstr = value;
      get => this.auxstr;
    }

    public string AuxDate(string fecha) => DbnetGlobal.Base_dato == "SQLSERVER" ? "Convert(datetime,'" + fecha + "',102)" : "to_date('" + fecha + "','yyyy-mm-dd')";

    public DataTable dtSelect
    {
      set => this._dtSelect = value;
      get => this._dtSelect;
    }

    public DataTable dtGrilla
    {
      set => this._dtGrilla = value;
      get => this._dtGrilla;
    }

    public DataTable dtSelectInicial
    {
      set => this._dtSelectInicial = value;
      get => this._dtSelectInicial;
    }

    public int nroPagina
    {
      set => this._nroPagina = value;
      get => this._nroPagina;
    }

    public int totPagina
    {
      set => this._totPagina = value;
      get => this._totPagina;
    }

    public int totRegistro
    {
      set => this._totRegistro = value;
      get => this._totRegistro;
    }

    public int opBusqueda
    {
      set => this._opBusqueda = value;
      get => this._opBusqueda;
    }

    public string TipoMonitor
    {
      set => this._TipoMonitor = value;
      get => this._TipoMonitor;
    }

    public int regpag
    {
      set => this._regpag = value;
      get => this._regpag;
    }
  }
}
