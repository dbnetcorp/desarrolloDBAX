using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Xml.Linq;

public partial class GeneraCntx
{
    Conexion con = Conexion.CrearInstancia();
    Genera_cntx cntx = new Genera_cntx();

    /// <summary>
    /// Guardar Contextos
    /// </summary>
    /// 
    public void GuardarCntx(string nombrecntx, string fini_cntx, string ffin_cntx, string codi_empr)
    {
        con.TraerResultados0(cntx.Guarda_contextos(nombrecntx, fini_cntx, ffin_cntx, codi_empr));

    }
    /// <summary>
    /// LLenado de  grilla contextos
    /// </summary>
    /// 
    public DataSet llenado_grilla_cntx()
    {
       return con.TraerResultados0(cntx.LLenado_grilla());
    }
    /// <summary>
    /// Eliminar cntx
    /// </summary>
    /// 
    public void Eliminar_cntx(string nombre_cntx, string codi_empr)
    {
         con.TraerResultados0(cntx.Eliminar_cntx(nombre_cntx, codi_empr));
    }
    /// <summary>
    /// LLenado de  grilla Informe
    /// </summary>
    /// 
    public DataSet llenado_grilla_Informe()
    {
        return con.TraerResultados0(cntx.LLenado_Informe());
    }
    /// <summary>
    /// LLenado de  grilla Contextos
    /// </summary>
    /// 
    public DataSet llenado_grilla_Contextos()
    {
        return con.TraerResultados0(cntx.LLenado_Contexto());
    }
    /// <summary>
    /// Insertar informes  y contextos
    /// </summary>
    /// 
    public void GuardarInfoCntx(string Informe, string contexto, string orden, string codi_empr)
    {
        con.TraerResultados0(cntx.Guarda_Info_cntx(Informe, contexto, orden, codi_empr));

    }
    /// <summary>
    /// datos para grilla informe contexto
    /// </summary>
    /// 
    public DataSet llenado_grilla_cntx_informe(string informe)
    {
        return con.TraerResultados0(cntx.LLenado_grilla_informe_contexto(informe));
    }
    /// <summary>
    /// Eliminar info_cntx
    /// </summary>
    /// 
    public void Eliminar_Info_cntx(string Codi_info_cntx, string codi_Empr)
    {
        con.TraerResultados0(cntx.Eliminar_Info_cntx(Codi_info_cntx, codi_Empr));
    }
    /// <summary>
    /// Modificar grilla informe contexto
    /// </summary>
    /// 
    public void Modificar_grilla_cntx_informe(string codi_info_cntx, string codi_Empr, string orden)
    {
       con.TraerResultados0(cntx.Modificar_grilla_informe_contexto(codi_info_cntx, codi_Empr, orden));
    }
    /// <summary>
    /// Validacion de orden
    /// </summary>
    /// 
    public Boolean verificar_orden(string codi_info_cntx, string codi_Empr, string orden)
    {
       DataSet dt= con.TraerResultados0(cntx.valida_orden(codi_info_cntx, codi_Empr, orden));
       string valor = dt.Tables[0].Rows[0][0].ToString();
       if (int.Parse(valor) > 0)
       {
           return false;
       }
       else
       {
           return true;
       }
    }
}
