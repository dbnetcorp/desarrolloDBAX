using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for VariablesSession
/// </summary>
public class VariablesSession
{
    public string CodiPers;
    public string CorrInst;
    public string DescEmpr;
    public string FechPeri;
    public string CodiGrup;
    public string DescGrup;
    public string CodiSegm;
    public string DescSegm;
    public string CodiInfo;
    public string TipoTaxo;
    public string TipoInfo;

	public VariablesSession()
	{
		//Constructor

	}

    public void VariablesPersonaInstancia(string tsCodiEmex, string tsCodiEmpr, string tsCodiPers, string vCorrInst, string vTipoTaxo)
    {
        LimpiaVariables();
        CodiPers = tsCodiPers;
        CorrInst = vCorrInst;
        TipoTaxo = vTipoTaxo;
    }

    public void VariablesPersonaInstanciaInforme(string vCodiEmex, string vCodiEmpr, string vCodiPers, string vCorrInst, string vCodiInfo, string vTipoTaxo)
    {
        LimpiaVariables();
        CodiPers = vCodiPers;
        CorrInst = vCorrInst;
        CodiInfo = vCodiInfo;
        TipoTaxo = vTipoTaxo;
    }

    public void VariablesInforme(string vCodiEmex, string vCodiEmpr, string vCodiInfo, string vTipoInfo)
    {
        LimpiaVariables();
        CodiInfo = vCodiInfo;
        TipoInfo = vTipoInfo;
    }

    private void LimpiaVariables()
    {
        CodiPers = "";
        CorrInst = "";
        DescEmpr = "";
        FechPeri = "";
        CodiGrup = "";
        DescGrup = "";
        CodiSegm = "";
        DescSegm = "";
        CodiInfo = "";
        TipoTaxo = "";
        TipoInfo = "";
    }
}