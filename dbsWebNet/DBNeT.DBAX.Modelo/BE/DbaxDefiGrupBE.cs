using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Entidades de Negocio
namespace DBNeT.DBAX.Modelo.BE
{
    public class DbaxDefiGrupBE
    {
        public DbaxDefiGrupBE() 
        { } 
        public string CODI_GRUP { get; set; } 
        public string DESC_GRUP { get; set; } 
        
        #region PRC_DBAX_DEFI_GRUP_CREATE
        private string prc_create_dbax_defi_grup;
        
        public string PRC_CREATE_DBAX_DEFI_GRUP
        {
            get { return prc_create_dbax_defi_grup = "dbo.prc_create_dbax_defi_grup"; }
            set { prc_create_dbax_defi_grup = value; }
        }
        #endregion
        
        #region PRC_READ_DBAX_DEFI_GRUP
        private string prc_read_dbax_defi_grup;
        
        public string PRC_READ_DBAX_DEFI_GRUP
        {
            get { return prc_read_dbax_defi_grup = "dbo.prc_read_dbax_defi_grup"; }
            set { prc_read_dbax_defi_grup = value; }
        }
        #endregion
        
        #region PRC_UPDATE_DBAX_DEFI_GRUP
        private string prc_update_dbax_defi_grup;
        
        public string PRC_UPDATE_DBAX_DEFI_GRUP
        {
            get { return prc_update_dbax_defi_grup = "dbo.prc_update_dbax_defi_grup"; }
            set { prc_update_dbax_defi_grup = value; }
        }
        #endregion
        
        #region PRC_DELETE_DBAX_DEFI_GRUP
        private string prc_delete_dbax_defi_grup;
        
        public string PRC_DELETE_DBAX_DEFI_GRUP
        {
            get { return prc_delete_dbax_defi_grup = "dbo.prc_delete_dbax_defi_grup"; }
            set { prc_delete_dbax_defi_grup = value; }
        }
        #endregion
    }
}
