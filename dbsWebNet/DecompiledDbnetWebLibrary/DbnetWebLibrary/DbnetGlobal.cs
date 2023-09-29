// Decompiled with JetBrains decompiler
// Type: DbnetWebLibrary.DbnetGlobal
// Assembly: DbnetWebLibrary, Version=1.0.4846.32991, Culture=neutral, PublicKeyToken=null
// MVID: C0BBA738-7D4D-4EF6-BC01-69A3EC828016
// Assembly location: C:\dbnet\SVN_desarrolloDBAX\dbsWebNet\DBNeT.DBAX.Wss\Bin\DbnetWebLibrary.dll

namespace DbnetWebLibrary
{
  public class DbnetGlobal
  {
    private static string imgBanner50 = (string) null;
    private static string imgLogin50 = (string) null;
    private static string codi_cult = (string) null;
    private static string mensaje = (string) null;
    private static string nomb_serv = (string) null;
    private static string nomb_base = (string) null;
    private static string usua_base_dato = (string) null;
    private static string pass_base_dato = (string) null;
    private static string login_apli = (string) null;
    private static string usua_segu = (string) null;
    private static string pass_segu = (string) null;
    private static string base_dato = "SQLSERVER";
    private static string home = (string) null;
    private static string path = (string) null;
    private static string sys_path = (string) null;

    private DbnetGlobal()
    {
    }

    public static string Base_dato
    {
      get => DbnetGlobal.base_dato;
      set => DbnetGlobal.base_dato = value;
    }

    public static string Nomb_serv
    {
      get => DbnetGlobal.nomb_serv;
      set => DbnetGlobal.nomb_serv = value;
    }

    public static string Nomb_base
    {
      get => DbnetGlobal.nomb_base;
      set => DbnetGlobal.nomb_base = value;
    }

    public static string Login_aplicacion
    {
      get => DbnetGlobal.login_apli;
      set => DbnetGlobal.login_apli = value;
    }

    public static string Usua_base_dato
    {
      get => DbnetGlobal.usua_base_dato;
      set => DbnetGlobal.usua_base_dato = value;
    }

    public static string Pass_base_dato
    {
      get => DbnetGlobal.pass_base_dato;
      set => DbnetGlobal.pass_base_dato = value;
    }

    public static string Usua_segu
    {
      get => DbnetGlobal.usua_segu;
      set => DbnetGlobal.usua_segu = value;
    }

    public static string Pass_segu
    {
      get => DbnetGlobal.pass_segu;
      set => DbnetGlobal.pass_segu = value;
    }

    public static string Sys_path
    {
      set => DbnetGlobal.sys_path = value;
      get => DbnetGlobal.sys_path;
    }

    public static string Path
    {
      set => DbnetGlobal.path = value;
      get => DbnetGlobal.path;
    }

    public static string Home
    {
      set => DbnetGlobal.home = value;
      get => DbnetGlobal.home;
    }

    public static string Mensaje_Error
    {
      set => DbnetGlobal.mensaje = value;
      get => DbnetGlobal.mensaje;
    }

    public static string Codi_cult
    {
      get => DbnetGlobal.codi_cult;
      set => DbnetGlobal.codi_cult = value;
    }

    public static string VimgLogin50
    {
      get => DbnetGlobal.imgLogin50;
      set => DbnetGlobal.imgLogin50 = value;
    }

    public static string VimgBanner50
    {
      get => DbnetGlobal.imgBanner50;
      set => DbnetGlobal.imgBanner50 = value;
    }
  }
}
