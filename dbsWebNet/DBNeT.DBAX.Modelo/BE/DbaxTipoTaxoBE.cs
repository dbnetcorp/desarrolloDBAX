using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Entidades de Negocio
namespace DBNeT.DBAX.Modelo.BE
{
    public class DbaxTipoTaxoBE
    {
        public DbaxTipoTaxoBE() 
        { } 
        public string TIPO_TAXO { get; set; } 
        public string DESC_TIPO { get; set; } 
        
        #region PRC_DBAX_TIPO_TAXO_CREATE
        private string prc_create_dbax_tipo_taxo;
        
        public string PRC_CREATE_DBAX_TIPO_TAXO
        {
            get { return prc_create_dbax_tipo_taxo = "dbo.prc_create_dbax_tipo_taxo"; }
            set { prc_create_dbax_tipo_taxo = value; }
        }
        #endregion
        
        #region PRC_READ_DBAX_TIPO_TAXO
        private string prc_read_dbax_tipo_taxo;
        
        public string PRC_READ_DBAX_TIPO_TAXO
        {
            get { return prc_read_dbax_tipo_taxo = "dbo.prc_read_dbax_tipo_taxo"; }
            set { prc_read_dbax_tipo_taxo = value; }
        }
        #endregion
        
        #region PRC_UPDATE_DBAX_TIPO_TAXO
        private string prc_update_dbax_tipo_taxo;
        
        public string PRC_UPDATE_DBAX_TIPO_TAXO
        {
            get { return prc_update_dbax_tipo_taxo = "dbo.prc_update_dbax_tipo_taxo"; }
            set { prc_update_dbax_tipo_taxo = value; }
        }
        #endregion
        
        #region PRC_DELETE_DBAX_TIPO_TAXO
        private string prc_delete_dbax_tipo_taxo;
        
        public string PRC_DELETE_DBAX_TIPO_TAXO
        {
            get { return prc_delete_dbax_tipo_taxo = "dbo.prc_delete_dbax_tipo_taxo"; }
            set { prc_delete_dbax_tipo_taxo = value; }
        }
        #endregion
    }
}
