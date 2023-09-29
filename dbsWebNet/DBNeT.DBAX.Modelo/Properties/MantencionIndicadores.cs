using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Xml.Linq;
using System.Web.UI.WebControls;

public partial class MantencionIndicadores
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
    Conexion con = Conexion.CrearInstancia();
    private string Codi_emex;
    private string Codi_empr;
    private string Codi_indi;
    private string Tipo_indi;
    private string Desc_indi;
    private string Form_indi;
    private string[,] vDatosVariables;
    //private string[] vDatosVariable;
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
    /// Setea las variables para el encabezado del indicador.
    /// </summary>
    public void setEncabezadoIndicador(string vHolding, string vEmpresa, string vNombre, string vAgrupacion, string vDescripcion)
    {
        if (vHolding.Length > 0 && vEmpresa.Length > 0 && vNombre.Length > 0 && vAgrupacion.Length > 0)
        {
            Codi_emex = vHolding;
            Codi_empr = vEmpresa;
            Codi_indi = vNombre;
            Tipo_indi = vAgrupacion;
            Desc_indi = vDescripcion;
        }
        else
        {
            throw new System.Exception("No todos los campos obligatorios han sido completados correctamente.");
        }
    }

    /// <summary>
    /// Inserta en DB el detalle de la validación.
    /// </summary>
    

    /// <summary>
    /// Calcula el número de variables con conceptos asociados
    /// </summary>
    public void setNumeroVariablesLlenas()
    {
        vNumeroVariables = cadenaVariables.Substring(0, cadenaVariables.Length - 1).Split('/').Count();
    }
    /// <summary>
    /// Setea las variables y el concepto asociado
    /// </summary>
    public void setDetalleIndicador()
    {
        string[] tmpDatosVariables = new string[vNumeroVariables];
        vDatosVariables = new string[vNumeroVariables, 3];
        //string []vDatosVariables = new string[vNumeroVariables,2];
        tmpDatosVariables = cadenaVariables.Substring(0, cadenaVariables.Length - 1).Split('/');

        for (int i = 0; i < vNumeroVariables; i++)
        {
            string [] vDatosVariable = new string[3];
            vDatosVariable = tmpDatosVariables[i].Split('|');
            vDatosVariable[0] = vDatosVariable[0].Substring(vDatosVariable[0].Length - 1);
            for (int j = 0; j < 3; j++)
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
    public void insDetalleIndicador()
    {
        for (int i = 0; i < vNumeroVariables; i++)
        {
            con.EjecutarQuery("execute SP_AX_InsDetaIndi " + Codi_emex + ",'" + Codi_empr + "','" + Codi_indi + "','" + getDetalleIndicador()[i, 0] + "','" + getDetalleIndicador()[i, 1] + "','" + getDetalleIndicador()[i, 2] + "'");
        }
    }
    /// <summary>
    /// Inserta en DB el encabezado del indicador
    /// </summary>
    public void insEncabezadoIndicador()
    {
        con.EjecutarQuery("execute SP_AX_InsEncaIndi " + Codi_emex + ",'" + Codi_empr + "','" + Codi_indi + "','" + Tipo_indi + "','" + Desc_indi + "','" + Form_indi + "'");
    }

    /*public DataSet TraerResultados1(string query, string par1)
    {
        declararConexion();
        SqlDataAdapter ada = new SqlDataAdapter(query + " '" + par1 + "'", con);
        DataSet ds = new DataSet();
        ada.Fill(ds);
        con.Close();

        return ds;
    }*/
}

