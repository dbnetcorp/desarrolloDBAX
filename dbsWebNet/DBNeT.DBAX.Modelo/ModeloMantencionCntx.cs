using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Data;

 public partial class ModeloMantencionCntx
 {
     /// <summary>
     /// Guarda contexto
     /// </summary>
     public string insCntx(string CodiEmex, string CodiEmpr, string CodiCntx, string DescCntx, string DiaiCntx, string AnoiCntx, string DiatCntx, string AnotCntx)
     {
         return "execute SP_AX_insCntx '" + CodiEmex + "','" + CodiEmpr + "','" + CodiCntx + "','" + DescCntx + "','" + DiaiCntx + "','" + AnoiCntx + "','" + DiatCntx + "','" + AnotCntx + "'";
     }
     /// <summary>
     /// Actualiza contexto
     /// </summary>
     public string UpdContexto(string CodiEmex, string CodiEmpr, string CodiCntx, string DescCntx, string DiaiCntx, string AnoiCntx, string DiatCntx, string AnotCntx)
     {
         return "execute SP_AX_UpdContexto '" + CodiEmex + "','" + CodiEmpr + "','" + CodiCntx + "','" + DescCntx  + "','" + DiaiCntx + "','" + AnoiCntx + "','" + DiatCntx + "','" + AnotCntx + "'";
     }
     /// <summary>
     /// LLena Contextos
     /// </summary>
     public string getContextos(string CodiEmex, string CodiEmpr)
     {
         return "execute SP_AX_getContextos '" + CodiEmex + "','" + CodiEmpr + "', 0";
     }
     /// <summary>
     /// Obtiene contextos y sus fechas interpretadas por CodiEmex, CodiEmpr y CorrInst
     /// </summary>
     public string getContextos(string codiEmex, string codiEmpr, int CorrInst)
     {
         return "execute SP_AX_getContextos '" + codiEmex + "','" + codiEmpr + "','" + CorrInst+"'";
     }
     /// <summary>
     /// Obtiene contextos ordenados de acuerdo al orden dentro del informe
     /// </summary>
     public string getContextos(string codiEmex, string codiEmpr, string CodiInfo)
     {
         return "execute SP_AX_getContextos '" + codiEmex + "','" + codiEmpr + "',0,'" + CodiInfo + "'";
     }
     /// <summary>
     /// Para un contexto dado obtiene sus fechas asociadas a un periodo determinado
     /// </summary>
     public string getContextoFechas(string codiEmex, string codiEmpr, string CorrInst, string CodiCntx)
     {
         return "execute SP_AX_getFechaContexto '" + codiEmex + "','" + codiEmpr + "', '" + CorrInst + "','" + CodiCntx + "'";
     }
     /// <summary>
     /// Elimina cntx
     /// </summary>
     public string delCntx(string CodiEmex, string CodiEmpr, string CodiCntx)
     {
         return "execute SP_AX_delCntx '" + CodiEmex + "','" + CodiEmpr + "','" + CodiCntx + "'";
     }
     /// <summary>
     /// LLena Informes
     /// </summary>
     public string getInformes(string CodiEmex, string CodiEmpr)
     {
         return "execute SP_AX_getInformes '" + CodiEmex + "','" + CodiEmpr + "'";
     }
     /// <summary>
     /// Obtiene contextos y sus fechas para un informe dado
     /// </summary>
     public string getInformesContextos(string CodiEmex, string CodiEmpr, string CorrInst, string CodiInfo)
     {
         return "execute SP_AX_getInformesContextos '" + CodiEmex + "','" + CodiEmpr + "','" + CorrInst + "','" + CodiInfo + "'";
     }
     /// <summary>
     /// LLena grilla informe contexto
     /// </summary>
     public string LLenado_grilla_informe_contexto(string informe)
     {
         return "execute SP_AX_getContextosInforme '" + informe + "'";
     }
     /// <summary>
     /// Guarda los Informes Contextos
     /// </summary>
     public string Guarda_Info_cntx(string CodiEmex, string CodiEmpr, string Informe, string CntxEmex, string CntxEmpr, string contexto, string orden)
     {
         return "execute SP_AX_insInfoCntx '" + CodiEmex + "','" + CodiEmpr + "','" + Informe + "','" + CntxEmex + "','" + CntxEmpr + "','" + contexto + "','" + orden + "'";
     }
     /// <summary>
     /// Elimina info_cntx
     /// </summary>
     public string delInfoCntx(string CodiEmex, string CodiEmpr, string CodiInfo, string CodiCntx)
     {
         return "execute SP_AX_delInfoCntx '" + CodiEmex + "','" + CodiEmpr + "','" + CodiInfo + "','" + CodiCntx + "'";
     }
     /// <summary>
     /// Modificar grilla informe contexto
     /// </summary>
     public string UpdOrdenInforme(string CodiEmex, string CodiEmpr, string CodiInfo, string CodiCntx, int OrdeConcAnt, int OrdeConcAct)
     {
         return "execute SP_AX_UpdOrdenInforme '" + CodiEmex + "','" + CodiEmpr + "','" + CodiInfo + "','" + CodiCntx + "','" + OrdeConcAnt + "','" + OrdeConcAct + "'";
     }
     /// <summary>
     /// Validacion de orden
     /// </summary>
     /// 
     public string valida_orden(string codi_info_cntx, string codi_Empr, string orden)
     {
         return "execute SP_AX_Valida_orde_info_cntx '" + codi_info_cntx + "','" + codi_Empr + "','" + orden + "'";
    
     }
     /// <summary>
     /// Obtiene string de consulta de codificacion de fechas, el parámetro puede ser D para dia o A para año
     /// </summary>
     /// 
     public string getCodificacionFechas(string p_TipoFech)
    {
        return "execute SP_AX_getCodiFech '" + p_TipoFech+"'";
    }
     /// <summary>
     /// Obtiene miembros de taxonomía por eje (se usa para los cuadros técnicos 2018)
     /// </summary>
     public string getMiembrosTaxo(string PrefConc, string CodiAxis)
     {
         return "execute SP_AX_getMiembrosTaxoDimension '" + PrefConc + "','" + CodiAxis + "'";
     }
     /// <summary>
     /// Obtiene miembros por eje
     /// </summary>
     public string getInformesMiembros(string CodiPers, string CorrInst, string VersInst, string CodiInfo, string PrefConc, string CodiAxis)
     {
         return "execute SP_AX_getMiembrosDimensionEmpresaPeriodoVersion '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + CodiInfo + "','" + PrefConc + "','" + CodiAxis + "'";
     }
     public string getInformesMiembrosCuadros(string CodiPers, string CorrInst, string VersInst, string CodiInfo, string PrefConc, string CodiAxis, string OrdeMemb)
     {
         return "execute SP_AX_getMiembrosDimensionEmpresaPeriodoVersionCuadros '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + CodiInfo + "','" + PrefConc + "','" + CodiAxis + "'," + OrdeMemb;
     }
     /// <summary>
     /// Obtiene los registros de dbaxInstDicx por contexto
     /// </summary>
     public string getInstDicxPorContexto(string CodiPers, string CorrInst, string VersInst, string CodiCntx)
     {
         return "execute SP_AX_getInstDicxPorContexto '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + CodiCntx + "'";
     }
     //public string getInformesMiembros(string tsCodiPers, string tsCorrInst, string tsVersInst, string CodiInfo, string dimension, string tipo_taxo, string codi_conc, string pref_conc)
     //{
     //    return "execute SP_AX_getMiembrosDimension '" + tsCodiPers + "', '" + tsCorrInst + "', '" + tsVersInst + "', '" + CodiInfo + "','" + dimension + "', '" + tipo_taxo + "', '" + codi_conc + "', '" + pref_conc + "'";
     //}
     /// <summary>
     /// Obtiene maximo de columna en informe
     /// </summary>
     public string getMaxinformeColumna(string Informe, string codi_empr, string codi_emex)
     {
         return "execute SP_AX_GetMaxColum'" + Informe + "','" + codi_empr + "','" + codi_emex + "'";
     }
     /// <summary>
     /// Obtiene todos los períodos  del rango que se  soliciten
     /// </summary>
     public string getPeriRango(string PeriIni, string PeriFin)
     {
         return "execute SP_AX_GetPeriRang'" + PeriIni+ "','" + PeriFin + "'";
     }
     /// <summary>
     /// Rescata fechas contextos
     /// </summary>
     public string getFechasCntx(string Codi_inst, string FechaInicio, string FechaFinal)
     {
         return ("execute SP_AX_GetFechaCntx '" + Codi_inst + "','" + FechaInicio + "','" + FechaFinal + "'");
     }

     /// <summary>
     /// Rescata fechas de contextos asociados a un concepto
     /// </summary>
     public string getFechasEmprInstVersConc(string CodiEmpr, string CorrInst, string VersInst, string CodiConc)
     {
         return ("execute SP_AX_GetFechasEmprInstVersConc '" + CodiEmpr + "','" + CorrInst + "','" + VersInst + "','" + CodiConc + "'");
     }
     /// <summary>
     /// Rescata contextos y fechas usados en una taxonomía COLOMBIANA
     /// </summary>
     public string getContextosFechasPorTaxonomiaCOL(string CorrInst, string versTaxo)
     {
         return ("execute SP_AX_getContextosFechasPorTaxonomiaCOL " + CorrInst + ",'" + versTaxo + "'");
     }
     /// <summary>
     /// Rescata contextos normales y fechas usados en una empresa, instancia,version
     /// </summary>
     public string getContextosFechasPorEmprInstVers(string CodiEmpr, string CorrInst, string VersInst)
     {
         return ("execute SP_AX_getContextosFechasPorEmprInstVers '" + CodiEmpr + "'," + CorrInst + "," + VersInst);
     }
     /// <summary>
     /// Rescata los contextos asociados una empresa, instancia, versión, concepto y fechas 
     /// </summary>
     public string getCntxEmprInstVersFech(string CodiEmpr, string CorrInst, string VersInst, string PrefConc, string CodiConc, string CntxFini, string CntxFfin, string CntxDime)
     {
         return ("execute SP_AX_GetCntxEmprInstVersFech '" + CodiEmpr + "','" + CorrInst + "','" + VersInst + "','" + PrefConc + "','" + CodiConc + "','" + CntxFini + "','" + CntxFfin + "','" + CntxDime + "'");
     }
     /// <summary>
     /// Rescata los contextos (1 eje) asociados a una empresa, instancia, versión, ejes y miembros
     /// </summary>
     public string getCntxDimension1Eje(string CodiEmpr, string CorrInst, string VersInst, string PrefAxis1, string CodiAxis1, string PrefMemb1, string CodiMemb1, string TipoMemb1, string PrefConc, string CodiConc)
     {
         return ("execute SP_AX_getCntxDimension1Eje '" + CodiEmpr + "','" + CorrInst + "','" + VersInst + "','" + PrefAxis1 + "','" + CodiAxis1 + "','" + PrefMemb1 + "','" + CodiMemb1 + "','" + TipoMemb1 + "','" + PrefConc + "','" + CodiConc + "'");
     }
     /// <summary>
     /// Rescata los contextos (2 ejes) asociados a una empresa, instancia, versión, ejes y miembros
     /// </summary>
     public string getCntxDimension2Ejes(string CodiEmpr, string CorrInst, string VersInst, string PrefAxis1, string CodiAxis1, string PrefMemb1, string CodiMemb1, string TipoMemb1, string PrefAxis2, string CodiAxis2, string PrefMemb2, string CodiMemb2, string TipoMemb2, string PrefConc, string CodiConc)
     {
         return ("execute SP_AX_getCntxDimension2Ejes '" + CodiEmpr + "','" + CorrInst + "','" + VersInst + "','" + PrefAxis1 + "','" + CodiAxis1 + "','" + PrefMemb1 + "','" + CodiMemb1 + "','" + TipoMemb1 + "','" + PrefAxis2 + "','" + CodiAxis2 + "','" + PrefMemb2 + "','" + CodiMemb2 + "','" + TipoMemb2 + "','" + PrefConc + "','" + CodiConc + "'");
     }
     /// <summary>
     /// Rescata miembros de un contexto de una empresa, instancia, versión
     /// </summary>
     public string getMiembrosContexto(string CodiEmpr, string CorrInst, string VersInst, string CodiCntx)
     {
         return ("execute SP_AX_GetMiembrosContexto '" + CodiEmpr + "','" + CorrInst + "','" + VersInst + "','" + CodiCntx + "'");
     }
     /// <summary>
     /// Obtiene contextos "Actuales" de una empresa/instancia/version
     /// </summary>
     public string getCntxActuales(string CodiPers, string CorrInst, string VersInst)
     {
         return ("execute SP_AX_getCntxActuales '" + CodiPers + "','" + CorrInst + "','" + VersInst + "'");
     }
     /// <summary>
     /// Obtiene contextos de una tupla n = 1 de ejes-miembros que NO SON DEFAULT
     /// </summary>
     public string getCntxDime1(string CodiPers, string CorrInst, string VersInst, string vCodiAxis1, string vCodiMemb1, string vFech1, string vFech2, string vFech3)
     {
         return ("execute SP_AX_getCntxDime1 '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + vCodiAxis1 + "','" + vCodiMemb1 + "','" + vFech1 + "','" + vFech2 + "','" + vFech3 + "'");
     }
     /// <summary>
     /// Obtiene contextos de una tupla n = 2 de ejes-miembros que NO SON DEFAULT
     /// </summary>
     public string getCntxDime2(string CodiPers, string CorrInst, string VersInst, string vCodiAxis1, string vCodiMemb1, string vCodiAxis2, string vCodiMemb2, string vFech1, string vFech2, string vFech3)
     {
         return ("execute SP_AX_getCntxDime2 '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + vCodiAxis1 + "','" + vCodiMemb1 + "','" + vCodiAxis2 + "','" + vCodiMemb2 + "','" + vFech1 + "','" + vFech2 + "','" + vFech3 + "'");
     }
     /// <summary>
     /// Obtiene contextos de una tupla n = 3 de ejes-miembros que NO SON DEFAULT
     /// </summary>
     public string getCntxDime3(string CodiPers, string CorrInst, string VersInst, string vCodiAxis1, string vCodiMemb1, string vCodiAxis2, string vCodiMemb2, string vCodiAxis3, string vCodiMemb3, string vFech1, string vFech2, string vFech3)
     {
         return ("execute SP_AX_getCntxDime3 '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + vCodiAxis1 + "','" + vCodiMemb1 + "','" + vCodiAxis2 + "','" + vCodiMemb2 + "','" + vCodiAxis3 + "','" + vCodiMemb3 + "','" + vFech1 + "','" + vFech2 + "','" + vFech3 + "'");
     }


     /// <summary>
     /// Obtiene los contextos de una empresa instancia versión. 
     /// </summary>
     public string getContextosPorEmpresaInstanciaVersion(string CodiPers, string CorrInst, string VersInst, string TipoCntx)
     {
         return ("execute SP_AX_getContextosPorEmpresaInstanciaVersion '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + TipoCntx + "'");
     }
 }