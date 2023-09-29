using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml;
using System.Data;

using System.Net;

public partial class insertaRegistrosEnCentral
{
    /// <summary>
    /// Concatena inserts de conceptos en bloque
    /// </summary>
    /// 
    public string prc_create_dbax_tras_arch(string tipo, string segmento, string zip, string version, string fecha)
    {

        tipo = tipo.Replace("'", "").Replace(";", "");
        segmento = segmento.Replace("'", "").Replace(";", "");
        zip = zip.Replace("'", "").Replace(";", "");
        version = version.Replace("'", "").Replace(";", "");
        fecha = fecha.Replace("'", "").Replace(";", "");
        
        return "execute dbax_central.dbo.prc_create_dbax_tras_arch '" + tipo + "','" + segmento + "','" + zip + "','" + version + "','" + fecha + "'";

        //try
        //{
        //    OpenConnection();
        //    CreateCommand("prc_create_exec_bin");
        //    AddCommandParamIN("p_tipo_arch", CmdParamType.StringVarLen, 5, tipo);
        //    AddCommandParamIN("p_codi_taxo", CmdParamType.StringVarLen, 5, segmento);
        //    AddCommandParamIN("p_path_arch", CmdParamType.StringVarLen, 256, zip);
        //    AddCommandParamIN("p_vers_arch", CmdParamType.StringVarLen, 50, version);
        //    AddCommandParamIN("p_fech_envi", CmdParamType.StringVarLen, 50, fecha);
        //    this.ExecuteNonQuery();
        //}
        //catch (Exception ex)
        //{
        //    throw ex;
        //}
    }
}