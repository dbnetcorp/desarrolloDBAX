using System;
using System.Data;
using System.Configuration;
using System.Linq;

public partial class ValidacionDeConceptos
{
    string concepto = "";

    public string getConcepto() {
        return concepto;
    }

    public void setConceptoValidaLargo(string conceptoIngresado) {
        if (conceptoIngresado.Length > 0)
            this.concepto = conceptoIngresado;
        else
            throw new System.Exception("Campo no puede estar vacío.");
    }
    public void setConcepto(string conceptoIngresado)
    {
        this.concepto = conceptoIngresado;
    }
}

