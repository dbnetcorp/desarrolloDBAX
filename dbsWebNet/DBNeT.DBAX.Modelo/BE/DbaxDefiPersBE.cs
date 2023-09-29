using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Entidades de Negocio
namespace DBNeT.DBAX.Modelo.BE
{
    public class DbaxDefiPersBE
    {
        public DbaxDefiPersBE() 
        { } 
        public string CODI_PERS { get; set; } 
        public string DESC_PERS { get; set; } 
        public string CODI_GRUP { get; set; } 
        public string CODI_SEGM { get; set; } 
        public string TIPO_TAXO { get; set; } 
        public string PRES_BURS { get; set; } 
        public string EMIS_BONO { get; set; } 
        public string EMPR_VIGE { get; set; }
        
        #region PRC_DBAX_DEFI_PERS_CREATE
        private string prc_create_dbax_defi_pers;
        
        public string PRC_CREATE_DBAX_DEFI_PERS
        {
            get { return prc_create_dbax_defi_pers = "prc_create_dbax_defi_pers"; }
            set { prc_create_dbax_defi_pers = value; }
        }
        #endregion
        
        #region PRC_READ_DBAX_DEFI_PERS
        private string prc_read_dbax_defi_pers;
        
        public string PRC_READ_DBAX_DEFI_PERS
        {
            get { return prc_read_dbax_defi_pers = "prc_read_dbax_defi_pers"; }
            set { prc_read_dbax_defi_pers = value; }
        }
        #endregion
        
        #region PRC_UPDATE_DBAX_DEFI_PERS
        private string prc_update_dbax_defi_pers;
        
        public string PRC_UPDATE_DBAX_DEFI_PERS
        {
            get { return prc_update_dbax_defi_pers = "prc_update_dbax_defi_pers"; }
            set { prc_update_dbax_defi_pers = value; }
        }
        #endregion
        
        #region PRC_DELETE_DBAX_DEFI_PERS
        private string prc_delete_dbax_defi_pers;
        
        public string PRC_DELETE_DBAX_DEFI_PERS
        {
            get { return prc_delete_dbax_defi_pers = "prc_delete_dbax_defi_pers"; }
            set { prc_delete_dbax_defi_pers = value; }
        }
        #endregion
    }
}