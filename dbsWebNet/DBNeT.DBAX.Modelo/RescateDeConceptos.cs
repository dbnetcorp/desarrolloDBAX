using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Xml.Linq;
//using System.Web.UI.WebControls;

using System.Text;
using System.Xml;
using System.IO;

public partial class RescateDeConceptos
{
    private string vCodiInfo = "";
    Conexion con = new Conexion().CrearInstancia();
    ValidacionDeConceptos vc = new ValidacionDeConceptos();

    public string getPrefConcPorCodiConc(string CodiEmex, string CodiEmpr, string CodiConc)
    {
        return "execute SP_AX_getPrefConcPorCodiConc '" + CodiEmex + "','" + CodiEmpr + "','" + CodiConc + "'";
    }
    public string ObtenerTipoIndicadores()
    {
        return "execute SP_AX_RescAgru";
    }
    /// <summary>
    /// Obtiene conceptos monetarios
    /// </summary>
    public string getConceptos(string CodiEmex, string CodiEmpr, string CodiConc, string TipoElem, string CodiConc2)
    {
        return "execute SP_AX_GetConcPorNombreTipo '" + CodiEmex + "','" + CodiEmpr + "','" + CodiConc + "','" + TipoElem + "','" + CodiConc2 + "'";
    }
    /// <summary>
    /// Trae códigos y descripción de todos los conceptos informadas en una versión
    /// </summary>
    ///
    public string getConcEmprInstVers(string CodiPers, string CorrInst, string VersInst)
    {
        return "execute SP_AX_GetConcEmprInstVers '" + CodiPers + "','" + CorrInst + "','" + VersInst + "'";
    }
    /// <summary>
    /// Trae códigos y descripción de todos los conceptos informadas en una versión (filtrado por codigo o descripción)
    /// </summary>
    ///
    public string getConcEmprInstVers(string CodiPers, string CorrInst, string VersInst, string TextBusq)
    {
        return "execute SP_AX_GetConcEmprInstVers '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + TextBusq + "'";
    }
    /// <summary>
    /// Trae los ejes de una dimensión
    /// </summary>
    /// 
    public string getEjesPorDimension(string CodiInfo, string prefDime, string CodiDime)
    {
        return "execute SP_AX_getEjesPorDimension '" + CodiInfo + "','" + prefDime + "','" + CodiDime + "'";
    }
    /// <summary>
    /// Trae los miembros de un eje mas los miembros personalizados
    /// </summary>
    /// 
    public string getMiembrosPorEjeEmpresaInstanciaVersion(string CodiPers, string CorrInst, string VersInst, string prefAxis, string codiAxis)
    {
        return "execute SP_AX_getMiembrosPorEjeEmpresaInstanciaVersion '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + prefAxis + "','" + codiAxis + "'";
    }
    /// <summary>
    /// Trae los miembros de un eje
    /// </summary>
    /// 
    public string getMiembrosPorEje(string prefAxis, string codiAxis)
    {
        return "execute SP_AX_getMiembrosPorEje '" + prefAxis + "','" + codiAxis + "'";
    }
    /// <summary>
    /// Trae conceptos de una dimensión
    /// </summary>
    /// 
    public string getConcPorDime(string CodiInfo, string prefDime, string CodiDime)
    {
        return "execute SP_AX_getConceptoPorDimension '" + CodiInfo + "','" + prefDime + "','" + CodiDime + "'";
    }
    /// <summary>
    /// Trae los informes correspondientes a cuadros técnicos
    /// </summary>
    ///
    public string getInformesCuadrosTecnicos()
    {
        return "execute SP_AX_getInformesCuadrosTecnicos";
    }
    /// <summary>
    /// Trae descripción y código de los cuadros técnicos
    /// </summary>
    ///
    public string getCuadrosTecnicos()
    {
        return "execute SP_AX_getCuadrosTecnicos";
    }
    /// <summary>
    /// Trae descripción y código de los cuadros técnicos para un informe
    /// </summary>
    ///
    public string getCuadrosTecnicos(string CodiInfo)
    {
        return "execute SP_AX_getCuadrosTecnicos '" + CodiInfo + "'";
    }
    /// <summary>
    /// Trae la definición de un concepto
    /// </summary>
    ///
    public string getConceptoPrefConc(string prefConc, string codiConc)
    {
        return "execute SP_AX_GetConceptoPrefConc '" + prefConc + "','" + codiConc + "'";
    }
    /// <summary>
    /// Obtiene conceptos segun tipo de concepto (taxonomia o indicador) y tipo de valor
    /// </summary>
    public string getConceptos(string CodiEmex, string CodiEmpr, string CodiConc, string TipoElem, string CodiConc2, string TipoValo)
    {
        return "execute SP_AX_GetConcPorNombreTipo '" + CodiEmex + "','" + CodiEmpr + "','" + CodiConc + "','" + TipoElem + "','" + CodiConc2 + "','" + TipoValo + "'";
    }
    /// <summary>
    /// Obtiene conceptos segun tipo de concepto (taxonomia o indicador) y tipo de valor
    /// </summary>
    public string getConceptos(string CodiEmex, string CodiEmpr, string TipoTaxo, string CodiConc, string TipoRepo, string tnull, string tnull1)
    {
        return "execute SP_AX_GetConcPorPrefConc '" + CodiEmex + "','" + CodiEmpr + "','" + TipoTaxo + "','" + CodiConc + "', '" +TipoRepo+"'";
    }
    /// <summary>
    /// Obtiene conceptos por taxonomía y codigo parcial
    /// </summary>
    public string getConceptosPorTaxonomia(string CodiEmex, string CodiEmpr, string VersTaxo, string DescConc, string CodiInfo, string OrdeConc, string PrefConc, string CodiConc, string TipoTaxo)
    {
        return "execute SP_AX_GetConcPorTaxonomia '" + CodiEmex + "','" + CodiEmpr + "','" + VersTaxo + "','" + DescConc + "','" + CodiInfo  + "','" + OrdeConc + "','" + PrefConc + "','" + CodiConc + "','" + TipoTaxo + "'";
    }
    /// <summary>
    /// Obtiene lista de conceptos de un informe, sus niveles y si son negritas
    /// </summary>
    public string getInfoDescConc(string CodiEmex, string CodiEmpr, string CodiInfo, string TipoInfo)
    {
        return "execute SP_AX_getInfoDescConc '" + CodiEmex + "','" + CodiEmpr + "','" + CodiInfo + "','" + TipoInfo + "'";
    }
    /// <summary>
    /// Obtiene lista de conceptos de un informe, sus niveles, si son negritas y su tipo de valor
    /// </summary>
    public string getInfoDescConcConTipos(string CodiEmex, string CodiEmpr, string CodiInfo, string TipoInfo)
    {
        return "execute SP_AX_getInfoDescConcConTipos '" + CodiEmex + "','" + CodiEmpr + "','" + CodiInfo + "','" + TipoInfo + "'";
    }
    public string getInfoValoColu(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string VersInst, string CodiInfo, string FiniCntx, string FfinCntx, string CodiMone)
    {
        return "execute SP_AX_getInfoValoColu '" + CodiEmex + "','" + CodiEmpr + "','" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + CodiInfo + "','" + FiniCntx + "','" + FfinCntx + "','"+CodiMone+"'";
    }
    public string getInfoValoColu(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string VersInst, string CodiInfo, string FiniCntx, string FfinCntx, string CodiMone, string TipoInfo)
    {
        return "execute SP_AX_getInfoValoColu '" + CodiEmex + "','" + CodiEmpr + "','" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + CodiInfo + "','" + FiniCntx + "','" + FfinCntx + "','" + CodiMone + "','" + TipoInfo + "'";
    }
    public string getCodiMone(string CodiPers, string CorrInst)
    {
        return "execute SP_AX_getTipoMone '" + CodiPers + "'," + CorrInst;
    }

    public string getCodiMone(string CodiPers, string CorrInst, string VersInst)
    {
        return "execute SP_AX_getTipoMone '" + CodiPers + "'," + CorrInst + "," + VersInst;
    }

    /// <summary>
    /// Devuelve el query necesario para obtener la lista de indicadores
    /// </summary>
    public string getListaIndicadores(string CodiEmex, string CodiEmpr, string TipoTaxo, string CodiIndi)
    {
        return "execute SP_AX_GetListaIndicadoresEmpresa '" + CodiEmex + "','" + CodiEmpr + "','" + TipoTaxo  + "','" + CodiIndi + "'";
    }
    public string getListaIndicadores(string CodiEmex, string CodiEmpr, string TipoTaxo, string CodiIndi, string VisuIndi)
    {
        return "execute SP_AX_GetListaIndicadoresEmpresa '" + CodiEmex + "','" + CodiEmpr + "','" + TipoTaxo + "','" + CodiIndi + "','" + VisuIndi + "'";
    }
    /// <summary>
    /// Elimina definición de informe
    /// </summary>
    public string delInfoDefi(string CodiEmex, string CodiEmpr, string CodiInfo)
    {
        return "execute SP_AX_delInfoDefi '" + CodiEmex + "','" + CodiEmpr + "','" + CodiInfo + "'";
    }
    public string ObtenerEmprInfor(string CodiPers, string CorrInst, string VersInst)
    {
        return "execute SP_AX_RescEmrInfor '" + CodiPers + "', '" + CorrInst + "', '" + VersInst + "'";
    }
    public string getConceptosInformes(string CodiEmex, string CodiEmpr, string CodiInfo, string TipoInfo)
    {
        return "execute SP_AX_getConcepInfo '" + CodiEmex + "','" + CodiEmpr + "','" + CodiInfo + "','" + TipoInfo + "'";
    }
    public string delInfoConc(string CodiEmex, string CodiEmpr, string CodiInfo, string PrefConc, string CodiConc, string OrdeConc)
    {
        return "execute SP_AX_delInfoConc '" + CodiEmex + "','" + CodiEmpr + "','" + CodiInfo + "','" + PrefConc + "','" + CodiConc + "','" + OrdeConc + "'";
    }
    public string insInfoConc(string CodiEmex, string CodiEmpr, string informe, string pref_conc, string codi_concepto, string orden, string nivel)
    {
        return "execute SP_AX_insInfoConc '" + CodiEmex + "','" + CodiEmpr + "','" + informe + "','" + pref_conc  + "','" + codi_concepto + "','" + orden + "','" + nivel + "'";
    }
    public string insCopiaInfoConc(string CodiEmexO, string CodiEmprO, string informeO, string CodiEmexF, string CodiEmprF, string informeF)
    {
        return "execute SP_AX_insCopiaInfoConc '" + CodiEmexO + "','" + CodiEmprO + "','" + informeO + "','" + CodiEmexF + "','" + CodiEmprF + "','" + informeF + "'";
    }
    public string ModificarConceptos(string CodiEmex, string CodiEmpr, string Informe, string PrefConc, string codi_concepto, string Orden, string nivel, string negrita)
    {
        return "execute SP_AX_updInfoConc '" + CodiEmex + "','" + CodiEmpr + "','" + Informe + "','" + PrefConc + "','" + codi_concepto + "','" + Orden + "','" + nivel + "','" + negrita + "'";
    }
    
    /// <summary>
    /// Actualiza informe
    /// </summary>
    public string updInfoDefi(string CodiEmex, string CodiEmpr, string CodiInfo, string DescInfo, string IndiVige, string CodiCort)
    {
        return "execute SP_AX_updInfoDefi '" + CodiEmex + "','" + CodiEmpr + "','" + CodiInfo + "','" + DescInfo + "','" + IndiVige + "','" + CodiCort + "'";
    }
    /// <summary>
    /// Inserta nuevo informe
    /// </summary>
    public string insInfoDefi(string CodiEmex, string CodiEmpr, string DescInfo, string TipoTaxo, string IndiVige, string CodiCort)
    {
        return "execute SP_AX_insInfoDefi '" + CodiEmex + "','" + CodiEmpr + "','" + getCodiInfo(DescInfo) + "','" + DescInfo + "','" + TipoTaxo + "','" + IndiVige + "','" + CodiCort + "'";
    }
    /// <summary>
    /// Inserta nuevo informe
    /// </summary>
    public string insInfoDefi(string CodiEmex, string CodiEmpr, string CodiInfo, string DescInfo, string TipoTaxo, string IndiVige, string CodiCort)
    {
        return "execute SP_AX_insInfoDefi '" + CodiEmex + "','" + CodiEmpr + "','" + CodiInfo + "','" + DescInfo + "','" + TipoTaxo + "','" + IndiVige + "','" + CodiCort + "'";
    }
    /// <summary>
    /// Metodo que se ocupara para seleccionar 1 informe
    /// </summary>
    public string getInfoDefi(string CodiEmex, int CodiEmpr, string CodiInfo)
    {
        return "execute SP_AX_getInfoDefi '"+CodiEmex+"', "+CodiEmpr+", '"+CodiInfo+"'";
    }
    /// <summary>
    ///A partir de la descripcion del informe genera un codigo para insercion
    /// </summary>
    public string getCodiInfo(string DescInfo)
    {
        if (DescInfo.Length > 0)
        {
            vCodiInfo = DescInfo.Replace(" ", "");
            vCodiInfo = vCodiInfo.Substring(0, Math.Min(vCodiInfo.Length,49));
        }
        else {
            return "0";
        }
            
        return vCodiInfo;
    }
    public string UpdDescEmpr(string codi_emex, string codi_empr, string codi_pers, string desc_empr, string codi_grup, string codi_segm, string tipo_taxo)
    {
        return "execute SP_AX_UpdDescEmpresa '" + codi_emex + "','" + codi_empr + "','" + codi_pers + "','" + desc_empr + "', '" + codi_grup + "','" + codi_segm + "','" + tipo_taxo + "'";
    }
    public string getPersCorrInst(string CodiPers)
    {
        return "execute SP_AX_getPersCorrInst '" + CodiPers + "'";
    }
    public string getPersCorrInst(string CodiPers, string CorrInst)
    {
        return "execute SP_AX_getPersCorrInst '" + CodiPers + "','" + CorrInst+"'";
    }
    /// <summary>
    /// Obtiene listado de versiones cargadas para Empresa/Instancia
    /// </summary>
    public string getPersVersInst(string CodiPers, string CorrInst)
    {
        return "execute SP_AX_getPersCorrVersInst '" + CodiPers + "','" + CorrInst + "','I'";
    }
    /// <summary>
    /// Obtiene los valores ingresados para una empresa, instancia, version, prefijo, concepto, contexto
    /// </summary>
    public string getValoEmprInstVersPrefConcCntx(string CodiPers, string CorrInst, string VersInst, string PrefConc, string CodiConc, string CodiCntx)
    {
        return "execute SP_AX_GetValoEmprInstVersPrefConcCntx '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + PrefConc + "','" + CodiConc + "','" + CodiCntx + "'";
    }
    /// <summary>
    /// Actualiza los valores de la tabla dbax_inst_conc y se insertan registros en dbax_inst_modi
    /// </summary>
    public string updValorInstConc(string CodiPers, string CorrInst, string VersInst, string PrefConc, string CodiConc, string CodiCntx, string ValoCntx, string ValoRefe, string ValoInte)
    {
        return "execute SP_AX_updValorInstConc '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + PrefConc + "','" + CodiConc + "','" + CodiCntx + "','" + ValoCntx + "','" + ValoRefe + "','" + ValoInte + "'";
    }
    /// <summary>
    /// Inserta los valores en la tabla dbax_inst_conc y se insertan registros en dbax_inst_modi
    /// </summary>
    public string insValorEdicionInstConc(string CodiPers, string CorrInst, string VersInst, string PrefConc, string CodiConc, string CodiCntx, string ValoCntx, string ValoRefe, string ValoInte)
    {
        return "execute SP_AX_insValorEdicionInstConc '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + PrefConc + "','" + CodiConc + "','" + CodiCntx + "','" + ValoCntx + "','" + ValoRefe + "','" + ValoInte + "'";
    }
    /// <summary>
    /// Devuelve [1,0] dependiendo de si la versión pasada por parámetros es la ultima (se consideran las de dbax_arch_temp)
    /// </summary>
    public string getEsUltimaVers(string CodiPers, string CorrInst, string VersInst)
    {
        return "execute SP_AX_getEsUltimaVers '" + CodiPers + "','" + CorrInst + "','" + VersInst + "'";
    }
    /// <summary>
    /// Obtiene listado de versiones externas cargadas para Empresa/Instancia
    /// </summary>
    public string getPersVersInstExte(string CodiPers, string CorrInst, string UsuaCarg)
    {
        return "execute SP_AX_getPersCorrVersInst '" + CodiPers + "','" + CorrInst + "','E', 'T','" + UsuaCarg + "'";
    }
    /// <summary>
    /// Obtiene SIGUIENTE version (aun no está cargada)
    /// </summary>
    public string getSigPersVersInst(string CodiPers, string CorrInst)
    {
        return "execute SP_AX_getPersCorrVersInst '" + CodiPers + "','" + CorrInst + "','I','S'";
    }
    /// <summary>
    /// Obtiene ULTIMA version cargada (Si no hay cargadas devuelve 0)
    /// </summary>
    public string getUltPersVersInst(string CodiPers, string CorrInst)
    {
        return "execute SP_AX_getPersCorrVersInst '" + CodiPers + "','" + CorrInst + "','I','M'";
    }
    public string getSigPersVersInstExte(string CodiPers, string CorrInst)
    {
        return "execute SP_AX_getPersCorrVersInst '" + CodiPers + "','" + CorrInst + "','E','S'";
    }
    /// <summary>
    /// Obtiene ULTIMA version cargada (desde GX) (Si no hay cargadas devuelve 0)
    /// </summary>
    public string getSigPersVersInstExte(string CodiPers, string CorrInst, string DbgxEmpr, string DbgxCorr, string DbgxVers)
    {
        return "execute SP_AX_getPersCorrVersInst '" + CodiPers + "','" + CorrInst + "','E','S'";
    }
    /// <summary>
    /// Devuelve la lista de informes definidos (parciales)
    /// </summary>
    public string getInformes(string CodiEmex, string CodiEmpr, string Tipo)
    {
        return "execute SP_AX_getInformes '" + CodiEmex + "','" + CodiEmpr + "','" + Tipo + "'";
    }
    /// <summary>
    /// Devuelve la lista de informes definidos (parciales)
    /// </summary>
    public string getInformes(string CodiEmex, string CodiEmpr, string TipoTaxo, string TipoInfo)
    {
        return "execute SP_AX_getInformes '" + CodiEmex + "','" + CodiEmpr + "','" + TipoTaxo + "','" + TipoInfo + "'";
    }
    public string getInformesActivos(string CodiEmex, string CodiEmpr, string TipoTaxo, string TipoInfo)
    {
        return "execute SP_AX_getInformesActivos '" + CodiEmex + "','" + CodiEmpr + "','" + TipoTaxo + "','" + TipoInfo + "'";
    }
    /// <summary>
    /// Obtiene datos de informe por codiInfo
    /// </summary>
    public string getInforme(string CodiEmex, string CodiEmpr, string CodiInfo, string TipoInfo)
    {
        return "execute SP_AX_getInforme '" + CodiEmex + "','" + CodiEmpr + "','" + CodiInfo + "','" + TipoInfo + "'";
    }
    /// <summary>
    /// Devuelve todos los informes totalmente definidos y que fueron informados por la empresa
    /// </summary>
    public string getInformesUsables(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string VersInst, string TipoInfo, string TipoTaxo)
    {
        return "execute SP_AX_getInformesUsables '" + CodiEmex + "','" + CodiEmpr + "','" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + TipoInfo + "','" + TipoTaxo + "'";
    }
    /// <summary>
    /// Devuelve el maximo orden para un informe dado
    /// </summary>
    /// 
    public string getMaxOrdeConc(string CodiEmex, string CodiEmpr, string CodiInfo)
    {
        return "execute SP_AX_getMaxOrdeConc '" + CodiEmex + "','" + CodiEmpr + "','" + CodiInfo + "'";
    }
    /// <summary>
    /// Devuelve todas las dimensiones
    /// </summary>
    public string getDimensionesUsables(string codi_emex, string codi_empr, string Informe)
    {
        return "execute SP_AX_getDimensionesUsables '" + codi_emex + "','" + codi_empr + "','" + Informe + "'";
    }
    /// <summary>
    /// Obtiene el detalle del encabezado de la dimension
    /// </summary>
    public string getDetalleDimension(string codi_info, string pref_dime, string codi_dime)
    {
        return "execute SP_AX_getDetaDime '" + codi_info + "','" + pref_dime + "','" + codi_dime + "'";
    }
    /// <summary>
    /// Devuelve todas los informes de dimensiones
    /// </summary>
    public string getInformesDimension(string tipo_info, string codi_pers, string corr_inst)
    {
        return "execute SP_AX_getInformesDimension '" + tipo_info + "','" + codi_pers + "','" + corr_inst + "'";
    }
    /// <summary>
    /// Devuelve todas los informes de dimensiones por tipo de taxonomia
    /// </summary>
    public string getInformesDimension(string tipo_taxo, string tipo_info, string codi_pers, string corr_inst)
    {
        return "execute SP_AX_getInformesDimension '" + tipo_info + "','" + codi_pers + "','" + corr_inst + "','" + tipo_taxo + "'";
    }
    /// <summary>
    /// Devuelve todas los conceptos de la dimension
    /// </summary>
    public string getInfoDimensionDescConc(string CodiInfo, string dimension, string tipo_taxo)
    {
        return "execute SP_AX_getInfoDimensionDescConc '" + CodiInfo + "','" + dimension + "', '"+tipo_taxo+"'";
    }
    /// <summary>
    /// Devuelve los valores de los conceptos de dimension por miembro
    /// </summary>
    public string getInfoValoColuDimension(string CodiPers, string CorrInst, string VersInst, string CodiInfo, string desc_miembro, string dimension, string tipo_memb, string codi_mone, string codi_conc, string pref_conc, string tipo_taxo, string sald_ini)
    {
        return "execute SP_AX_getInfoValoColuDimension '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + CodiInfo + "','" + desc_miembro + "','" + dimension + "','" + tipo_memb + "','"+codi_mone+"','"+codi_conc+"','"+pref_conc+"','"+tipo_taxo+"','"+sald_ini+"'";
    }
    /// <summary>
    ///Guarda las empresas que no esten registardas
    /// </summary>
    public string InstEmpreArchXbrl(string codi_pers)
    {
        return "execute SP_AX_InstEmpreArchXbrl '" + codi_pers + "'";
    }
     /// <summary>
    /// Metodo para extraer personas de dbax_inst_arch
    /// </summary>
    public string GetPersArch(string periodo, string version)
    {
        return "execute SP_AX_GetPersScript'" + periodo + "','" + version + "'";
    }
    /// <summary>
    /// Metodo para generar el script de la base de datos de la  dbax_inst_arch
    /// </summary>
    /// 
    public string GetArchXBRL(string persona, string periodo, string version)
    {
        return "execute SP_AX_GetDatosScript'" + persona + "','" + periodo + "','" + version + "'";
    }
    /// <summary>
    /// Metodo para imprimir archivo
    /// </summary>
    /// 
    public void ImprimeArchivo(DataTable tabla)
    {
        string sNombreInforme = "SCRIPTXBRL";
        string sRuta = "";
        string sNombre = "";
        sRuta = "C:\\DBNeT";
        sNombre = sNombreInforme + "_" + DateTime.Now.ToString("dd-MM-yyyy") + ".txt";
        try
        {
            FileStream fsFlujo = new FileStream(sRuta + "\\" + sNombre, FileMode.Append, FileAccess.Write);
            StreamWriter swGrabador = new StreamWriter(fsFlujo, Encoding.GetEncoding("ISO-8859-1"));
            foreach (DataRow drFila in tabla.Rows)
            {
                // se debe modificar la linea de  impresión al momento de crear un nuevo script
                if (drFila["valo_cntx"].ToString().Length > 1000)
                {
                    Console.WriteLine("adsadkljs");
                }
                swGrabador.WriteLine("insert into dbax_inst_conc (codi_pers, corr_inst, vers_inst, pref_conc, codi_conc, codi_cntx, valo_cntx, valo_seri, valo_nota, codi_unit )  values ('" + drFila["codi_pers"].ToString() + "','" + drFila["corr_inst"].ToString() + "','" + drFila["vers_inst"].ToString() + "','" + drFila["pref_conc"].ToString() + "','" + drFila["codi_conc"].ToString() + "','" + drFila["codi_cntx"].ToString() + "','" +  drFila["valo_cntx"].ToString().Replace( "'", "''") + "','" + drFila["valo_seri"].ToString() + "','" + drFila["valo_nota"].ToString() + "','" + drFila["codi_unit"].ToString() + "')");
               // swGrabador.WriteLine("insert into dbax_inst_arch (codi_pers, corr_inst, vers_inst, nomb_arch, cont_arch, tipo_mime )  values ('" + drFila[0].ToString() + "','" + drFila[1].ToString() + "','" + drFila[2].ToString() + "','" + drFila[3].ToString() + "','" + drFila[4].ToString() + "','" + drFila[5].ToString()+ "')");
               swGrabador.WriteLine("GO");
            }
           
            swGrabador.Close();
            fsFlujo.Close();
            swGrabador = null;
            fsFlujo = null;
        }
        catch
        {
        }
    }
    public string GetEjesDimension(string CodiInfo, string PrefDime, string CodiDime)
    {
        return "execute prc_read_dbax_ejes '" + CodiInfo + "','" + PrefDime + "','" + CodiDime + "'";
    }
    public string GetCounEje(string CodiInfo, string CodiDime)
    {
        return "execute SP_AX_getCounDimeEjes '" + CodiInfo + "','" + CodiDime + "'";
    }
    public string GetCounMemb(string CodiInfo, string CodiAxis)
    {
        return "execute SP_AX_getCounDimeMemb '" + CodiInfo + "','" + CodiAxis + "'";
    }
    public string GetExceptDime(string CodiPers, string CorrInst, string VersInst, string CodiAxis)
    {
        /*return " select  id.codi_cntx " +
               " from dbax_inst_dicx id " +
               " where id.codi_pers= " + CodiPers +
               " and   id.corr_inst= " + CorrInst +
               " and   id.vers_inst= " + VersInst +
               " and   id.codi_axis= '" + CodiAxis + "'";*/

        string vQuery = "";
        /*vQuery =   " (select     id.codi_cntx, 1 " +
                   " from       dbax_inst_dicx id " +
                   " where      id.codi_pers= " + CodiPers +
                   " and        id.corr_inst= " + CorrInst +
                   " and        id.vers_inst= " + VersInst +
                   " and        id.codi_axis= '" + CodiAxis + "' " +
                   " union " +
                   " select     id.codi_cntx, 2 " +
                   " from       dbax_inst_dicx id " +
                   " where      id.codi_pers= " + CodiPers +
                   " and        id.corr_inst= " + CorrInst +
                   " and        id.vers_inst= " + VersInst +
                   " and        id.codi_axis= '" + CodiAxis + "' " +
                   " union " +
                   " select     id.codi_cntx, 2 " +
                   " from       dbax_inst_dicx id " +
                   " where      id.codi_pers= " + CodiPers +
                   " and        id.corr_inst= " + CorrInst +
                   " and        id.vers_inst= " + VersInst +
                   " and        id.codi_axis= '" + CodiAxis + "' " +
                   " union " +
                   " select     id.codi_cntx, 1 " +
                   " from       dbax_inst_dicx id " +
                   " where      id.codi_pers= " + CodiPers +
                   " and        id.corr_inst= " + CorrInst +
                   " and        id.vers_inst= " + VersInst + "' )";*/
        vQuery = " (select     id.codi_cntx, 1" +
                   " from   dbax_inst_dicx id " +
                   " where  id.codi_pers= @CodiPers " +
                   " and    id.corr_inst= @CorrInst " +
                   " and    id.vers_inst= @VersInst " +
                   " and        id.codi_axis= '" + CodiAxis + "' " +
                   " union " +
                   " select     id.codi_cntx, 2 " +
                   " from       dbax_inst_dicx id " +
                   " where  id.codi_pers= @CodiPers " +
                   " and    id.corr_inst= @CorrInst " +
                   " and    id.vers_inst= @VersInst " +
                   " and        id.codi_axis= '" + CodiAxis + "')";

        return vQuery;
    }
    public string GetIntersectDime(string CodiPers, string CorrInst, string VersInst, string CodiAxis, string CodiMemb)
    {
        /*return " select  ic.codi_cntx, ic.fini_cntx, ffin_cntx " +
               " from   dbax_inst_cntx ic, " +
                "       dbax_inst_dicx id " +
               " where  ic.codi_pers= " + CodiPers +
               " and    ic.corr_inst= " + CorrInst +
               " and    ic.vers_inst= " + VersInst +
               " and    id.codi_pers = ic.codi_pers " +
               " and    id.corr_inst = ic.corr_inst " +
               " and    id.vers_inst = ic.vers_inst " +
               " and    id.codi_cntx = ic.codi_cntx " +
               " and    id.codi_axis= '" + CodiAxis + "'" +
               " and    id.codi_memb= '" + CodiMemb + "'";*/
        string vQuery = "";

        vQuery = " (select  id.codi_cntx, t.campo1  " +
                   " from   dbax_inst_dicx id, dbax_auxi_visu T " +
                   " where  id.codi_pers= @CodiPers " +
                   " and    id.corr_inst= @CorrInst " +
                   " and    id.vers_inst= @VersInst " +
                   " and    id.codi_axis= '" + CodiAxis + "'" +
                   " and    id.codi_memb= '" + CodiMemb + "') ";
                   //" union" +
                   //" select  id.codi_cntx, 2 " +
                   //" from   dbax_inst_dicx id " +
                   //" where  id.codi_pers= @CodiPers " +
                   //" and    id.corr_inst= @CorrInst " +
                   //" and    id.vers_inst= @VersInst " +
                   //" and    id.codi_axis= '" + CodiAxis + "'" +
                   //" and    id.codi_memb= '" + CodiMemb + "') ";

        return vQuery;
    }

    public string GetCntxInst(string CodiPers, string CorrInst, string VersInst)
    {
        string vQuery = "";

        vQuery ="  declare @CodiPers numeric(16,0), @CorrInst numeric(9,0), @VersInst numeric(10,0); " +
                "  set @CodiPers = " + CodiPers + ";" +
                " set @CorrInst = " + CorrInst  + ";" +
                " set @VersInst = " + VersInst + ";" +
                "(select    ic.codi_cntx, 1 " +
                " from      dbax_inst_cntx ic  " +
                " where     ic.codi_pers= @CodiPers" +
                " and       ic.corr_inst= @CorrInst" +
                " and       ic.vers_inst= @VersInst" +
                " and       ( " +
                "               (ic.fini_cntx=dbo.FU_AX_getFechas(@CorrInst,'inicioano','anoactual') " +
                "               and   ic.ffin_cntx=dbo.FU_AX_getFechas(@CorrInst,'ultimodiatrimestreactual','anoactual')) " +
                "           or (ic.fini_cntx=dbo.FU_AX_getFechas(@CorrInst,'ultimodiatrimestreactual','anoactual') " +
                "               and isnull(ic.ffin_cntx,'') = '') " +
                "           ) " +
                " union " +
                " select    ic.codi_cntx, 2 " +
                " from      dbax_inst_cntx ic  " +
                " where     ic.codi_pers= @CodiPers" +
                " and       ic.corr_inst= @CorrInst" +
                " and       ic.vers_inst= @VersInst" +
                " and       ic.fini_cntx=dbo.FU_AX_getFechas(@CorrInst,'finano','anoanterior') " +
                " and       isnull(ic.ffin_cntx,'') = '')";
        return vQuery;
    }
    /// <summary>
    /// Obtiene una columna completa de valores de una dimension
    /// </summary>
    ///
    public string GetValoresPorInfoDimeCntx(string CodiPers, string CorrInst, string VersInst, string CodiCntx, string CodiInfo, string PrefDime, string CodiDime, string CodiMone)
    {
        return "execute SP_AX_getValoresPorInfoDimeCntx '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + CodiCntx + "','" + CodiInfo + "','" + PrefDime + "','" + CodiDime + "','" + CodiMone + "'";
    }

    internal string getValoConcClob(string CorrConc, string CodiPers, string CorrInst, string VersInst)
    {
        return "execute Sp_AX_getValoConcClob " + CorrConc + "," + CodiPers + "," + CorrInst + "," + VersInst;
    }
}