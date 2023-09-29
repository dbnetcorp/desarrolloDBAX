using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Entidades de Negocio
namespace DBNeT.DBAX.Modelo.BE
{
    public class DbneDefiLangBE
    {
        public DbneDefiLangBE() 
        { } 
        public string CODI_LANG { get; set; } 
        public string DESC_LANG { get; set; } 
        
        #region PRC_DBNE_DEFI_LANG_CREATE
        private string prc_create_dbne_defi_lang;
        
        public string PRC_CREATE_DBNE_DEFI_LANG
        {
            get { return prc_create_dbne_defi_lang = "dbo.prc_create_dbne_defi_lang"; }
            set { prc_create_dbne_defi_lang = value; }
        }
        #endregion
        
        #region PRC_READ_DBNE_DEFI_LANG
        private string prc_read_dbne_defi_lang;
        
        public string PRC_READ_DBNE_DEFI_LANG
        {
            get { return prc_read_dbne_defi_lang = "dbo.prc_read_dbne_defi_lang"; }
            set { prc_read_dbne_defi_lang = value; }
        }
        #endregion
        
        #region PRC_UPDATE_DBNE_DEFI_LANG
        private string prc_update_dbne_defi_lang;
        
        public string PRC_UPDATE_DBNE_DEFI_LANG
        {
            get { return prc_update_dbne_defi_lang = "dbo.prc_update_dbne_defi_lang"; }
            set { prc_update_dbne_defi_lang = value; }
        }
        #endregion
        
        #region PRC_DELETE_DBNE_DEFI_LANG
        private string prc_delete_dbne_defi_lang;
        
        public string PRC_DELETE_DBNE_DEFI_LANG
        {
            get { return prc_delete_dbne_defi_lang = "dbo.prc_delete_dbne_defi_lang"; }
            set { prc_delete_dbne_defi_lang = value; }
        }
        #endregion
    }
}
