using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbaxDefiConcDAC : BaseDAC
    {
        DbaxDefiConcBE _goDbaxDefiConcBE;
        public DbaxDefiConcDAC()
        { _goDbaxDefiConcBE = new DbaxDefiConcBE(); }

        public void createDbaxDefiConc(DbaxDefiConcBE toDbaxDefiConcBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiConcBE.PRC_CREATE_DBAX_DEFI_CONC);
                AddCommandParamIN("P_PREF_CONC", CmdParamType.StringVarLen, 50, toDbaxDefiConcBE.PREF_CONC);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 256, toDbaxDefiConcBE.CODI_CONC);
                AddCommandParamIN("P_TIPO_CONC", CmdParamType.StringVarLen, 20, toDbaxDefiConcBE.TIPO_CONC);
                AddCommandParamIN("P_TIPO_PERI", CmdParamType.StringVarLen, 15, toDbaxDefiConcBE.TIPO_PERI);
                AddCommandParamIN("P_TIPO_VALO", CmdParamType.StringVarLen, 256, toDbaxDefiConcBE.TIPO_VALO);
                AddCommandParamIN("P_TIPO_CUEN", CmdParamType.StringVarLen, 10, toDbaxDefiConcBE.TIPO_CUEN);
                AddCommandParamIN("P_CODI_NUME", CmdParamType.StringVarLen, 25, toDbaxDefiConcBE.CODI_NUME);
                AddCommandParamIN("P_TIPO_TAXO", CmdParamType.StringVarLen, 10, toDbaxDefiConcBE.TIPO_TAXO);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public DataTable readDbaxDefiConcDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiConcBE.PRC_READ_DBAX_DEFI_CONC);
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

        public List<DbaxDefiConcBE> readDbaxDefiConcList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxDefiConcBE> listaDbaxDefiConc = new List<DbaxDefiConcBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiConcBE.PRC_READ_DBAX_DEFI_CONC);
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
                        _goDbaxDefiConcBE = new DbaxDefiConcBE();
                        _goDbaxDefiConcBE.PREF_CONC = dr["PREF_CONC"].ToString();
                        _goDbaxDefiConcBE.CODI_CONC = dr["CODI_CONC"].ToString();
                        _goDbaxDefiConcBE.TIPO_CONC = dr["TIPO_CONC"].ToString();
                        _goDbaxDefiConcBE.TIPO_PERI = dr["TIPO_PERI"].ToString();
                        _goDbaxDefiConcBE.TIPO_VALO = dr["TIPO_VALO"].ToString();
                        _goDbaxDefiConcBE.TIPO_CUEN = dr["TIPO_CUEN"].ToString();
                        _goDbaxDefiConcBE.CODI_NUME = dr["CODI_NUME"].ToString();
                        _goDbaxDefiConcBE.TIPO_TAXO = dr["TIPO_TAXO"].ToString();
                        listaDbaxDefiConc.Add(_goDbaxDefiConcBE);
                    }
                }
                return listaDbaxDefiConc;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbaxDefiConcBE readDbaxDefiConc(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiConcBE.PRC_READ_DBAX_DEFI_CONC);
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
                        _goDbaxDefiConcBE = new DbaxDefiConcBE();
                        _goDbaxDefiConcBE.PREF_CONC = dr["PREF_CONC"].ToString();
                        _goDbaxDefiConcBE.CODI_CONC = dr["CODI_CONC"].ToString();
                        _goDbaxDefiConcBE.TIPO_CONC = dr["TIPO_CONC"].ToString();
                        _goDbaxDefiConcBE.TIPO_PERI = dr["TIPO_PERI"].ToString();
                        _goDbaxDefiConcBE.TIPO_VALO = dr["TIPO_VALO"].ToString();
                        _goDbaxDefiConcBE.TIPO_CUEN = dr["TIPO_CUEN"].ToString();
                        _goDbaxDefiConcBE.CODI_NUME = dr["CODI_NUME"].ToString();
                        _goDbaxDefiConcBE.TIPO_TAXO = dr["TIPO_TAXO"].ToString();
                    }
                }
                return _goDbaxDefiConcBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbaxDefiConc(DbaxDefiConcBE toDbaxDefiConcBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiConcBE.PRC_UPDATE_DBAX_DEFI_CONC);
                AddCommandParamIN("P_PREF_CONC", CmdParamType.StringVarLen, 50, toDbaxDefiConcBE.PREF_CONC);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 256, toDbaxDefiConcBE.CODI_CONC);
                AddCommandParamIN("P_TIPO_CONC", CmdParamType.StringVarLen, 20, toDbaxDefiConcBE.TIPO_CONC);
                AddCommandParamIN("P_TIPO_PERI", CmdParamType.StringVarLen, 15, toDbaxDefiConcBE.TIPO_PERI);
                AddCommandParamIN("P_TIPO_VALO", CmdParamType.StringVarLen, 256, toDbaxDefiConcBE.TIPO_VALO);
                AddCommandParamIN("P_TIPO_CUEN", CmdParamType.StringVarLen, 10, toDbaxDefiConcBE.TIPO_CUEN);
                AddCommandParamIN("P_CODI_NUME", CmdParamType.StringVarLen, 25, toDbaxDefiConcBE.CODI_NUME);
                AddCommandParamIN("P_TIPO_TAXO", CmdParamType.StringVarLen, 10, toDbaxDefiConcBE.TIPO_TAXO);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbaxDefiConc(string tsCodiConc, string tsPrefConc)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiConcBE.PRC_DELETE_DBAX_DEFI_CONC);
                AddCommandParamIN("P_CODI_CONC", CmdParamType.StringVarLen, 256, tsCodiConc);
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