using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DBNeT.DBAX.Controlador
{
    public class insertaRegistroEnCentralController
    {
        insertaRegistrosEnCentral central = new insertaRegistrosEnCentral();

        public string insertaRegistroEnCentral(string tipo, string segmento, string zip, string version, string fecha)
        {
            return central.prc_create_dbax_tras_arch(tipo, segmento, zip, version, fecha);
             
        }
    }
}
