using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbneDefiLangDAC : BaseDAC
    {
        DbneDefiLangBE _goDbneDefiLangBE;
        public DbneDefiLangDAC()
        { _goDbneDefiLangBE = new DbneDefiLangBE(); }

        public void createDbneDefiLang(DbneDefiLangBE toDbneDefiLangBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbneDefiLangBE.PRC_CREATE_DBNE_DEFI_LANG);
                AddCommandParamIN("P_CODI_LANG", CmdParamType.StringVarLen, 50, toDbneDefiLangBE.CODI_LANG);
                AddCommandParamIN("P_DESC_LANG", CmdParamType.StringVarLen, 100, toDbneDefiLangBE.DESC_LANG);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public DataTable readDbneDefiLangDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbneDefiLangBE.PRC_READ_DBNE_DEFI_LANG);
                AddCommandParamIN("tsTipo", CmdParamType.StringVarLen, 2, tsTipo);
                AddCommandParamIN("tnPagina", CmdParamType.Integer, tnPagina);
                AddCommandParamIN("tnRegPag", CmdParamType.Integer, tnRegPag);
                AddCommandParamIN("tsCondicion", CmdParamType.StringVarLen, 128, tsCondicion);
                AddCommandParamIN("tsPar1", CmdParamType.StringVarLen, 30, tsPar1);
                AddCommandParamIN("tsPar2", CmdParamType.StringVarLen, 30, tsPar2);
                AddCommandParamIN("tsPar3", CmdParamType.StringVarLen, 30, tsPar3);
                AddCommandParamIN("tsPar4", CmdParamType.StringVarLen, 30, tsPar4);
                AddCommandParamIN("tsPar5", CmdParamType.StringVarLen, 30, tsPar5);
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

        public List<DbneDefiLangBE> readDbneDefiLangList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbneDefiLangBE> listaDbneDefiLang = new List<DbneDefiLangBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbneDefiLangBE.PRC_READ_DBNE_DEFI_LANG);
                AddCommandParamIN("tsTipo", CmdParamType.StringVarLen, 2, tsTipo);
                AddCommandParamIN("tnPagina", CmdParamType.Integer, tnPagina);
                AddCommandParamIN("tnRegPag", CmdParamType.Integer, tnRegPag);
                AddCommandParamIN("tsCondicion", CmdParamType.StringVarLen, 128, tsCondicion);
                AddCommandParamIN("tsPar1", CmdParamType.StringVarLen, 30, tsPar1);
                AddCommandParamIN("tsPar2", CmdParamType.StringVarLen, 30, tsPar2);
                AddCommandParamIN("tsPar3", CmdParamType.StringVarLen, 30, tsPar3);
                AddCommandParamIN("tsPar4", CmdParamType.StringVarLen, 30, tsPar4);
                AddCommandParamIN("tsPar5", CmdParamType.StringVarLen, 30, tsPar5);
                AddCommandParamIN("p_codi_usua", CmdParamType.StringVarLen, 30, ts_codi_usua);
                AddCommandParamIN("p_codi_empr", CmdParamType.Integer, tn_codi_empr);
                AddCommandParamIN("p_codi_emex", CmdParamType.StringVarLen, 30, ts_codi_emex);
                AddCommandParamCursor("P_CURSOR");
                DataTable dt = this.ExecuteQueryCmdTable();

                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        _goDbneDefiLangBE = new DbneDefiLangBE();
                        _goDbneDefiLangBE.CODI_LANG = dr["CODI_LANG"].ToString();
                        _goDbneDefiLangBE.DESC_LANG = dr["DESC_LANG"].ToString();
                        listaDbneDefiLang.Add(_goDbneDefiLangBE);
                    }
                }
                return listaDbneDefiLang;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbneDefiLangBE readDbneDefiLang(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbneDefiLangBE> listaDbneDefiLang = new List<DbneDefiLangBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbneDefiLangBE.PRC_READ_DBNE_DEFI_LANG);
                AddCommandParamIN("tsTipo", CmdParamType.StringVarLen, 2, tsTipo);
                AddCommandParamIN("tnPagina", CmdParamType.Integer, tnPagina);
                AddCommandParamIN("tnRegPag", CmdParamType.Integer, tnRegPag);
                AddCommandParamIN("tsCondicion", CmdParamType.StringVarLen, 128, tsCondicion);
                AddCommandParamIN("tsPar1", CmdParamType.StringVarLen, 30, tsPar1);
                AddCommandParamIN("tsPar2", CmdParamType.StringVarLen, 30, tsPar2);
                AddCommandParamIN("tsPar3", CmdParamType.StringVarLen, 30, tsPar3);
                AddCommandParamIN("tsPar4", CmdParamType.StringVarLen, 30, tsPar4);
                AddCommandParamIN("tsPar5", CmdParamType.StringVarLen, 30, tsPar5);
                AddCommandParamIN("p_codi_usua", CmdParamType.StringVarLen, 30, ts_codi_usua);
                AddCommandParamIN("p_codi_empr", CmdParamType.Integer, tn_codi_empr);
                AddCommandParamIN("p_codi_emex", CmdParamType.StringVarLen, 30, ts_codi_emex);
                AddCommandParamCursor("P_CURSOR");
                DataTable dt = this.ExecuteQueryCmdTable();

                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        _goDbneDefiLangBE = new DbneDefiLangBE();
                        _goDbneDefiLangBE.CODI_LANG = dr["CODI_LANG"].ToString();
                        _goDbneDefiLangBE.DESC_LANG = dr["DESC_LANG"].ToString();
                    }
                }
                return _goDbneDefiLangBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbneDefiLang(DbneDefiLangBE toDbneDefiLangBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbneDefiLangBE.PRC_UPDATE_DBNE_DEFI_LANG);
                AddCommandParamIN("P_CODI_LANG", CmdParamType.StringVarLen, 50, toDbneDefiLangBE.CODI_LANG);
                AddCommandParamIN("P_DESC_LANG", CmdParamType.StringVarLen, 100, toDbneDefiLangBE.DESC_LANG);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbneDefiLang(string tsCodiLang)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbneDefiLangBE.PRC_DELETE_DBNE_DEFI_LANG);
                AddCommandParamIN("P_CODI_LANG", CmdParamType.StringVarLen, 50, tsCodiLang);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }
    }
}
