using System;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Xml;
using System.IO;
using DbnetWebLibrary;


public partial class Conexion 
{
    private Conexion conectar = null;
    public SqlConnection con;

    public Conexion CrearInstancia()
    {
        if (conectar == null)
        { conectar = new Conexion(); }
        return conectar;
    }

    public void declararConexion()
    {
        try
        {
            XmlDocument xmldoc = new XmlDocument();
            string baseDir = System.Web.HttpRuntime.AppDomainAppPath;
            string configPath = Path.Combine(baseDir, "setting.config");
            xmldoc.Load(configPath);

            XmlNode server = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataServer" + "']");
            XmlNode serverAttribute = server.Attributes.GetNamedItem("value");
            string DataServer = serverAttribute.Value.ToString();

            XmlNode bd = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataBase" + "']");
            XmlNode bdAttribute = bd.Attributes.GetNamedItem("value");
            string DataBase = bdAttribute.Value.ToString();

            XmlNode Us = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "User" + "']");
            XmlNode USAttribute = Us.Attributes.GetNamedItem("value");
            string User = USAttribute.Value.ToString();

            XmlNode pass = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "Password" + "']");
            XmlNode passAttribute = pass.Attributes.GetNamedItem("value");
            string Password = passAttribute.Value.ToString();
            string descPassword = DbnetSecurity.dese_vari(Password);

            con = new SqlConnection("Data Source=" + DataServer + ";Initial Catalog=" + DataBase + ";Persist Security Info=True;User ID=" + User + ";Password=" + descPassword + "");
            con.Open();
        }
        catch
        {

            XmlDocument xmldoc = new XmlDocument();
            string baseDir = Environment.ExpandEnvironmentVariables("%ProgramFiles%");
            string configPath = Path.Combine(baseDir, "DBNeTSrvSetting\\setting.config");
            xmldoc.Load(configPath);

            XmlNode server = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataServer" + "']");
            XmlNode serverAttribute = server.Attributes.GetNamedItem("value");
            string DataServer = serverAttribute.Value.ToString();

            XmlNode bd = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataBase" + "']");
            XmlNode bdAttribute = bd.Attributes.GetNamedItem("value");
            string DataBase = bdAttribute.Value.ToString();

            XmlNode Us = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "User" + "']");
            XmlNode USAttribute = Us.Attributes.GetNamedItem("value");
            string User = USAttribute.Value.ToString();

            XmlNode pass = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "Password" + "']");
            XmlNode passAttribute = pass.Attributes.GetNamedItem("value");
            string Password = passAttribute.Value.ToString();
            string descPassword = DbnetSecurity.dese_vari(Password);

            con = new SqlConnection("Data Source=" + DataServer + ";Initial Catalog=" + DataBase + ";Persist Security Info=True;User ID=" + User + ";Password=" + descPassword + "");
            con.Open();
        }

    }
    public void declararConexionBI()
    {
        try
        {
            XmlDocument xmldoc = new XmlDocument();
            string baseDir = System.Web.HttpRuntime.AppDomainAppPath;
            string configPath = Path.Combine(baseDir, "settingBI.config");
            xmldoc.Load(configPath);

            XmlNode server = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataServer" + "']");
            XmlNode serverAttribute = server.Attributes.GetNamedItem("value");
            string DataServer = serverAttribute.Value.ToString();

            XmlNode bd = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataBase" + "']");
            XmlNode bdAttribute = bd.Attributes.GetNamedItem("value");
            string DataBase = bdAttribute.Value.ToString();

            XmlNode Us = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "User" + "']");
            XmlNode USAttribute = Us.Attributes.GetNamedItem("value");
            string User = USAttribute.Value.ToString();

            XmlNode pass = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "Password" + "']");
            XmlNode passAttribute = pass.Attributes.GetNamedItem("value");
            string Password = passAttribute.Value.ToString();
            string descPassword = DbnetSecurity.dese_vari(Password);

            con = new SqlConnection("Data Source=" + DataServer + ";Initial Catalog=" + DataBase + ";Persist Security Info=True;User ID=" + User + ";Password=" + descPassword + "");
            con.Open();
        }
        catch
        {

            XmlDocument xmldoc = new XmlDocument();
            string baseDir = Environment.ExpandEnvironmentVariables("%ProgramFiles%");
            string configPath = Path.Combine(baseDir, "DBNeTSrvSetting\\settingBI.config");
            xmldoc.Load(configPath);

            XmlNode server = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataServer" + "']");
            XmlNode serverAttribute = server.Attributes.GetNamedItem("value");
            string DataServer = serverAttribute.Value.ToString();

            XmlNode bd = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataBase" + "']");
            XmlNode bdAttribute = bd.Attributes.GetNamedItem("value");
            string DataBase = bdAttribute.Value.ToString();

            XmlNode Us = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "User" + "']");
            XmlNode USAttribute = Us.Attributes.GetNamedItem("value");
            string User = USAttribute.Value.ToString();

            XmlNode pass = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "Password" + "']");
            XmlNode passAttribute = pass.Attributes.GetNamedItem("value");
            string Password = passAttribute.Value.ToString();
            string descPassword = DbnetSecurity.dese_vari(Password);

            con = new SqlConnection("Data Source=" + DataServer + ";Initial Catalog=" + DataBase + ";Persist Security Info=True;User ID=" + User + ";Password=" + descPassword + "");
            con.Open();
        }

    }
    public void declararConexionCentral()
    {
        try
        {
            XmlDocument xmldoc = new XmlDocument();
            string baseDir = System.Web.HttpRuntime.AppDomainAppPath;
            string configPath = Path.Combine(baseDir, "settingCentral.config");
            xmldoc.Load(configPath);

            XmlNode server = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataServer" + "']");
            XmlNode serverAttribute = server.Attributes.GetNamedItem("value");
            string DataServer = serverAttribute.Value.ToString();

            XmlNode bd = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataBase" + "']");
            XmlNode bdAttribute = bd.Attributes.GetNamedItem("value");
            string DataBase = bdAttribute.Value.ToString();

            XmlNode Us = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "User" + "']");
            XmlNode USAttribute = Us.Attributes.GetNamedItem("value");
            string User = USAttribute.Value.ToString();

            XmlNode pass = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "Password" + "']");
            XmlNode passAttribute = pass.Attributes.GetNamedItem("value");
            string Password = passAttribute.Value.ToString();
            string descPassword = DbnetSecurity.dese_vari(Password);

            con = new SqlConnection("Data Source=" + DataServer + ";Initial Catalog=" + DataBase + ";Persist Security Info=True;User ID=" + User + ";Password=" + descPassword + "");
            con.Open();
        }
        catch
        {

            XmlDocument xmldoc = new XmlDocument();
            string baseDir = Environment.ExpandEnvironmentVariables("%ProgramFiles%");
            string configPath = Path.Combine(baseDir, "DBNeTSrvSetting\\settingCentral.config");
            xmldoc.Load(configPath);

            XmlNode server = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataServer" + "']");
            XmlNode serverAttribute = server.Attributes.GetNamedItem("value");
            string DataServer = serverAttribute.Value.ToString();

            XmlNode bd = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "DataBase" + "']");
            XmlNode bdAttribute = bd.Attributes.GetNamedItem("value");
            string DataBase = bdAttribute.Value.ToString();

            XmlNode Us = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "User" + "']");
            XmlNode USAttribute = Us.Attributes.GetNamedItem("value");
            string User = USAttribute.Value.ToString();

            XmlNode pass = xmldoc.SelectSingleNode("appSettings/add[@key = '" + "Password" + "']");
            XmlNode passAttribute = pass.Attributes.GetNamedItem("value");
            string Password = passAttribute.Value.ToString();
            string descPassword = DbnetSecurity.dese_vari(Password);

            con = new SqlConnection("Data Source=" + DataServer + ";Initial Catalog=" + DataBase + ";Persist Security Info=True;User ID=" + User + ";Password=" + descPassword + "");
            con.Open();
        }

    }
    public void AbrirConexion() { }
    public void CerrarConexion() { }
    public DataSet TraerResultados0(string query)
    {
        declararConexion();
        SqlDataAdapter ada = new SqlDataAdapter(query, con);
        ada.SelectCommand.CommandTimeout = 280000;
        DataSet ds = new DataSet();
        ada.Fill(ds);
        con.Close();

        return ds;
    }
    public DataTable TraerResultadosT0(string query)
    {
        try
        {
            declararConexion();
            SqlDataAdapter ada = new SqlDataAdapter(query, con);
            DataTable ds = new DataTable();
            ada.Fill(ds);
            con.Close();

            return ds;
        }
        catch(SqlException ex)
        {
            if (ex.Number == -2)
                throw new Exception("Tiempo de espera agotado");
            else
            {
                Log.putLog(ex.Message);
                Log.putLog(ex.StackTrace.ToString());
                //TODO: COMENTAR O QUITAR
                Log.putLog(query);
                throw new Exception("Code: -2. Ocurrio un error de base de datos. Codigo " + ex.Number + "en método TraerResultadosT0");
            }
        }
    }
    public DataSet TraerResultados1(string query, string par1)
    {
        declararConexion();
        SqlDataAdapter ada = new SqlDataAdapter(query + " '" + par1 + "'", con);
        DataSet ds = new DataSet();
        ada.Fill(ds);
        con.Close();

        return ds;
    }
    public DataSet TraerResultados2(string query, string par1, string par2)
    {
        declararConexion();
        SqlDataAdapter ada = new SqlDataAdapter(query + " '" + par1 + "','" + par2 + "'", con);
        DataSet ds = new DataSet();
        ada.Fill(ds);
        con.Close();

        return ds;
    }
    public string StringEjecutarQuery(string query)
    {
        try
        { 
            declararConexion();
            SqlDataAdapter ada = new SqlDataAdapter(query, con);
            DataSet ds = new DataSet();
            ada.Fill(ds);
            con.Close();
            return ds.Tables[0].Rows[0][0].ToString();
        }
        catch(Exception ex)
        {
            string vRetorno = string.Empty;
            return vRetorno;
        }
    }
    public void EjecutarQuery(string query)
    {
        try
        {
            declararConexion();
            SqlCommand com = new SqlCommand(query, con);
            com.CommandTimeout = 280000;
            com.ExecuteNonQuery();
            con.Close();
        }
        catch(SqlException ex)
        {
            if (ex.Number == 2627)
                throw new Exception("Ocurrió un error insertando el registro. Ya existe un registro con el mismo identificador en la base de datos.");
            else
            {
                Log.putLog(ex.Message);
                Log.putLog(ex.StackTrace.ToString());
                throw new Exception("Ocurrio un error de base de datos. Codigo " + ex.Number + "en método EjecutarQuery");
            }
        }
        con.Close();
    }
    public void EjecutarQueryBI(string query)
    {
        try
        {
            declararConexionBI();
            SqlCommand com = new SqlCommand(query, con);
            com.CommandTimeout = 280000;
            com.ExecuteNonQuery();
            con.Close();
        }
        catch (SqlException ex)
        {
            if (ex.Number == 2627)
                throw new Exception("Ocurrió un error insertando el registro. Ya existe un registro con el mismo identificador en la base de datos.");
            else
            {
                Log.putLog(ex.Message);
                Log.putLog(ex.StackTrace.ToString());
                throw new Exception("Ocurrio un error de base de datos. Codigo " + ex.Number + "en método EjecutarQueryBI");
            }
        }
        con.Close();
    }
    public void EjecutarQueryCentral(string query)
    {
        try
        {
            declararConexionCentral();
            SqlCommand com = new SqlCommand(query, con);
            com.CommandTimeout = 280000;
            com.ExecuteNonQuery();
            con.Close();
        }
        catch (SqlException ex)
        {
            if (ex.Number == 2627)
            {
                Log.putLog("Ya existía el registro");
                throw new Exception("Ocurrió un error insertando el registro. Ya existe un registro con el mismo identificador en la base de datos.");
            }
            else
            {
                Log.putLog(ex.Message);
                Log.putLog(ex.StackTrace.ToString());
                throw new Exception("Ocurrio un error de base de datos. Codigo " + ex.Number + "en método EjecutarQueryBI");
            }
        }
        con.Close();
    }
    public void insDetalleIndicador(string letr_vari, string pref_conc, string codi_conc)
    {
        declararConexion();
    }
}