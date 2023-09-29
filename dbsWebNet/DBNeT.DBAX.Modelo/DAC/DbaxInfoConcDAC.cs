using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbaxInfoConcDAC : BaseDAC
    {
        DbaxInfoConcBE _goDbaxInfoConcBE;
        public DbaxInfoConcDAC()
        { _goDbaxInfoConcBE = new DbaxInfoConcBE(); }

        public void createDbaxInfoConc(DbaxInfoConcBE toDbaxInfoConcBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxInfoConcBE.PRC_CREATE_DBAX_INFO_CONC);
                AddCommandParamIN("P_CODI_EMPR", CmdParamType.Integer, toDbaxInfoConcBE.CODI_EMPR);
                AddCommandParamIN("P_CODI_EMEX", CmdParamType.StringVarLen, 30, toDbaxInfoConcBE.CODI_EMEX);
                AddCommandParamIN("P_CODI_INFO", CmdParamType.StringVarLen, 50, toDbaxInfoConcBE.CODI_INFO);
                AddCommandParamIN("P_PREF_CONC", CmdParamType.StringVarLen, 50, toDbaxInfoConcBE.PREF_CONC);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 256, toDbaxInfoConcBE.CODI_CONC);
                AddCommandParamIN("P_ORDE_CONC", CmdParamType.Integer, toDbaxInfoConcBE.ORDE_CONC);
                AddCommandParamIN("P_CODI_CONC1", CmdParamType.StringVarLen, 256, toDbaxInfoConcBE.CODI_CONC1);
                AddCommandParamIN("P_NIVE_CONC", CmdParamType.Integer, toDbaxInfoConcBE.NIVE_CONC);
                AddCommandParamIN("P_NEGR_CONC", CmdParamType.StringVarLen, 1, toDbaxInfoConcBE.NEGR_CONC);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public DataTable readDbaxInfoConcDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbaxInfoConcBE.PRC_READ_DBAX_INFO_CONC);
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

        public List<DbaxInfoConcBE> readDbaxInfoConcList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxInfoConcBE> listaDbaxInfoConc = new List<DbaxInfoConcBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxInfoConcBE.PRC_READ_DBAX_INFO_CONC);
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
                        _goDbaxInfoConcBE = new DbaxInfoConcBE();
                        _goDbaxInfoConcBE.CODI_EMPR = Convert.ToInt32(dr["CODI_EMPR"]);
                        _goDbaxInfoConcBE.CODI_EMEX = dr["CODI_EMEX"].ToString();
                        _goDbaxInfoConcBE.CODI_INFO = dr["CODI_INFO"].ToString();
                        _goDbaxInfoConcBE.PREF_CONC = dr["PREF_CONC"].ToString();
                        _goDbaxInfoConcBE.CODI_CONC = dr["CODI_CONC"].ToString();
                        _goDbaxInfoConcBE.ORDE_CONC = Convert.ToInt32(dr["ORDE_CONC"]);
                        _goDbaxInfoConcBE.CODI_CONC1 = dr["CODI_CONC1"].ToString();
                        _goDbaxInfoConcBE.NIVE_CONC = Convert.ToInt32(dr["NIVE_CONC"]);
                        _goDbaxInfoConcBE.NEGR_CONC = dr["NEGR_CONC"].ToString();
                        listaDbaxInfoConc.Add(_goDbaxInfoConcBE);
                    }
                }
                return listaDbaxInfoConc;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbaxInfoConcBE readDbaxInfoConc(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxInfoConcBE.PRC_READ_DBAX_INFO_CONC);
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
                        _goDbaxInfoConcBE = new DbaxInfoConcBE();
                        _goDbaxInfoConcBE.CODI_EMPR = Convert.ToInt32(dr["CODI_EMPR"]);
                        _goDbaxInfoConcBE.CODI_EMEX = dr["CODI_EMEX"].ToString();
                        _goDbaxInfoConcBE.CODI_INFO = dr["CODI_INFO"].ToString();
                        _goDbaxInfoConcBE.PREF_CONC = dr["PREF_CONC"].ToString();
                        _goDbaxInfoConcBE.CODI_CONC = dr["CODI_CONC"].ToString();
                        _goDbaxInfoConcBE.ORDE_CONC = Convert.ToInt32(dr["ORDE_CONC"]);
                        _goDbaxInfoConcBE.CODI_CONC1 = dr["CODI_CONC1"].ToString();
                        _goDbaxInfoConcBE.NIVE_CONC = Convert.ToInt32(dr["NIVE_CONC"]);
                        _goDbaxInfoConcBE.NEGR_CONC = dr["NEGR_CONC"].ToString();
                    }
                }
                return _goDbaxInfoConcBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbaxInfoConc(DbaxInfoConcBE toDbaxInfoConcBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxInfoConcBE.PRC_UPDATE_DBAX_INFO_CONC);
                AddCommandParamIN("P_CODI_EMPR", CmdParamType.Integer, toDbaxInfoConcBE.CODI_EMPR);
                AddCommandParamIN("P_CODI_EMEX", CmdParamType.StringVarLen, 30, toDbaxInfoConcBE.CODI_EMEX);
                AddCommandParamIN("P_CODI_INFO", CmdParamType.StringVarLen, 50, toDbaxInfoConcBE.CODI_INFO);
                AddCommandParamIN("P_PREF_CONC", CmdParamType.StringVarLen, 50, toDbaxInfoConcBE.PREF_CONC);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 256, toDbaxInfoConcBE.CODI_CONC);
                AddCommandParamIN("P_ORDE_CONC", CmdParamType.Integer, toDbaxInfoConcBE.ORDE_CONC);
                AddCommandParamIN("P_CODI_CONC1", CmdParamType.StringVarLen, 256, toDbaxInfoConcBE.CODI_CONC1);
                AddCommandParamIN("P_NIVE_CONC", CmdParamType.Integer, toDbaxInfoConcBE.NIVE_CONC);
                AddCommandParamIN("P_NEGR_CONC", CmdParamType.StringVarLen, 1, toDbaxInfoConcBE.NEGR_CONC);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbaxInfoConc(int tnCodiEmpr, string tsCodiEmex, string tsCodiInfo, string tsPrefConc, string tsCodiConc, int tnOrdeConc)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxInfoConcBE.PRC_DELETE_DBAX_INFO_CONC);
                AddCommandParamIN("P_CODI_EMPR", CmdParamType.Integer, tnCodiEmpr);
                AddCommandParamIN("P_CODI_EMEX", CmdParamType.StringVarLen, 30, tsCodiEmex);
                AddCommandParamIN("P_CODI_INFO", CmdParamType.StringVarLen, 50, tsCodiInfo);
                AddCommandParamIN("P_PREF_CONC", CmdParamType.StringVarLen, 50, tsPrefConc);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 256, tsCodiConc);
                AddCommandParamIN("P_ORDE_CONC", CmdParamType.Integer, tnOrdeConc);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }
    }
}