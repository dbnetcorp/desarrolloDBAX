using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using DBNeT.DBAX.Modelo.DAC;

namespace DBNeT.DBAX.Controlador
{
    public class ListaValoresController
    {
        ListaValoresDAC _goListaValoresDAC;
        public ListaValoresController()
        { _goListaValoresDAC = new ListaValoresDAC(); }

        /// <summary>
        /// Metodo que obtiene los datos para llenar la lista de valores de prefijo de concepto, ejecuta el procedimiento almacenado prc_read_pref_conc
        /// </summary>
        /// <param name="tsTipo">LV</param>
        /// <param name="tnPagina">0</param>
        /// <param name="tnRegPag">0</param>
        /// <param name="tsCondicion">NULL</param>
        /// <param name="tsPar1">Tipo de Taxonomía</param>
        /// <param name="tsPar2">null</param>
        /// <param name="tsPar3">null</param>
        /// <param name="tsPar4">null</param>
        /// <param name="tsPar5">null</param>
        /// <param name="ts_codi_usua">_goSessionWeb.CODI_USUA</param>
        /// <param name="tn_codi_empr">_goSessionWeb.CODI_EMPR</param>
        /// <param name="ts_codi_emex">_goSessionWeb.CODI_EMEX</param>
        /// <returns>DataTable</returns>
        public DataTable readPrefConc(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        { 
            return _goListaValoresDAC.readPrefConc(tsTipo, tnPagina, tnRegPag, tsCondicion, tsPar1, tsPar2, tsPar3, tsPar4, tsPar5, ts_codi_usua, tn_codi_empr, ts_codi_emex); 
        }
        
        /// <summary>
        /// Metodo que obtiene el codigo del concepto mas la descripción del concepto, ejecuta el procedimiento prc_read_codi_conc
        /// </summary>
        /// <param name="tsTipo">LV</param>
        /// <param name="tnPagina">0</param>
        /// <param name="tnRegPag">0</param>
        /// <param name="tsCondicion">NULL</param>
        /// <param name="tsPar1">Versión de Taxonomía</param>
        /// <param name="tsPar2">Prefijo de Concepto</param>
        /// <param name="tsPar3">NULL</param>
        /// <param name="tsPar4">NULL</param>
        /// <param name="tsPar5">NULL</param>
        /// <param name="ts_codi_usua">_goSessionWeb.CODI_USUA</param>
        /// <param name="tn_codi_empr">_goSessionWeb.CODI_EMPR</param>
        /// <param name="ts_codi_emex">_goSessionWeb.CODI_EMEX</param>
        /// <returns>DataTable</returns>
        public DataTable readCodiConc(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            return _goListaValoresDAC.readCodiConc(tsTipo, tnPagina, tnRegPag, tsCondicion, tsPar1, tsPar2, tsPar3, tsPar4, tsPar5, ts_codi_usua, tn_codi_empr, ts_codi_emex);
        }

        /// <summary>
        /// Metodo que obtiene la participación bursatil de la empresa
        /// </summary>
        /// <returns>DataTable</returns>
        public DataTable readParticipacionBursatil()
        { return _goListaValoresDAC.readParticipacionBursatil(); }

        public DataTable readPrefTaxo(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            return _goListaValoresDAC.readPrefTaxo(tsTipo, tnPagina, tnRegPag, tsCondicion, tsPar1, tsPar2, tsPar3, tsPar4, tsPar5, ts_codi_usua, tn_codi_empr, ts_codi_emex);
        }
    }
}