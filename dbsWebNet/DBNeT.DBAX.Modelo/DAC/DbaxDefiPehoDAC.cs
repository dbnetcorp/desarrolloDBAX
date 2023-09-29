using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbaxDefiPehoDAC : BaseDAC
    {
        DbaxDefiPehoBE _goDbaxDefiPehoBE;
        DbaxDefiPersBE _goDbaxDefiPersBE;
        public DbaxDefiPehoDAC()
        { _goDbaxDefiPehoBE = new DbaxDefiPehoBE(); _goDbaxDefiPersBE = new DbaxDefiPersBE(); }

        public void createDbaxDefiPeho(DbaxDefiPehoBE toDbaxDefiPehoBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiPehoBE.PRC_CREATE_DBAX_DEFI_PEHO);
                AddCommandParamIN("P_CODI_EMEX", CmdParamType.StringVarLen, 30, toDbaxDefiPehoBE.CODI_EMEX);
                AddCommandParamIN("P_CODI_EMPR", CmdParamType.Integer, toDbaxDefiPehoBE.CODI_EMPR);
                AddCommandParamIN("P_CODI_PERS", CmdParamType.Integer, toDbaxDefiPehoBE.CODI_PERS);
                AddCommandParamIN("P_DESC_EMPR", CmdParamType.StringVarLen, 200, toDbaxDefiPehoBE.DESC_EMPR);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public DataTable readDbaxDefiPehoDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiPehoBE.PRC_READ_DBAX_DEFI_PEHO);
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

        public List<DbaxDefiPehoBE> readDbaxDefiPehoList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxDefiPehoBE> listaDbaxDefiPeho = new List<DbaxDefiPehoBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiPehoBE.PRC_READ_DBAX_DEFI_PEHO);
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
                        _goDbaxDefiPehoBE = new DbaxDefiPehoBE();
                        _goDbaxDefiPehoBE.CODI_EMEX = dr["CODI_EMEX"].ToString();
                        _goDbaxDefiPehoBE.CODI_EMPR = Convert.ToInt32(dr["CODI_EMPR"]);
                        _goDbaxDefiPehoBE.CODI_PERS = Convert.ToInt32(dr["CODI_PERS"]);
                        _goDbaxDefiPehoBE.DESC_EMPR = dr["DESC_EMPR"].ToString();
                        listaDbaxDefiPeho.Add(_goDbaxDefiPehoBE);
                    }
                }
                return listaDbaxDefiPeho;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbaxDefiPehoBE readDbaxDefiPeho(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
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
                        _goDbaxDefiPehoBE = new DbaxDefiPehoBE();
                        _goDbaxDefiPehoBE.CODI_EMEX = ts_codi_emex;
                        _goDbaxDefiPehoBE.CODI_EMPR = tn_codi_empr;
                        _goDbaxDefiPehoBE.CODI_PERS = Convert.ToInt32(dr["codi_pers"]);
                        _goDbaxDefiPehoBE.DESC_EMPR = dr["desc_peho"].ToString();
                    }
                }
                return _goDbaxDefiPehoBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbaxDefiPeho(DbaxDefiPehoBE toDbaxDefiPehoBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiPehoBE.PRC_UPDATE_DBAX_DEFI_PEHO);
                AddCommandParamIN("P_CODI_EMEX", CmdParamType.StringVarLen, 30, toDbaxDefiPehoBE.CODI_EMEX);
                AddCommandParamIN("P_CODI_EMPR", CmdParamType.Integer, toDbaxDefiPehoBE.CODI_EMPR);
                AddCommandParamIN("P_CODI_PERS", CmdParamType.Integer, toDbaxDefiPehoBE.CODI_PERS);
                AddCommandParamIN("P_DESC_EMPR", CmdParamType.StringVarLen, 200, toDbaxDefiPehoBE.DESC_EMPR);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbaxDefiPeho(int tnCodiPers, string tsCodiEmex, int tnCodiEmpr)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiPehoBE.PRC_DELETE_DBAX_DEFI_PEHO);
                AddCommandParamIN("P_CODI_PERS", CmdParamType.Integer, tnCodiPers);
                AddCommandParamIN("P_CODI_EMEX", CmdParamType.StringVarLen, 30, tsCodiEmex);
                AddCommandParamIN("P_CODI_EMPR", CmdParamType.Integer, tnCodiEmpr);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }
    }
}
