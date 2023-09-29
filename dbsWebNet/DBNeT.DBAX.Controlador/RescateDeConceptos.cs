using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Xml.Linq;
using System.Web.UI.WebControls;

    public partial class RescateDeConceptos
    {
        Conexion con = Conexion.CrearInstancia();
        ValidacionDeConceptos vc = new ValidacionDeConceptos();

        GridView gv = new GridView();

        public DataSet getConceptos(string var)
        {
            vc.setConceptoValidaLargo(var);
            return con.TraerResultados1("execute SP_AX_ejem", vc.getConcepto());
        }

        public DataSet ObtenerTipoIndicadores()
        {
            return con.TraerResultados0("execute SP_AX_RescAgru");
        }

        public DataSet getConceptosRatios(string par1, string par2)
        {
            return con.TraerResultados2("execute SP_AX_GetConcPorNombreTipo", par1, par2);
        }
    }

