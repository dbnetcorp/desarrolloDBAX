using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Entidades de Negocio
namespace DBNeT.DBAX.Modelo.BE
{
    public class DbaxDefiRamoBE
    {
        public DbaxDefiRamoBE() 
        { } 
        public string CODI_SEGM { get; set; } 
        public string CODI_RAMO { get; set; } 
        public string DESC_RAMO { get; set; } 
        public string CODI_RAMO_SUPE { get; set; }
        public string TIPO_RAMO { get; set; }
        public string CODI_CONC { get; set; }
        public string NUME_RAMO { get; set; }
        
        #region PRC_DBAX_DEFI_RAMO_CREATE
        private string prc_create_dbax_defi_ramo;
        
        public string PRC_CREATE_DBAX_DEFI_RAMO
        {
            get { return prc_create_dbax_defi_ramo = "dbo.prc_create_dbax_defi_ramo"; }
            set { prc_create_dbax_defi_ramo = value; }
        }
        #endregion
        
        #region PRC_READ_DBAX_DEFI_RAMO
        private string prc_read_dbax_defi_ramo;
        
        public string PRC_READ_DBAX_DEFI_RAMO
        {
            get { return prc_read_dbax_defi_ramo = "dbo.prc_read_dbax_defi_ramo"; }
            set { prc_read_dbax_defi_ramo = value; }
        }
        #endregion
        
        #region PRC_UPDATE_DBAX_DEFI_RAMO
        private string prc_update_dbax_defi_ramo;
        
        public string PRC_UPDATE_DBAX_DEFI_RAMO
        {
            get { return prc_update_dbax_defi_ramo = "dbo.prc_update_dbax_defi_ramo"; }
            set { prc_update_dbax_defi_ramo = value; }
        }
        #endregion
        
        #region PRC_DELETE_DBAX_DEFI_RAMO
        private string prc_delete_dbax_defi_ramo;
        
        public string PRC_DELETE_DBAX_DEFI_RAMO
        {
            get { return prc_delete_dbax_defi_ramo = "dbo.prc_delete_dbax_defi_ramo"; }
            set { prc_delete_dbax_defi_ramo = value; }
        }
        #endregion
    }
}
