using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Web.Security;
using System.Data;

public partial class UsuarioSistema
{
    Conexion con = new Conexion().CrearInstancia();
    ValidacionUsuario valUsua = new ValidacionUsuario();
    Boolean valida;
    string query; 
    public Boolean getValidaUsuario(string usua, string pass)
    {
        valida = false;
        query = valUsua.getValidaUsuario(usua, pass);
        string existe = con.StringEjecutarQuery(query);            
        if(existe=="S")
            valida = true;

        return valida;
    }
    #region Código del servicio
    /// <summary>
    /// Rescarta los datos  del servicio
    /// </summary>
    public DataSet SP_AX_getProcesosPendientes()
    {
        return con.TraerResultados0(valUsua.SP_AX_getProcesosPendientes());
    }

    /// <summary>
    /// Update de los estados del servicio
    /// </summary>
    public void UpdEstadoServicio(string esta_proc, string codi_proc, string mens_proc)
    {
        con.TraerResultados0(valUsua.UpdEstadoservicio(esta_proc, codi_proc, mens_proc));
    }
    #endregion
    public DataTable SP_AX_getMailPendientes()
    {
        return con.TraerResultados0(valUsua.SP_AX_getMailPendientes()).Tables[0];
    }

    public void UpdEstadoServicioMail(string esta_proc, string vId)
    {
        con.EjecutarQuery(valUsua.UpdEstadoServicioMail(esta_proc, vId));
    }
}
