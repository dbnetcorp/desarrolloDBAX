using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;
using DBNeT.Framework.Helper;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbaxDefiPersDAC : BaseDAC
    {
        DbaxDefiPersBE _goDbaxDefiPersBE;
        public DbaxDefiPersDAC()
        { _goDbaxDefiPersBE = new DbaxDefiPersBE(); }

        /// <summary>
        /// Metodo que Crea una Empresa
        /// </summary>
        /// <param name="toDbaxDefiPersBE"></param>
        public void createDbaxDefiPers(DbaxDefiPersBE toDbaxDefiPersBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiPersBE.PRC_CREATE_DBAX_DEFI_PERS);
                AddCommandParamIN("P_CODI_PERS", CmdParamType.StringVarLen, 16, toDbaxDefiPersBE.CODI_PERS);
                AddCommandParamIN("P_DESC_PERS", CmdParamType.StringVarLen, 100, toDbaxDefiPersBE.DESC_PERS);
                AddCommandParamIN("P_CODI_GRUP", CmdParamType.StringVarLen, 50, toDbaxDefiPersBE.CODI_GRUP);
                AddCommandParamIN("P_CODI_SEGM", CmdParamType.StringVarLen, 50, toDbaxDefiPersBE.CODI_SEGM);
                AddCommandParamIN("P_TIPO_TAXO", CmdParamType.StringVarLen, 10, toDbaxDefiPersBE.TIPO_TAXO);
                AddCommandParamIN("P_PRES_BURS", CmdParamType.StringVarLen, 30, toDbaxDefiPersBE.PRES_BURS);
                AddCommandParamIN("P_EMIS_BONO", CmdParamType.StringVarLen, 2, toDbaxDefiPersBE.EMIS_BONO);
                AddCommandParamIN("P_EMPR_VIGE", CmdParamType.StringVarLen, 10, toDbaxDefiPersBE.EMPR_VIGE);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        /// <summary>
        /// Metodo para obtener consulta de la tabla dbax_defi_pers
        /// </summary>
        /// <param name="tsTipo">Tipo de Listador</param>
        /// <param name="tnPagina">pagina a buscar</param>
        /// <param name="tnRegPag">cantidad de registro por página</param>
        /// <param name="tsCondicion">Condicion para filtrar la consulta</param>
        /// <param name="tsPar1">Código Empress</param>
        /// <param name="tsPar2">Descripción Empresa</param>
        /// <param name="tsPar3">Grupo</param>
        /// <param name="tsPar4">Segmento</param>
        /// <param name="tsPar5">Tipo</param>
        /// <param name="ts_codi_usua">Codigo de Usuario</param>
        /// <param name="tn_codi_empr">Codigo de Empresa</param>
        /// <param name="ts_codi_emex">Codigo de Holding</param>
        /// <returns></returns>
        public DataTable readDbaxDefiPersDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiPersBE.PRC_READ_DBAX_DEFI_PERS);
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

        public List<DbaxDefiPersBE> readDbaxDefiPersList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxDefiPersBE> listaDbaxDefiPers = new List<DbaxDefiPersBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiPersBE.PRC_READ_DBAX_DEFI_PERS);
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
                DataTable dt = this.ExecuteQueryCmdTable();

                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        _goDbaxDefiPersBE = new DbaxDefiPersBE();
                        _goDbaxDefiPersBE.CODI_PERS = DBHelper.devuelveString(dr["CODI_PERS"]);
                        _goDbaxDefiPersBE.DESC_PERS = DBHelper.devuelveString(dr["DESC_PERS"]);
                        _goDbaxDefiPersBE.CODI_GRUP = DBHelper.devuelveString(dr["CODI_GRUP"]);
                        _goDbaxDefiPersBE.CODI_SEGM = DBHelper.devuelveString(dr["CODI_SEGM"]);
                        _goDbaxDefiPersBE.TIPO_TAXO = DBHelper.devuelveString(dr["TIPO_TAXO"]);
                        _goDbaxDefiPersBE.PRES_BURS = DBHelper.devuelveString(dr["PRES_BURS"]);
                        _goDbaxDefiPersBE.EMIS_BONO = DBHelper.devuelveString(dr["EMIS_BONO"]);
                        _goDbaxDefiPersBE.EMPR_VIGE = DBHelper.devuelveString(dr["EMPR_VIGE"]);
                        listaDbaxDefiPers.Add(_goDbaxDefiPersBE);
                    }
                }
                return listaDbaxDefiPers;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbaxDefiPersBE readDbaxDefiPers(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiPersBE.PRC_READ_DBAX_DEFI_PERS);
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
                DataTable dt = this.ExecuteQueryCmdTable();

                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        _goDbaxDefiPersBE = new DbaxDefiPersBE();
                        _goDbaxDefiPersBE.CODI_PERS = DBHelper.devuelveString(dr["CODI_PERS"]);
                        _goDbaxDefiPersBE.DESC_PERS = DBHelper.devuelveString(dr["DESC_PERS"]);
                        _goDbaxDefiPersBE.CODI_GRUP = DBHelper.devuelveString(dr["CODI_GRUP"]);
                        _goDbaxDefiPersBE.CODI_SEGM = DBHelper.devuelveString(dr["CODI_SEGM"]);
                        _goDbaxDefiPersBE.TIPO_TAXO = DBHelper.devuelveString(dr["TIPO_TAXO"]);
                        _goDbaxDefiPersBE.PRES_BURS = DBHelper.devuelveString(dr["PRES_BURS"]);
                        _goDbaxDefiPersBE.EMIS_BONO = DBHelper.devuelveString(dr["EMIS_BONO"]);
                        _goDbaxDefiPersBE.EMPR_VIGE = DBHelper.devuelveString(dr["EMPR_VIGE"]);
                    }
                }
                return _goDbaxDefiPersBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbaxDefiPers(DbaxDefiPersBE toDbaxDefiPersBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiPersBE.PRC_UPDATE_DBAX_DEFI_PERS);
                AddCommandParamIN("P_CODI_PERS", CmdParamType.StringVarLen, 16, toDbaxDefiPersBE.CODI_PERS);
                AddCommandParamIN("P_DESC_PERS", CmdParamType.StringVarLen, 100, toDbaxDefiPersBE.DESC_PERS);
                AddCommandParamIN("P_CODI_GRUP", CmdParamType.StringVarLen, 50, toDbaxDefiPersBE.CODI_GRUP);
                AddCommandParamIN("P_CODI_SEGM", CmdParamType.StringVarLen, 50, toDbaxDefiPersBE.CODI_SEGM);
                AddCommandParamIN("P_TIPO_TAXO", CmdParamType.StringVarLen, 10, toDbaxDefiPersBE.TIPO_TAXO);
                AddCommandParamIN("P_PRES_BURS", CmdParamType.StringVarLen, 30, toDbaxDefiPersBE.PRES_BURS);
                AddCommandParamIN("P_EMIS_BONO", CmdParamType.StringVarLen, 2, toDbaxDefiPersBE.EMIS_BONO);
                AddCommandParamIN("P_EMPR_VIGE", CmdParamType.StringVarLen, 10, toDbaxDefiPersBE.EMPR_VIGE);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbaxDefiPers(int tnCodiPers)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiPersBE.PRC_DELETE_DBAX_DEFI_PERS);
                AddCommandParamIN("P_CODI_PERS", CmdParamType.Integer, tnCodiPers);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }
    }
}