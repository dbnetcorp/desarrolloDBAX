using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Entidades de Negocio
namespace DBNeT.DBAX.Modelo.BE
{
    public class DbaxTaxoVersBE
    {
        public DbaxTaxoVersBE() 
        { } 
        public string VERS_TAXO { get; set; } 
        public string UBIC_TAXO { get; set; } 
        public string TIPO_TAXO { get; set; } 
        
        #region PRC_DBAX_TAXO_VERS_CREATE
        private string prc_create_dbax_taxo_vers;
        
        public string PRC_CREATE_DBAX_TAXO_VERS
        {
            get { return prc_create_dbax_taxo_vers = "dbo.prc_create_dbax_taxo_vers"; }
            set { prc_create_dbax_taxo_vers = value; }
        }
        #endregion
        
        #region PRC_READ_DBAX_TAXO_VERS
        private string prc_read_dbax_taxo_vers;
        
        public string PRC_READ_DBAX_TAXO_VERS
        {
            get { return prc_read_dbax_taxo_vers = "dbo.prc_read_dbax_taxo_vers"; }
            set { prc_read_dbax_taxo_vers = value; }
        }
        #endregion
        
        #region PRC_UPDATE_DBAX_TAXO_VERS
        private string prc_update_dbax_taxo_vers;
        
        public string PRC_UPDATE_DBAX_TAXO_VERS
        {
            get { return prc_update_dbax_taxo_vers = "dbo.prc_update_dbax_taxo_vers"; }
            set { prc_update_dbax_taxo_vers = value; }
        }
        #endregion
        
        #region PRC_DELETE_DBAX_TAXO_VERS
        private string prc_delete_dbax_taxo_vers;
        
        public string PRC_DELETE_DBAX_TAXO_VERS
        {
            get { return prc_delete_dbax_taxo_vers = "dbo.prc_delete_dbax_taxo_vers"; }
            set { prc_delete_dbax_taxo_vers = value; }
        }
        #endregion
    }
}
