using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

public partial class MantencionCubo
{
    Conexion con = new Conexion().CrearInstancia();
    ModeloMantencionCubo cub = new ModeloMantencionCubo();
    /// <summary>
    /// Ejecuta actualización parcial de datos
    /// </summary>
    /// 
    public void updCuboParcial(string vPeriodo)
    {
        con.EjecutarQueryBI(cub.updCuboParcial(vPeriodo));
    }
    public DataTable getProcEsta(string pProgProc)
    {

        return con.TraerResultados0(cub.getProcEsta(pProgProc)).Tables[0];
    }
}
