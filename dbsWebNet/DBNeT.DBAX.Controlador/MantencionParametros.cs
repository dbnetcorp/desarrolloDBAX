using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public partial class MantencionParametros
{
    ModeloMantencionParametros Para = new ModeloMantencionParametros();
    Conexion con = new Conexion();
    /// <summary>
    /// Obtiene el tiempo se sesión definido en 
    /// </summary>
    public string getTiempoDeSession()
    {
        string sesion = con.StringEjecutarQuery(Para.getValoPara("DBAX_SESS_TIME"));
        return sesion;
    }
    /// <summary>
    /// Obtiene el directorio web de la aplicacion
    /// </summary>
    public string getPathWebb()
    {
        string sesion = con.StringEjecutarQuery(Para.getValoPara("DBAX_PATH_WEBB"));
        if (sesion[sesion.Length - 1] != System.IO.Path.DirectorySeparatorChar)
            sesion += System.IO.Path.DirectorySeparatorChar;
        return sesion;
    }
    /// <summary>
    /// Obtiene directorio de los binarios de la aplicacion
    /// </summary>
    public string getPathBina()
    {
        string sesion = con.StringEjecutarQuery(Para.getValoPara("DBAX_XBRL_BINA"));
        if (sesion[sesion.Length - 1] != System.IO.Path.DirectorySeparatorChar)
            sesion += System.IO.Path.DirectorySeparatorChar;
        return sesion;
    }
    /// <summary>
    /// Obtiene directorio de los XBRL
    /// </summary>
    public string getPathXbrl()
    {
        string sesion = con.StringEjecutarQuery(Para.getValoPara("DBAX_XBRL_PATH"));
        if (sesion[sesion.Length - 1] != System.IO.Path.DirectorySeparatorChar)
            sesion += System.IO.Path.DirectorySeparatorChar;
        return sesion;
    }
    public string getPathWebTemp()
    {
        string sesion = con.StringEjecutarQuery(Para.getValoPara("DBAX_PATH_TEMP"));
        if (sesion[sesion.Length - 1] != System.IO.Path.DirectorySeparatorChar)
            sesion += System.IO.Path.DirectorySeparatorChar;
        return sesion;
    }
    public string getPaisXbrl()
    {
        string sesion = con.StringEjecutarQuery(Para.getValoPara("DBAX_PAIS_XBRL"));
        return sesion;
    }
    public string getPath(string tsRutaWeb)
    {
        string sesion = con.StringEjecutarQuery(Para.getValoPara(tsRutaWeb));
        return sesion;
    }

    /// <summary>
    /// Obtiene estado para desplegar en la barra de estado
    /// </summary>
    public string SP_AX_getEstadoBarra()
    {
        string estado = con.StringEjecutarQuery(Para.SP_AX_getEstadoBarra());
        return estado;
    }
    /// <summary>
    /// Obtiene estado para desplegar en la barra de estado (por usuario)
    /// </summary>
    public string SP_AX_getEstadoBarra(string usuario)
    {
        string estado = con.StringEjecutarQuery(Para.SP_AX_getEstadoBarra(usuario));
        return estado;
    }
    /// <summary>
    /// Inserta estado en tabla. Estado = [OK, Proc, Wait], borra = [S,N]
    /// </summary>
    public string SP_AX_insEstadoBarra(string estado, string mensaje, string borra)
    {
        string res = con.StringEjecutarQuery(Para.SP_AX_insEstadoBarra(estado,mensaje, borra));
        return res;
    }
    /// <summary>
    /// Inserta estado en tabla. Estado = [OK, Proc, Wait], borra = [S,N]
    /// </summary>
    public string SP_AX_insEstadoBarra(string estado, string mensaje, string borra, string usuario)
    {
        string res = con.StringEjecutarQuery(Para.SP_AX_insEstadoBarra(estado, mensaje, borra, usuario));
        return res;
    }
    /// <summary>
    /// Devuelve prefijo (antes del separador)
    /// </summary>
    public string getPreFijo(string cadena, string separador=":")
    {
        return Para.getPreFijo(cadena, separador);
    }

    /// <summary>
    /// Devuelve postFijo (despues del separador)
    /// </summary>
    public string getPostFijo(string cadena, string separador = ":")
    {
        return Para.getPostFijo(cadena, separador);
    }
    /// <summary>
    /// Obtiene versión del sistema
    /// </summary>
    public string getVersion()
    {
        string res = con.StringEjecutarQuery(Para.getVersion());
        return res;
    }
}
