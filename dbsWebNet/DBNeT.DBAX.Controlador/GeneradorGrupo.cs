using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Xml.Linq;


public partial class GeneradorGrupo
{
    Conexion con = new Conexion().CrearInstancia();
    ModeloGruposEmpresas grup = new ModeloGruposEmpresas();

    /// <summary>
    /// Inserta Grupo
    /// </summary>
    /// 
    public void GuardarGrupo(string nonmbreGrupo)
    {
        con.TraerResultados0(grup.GuardaGrupo(nonmbreGrupo));

    }

    /// <summary>
    /// Elimina Grupo
    /// </summary>
    /// 
    public void EliminaGrupo(string nonmbreGrupo)
    {
        con.TraerResultados0(grup.Elimina_grilla_grupo(nonmbreGrupo));

    }

    /// <summary>
    /// Guarda Grupo empresa
    /// </summary>
    public void GuardaGrupoEmpresa(string cadena)
    {
        string[] retornaquery = grup.Guarda_grupo_Empresa(cadena);
        foreach (string query in retornaquery)
        {
            con.TraerResultados0(query);
        }

    }

    /// <summary>
    /// verificar si es M o I
    /// </summary>
    public DataSet verificacionIngrenso(string codi_empr, string codi_emex)
    {
      return  con.TraerResultados0(grup.verificaingreso(codi_empr, codi_emex));
     
    }

    /// <summary>
    /// Rescate de valores
    /// </summary>
    public DataSet GetDatosGrupo(string codi_empr, string codi_emex, string codi)
    {
        return con.TraerResultados0(grup.GetDatosGrupo(codi_empr, codi_emex, codi));
    }

    /// <summary>
    /// Elimina Grupo
    /// </summary>
    public void EliminaGrupoEmpresa(string codi_empr, string codi_emex)
    {
        con.TraerResultados0(grup.EliminardatosGupoEmpresa(codi_empr, codi_emex));
    }

    /// <summary>
    /// Verifica existencia de empresa
    /// </summary>
    public string getExisteEmpresa(string codi_pers)
    {
        return con.TraerResultados0(grup.getExisteEmpresa(codi_pers)).Tables[0].Rows[0][0].ToString();
    }

    /// <summary>
    /// Modificación  grupo
    /// </summary>
    public void UpdGrupoEmpresa(string codi_empr, string codi_emex, string desc_grup, string codi_grup)
    {
        con.TraerResultados0(grup.Upd_Grupo_Empresa(codi_empr, codi_emex, desc_grup, codi_grup));
    }

    /// <summary>
    /// Obtiene grupos (segun definicion de victor)
    /// </summary>
    public DataSet getGrupos()
    {
        return con.TraerResultados0(grup.getGrupos());
    }

    /// <summary>
    /// Obtiene Segmentos (segun definicion de victor)
    /// </summary>
    public DataSet getSegmentos()
    {
        return con.TraerResultados0(grup.getSegmentos());
    }

    /// <summary>
    /// Obtiene los tipos de taxonomia
    /// </summary>
    public DataSet getTiposTaxonomia()
    {
        return con.TraerResultados0(grup.getTiposTaxonomia());
    }
}