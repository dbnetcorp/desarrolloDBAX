using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Entidades de Negocio
namespace DBNeT.DBAX.Modelo.BE
{
    public class DbaxDefiPehoBE
    {
        public DbaxDefiPehoBE() 
        { } 
        public string CODI_EMEX { get; set; } 
        public int CODI_EMPR { get; set; } 
        public int CODI_PERS { get; set; } 
        public string DESC_EMPR { get; set; } 
        
        #region PRC_DBAX_DEFI_PEHO_CREATE
        private string prc_create_dbax_defi_peho;
        
        public string PRC_CREATE_DBAX_DEFI_PEHO
        {
            get { return prc_create_dbax_defi_peho = "dbo.prc_create_dbax_defi_peho"; }
            set { prc_create_dbax_defi_peho = value; }
        }
        #endregion
        
        #region PRC_READ_DBAX_DEFI_PEHO
        private string prc_read_dbax_defi_peho;
        
        public string PRC_READ_DBAX_DEFI_PEHO
        {
            get { return prc_read_dbax_defi_peho = "dbo.prc_read_dbax_defi_peho"; }
            set { prc_read_dbax_defi_peho = value; }
        }
        #endregion
        
        #region PRC_UPDATE_DBAX_DEFI_PEHO
        private string prc_update_dbax_defi_peho;
        
        public string PRC_UPDATE_DBAX_DEFI_PEHO
        {
            get { return prc_update_dbax_defi_peho = "dbo.prc_update_dbax_defi_peho"; }
            set { prc_update_dbax_defi_peho = value; }
        }
        #endregion
        
        #region PRC_DELETE_DBAX_DEFI_PEHO
        private string prc_delete_dbax_defi_peho;
        
        public string PRC_DELETE_DBAX_DEFI_PEHO
        {
            get { return prc_delete_dbax_defi_peho = "dbo.prc_delete_dbax_defi_peho"; }
            set { prc_delete_dbax_defi_peho = value; }
        }
        #endregion
    }
}
