using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbaxTaxoVersDAC : BaseDAC
    {
        DbaxTaxoVersBE _goDbaxTaxoVersBE;
        public DbaxTaxoVersDAC()
        { _goDbaxTaxoVersBE = new DbaxTaxoVersBE(); }

        public void createDbaxTaxoVers(DbaxTaxoVersBE toDbaxTaxoVersBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTaxoVersBE.PRC_CREATE_DBAX_TAXO_VERS);
                AddCommandParamIN("P_VERS_TAXO", CmdParamType.StringVarLen, 256, toDbaxTaxoVersBE.VERS_TAXO);
                AddCommandParamIN("P_UBIC_TAXO", CmdParamType.StringVarLen, 256, toDbaxTaxoVersBE.UBIC_TAXO);
                AddCommandParamIN("P_TIPO_TAXO", CmdParamType.StringVarLen, 4, toDbaxTaxoVersBE.TIPO_TAXO);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public DataTable readDbaxTaxoVersDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbaxTaxoVersBE.PRC_READ_DBAX_TAXO_VERS);
                AddCommandParamIN("tsTipo", CmdParamType.StringVarLen, 2, tsTipo);
                AddCommandParamIN("tnPagina", CmdParamType.Integer, tnPagina);
                AddCommandParamIN("tnRegPag", CmdParamType.Integer, tnRegPag);
                AddCommandParamIN("tsCondicion", CmdParamType.StringVarLen, 2048, tsCondicion);
                AddCommandParamIN("tsPar1", CmdParamType.StringVarLen, 256, tsPar1);
                AddCommandParamCursor("P_CURSOR");

                DataTable dt = this.ExecuteQueryCmdTable();
                return dt;
            }
             catch (Exception ex)
             { throw ex; }
             finally
             { CloseConnection(); }
        }

        public List<DbaxTaxoVersBE> readDbaxTaxoVersList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxTaxoVersBE> listaDbaxTaxoVers = new List<DbaxTaxoVersBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTaxoVersBE.PRC_READ_DBAX_TAXO_VERS);
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
                        _goDbaxTaxoVersBE = new DbaxTaxoVersBE();
                        _goDbaxTaxoVersBE.VERS_TAXO = dr["VERS_TAXO"].ToString();
                        _goDbaxTaxoVersBE.UBIC_TAXO = dr["UBIC_TAXO"].ToString();
                        _goDbaxTaxoVersBE.TIPO_TAXO = dr["TIPO_TAXO"].ToString();
                        listaDbaxTaxoVers.Add(_goDbaxTaxoVersBE);
                    }
                }
                return listaDbaxTaxoVers;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbaxTaxoVersBE readDbaxTaxoVers(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTaxoVersBE.PRC_READ_DBAX_TAXO_VERS);
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
                        _goDbaxTaxoVersBE = new DbaxTaxoVersBE();
                        _goDbaxTaxoVersBE.VERS_TAXO = dr["VERS_TAXO"].ToString();
                        _goDbaxTaxoVersBE.UBIC_TAXO = dr["UBIC_TAXO"].ToString();
                        _goDbaxTaxoVersBE.TIPO_TAXO = dr["TIPO_TAXO"].ToString();
                    }
                }
                return _goDbaxTaxoVersBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbaxTaxoVers(DbaxTaxoVersBE toDbaxTaxoVersBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTaxoVersBE.PRC_UPDATE_DBAX_TAXO_VERS);
                AddCommandParamIN("P_VERS_TAXO", CmdParamType.StringVarLen, 256, toDbaxTaxoVersBE.VERS_TAXO);
                AddCommandParamIN("P_UBIC_TAXO", CmdParamType.StringVarLen, 256, toDbaxTaxoVersBE.UBIC_TAXO);
                AddCommandParamIN("P_TIPO_TAXO", CmdParamType.StringVarLen, 4, toDbaxTaxoVersBE.TIPO_TAXO);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbaxTaxoVers(string tsVersTaxo)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxTaxoVersBE.PRC_DELETE_DBAX_TAXO_VERS);
                AddCommandParamIN("P_VERS_TAXO", CmdParamType.StringVarLen, 256, tsVersTaxo);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }
    }
}