using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbaxHomoConcDAC : BaseDAC
    {
        DbaxHomoConcBE _goDbaxHomoConcBE;
        public DbaxHomoConcDAC()
        { _goDbaxHomoConcBE = new DbaxHomoConcBE(); }

        public void createDbaxHomoConc(DbaxHomoConcBE toDbaxHomoConcBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxHomoConcBE.PRC_CREATE_DBAX_HOMO_CONC);
                AddCommandParamIN("P_TIPO_TAXO", CmdParamType.StringVarLen, 10, toDbaxHomoConcBE.TIPO_TAXO);
                AddCommandParamIN("P_PREF_CONC", CmdParamType.StringVarLen, 50, toDbaxHomoConcBE.PREF_CONC);
                AddCommandParamIN("P_VERS_TAXO", CmdParamType.StringVarLen, 256, toDbaxHomoConcBE.VERS_TAXO);
                AddCommandParamIN("P_VERS_TAXO_DEST", CmdParamType.StringVarLen, 256, toDbaxHomoConcBE.VERS_TAXO_DEST);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public DataTable readDbaxHomoConcDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbaxHomoConcBE.PRC_READ_DBAX_HOMO_CONC);
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

        public List<DbaxHomoConcBE> readDbaxHomoConcList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxHomoConcBE> listaDbaxHomoConc = new List<DbaxHomoConcBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxHomoConcBE.PRC_READ_DBAX_HOMO_CONC);
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
                        _goDbaxHomoConcBE = new DbaxHomoConcBE();
                        _goDbaxHomoConcBE.CODI_HOCO = Convert.ToInt32(dr["CODI_HOCO"]);
                        _goDbaxHomoConcBE.TIPO_TAXO = dr["TIPO_TAXO"].ToString();
                        _goDbaxHomoConcBE.PREF_CONC = dr["PREF_CONC"].ToString();
                        _goDbaxHomoConcBE.VERS_TAXO = dr["VERS_TAXO"].ToString();
                        _goDbaxHomoConcBE.VERS_TAXO_DEST = dr["VERS_TAXO_DEST"].ToString();
                        _goDbaxHomoConcBE.FECH_HOCO = Convert.ToDateTime(dr["FECH_HOCO"]);
                        listaDbaxHomoConc.Add(_goDbaxHomoConcBE);
                    }
                }
                return listaDbaxHomoConc;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbaxHomoConcBE readDbaxHomoConc(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxHomoConcBE> listaDbaxHomoConc = new List<DbaxHomoConcBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxHomoConcBE.PRC_READ_DBAX_HOMO_CONC);
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
                        _goDbaxHomoConcBE = new DbaxHomoConcBE();
                        _goDbaxHomoConcBE.CODI_HOCO = Convert.ToInt32(dr["CODI_HOCO"]);
                        _goDbaxHomoConcBE.TIPO_TAXO = dr["TIPO_TAXO"].ToString();
                        _goDbaxHomoConcBE.PREF_CONC = dr["PREF_CONC"].ToString();
                        _goDbaxHomoConcBE.VERS_TAXO = dr["VERS_TAXO"].ToString();
                        _goDbaxHomoConcBE.VERS_TAXO_DEST = dr["VERS_TAXO_DEST"].ToString();
                        _goDbaxHomoConcBE.FECH_HOCO = Convert.ToDateTime(dr["FECH_HOCO"]);
                    }
                }
                return _goDbaxHomoConcBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbaxHomoConc(DbaxHomoConcBE toDbaxHomoConcBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxHomoConcBE.PRC_UPDATE_DBAX_HOMO_CONC);
                AddCommandParamIN("P_CODI_HOCO", CmdParamType.Integer, toDbaxHomoConcBE.CODI_HOCO);
                AddCommandParamIN("P_TIPO_TAXO", CmdParamType.StringVarLen, 10, toDbaxHomoConcBE.TIPO_TAXO);
                AddCommandParamIN("P_PREF_CONC", CmdParamType.StringVarLen, 50, toDbaxHomoConcBE.PREF_CONC);
                AddCommandParamIN("P_VERS_TAXO", CmdParamType.StringVarLen, 256, toDbaxHomoConcBE.VERS_TAXO);
                AddCommandParamIN("P_VERS_TAXO_DEST", CmdParamType.StringVarLen, 256, toDbaxHomoConcBE.VERS_TAXO_DEST);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbaxHomoConc(int tnCodiHoco)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxHomoConcBE.PRC_DELETE_DBAX_HOMO_CONC);
                AddCommandParamIN("P_CODI_HOCO", CmdParamType.Integer, tnCodiHoco);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void ejecutarHomologacion(string tsTipoTaxo, string tsPrefConc, DateTime tdFeinProc)
        {
            try
            {
                OpenConnection();
                CreateCommand("prc_dbax_proc_homo");
                AddCommandParamIN("p_tipo_taxo", CmdParamType.StringVarLen, 10, tsTipoTaxo);
                AddCommandParamIN("p_pref_conc", CmdParamType.StringVarLen, 10, tsPrefConc);
                AddCommandParamIN("p_fein_proc", CmdParamType.DateTime, tdFeinProc);
                AddCommandParamOUT("p_erro", CmdParamType.StringVarLen, 30);
                AddCommandParamOUT("p_mens", CmdParamType.StringVarLen, 250);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }
    }
}