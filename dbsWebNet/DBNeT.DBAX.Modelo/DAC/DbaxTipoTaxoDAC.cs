using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbaxTipoTaxoDAC : BaseDAC
    {
        DbaxTipoTaxoBE _goDbaxTipoTaxoBE;
        public DbaxTipoTaxoDAC()
        { _goDbaxTipoTaxoBE = new DbaxTipoTaxoBE(); }

        public void createDbaxTipoTaxo(DbaxTipoTaxoBE toDbaxTipoTaxoBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTipoTaxoBE.PRC_CREATE_DBAX_TIPO_TAXO);
                AddCommandParamIN("P_TIPO_TAXO", CmdParamType.StringVarLen, 10, toDbaxTipoTaxoBE.TIPO_TAXO);
                AddCommandParamIN("P_DESC_TIPO", CmdParamType.StringVarLen, 50, toDbaxTipoTaxoBE.DESC_TIPO);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public DataTable readDbaxTipoTaxoDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbaxTipoTaxoBE.PRC_READ_DBAX_TIPO_TAXO);
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

        public List<DbaxTipoTaxoBE> readDbaxTipoTaxoList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxTipoTaxoBE> listaDbaxTipoTaxo = new List<DbaxTipoTaxoBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTipoTaxoBE.PRC_READ_DBAX_TIPO_TAXO);
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
                        _goDbaxTipoTaxoBE = new DbaxTipoTaxoBE();
                        _goDbaxTipoTaxoBE.TIPO_TAXO = dr["TIPO_TAXO"].ToString();
                        _goDbaxTipoTaxoBE.DESC_TIPO = dr["DESC_TIPO"].ToString();
                        listaDbaxTipoTaxo.Add(_goDbaxTipoTaxoBE);
                    }
                }
                return listaDbaxTipoTaxo;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbaxTipoTaxoBE readDbaxTipoTaxo(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxTipoTaxoBE> listaDbaxTipoTaxo = new List<DbaxTipoTaxoBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTipoTaxoBE.PRC_READ_DBAX_TIPO_TAXO);
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
                        _goDbaxTipoTaxoBE = new DbaxTipoTaxoBE();
                        _goDbaxTipoTaxoBE.TIPO_TAXO = dr["TIPO_TAXO"].ToString();
                        _goDbaxTipoTaxoBE.DESC_TIPO = dr["DESC_TIPO"].ToString();
                    }
                }
                return _goDbaxTipoTaxoBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbaxTipoTaxo(DbaxTipoTaxoBE toDbaxTipoTaxoBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTipoTaxoBE.PRC_UPDATE_DBAX_TIPO_TAXO);
                AddCommandParamIN("P_TIPO_TAXO", CmdParamType.StringVarLen, 10, toDbaxTipoTaxoBE.TIPO_TAXO);
                AddCommandParamIN("P_DESC_TIPO", CmdParamType.StringVarLen, 50, toDbaxTipoTaxoBE.DESC_TIPO);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbaxTipoTaxo(string tsTipoTaxo)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTipoTaxoBE.PRC_DELETE_DBAX_TIPO_TAXO);
                AddCommandParamIN("P_TIPO_TAXO", CmdParamType.StringVarLen, 10, tsTipoTaxo);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }
    }
}
