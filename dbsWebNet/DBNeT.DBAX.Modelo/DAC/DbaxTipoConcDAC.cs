using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbaxTipoConcDAC : BaseDAC
    {
        DbaxTipoConcBE _goDbaxTipoConcBE;
        public DbaxTipoConcDAC()
        { _goDbaxTipoConcBE = new DbaxTipoConcBE(); }

        public void createDbaxTipoConc(DbaxTipoConcBE toDbaxTipoConcBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTipoConcBE.PRC_CREATE_DBAX_TIPO_CONC);
                AddCommandParamIN("P_TIPO_CONC", CmdParamType.StringVarLen, 20, toDbaxTipoConcBE.TIPO_CONC);
                AddCommandParamIN("P_DESC_CONC", CmdParamType.StringVarLen, 100, toDbaxTipoConcBE.DESC_CONC);
                AddCommandParamIN("P_TIPO_ELEM", CmdParamType.StringVarLen, 20, toDbaxTipoConcBE.TIPO_ELEM);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public DataTable readDbaxTipoConcDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbaxTipoConcBE.PRC_READ_DBAX_TIPO_CONC);
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

        public List<DbaxTipoConcBE> readDbaxTipoConcList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxTipoConcBE> listaDbaxTipoConc = new List<DbaxTipoConcBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTipoConcBE.PRC_READ_DBAX_TIPO_CONC);
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
                        _goDbaxTipoConcBE = new DbaxTipoConcBE();
                        _goDbaxTipoConcBE.TIPO_CONC = dr["TIPO_CONC"].ToString();
                        _goDbaxTipoConcBE.DESC_CONC = dr["DESC_CONC"].ToString();
                        _goDbaxTipoConcBE.TIPO_ELEM = dr["TIPO_ELEM"].ToString();
                        listaDbaxTipoConc.Add(_goDbaxTipoConcBE);
                    }
                }
                return listaDbaxTipoConc;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbaxTipoConcBE readDbaxTipoConc(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxTipoConcBE> listaDbaxTipoConc = new List<DbaxTipoConcBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTipoConcBE.PRC_READ_DBAX_TIPO_CONC);
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
                        _goDbaxTipoConcBE = new DbaxTipoConcBE();
                        _goDbaxTipoConcBE.TIPO_CONC = dr["TIPO_CONC"].ToString();
                        _goDbaxTipoConcBE.DESC_CONC = dr["DESC_CONC"].ToString();
                        _goDbaxTipoConcBE.TIPO_ELEM = dr["TIPO_ELEM"].ToString();
                    }
                }
                return _goDbaxTipoConcBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbaxTipoConc(DbaxTipoConcBE toDbaxTipoConcBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTipoConcBE.PRC_UPDATE_DBAX_TIPO_CONC);
                AddCommandParamIN("P_TIPO_CONC", CmdParamType.StringVarLen, 20, toDbaxTipoConcBE.TIPO_CONC);
                AddCommandParamIN("P_DESC_CONC", CmdParamType.StringVarLen, 100, toDbaxTipoConcBE.DESC_CONC);
                AddCommandParamIN("P_TIPO_ELEM", CmdParamType.StringVarLen, 20, toDbaxTipoConcBE.TIPO_ELEM);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbaxTipoConc(string tsTipoConc)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTipoConcBE.PRC_DELETE_DBAX_TIPO_CONC);
                AddCommandParamIN("P_TIPO_CONC", CmdParamType.StringVarLen, 20, tsTipoConc);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }
    }
}
