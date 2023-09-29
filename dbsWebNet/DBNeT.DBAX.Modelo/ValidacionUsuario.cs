using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public partial class ValidacionUsuario
{
    public string InsertarUsuario(string CodiUsua, string PassUsua)
    {
        return "execute SP_AX_InseUsuaSys '" + CodiUsua + "','" + PassUsua + "'";
    }
    public string getValidaUsuario(string CodiUsua, string PassUsua)
    {
        return "select dbo.FU_AX_getValidaUsua ('" + CodiUsua + "','" + PassUsua + "')";
    }
    #region Código del servicio
    /// <summary>
    /// Rescarta los datos  del servicio
    /// </summary>
    public string SP_AX_getProcesosPendientes()
    {
        return "execute SP_AX_getProcesosPendientes";
    }
    /// <summary>
    /// Update de los estados del servicio
    /// </summary>
    public string UpdEstadoservicio(string esta_proc, string codi_proc, string mens_proc)
    {
        return "execute SP_AX_UpdEstadoservicio '" + esta_proc + "','" + codi_proc + "','" + mens_proc + "'";
    }
    #endregion

    public string SP_AX_getMailPendientes()
    {
        return "execute SP_AX_getMailPendientes";
    }

    internal string UpdEstadoServicioMail(string esta_proc, string vId)
    {
        return "execute SP_AX_UpdEstadoServicioMail '" + esta_proc + "','" + vId + "'";
    }
}