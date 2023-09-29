using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Xml.Linq;

public partial class MantencionCntx
{
    Conexion con = new Conexion().CrearInstancia();
    ModeloMantencionCntx cntx = new ModeloMantencionCntx();
    /// <summary>
    /// Guardar Contextos
    /// </summary>
    /// 
    public void insCntx(string CodiEmex, string CodiEmpr, string CodiCntx, string DescCntx, string DiaiCntx, string AnoiCntx, string DiatCntx, string AnotCntx)
    {
        con.TraerResultados0(cntx.insCntx(CodiEmex, CodiEmpr, CodiCntx, DescCntx, DiaiCntx, AnoiCntx, DiatCntx, AnotCntx));
    }
    /// <summary>
    /// Actualiza Contextos
    /// </summary>
    /// 
    public void UpdContexto(string CodiEmex, string CodiEmpr, string CodiCntx, string DescCntx, string DiaiCntx, string AnoiCntx, string DiatCntx, string AnotCntx)
    {
        con.TraerResultados0(cntx.UpdContexto(CodiEmex, CodiEmpr, CodiCntx, DescCntx, DiaiCntx, AnoiCntx, DiatCntx, AnotCntx));
    }
    /// <summary>
    /// Devuelve contextos definidos segun CodiEmex y CodiEmpr
    /// </summary>
    public DataSet getContextos(string CodiEmex, string CodiEmpr, string CodiInfo)
    {
        return con.TraerResultados0(cntx.getContextos(CodiEmex, CodiEmpr, CodiInfo));
    }
    /// <summary>
    /// Devuelve contextos definidos segun CodiEmex y CodiEmpr
    /// </summary>
    public DataSet getContextos(string CodiEmex, string CodiEmpr, int CorrInst)
    {
        return con.TraerResultados0(cntx.getContextos(CodiEmex, CodiEmpr, CorrInst));
    }
    /// <summary>
    /// Devuelve contextos definidos segun CodiEmex y CodiEmpr
    /// </summary>
    public DataSet getContextos(string CodiEmex, string CodiEmpr)
    {
        return con.TraerResultados0(cntx.getContextos(CodiEmex, CodiEmpr, 0));
    }
    /// <summary>
    /// Para un contexto dado obtiene sus fechas asociadas a un periodo determinado
    /// </summary>
    public DataSet getContextoFechas(string codiEmex, string codiEmpr, string CorrInst, string CodiCntx)
    {
        return con.TraerResultados0(cntx.getContextoFechas(codiEmex, codiEmpr, CorrInst, CodiCntx));
    }
    /// <summary>
    /// Eliminar cntx
    /// </summary>
    public void delCntx(string CodiEmex, string CodiEmpr, string CodiCntx)
    {
        con.TraerResultados0(cntx.delCntx(CodiEmex, CodiEmpr, CodiCntx));
    }
    /// <summary>
    /// LLenado de  grilla Informe
    /// </summary>
    /// 
    public DataSet getInformes(string CodiEmex, string CodiEmpr)
    {
        return con.TraerResultados0(cntx.getInformes(CodiEmex, CodiEmpr));
    }
    /// <summary>
    /// Insertar informes  y contextos
    /// </summary>
    /// 
    public void GuardarInfoCntx(string CodiEmex, string CodiEmpr, string Informe, string CntxEmex, string CntxEmp, string contexto, string orden)
    {
        con.TraerResultados0(cntx.Guarda_Info_cntx(CodiEmex, CodiEmpr, Informe, CntxEmex, CntxEmp, contexto, orden));
    }
    /// <summary>
    /// datos para grilla informe contexto
    /// </summary>
    /// 
    public DataSet llenado_grilla_cntx_informe(string informe)
    {
        return con.TraerResultados0(cntx.LLenado_grilla_informe_contexto(informe));
    }
    /// <summary>
    /// Eliminar info_cntx
    /// </summary>
    /// 
    public void delInfoCntx(string CodiEmex, string CodiEmpr, string CodiInfo, string CodiCntx)
    {
        con.TraerResultados0(cntx.delInfoCntx(CodiEmex, CodiEmpr, CodiInfo, CodiCntx));
    }
    /// <summary>
    /// Modificar grilla informe contexto
    /// </summary>
    /// 
    public void UpdOrdenInforme(string CodiEmex, string CodiEmpr, string CodiInfo, string CodiCntx, int OrdeConcAnt, int OrdeConcAct)
    {
        con.TraerResultados0(cntx.UpdOrdenInforme(CodiEmex, CodiEmpr, CodiInfo, CodiCntx, OrdeConcAnt, OrdeConcAct));
    }
    /// <summary>
    /// Validacion de orden
    /// </summary>
    /// 
    public Boolean verificar_orden(string codi_info_cntx, string codi_Empr, string orden)
    {
       DataSet dt= con.TraerResultados0(cntx.valida_orden(codi_info_cntx, codi_Empr, orden));
       string valor = dt.Tables[0].Rows[0][0].ToString();
       if (int.Parse(valor) > 0)
       {
           return false;
       }
       else
       {
           return true;
       }
    }
    /// <summary>
    /// Obtiene definición de fechas para definir contextos, el parámetro puede ser D para dia o A para año
    /// </summary>
    /// 
    public DataSet getCodificacionFechas(string p_TipoFech)
    {
        return con.TraerResultados0(cntx.getCodificacionFechas(p_TipoFech));
    }
    /// <summary>
    /// Obtiene el maximo de  orden de columna
    /// </summary> 
    public int getMaxOrdenColumna(string Informe,string codi_empr,string codi_emex)
    {
        DataTable dt = con.TraerResultadosT0(cntx.getMaxinformeColumna(Informe, codi_empr, codi_emex));
        return Convert.ToInt32(dt.Rows[0][0].ToString());
    }

    /// <summary>
    /// Rescata fechas de contextos
    /// </summary>
    public DataSet getFechasCntx(string Codi_inst, string FechaInicio, string FechaFinal)
    {
        return con.TraerResultados0(cntx.getFechasCntx(Codi_inst, FechaInicio, FechaFinal));
    }

    /// <summary>
    /// Rescata fechas de contextos asociados a un concepto
    /// </summary>
    public DataTable getFechasEmprInstVersConc(string CodiEmpr, string CorrInst, string VersInst, string CodiConc)
    {
        string[] tmpDatosVariables = new string[2];
        if (CodiConc.Contains('#'))
        {
            tmpDatosVariables = CodiConc.Split('#');
            return con.TraerResultados0(cntx.getFechasEmprInstVersConc(CodiEmpr, CorrInst, VersInst, tmpDatosVariables[1])).Tables[0];
        }
        else
        {
            return con.TraerResultados0(cntx.getFechasEmprInstVersConc(CodiEmpr, CorrInst, VersInst, CodiConc)).Tables[0];
        }
    }

    /// <summary>
    /// Rescata miembros de un contexto de una empresa, instancia, versión
    /// </summary>
    public DataTable getMiembrosContexto(string CodiEmpr, string CorrInst, string VersInst, string CodiCntx)
    {
        return con.TraerResultados0(cntx.getMiembrosContexto(CodiEmpr, CorrInst, VersInst, CodiCntx)).Tables[0];
    }
    /// <summary>
    /// Rescata los contextos asociados una empresa, instancia, versión y fechas 
    /// </summary>
    public DataTable getCntxEmprInstVersFech(string CodiEmpr, string CorrInst, string VersInst, string PrefConc, string CodiConc, string CntxFecha, string CntxDime)
    {
        string[] tmpDatosVariables = new string[2];
        if (CntxFecha.Contains("   "))
        {
            CntxFecha = CntxFecha.Replace("   ","/");
            tmpDatosVariables = CntxFecha.Split('/');
            return con.TraerResultados0(cntx.getCntxEmprInstVersFech(CodiEmpr, CorrInst, VersInst, PrefConc, CodiConc, tmpDatosVariables[0], tmpDatosVariables[1],CntxDime)).Tables[0];
        }
        else
        {
            return con.TraerResultados0(cntx.getCntxEmprInstVersFech(CodiEmpr, CorrInst, VersInst, PrefConc, CodiConc, tmpDatosVariables[0], "", CntxDime)).Tables[0];
        }
    }
    /// <summary>
    /// Rescata los contextos (1 eje) asociados a una empresa, instancia, versión, ejes y miembros
    /// </summary>
    public DataTable getCntxDimension1Eje(string CodiPers, string CorrInst, string VersInst, string PrefAxis1, string CodiAxis1, string PrefMemb1, string CodiMemb1, string TipoMemb1, string PrefConc, string CodiConc)
    {
        return con.TraerResultadosT0(cntx.getCntxDimension1Eje(CodiPers, CorrInst, VersInst, PrefAxis1, CodiAxis1, PrefMemb1, CodiMemb1, TipoMemb1, PrefConc, CodiConc));
    }
    /// <summary>
    /// Rescata los contextos (2 ejes) asociados a una empresa, instancia, versión, ejes y miembros
    /// </summary>
    public DataTable getCntxDimension2Ejes(string CodiPers, string CorrInst, string VersInst, string PrefAxis1, string CodiAxis1, string PrefMemb1, string CodiMemb1, string TipoMemb1, string PrefAxis2, string CodiAxis2, string PrefMemb2, string CodiMemb2, string TipoMemb2, string PrefConc, string CodiConc)
    {
        return con.TraerResultadosT0(cntx.getCntxDimension2Ejes(CodiPers, CorrInst, VersInst,  PrefAxis1,  CodiAxis1,  PrefMemb1,  CodiMemb1,  TipoMemb1,  PrefAxis2,  CodiAxis2,  PrefMemb2,  CodiMemb2,  TipoMemb2, PrefConc, CodiConc));
    }
    /// <summary>
    /// Obtiene contextos "Actuales" de una empresa/instancia/version
    /// </summary>
    public DataTable getCntxActuales(string CodiPers, string CorrInst, string VersInst)
    {
        return con.TraerResultadosT0(cntx.getCntxActuales(CodiPers, CorrInst, VersInst));
    }

    /// <summary>
    /// Obtiene todos los contextos de una empresa/instancia/version segun tipo (C Columna o D Dimension)
    /// </summary>
    public DataTable getContextosPorEmpresaInstanciaVersion(string CodiPers, string CorrInst, string VersInst, string TipoCntx)
    {
        return con.TraerResultadosT0(cntx.getContextosPorEmpresaInstanciaVersion(CodiPers, CorrInst, VersInst, TipoCntx));
    }
}
