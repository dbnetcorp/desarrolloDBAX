using System.Data;
using System.Text;

/// <summary>
/// Clase que se ocupa para el binario de calculo
/// </summary>
public partial class CalculoValoresActualizadosC
{
    Conexion con = new Conexion().CrearInstancia();
    ModeloCalculoValoresActualizado calValActu = new ModeloCalculoValoresActualizado();

    public DataTable getEmpresas(string tipoTaxonomia, string segmento, string tsCodiUsua, string tsCodiEmpr, string tsCodiEmex)
    {
        return con.TraerResultados0(calValActu.getEmpresas(tipoTaxonomia,segmento,tsCodiUsua,tsCodiEmpr, tsCodiEmex)).Tables[0];
    }

    public void CambioValores(string tsCodiEmex,  string tsCodiEmpr, string tsCodiPers, string tsPeriDesde, string tsPeriHasta, string tsPeriActual)
    {
        con.EjecutarQuery(calValActu.execCalculo(tsCodiEmex,tsCodiEmpr,tsCodiPers,tsPeriDesde,tsPeriHasta,tsPeriActual));
    }
}