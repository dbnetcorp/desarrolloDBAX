using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Xml.Linq;
using DBNeT.DBAX.Modelo.DAC;
//using System.Web.UI.WebControls;

public partial class ModeloMantencionIndicadores
{
    /// <summary>
    /// Cadena que contiene la asociacion entre variable y concepto
    /// </summary>
    private string cadenaVariables;
    /// <summary>
    /// Numero de variables
    /// </summary>
    private int vNumeroVariables = 0;
    //public string[] variables = new string[50];    
    /// <summary>
    /// Conexion
    /// </summary>
    private string Codi_emex;
    private string Codi_empr;
    private string Codi_indi;
    private string Tipo_indi;
    private string Desc_indi;
    private string Form_indi;
    private string Tipo_taxo;
    private string Refe_Mini;
    private string Refe_Maxi;
    private string Visu_Indi;
    private string Apli_Hold;
    private string[,] vDatosVariables;
    /// <summary>
    /// Arreglo con variables definidas en formula
    /// </summary>
    private string[] VariablesFormula;
    /// <summary>
    /// Número de variables definidas en formula
    /// </summary>
    private int numeroVariablesFormula=0;
    /// <summary>
    /// Setea el miembro cadenaVariables a partir de una cadena ingresada como parámetro
    /// </summary>
    public void setCadenaFormula(string cadena)
    {
        if (cadena.Length > 0)
        {
            Form_indi = cadena.ToUpper();
        }else
            throw new System.Exception("La fórmula no puede estar vacía.");
    }
    /// <summary>
    /// Setea el número de variables definidas en formula
    /// </summary>
    public void setNumeroVariablesFormula()
    {
        for (int i = 0; i < Form_indi.Length; i++)
        {
            if (System.Text.RegularExpressions.Regex.IsMatch(Form_indi[i].ToString(), "^[a-zA-Z]+$"))
            {
                numeroVariablesFormula++;
            }
        }
        setVariablesFormula();
    }
    /// <summary>
    /// Setea las variables definidas en formula
    /// </summary>
    public void setVariablesFormula()
    {
        VariablesFormula = new string[numeroVariablesFormula];
        int j = 0;
        for (int i = 0; i < Form_indi.Length; i++)
        {
            if (System.Text.RegularExpressions.Regex.IsMatch(Form_indi[i].ToString(), "^[a-zA-Z]+$"))
            {
                VariablesFormula[j] = Form_indi[i].ToString();
                j++;
            }
        }
    }
    /// <summary>
    /// Devuelve un arreglo que contiene las variables definidas en la formula ingresada
    /// </summary>
    public string[] getVariablesFormula()
    {
        return VariablesFormula;
    }
    /// <summary>
    /// Setea el miembro cadenaVariables a partir de una cadena ingresada como parámetro
    /// </summary>
    public string getCadenaFormula()
    {
        if (Form_indi.Length > 0)
            return Form_indi;
        else
            throw new System.Exception("La formula no ha sido definida todavía.");
    }
    /// <summary>
    /// Valida una cadena de texto y la asigna al atributo cadenaVariables
    /// </summary>
    public void setCadenaVariables(string cadena)
    {
        if (cadena.Length == 0)
            throw new System.Exception("No todos los campos obligatorios han sido completados correctamente.");
        else
        {
            if (!cadena.Contains('/'))
                throw new System.Exception("La cadena de entrada no tiene el formato correcto (falta '/')");
            if (!cadena.Contains('|'))
                throw new System.Exception("La cadena de entrada no tiene el formato correcto (falta '|')");

            cadenaVariables = cadena;
            setNumeroVariablesLlenas();
            setDetalleIndicador();
        }
    }
    /// <summary>
    /// Valida los contextos guardados de acuerdo al tipo de la variable [instant|duration] y si corresponde lo setea correctamente
    /// </summary>
    public void validaContextosDetalle()
    {
        DbaxDefiConcDAC conc = new DbaxDefiConcDAC();
        for (int i = 0; i < vNumeroVariables; i++)
        {
            if (vDatosVariables[i, 5] == "CierreTrimestreActual" && conc.readDbaxDefiConcDt("S",0,0,vDatosVariables[i, 2].ToString(),"",vDatosVariables[i, 1].ToString(),"","","","",0,"").Rows[0]["tipo_peri"].ToString() == "duration")
            {
                //Si entro acá es
                vDatosVariables[i, 5] = "TrimestreAcumuladoActual";
            }
        }
    }
    /// <summary>
    /// Setea las variables para el encabezado del indicador.
    /// </summary>
    public void setEncabezadoIndicador(string vHolding, string vEmpresa, string vNombre, string vAgrupacion, string vDescripcion, string vFormula, string vTipoTaxo, string vRefeMini, string vRefeMaxi, bool vVisuIndi, bool vApliHold)
    {
        if (vHolding.Length > 0 && vEmpresa.Length > 0 && vNombre.Length > 0 && vAgrupacion.Length > 0)
        {
            setCadenaFormula(vFormula);
            Codi_emex = vHolding;
            Codi_empr = vEmpresa;
            Codi_indi = vNombre;
            Tipo_indi = vAgrupacion;
            Desc_indi = vDescripcion;
            Tipo_taxo = vTipoTaxo;
            if (vRefeMini.Length == 0)
                Refe_Mini = "NULL";
            else
                Refe_Mini = vRefeMini;

            if (vRefeMaxi.Length==0)
                Refe_Maxi = "NULL";
            else
                Refe_Maxi = vRefeMaxi;

            if (vVisuIndi)
                Visu_Indi = "S";
            else
                Visu_Indi = "N";

            if (vApliHold)
                Apli_Hold = "S";
            else
                Apli_Hold = "N";
        }
        else
        {
            throw new System.Exception("No todos los campos obligatorios han sido completados correctamente.");
        }
    }
    /// <summary>
    /// Calcula el número de variables con conceptos asociados
    /// </summary>
    public void setNumeroVariablesLlenas()
    {
        vNumeroVariables = cadenaVariables.Substring(0, cadenaVariables.Length - 1).Split('/').Count();
    }
    public int getNumeroVariablesLlenas()
    {
        return vNumeroVariables;
    }
    /// <summary>
    /// Setea las variables y el concepto asociado
    /// </summary>
    public void setDetalleIndicador()
    {
        string[] tmpDatosVariables = new string[vNumeroVariables];
        vDatosVariables = new string[vNumeroVariables, 6];
        //string []vDatosVariables = new string[vNumeroVariables,2];
        tmpDatosVariables = cadenaVariables.Substring(0, cadenaVariables.Length - 1).Split('/');

        for (int i = 0; i < vNumeroVariables; i++)
        {
            string vCadenaAReemplazar = "";
            if (!tmpDatosVariables[i].Contains("|indi|") && tmpDatosVariables[i].Contains("__"))
            {
                vCadenaAReemplazar = tmpDatosVariables[i].Substring(tmpDatosVariables[i].IndexOf("|") + 1, tmpDatosVariables[i].IndexOf("__") - tmpDatosVariables[i].IndexOf("|") + 1);
                tmpDatosVariables[i] = tmpDatosVariables[i].Replace(vCadenaAReemplazar, "");
            }
            
            string [] vDatosVariable = new string[6];
            vDatosVariable = tmpDatosVariables[i].Split('|');
            vDatosVariable[0] = vDatosVariable[0].Substring(vDatosVariable[0].Length - 1);

            for (int j = 0; j < 6; j++)
            {
                vDatosVariables[i, j] = vDatosVariable[j];
            }
        }
    }
    /// <summary>
    /// Devuelve un arreglo que contiene la variable y el concepto asociado
    /// </summary>
    public string[,] getDetalleIndicador()
    {
        return vDatosVariables;
    }
    /// <summary>
    /// Devuelve el número de variables definidas en la fórmula
    /// </summary>
    public int getNumeroVariablesFormula()
    {
        return numeroVariablesFormula;
    }
    /// <summary>
    /// Inserta en DB el detalle de una variable de la formula definida en Form_indi
    /// </summary>
    public string[] insDetalleIndicador()
    {
        string[] detalles = new string[vNumeroVariables];
        for (int i = 0; i < vNumeroVariables; i++)
        {
            detalles[i] = "execute SP_AX_InsDetaIndi " + Codi_emex + ",'" + Codi_empr + "','" + Codi_indi + "','" + getDetalleIndicador()[i, 0] + "','" + getDetalleIndicador()[i, 1] + "','" + getDetalleIndicador()[i, 2] + "','" + getDetalleIndicador()[i, 3] + "','" + getDetalleIndicador()[i, 4] + "','" + getDetalleIndicador()[i, 5] + "'";
        }
        return detalles;
    }
    /// <summary>
    /// Inserta en DB el encabezado del indicador
    /// </summary>
    public string insEncabezadoIndicador(string vModo)
    {
        return ("execute SP_AX_InsEncaIndi '" + vModo + "','" + Codi_emex + "','" + Codi_empr + "','" + Codi_indi + "','" + Tipo_indi + "','" + Desc_indi + "','" + Form_indi + "','" + Tipo_taxo + "'," + Refe_Mini + "," + Refe_Maxi + ",'" + Visu_Indi + "','" + Apli_Hold + "'");
    }
    public string delIndicador(string vHolding, string vEmpresa, string vNombre)
    {
        return ("execute SP_AX_delIndi '" + vHolding + "','" + vEmpresa + "','" + vNombre + "'");
    }
    public string getEncabezadoIndicador(string vCodi_emex, string vCodi_empr, string vCodi_indi)
    {
        return ("execute SP_AX_GetEncaIndi " + vCodi_emex + ",'" + vCodi_empr + "','" + vCodi_indi + "'");
    }
    /// <summary>
    /// Rescata valores conceptos de a uno por indicador
    /// </summary>
    public string getDetalleIndicador(string vCodi_emex, string vCodi_empr, string vCodi_indi, string vLetr_indi)
    {
        return ("execute SP_AX_GetDetaIndi '" + vCodi_emex + "','" + vCodi_empr + "','" + vCodi_indi + "','" + vLetr_indi + "'");
    }
    /// <summary>
    /// Rescata valores conceptos por indicador (sobrecargado)
    /// </summary>
    public string getDetalleIndicador(string vCodi_emex, string vCodi_empr, int vCorrInst, string vCodi_indi)
    {
        return ("execute SP_AX_GetDetaIndicadores '" + vCodi_emex + "','" + vCodi_empr + "'," + vCorrInst + ",'" + vCodi_indi + "'");
    }
    /// <summary>
    /// Rescata Contextos por fechas
    /// </summary>
    public string GetValoCntx(string Codi_pers, string Codi_inst, string Codi_vers, string pref_conc, string codi_conc, string Fecha_Inicio, string Fecha_Termino)
    {
        return ("execute SP_AX_GetValoCntx '" + Codi_pers + "','" + Codi_inst + "','" + Codi_vers + "','" + pref_conc + "','" + codi_conc + "','" + Fecha_Inicio + "','" + Fecha_Termino + "'");
    }
    /// <summary>
    /// insertar Valores indicadores
    /// </summary>
    public string InsValoresIndicadores(string codi_pers, string corr_inst, string vers_inst, string codi_conc, string codi_cntx, string valo_cntx, string Codi_unit)
    {
        return ("execute SP_AX_InsValoresIndicadores '" + codi_pers + "','" + corr_inst + "','" + vers_inst + "','" + codi_conc + "','" + codi_cntx + "','" + valo_cntx + "','" + Codi_unit + "'");
    }
    /// <summary>
    /// Obtiene prefijos de conceptos definidos
    /// </summary>
    public string getPrefConc()
    {
        return ("execute SP_AX_getPrefConc ");
    }
    /// <summary>
    /// Obtiene prefijos de conceptos definidos por TipoTaxo
    /// </summary>
    public string getPrefConc(string VersTaxo)
    {
        return ("execute SP_AX_getPrefConc '" + VersTaxo + "'");
    }
    /// <summary>
    /// Obtiene prefijos de conceptos definidos
    /// </summary>
    public string InsDatosCalIndicadores(string codi_emex, string codi_empr, string corr_inst, string codi_grup, string codi_segm, string codi_indi, string tipo_taxo)
    {
        return ("execute SP_AX_InsDatosCalIndicadores '" + codi_emex + "','" + codi_empr + "','" + corr_inst  + "','" + codi_grup + "','" + codi_segm + "','" + codi_indi + "', '"+tipo_taxo+"'");
    }
    /// <summary>
    /// Obtiene Empresas de indicadores
    /// </summary>
    public string GetEmpresasIndicadores()
    {
        return ("execute SP_AX_GetEmpresasIndicadores");
    }
    /// <summary>
    /// Obtiene contextos "normales" que se pueden usar para calcular un indicador para una empresa
    /// </summary>
    public string GetContextosIndicadorEmpresa(string CodiEmpr, string CorrInst, string VersInst, string CodiIndi)
    {
        return ("execute SP_AX_GetContextosIndicadorEmpresa '" + CodiEmpr + "','"+ CorrInst + "','" + VersInst + "','" + CodiIndi+"'");
    }
    /// <summary>
    /// ejecuta binario
    /// </summary>
    public string ejecuta_servicio(string prog_proc,string args_proc)
    {
        return ("execute SP_AX_inssServicio '" + prog_proc + "','" + args_proc + "'");
    }
    /// <summary>
    /// Borrar Tabla temporal indicadores
    /// </summary>
    public string BorraTempIndi()
    {
        return ("execute SP_AX_DelTempIndi");
    }

    public string InsAnomaliasIndicadores(string codi_pers, string corr_inst, string vers_inst, string codi_conc, string codi_cntx, string valo_cntx,string refe_mini, string refe_maxi)
    {
        return ("execute SP_AX_InsAnomaliasIndicadores '" + codi_pers + "','" + corr_inst + "','" + vers_inst + "','" + codi_conc + "','" + codi_cntx + "','" + valo_cntx + "','" + refe_mini + "','" + refe_maxi + "'");
    }

    public string GetPermusuaEmpr(string pCodiEmex, string vCodiPers, string pCodiUsua)
    {
        return ("execute SP_AX_GetPermUsuaEmpr " + pCodiEmex + ",'" + vCodiPers + "','" + pCodiUsua + "'");
    }
}