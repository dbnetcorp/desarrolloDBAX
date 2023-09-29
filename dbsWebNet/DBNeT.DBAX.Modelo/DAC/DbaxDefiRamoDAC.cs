using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.Framework.Helper;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbaxDefiRamoDAC : BaseDAC
    {
        DbaxDefiRamoBE _goDbaxDefiRamoBE;
        public DbaxDefiRamoDAC()
        { _goDbaxDefiRamoBE = new DbaxDefiRamoBE(); }

        public void createDbaxDefiRamo(DbaxDefiRamoBE toDbaxDefiRamoBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiRamoBE.PRC_CREATE_DBAX_DEFI_RAMO);
                AddCommandParamIN("P_CODI_SEGM", CmdParamType.StringVarLen, 50, toDbaxDefiRamoBE.CODI_SEGM);
                AddCommandParamIN("P_CODI_RAMO", CmdParamType.StringVarLen, 30, toDbaxDefiRamoBE.CODI_RAMO);
                AddCommandParamIN("P_DESC_RAMO", CmdParamType.StringVarLen, 80, toDbaxDefiRamoBE.DESC_RAMO);
                AddCommandParamIN("P_CODI_RAMO_SUPE", CmdParamType.StringVarLen, 30, toDbaxDefiRamoBE.CODI_RAMO_SUPE);
                AddCommandParamIN("P_TIPO_RAMO", CmdParamType.StringVarLen, 1, toDbaxDefiRamoBE.TIPO_RAMO);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 64, toDbaxDefiRamoBE.CODI_CONC);
                AddCommandParamIN("P_NUME_RAMO", CmdParamType.StringVarLen, 10, toDbaxDefiRamoBE.NUME_RAMO);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public DataTable readDbaxDefiRamoDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiRamoBE.PRC_READ_DBAX_DEFI_RAMO);
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
                return dt;
            }
             catch (Exception ex)
             { throw ex; }
             finally
             { CloseConnection(); }
        }

        public List<DbaxDefiRamoBE> readDbaxDefiRamoList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxDefiRamoBE> listaDbaxDefiRamo = new List<DbaxDefiRamoBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiRamoBE.PRC_READ_DBAX_DEFI_RAMO);
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
                        _goDbaxDefiRamoBE = new DbaxDefiRamoBE();
                        _goDbaxDefiRamoBE.CODI_SEGM = DBHelper.devuelveString(dr["CODI_SEGM"]);
                        _goDbaxDefiRamoBE.CODI_RAMO = DBHelper.devuelveString(dr["CODI_RAMO"]);
                        _goDbaxDefiRamoBE.DESC_RAMO = DBHelper.devuelveString(dr["DESC_RAMO"]);
                        _goDbaxDefiRamoBE.CODI_RAMO_SUPE = DBHelper.devuelveString(dr["CODI_RAMO_SUPE"]);
                        _goDbaxDefiRamoBE.TIPO_RAMO = DBHelper.devuelveString(dr["TIPO_RAMO"]);
                        _goDbaxDefiRamoBE.CODI_CONC = DBHelper.devuelveString(dr["CODI_CONC"]);
                        _goDbaxDefiRamoBE.NUME_RAMO = DBHelper.devuelveString(dr["NUME_RAMO"]);
                        listaDbaxDefiRamo.Add(_goDbaxDefiRamoBE);
                    }
                }
                return listaDbaxDefiRamo;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbaxDefiRamoBE readDbaxDefiRamo(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiRamoBE.PRC_READ_DBAX_DEFI_RAMO);
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
                        _goDbaxDefiRamoBE = new DbaxDefiRamoBE();
                        _goDbaxDefiRamoBE.CODI_SEGM = DBHelper.devuelveString(dr["CODI_SEGM"]);
                        _goDbaxDefiRamoBE.CODI_RAMO = DBHelper.devuelveString(dr["CODI_RAMO"]);
                        _goDbaxDefiRamoBE.DESC_RAMO = DBHelper.devuelveString(dr["DESC_RAMO"]);
                        _goDbaxDefiRamoBE.CODI_RAMO_SUPE = DBHelper.devuelveString(dr["CODI_RAMO_SUPE"]);
                        _goDbaxDefiRamoBE.TIPO_RAMO = DBHelper.devuelveString(dr["TIPO_RAMO"]);
                        _goDbaxDefiRamoBE.CODI_CONC = DBHelper.devuelveString(dr["CODI_CONC"]);
                        _goDbaxDefiRamoBE.NUME_RAMO = DBHelper.devuelveString(dr["NUME_RAMO"]);
                    }
                }
                return _goDbaxDefiRamoBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbaxDefiRamo(DbaxDefiRamoBE toDbaxDefiRamoBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiRamoBE.PRC_UPDATE_DBAX_DEFI_RAMO);
                AddCommandParamIN("P_CODI_SEGM", CmdParamType.StringVarLen, 50, toDbaxDefiRamoBE.CODI_SEGM);
                AddCommandParamIN("P_CODI_RAMO", CmdParamType.StringVarLen, 30, toDbaxDefiRamoBE.CODI_RAMO);
                AddCommandParamIN("P_DESC_RAMO", CmdParamType.StringVarLen, 80, toDbaxDefiRamoBE.DESC_RAMO);
                AddCommandParamIN("P_CODI_RAMO_SUPE", CmdParamType.StringVarLen, 30, toDbaxDefiRamoBE.CODI_RAMO_SUPE);
                AddCommandParamIN("P_TIPO_RAMO", CmdParamType.StringVarLen, 1, toDbaxDefiRamoBE.TIPO_RAMO);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 64, toDbaxDefiRamoBE.CODI_CONC);
                AddCommandParamIN("P_NUME_RAMO", CmdParamType.StringVarLen,10, toDbaxDefiRamoBE.NUME_RAMO);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbaxDefiRamo(string tsCodiSegm, string tsCodiRamo, string tsTipoRamo)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiRamoBE.PRC_DELETE_DBAX_DEFI_RAMO);
                AddCommandParamIN("P_CODI_SEGM", CmdParamType.StringVarLen, 50, tsCodiSegm);
                AddCommandParamIN("P_CODI_RAMO", CmdParamType.StringVarLen, 30, tsCodiRamo);
                AddCommandParamIN("P_TIPO_RAMO", CmdParamType.StringVarLen, 1, tsTipoRamo);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }
    }
}