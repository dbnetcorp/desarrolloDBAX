using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.IO;

namespace dbax.GeneraHTML
{
    class Program
    {
        static string pCODI_EMEX;
        static string pCODI_EMPR;
        static string pCorrInst;
        static string pEmpresa;
        static string pGrupo;
        static string pSegmento;
        static string pTipoTaxonomia;
        static string pSobreescribe;

        static void Main(string[] args)
        {
            GeneracionExcel genExcel = new GeneracionExcel();
            ComparacionXBRL comXBRL = new ComparacionXBRL();
            GuardarXBRL Gxbrl = new GuardarXBRL();
            MantencionParametros para = new MantencionParametros();

            string RutaXbrl = "";
            RutaXbrl = para.getPathXbrl();

            para.SP_AX_insEstadoBarra("Wait", "Proceso de generacion de HTML iniciado.", "N");
            Log.putLog("Inicio");

            if (args.Count() != 8)
            {
                Console.WriteLine("Faltan parámetros: " + args.ToString() + ". Debe ser pCODI_EMEX, pCODI_EMPR, pCorrInst, pEmpresa, pGrupo, pSegmento, pTipoTaxonomia, pSobreescribe");
                Log.putLog("Faltan parámetros: " + args.ToString() + ". Debe ser pCODI_EMEX, pCODI_EMPR, pCorrInst, pEmpresa, pGrupo, pSegmento, pTipoTaxonomia, pSobreescribe");
                Environment.Exit(-1);
            }
            try
            {
                pCODI_EMEX = args[0];
                pCODI_EMPR = args[1];
                pCorrInst = args[2];
                pEmpresa = args[3];
                pGrupo = args[4];
                pSegmento = args[5];
                pTipoTaxonomia = args[6];
                pSobreescribe = args[7];

                foreach (string parametro in args)
                {
                    Log.putLog(parametro);
                }

                DataTable dtEmpresas = genExcel.GetEmpresas(pCODI_EMEX, pCODI_EMPR, pCorrInst, pEmpresa, pGrupo, pSegmento, pTipoTaxonomia, "E").Tables[0];
                Log.putLog("Se encontraron " + dtEmpresas.Rows.Count + " empresas");
                for (int i = 0; i < dtEmpresas.Rows.Count; i++)
                {
                    para.SP_AX_insEstadoBarra("Wait", "Proceso de generacion de HTML iniciado. Procesando empresa " + dtEmpresas.Rows[i]["codi_pers"].ToString() + ", periodo " + pCorrInst, "N");
                    Log.putLog("Comenzando generación HTML para empresa :" + dtEmpresas.Rows[i]["codi_pers"].ToString() + " periodo " + pCorrInst);
                    DataTable dtArchivos = genExcel.getEmpresasDocumentosPorColumna(pCODI_EMEX, pCODI_EMPR, pCorrInst, dtEmpresas.Rows[i]["codi_pers"].ToString(), pGrupo, pSegmento, pTipoTaxonomia, "Estados_financieros_(XBRL)");
                    if (dtArchivos.Rows.Count > 0 && dtArchivos.Rows[0]["nomb_arch"].ToString().Length > 0)
                    {
                        //File.Delete(para.getPathBina() + "Visualizador\\" + dtArchivos.Rows[0]["nomb_arch"].ToString());
                        Gxbrl.limpiaDirectorio(para.getPathBina() + "Visualizador\\Reports");

                        //Si no debo sobreescribir los HTML existentes debo ir a buscar los que estèn generados
                        bool vExisteHTML = false;
                        if (pSobreescribe == "N")
                        {
                            DataTable dtHtmlDeEmpresa = genExcel.getEmpresasDocumentosPorColumna(pCODI_EMEX, pCODI_EMPR, pCorrInst, dtEmpresas.Rows[i]["codi_pers"].ToString(), pGrupo, pSegmento, pTipoTaxonomia, "VisualizacionXBRL");
                            if (dtHtmlDeEmpresa.Rows[0]["nomb_arch"].ToString().Length > 0)
                            {
                                vExisteHTML = true;
                            }
                        }

                        if (pSobreescribe == "S" || (pSobreescribe == "N" && vExisteHTML == false))
                        {
                            para.SP_AX_insEstadoBarra("Wait", "Proceso de generacion de HTML iniciado. Generando HTML para empresa " + dtEmpresas.Rows[i]["codi_pers"].ToString() + ", periodo " + pCorrInst + ".", "N");
                            byte[] contenido = Gxbrl.Rescata_Archivos_XBRL((genExcel.GetArchivosXbrl(dtEmpresas.Rows[i]["codi_pers"].ToString(), pCorrInst, genExcel.getUltPersVersInst(dtEmpresas.Rows[i]["codi_pers"].ToString(), pCorrInst), dtArchivos.Rows[0]["nomb_arch"].ToString()).Rows[0]["Contenido"].ToString()));
                            comXBRL.guardaByteArchivo(para.getPathBina() + "Visualizador\\" + dtArchivos.Rows[0]["nomb_arch"].ToString(), contenido);

                            System.Diagnostics.ProcessStartInfo pinfo = new System.Diagnostics.ProcessStartInfo();
                            pinfo.UseShellExecute = true;
                            pinfo.RedirectStandardOutput = false;
                            pinfo.FileName = para.getPathBina() + "Visualizador\\ReportBuilderRenderer.exe";
                            pinfo.Arguments = "/Instance=\"" + para.getPathBina() + "Visualizador\\" + dtArchivos.Rows[0]["nomb_arch"].ToString() + "\" /ReportFormat=\"Html\"";
                            Log.putLog(pinfo.FileName + " " + pinfo.Arguments);
                            System.Diagnostics.Process p = System.Diagnostics.Process.Start(pinfo);
                            p.WaitForExit();

                            Gxbrl.DescomprimeHTML(para.getPathBina() + "Visualizador\\Reports\\" + dtArchivos.Rows[0]["nomb_arch"].ToString());

                            //Gxbrl.guardaBase64(dtEmpresas.Rows[i]["codi_pers"].ToString(), pCorrInst, genExcel.getUltPersVersInst(dtEmpresas.Rows[i]["codi_pers"].ToString(), pCorrInst), "", ".\\Visualizador\\Reports\\Reports.html", "Informe_" + dtArchivos.Rows[0]["nomb_arch"].ToString().Replace(".zip", ".html").Replace(".xbrl", ".html"), "html");

                            string res = Gxbrl.guardaBase64(dtEmpresas.Rows[i]["codi_pers"].ToString(), pCorrInst, genExcel.getUltPersVersInst(dtEmpresas.Rows[i]["codi_pers"].ToString(), pCorrInst), "", para.getPathBina() + "Visualizador\\Reports\\Reports.html", "VisualizacionXBRL_" + dtEmpresas.Rows[i]["codi_pers"].ToString() + "_" + pCorrInst + ".html", "html", "");
                            if (res == "1")
                            {
                                para.SP_AX_insEstadoBarra("Wait", "Proceso de generacion de HTML iniciado. HTML de empresa " + dtEmpresas.Rows[i]["codi_pers"].ToString() + ", periodo " + pCorrInst + ". Generado y almacenado en DB.", "N");
                            }
                            else
                            {
                                Log.putLog("Ocurrió un error generando el HTML de empresa " + dtEmpresas.Rows[i]["codi_pers"].ToString() + ", periodo " + pCorrInst);
                                para.SP_AX_insEstadoBarra("Wait", "Proceso de generacion de HTML iniciado. HTML de empresa " + dtEmpresas.Rows[i]["codi_pers"].ToString() + ", periodo " + pCorrInst + ". Generado y almacenado en DB.", "N");
                            }
                        }
                        else
                        {
                            para.SP_AX_insEstadoBarra("Wait", "Proceso de generacion de HTML iniciado. Omitiendo empresa " + dtEmpresas.Rows[i]["codi_pers"].ToString() + ", periodo " + pCorrInst + ". Ya existe HTML.", "N");
                            Log.putLog("No se volvió a generar el HTML para esta empresa pues ya existia y parámetro de sobreescritura esta en N");
                        }

                        if (File.Exists(para.getPathBina() + "Visualizador\\" + dtArchivos.Rows[0]["nomb_arch"].ToString()))
                        {
                            File.Delete(para.getPathBina() + "Visualizador\\" + dtArchivos.Rows[0]["nomb_arch"].ToString());
                        }
                    }else
                    {
                        Log.putLog("Ocurre algo raro con selección de empresa para datos " + pCODI_EMEX + ", " + pCODI_EMPR + ", " +pCorrInst + ", " + dtEmpresas.Rows[i]["codi_pers"].ToString() + ", " + pGrupo + ", " + pSegmento + ", " + pTipoTaxonomia + ", " + "Estados_financieros_(XBRL)");
                    }
                }
                Log.putLog("Fin");
                para.SP_AX_insEstadoBarra("OK", "Proceso de generacion de HTML finalizado.", "S");
            }
            catch (Exception ex)
            {
                Log.putLog(ex.Message);
                Log.putLog(ex.StackTrace);
            }
        }
    }
}