using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbaxDefiSegmDAC : BaseDAC
    {
        DbaxDefiSegmBE _goDbaxDefiSegmBE;
        public DbaxDefiSegmDAC()
        { _goDbaxDefiSegmBE = new DbaxDefiSegmBE(); }

        public void createDbaxDefiSegm(DbaxDefiSegmBE toDbaxDefiSegmBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiSegmBE.PRC_CREATE_DBAX_DEFI_SEGM);
                AddCommandParamIN("P_CODI_SEGM", CmdParamType.StringVarLen, 50, toDbaxDefiSegmBE.CODI_SEGM);
                AddCommandParamIN("P_DESC_SEGM", CmdParamType.StringVarLen, 100, toDbaxDefiSegmBE.DESC_SEGM);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public DataTable readDbaxDefiSegmDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiSegmBE.PRC_READ_DBAX_DEFI_SEGM);
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

        public List<DbaxDefiSegmBE> readDbaxDefiSegmList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxDefiSegmBE> listaDbaxDefiSegm = new List<DbaxDefiSegmBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiSegmBE.PRC_READ_DBAX_DEFI_SEGM);
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
                        _goDbaxDefiSegmBE = new DbaxDefiSegmBE();
                        _goDbaxDefiSegmBE.CODI_SEGM = dr["CODI_SEGM"].ToString();
                        _goDbaxDefiSegmBE.DESC_SEGM = dr["DESC_SEGM"].ToString();
                        listaDbaxDefiSegm.Add(_goDbaxDefiSegmBE);
                    }
                }
                return listaDbaxDefiSegm;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbaxDefiSegmBE readDbaxDefiSegm(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxDefiSegmBE> listaDbaxDefiSegm = new List<DbaxDefiSegmBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiSegmBE.PRC_READ_DBAX_DEFI_SEGM);
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
                        _goDbaxDefiSegmBE = new DbaxDefiSegmBE();
                        _goDbaxDefiSegmBE.CODI_SEGM = dr["CODI_SEGM"].ToString();
                        _goDbaxDefiSegmBE.DESC_SEGM = dr["DESC_SEGM"].ToString();
                    }
                }
                return _goDbaxDefiSegmBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbaxDefiSegm(DbaxDefiSegmBE toDbaxDefiSegmBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiSegmBE.PRC_UPDATE_DBAX_DEFI_SEGM);
                AddCommandParamIN("P_CODI_SEGM", CmdParamType.StringVarLen, 50, toDbaxDefiSegmBE.CODI_SEGM);
                AddCommandParamIN("P_DESC_SEGM", CmdParamType.StringVarLen, 100, toDbaxDefiSegmBE.DESC_SEGM);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbaxDefiSegm(string tsCodiSegm)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiSegmBE.PRC_DELETE_DBAX_DEFI_SEGM);
                AddCommandParamIN("P_CODI_SEGM", CmdParamType.StringVarLen, 50, tsCodiSegm);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }
    }
}
