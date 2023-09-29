using System;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;

    public partial class Conexion
    {
        static private Conexion conectar = null;
        public SqlConnection con;


        public static Conexion CrearInstancia()
        {
            if(conectar == null)
                conectar = new Conexion();

            return conectar;
        }

        public void declararConexion()
        {
            con = new SqlConnection("Data Source=VM-GXXBRL;Initial Catalog=dbax;Persist Security Info=True;User ID=dbax;Password=dbax");
            con.Open();
        }
        
        public void AbrirConexion() { }
        public void CerrarConexion() { }
        public DataSet TraerResultados0(string query)
        {
            declararConexion();
            SqlDataAdapter ada = new SqlDataAdapter(query, con);
            DataSet ds = new DataSet();
            ada.Fill(ds);
            con.Close();

            return ds;
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

        public void EjecutarQuery(string query)
        {
            declararConexion();
            SqlCommand com = new SqlCommand(query, con);
            com.ExecuteNonQuery();
        }

        public void insDetalleIndicador(string letr_vari, string pref_conc, string codi_conc)
        {
            declararConexion();
        }
    }

