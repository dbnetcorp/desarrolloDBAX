using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DBNeT.Framework.Conector;
using DBNeT.DBAX.Modelo.BE;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class DbaxDefiGrupDAC : BaseDAC
    {
        DbaxDefiGrupBE _goDbaxDefiGrupBE;
        public DbaxDefiGrupDAC()
        { _goDbaxDefiGrupBE = new DbaxDefiGrupBE(); }

        public void createDbaxDefiGrup(DbaxDefiGrupBE toDbaxDefiGrupBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiGrupBE.PRC_CREATE_DBAX_DEFI_GRUP);
                AddCommandParamIN("P_CODI_GRUP", CmdParamType.StringVarLen, 50, toDbaxDefiGrupBE.CODI_GRUP);
                AddCommandParamIN("P_DESC_GRUP", CmdParamType.StringVarLen, 100, toDbaxDefiGrupBE.DESC_GRUP);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public DataTable readDbaxDefiGrupDt(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
             try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiGrupBE.PRC_READ_DBAX_DEFI_GRUP);
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

        public List<DbaxDefiGrupBE> readDbaxDefiGrupList(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxDefiGrupBE> listaDbaxDefiGrup = new List<DbaxDefiGrupBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiGrupBE.PRC_READ_DBAX_DEFI_GRUP);
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
                        _goDbaxDefiGrupBE = new DbaxDefiGrupBE();
                        _goDbaxDefiGrupBE.CODI_GRUP = dr["CODI_GRUP"].ToString();
                        _goDbaxDefiGrupBE.DESC_GRUP = dr["DESC_GRUP"].ToString();
                        listaDbaxDefiGrup.Add(_goDbaxDefiGrupBE);
                    }
                }
                return listaDbaxDefiGrup;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public DbaxDefiGrupBE readDbaxDefiGrup(string tsTipo, int tnPagina, int tnRegPag, string tsCondicion, string tsPar1, string tsPar2, string tsPar3, string tsPar4, string tsPar5, string ts_codi_usua, int tn_codi_empr, string ts_codi_emex)
        {
            List<DbaxDefiGrupBE> listaDbaxDefiGrup = new List<DbaxDefiGrupBE>();
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiGrupBE.PRC_READ_DBAX_DEFI_GRUP);
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
                        _goDbaxDefiGrupBE = new DbaxDefiGrupBE();
                        _goDbaxDefiGrupBE.CODI_GRUP = dr["CODI_GRUP"].ToString();
                        _goDbaxDefiGrupBE.DESC_GRUP = dr["DESC_GRUP"].ToString();
                    }
                }
                return _goDbaxDefiGrupBE;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        public void updateDbaxDefiGrup(DbaxDefiGrupBE toDbaxDefiGrupBE)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiGrupBE.PRC_UPDATE_DBAX_DEFI_GRUP);
                AddCommandParamIN("P_CODI_GRUP", CmdParamType.StringVarLen, 50, toDbaxDefiGrupBE.CODI_GRUP);
                AddCommandParamIN("P_DESC_GRUP", CmdParamType.StringVarLen, 100, toDbaxDefiGrupBE.DESC_GRUP);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }

        public void deleteDbaxDefiGrup(string tsCodiGrup)
        {
            try
            {
                OpenConnection();
                CreateCommand(_goDbaxDefiGrupBE.PRC_DELETE_DBAX_DEFI_GRUP);
                AddCommandParamIN("P_CODI_GRUP", CmdParamType.StringVarLen, 50, tsCodiGrup);
                this.ExecuteNonQuery();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { DisposeCmd(); }
        }
    }
}