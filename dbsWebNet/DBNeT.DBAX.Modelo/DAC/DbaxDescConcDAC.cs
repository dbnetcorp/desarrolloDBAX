using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbaxDescConcDAC : BaseDAC
    {
        DbaxDescConcBE _goDbaxDescConcBE;
        public DbaxDescConcDAC()
        { _goDbaxDescConcBE = new DbaxDescConcBE(); }

        public void createDbaxDescConc(DbaxDescConcBE toDbaxDescConcBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDescConcBE.PRC_CREATE_DBAX_DESC_CONC);
                AddCommandParamIN("P_PREF_CONC", CmdParamType.StringVarLen, 50, toDbaxDescConcBE.PREF_CONC);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 256, toDbaxDescConcBE.CODI_CONC);
                AddCommandParamIN("P_CODI_LANG", CmdParamType.StringVarLen, 50, toDbaxDescConcBE.CODI_LANG);
                AddCommandParamIN("P_DESC_CONC", CmdParamType.StringVarLen, 512, toDbaxDescConcBE.DESC_CONC);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public DataTable readDbaxDescConcDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbaxDescConcBE.PRC_READ_DBAX_DESC_CONC);
                AddCommandParamIN("tsTipo", CmdParamType.StringVarLen, 2, tsTipo);
                AddCommandParamIN("tnPagina", CmdParamType.Integer, tnPagina);
                AddCommandParamIN("tnRegPag", CmdParamType.Integer, tnRegPag);
                AddCommandParamIN("tsCondicion",CmdParamType.StringVarLen, 2048, tsCondicion);
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

        public List<DbaxDescConcBE> readDbaxDescConcList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxDescConcBE> listaDbaxDescConc = new List<DbaxDescConcBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDescConcBE.PRC_READ_DBAX_DESC_CONC);
                AddCommandParamIN("tsTipo", CmdParamType.StringVarLen, 2, tsTipo);
                AddCommandParamIN("tnPagina", CmdParamType.Integer, tnPagina);
                AddCommandParamIN("tnRegPag", CmdParamType.Integer, tnRegPag);
                AddCommandParamIN("tsCondicion",CmdParamType.StringVarLen, 2048, tsCondicion);
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
                        _goDbaxDescConcBE = new DbaxDescConcBE();
                        _goDbaxDescConcBE.PREF_CONC = dr["PREF_CONC"].ToString();
                        _goDbaxDescConcBE.CODI_CONC = dr["CODI_CONC"].ToString();
                        _goDbaxDescConcBE.CODI_LANG = dr["CODI_LANG"].ToString();
                        _goDbaxDescConcBE.DESC_CONC = dr["DESC_CONC"].ToString();
                        listaDbaxDescConc.Add(_goDbaxDescConcBE);
                    }
                }
                return listaDbaxDescConc;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbaxDescConcBE readDbaxDescConc(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxDescConcBE> listaDbaxDescConc = new List<DbaxDescConcBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDescConcBE.PRC_READ_DBAX_DESC_CONC);
                AddCommandParamIN("tsTipo", CmdParamType.StringVarLen, 2, tsTipo);
                AddCommandParamIN("tnPagina", CmdParamType.Integer, tnPagina);
                AddCommandParamIN("tnRegPag", CmdParamType.Integer, tnRegPag);
                AddCommandParamIN("tsCondicion",CmdParamType.StringVarLen, 2048, tsCondicion);
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
                        _goDbaxDescConcBE = new DbaxDescConcBE();
                        _goDbaxDescConcBE.PREF_CONC = dr["PREF_CONC"].ToString();
                        _goDbaxDescConcBE.CODI_CONC = dr["CODI_CONC"].ToString();
                        _goDbaxDescConcBE.CODI_LANG = dr["CODI_LANG"].ToString();
                        _goDbaxDescConcBE.DESC_CONC = dr["DESC_CONC"].ToString();
                    }
                }
                return _goDbaxDescConcBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbaxDescConc(DbaxDescConcBE toDbaxDescConcBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDescConcBE.PRC_UPDATE_DBAX_DESC_CONC);
                AddCommandParamIN("P_PREF_CONC", CmdParamType.StringVarLen, 50, toDbaxDescConcBE.PREF_CONC);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 256, toDbaxDescConcBE.CODI_CONC);
                AddCommandParamIN("P_CODI_LANG", CmdParamType.StringVarLen, 50, toDbaxDescConcBE.CODI_LANG);
                AddCommandParamIN("P_DESC_CONC", CmdParamType.StringVarLen, 512, toDbaxDescConcBE.DESC_CONC);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbaxDescConc(string tsCodiConc, string tsCodiLang, string tsPrefConc)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDescConcBE.PRC_DELETE_DBAX_DESC_CONC);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 256, tsCodiConc);
                AddCommandParamIN("P_CODI_LANG", CmdParamType.StringVarLen, 50, tsCodiLang);
                AddCommandParamIN("P_PREF_CONC", CmdParamType.StringVarLen, 50, tsPrefConc);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }
    }
}
