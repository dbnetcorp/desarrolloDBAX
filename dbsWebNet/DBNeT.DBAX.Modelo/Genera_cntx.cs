using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Data;

 public partial class Genera_cntx
 {
     /// <summary>
     /// Guarda los conceptos
     /// </summary>
     public string Guarda_contextos(string nombrecntx, string fini_cntx, string ffin_cntx, string codi_Empr)
     {
         return "execute SP_AX_GuardaCntx '" + nombrecntx + "','" + fini_cntx + "','" + ffin_cntx + "','" + codi_Empr + "'";
     }
     /// <summary>
     /// LLena grilla cntx
     /// </summary>
     public string LLenado_grilla()
     {
         return "execute SP_AX_Get_contextos";
     }
     /// <summary>
     /// Elimina cntx
     /// </summary>
     public string Eliminar_cntx(string nombrecntx, string codi_Empr)
     {
         return "execute SP_AX_Elimina_cntx '" + nombrecntx + "','" + codi_Empr + "'";
     }
     /// <summary>
     /// LLena Informes
     /// </summary>
     public string LLenado_Informe()
     {
         return "execute SP_AX_RescInforme";
     }
     /// <summary>
     /// LLena Contextos
     /// </summary>
     public string LLenado_Contexto()
     {
         return "execute SP_AX_Contextos";
     }
     /// <summary>
     /// Guarda los Informes Contextos
     /// </summary>
     public string Guarda_Info_cntx(string Informe, string contexto, string orden, string codi_empr)
     {
         return "execute SP_AX_Guarda_Cntx_infor '" + Informe + "','" + contexto + "','" + orden + "','" + codi_empr + "'";
     }
     /// <summary>
     /// LLena grilla informe contexto
     /// </summary>
     public string LLenado_grilla_informe_contexto(string informe)
     {
         return "execute SP_AX_Get_informe_contexto_grilla'" + informe + "'";
     }
     /// <summary>
     /// Elimina info_cntx
     /// </summary>
     public string Eliminar_Info_cntx(string codi_info_cntx, string codi_Empr)
     {
         return "execute SP_AX_Elimina_Info_cntx '" + codi_info_cntx + "','" + codi_Empr + "'";
     }
     /// <summary>
     /// Modificar grilla informe contexto
     /// </summary>
     public string Modificar_grilla_informe_contexto(string codi_info_cntx, string codi_Empr, string orden)
     {
         return "execute SP_AX_Modificar_informe_contexto_grilla'" + codi_info_cntx + "','" + codi_Empr + "','" + orden + "'";
     }
     /// <summary>
     /// Validacion de orden
     /// </summary>
     /// 
     public string valida_orden(string codi_info_cntx, string codi_Empr, string orden)
     {
         return "execute SP_AX_Valida_orde_info_cntx'" + codi_info_cntx + "','" + codi_Empr + "','" + orden + "'";
    
     }
 }

