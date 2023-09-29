using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Entidades de Negocio
namespace DBNeT.DBAX.Modelo.BE
{
    public class DbaxDefiConcBE
    {
        public DbaxDefiConcBE() 
        { } 
        public string PREF_CONC { get; set; } 
        public string CODI_CONC { get; set; } 
        public string TIPO_CONC { get; set; } 
        public string TIPO_PERI { get; set; } 
        public string TIPO_VALO { get; set; } 
        public string TIPO_CUEN { get; set; } 
        public string CODI_NUME { get; set; } 
        public string TIPO_TAXO { get; set; } 
        
        #region PRC_DBAX_DEFI_CONC_CREATE
        private string prc_create_dbax_defi_conc;
        
        public string PRC_CREATE_DBAX_DEFI_CONC
        {
            get { return prc_create_dbax_defi_conc = "dbo.prc_create_dbax_defi_conc"; }
            set { prc_create_dbax_defi_conc = value; }
        }
        #endregion
        
        #region PRC_READ_DBAX_DEFI_CONC
        private string prc_read_dbax_defi_conc;
        
        public string PRC_READ_DBAX_DEFI_CONC
        {
            get { return prc_read_dbax_defi_conc = "dbo.prc_read_dbax_defi_conc"; }
            set { prc_read_dbax_defi_conc = value; }
        }
        #endregion
        
        #region PRC_UPDATE_DBAX_DEFI_CONC
        private string prc_update_dbax_defi_conc;
        
        public string PRC_UPDATE_DBAX_DEFI_CONC
        {
            get { return prc_update_dbax_defi_conc = "dbo.prc_update_dbax_defi_conc"; }
            set { prc_update_dbax_defi_conc = value; }
        }
        #endregion
        
        #region PRC_DELETE_DBAX_DEFI_CONC
        private string prc_delete_dbax_defi_conc;
        
        public string PRC_DELETE_DBAX_DEFI_CONC
        {
            get { return prc_delete_dbax_defi_conc = "dbo.prc_delete_dbax_defi_conc"; }
            set { prc_delete_dbax_defi_conc = value; }
        }
        #endregion
    }
}
