using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Entidades de Negocio
namespace DBNeT.DBAX.Modelo.BE
{
    public class DbaxHomoDetaBE
    {
        public DbaxHomoDetaBE() 
        { } 
        public int CODI_HOCO { get; set; } 
        public string PREF_CONC { get; set; } 
        public string CODI_CONC { get; set; } 
        public string PREF_CONC1 { get; set; } 
        public string CODI_CONC1 { get; set; } 
        
        #region PRC_DBAX_HOMO_DETA_CREATE
        private string prc_create_dbax_homo_deta;
        
        public string PRC_CREATE_DBAX_HOMO_DETA
        {
            get { return prc_create_dbax_homo_deta = "dbo.prc_create_dbax_homo_deta"; }
            set { prc_create_dbax_homo_deta = value; }
        }
        #endregion
        
        #region PRC_READ_DBAX_HOMO_DETA
        private string prc_read_dbax_homo_deta;
        
        public string PRC_READ_DBAX_HOMO_DETA
        {
            get { return prc_read_dbax_homo_deta = "dbo.prc_read_dbax_homo_deta"; }
            set { prc_read_dbax_homo_deta = value; }
        }
        #endregion
        
        #region PRC_UPDATE_DBAX_HOMO_DETA
        private string prc_update_dbax_homo_deta;
        
        public string PRC_UPDATE_DBAX_HOMO_DETA
        {
            get { return prc_update_dbax_homo_deta = "dbo.prc_update_dbax_homo_deta"; }
            set { prc_update_dbax_homo_deta = value; }
        }
        #endregion
        
        #region PRC_DELETE_DBAX_HOMO_DETA
        private string prc_delete_dbax_homo_deta;
        
        public string PRC_DELETE_DBAX_HOMO_DETA
        {
            get { return prc_delete_dbax_homo_deta = "dbo.prc_delete_dbax_homo_deta"; }
            set { prc_delete_dbax_homo_deta = value; }
        }
        #endregion
    }
}
