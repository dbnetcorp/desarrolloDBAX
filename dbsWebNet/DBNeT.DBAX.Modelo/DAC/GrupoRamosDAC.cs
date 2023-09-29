using System;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;
using DBNeT.Framework.Conector;
using DBNeT.Framework.Helper;
using System.IO;
using System.IO.Compression;
using ICSharpCode.SharpZipLib.Zip;

namespace DBNeT.DBAX.Modelo.DAC
{
    public class GrupoRamosDAC : BaseDAC
    {
        public GrupoRamosDAC()
        { }

        /// <summary>
        /// Obtiene Todos los Segmentos de las Compañías
        /// </summary>
        /// <returns></returns>
        public DataTable getSegmentos()
        {
            try
            {
                OpenConnection();
                CreateCommand("SP_AX_getSegmentos");
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        /// <summary>
        /// Metodo que Obtiene todos los informes de Cuadros Técnicos
        /// </summary>
        /// <returns></returns>
        public DataTable getCuadros()
        {
            try
            {
                OpenConnection();
                CreateCommand("prc_read_dbax_cuadros");
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        /// <summary>
        /// Metodo que obtiene los periodos (correlativo de instancia)
        /// </summary>
        /// <param name="tsCodiPers">Código Empresa</param>
        /// <param name="tnCorrInst">Correlativo de Instancia(string.Empty)</param>
        /// <returns>Periodos</returns>
        public DataTable getPeriodos(string tsCodiPers, int tnCorrInst)
        {
            try
            {
                OpenConnection();
                CreateCommand("SP_AX_getPersCorrInst");
                AddCommandParamIN("pCodiPers", CmdParamType.StringVarLen, 30, tsCodiPers);
                AddCommandParamIN("pCorrInst", CmdParamType.Integer, tnCorrInst);
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        /// <summary>
        /// Metodo que obtiene las dimensiones de un informe
        /// </summary>
        /// <param name="tsCodiDein">Codigo de Informe</param>
        /// <returns></returns>
        public DataTable getDimensiones(string tsCodiDein)
        {
            try
            {
                OpenConnection();
                CreateCommand("prc_read_dbax_dimensiones");
                AddCommandParamIN("p_codi_dein", CmdParamType.StringVarLen, 128, tsCodiDein);
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }

        }

        /// <summary>
        /// Metodo que retorna las empresas segun el segmento y el correlativo de instancia
        /// </summary>
        /// <param name="tsCodiSegm">Códido Segmento</param>
        /// <param name="tsCorrInst">Correlativo de Instancia(Periodo)</param>
        /// <returns></returns>
        public DataTable getEmpresas(string tsCodiSegm, int tsCorrInst)
        {
            try
            {
                OpenConnection();
                CreateCommand("prc_read_dbax_empresa");
                AddCommandParamIN("p_corr_inst", CmdParamType.Integer, tsCorrInst);
                AddCommandParamIN("p_codi_segm", CmdParamType.StringVarLen, 30, tsCodiSegm);
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        /// <summary>
        /// Metodo que obtiene los conceptos
        /// </summary>
        /// <param name="tsCodiDein">Codigo de Informe</param>
        /// <param name="tsCodiDime">Codigo de Dimensión</param>
        /// <returns>Conceptos Segun el Codigo de Informe y Dimemsión</returns>
        public DataTable getConceptos(string tsCodiDein, string tsCodiDime)
        {
            try
            {
                OpenConnection();
                CreateCommand("prc_read_dbax_conceptos");
                AddCommandParamIN("p_codi_dein", CmdParamType.StringVarLen, 128, tsCodiDein);
                AddCommandParamIN("p_codi_dime", CmdParamType.StringVarLen, 64, tsCodiDime);
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        /// <summary>
        /// Metodo que obtiene los Ramos(miembros) para el encabezado
        /// </summary>
        /// <param name="tsCodiPers">Rut Empresa</param>
        /// <param name="tsCorrInst">Correlativo de Instancia(Periodo)</param>
        /// <param name="tsVersInst">Versión de instancia</param>
        /// <param name="tsCodiInfo">Codigo de Informe</param>
        /// <param name="tsDimension">Codigo de Dimensión</param>
        /// <returns>Retorna los Ramos(Miembros)</returns>
        public DataTable getMiembros(string tsCodiPers, string tsCorrInst, string tsVersInst, string tsCodiInfo, string tsDimension)
        {
            try
            {
                OpenConnection();
                CreateCommand("SP_AX_getMiembrosDimension");
                AddCommandParamIN("p_codi_pers", CmdParamType.StringVarLen, 30, tsCodiPers);
                AddCommandParamIN("p_corr_inst", CmdParamType.StringVarLen, 30, tsCorrInst);
                AddCommandParamIN("p_vers_inst", CmdParamType.StringVarLen, 2, tsVersInst);
                AddCommandParamIN("p_codi_info", CmdParamType.StringVarLen, 64, tsCodiInfo);
                AddCommandParamIN("p_dimension", CmdParamType.StringVarLen, 64, tsDimension);
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        /// <summary>
        /// Metodo que Obtiene los Ramos segun un Código de Segmento
        /// </summary>
        /// <param name="tsCodiSegm">Código de Concepto</param>
        /// <returns>Ramos</returns>
        public DataTable getRamos(string tsCodiSegm)
        {
            try
            {
                OpenConnection();
                CreateCommand("prc_read_dbax_ramos");
                AddCommandParamIN("p_codi_segm", CmdParamType.StringVarLen, 10, tsCodiSegm);
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { CloseConnection(); }
        }

        /// <summary>
        /// Metodo que Obtiene el valor de la columna segun el codigo de ramo y la empresa por un concepto en especifico asignado desde la web
        /// </summary>
        /// <param name="tsCodiPers">Codigo Empresa(rut)</param>
        /// <param name="tsCorrInst">Correlativo de Instancia(Periodo)</param>
        /// <param name="tsVersInst">Versión de Carga</param>
        /// <param name="tsCodiSegm">Codigo de Ramo</param>
        /// <param name="tsPrefConc">Prefijo de Concepto</param>
        /// <param name="tsCodiConc">Código de Concepto</param>
        /// <param name="tsCodiMone">Codigo de Moneda</param>
        /// <returns>Datatable Generado por las Columnas</returns>
        public DataTable getValorColumnaRamo(string tsCodiPers, int tsCorrInst, string tsVersInst,string tsCodiSegm, string tsPrefConc, string tsCodiConc, string tsCodiMone)
        {
            try
            {
                OpenConnection();
                CreateCommand("prc_read_dbax_getValorColumnaRamo");
                AddCommandParamIN("p_codi_pers", CmdParamType.StringVarLen, 30, tsCodiPers);
                AddCommandParamIN("p_corr_inst", CmdParamType.Integer, tsCorrInst);
                AddCommandParamIN("p_vers_inst", CmdParamType.StringVarLen, 2, tsVersInst);
                AddCommandParamIN("p_pref_conc", CmdParamType.StringVarLen, 10, tsPrefConc);
                AddCommandParamIN("p_codi_conc", CmdParamType.StringVarLen, 30, tsCodiConc);
                AddCommandParamIN("p_codi_mone", CmdParamType.StringVarLen, 30, tsCodiMone);
                AddCommandParamIN("p_codi_segm", CmdParamType.StringVarLen, 128, tsCodiSegm);
                AddCommandParamCursor("P_CURSOR");
                return this.ExecuteQueryCmdTable();
            }
            catch (Exception ex)
            { 
                throw ex; 
            }
            finally
            { 
                CloseConnection(); 
            }
        }

        /// <summary>
        /// Metodo que sirve para agregar los valores de las empresas segun el ramo
        /// </summary>
        /// <param name="tsCodiSegm">Código Segmento</param>
        /// <param name="tsCodiInfoCuadro">Código Informe (Cuadro)</param>
        /// <param name="tsCodiDein">Código Dimensión</param>
        /// <param name="tsCodiConc">Código Concepto</param>
        /// <returns>Retorna el Informe Creado con las </returns>
        public DataTable getInformeRamosEmpresa(string tsCodiSegm, string tsCodiInfoCuadro, string tsCodiConc, int tnCorrInst, DataTable tdEmpresas, DataTable tdRamos, string tsCodiMone)
        {
            DataTable dtEmpresas = new DataTable();
            dtEmpresas = tdEmpresas.Copy();
            tdEmpresas.Columns.Remove("codi_pers");
            tdEmpresas.Columns.Remove("pref_conc");
            
            tdEmpresas = this.setColumnaAgregada(tdEmpresas, tsCodiSegm, tdRamos, tsCodiMone, dtEmpresas, tnCorrInst, tsCodiConc).Copy();
            return tdEmpresas;
        }

        /// <summary>
        /// Metodo que Concatena las Columnas con los valores de cada empresa segun las columnas de miembros
        /// </summary>
        /// <returns>Informe con los valores</returns>
        public DataTable setColumnaAgregada(DataTable dtValores, string tsCodiSegm, DataTable tdRamos, string tsCodiMone, DataTable tdCodiPers, int tnCorrInst, string tsCodiConc)
        {
            RescateDeConceptos conc = new RescateDeConceptos();
            Conexion con = new Conexion();
            dtValores.Columns[0].ColumnName = "Empresas";
            dtValores.Columns.Add();
            for (int i = 0; i < tdRamos.Rows.Count; i++)
            {
                string lsCodiRamo = tdRamos.Rows[i]["codi_ramo"].ToString();
                dtValores.Columns[i + 1].ColumnName = lsCodiRamo;
                dtValores.Columns.Add();
            }
            dtValores.Columns.Remove("Column1");
            for (int a = 0; a < tdCodiPers.Rows.Count; a++)
            {
                string lsCodiPers = tdCodiPers.Rows[a]["codi_pers"].ToString();
                string lsPrefConc = tdCodiPers.Rows[a]["pref_conc"].ToString();
                string lsVersInst = con.StringEjecutarQuery(conc.getUltPersVersInst(lsCodiPers, tnCorrInst.ToString()));
                               
                DataTable dtValorConceptoRamo = this.getValorColumnaRamo(lsCodiPers, tnCorrInst, lsVersInst, tsCodiSegm, lsPrefConc, tsCodiConc, tsCodiMone);

                for (int b = 0; b < dtValorConceptoRamo.Rows.Count; b++)
                { 
                    dtValores.Rows[a][b + 1] = dtValorConceptoRamo.Rows[b]["valo_cntx"].ToString(); 
                }
            }
            return dtValores;
        }

        /// <summary>
        /// Metodo que genera en html el DataTable que contiene el informe
        /// </summary>
        /// <param name="tsRuta">Ruta donde se creara el archivo HTML</param>
        /// <param name="tdInforme">Informe de tipo DataTable</param>
        public void GeneraHtml(string tsRuta, DataTable tdInforme)
        {
            FileStream lfFlujo = new FileStream(tsRuta, FileMode.Create, FileAccess.Write);
            StreamWriter lswEscribe = new StreamWriter(lfFlujo, Encoding.UTF8);

            lswEscribe.WriteLine("<html>");
            lswEscribe.WriteLine("<head>");
            lswEscribe.WriteLine("<meta http-equiv=\"cache-control\" content=\"no-cache\"/>");
            lswEscribe.WriteLine("</head>");
            lswEscribe.WriteLine("<body>");
            lswEscribe.WriteLine(" <table style=\"width: 0px; \" title=\"Grilla de informe\" class=\"jSheet ui-widget-content\" id=\"jSheet_0_2\" border=\"1px\" cellpadding=\"0\" cellspacing=\"0\">");
            lswEscribe.WriteLine(" <tbody>");
            lswEscribe.WriteLine(" <tr height:\"100\" >");
            lswEscribe.WriteLine(" <td style=\"font-size: large; text-decoration: underline; font-weight: bold\">Empresa</td>");
            //Genera las Columnas
            for (int i = 1; i < tdInforme.Columns.Count; i++)
            { lswEscribe.WriteLine(" <th style=\"font-size: 12px; text-decoration: underline; font-weight: bold; font-family:Calibri; \">" + tdInforme.Columns[i].ColumnName.ToString() + "</th>"); }
            lswEscribe.WriteLine(" </tr>");

            foreach (DataRow item in tdInforme.Rows)
            {
                try
                {
                    lswEscribe.WriteLine("<tr style=\"width:150px;\">");
                    lswEscribe.WriteLine("<td align=\"right\" style=\"font-size: 12px; font-family:Calibri; width:200px;\">" + item[0].ToString() + "</td>");

                    for (int i = 1; i < tdInforme.Columns.Count; i++)
                    { lswEscribe.WriteLine("<td align=\"right\">" + item[i].ToString() + "</td>"); }
                }
                catch
                { lswEscribe.WriteLine("<td>&nbsp;</td>"); }
                lswEscribe.WriteLine("</tr>");
            }
            lswEscribe.WriteLine(" </tbody>");
            lswEscribe.WriteLine(" </table>");
            lswEscribe.WriteLine(" </body>");
            lswEscribe.WriteLine(" </html>");
            lswEscribe.Close();
            lfFlujo.Close();
            lswEscribe = null;
            lfFlujo = null;
        }

        /// <summary>
        /// Metodo que Elimina las Columnas que no tienen valores
        /// </summary>
        /// <param name="tdInforme">Informes</param>
        /// <returns>DataTable solo con valores en sus Columnas</returns>
        public DataTable eliminaColumna(DataTable tdInforme)
        {
            decimal lnValColum = 0;
            int lnColumn;
            ArrayList laColumn = new ArrayList();
            for (int c = 1; c < tdInforme.Columns.Count; c++)
            {
                for (int r = 0; r < tdInforme.Rows.Count; r++)
                { 
                    decimal lnVal = DBHelper.devuelveDecimal(tdInforme.Rows[r][c]); 
                    lnValColum += lnVal;
                    if (lnValColum > 0)
                    { break; }
                    else
                    { continue; }
                }
                if (lnValColum == 0)
                { lnColumn = c; laColumn.Add(lnColumn); }
                lnValColum = 0;
            }
            for (int i = laColumn.Count; i > 0; i--)
            { tdInforme.Columns.RemoveAt(DBHelper.devuelveInt(laColumn[i-1])); }

            return tdInforme;
        }
    }
}