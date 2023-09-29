using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public partial class ModeloMantencionParametros
{
    public string getValoPara()
    {
        return ("execute SP_AX_GetSessTime");
    }
    public string getValoPara(string CodiPara)
    {
        return ("execute SP_AX_GetValoPara '" + CodiPara + "'");
    }
    public string SP_AX_getEstadoBarra()
    {
        return ("execute prc_read_dbax_proc_even");
    }
    public string SP_AX_getEstadoBarra(string usuario)
    {
        return ("execute prc_read_dbax_proc_even '" + usuario + "'");
    }
    /// <summary>
    /// Inserta estado en tabla. Estado = [OK, Proc, Wait], borra = [S,N]
    /// </summary>
    public string SP_AX_insEstadoBarra(string estado, string mensaje, string borra)
    {
        mensaje = "<img src=\"../librerias/img/img" + estado + ".png\" border=\"0\" class=\"dbnEstado\">" + mensaje;
        return ("execute prc_create_dbax_proc_even '" + mensaje + "','" + borra.Replace("S", "1").Replace("N", "0") + "'");
    }
    /// <summary>
    /// Inserta estado en tabla. Estado = [OK, Proc, Wait], borra = [S,N]
    /// </summary>
    public string SP_AX_insEstadoBarra(string estado, string mensaje, string borra, string usuario)
    {
        mensaje = "<img src=\"../librerias/img/img" + estado + ".png\" border=\"0\" class=\"dbnEstado\"/>" + mensaje;
        return ("execute prc_create_dbax_proc_even '" + mensaje + "','" + borra.Replace("S", "1").Replace("N", "0") + "','" + usuario + "'");
    }

    /// <summary>
    /// Devuelve prefijo (antes de :)
    /// </summary>
    public string getPreFijo(string cadena, string separador = ":")
    {
        try
        {
            return cadena.Substring(0, cadena.IndexOf(separador));
        }
        catch
        {
            return cadena;
        }
    }

    /// <summary>
    /// Devuelve prefijo (antes de :)
    /// </summary>
    public string getPostFijo(string cadena, string separador = ":")
    {
        try
        {
            return cadena.Substring(cadena.IndexOf(separador) + 1, cadena.Length - cadena.IndexOf(separador) - 1);
        }
        catch
        {
            return cadena;
        }
    }
    /// <summary>
    /// Devuelve prefijo (antes de :)
    /// </summary>
    public string getVersion()
    {
        return ("execute SP_AX_getVersion");
    }
}