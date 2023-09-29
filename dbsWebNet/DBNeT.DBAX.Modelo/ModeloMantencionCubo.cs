using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public partial class ModeloMantencionCubo
{
    Conexion con = new Conexion().CrearInstancia();
    /// <summary>
    /// Ejecuta actualización parcial de datos (prc_bi_dbax_create_3)
    /// </summary>
    /// 
    public string updCuboParcial(string vPeriodo)
    {
        return "execute prc_bi_dbax_create_3 '" + vPeriodo + "'";
    }
    public string getProcEsta(string pProgProc)
    {
        return "execute SP_AX_getProcEsta '" + pProgProc + "'";
    }
}
