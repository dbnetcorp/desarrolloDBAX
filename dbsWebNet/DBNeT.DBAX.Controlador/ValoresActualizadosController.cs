using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.DBAX.Modelo.DAC;

namespace DBNeT.DBAX.Controlador
{
    public class ValoresActualizadosController
    {
        ValoresActualizadosDAC _goValoresActualizados;
        public ValoresActualizadosController()
        { _goValoresActualizados = new ValoresActualizadosDAC(); }

        public void create_dbax_calc_actu(string tsNombBin, string tsCodiUsua, string tsCodiArgs, string tsCodiEmex, int tnCodiEmpr)
        {
            _goValoresActualizados.create_dbax_calc_actu(tsNombBin,tsCodiUsua,tsCodiArgs,tsCodiEmex,tnCodiEmpr);
        }
    }
}