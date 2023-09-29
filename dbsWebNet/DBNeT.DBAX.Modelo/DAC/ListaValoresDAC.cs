using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class ListaValoresDAC : BaseDAC
    {
        public ListaValoresDAC()
        { }

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
            try
            {
                OpenConnection();
                CreateCommand("prc_read_pref_conc");
                AddCommandParamIN("tsTipo", CmdParamType.StringVarLen, 2, tsTipo);
                AddCommandParamIN("tnPagina", CmdParamType.Integer, tnPagina);
                AddCommandParamIN("tnRegPag", CmdParamType.Integer, tnRegPag);
                AddCommandParamIN("tsCondicion", CmdParamType.StringVarLen, 2048, tsCondicion);
                AddCommandParamIN("tsPar1", CmdParamType.StringVarLen, 256, tsPar1);
                AddCommandParamIN("tsPar2", CmdParamType.StringVarLen, 256, tsPar2);
                AddCommandParamIN("tsPar3", CmdParamType.StringVarLen, 256, tsPar3);
                AddCommandParamIN("tsPar4", CmdParamType.StringVarLen, 256, tsPar4);
                AddCommandParamIN("tsPar5", CmdParamType.StringVarLen, 256, tsPar5);
                AddCommandParamIN("p_codi_usua", CmdParamType.StringVarLen, 30, ts_codi_usua);
                AddCommandParamIN("p_codi_empr", CmdParamType.Integer, tn_codi_empr);
                AddCommandParamIN("p_codi_emex", CmdParamType.StringVarLen, 30, ts_codi_emex);
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
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
            try
            {
                OpenConnection();
                CreateCommand("prc_read_codi_conc");
                AddCommandParamIN("tsTipo", CmdParamType.StringVarLen, 2, tsTipo);
                AddCommandParamIN("tnPagina", CmdParamType.Integer, tnPagina);
                AddCommandParamIN("tnRegPag", CmdParamType.Integer, tnRegPag);
                AddCommandParamIN("tsCondicion", CmdParamType.StringVarLen, 2048, tsCondicion);
                AddCommandParamIN("tsPar1", CmdParamType.StringVarLen, 256, tsPar1);
                AddCommandParamIN("tsPar2", CmdParamType.StringVarLen, 256, tsPar2);
                AddCommandParamIN("tsPar3", CmdParamType.StringVarLen, 256, tsPar3);
                AddCommandParamIN("tsPar4", CmdParamType.StringVarLen, 256, tsPar4);
                AddCommandParamIN("tsPar5", CmdParamType.StringVarLen, 256, tsPar5);
                AddCommandParamIN("p_codi_usua", CmdParamType.StringVarLen, 30, ts_codi_usua);
                AddCommandParamIN("p_codi_empr", CmdParamType.Integer, tn_codi_empr);
                AddCommandParamIN("p_codi_emex", CmdParamType.StringVarLen, 30, ts_codi_emex);
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        /// <summary>
        /// Metodo que Obtiene la participación bursatil de la empresa
        /// </summary>
        /// <returns></returns>
        public DataTable readParticipacionBursatil()
        {
            try
            {
                OpenConnection();
                CreateCommandSQL("select '' as CODIGO, 'Seleccione' as Valor union select code as CODIGO, code_desc AS VALOR from sys_code where domain_code = '2100'");
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }


        public DataTable readPrefTaxo(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            try
            {
                OpenConnection();
                CreateCommand("prc_read_pref_taxo");
                AddCommandParamIN("tsTipo", CmdParamType.StringVarLen, 2, tsTipo);
                AddCommandParamIN("tnPagina", CmdParamType.Integer, tnPagina);
                AddCommandParamIN("tnRegPag", CmdParamType.Integer, tnRegPag);
                AddCommandParamIN("tsCondicion", CmdParamType.StringVarLen, 2048, tsCondicion);
                AddCommandParamIN("tsPar1", CmdParamType.StringVarLen, 256, tsPar1);
                AddCommandParamIN("tsPar2", CmdParamType.StringVarLen, 256, tsPar2);
                AddCommandParamIN("tsPar3", CmdParamType.StringVarLen, 256, tsPar3);
                AddCommandParamIN("tsPar4", CmdParamType.StringVarLen, 256, tsPar4);
                AddCommandParamIN("tsPar5", CmdParamType.StringVarLen, 256, tsPar5);
                AddCommandParamIN("p_codi_usua", CmdParamType.StringVarLen, 30, ts_codi_usua);
                AddCommandParamIN("p_codi_empr", CmdParamType.Integer, tn_codi_empr);
                AddCommandParamIN("p_codi_emex", CmdParamType.StringVarLen, 30, ts_codi_emex);
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }
    }
}