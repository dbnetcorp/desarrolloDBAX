using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Entidades de Negocio
namespace DBNeT.DBAX.Modelo.BE
{
    public class DbaxDescConcBE
    {
        public DbaxDescConcBE() 
        { } 
        public string PREF_CONC { get; set; } 
        public string CODI_CONC { get; set; } 
        public string CODI_LANG { get; set; } 
        public string DESC_CONC { get; set; } 
        
        #region PRC_DBAX_DESC_CONC_CREATE
        private string prc_create_dbax_desc_conc;
        
        public string PRC_CREATE_DBAX_DESC_CONC
        {
            get { return prc_create_dbax_desc_conc = "dbo.prc_create_dbax_desc_conc"; }
            set { prc_create_dbax_desc_conc = value; }
        }
        #endregion
        
        #region PRC_READ_DBAX_DESC_CONC
        private string prc_read_dbax_desc_conc;
        
        public string PRC_READ_DBAX_DESC_CONC
        {
            get { return prc_read_dbax_desc_conc = "dbo.prc_read_dbax_desc_conc"; }
            set { prc_read_dbax_desc_conc = value; }
        }
        #endregion
        
        #region PRC_UPDATE_DBAX_DESC_CONC
        private string prc_update_dbax_desc_conc;
        
        public string PRC_UPDATE_DBAX_DESC_CONC
        {
            get { return prc_update_dbax_desc_conc = "dbo.prc_update_dbax_desc_conc"; }
            set { prc_update_dbax_desc_conc = value; }
        }
        #endregion
        
        #region PRC_DELETE_DBAX_DESC_CONC
        private string prc_delete_dbax_desc_conc;
        
        public string PRC_DELETE_DBAX_DESC_CONC
        {
            get { return prc_delete_dbax_desc_conc = "dbo.prc_delete_dbax_desc_conc"; }
            set { prc_delete_dbax_desc_conc = value; }
        }
        #endregion
    }
}
