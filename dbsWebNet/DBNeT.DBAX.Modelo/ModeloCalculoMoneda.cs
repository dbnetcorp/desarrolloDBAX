using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public partial class ModeloCalculoMoneda
{
    /// <summary>
    /// Ejectua el Cambio de Moneda por codigo de empresa, version de instancia, correlativo de instancia
    /// </summary>
    /// <param name="tn_codi_pers"></param>
    /// <param name="tn_corr_inst"></param>
    /// <param name="tn_vers_inst"></param>
    /// <param name="ts_codi_emex"></param>
    /// <param name="tn_codi_empr"></param>
    /// <returns></returns>
    public string getCambioMoneda(string tn_codi_pers, int tn_corr_inst,int tn_vers_inst, string ts_codi_emex, int tn_codi_empr)
    {
        return ("execute prc_dbax_inst_conc_conv_mone '"+tn_codi_pers+"',"+tn_corr_inst+","+tn_vers_inst+",'"+ts_codi_emex+"',"+tn_codi_empr+"");
    }
    /// <summary>
    /// Ejectua el Cambio de Moneda mejorado por codigo de empresa, version de instancia, correlativo de instancia
    /// </summary>
    /// <param name="tn_codi_pers"></param>
    /// <param name="tn_corr_inst"></param>
    /// <param name="tn_vers_inst"></param>
    /// <param name="ts_codi_emex"></param>
    /// <param name="tn_codi_empr"></param>
    /// <returns></returns>
    public string getCambioMoneda2(string tn_codi_pers, int tn_corr_inst, int tn_vers_inst)
    {
        return ("execute SP_AX_CalculaMonedas '" + tn_codi_pers + "'," + tn_corr_inst + "," + tn_vers_inst);
    }
    /// <summary>
    /// Ejectua el Cambio de Moneda por codigo de empresa, version de instancia, correlativo de instancia y concepto
    /// </summary>
    /// <param name="tn_codi_pers"></param>
    /// <param name="tn_corr_inst"></param>
    /// <param name="tn_vers_inst"></param>
    /// <param name="ts_codi_emex"></param>
    /// <param name="tn_codi_empr"></param>
    /// <returns></returns>
    public string getCambioMoneda(string tn_codi_pers, int tn_corr_inst, int tn_vers_inst, string ts_codi_emex, int tn_codi_empr, string ts_pref_conc, string ts_codi_conc)
    {
        return ("execute prc_dbax_inst_conc_conv_mone '" + tn_codi_pers + "'," + tn_corr_inst + "," + tn_vers_inst + ",'" + ts_codi_emex + "'," + tn_codi_empr + ",'" + ts_pref_conc + "','" + ts_codi_conc + "'");
    }
    /// <summary>
    /// Obtiene las empresas que tienen datos cargados para el correlativo que se recibe por parámetro
    /// </summary>
    /// <param name="ts_corr_inst"></param>
    /// <returns></returns>
    public string getCodigosEmpresa(string ts_corr_inst)
    {
        return ("execute SP_AX_getCodigosEmpresa '"+ts_corr_inst+"'");
    }
    /// <summary>
    /// Obtiene las empresas que tienen datos cargados para el correlativo que se recibe por parámetro y que no no tienen las monedas actualizadas
    /// </summary>
    /// <param name="ts_corr_inst"></param>
    /// <returns></returns>
    public string getCodigosEmpresaSinActualizar(string ts_corr_inst)
    {
        return ("execute SP_AX_getCodigosEmpresa '" + ts_corr_inst + "','0'");
    }

    /// <summary>
    /// Devuelve el valor de las monedas de conversión para el período dado por parámetro
    /// </summary>
    /// <param name="ts_corr_inst"></param>
    /// <returns></returns>
    public string getEstadoMonedas(string vCorrInst)
    {
        return ("execute SP_AX_getEstadoMonedas '" + vCorrInst + "'");
    }

    /// <summary>
    /// Inserta el valor de una moneda en la DB
    /// </summary>
    /// <param name="ts_corr_inst"></param>
    /// <returns></returns>
    public string insValorMoneda(string vCodiEmex, string vCodiMone, string vCodiMone1, string FechCamo, string ValoCamo)
    {
        return ("execute SP_AX_insValorMoneda '" + vCodiEmex + "','" + vCodiMone + "','" + vCodiMone1 + "','" + FechCamo + "','" + ValoCamo + "'");
    }
}