using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.IO;
using System.Data;
using System.Web;
using System.Diagnostics;

public partial class ModeloExpoData
{
    Conexion con = new Conexion().CrearInstancia();
    //ModeloGruposEmpresas grup = new ModeloGruposEmpresas();

    /// <summary>
    /// Obtiene los tipos de empresas (taxonomías)
    /// </summary>
    public DataSet getTiposEmpresa()
    {
        String sql;
        sql = "SELECT tipo_taxo, desc_tipo FROM dbax_tipo_taxo";

        return con.TraerResultados0(sql);
    }

    /// <summary>
    /// Obtiene las empresas filtrando por tipo de empresa(taxonomías) y por segmento
    /// </summary>
    public DataSet getEmpresas(String tipo, String segm) 
    {
        String sql;
        sql = "SELECT codi_pers, desc_pers FROM dbax_defi_pers dp "+
               "WHERE dp.tipo_taxo = '" + tipo + "' AND dp.codi_segm = '" + segm + "' order by desc_pers";

        Console.Write(sql);

        return con.TraerResultados0(sql);
    }

    /// <summary>
    /// Obtiene los segmentos filtrando por tipo de empresa(taxonomías)
    /// </summary>
    public DataSet getSegmentos(String tipo)
    {
        String sql;
        sql = "SELECT s.codi_segm, s.desc_segm FROM dbax_defi_segm s " +
               "WHERE EXISTS"+
               "(SELECT 1 FROM dbax_defi_pers dp WHERE dp.tipo_taxo = '" + tipo + "' AND dp.codi_segm = s.codi_segm)";

        return con.TraerResultados0(sql); 
    }

    /// <summary>
    /// Obtiene los periodos filtrando por tipo de empresa(taxonomías) y segmento
    /// </summary>
    public DataSet getPeriodos(String tipo, String segm)
    {
        String sql;
        sql = "SELECT DISTINCT corr_inst FROM dbax_inst_docu " +
               "WHERE EXISTS" +
               "(SELECT 1 FROM dbax_defi_pers dp WHERE dp.tipo_taxo = '" + tipo + "' AND dp.codi_segm = '"+segm+"') " +
               "ORDER BY 1 DESC";

        return con.TraerResultados0(sql);
    }

    /// <summary>
    /// Obtiene los informes filtrando por tipo de empresa(taxonomías), empresa y por segmento
    /// </summary>
    public DataSet getInformes(String tipo, String segm, List<string> per, String tipoFiltro)
    {
        String Periodos  = string.Join(",", per);
        
        String sql;
        sql = "SELECT distinct di.codi_info, di.desc_info " +
              "FROM dbax_desc_info di " +
              "WHERE di.codi_lang = 'es_ES' " +
              "AND EXISTS (SELECT 1 FROM dbax_info_tita it WHERE it.tipo_taxo = '" + tipo + "' AND it.codi_info = di.codi_info)";

        if (tipoFiltro.Equals("IP"))
        {
            sql += "AND EXISTS (SELECT 1 FROM dbax_inst_info ii WHERE ii.codi_info = di.codi_info " +
                   "AND ii.corr_inst IN (" + Periodos + ") AND EXISTS (SELECT * FROM dbax_defi_pers dp WHERE dp.codi_segm = '" + segm + "' " +
                   "AND dp.codi_pers = ii.codi_pers )) ";
        }

        sql += "ORDER BY di.desc_info";

        return con.TraerResultados0(sql);
    }

    /// <summary>
    /// Vemos si existe un proceso en ejecución y lo extramos
    /// </summary>
    public DataSet getEstadoProceso(String usuario)
    {
        String sql;
        sql = "SELECT TOP 1 desc_proc, corr_proc " +
              "FROM dbax_proc_even " +
              "WHERE codi_usua = '"+usuario+"' AND desc_proc LIKE '<!--expoData%' ORDER BY corr_proc DESC";

        return con.TraerResultados0(sql);
    }

    /// <summary>
    /// Creamos un proceso
    /// </summary>
    public DataSet crearProceso(String codi_usua, String fecha)
    {
        String sql;
        sql = "DECLARE @IDs TABLE(corr_proc numeric(10,0)); " +
              "INSERT dbax_proc_even([codi_usua],[desc_proc],[fech_even],[borr_mens])" +
              "OUTPUT inserted.corr_proc INTO @IDs(corr_proc)" +
              "VALUES" +
              "('" + codi_usua + "','<!--expoData--><label CssClass=\"lblIzquierdo\"><img src=\"../librerias/img/amarillo.png\" />Proceso de descarga de archivos en curso. </label>'," +
              "'" + "" + "'" + ",0);" +
              "SELECT corr_proc FROM @IDs";

        return con.TraerResultados0(sql);
    }

    /// <summary>
    /// Actualizamos el proceso en rojo en caso de emergencia
    /// </summary>
    public void actualizarProcesoRojo(String corr_proc, String fecha)
    {
        string sql = "UPDATE [dbax].[dbo].[dbax_proc_even]" +
                     "SET [desc_proc] = '<!--expoData--><label CssClass=\"lblIzquierdo\"><img src=\"../librerias/img/rojo.png\" />Proceso concluido cierre inesperado de la aplicación (No manejado).</label>' ,[fech_even] = '" + "" + "', [borr_mens] = '1'" +
                     "WHERE corr_proc = '" + corr_proc + "'";

        con.EjecutarQuery(sql);
    }

}
