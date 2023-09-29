using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Entidades de Negocio
namespace DBNeT.DBAX.Modelo.BE
{
    public class DbaxInfoConcBE
    {
        public DbaxInfoConcBE() 
        { } 
        public int CODI_EMPR { get; set; } 
        public string CODI_EMEX { get; set; } 
        public string CODI_INFO { get; set; } 
        public string PREF_CONC { get; set; } 
        public string CODI_CONC { get; set; } 
        public int ORDE_CONC { get; set; } 
        public string CODI_CONC1 { get; set; } 
        public int NIVE_CONC { get; set; } 
        public string NEGR_CONC { get; set; } 
        
        #region PRC_DBAX_INFO_CONC_CREATE
        private string prc_create_dbax_info_conc;
        
        public string PRC_CREATE_DBAX_INFO_CONC
        {
            get { return prc_create_dbax_info_conc = "dbo.prc_create_dbax_info_conc"; }
            set { prc_create_dbax_info_conc = value; }
        }
        #endregion
        
        #region PRC_READ_DBAX_INFO_CONC
        private string prc_read_dbax_info_conc;
        
        public string PRC_READ_DBAX_INFO_CONC
        {
            get { return prc_read_dbax_info_conc = "dbo.prc_read_dbax_info_conc"; }
            set { prc_read_dbax_info_conc = value; }
        }
        #endregion
        
        #region PRC_UPDATE_DBAX_INFO_CONC
        private string prc_update_dbax_info_conc;
        
        public string PRC_UPDATE_DBAX_INFO_CONC
        {
            get { return prc_update_dbax_info_conc = "dbo.prc_update_dbax_info_conc"; }
            set { prc_update_dbax_info_conc = value; }
        }
        #endregion
        
        #region PRC_DELETE_DBAX_INFO_CONC
        private string prc_delete_dbax_info_conc;
        
        public string PRC_DELETE_DBAX_INFO_CONC
        {
            get { return prc_delete_dbax_info_conc = "dbo.prc_delete_dbax_info_conc"; }
            set { prc_delete_dbax_info_conc = value; }
        }
        #endregion
    }
}
