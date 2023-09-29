using System.Data;

public partial class MantencionIndicadores
{
    Conexion con = new Conexion().CrearInstancia();
    ModeloMantencionIndicadores modIndi = new ModeloMantencionIndicadores();
    RescateDeConceptos modConc = new RescateDeConceptos();
    ModeloMantencionCntx cntx = new ModeloMantencionCntx();

    public DataTable getPrefConcPorCodiConc(string CodiEmex, string CodiEmpr, string codi_conc)
    {
        return con.TraerResultados0(modConc.getPrefConcPorCodiConc(CodiEmex, CodiEmpr, codi_conc)).Tables[0];
    }

    /// <summary>
    /// Setea las variables y el concepto asociado
    /// </summary>
    public void setDetalleIndicador()
    {
        modIndi.setDetalleIndicador();
    }
    public DataSet ObtenerTipoIndicadores()
    {
        return con.TraerResultados0(modConc.ObtenerTipoIndicadores());
    }
    /// <summary>
    /// Setea el miembro cadenaVariables a partir de una cadena ingresada como parámetro
    /// </summary>
    public void setCadenaFormula(string cadena)
    {
        modIndi.setCadenaFormula(cadena);
        modIndi.setNumeroVariablesFormula();
    }
    /// <summary>
    /// Devuelve el número de variables definidas en la fórmula
    /// </summary>
    public int getNumeroVariablesFormula()
    {
        return modIndi.getNumeroVariablesFormula();
    }
    /// <summary>
    /// Devuelve un arreglo que contiene las variables definidas en la formula ingresada
    /// </summary>
    public string[] getVariablesFormula()
    {
        return modIndi.getVariablesFormula();
    }
    /// <summary>
    /// Setea las variables para el encabezado del indicador.
    /// </summary>
    public void setEncabezadoIndicador(string vModo, string vHolding, string vEmpresa, string vNombre, string vAgrupacion, string vDescripcion, string vFormula, string vTipoTaxo, string vRefeMini, string vRefeMaxi, bool vVisuIndi, bool vApliHold)
    {
        modIndi.setEncabezadoIndicador(vHolding, vEmpresa, vNombre, vAgrupacion, vDescripcion, vFormula, vTipoTaxo, vRefeMini, vRefeMaxi, vVisuIndi, vApliHold);
        con.EjecutarQuery(modIndi.insEncabezadoIndicador(vModo));
    }
    /// <summary>
    /// Valida una cadena de texto y la asigna al atributo cadenaVariables
    /// </summary>
    public void setCadenaVariables(string cadena)
    {
        modIndi.setCadenaVariables(cadena);
        modIndi.validaContextosDetalle();
        int vNumero = modIndi.getNumeroVariablesLlenas();
        string[] cadenas = new string[vNumero];
        cadenas = modIndi.insDetalleIndicador();
        for (int i = 0; i < vNumero; i++)
        {
            con.EjecutarQuery(cadenas[i]);
        }
    }
    /// <summary>
    /// Obtiene conceptos monetarios
    /// </summary>
    public DataSet getConceptos(string CodiEmex, string CodiEmpr, string CodiConc, string TipoElem, string CodiConc2)
    {
        return con.TraerResultados0(modConc.getConceptos(CodiEmex, CodiEmpr, CodiConc, TipoElem, CodiConc2));
    }
    /// <summary>
    /// Obtiene conceptos
    /// </summary>
    public DataSet getConceptos(string CodiEmex, string CodiEmpr, string CodiConc, string TipoElem, string CodiConc2, string TipoValo)
    {
        return con.TraerResultados0(modConc.getConceptos(CodiEmex, CodiEmpr, CodiConc, TipoElem, CodiConc2, TipoValo));
    }
    /// <summary>
    /// Obtiene conceptos monetarios segun prefijo
    /// </summary>
    public DataSet getConceptos(string CodiEmex, string CodiEmpr, string PrefConc, string CodiConc, string TipoRepo, string tnull, string tnull1)
    {
        return con.TraerResultados0(modConc.getConceptos(CodiEmex, CodiEmpr, PrefConc, CodiConc,TipoRepo,tnull,tnull1));
    }
    /// <summary>
    /// Obtiene conceptos por taxonomía y codigo parcial
    /// </summary>
    public DataSet getConceptosPorTaxonomia(string CodiEmex, string CodiEmpr, string VersTaxo, string DescConc, string CodiInfo, string OrdeConc, string PrefConc, string CodiConc, string TipoTaxo)
    {
        //Si todos estos parámetros están vacios, probablemente la cadena es del tipo:
        //[BALA_CLAS] [40]     Efectivo y equivalentes al efectivo (ifrs)
        //Pudo causarse por que se perdieron los valores de dtConceptos
        //Debo limpiar esa cadena para poder buscar por descripción
        if (CodiInfo == "" && PrefConc == "" && CodiConc == "" && OrdeConc == "")
        {
            int posCorcheteFinal;
            posCorcheteFinal = DescConc.LastIndexOf("]");
            if (posCorcheteFinal > 0)
                DescConc = DescConc.Substring(posCorcheteFinal+1).Trim();
        }
        return con.TraerResultados0(modConc.getConceptosPorTaxonomia(CodiEmex, CodiEmpr, VersTaxo, DescConc, CodiInfo, OrdeConc, PrefConc, CodiConc, TipoTaxo));
    }
    public string getCadenaFormula()
    {
        return modIndi.getCadenaFormula();
    }
    /// <summary>
    /// Obtiene la lista de los indicadores definidos para el holding/empresa
    /// </summary>
    public DataTable getListaIndicadores(string CodiEmex, string CodiEmpr, string TipoTaxo, string CodiIndi)
    {
        return con.TraerResultadosT0(modConc.getListaIndicadores(CodiEmex, CodiEmpr, TipoTaxo, CodiIndi));
    }
    public DataTable getListaIndicadores(string CodiEmex, string CodiEmpr, string TipoTaxo, string CodiIndi,string VisuIndi)
    {
        return con.TraerResultadosT0(modConc.getListaIndicadores(CodiEmex, CodiEmpr, TipoTaxo, CodiIndi, VisuIndi));
    }
    public DataTable getEncabezadoIndicador(string vCodi_emex, string vCodi_empr, string vCodi_indi)
    {
        return con.TraerResultadosT0(modIndi.getEncabezadoIndicador(vCodi_emex, vCodi_empr, vCodi_indi));
    }
    /// <summary>
    /// Obtiene la lista de los conceptos de a uno
    /// </summary>
    public DataTable getDetalleIndicador(string vCodi_emex, string vCodi_empr, string vCodi_indi, string vLetr_indi)
    {
        return con.TraerResultadosT0(modIndi.getDetalleIndicador(vCodi_emex, vCodi_empr, vCodi_indi, vLetr_indi));
    }
    /// <summary>
    /// Obtiene la lista de los conceptos (sobrecargado)
    /// </summary>
    public DataTable getDetalleIndicador(string vCodi_emex, string vCodi_empr, int vCorrInst, string vCodi_indi)
    {
        return con.TraerResultadosT0(modIndi.getDetalleIndicador(vCodi_emex, vCodi_empr, vCorrInst, vCodi_indi));
    }
    /// <summary>
    /// extrae los conceptos de los informes
    /// </summary>
    public DataSet getConceptosInformes(string CodiEmex, string CodiEmpr, string CodiInfo, string TipoInfo)
    {
        return con.TraerResultados0(modConc.getConceptosInformes(CodiEmex, CodiEmpr, CodiInfo, TipoInfo));
    }
    /// <summary>
    /// Elimina definicion de informe
    /// </summary>
    public void delInfoDefi(string CodiEmex, string CodiEmpr, string CodiInfo)
    {
        con.EjecutarQuery(modConc.delInfoDefi(CodiEmex, CodiEmpr, CodiInfo));
    }
    /// <summary>
    /// Eliminar Conceptos informe
    /// </summary>
    public void delInfoConc(string CodiEmex, string CodiEmpr, string CodiInfo, string PrefConc, string CodiConc, string OrdeConc)
    {
        con.EjecutarQuery(modConc.delInfoConc(CodiEmex, CodiEmpr, CodiInfo, PrefConc, CodiConc, OrdeConc));
    }
    /// <summary>
    /// Agregar Conceptos informe
    /// </summary>
    public void insInfoConc(string CodiEmex, string CodiEmpr, string informe, string pref_conc, string codi_concepto, string orden, string nivel)
    {
        con.EjecutarQuery(modConc.insInfoConc(CodiEmex, CodiEmpr, informe, pref_conc, codi_concepto, orden, nivel));
    }
    /// <summary>
    /// Copiar conceptos de informe original a informe final
    /// </summary>
    public void insCopiaInfoConc(string CodiEmexO, string CodiEmprO, string informeO, string CodiEmexF, string CodiEmprF, string informeF)
    {
        con.EjecutarQuery(modConc.insCopiaInfoConc(CodiEmexO, CodiEmprO, informeO, CodiEmexF, CodiEmprF, informeF));
    }
    /// <summary>
    /// Modificar Conceptos
    /// </summary>
    public void ModificarConceptos(string CodiEmex, string CodiEmpr, string Informe, string PrefConc, string codi_concepto, string Orden, string nivel, string negrita)
    {
        con.EjecutarQuery(modConc.ModificarConceptos(CodiEmex, CodiEmpr, Informe, PrefConc, codi_concepto, Orden, nivel, negrita));
    }
    public void delIndicador(string vHolding, string vEmpresa, string vNombre)
    {
         con.EjecutarQuery(modIndi.delIndicador(vHolding, vEmpresa, vNombre));
    }
    /// <summary>
    /// Obtiene código de informe a partir de la descripción
    /// </summary>
    public string getCodiInfo(string DescInfo)
    {
        return modConc.getCodiInfo(DescInfo);
    }
    /// <summary>
    /// Insertar Nuevo informe
    /// </summary>
    public void insInfoDefi(string CodiEmex, string CodiEmpr, string DescInfo, string TipoTaxo, string IndiVige, string CodiCort)
    {
        con.TraerResultados0(modConc.insInfoDefi(CodiEmex, CodiEmpr, DescInfo, TipoTaxo, IndiVige, CodiCort));
    }

    /// <summary>
    /// Insertar Nuevo informe
    /// </summary>
    public void insInfoDefi(string CodiEmex, string CodiEmpr, string CodiInfo, string DescInfo, string TipoTaxo, string IndiVige, string CodiCort)
    {
        con.TraerResultados0(modConc.insInfoDefi(CodiEmex, CodiEmpr, CodiInfo, DescInfo, TipoTaxo, IndiVige, CodiCort));
    }

    /// <summary>
    /// Metodo quie se ocupa para seleccionar informe
    /// </summary>
    /// <param name="CodiEmex"></param>
    /// <param name="CodiEmpr"></param>
    /// <param name="CodiInfo"></param>
    /// <returns></returns>
    public DataTable getInfoDefi(string CodiEmex, int CodiEmpr, string CodiInfo)
    {
        return con.TraerResultados0(modConc.getInfoDefi(CodiEmex,CodiEmpr,CodiInfo)).Tables[0];
    }
    /// <summary>
    /// Actualiza descripcion de informe
    /// </summary>
    public void updInfoDefi(string CodiEmex, string CodiEmpr, string CodiInfo, string DescInfo, string IndiVige, string CodiCort)
    {
        con.TraerResultados0(modConc.updInfoDefi(CodiEmex, CodiEmpr, CodiInfo, DescInfo, IndiVige, CodiCort));
    }
    /// <summary>
    /// Rescata Contextos por fechas
    /// </summary>
    public DataTable GetValoCntx(string Codi_pers, string Codi_inst, string Codi_vers, string pref_conc, string codi_conc, string Fecha_Inicio, string Fecha_Termino)
    {
        return con.TraerResultadosT0(modIndi.GetValoCntx(Codi_pers, Codi_inst, Codi_vers, pref_conc, codi_conc, Fecha_Inicio, Fecha_Termino));
    }
    /// <summary>
    /// Insertar Calculos de los indicadores
    /// </summary>
    public void InsValoresIndicadores(string codi_pers, string corr_inst, string vers_inst, string codi_conc, string codi_cntx, string valo_cntx, string Codi_unit)
    {
        con.EjecutarQuery(modIndi.InsValoresIndicadores(codi_pers, corr_inst, vers_inst, codi_conc, codi_cntx, valo_cntx, Codi_unit));
    }
    /// <summary>
    /// Rescata prefijos de conceptos definidos
    /// </summary>
    public DataTable getPrefConc()
    {
        return con.TraerResultadosT0(modIndi.getPrefConc());
    }
    /// <summary>
    /// Rescata prefijos de conceptos definidos para una taxonomia
    /// </summary>
    public DataTable getPrefConc(string VersTaxo)
    {
        return con.TraerResultadosT0(modIndi.getPrefConc(VersTaxo));
    }
    /// <summary>
    /// Metodo para llamar a calcular los indicadores por el web
    /// </summary>
    public void InsDatosCalIndicadores(string codi_emex, string codi_empr, string corr_inst, string codi_grup, string codi_segm, string codi_indi, string tipo_taxo)
    {
        con.EjecutarQuery(modIndi.InsDatosCalIndicadores(codi_emex, codi_empr, corr_inst, codi_grup, codi_segm, codi_indi, tipo_taxo));
    }
    /// <summary>
    /// Metodo para Extraer  las empresas que seran calulados
    /// </summary>
    public DataTable GetEmpresaIndicadores()
    {
        return con.TraerResultados0(modIndi.GetEmpresasIndicadores()).Tables[0];
    }
    /// <summary>
    /// Inserta linea de proceso para su ejecución 
    /// </summary>
    public void EjecutaProceso(string prog_proc,string arg_prog)
    {
        con.EjecutarQuery(modIndi.ejecuta_servicio(prog_proc,arg_prog));
    }
    /// <summary>
    /// Borrar Tabla temporal indicadores
    /// </summary>
    public void BorraTempIndi()
    {
        con.EjecutarQuery(modIndi.BorraTempIndi());
    }
    /// <summary>
    /// Obtiene contextos "normales" que se pueden usar para calcular un indicador para una empresa
    /// </summary>
    public DataTable GetContextosIndicadorEmpresa(string CodiEmpr, string CorrInst, string VersInst, string CodiIndi)
    {
        return con.TraerResultados0(modIndi.GetContextosIndicadorEmpresa(CodiEmpr, CorrInst, VersInst, CodiIndi)).Tables[0];
    }
    /// <summary>
    /// Obtiene contextos "normales" que se pueden usar para calcular un indicador para una empresa
    /// </summary>
    public DataTable getContextoFechas(string codiEmex, string CodiEmpr, string CorrInst, string CodiCntx)
    {
        return con.TraerResultados0(cntx.getContextoFechas(codiEmex, CodiEmpr, CorrInst, CodiCntx)).Tables[0];
    }
    public void InsAnomaliasIndicadores(string codi_pers, string corr_inst, string vers_inst, string codi_conc, string codi_cntx, string valo_cntx, string refe_mini, string refe_maxi)
    {
        con.EjecutarQuery(modIndi.InsAnomaliasIndicadores(codi_pers, corr_inst, vers_inst, codi_conc, codi_cntx, valo_cntx, refe_mini, refe_maxi));
    }

    public string GetPermusuaEmpr(string pCodiEmex, string vCodiPers, string pCodiUsua)
    {
       return con.StringEjecutarQuery(modIndi.GetPermusuaEmpr(pCodiEmex,vCodiPers,pCodiUsua));
    }
}