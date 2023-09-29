using System.Data;
using System.Text;
using DBNeT.DBAX.Controlador;

public partial class CalculoMonedaC
{
    Conexion con = new Conexion().CrearInstancia();
    ModeloCalculoMoneda calcMone = new ModeloCalculoMoneda();

    public DataTable getCodigosEmpresa(string ts_corr_inst)
    {
        return con.TraerResultadosT0(calcMone.getCodigosEmpresa(ts_corr_inst));
    }
    public DataTable getCodigosEmpresaSinActualizar(string ts_corr_inst)
    {
        return con.TraerResultadosT0(calcMone.getCodigosEmpresaSinActualizar(ts_corr_inst));
    }
    public DataTable getCambioMoneda(string tn_codi_pers, int tn_corr_inst, int tn_vers_inst, string ts_codi_emex, int tn_codi_empr)
    {
        return con.TraerResultadosT0(calcMone.getCambioMoneda(tn_codi_pers, tn_corr_inst, tn_vers_inst, ts_codi_emex, tn_codi_empr));
    }
    public DataTable getCambioMoneda2(string tn_codi_pers, int tn_corr_inst, int tn_vers_inst)
    {
        return con.TraerResultadosT0(calcMone.getCambioMoneda2(tn_codi_pers, tn_corr_inst, tn_vers_inst));
    }
    public DataTable getCambioMoneda(string tn_codi_pers, int tn_corr_inst, int tn_vers_inst, string ts_codi_emex, int tn_codi_empr, string ts_pref_conc, string ts_codi_conc)
    {
        return con.TraerResultadosT0(calcMone.getCambioMoneda(tn_codi_pers, tn_corr_inst, tn_vers_inst, ts_codi_emex, tn_codi_empr, ts_pref_conc, ts_codi_conc));
    }
    public DataTable getEstadoMonedas(string vCorrInst)
    {
        return con.TraerResultadosT0(calcMone.getEstadoMonedas(vCorrInst));
    }
    public void insValorMoneda(string vCodiEmex, string vCodiMone, string CodiMone1, string FechCamo,string ValoCamo)
    {
        con.TraerResultadosT0(calcMone.insValorMoneda(vCodiEmex, vCodiMone, CodiMone1, FechCamo, ValoCamo));
    }
}