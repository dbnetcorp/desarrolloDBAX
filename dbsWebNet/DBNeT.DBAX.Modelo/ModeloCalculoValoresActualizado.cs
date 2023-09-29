using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public partial class ModeloCalculoValoresActualizado
{
    public string getEmpresas(string tipoTaxonomia, string segmento, string tsCodiUsua, string tsCodiEmpr, string tsCodiEmex)
    {
        return "exec prc_read_dbax_defi_pers 'l', 1, 1000,'','','','','"+segmento+"','"+tipoTaxonomia+"', '"+tsCodiUsua+"','"+tsCodiEmpr+"','"+tsCodiEmex+"'";
    }
    public string execCalculo(string tsCodiEmex,  string tsCodiEmpr, string tsCodiPers, string tsPeriDesde, string tsPeriHasta, string tsPeriActual)
    {
        return "exec prc_dbax_calc_actu '" + tsCodiEmex + "', " + tsCodiEmpr + ", '" + tsCodiPers + "', '" + tsPeriDesde + "', '" + tsPeriHasta + "', '" + tsPeriActual + "' ";
    }
}