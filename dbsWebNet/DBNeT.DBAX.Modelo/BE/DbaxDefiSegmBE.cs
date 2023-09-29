using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Entidades de Negocio
namespace DBNeT.DBAX.Modelo.BE
{
    public class DbaxDefiSegmBE
    {
        public DbaxDefiSegmBE() 
        { } 
        public string CODI_SEGM { get; set; } 
        public string DESC_SEGM { get; set; } 
        
        #region PRC_DBAX_DEFI_SEGM_CREATE
        private string prc_create_dbax_defi_segm;
        
        public string PRC_CREATE_DBAX_DEFI_SEGM
        {
            get { return prc_create_dbax_defi_segm = "dbo.prc_create_dbax_defi_segm"; }
            set { prc_create_dbax_defi_segm = value; }
        }
        #endregion
        
        #region PRC_READ_DBAX_DEFI_SEGM
        private string prc_read_dbax_defi_segm;
        
        public string PRC_READ_DBAX_DEFI_SEGM
        {
            get { return prc_read_dbax_defi_segm = "dbo.prc_read_dbax_defi_segm"; }
            set { prc_read_dbax_defi_segm = value; }
        }
        #endregion
        
        #region PRC_UPDATE_DBAX_DEFI_SEGM
        private string prc_update_dbax_defi_segm;
        
        public string PRC_UPDATE_DBAX_DEFI_SEGM
        {
            get { return prc_update_dbax_defi_segm = "dbo.prc_update_dbax_defi_segm"; }
            set { prc_update_dbax_defi_segm = value; }
        }
        #endregion
        
        #region PRC_DELETE_DBAX_DEFI_SEGM
        private string prc_delete_dbax_defi_segm;
        
        public string PRC_DELETE_DBAX_DEFI_SEGM
        {
            get { return prc_delete_dbax_defi_segm = "dbo.prc_delete_dbax_defi_segm"; }
            set { prc_delete_dbax_defi_segm = value; }
        }
        #endregion
    }
}
