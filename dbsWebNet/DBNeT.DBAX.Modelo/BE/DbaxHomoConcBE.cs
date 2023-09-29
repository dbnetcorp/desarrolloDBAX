using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Entidades de Negocio
namespace DBNeT.DBAX.Modelo.BE
{
    public class DbaxHomoConcBE
    {
        public DbaxHomoConcBE() 
        { } 
        public int CODI_HOCO { get; set; } 
        public string TIPO_TAXO { get; set; } 
        public string PREF_CONC { get; set; } 
        public string VERS_TAXO { get; set; } 
        public string VERS_TAXO_DEST { get; set; } 
        public DateTime FECH_HOCO { get; set; } 
        
        #region PRC_DBAX_HOMO_CONC_CREATE
        private string prc_create_dbax_homo_conc;
        
        public string PRC_CREATE_DBAX_HOMO_CONC
        {
            get { return prc_create_dbax_homo_conc = "dbo.prc_create_dbax_homo_conc"; }
            set { prc_create_dbax_homo_conc = value; }
        }
        #endregion
        
        #region PRC_READ_DBAX_HOMO_CONC
        private string prc_read_dbax_homo_conc;
        
        public string PRC_READ_DBAX_HOMO_CONC
        {
            get { return prc_read_dbax_homo_conc = "dbo.prc_read_dbax_homo_conc"; }
            set { prc_read_dbax_homo_conc = value; }
        }
        #endregion
        
        #region PRC_UPDATE_DBAX_HOMO_CONC
        private string prc_update_dbax_homo_conc;
        
        public string PRC_UPDATE_DBAX_HOMO_CONC
        {
            get { return prc_update_dbax_homo_conc = "dbo.prc_update_dbax_homo_conc"; }
            set { prc_update_dbax_homo_conc = value; }
        }
        #endregion
        
        #region PRC_DELETE_DBAX_HOMO_CONC
        private string prc_delete_dbax_homo_conc;
        
        public string PRC_DELETE_DBAX_HOMO_CONC
        {
            get { return prc_delete_dbax_homo_conc = "dbo.prc_delete_dbax_homo_conc"; }
            set { prc_delete_dbax_homo_conc = value; }
        }
        #endregion
    }
}
