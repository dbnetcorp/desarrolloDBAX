using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml;
using System.Data;

using System.Net;

public partial class ComparacionXBRL
{
    private string vBloqueConceptos = "";
    private string vBloqueContextos = "";

    public void setBloqueConceptos(int corrConc, string par1, string par2, string par3, string par4, string par5, string par6, string par7, string par8)
    {
        vBloqueConceptos += InsertConceptoInstancia(corrConc, par1,  par2,  par3,  par4,  par5,  par6,  par7,  par8);
        vBloqueConceptos += ";";
    }

    public void setBloqueConceptos(int corrConc, string par1, string par2, string par3, string par4, string par5, string par6, string par7, string par8, string CntxStnd)
    {
        vBloqueConceptos += InsertConceptoInstancia(corrConc, par1, par2, par3, par4, par5, par6, par7, par8, CntxStnd);
        vBloqueConceptos += ";";
    }

    public void setBloqueConceptosGrandes(int par1, string par2, string par3, string par4, string par5)
    {
        vBloqueConceptos += InsertConceptoClobInstancia(par1, par2, par3, par4, par5);
        vBloqueConceptos += ";";
    }

    public string getBloqueConceptos()
    {
        string temp = vBloqueConceptos;
        vBloqueConceptos = "";
        return "SET IDENTITY_INSERT [dbax_inst_conc] ON;" + temp;
    }

    public void setBloqueContextos(string par1, string par2, string par3, string par4)
    {
        //if (par4 == "c825aY1_ActivosFinancierosCostoAmortizadoMiembro" || par4 == "c825aY1_InversionesSegurosCUIMiembro")
        //{
        //    Console.WriteLine(par4);
        //}

        vBloqueContextos += InsertContextosInstancia(par1, par2, par3, par4);
        vBloqueContextos += ";";
    }

    public void setBloqueUpdateContextoInstant(string par1, string par2, string par3, string par4, string par5)
    {
        vBloqueContextos += UpdateContextoInstanst(par1, par2, par3, par4, par5);
        vBloqueContextos += ";";
    }

    public void setBloqueUpdateContextoPeriod(string par1, string par2, string par3, string par4, string par5, string par6)
    {
        vBloqueContextos += UpdateContextoPeriod(par1, par2, par3, par4, par5, par6);
        vBloqueContextos += ";";
    }

    public void setBloqueInsertInstDicx(string par1, string par2, string par3, string par4, string par5, string par6)
    {
        //if (par4 == "c825aY1_ActivosFinancierosCostoAmortizadoMiembro" || par4 == "c825aY1_InversionesSegurosCUIMiembro")
        //{
        //    Console.WriteLine(par4);
        //}

        vBloqueContextos += InsertInstDicx(par1, par2, par3, par4, par5, par6);
        vBloqueContextos += ";";
    }

    public string getBloqueContextos()
    {
        string temp = vBloqueContextos;
        vBloqueContextos = "";
        return temp;
    }


    public string CodificarArchivo(string sNombreArchivo)
    {
        try
        {
            string sBase64 = "";
            // Declaramos fs para tener acceso al archivo residente en la maquina cliente.
            FileStream fs = new FileStream(sNombreArchivo, FileMode.Open);
            // Declaramos un Leector Binario para accesar a los datos del archivo pasarlos a un arreglo de bytes
            BinaryReader br = new BinaryReader(fs);
            byte[] bytes = new byte[(int)fs.Length];
            br.Read(bytes, 0, bytes.Length);
            // base64 es la cadena en donde se guarda el arreglo de bytes ya convertido
            sBase64 = Convert.ToBase64String(bytes);
            fs.Close();
            return sBase64;
        }
        catch (Exception ex)
        {
            Log.putLog(ex.Message.ToString());
            return "Error " + ex.Message.ToString();
        }
    }
    public string DecodificarArchivo(string sBase64)
    {
        // Declaramos fs para tener crear un nuevo archivo temporal en la maquina cliente.
        // y memStream para almacenar en memoria la cadena recibida.
        string sDeco64 = "";
        byte[] decbuff = Convert.FromBase64String(sBase64);
        sDeco64 = System.Text.Encoding.UTF8.GetString(decbuff);
        return sDeco64;

    }
    public bool guardaByteArchivo(string _FileName, byte[] _ByteArray)
    {
        try
        {
            // Open file for reading
            System.IO.FileStream _FileStream =
               new System.IO.FileStream(_FileName, System.IO.FileMode.Create,
                                        System.IO.FileAccess.Write);
            // Writes a block of bytes to this stream using data from
            // a byte array.
            _FileStream.Write(_ByteArray, 0, _ByteArray.Length);

            // close file stream
            _FileStream.Close();

            return true;
        }
        catch (Exception _Exception)
        {
            // Error
            Console.WriteLine("Exception caught in process: {0}",
                              _Exception.ToString());
        }

        // error occured, return false
        return false;
    }
    public byte[] DecodificarArchivoBytes(string sBase64)
    {
        return Convert.FromBase64String(sBase64);
    }
    public string GetRutaXBRL()
    {
        return "execute SP_AX_GetRutaXBRL";
    }
    public bool VerificarXBRL(string pArchivo, string sDesco64)
    {
        string sXBRL;
        sXBRL = CodificarArchivo(pArchivo);
        if (sXBRL.Equals(sDesco64))
            return false;
        else
            return true;
    }
    public string SetBase64XBRL(string CodiPers, string CorrInst, string VersInst, string ContArch, string NombArch, string tipo_mime)
    {
        return "execute SP_AX_InsBase64XBRL '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + ContArch + "','" + NombArch + "','" + tipo_mime + "'"; 
    }
    //La ultima version la obtiene el procedimiento almacenado
    public string GetBase64XBRL(string par1, string par2, string par3)
    {
        return "execute SP_AX_GetBase64XBRL '" + par1 + "','" + par2 + "','" + par3 + "'";
    }
    public string GetBase64HTMLExte(string par1, string par2)
    {
        return "execute SP_AX_GetBase64HTMLExte '" + par1 + "','" + par2  + "'";
    }
    public string delInstDocu(string CodiPers, string CorrInst)
    {
        return "execute SP_AX_delInstDocu '" + CodiPers + "','" + CorrInst + "'";
    }
    public string insInstDocu(string CodiPers, string CorrInst, string CodiEsta)
    {
        return "execute SP_AX_insInstDocu '" + CodiPers + "','" + CorrInst + "','" + CodiEsta + "'";
    }
    public string InsertVersionInstancia(string par1, string par2, string par3, string par4, string par5)
    {
        return "execute SP_AX_insVersInst '" + par1 + "','" + par2 + "','" + par3 + "','" + par4 + "','" + par5 + "'";
    }
    public string InsertVersionInstancia(string par1, string par2, string par3, string par4, string par5, string par6)
    {
        return "execute SP_AX_insVersInst '" + par1 + "','" + par2 + "','" + par3 + "','" + par4 + "','" + par5 + "','" + par6 + "'";
    }
    public string InsertVersionInstancia(string par1, string par2, string par3, string par4, string par5, string par6, string pDbgxEmpr, string pDbgxCorr, string pDbgxVers)
    {
        return "execute SP_AX_insVersInst '" + par1 + "','" + par2 + "','" + par3 + "','" + par4 + "','" + par5 + "','" + par6 + "','" + pDbgxEmpr + "','" + pDbgxCorr + "','" + pDbgxVers + "'";
    }
    public string InsertContextosInstancia(string par1, string par2, string par3, string par4)
    {
        return "execute SP_AX_insCntxInst '" + par1 + "','" + par2 + "','" + par3 + "','" + par4 + "'";
    }
    public string UpdateContextoInstanst(string par1, string par2, string par3, string par4, string par5)
    {
        return "execute SP_AX_UpdaCntxInst '" + par1 + "',default,'" + par2 + "','" + par3 + "','" + par4 + "','" + par5 + "'"; 
    }
    public string UpdateContextoPeriod(string par1, string par2, string par3, string par4, string par5, string par6)
    {
        return "execute SP_AX_UpdaCntxInst '" + par1 + "','" + par2 + "','" + par3 + "','" + par4 + "','" + par5 + "','" + par6 + "'"; 
    }
    public string InsertInstDicx(string par1, string par2, string par3, string par4, string par5, string par6)
    {
        return "execute SP_AX_insInstDicx '" + par1 + "','" + par2 + "','" + par3 + "','" + par4 + "','" + par5 + "','" + par6 + "'"; 
    }
    public string InsertInstUnit(string par1, string par2, string par3, string par4)
    {
        return "execute SP_AX_insInstUnit '" + par1 + "','" + par2 + "','" + par3 + "','" + par4 +  "'"; 
    }
    public string UpdateInstUnit(string par1, string par2, string par3, string par4, string par5)
    {
        return "execute SP_AX_UpdaInstUnit '" + par1 + "','" + par2 + "','" + par3 + "','" + par4 + "','" + par5 + "'"; 
    }
    /// <summary>
    /// Concatena inserts de conceptos en bloque
    /// </summary>
    /// 
    public string InsertConceptoInstancia(int corrConc, string par1, string par2, string par3, string par4, string par5, string par6, string par7, string par8)
    {
        return "execute SP_AX_insInstConc " + corrConc + ",'" + par1 + "','" + par2 + "','" + par3 + "','" + par4 + "','" + par5 + "','" + par6 + "','" + par7 + "','" + par8 + "'";
    }
    /// <summary>
    /// Concatena inserts de conceptos en bloque (con contexto estándar)
    /// </summary>
    /// 
    public string InsertConceptoInstancia(int corrConc, string par1, string par2, string par3, string par4, string par5, string par6, string par7, string par8, string CntxStnd)
    {
        return "execute SP_AX_insInstConc " + corrConc + ",'" + par1 + "','" + par2 + "','" + par3 + "','" + par4 + "','" + par5 + "','" + par6 + "','" + par7 + "','" + par8 + "','" + CntxStnd + "'";
    }
    /// <summary>
    /// Elimina los contextos que han sido definidos pero no fueron usados en el XBRL
    /// </summary>
    /// 
    public string delContextosNoUsados(string CodiEmpr, string CorrInst, string VersInst)
    {
        return "execute SP_AX_delContextosNoUsados '" + CodiEmpr + "','" + CorrInst + "','" + VersInst + "'";
    }
    public string InsertConceptoClobInstancia(int par1, string par2, string par3, string par4, string par5)
    {
        return "execute SP_AX_insInstValoConc '" + par1 + "','" + par2 + "','" + par3 + "','" + par4 + "','" + par5 + "'"; 
    }
    public string GetEsquemaInforme(string par1)
    {
        return "execute SP_AX_GetScheInfo '" + par1 + "'";
    }
    public string InsertInformeInstancia(string par1, string par2, string par3, string par4)
    {
        return "execute SP_AX_insInstInfo '" + par1 + "','" + par2 + "','" + par3 + "','" + par4 + "'"; 
    }
    /// <summary>
    /// Inserta todos los informes de la taxonomía en la versión actual (colombia)
    /// </summary>
    ///
    public string insertInformesColombia(string @pCodiPers, string @pCorrInst, string @pVersInst, string @pShell)
    {
        //Si da un error acá, fijarse que no hayan duplicaciones en las siguientes tablas
        /*
         * delete from dbax_taxo_conc where vers_taxo ='ctrl-58-avcp-ind_2015-01-01'
         * delete from dbax_info_colo where vers_taxo ='ctrl-58-avcp-ind_2015-01-01'
         * delete from dbax_taxo_vers where vers_taxo ='ctrl-58-avcp-ind_2015-01-01'
         */
        return "execute SP_AX_insInstInfoColo '" + @pCodiPers + "','" + @pCorrInst + "','" + @pVersInst + "','" + @pShell + "'";
    }
    /// <summary>
    /// Recupera la taxonomía correspondiente a partir del link (entry point)
    /// </summary>
    ///
    public string getTaxoPorUbic(string @pShell)
    {
        return "execute SP_AX_getTaxoporUbic '" + @pShell + "'";
    }
    public string GetConceptosDiferentes(string codi_pers, string corr_inst, string vers_inst)
    {
        return "execute SP_AX_GetConcDife '" + codi_pers + "','" + corr_inst + "','" + vers_inst+"'";
    }
    public string GetConceptosVers(string codi_pers, string corr_inst, string vers_inst)
    {
        return "execute SP_AX_GetConcVers '" + codi_pers + "','" + corr_inst + "','" + vers_inst + "'";
    }
    public string GetConceptosFaltantes1(string codi_pers, string corr_inst, string vers_inst)
    {
        return "execute SP_AX_GetConcFalt1 '" + codi_pers + "','" + corr_inst + "','" + vers_inst+"'";
    }
    public string GetConceptosFaltantes2(string codi_pers, string corr_inst, string vers_inst)
    {
        return "execute SP_AX_GetConcFalt2 '" + codi_pers + "','" + corr_inst + "','" + vers_inst+"'";
    }
    public string InseConceptosDiferentes(string codi_pers, string corr_inst, string vers_inst, string codi_conc, string codi_cntx, string valo_cntx)
    {
        return "execute SP_AX_insConcDife '" + codi_pers + "','" + corr_inst + "','" + vers_inst + "','" + codi_conc + "','" + codi_cntx + "','" + valo_cntx + "'";
    }
    public string GetValoresInstancia(string codi_pers, string corr_inst, string vers_inst, string codi_conc, string fini_cntx, string ffin_cntx)
    {
        return "execute SP_AX_GetValoInst '" + codi_pers + "','" + corr_inst + "','" + vers_inst + "','" + codi_conc + "','" + fini_cntx + "','" + ffin_cntx + "'";
    }
    public string InseHtmlDiferencias(string codi_pers, string corr_inst, string vers_inst, string vHtml)
    {
        return "execute SP_AX_insHtmlDife '" + codi_pers + "','" + corr_inst + "','" + vers_inst + "','" + vHtml + "'";
    }
    public string GetInstanciaHTML(string codi_pers, string corr_inst,string vers_inst)
    {
        return "execute SP_AX_GetInstHTML '" + codi_pers + "','" + corr_inst + "','" + vers_inst+"'";
    }
    public string InseInstMemb(string codi_pers, string corr_inst, string vers_inst, string codi_memb, string desc_memb)
    {
        return "execute SP_AX_insInstMemb '" + codi_pers + "','" + corr_inst + "','" + vers_inst + "','" + codi_memb + "','" + desc_memb + "'";
    }
    public string InseInstDime(string codi_pers, string corr_inst, string vers_inst, string codi_dein, string pref_dime,string codi_dime,string letr_dime,string pref_axis,string codi_axis,string codi_memb,string orde_memb,string memb_papa)
    {
        return "execute SP_AX_insInstDime '" + codi_pers + "','" + corr_inst + "','" + vers_inst + "','" + codi_dein + "','" + pref_dime + "','" + codi_dime + "','" + letr_dime + "','" + pref_axis + "','" + codi_axis + "','" + codi_memb + "','" + orde_memb  + "','" + memb_papa + "'";
    }
    public string GetDimeDefi(string role_uri)
    {
        return "execute SP_AX_getDimeDefi '"  + role_uri + "'";
    }
    public string GetAxisMemb(string pref_memb, string codi_memb, string pref_dime, string codi_dime, string codi_dein)
    {
        return "execute SP_AX_getAxisMemb '" + pref_memb + "','" + codi_memb + "','" + pref_dime + "','" + codi_dime + "','" + codi_dein + "'"; 
    }
    public string GetOrdenMembVari(string codi_pers, string corr_inst, string vers_inst, string codi_dein, string pref_dime, string codi_dime, string pref_papa, string memb_papa)
    {
        return "execute SP_AX_GetOrdenMembVari '" + codi_pers + "','" + corr_inst + "','" + vers_inst + "','" + codi_dein + "','" + pref_dime + "','" + codi_dime + "','" + pref_papa + "','" + memb_papa + "'";
    }
    public string GetMiembroInstMemb(string codi_pers, string corr_inst, string vers_inst, string pref_memb, string codi_memb)
    {
        return "execute SP_AX_getMiembroInstMemb '" + codi_pers + "','" + corr_inst + "','" + vers_inst + "','" + pref_memb + "','" + codi_memb + "'";
    }
    public string DelInstDocuVers(string codi_pers, string corr_inst, string vers_inst)
    {
        return "execute SP_AX_delInstDocuVers '" + codi_pers + "','" + corr_inst + "','" + vers_inst + "'";
    }
    public string GetInstDimeVers(string codi_pers, string corr_inst, string vers_inst, string codi_dein, string pref_dime, string codi_dime, string codi_memb)
    {
        return "execute SP_AX_getInstDimeVers '" + codi_pers + "','" + corr_inst + "','" + vers_inst + "','" + codi_dein + "','" + pref_dime + "','" + codi_dime + "','" + codi_memb + "'";
    }
    public string DelInstDocuVersExte(string codi_pers, string corr_inst, string pCodiUsua, string pDbgxEmpr, string pDbgxCorr, string pDbgxVers)
    {
        return "execute SP_AX_delInstDocuVersExte '" + codi_pers + "','" + corr_inst + "','" + pCodiUsua + "','" + pDbgxEmpr + "','" + pDbgxCorr + "','" + pDbgxVers + "'";
    }
    public string UpdEstadoVersInst(string pCodiPers, string pCorrInst, string pVersInst,string pEstaVers)
    {
        return "execute SP_AX_UpdEstadoVersInst '" + pCodiPers + "','" + pCorrInst + "','" + pVersInst + "','" + pEstaVers + "'";
    }
    public string getConceptosCriticos(string pCodiPers, string pCorrInst, string pVersInst)
    {
        return "execute SP_AX_getConceptosCriticos '" + pCodiPers + "','" + pCorrInst + "','" + pVersInst + "'";
    }
    public string GetCorrConc(string vRutEmpr, string vPeriInfo, string vInstVers)
    {
        return "execute SP_AX_GetCorrConc '" + vRutEmpr + "','" + vPeriInfo + "','" + vInstVers + "'";
    }

    /// <summary>
    /// Obtiene fechas asociadas a un concepto por empresa, instancia, version
    /// </summary>
    /// 
    public string getFechasConceptoPorEmpresaInstanciaVersion(string vCodiPers, string vCorrInst, string vVersInst, string vPrefConc, string vCodiConc)
    {
        return "execute SP_AX_getFechasConceptoPorEmpresaInstanciaVersion '" + vCodiPers + "'," + vCorrInst + "," + vVersInst + ",'" + vPrefConc + "','" + vCodiConc + "'";
    }

    /// <summary>
    /// Inserta la cantidad de XBRL disponibles en sitio SVS
    /// </summary>
    /// 
    public string insCantidadXbrlReportados(string vCorrInst, string vCantXbrl)
    {
        return "execute SP_AX_insCantidadXbrlReportados '" + vCorrInst + "','" + vCantXbrl + "'";
    }
    /// <summary>
    /// Inserta los registros existentes en la base de datos del BOT
    /// </summary>
    /// 
    public string insLinksXbrlReportados(string vRut, string vXbrl, string vAnal, string vDecl, string vHech, string vPdf)
    {
        vRut = vRut.Replace(" ", "");
        vRut = vRut.Substring(0, vRut.LastIndexOf("-"));
        return "execute SP_AX_insLinksXbrlReportados '" + vRut + "','" + vXbrl + "','" + vAnal + "','" + vDecl + "','" + vHech + "','" + vPdf + "'";
    }
    /// <summary>
    /// Obtiene cantidad de XBRL con posibles errores en la carga y descarga
    /// </summary>
    /// 
    public string getCantidadXbrlReportados(string vCorrInst)
    {
        return "execute SP_AX_getCantidadXbrlReportados " + vCorrInst + ",'N'";
    }
    /// <summary>
    /// Obtiene lista de XBRL con posibles errores en la carga
    /// </summary>
    /// 
    public string getListaXbrlReportadosYNoCargados(string vCorrInst)
    {
        return "execute SP_AX_getCantidadXbrlReportados " + vCorrInst + ",'C'";
    }
    /// <summary>
    /// Obtiene lista de XBRL con posibles errores en la carga
    /// </summary>
    /// 
    public string getListaXbrlReportadosConErrorLink(string vCorrInst)
    {
        return "execute SP_AX_getCantidadXbrlReportados " + vCorrInst + ",'L'";
    }
    /// <summary>
    /// Inserta un registro correspondiente a un XBRL que tuvo errores de carga
    /// </summary>
    /// 
    public string insXbrlConProblemas(string vCorrInst, string vCodiPers, string vNombArch, string vTipoError, string vDescprob)
    {
        return "execute SP_AX_insXbrlConProblemas '" + vCorrInst + "','" + vCodiPers + "','" + vNombArch + "','" + vTipoError + "','" + vDescprob.Replace("'", "") + "'";
    }
    /// <summary>
    /// Inserta un registro correspondiente a un XBRL que tuvo errores de carga
    /// </summary>
    public string insXbrlConProblemas(string vCorrInst, string vCodiPers, string vNombArch, DataTable vConceptosFaltante)
    {
        string vDescProb = "Conceptos faltantes: ";
        for (int i = 0; i < vConceptosFaltante.Rows.Count; i++)
        {
            vDescProb += vConceptosFaltante.Rows[i][0].ToString() + ", ";
        }

        vDescProb = vDescProb.Substring(0, vDescProb.Length - 2);

        return "execute SP_AX_insXbrlConProblemas '" + vCorrInst + "','" + vCodiPers + "','" + vNombArch + "','EDA','" + vDescProb.Replace("'", "") + "'";
    }
    /// <summary>
    /// Actualiza la tabla dbax_defi_peho insertando las filas si faltan.
    /// </summary>
    /// 
    public string insValidaPersonaHolding()
    {
        return "execute SP_AX_insValidaPersonaHolding";      
    }
    public string insRepoXbrlProb(string vCorrInst)
    {
        return "execute SP_AX_insRepoXbrlProb '" + vCorrInst + "'";
    }

    /// <summary>
    /// Actualiza la tabla dbax_arch_pend
    /// </summary>
    /// 
    public string updArchPen(string vCorrInst, string vCodiPers, string vModo)
    {
        return "execute SP_AX_updArchPend " + vCorrInst + ",'" + vCodiPers + "','" + vModo + "'";
    }

    /// <summary>
    /// Actualiza la tabla dbax_arch_pend y setea valor de error
    /// </summary>
    /// 
    public string updArchPen(string vCorrInst, string vCodiPers, string vModo, string vError)
    {
        return "execute SP_AX_updArchPend " + vCorrInst + ",'" + vCodiPers + "','" + vModo + "','" + vError + "'";
    }
    /// <summary>
    /// Obtiene los ruts de las empresas que reportaron en el periodo actual
    /// </summary>
    /// 
    public string getCodiPersReportadosPeriodoActual(string vCorrInst)
    {
        return "execute SP_AX_getCodiPersReportados '" + vCorrInst + "','2'";
    }

    /// <summary>
    /// Obtiene los ruts de las empresas que reportaron en el periodo actual más el anterior
    /// </summary>
    /// 
    public string getCodiPersReportadosPeriodoActualyAnterior(string vCorrInst)
    {
        return "execute SP_AX_getCodiPersReportados '" + vCorrInst + "','1'";
    }
}