using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbaxHomoDetaDAC : BaseDAC
    {
        DbaxHomoDetaBE _goDbaxHomoDetaBE;
        public DbaxHomoDetaDAC()
        { _goDbaxHomoDetaBE = new DbaxHomoDetaBE(); }

        public void createDbaxHomoDeta(DbaxHomoDetaBE toDbaxHomoDetaBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxHomoDetaBE.PRC_CREATE_DBAX_HOMO_DETA);
                AddCommandParamIN("P_CODI_HOCO", CmdParamType.Integer, toDbaxHomoDetaBE.CODI_HOCO);
                AddCommandParamIN("P_PREF_CONC", CmdParamType.StringVarLen, 50, toDbaxHomoDetaBE.PREF_CONC);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 256, toDbaxHomoDetaBE.CODI_CONC);
                AddCommandParamIN("P_PREF_CONC1", CmdParamType.StringVarLen, 50, toDbaxHomoDetaBE.PREF_CONC1);
                AddCommandParamIN("P_CODI_CONC1", CmdParamType.StringVarLen, 256, toDbaxHomoDetaBE.CODI_CONC1);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public DataTable readDbaxHomoDetaDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbaxHomoDetaBE.PRC_READ_DBAX_HOMO_DETA);
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

        public List<DbaxHomoDetaBE> readDbaxHomoDetaList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxHomoDetaBE> listaDbaxHomoDeta = new List<DbaxHomoDetaBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxHomoDetaBE.PRC_READ_DBAX_HOMO_DETA);
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
                        _goDbaxHomoDetaBE = new DbaxHomoDetaBE();
                        _goDbaxHomoDetaBE.CODI_HOCO = Convert.ToInt32(dr["CODI_HOCO"]);
                        _goDbaxHomoDetaBE.PREF_CONC = dr["PREF_CONC"].ToString();
                        _goDbaxHomoDetaBE.CODI_CONC = dr["CODI_CONC"].ToString();
                        _goDbaxHomoDetaBE.PREF_CONC1 = dr["PREF_CONC1"].ToString();
                        _goDbaxHomoDetaBE.CODI_CONC1 = dr["CODI_CONC1"].ToString();
                        listaDbaxHomoDeta.Add(_goDbaxHomoDetaBE);
                    }
                }
                return listaDbaxHomoDeta;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbaxHomoDetaBE readDbaxHomoDeta(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxHomoDetaBE> listaDbaxHomoDeta = new List<DbaxHomoDetaBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxHomoDetaBE.PRC_READ_DBAX_HOMO_DETA);
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
                        _goDbaxHomoDetaBE = new DbaxHomoDetaBE();
                        _goDbaxHomoDetaBE.CODI_HOCO = Convert.ToInt32(dr["CODI_HOCO"]);
                        _goDbaxHomoDetaBE.PREF_CONC = dr["PREF_CONC"].ToString();
                        _goDbaxHomoDetaBE.CODI_CONC = dr["CODI_CONC"].ToString();
                        _goDbaxHomoDetaBE.PREF_CONC1 = dr["PREF_CONC1"].ToString();
                        _goDbaxHomoDetaBE.CODI_CONC1 = dr["CODI_CONC1"].ToString();
                    }
                }
                return _goDbaxHomoDetaBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbaxHomoDeta(DbaxHomoDetaBE toDbaxHomoDetaBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxHomoDetaBE.PRC_UPDATE_DBAX_HOMO_DETA);
                AddCommandParamIN("P_CODI_HOCO", CmdParamType.Integer, toDbaxHomoDetaBE.CODI_HOCO);
                AddCommandParamIN("P_PREF_CONC", CmdParamType.StringVarLen, 50, toDbaxHomoDetaBE.PREF_CONC);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 256, toDbaxHomoDetaBE.CODI_CONC);
                AddCommandParamIN("P_PREF_CONC1", CmdParamType.StringVarLen, 50, toDbaxHomoDetaBE.PREF_CONC1);
                AddCommandParamIN("P_CODI_CONC1", CmdParamType.StringVarLen, 256, toDbaxHomoDetaBE.CODI_CONC1);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbaxHomoDeta(int tnCodiHoco, string tsPrefConc, string tsCodiConc, string tsPrefConc1, string tsCodiConc1)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxHomoDetaBE.PRC_DELETE_DBAX_HOMO_DETA);
                AddCommandParamIN("P_CODI_HOCO", CmdParamType.Integer, tnCodiHoco);
                AddCommandParamIN("P_PREF_CONC", CmdParamType.StringVarLen, 50, tsPrefConc);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 256, tsCodiConc);
                AddCommandParamIN("P_PREF_CONC1", CmdParamType.StringVarLen, 50, tsPrefConc1);
                AddCommandParamIN("P_CODI_CONC1", CmdParamType.StringVarLen, 256, tsCodiConc1);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }
    }
}
