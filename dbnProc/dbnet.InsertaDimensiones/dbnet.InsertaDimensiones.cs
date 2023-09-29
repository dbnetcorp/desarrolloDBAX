using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.IO;
using DBNeT.DBAX.Controlador;

namespace dbnet.InsertaDimensiones
{
    class Program
    {
        static string pCodiEmex = "1", pCodiEmpr = "1", pCorrInst = "", pCodiPers = "";
        static string pCodiGrup = "0", pCodiSegm = "0", pCodiIndi = "", pTipoTaxo = "", pRutaResp="";
        

        static void Main(string[] args)
        {
            if (args.Length != 8)
            {
                Console.WriteLine("Faltan Parametros " + args.Length.ToString());
                Environment.Exit(-1);
            }

            pCodiEmex = args[0];
            pCodiEmpr = args[1];
            pCorrInst = args[2];
            pCodiPers = args[3];
            pCodiGrup = args[4];
            pCodiSegm = args[5];
            pTipoTaxo = args[6];
            pRutaResp = args[7];

            GeneracionExcel Empresas = new GeneracionExcel();
            MantencionParametros para = new MantencionParametros();
            GuardarXBRL Gxbrl = new GuardarXBRL();
            ComparacionXBRL comXBRL = new ComparacionXBRL();

            string RutaXbrl = "";
            RutaXbrl = para.getPathXbrl();
            bool cargar=true;
            DataTable dtEmpresas = Empresas.GetEmpresas(pCodiEmex, pCodiEmpr, pCorrInst, pCodiPers, pCodiGrup, pCodiSegm, "", "P").Tables[0];
            for (int i =0; i < dtEmpresas.Rows.Count; i++)
            {
                if (dtEmpresas.Rows[i]["codi_pers"].ToString() == "90690000")
                    cargar = true;
                if (cargar)
                {
                    DataTable dtArchivos = Empresas.getEmpresasDocumentosPorColumna(pCodiEmex, pCodiEmpr, pCorrInst, dtEmpresas.Rows[i]["codi_pers"].ToString(), pCodiGrup, pCodiSegm, pTipoTaxo, "Estados_financieros_(XBRL)");

                    try
                    {
                        Log.putLog("Cargando empresa: " + dtEmpresas.Rows[i]["codi_pers"].ToString() + " Periodo: " + pCorrInst);
                        if (dtArchivos.Rows.Count > 0)
                        {
                            //File.Delete(RutaXbrl + dtEmpresas.Rows[i]["codi_pers"].ToString() + "_" + pCorrInst + "\\" + dtArchivos.Rows[0]["nomb_arch"].ToString());
                            //Gxbrl.limpiaDirectorio(RutaXbrl + dtEmpresas.Rows[i]["codi_pers"].ToString() + "_" + pCorrInst + "\\");
                            Directory.CreateDirectory(RutaXbrl + dtEmpresas.Rows[i]["codi_pers"].ToString() + "_" + pCorrInst + "\\");
                            //  Directory.CreateDirectory(pRutaResp + dtEmpresas.Rows[i]["codi_pers"].ToString() + "_" + pCorrInst + "\\");
                            // byte[] contenido = Gxbrl.Rescata_Archivos_XBRL((Empresas.GetArchivosXbrl(dtEmpresas.Rows[i]["codi_pers"].ToString(), pCorrInst, Empresas.getUltPersVersInst(dtEmpresas.Rows[i]["codi_pers"].ToString(), pCorrInst), dtArchivos.Rows[0]["nomb_arch"].ToString()).Rows[0]["Contenido"].ToString()));
                            // comXBRL.guardaByteArchivo(RutaXbrl + dtEmpresas.Rows[i]["codi_pers"].ToString() + "_" + pCorrInst + "\\" + dtArchivos.Rows[0]["nomb_arch"].ToString(), contenido);
                            //comXBRL.guardaByteArchivo(pRutaResp + dtEmpresas.Rows[i]["codi_pers"].ToString() + "_" + pCorrInst + "\\" + dtArchivos.Rows[0]["nomb_arch"].ToString(), contenido);
                            //ESTO LO COMENTE YO - MAURICIO
                            Gxbrl.GetArchEmpresa(dtEmpresas.Rows[i]["codi_pers"].ToString(), pCorrInst, dtEmpresas.Rows[i]["vers_inst"].ToString(), RutaXbrl + dtEmpresas.Rows[i]["codi_pers"].ToString() + "_" + pCorrInst);
                            //ESTO LO COMENTE YO - MAURICIO
                            Empresas.DelInstDocuVers(dtEmpresas.Rows[i]["codi_pers"].ToString(), pCorrInst, dtEmpresas.Rows[i]["vers_inst"].ToString());
                            Gxbrl.CargaXBRLCorregida(false,false);
                            DescomprimirZipController.DirectoryCopy(RutaXbrl + dtEmpresas.Rows[i]["codi_pers"].ToString() + "_" + pCorrInst + "\\", pRutaResp + "\\" + dtEmpresas.Rows[i]["codi_pers"].ToString() + "_" + pCorrInst + "\\", true);
                            Gxbrl.limpiaDirectorio(RutaXbrl + dtEmpresas.Rows[i]["codi_pers"].ToString() + "_" + pCorrInst + "\\");
                            Directory.Delete(RutaXbrl + dtEmpresas.Rows[i]["codi_pers"].ToString() + "_" + pCorrInst + "\\");
                        }
                        else
                            Log.putLog("La Empresa " + dtEmpresas.Rows[i]["codi_pers"].ToString() + " no tiene archivos?");
                    }
                    catch (Exception ex)
                    {
                        Log.putLog(" Ocurrio un error cargando la empresa: " + dtEmpresas.Rows[i]["codi_pers"].ToString());
                        Log.putLog(ex.Message);
                    }
                }
            }
        }
    }
}
