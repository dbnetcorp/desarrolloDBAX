using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Data;

public partial class ModeloGruposEmpresas
{
    string code = "";
    string CodiPers= "";

    /// <summary>
    /// Obtiene los grupos
    /// </summary>
    public string getGrupos()
    {
        return "execute SP_AX_getGrupos ";
    }
    /// <summary>
    /// Obtiene los Segmentos
    /// </summary>
    public string getSegmentos()
    {
        return "execute SP_AX_getSegmentos ";
    }
    /// <summary>
    /// Obtiene los Tipos de taxonomia
    /// </summary>
    public string getTiposTaxonomia()
    {
        return "execute SP_AX_getTiposTaxonomia ";
    }
    /// <summary>
    /// Guarda los conceptos
    /// </summary>
    public string GuardaGrupo(string NombreGrupo)
    {
        return "execute SP_AX_InsertaGrupo '" + NombreGrupo +"'";
    }
    /// <summary>
    /// LLenado grilla grupo
    /// </summary>
    public string LLenado_grilla_grupo ()
    {
        return "execute SP_AX_getGrupos ";
    }
    /// <summary>
    /// Elimina grilla grupo
    /// </summary>
    public string Elimina_grilla_grupo(string grupo)
    {
        return "execute SP_AX_Elimina_grilla_grupo '" + grupo + "'";
    }
    /// <summary>
    /// Guarda Grupo Empresa
    /// </summary>
    public string[] Guarda_grupo_Empresa(string cadena)
    {
        string strData = cadena;
         
        string[] separator = new string[] { "/" };

        string[] strSplitArr = strData.Split(separator, StringSplitOptions.RemoveEmptyEntries);

        string[] querys = new string[strSplitArr.Length];

        int i = 0;

        foreach (string arrStr in strSplitArr)
            {
              code = "";
              CodiPers= "";
              valores(arrStr);
              querys[i] = "execute SP_AX_Ins_GrupoEmpr '" + code + "','" + CodiPers + "','" + '1' + "','" + '1' + "'";
              i ++;
             }

        return querys;
    }
    /// <summary>
    /// metodo que separa el string y lo guarda en 3 text para poder usarlos en guarpareo()
    /// </summary>
    public void valores(string var)
    {
        string strData = var;
        string[] separator = new string[] { "|" };
        string[] strSplitArr = strData.Split(separator, StringSplitOptions.RemoveEmptyEntries);

        strSplitArr[0] = strSplitArr[0].Substring((strSplitArr[0].IndexOf("$") + 1), strSplitArr[0].Length - (strSplitArr[0].IndexOf("$") + 1));

        foreach (string arrStr2 in strSplitArr)
        {
            if (code == "")
                code = arrStr2.Substring(arrStr2.IndexOf("_") + 1);
            else if (CodiPers== "")
                CodiPers= arrStr2;
        }
    }
    /// <summary>
    /// metodo para comprobar si es de ingreso o de modificación
    /// </summary>
    public string verificaingreso(string codi_Empr, string codi_emex)
    {
        return "execute SP_AX_Get_Ingreso '" + codi_Empr + "','" + codi_emex+ "'";
    }
    /// <summary>
    /// Extraer datos de empresas grupo
    /// </summary>
    public string GetDatosGrupo(string codi_empr, string codi_emex, string codi)
    {
        //Cambió nombre desde SP_AX_GetDatosGrupo

        return "execute SP_AX_GetDatosGrupo '" + codi_empr + "','" + codi_emex + "','" + codi + "'";
    }
    /// <summary>
    /// Eliminar datos de empresas grupo
    /// </summary>
    public string EliminardatosGupoEmpresa(string codi_Empr, string codi_emex)
    {
        return "execute SP_AX_Del_grupo '" + codi_Empr + "','" + codi_emex + "'";
    }
    /*
    /// <summary>
    /// metodo que rescata  las empresas
    /// </summary>
    public string GetEmpresas(string CodiEmex, string CodiEmpr, string Cadena, string Grupo)
    {
        if(Cadena.Length > 2 && Cadena.Contains("] "))
            Cadena = Cadena.Substring(Cadena.IndexOf("] ") + 2, Cadena.Length - Cadena.IndexOf("] ") - 2);
        return "execute SP_AX_getEmpresaConFiltro '" + CodiEmex + "','" + CodiEmpr + "','" + Cadena + "','" + Grupo + "'";
    }

    
    /// <summary>
    /// metodo que rescata  las empresas (sobrecarga de metodos)
    /// </summary>
    public string GetEmpresas(string CodiEmex, string CodiEmpr, string Cadena, string Grupo, string parametro)
    {
        if (Cadena.Length > 2 && Cadena.Contains("] "))
            Cadena = Cadena.Substring(Cadena.IndexOf("] ") + 2, Cadena.Length - Cadena.IndexOf("] ") - 2);
        return "exec SP_AX_getEmpresaConFiltro '" + CodiEmex + "','" + CodiEmpr + "','" + Cadena + "','" + Grupo + "','" + parametro + "'";
    }

    /// <summary>
    /// metodo que rescata  las empresas (sobrecarga de metodos)
    /// </summary>
    public string GetEmpresas(string CodiEmex, string CodiEmpr, string Cadena, string Grupo, string Segmento, string parametro)
    {
        if (Cadena.Length > 2 && Cadena.Contains("] "))
            Cadena = Cadena.Substring(Cadena.IndexOf("] ") + 2, Cadena.Length - Cadena.IndexOf("] ") - 2);
        return "exec SP_AX_getEmpresaPorGrupoSegmento '" + CodiEmex + "','" + CodiEmpr + "','','" + Cadena + "','" + Grupo + "','" + Segmento + "','','" + parametro + "'";
    }

    /// <summary>
    /// metodo que rescata  las empresas (sobrecarga de metodos)
    /// </summary>
    public string GetEmpresas(string CodiEmex, string CodiEmpr, string Cadena, string Grupo, string Segmento, string Tipo, string parametro)
    {
        if (Cadena.Length > 2 && Cadena.Contains("] "))
            Cadena = Cadena.Substring(Cadena.IndexOf("] ") + 2, Cadena.Length - Cadena.IndexOf("] ") - 2);
        return "exec SP_AX_getEmpresaPorGrupoSegmento '" + CodiEmex + "','" + CodiEmpr + "','','" + Cadena + "','" + Grupo + "','" + Segmento + "','" + Tipo + "','" + parametro + "'";
    }*/
    /// <summary>
    /// metodo que rescata  las empresas (sobrecarga de metodos)
    /// </summary>
    public string GetEmpresas(string CodiEmex, string CodiEmpr, string CorrInst, string Cadena, string Grupo, string Segmento, string Tipo, string parametro)
    {
        if (Cadena.Length > 2 && Cadena.Contains("] "))
            Cadena = Cadena.Substring(Cadena.IndexOf("] ") + 2, Cadena.Length - Cadena.IndexOf("] ") - 2);
        return "exec SP_AX_getEmpresaPorGrupoSegmento '" + CodiEmex + "','" + CodiEmpr + "','" + CorrInst + "','" + Cadena + "','" + Grupo + "','" + Segmento  + "','" + Tipo + "','" + parametro + "'";
    }
    /// <summary>
    /// metodo que rescata  las empresas (sobrecarga de metodos)
    /// </summary>
    public string GetEmpresas(string CodiEmex, string CodiEmpr, string CorrInst, string Cadena, string Grupo, string Segmento, string Tipo, string parametro, string TipoDeCarga)
    {
        if (Cadena.Length > 2 && Cadena.Contains("] "))
            Cadena = Cadena.Substring(Cadena.IndexOf("] ") + 2, Cadena.Length - Cadena.IndexOf("] ") - 2);
        return "exec SP_AX_getEmpresaPorGrupoSegmento '" + CodiEmex + "','" + CodiEmpr + "','" + CorrInst + "','" + Cadena + "','" + Grupo + "','" + Segmento + "','" + Tipo + "','" + parametro + "','" + TipoDeCarga + "'";
    }
    /// <summary>
    /// metodo que rescata  las empresas (externas) por usuario (sobrecarga de metodos)
    /// </summary>
    public string GetEmpresas(string CodiEmex, string CodiEmpr, string CorrInst, string Cadena, string Grupo, string Segmento, string Tipo, string parametro, string TipoDeCarga, string UsuaCarg)
    {
        if (Cadena.Length > 2 && Cadena.Contains("] "))
            Cadena = Cadena.Substring(Cadena.IndexOf("] ") + 2, Cadena.Length - Cadena.IndexOf("] ") - 2);
        return "exec SP_AX_getEmpresaPorGrupoSegmento '" + CodiEmex + "','" + CodiEmpr + "','" + CorrInst + "','" + Cadena + "','" + Grupo + "','" + Segmento + "','" + Tipo + "','" + parametro + "','" + TipoDeCarga + "','" + UsuaCarg + "'";
    }
    /// <summary>
    /// Comprueba existencia de empresa (1 = existe, 0 = no existe)
    /// </summary>
    public string getExisteEmpresa(string CodiPers)
    {
        return "execute SP_AX_getEmpresa '" + CodiPers + "'";
    }
    /// <summary>
    /// Modificar nombre del  grupo
    /// </summary>
    public string Upd_Grupo_Empresa(string codi_empr, string codi_emex, string desc_grup, string codi_grup)
    {
        return "execute SP_AX_Upd_grupo_Empr '" + codi_empr + "','" + codi_emex + "','" + desc_grup + "','" + codi_grup + "'";
    }
}