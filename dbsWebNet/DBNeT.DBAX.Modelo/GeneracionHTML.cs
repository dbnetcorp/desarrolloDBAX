using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
//using System.Web;
//using System.Web.UI;
//using System.Web.UI.WebControls;
using System.Text;
using System.IO;
using System.Data;
using System.Web;


public partial class GeneracionHTML
{
    Conexion con = new Conexion().CrearInstancia();
    RescateDeConceptos modConc = new RescateDeConceptos();
    ModeloMantencionCntx Contextos = new ModeloMantencionCntx();

    public string insEmpresaParaInforme(string codi_pers, string desc_pers, string corr_inst)
    {
        return "execute SP_AX_insEmpresaParaInforme '" + codi_pers + "','" + desc_pers + "','" + corr_inst + "'";
    }

    private string insEncabezadoInforme(string vDescInfo, string vCorrInst, string vDescPers, int vCantColu)
    {
        string vTablaResumen ="";
        //vNombre = vNombre.Replace(".html", "");
        //vNombre = vNombre.Substring(vNombre.LastIndexOf("\\")+1);
        //string vVersInst = vNombre.Substring(vNombre.LastIndexOf("_")+1);

        //vNombre = vNombre.Substring(0, vNombre.LastIndexOf("_"));

        //string vCorrInst = vNombre.Substring(vNombre.LastIndexOf("_") + 1);
        //vNombre = vNombre.Substring(0, vNombre.LastIndexOf("_"));
        
        //string vCodiPers = vNombre.Substring(vNombre.LastIndexOf("_") + 1);
        //string vCodiInfo = vNombre.Substring(0, vNombre.LastIndexOf("_"));

        //vTablaResumen += "<table style=\"border: 1px solid #DDDDDD; background-color: #EEEEEE;\">";
        
        vTablaResumen += "<tr>";
        vTablaResumen += "<th>";
        vTablaResumen += vDescInfo;
        vTablaResumen += "</th>";
        for (int i = 1; i < vCantColu; i++)
        {
            vTablaResumen += "<th></th>";
        }
        vTablaResumen += "</tr>";


        vTablaResumen += "<tr>";
        vTablaResumen += "<th>";
        vTablaResumen += vCorrInst;
        vTablaResumen += "</th>";
        for (int i = 1; i < vCantColu; i++)
        {
            vTablaResumen += "<th></th>";
        }
        vTablaResumen += "</tr>";


        vTablaResumen += "<tr>";
        vTablaResumen += "<th>";
        vTablaResumen += vDescPers;
        vTablaResumen += "</th>";
        for (int i = 1; i < vCantColu; i++)
        {
            vTablaResumen += "<th></th>";
        }
        vTablaResumen += "</tr>";

        vTablaResumen += "<tr>";
        for (int i = 0; i < vCantColu; i++)
        {
            vTablaResumen += "<th></th>";
        }
        vTablaResumen += "</tr>";
        //vTablaResumen += "</table>";
        //vTablaResumen += "</br></br>";
        return vTablaResumen;
    }

    public void GeneracionHTML_Informes(string ruta, DataTable tabla, string informe, FileMode vFileMode, string vDescinfo, int vCont, bool vConEncabezado = false, string vCorrInst = "", string vDescPers = "")
    {
        FileStream fsFlujo = new FileStream(ruta, vFileMode, FileAccess.Write);
        StreamWriter swGrabador = new StreamWriter(fsFlujo, Encoding.Unicode);
        if (vCont == 1 || vCont == 3)
        {
            swGrabador.WriteLine("<html>");
            swGrabador.WriteLine("<head>");
            swGrabador.WriteLine("<meta http-equiv=\"cache-control\" content=\"no-cache\"/>");
            swGrabador.WriteLine("<link rel=\"StyleSheet\" type=\"text/css\">");
            swGrabador.WriteLine("</head>");
            swGrabador.WriteLine("<body>");
        }

        if (vDescinfo != "" && !vConEncabezado)
        {
            swGrabador.WriteLine("<br/><br/>");
            swGrabador.WriteLine("<b class=\"TituloHTML\">  Informe: " + vDescinfo + "</b>");
        }
        
        swGrabador.WriteLine(" <table class=\"HtmlDeReporte\" title=\"Grilla de informe\" id=\"jSheet_0_2\" border=\"1px\" cellpadding=\"0\" cellspacing=\"0\">");
        swGrabador.WriteLine(" <tbody>");

        string clase = "class=\"\"";

        if (vConEncabezado)
        {
            swGrabador.WriteLine(insEncabezadoInforme(vDescinfo, vCorrInst, vDescPers, tabla.Columns.Count-2));
        }

        swGrabador.WriteLine(" <tr >");
        swGrabador.WriteLine(" <th >Concepto</th>");
        for (int i = 3; i < tabla.Columns.Count; i++)
        {
            swGrabador.WriteLine("<th >" + tabla.Columns[i].ColumnName.ToString() + "</th>");
        }
        swGrabador.WriteLine(" </tr>");


        #region Con Negrita
        foreach (DataRow drFila in tabla.Rows)
        {
            if (drFila[0].ToString() == "1") // con negrita
            {
                try
                {
                    swGrabador.WriteLine(" <tr class=\"TextosNegritas\">");
                    switch (drFila[1].ToString())
                    {
                        case ("1"):
                            swGrabador.WriteLine("<td class=\"ConceptoHTML\">" + drFila[2].ToString() + "</td>");
                            break;
                        case ("2"):
                            swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                            break;
                        case ("3"):
                            swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                            break;
                        case ("4"):
                            swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                            break;
                        default:
                            swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                            break;
                    }

                    for (int i = 3; i < tabla.Columns.Count; i++)
                    {
                        swGrabador.WriteLine(" <td align=\"right\" style=\"font-size: 12px; font-family:Calibri;\">" + drFila[i].ToString() + "</td>");
                    }
                }
                catch
                {
                    swGrabador.WriteLine(" <td>&nbsp;</td>");
                }
                swGrabador.WriteLine(" </tr>");
            }
        #endregion
            #region Sin  Negrita
            else // sin negrita
            {
                try
                {
                    swGrabador.WriteLine(" <tr>");
                    switch (drFila[1].ToString())
                    {
                        case ("1"):
                            swGrabador.WriteLine("<td class=\"ConceptoHTML\">" + drFila[2].ToString() + "</td>");
                            break;
                        case ("2"):
                            swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                            break;
                        case ("3"):
                            swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                            break;
                        case ("4"):
                            swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                            break;
                        default:
                            swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                            break;
                    }

                    for (int i = 3; i < tabla.Columns.Count; i++)
                    {
                        swGrabador.WriteLine(" <td align=\"right\" style=\"font-size: 12px; font-family:Calibri;\">" + drFila[i].ToString() + "</td>");
                    }
                }
                catch
                {
                    swGrabador.WriteLine(" <td>&nbsp;</td>");
                }
                swGrabador.WriteLine(" </tr>");
            }
            #endregion
        }

        swGrabador.WriteLine(" </tbody>");
        swGrabador.WriteLine(" </table>");

        if (vCont == 2 || vCont == 3)
        {
            
            swGrabador.WriteLine(" </body>");
            swGrabador.WriteLine(" </html>");
        }
        swGrabador.Close();
        fsFlujo.Close();
        swGrabador = null;
        fsFlujo = null;
    }
    public void escribeArchivo(string ruta, string vContenido)
    {
        if (File.Exists(ruta))
        {
            File.Delete(ruta);
        }

        FileStream fsFlujo = new FileStream(ruta, FileMode.Create, FileAccess.Write);
        StreamWriter swGrabador = new StreamWriter(fsFlujo, Encoding.Unicode);
        
        swGrabador.Write(vContenido);
        
        swGrabador.Close();
        fsFlujo.Close();
        swGrabador = null;
        fsFlujo = null;
    }
    public void     GeneracionHTML_InformesTextosDiferentes(string ruta, DataTable tabla, string informe, FileMode vFileMode, string vDescinfo, int vCont)
    {
        int vTablaNumerica = 0;
        FileStream fsFlujo = new FileStream(ruta, vFileMode, FileAccess.Write);
        StreamWriter swGrabador = new StreamWriter(fsFlujo, Encoding.Unicode);
        if (vCont == 1 || vCont == 3)
        {
            swGrabador.WriteLine("<html>");
            swGrabador.WriteLine("<head>");
            swGrabador.WriteLine("<meta http-equiv=\"cache-control\" content=\"no-cache\"/>");
            swGrabador.WriteLine("<link rel=\"StyleSheet\" type=\"text/css\" href=\"test.css\">");
            swGrabador.WriteLine("</head>");
            swGrabador.WriteLine("<body>");
        }

        if (vDescinfo != "")
        {
            swGrabador.WriteLine("<br/>");
            swGrabador.WriteLine("<b class=\"TituloHTML\">  Informe: " + vDescinfo + "</b>");
        }

        foreach (DataRow drFila in tabla.Rows)
        {
            int z = 0, t = 0; ;
            for (int j = 5; j < drFila.ItemArray.Count(); j++)
            {
                if (drFila.ItemArray[j].ToString() != "")
                {
                    t = j;
                    z++;
                }
            }

            if ((drFila["tipo_valo"].ToString() == "xbrli:stringItemType" || drFila["tipo_valo"].ToString() == "nonnum:escapedItemType" || drFila["tipo_valo"].ToString() == "xbrli:dateItemType") &&
                drFila["tipo_cuen"].ToString() != "abstract" && z <= 1)
            {
                if (vTablaNumerica == 1)
                {
                    imprFinTabla(swGrabador);
                    imprInicioTabla(swGrabador);
                    vTablaNumerica = 0;
                }
                impTablaConceptoTexto(swGrabador, drFila, t);
            }
            else //if (z >= 1)
            {
                if (vTablaNumerica == 0)
                {
                    imprInicioTabla(swGrabador);
                    vTablaNumerica = imprInicioTablaNumerica(swGrabador, tabla, 5);
                }
                
                #region Con Negrita
                if (drFila[0].ToString() == "1") // con negrita
                {
                    try
                    {
                        swGrabador.WriteLine(" <tr class=\"TextosNegritas\">");
                        switch (drFila[1].ToString())
                        {
                            case ("1"):
                                swGrabador.WriteLine("<td class=\"ConceptoHTML\">" + drFila[2].ToString() + "</td>");
                                break;
                            case ("2"):
                                swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                                break;
                            case ("3"):
                                swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                                break;
                            case ("4"):
                                swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                                break;
                            default:
                                swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                                break;
                        }

                        for (int i = 5; i < tabla.Columns.Count; i++)
                        {
                            //swGrabador.WriteLine(" <td align=\"right\" style=\"font-size: 12px; font-family:Calibri;\"><label><input type=\"checkbox\" /><div class=\"content\"><span class=\"hidden\">" + drFila[i].ToString() + "</span></div></label></td>");
                            swGrabador.WriteLine(" <td>" + drFila[i].ToString() + "</td>");
                        }
                    }
                    catch
                    {
                        swGrabador.WriteLine(" <td>&nbsp;</td>");
                    }
                    swGrabador.WriteLine(" </tr>");
                }
                #endregion
                #region Sin  Negrita
                else // sin negrita
                {
                    try
                    {
                        swGrabador.WriteLine(" <tr>");
                        switch (drFila[1].ToString())
                        {
                            case ("1"):
                                swGrabador.WriteLine("<td class=\"ConceptoHTML\">" + drFila[2].ToString() + "</td>");
                                break;
                            case ("2"):
                                swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                                break;
                            case ("3"):
                                swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                                break;
                            case ("4"):
                                swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                                break;
                            default:
                                swGrabador.WriteLine("<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>");
                                break;
                        }

                        for (int i = 5; i < tabla.Columns.Count; i++)
                        {
                            //swGrabador.WriteLine(" <td align=\"right\" style=\"font-size: 12px; font-family:Calibri;\"><label><input type=\"checkbox\" /><div class=\"content\"><span class=\"hidden\">" + drFila[i].ToString() + "</span></div></label></td>");
                            swGrabador.WriteLine(" <td >" + drFila[i].ToString() + "</td>");
                        }

                    }
                    catch
                    {
                        swGrabador.WriteLine(" <td>&nbsp;</td>");
                    }
                    swGrabador.WriteLine(" </tr>");
                }
                #endregion
            }
        }
        if (vTablaNumerica == 1)
        {
            imprFinTabla(swGrabador);
        }

        if (vCont == 2 || vCont == 3)
        {
            swGrabador.WriteLine(" </body>");
            swGrabador.WriteLine(" </html>");
        }
        swGrabador.Close();
        fsFlujo.Close();
        swGrabador = null;
        fsFlujo = null;
    }
    public string   GeneracionHTML_InformesTextosDiferentes(DataTable tabla, string informe, string vDescinfo, int vCont)
    {
        int vTablaNumerica = 0;
        string vHtml = "";
        foreach (DataRow drFila in tabla.Rows)
        {
            int z = 0, t = 0; ;
            for (int j = 5; j < drFila.ItemArray.Count(); j++)
            {
                if (drFila.ItemArray[j].ToString() != "")
                {
                    t = j;
                    z++;
                }
            }

            if ((drFila["tipo_valo"].ToString() == "xbrli:stringItemType" || drFila["tipo_valo"].ToString() == "nonnum:escapedItemType" || drFila["tipo_valo"].ToString() == "xbrli:dateItemType") &&
                drFila["tipo_cuen"].ToString() != "abstract" && z <= 1)
            {
                if (vTablaNumerica == 1)
                {
                    vHtml += imprFinTabla();
                    vHtml += imprInicioTabla();
                    vTablaNumerica = 0;
                }
                vHtml += impTablaConceptoTexto(drFila, t);
            }
            else //if (z >= 1)
            {
                if (vTablaNumerica == 0)
                {
                    vHtml += imprInicioTabla();
                    vHtml += imprInicioTablaNumerica(tabla, 5);
                    vTablaNumerica = 1;
                }

                #region Con Negrita
                if (drFila[0].ToString() == "1") // con negrita
                {
                    try
                    {
                        vHtml += " <tr class=\"TextosNegritas\">";
                        switch (drFila[1].ToString())
                        {
                            case ("1"):
                                vHtml += "<td class=\"ConceptoHTML\">" + drFila[2].ToString() + "</td>";
                                break;
                            case ("2"):
                                vHtml += "<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>";
                                break;
                            case ("3"):
                                vHtml += "<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>";
                                break;
                            case ("4"):
                                vHtml += "<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>";
                                break;
                            default:
                                vHtml += "<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>";
                                break;
                        }

                        for (int i = 5; i < tabla.Columns.Count; i++)
                        {
                            //vHtml += " <td align=\"right\" style=\"font-size: 12px; font-family:Calibri;\"><label><input type=\"checkbox\" /><div class=\"content\"><span class=\"hidden\">" + drFila[i].ToString() + "</span></div></label></td>");
                            vHtml += " <td>" + drFila[i].ToString() + "</td>";
                        }
                    }
                    catch
                    {
                        vHtml += " <td>&nbsp;</td>";
                    }
                    vHtml += " </tr>";
                }
                #endregion
                #region Sin  Negrita
                else // sin negrita
                {
                    try
                    {
                        vHtml += " <tr>";
                        switch (drFila[1].ToString())
                        {
                            case ("1"):
                                vHtml += "<td class=\"ConceptoHTML\">" + drFila[2].ToString() + "</td>";
                                break;
                            case ("2"):
                                vHtml += "<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>";
                                break;
                            case ("3"):
                                vHtml += "<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>";
                                break;
                            case ("4"):
                                vHtml += "<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>";
                                break;
                            default:
                                vHtml += "<td class=\"ConceptoHTML\">&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;" + drFila[2].ToString() + "</td>";
                                break;
                        }

                        for (int i = 5; i < tabla.Columns.Count; i++)
                        {
                            //vHtml += " <td align=\"right\" style=\"font-size: 12px; font-family:Calibri;\"><label><input type=\"checkbox\" /><div class=\"content\"><span class=\"hidden\">" + drFila[i].ToString() + "</span></div></label></td>");
                            vHtml += " <td >" + drFila[i].ToString() + "</td>";
                        }

                    }
                    catch
                    {
                        vHtml += " <td>&nbsp;</td>";
                    }
                    vHtml += " </tr>";
                }
                #endregion
            }
        }
        if (vTablaNumerica == 1)
        {
            vHtml += imprFinTabla();
        }

        return vHtml;
    }
    private void    imprInicioTabla(StreamWriter swGrabador)
    {
        swGrabador.WriteLine(" <table class=\"HtmlDeReporte\" title=\"Grilla de informe\" id=\"jSheet_0_2\" border=\"1px\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">");
        swGrabador.WriteLine(" <tbody>");
    }
    private string  imprInicioTabla()
    {
        string vHtml ="";
        vHtml += " <table class=\"HtmlDeReporte\" title=\"Grilla de informe\" id=\"jSheet_0_2\" border=\"1px\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
        vHtml += " <tbody>";

        return vHtml;
    }

    private void    imprInicioTablaTexto(StreamWriter swGrabador)
    {
        swGrabador.WriteLine(" <table class=\"HtmlDeReporte\" border=\"1px\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">");
        swGrabador.WriteLine(" <tbody>");
    }
    private string  imprInicioTablaTexto()
    {
        string vHtml = "";
        vHtml += " <table class=\"HtmlDeReporte\" border=\"1px\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
        vHtml += " <tbody>";
        return vHtml;
    }
    
    private void    imprFinTabla(StreamWriter swGrabador)
    {
        swGrabador.WriteLine(" </tbody>");
        swGrabador.WriteLine(" </table>");
        swGrabador.WriteLine(" </br></br>");
    }
    private string  imprFinTabla()
    {
        string vHtml ="";
        vHtml += " </tbody>";
        vHtml += " </table>";
        vHtml += " </br></br>";
        return vHtml;
    }

    private void    imprFinTablaTexto(StreamWriter swGrabador)
    {
        swGrabador.WriteLine(" </tbody>");
        swGrabador.WriteLine(" </table>");
        swGrabador.WriteLine(" </br>");
    }
    private string  imprFinTablaTexto()
    {
        string vHtml = "";
        vHtml += " </tbody>";
        vHtml += " </table>";
        vHtml += " </br>";
        return vHtml;
    }

    private int imprInicioTablaNumerica(StreamWriter swGrabador, DataTable tabla, int i)
    {
        swGrabador.WriteLine(" <tr >");
        swGrabador.WriteLine(" <th >Concepto</th>");
        for (i=i; i < tabla.Columns.Count; i++)
        {
            swGrabador.WriteLine("<th >" + tabla.Columns[i].ColumnName.ToString() + "</th>");
        }

        swGrabador.WriteLine(" </tr>");

        return 1;
    }
    private string imprInicioTablaNumerica(DataTable tabla, int i)
    {
        string vHtml = "";
        vHtml += " <tr >";
        vHtml += " <th >Concepto</th>";
        for (i = i; i < tabla.Columns.Count; i++)
        {
            vHtml += "<th >" + tabla.Columns[i].ColumnName.ToString() + "</th>";
        }

        vHtml += " </tr>";

        return vHtml;
    }
    private void impTablaConceptoTexto(StreamWriter swGrabador, DataRow fila, int columna)
    {
        imprInicioTablaTexto(swGrabador);
        swGrabador.WriteLine("<tr><td class=\"ConceptoTexto\">" + fila["desc_conc"].ToString().Replace("[bloque de texto]","") + "</td></tr>");
        swGrabador.WriteLine(("<tr><td class=\"ValorTexto\">" + fila[columna].ToString() + "</td></tr>").Replace("<td></td>","<td>&nbsp;</td>"));
        imprFinTablaTexto(swGrabador);
    }
    private string impTablaConceptoTexto(DataRow fila, int columna)
    {
        string vHtml = "";
        vHtml += imprInicioTablaTexto();
        vHtml += "<tr><td class=\"ConceptoTexto\">" + fila["desc_conc"].ToString().Replace("[bloque de texto]", "") + "</td></tr>";
        vHtml += ("<tr><td class=\"ValorTexto\">" + fila[columna].ToString() + "</td></tr>").Replace("<td></td>", "<td>&nbsp;</td>");
        vHtml += imprFinTablaTexto();
        return vHtml;
    }
    public string getEmpresaEstadoCargExte(string CodiEmex, string CodiEmpr, string pCodiUsua)
    {
        return "execute SP_AX_getEmpresaEstadoCargExte '" + CodiEmex + "','" + CodiEmpr + "','" + pCodiUsua + "'";
    }
    public string getEmpresaEstadoCargExteVers(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string FechCarg, string pCodiUsua, string pDbgxEmpr, string pDbgxCorr, string pDbgxVers)
    {
        return "execute SP_AX_getEmpresaEstadoCargExteVers '" + CodiEmex + "','" + CodiEmpr + "','" + CodiPers + "','" + CorrInst + "','" + FechCarg + "','" + pCodiUsua + "','" + pDbgxEmpr + "','" + pDbgxCorr + "','" + pDbgxVers + "'";
    }
    public void GeneracionHTML_InformesTranspuesto(string ruta, DataTable tabla, string informe)
    {
        FileStream fsFlujo = new FileStream(ruta, FileMode.Create, FileAccess.Write);
        StreamWriter swGrabador = new StreamWriter(fsFlujo, Encoding.Unicode);

        string clase = "class=\"\"";

        swGrabador.WriteLine("<html>");
        swGrabador.WriteLine("<head>");
        swGrabador.WriteLine("<meta http-equiv=\"cache-control\" content=\"no-cache\"/>");
        swGrabador.WriteLine("</head>");
        swGrabador.WriteLine("<body>");
        swGrabador.WriteLine(" <table style=\"title=\"Grilla de informe\" class=\"HtmlDeReporte\" id=\"jSheet_0_2\" border=\"1px\" cellpadding=\"0\" cellspacing=\"0\">");
        swGrabador.WriteLine(" <tbody>");
        swGrabador.WriteLine(" <tr class=\"HeaderTR\" >");
        swGrabador.WriteLine(" <th >Concepto</th>");
        for (int i = 0; i < tabla.Columns.Count; i++)
        {
            if (i != 0)
                swGrabador.WriteLine("  <th >" + tabla.Columns[i].ColumnName.ToString() + "</th>");
            else
                continue;
        }
        swGrabador.WriteLine(" </tr>");
        foreach (DataRow drFila in tabla.Rows)
        {

            try
            {
                swGrabador.WriteLine(" <tr >");
                for (int i = 0; i < tabla.Columns.Count; i++)
                { swGrabador.WriteLine(" <td align=\"right\" >" + drFila[i].ToString() + "</td>"); }
            }
            catch
            { swGrabador.WriteLine(" <td>&nbsp;</td>"); }
            swGrabador.WriteLine(" </tr>");

        }
        swGrabador.WriteLine(" </tbody>");
        swGrabador.WriteLine(" </table>");

        swGrabador.WriteLine(" </body>");
        swGrabador.WriteLine(" </html>");
        swGrabador.Close();
        fsFlujo.Close();
        swGrabador = null;
        fsFlujo = null;
    }
    /// <summary>
    /// Generar HTML (tags) de un cuadro correspondiente a una dimension
    /// </summary>
    public void GeneracionHTMLDimensiones(string ruta, DataTable tabla, int numeEjes, FileMode vFileMode, string vDescInfo, int vCont, bool vConEncabezado = false, string vCorrInst = "", string vDescPers = "")
    {
        Log.putLog("Escribiendo tags HTML de informe " + vDescInfo);
        FileStream fsFlujo = new FileStream(ruta, vFileMode, FileAccess.Write);
        StreamWriter swGrabador = new StreamWriter(fsFlujo, Encoding.Unicode);
        if (vCont == 1 || vCont == 3)
        {
            swGrabador.WriteLine("<html>");
            swGrabador.WriteLine("<head>");
            swGrabador.WriteLine("<meta http-equiv=\"cache-control\" content=\"no-cache\"/>");
            //swGrabador.WriteLine("<link rel=\"stylesheet\" href=\"../CSS/DBAX.css\">");
            swGrabador.WriteLine("<link rel=\"StyleSheet\" type=\"text/css\" href=\"test.css\">");
            swGrabador.WriteLine("</head>");
            swGrabador.WriteLine("<body>");
        }
        if (vDescInfo != "" && !vConEncabezado)
        {
            swGrabador.WriteLine("<br/><br/>");
            swGrabador.WriteLine("<b class=\"TituloHTML\">  Informe: " + vDescInfo + "</b>");
        }
        swGrabador.WriteLine(" <table title=\"Grilla de informe\" class=\"HtmlDeReporte\" id=\"jSheet_0_2\" border=\"1px\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">");
        swGrabador.WriteLine(" <tbody>");

        bool vEsHeader = true;
        string clase = "class=\"\"";

        //Si la tabla NO viene transpuesta, la primera columna tiene los valores de las negritas
        int vInicioTabla = 1;
        //Pero SI VIENE transpuesta la primera columa tiene la descripcion de los conceptos
        if (tabla.Columns[0].ColumnName == "desc_conc")
            vInicioTabla = 0;


        if (vConEncabezado)
        {
            swGrabador.WriteLine(insEncabezadoInforme(vDescInfo, vCorrInst, vDescPers, tabla.Columns.Count - 1));
        }

        //Para cada fila de la tabla
        for (int i = 0; i < tabla.Rows.Count; i++)
        {
            if (vEsHeader)
            {
                
                    swGrabador.WriteLine(" <tr>");
            }
            else
            {
                
                if (vInicioTabla==1 && tabla.Rows[i][0].ToString() == "1")
                {
                    swGrabador.WriteLine(" <tr class=\"TextosNegritas\">");
                }
                else
                    swGrabador.WriteLine(" <tr>");
            }

            for (int j = vInicioTabla; j < tabla.Columns.Count; j++)
            {
                if (j == vInicioTabla)
                {
                    clase = "class=\"ConceptoHTML\"";
                }
                else
                    clase = "";
                if (i < numeEjes) //Si estoy en las filas de encabezado imprimo como TH
                {
                    swGrabador.WriteLine(" <th>" + tabla.Rows[i][j].ToString().Replace("[miembro]","").Replace("[member]","") + "</th>");
                }
                else
                {
                    swGrabador.WriteLine("<td " + clase + "><label><input type=\"checkbox\" /><div class=\"content\"><span class=\"hidden\">" + tabla.Rows[i][j].ToString() + "</span></div></label></td>");
                }
            }
            vEsHeader = false;
            swGrabador.WriteLine(" </tr>");
        }

        swGrabador.WriteLine(" </tbody>");
        swGrabador.WriteLine(" </table>");

        if (vCont == 2 || vCont == 3)
        {
            
            swGrabador.WriteLine(" </body>");
            swGrabador.WriteLine(" </html>");
        }
        swGrabador.Close();
        fsFlujo.Close();
        swGrabador = null;
        fsFlujo = null;
    }
    /// <summary>
    /// Generar HTML (tags) de un cuadro correspondiente a una dimension
    /// </summary>
    public string GeneracionHTMLDimensiones(DataTable tabla, int numeEjes, string vDescInfo, int vCont, bool vConEncabezado = false, string vCorrInst = "", string vDescPers = "")
    {
        Log.putLog("Escribiendo tags HTML de informe " + vDescInfo);
        string vHtml = "";
        vHtml += " <table title=\"Grilla de informe\" class=\"HtmlDeReporte\" id=\"jSheet_0_2\" border=\"1px\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
        vHtml += " <tbody>";

        bool vEsHeader = true;
        string clase = "class=\"\"";

        //Si la tabla NO viene transpuesta, la primera columna tiene los valores de las negritas
        int vInicioTabla = 1;
        //Pero SI VIENE transpuesta la primera columa tiene la descripcion de los conceptos
        if (tabla.Columns[0].ColumnName == "desc_conc")
            vInicioTabla = 0;

        if (vConEncabezado)
        {
            vHtml += insEncabezadoInforme(vDescInfo, vCorrInst, vDescPers, tabla.Columns.Count - 1);
        }

        //Para cada fila de la tabla
        for (int i = 0; i < tabla.Rows.Count; i++)
        {
            if (vEsHeader)
            {
                vHtml += " <tr>";
            }
            else
            {
                if (vInicioTabla == 1 && tabla.Rows[i][0].ToString() == "1")
                {
                    vHtml += " <tr class=\"TextosNegritas\">";
                }
                else
                    vHtml += " <tr>";
            }

            for (int j = vInicioTabla; j < tabla.Columns.Count; j++)
            {
                if (j == vInicioTabla)
                {
                    clase = "class=\"ConceptoHTML\"";
                }
                else
                    clase = "";
                if (i < numeEjes) //Si estoy en las filas de encabezado imprimo como TH
                {
                    vHtml += " <th>" + tabla.Rows[i][j].ToString().Replace("[miembro]", "").Replace("[member]", "") + "</th>";
                }
                else
                {
                    vHtml += "<td " + clase + "><label><input type=\"checkbox\" /><div class=\"content\"><span class=\"hidden\">" + tabla.Rows[i][j].ToString() + "</span></div></label></td>";
                }
            }
            vEsHeader = false;
            vHtml += " </tr>";
        }

        vHtml += " </tbody>";
        vHtml += " </table>";

        return vHtml;
    }
    /// <summary>
    /// Lee archivo y devuelve lo leido. Solo debe usarse para textos planos, por ejemplo HTML
    /// </summary>
    /// 
    public string leeArchivoPlano(string archivo)
    {
        try
        {
            StreamReader strR = new StreamReader(archivo);
            string contenido = strR.ReadToEnd();
            return contenido;
        }
        catch (Exception ex)
        {
            Log.putLog("No se pudo leer archivo :" + archivo);
        }
        return "No se pudo leer el archivo";
    }
    /// <summary>
    /// Escapa texto plano para ser guardado en DB
    /// </summary>
    ///
    public string escapaTexto(string texto)
    {
        var encoded = HttpUtility.HtmlEncode(texto);
        return encoded;
    }
    public DataTable getDatosReporte(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string VersInst, string CodiInfo, DataTable dt_Contextos, DataTable dt_DescConc, string CodiMone)
    {
        for (int i = 0; i < dt_Contextos.Rows.Count; i++)
        {
            dt_DescConc = getInformeConColumnaAgregada(CodiEmex, CodiEmpr, CodiPers, CorrInst, VersInst, CodiInfo, dt_Contextos.Rows[i]["fini_cntx"].ToString(), dt_Contextos.Rows[i]["ffin_cntx"].ToString(), dt_DescConc, i,CodiMone).Copy();
        }
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene columna de datos para informe multiempresa (recibe una lista)
    /// </summary>
    public DataTable getDatosReporte(string CodiEmex, string CodiEmpr, string CodiInfo, string CorrInst, DataTable dt_DescConc, StringCollection Empresas, string Fini_cntx, string Ffin_cntx,string CodiMone)
    {
        int i = 0;
        foreach (string Empresa in Empresas)
        {
            dt_DescConc = getInformeConColumnaAgregada(CodiEmex, CodiEmpr, CodiInfo, Empresa, CorrInst, Fini_cntx, Ffin_cntx, dt_DescConc, i,CodiMone).Copy();
            i++;
        }
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene columna de datos para informe multiempresa (recibe un diccionario)
    /// </summary>
    public DataTable getDatosReporte(string CodiEmex, string CodiEmpr, string CodiInfo, string CorrInst, DataTable dt_DescConc, Dictionary<string, string> Empresas, string Fini_cntx, string Ffin_cntx, string CodiMone)
    {
        int i = 0;
        //foreach (string Empresa in Empresas)
        foreach (KeyValuePair<string, string> kvp in Empresas)
        {
            dt_DescConc = getInformeConColumnaAgregada(CodiEmex, CodiEmpr, CodiInfo, kvp, CorrInst, Fini_cntx, Ffin_cntx, dt_DescConc, i,CodiMone).Copy();
            i++;
        }
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene columna de datos para informe multiempresa (recibe un diccionario) y tipo de informe
    /// </summary>
    public DataTable getDatosReporte(string CodiEmex, string CodiEmpr, string CodiInfo, string CorrInst, DataTable dt_DescConc, Dictionary<string, string> Empresas, string Fini_cntx, string Ffin_cntx, string CodiMone, string TipoInfo)
    {
        int i = 0;
        //foreach (string Empresa in Empresas)
        foreach (KeyValuePair<string, string> kvp in Empresas)
        {
            dt_DescConc = getInformeConColumnaAgregada(CodiEmex, CodiEmpr, CodiInfo, kvp, CorrInst, Fini_cntx, Ffin_cntx, dt_DescConc, i, CodiMone, TipoInfo).Copy();
            i++;
        }
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene columna de datos para informe multiPeríodo
    /// </summary>
    public DataTable getDatosReporte(string CodiEmex, string CodiEmpr, string CodiCntx, string CodiInfo, string CodiPers, DataTable dt_Periodos, DataTable dt_DescConc,string CodiMone)
    {
        for (int i = 0; i < dt_Periodos.Rows.Count; i++)
        {
            DataTable dt_Contextos = con.TraerResultados0(Contextos.getContextoFechas(CodiEmex, CodiEmpr, dt_Periodos.Rows[i]["corr_inst"].ToString(), CodiCntx)).Tables[0];
            dt_DescConc = getInformeConColumnaAgregadaPeri(CodiEmex, CodiEmpr, CodiInfo, CodiPers, dt_Periodos.Rows[i]["corr_inst"].ToString(), "0", dt_Contextos.Rows[0]["fini_cntx"].ToString(), dt_Contextos.Rows[0]["ffin_cntx"].ToString(), dt_DescConc, i,CodiMone).Copy();
        }
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene columna con datos para una empresa, de acuerdo a la definición de informes
    /// </summary>
    private DataTable getInformeConColumnaAgregada(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string VersInst, string CodiInfo, string FiniCntx, string FfinCntx, DataTable dt_DescConc, int i, string CodiMone)
    {
        try
        {
            int numColumnas = 3;
            DataTable dt_ValoColu = getInfoValoColu(CodiEmex, CodiEmpr, CodiPers, CorrInst, VersInst, CodiInfo, FiniCntx, FfinCntx, CodiMone).Tables[0];
            string vValoColu = string.Empty;
            dt_ValoColu.Columns[0].ColumnName = "Columna " + i;

            if (dt_DescConc.Columns.Count > 4 && dt_DescConc.Columns[3].ColumnName == "tipo_valo")
                numColumnas = 5;

            dt_DescConc.Columns.Add();
            dt_DescConc.Columns[i + numColumnas].ColumnName = FiniCntx;
            if (FfinCntx != "")
            {
                dt_DescConc.Columns[i + numColumnas].ColumnName = dt_DescConc.Columns[i + numColumnas].ColumnName + " / " + FfinCntx;
            }

            for (int j = 0; j < dt_ValoColu.Rows.Count; j++)
            {
                if (dt_ValoColu.Rows[j][0].ToString().Contains("###"))
                {
                    vValoColu = getValoConcClob(dt_ValoColu.Rows[j][1].ToString(), CodiPers, CorrInst, VersInst);
                    dt_DescConc.Rows[j][dt_DescConc.Columns.Count - 1] = vValoColu;
                }
                else
                    dt_DescConc.Rows[j][dt_DescConc.Columns.Count - 1] = dt_ValoColu.Rows[j][0].ToString();
            }
            return dt_DescConc;
        }
        catch (Exception ex)
        {
            return dt_DescConc;
        }
    }
    private string getValoConcClob(string CorrConc, string CodiPers, string CorrInst, string VersInst)
    {
        return con.StringEjecutarQuery(modConc.getValoConcClob(CorrConc, CodiPers, CorrInst, VersInst));
    }
    /// <summary>
    /// Obtiene columna de datos para informe multiEmpresa
    /// </summary>
    private DataTable getInformeConColumnaAgregada(string CodiEmex, string CodiEmpr, string CodiInfo, string CodiPers, string CorrInst, string FiniCntx, string FfinCntx, DataTable dt_DescConc, int i,string CodiMone)
    {
        DataTable dt_ValoColu = getInfoValoColu(CodiEmex, CodiEmpr, CodiPers, CorrInst, "0", CodiInfo, FiniCntx, FfinCntx,CodiMone).Tables[0];
        DataTable dtCodiMone = getCodiMone(CodiEmpr, CorrInst).Tables[0];
        dt_ValoColu.Columns[0].ColumnName = "Columna " + i;
        dt_DescConc.Columns.Add();
        dt_DescConc.Columns[i + 3].ColumnName = CodiPers;
        //dt_DescConc.Columns[i + 3].ColumnName = ;
        if (FfinCntx != "")
        {
            dt_DescConc.Columns[i + 3].ColumnName = dt_DescConc.Columns[i + 3].ColumnName + " / " + FfinCntx;
        }

        for (int j = 0; j < dt_ValoColu.Rows.Count; j++)
        {
            dt_DescConc.Rows[j][dt_DescConc.Columns.Count - 1] = dt_ValoColu.Rows[j][0].ToString();
        }
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene columna de datos para informe multiEmpresa (recibe un keyValuePair)
    /// </summary>
    private DataTable getInformeConColumnaAgregada(string CodiEmex, string CodiEmpr, string CodiInfo, KeyValuePair<string, string> kvp, string CorrInst, string FiniCntx, string FfinCntx, DataTable dt_DescConc, int i, string CodiMone)
    {
        DataTable dt_ValoColu = getInfoValoColu(CodiEmex, CodiEmpr, kvp.Key, CorrInst, "0", CodiInfo, FiniCntx, FfinCntx,CodiMone).Tables[0];
        DataTable dt_TipoMone = getCodiMone(kvp.Key, CorrInst).Tables[0];
        string codi_mone = string.Empty;
        foreach (DataRow item in dt_TipoMone.Rows)
        {
            codi_mone = item["codi_mone"].ToString();
        }

        dt_ValoColu.Columns[0].ColumnName = "Columna " + i;
        dt_DescConc.Columns.Add();
        //dt_DescConc.Columns[i + 3].ColumnName = CodiPers;
        dt_DescConc.Columns[i + 3].ColumnName = kvp.Value + "/ "+ codi_mone;
        if (FfinCntx != "")
        {
            dt_DescConc.Columns[i + 3].ColumnName = dt_DescConc.Columns[i + 3].ColumnName + " / " + FfinCntx;
        }

        for (int j = 0; j < dt_ValoColu.Rows.Count; j++)
        {
            dt_DescConc.Rows[j][dt_DescConc.Columns.Count - 1] = dt_ValoColu.Rows[j][0].ToString();
        }
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene columna de datos para informe multiEmpresa (recibe un keyValuePair) y tipoInfo
    /// </summary>
    private DataTable getInformeConColumnaAgregada(string CodiEmex, string CodiEmpr, string CodiInfo, KeyValuePair<string, string> kvp, string CorrInst, string FiniCntx, string FfinCntx, DataTable dt_DescConc, int i, string CodiMone, string TipoInfo)
    {
        //if (kvp.Key == "966287802")
        //    Console.Write(kvp.Key);

        string vInstVers = con.StringEjecutarQuery(modConc.getUltPersVersInst(kvp.Key, CorrInst));

        DataTable dt_ValoColu = getInfoValoColu(CodiEmex, CodiEmpr, kvp.Key, CorrInst, vInstVers, CodiInfo, FiniCntx, FfinCntx, CodiMone, TipoInfo).Tables[0];

        DataTable dt_TipoMone = getCodiMone(kvp.Key, CorrInst, vInstVers).Tables[0];
        string codi_mone = string.Empty;
        foreach (DataRow item in dt_TipoMone.Rows)
        {
            codi_mone = item["codi_mone"].ToString();
        }

        dt_ValoColu.Columns[0].ColumnName = "Columna " + i;
        dt_DescConc.Columns.Add();
        //dt_DescConc.Columns[i + 3].ColumnName = CodiPers;
        dt_DescConc.Columns[i + 3].ColumnName = kvp.Value + "/ " + codi_mone;
        if (FfinCntx != "")
        {
            dt_DescConc.Columns[i + 3].ColumnName = dt_DescConc.Columns[i + 3].ColumnName + " / " + FfinCntx;
        }

        for (int j = 0; j < dt_ValoColu.Rows.Count; j++)
        {
            dt_DescConc.Rows[j][dt_DescConc.Columns.Count - 1] = dt_ValoColu.Rows[j][0].ToString();
        }
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene columna de datos para informe multiPeríodo
    /// </summary>
    private DataTable getInformeConColumnaAgregadaPeri(string CodiEmex, string CodiEmpr, string CodiInfo, string CodiPers, string CorrInst, string VersInst, string FiniCntx, string FfinCntx, DataTable dt_DescConc, int i, string CodiMone)
    {
        DataTable dt_ValoColu = getInfoValoColu(CodiEmex, CodiEmpr, CodiPers, CorrInst, VersInst, CodiInfo, FiniCntx, FfinCntx,CodiMone).Tables[0];
        dt_ValoColu.Columns[0].ColumnName = "Columna " + i;
        dt_DescConc.Columns.Add();

        dt_DescConc.Columns[i + 3].ColumnName = CorrInst.Substring(0, 4) + '-' + CorrInst.Substring(CorrInst.Length - 2);

        for (int j = 0; j < dt_ValoColu.Rows.Count; j++)
        {
            dt_DescConc.Rows[j][dt_DescConc.Columns.Count - 1] = dt_ValoColu.Rows[j][0].ToString();
        }
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene (de un documento cargado) a un datatable pasado por parámetro
    /// </summary>
    public string getEmpresasDocumentosPorColumna(string CodiEmex, string CodiEmpr, string CorrInst, string DescPers, string Grupo, string Segmento, string Tipo, string NombDocu)
    {
        return "execute SP_AX_getArchivosPorGrupoSegmento " + CodiEmex + "," + CodiEmpr + "," + CorrInst + ",'" + DescPers + "','" + Grupo + "','" + Segmento + "','" + Tipo + "','" + NombDocu + "'";
    }
    /// <summary>
    /// Anexa una columna completa de un datatable a otro
    /// </summary>
    public DataTable AnexaColumna(DataTable Origen, DataTable Destino, string nombColu)
    {
        Origen.Columns.Add();
        Origen.Columns[Origen.Columns.Count - 1].ColumnName = nombColu;

        for (int j = 0; j < Destino.Rows.Count; j++)
        {
            Origen.Rows[j][Origen.Columns.Count - 1] = Destino.Rows[j][3].ToString();
        }
        return Origen;
    }
    /// <summary>
    /// Obtiene informe/concepto de una empresa/instancia en particular
    /// </summary>
    /// 
    private DataSet getInfoValoColu(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string VersInst, string CodiInfo, string vFiniCntx, string vFfinCntx, string CodiMone)
    {
        return con.TraerResultados0(modConc.getInfoValoColu(CodiEmex, CodiEmpr, CodiPers, CorrInst, VersInst, CodiInfo, vFiniCntx, vFfinCntx,CodiMone));
    }
    /// <summary>
    /// Obtiene informe/concepto de una empresa/instancia en particular (recibe tipoInfo)
    /// </summary>
    /// 
    private DataSet getInfoValoColu(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string VersInst, string CodiInfo, string vFiniCntx, string vFfinCntx, string CodiMone, string TipoInfo)
    {
        return con.TraerResultados0(modConc.getInfoValoColu(CodiEmex, CodiEmpr, CodiPers, CorrInst, VersInst, CodiInfo, vFiniCntx, vFfinCntx, CodiMone, TipoInfo));
    }
    public DataSet getCodiMone(string CodiEmpr, string CorrInst)
    {
        return con.TraerResultados0(modConc.getCodiMone(CodiEmpr,CorrInst));
    }
    public DataSet getCodiMone(string CodiEmpr, string CorrInst, string VersInst)
    {
        return con.TraerResultados0(modConc.getCodiMone(CodiEmpr, CorrInst, VersInst));
    }
    /// <summary>
    /// Rescata los archivos de los XBRL
    /// </summary>
    /// 
    public string GetArchivosXBRL(string corr_inst)
    {
        return "execute SP_AX_getEmpresasArchivosPorPeriodo " + corr_inst;
    }
    /// <summary>
    /// Rescata los archivos cargados para una empresa/version/instancia (sin traer contenido)
    /// </summary>
    /// 
    public string GetArchivosXBRL(string codi_pers, string corr_inst, string vers_inst)
    {
        return "execute SP_AX_getArchivosXbrl '" + codi_pers + "','" + corr_inst + "','" + vers_inst + "'";
    }
    /// <summary>
    /// Rescata el contenido de un archivo cargado para una empresa/version/instancia/archivo
    /// </summary>
    /// 
    public string GetArchivosXBRL(string codi_pers, string corr_inst, string vers_inst, string Archivo)
    {
        return "execute SP_AX_getArchivosXbrl " + codi_pers + "," + corr_inst + "," + vers_inst + ", '" + Archivo + "'";
    }
    // logica para las dimensiones de un eje
    /// <summary>
    /// Rescata los conceptos con los miembros de las dimensiones
    /// </summary>
    /// 
    public DataTable getDatosDimension(string CodiPers, string CorrInst, string VersInst, string CodiInfo, DataTable dt_Miembros, DataTable dt_DescConc, string dimension, string codi_mone, DataTable dt_CodiConc, string tipo_taxo)
    {
        for (int ax = 0; ax < dt_Miembros.Rows.Count; ax++)
        {
            if (tipo_taxo == "COME_INDU")
            {
                dt_DescConc.Columns.Add(); 
                dt_DescConc.Columns[ax + 1].ColumnName = dt_Miembros.Rows[ax]["desc_conc"].ToString() + " / " + dt_Miembros.Rows[ax]["fini_cntx"].ToString() + " " + ax;
            }
            else
            {
                dt_DescConc.Columns.Add();
                dt_DescConc.Columns[ax + 1].ColumnName = dt_Miembros.Rows[ax]["desc_conc"].ToString();
            }
        }
        for (int i = 0; i < dt_CodiConc.Rows.Count; i++)
        {
            string codi_conc = dt_CodiConc.Rows[i]["codi_conc"].ToString();
            string pref_conc = dt_CodiConc.Rows[i]["pref_conc"].ToString();
            string sald_ini = dt_CodiConc.Rows[i]["sald_ini"].ToString();
            //dt_DescConc = getInformeConColumnaAgregadaDimension(CodiPers, CorrInst, VersInst, CodiInfo, miembroconc, dt_DescConc, i, dimension, dt_Miembros.Rows[i]["desc_conc"].ToString(), dt_Miembros.Rows[i]["tipo_memb"].ToString(), codi_mone, fini_cntx, codi_conc, pref_conc, tipo_taxo).Copy();
            dt_DescConc = getInformeConColumnaAgregadaDimension(CodiPers, CorrInst, VersInst, CodiInfo, "", dt_DescConc, i, dimension, "", "", codi_mone, "", codi_conc, pref_conc, tipo_taxo, sald_ini).Copy();
        }
        return dt_DescConc;
    }
    /// <summary>
    /// Metodo que concatena las columnas
    /// </summary>
    private DataTable getInformeConColumnaAgregadaDimension(string CodiPers, string CorrInst, string VersInst, string CodiInfo, string codi_miembro, DataTable dt_DescConc, int i, string dimension, string desc_miemb, string tipo_memb, string codi_mone, string fini_cntx, string codi_conc, string pref_conc, string tipo_taxo, string sald_ini)
    {
        DataTable dt_ValoColu = getInfoValoColuDimension(CodiPers, CorrInst, VersInst, CodiInfo, codi_miembro, dimension, tipo_memb, codi_mone, codi_conc, pref_conc, tipo_taxo, sald_ini).Tables[0];

        dt_ValoColu.Columns[0].ColumnName = "Columna " + i;
        if (tipo_taxo == "COME_INDU")
        {
            for (int j = 0; j < dt_ValoColu.Rows.Count; j++)
            {
                dt_DescConc.Rows[i][j + 1] = dt_ValoColu.Rows[j]["valo_cntx"].ToString();
            }
        }
        else
        {
            for (int j = 0; j < dt_ValoColu.Rows.Count; j++)
            {
                //dt_DescConc.Rows[j][dt_DescConc.Columns.Count - 1] = dt_ValoColu.Rows[j][0].ToString();
                if (dt_ValoColu.Rows[j]["desc_conc"].ToString() == string.Empty)
                {
                    dt_DescConc.Rows[i][j+1] = dt_ValoColu.Rows[j]["valo_cntx"].ToString();
                }
                else
                {
                    dt_DescConc.Rows[i][dt_ValoColu.Rows[j]["desc_conc"].ToString()] = dt_ValoColu.Rows[j]["valo_cntx"].ToString();
                }
            }
        }
        return dt_DescConc;
    }
    /// <summary>
    /// Obtiene informe/concepto de una  dimension
    /// </summary>
    /// 
    private DataSet getInfoValoColuDimension(string CodiPers, string CorrInst, string VersInst, string CodiInfo, string desc_miembro, string dimension, string tipo_memb, string codi_mone, string codi_conc, string pref_conc, string tipo_taxo, string sald_ini)
    {
        return con.TraerResultados0(modConc.getInfoValoColuDimension(CodiPers, CorrInst, VersInst, CodiInfo, desc_miembro, dimension, tipo_memb, codi_mone, codi_conc, pref_conc, tipo_taxo, sald_ini));
    }
    /// <summary>
    ///Metodo para imprimir la dimension en el  html
    /// </summary>
    public void GeneracionHTML_Dimension(string ruta, DataTable tabla, string informe)
    {
        FileStream fsFlujo = new FileStream(ruta, FileMode.Create, FileAccess.Write);
        StreamWriter swGrabador = new StreamWriter(fsFlujo, Encoding.UTF8);

        swGrabador.WriteLine("<html>");
        swGrabador.WriteLine("<head>");
        swGrabador.WriteLine("<meta http-equiv=\"cache-control\" content=\"no-cache\"/>");
        swGrabador.WriteLine("</head>");
        swGrabador.WriteLine("<body>");
        swGrabador.WriteLine(" <table style=\"width: 0px; \" title=\"Grilla de informe\" class=\"jSheet ui-widget-content\" id=\"jSheet_0_2\" border=\"1px\" cellpadding=\"0\" cellspacing=\"0\">");
        swGrabador.WriteLine(" <tbody>");
        swGrabador.WriteLine(" <tr height:\"100\" >");
        swGrabador.WriteLine(" <td style=\"font-size: large; text-decoration: underline; font-weight: bold\">Concepto</td>");
        for (int i = 1; i < tabla.Columns.Count; i++)
        { swGrabador.WriteLine("  <th style=\"font-size: 12px; text-decoration: underline; font-weight: bold; font-family:Calibri; \">" + tabla.Columns[i].ColumnName.ToString() + "</td>"); }

        swGrabador.WriteLine(" </tr>");
        foreach (DataRow drFila in tabla.Rows)
        {
            try
            {
                swGrabador.WriteLine(" <tr height:\"20\" >");
                swGrabador.WriteLine("<td align=\"right\" style=\"font-size: 12px; font-family:Calibri; width:200px;\">" + drFila[0].ToString() + "</td>");
                for (int i = 1; i < tabla.Columns.Count; i++)
                { swGrabador.WriteLine(" <td align=\"right\">" + drFila[i].ToString() + "</td>"); }
            }
            catch
            {swGrabador.WriteLine(" <td>&nbsp;</td>");}
            swGrabador.WriteLine(" </tr>");
        }
        swGrabador.WriteLine(" </tbody>");
        swGrabador.WriteLine(" </table>");
        swGrabador.WriteLine(" </body>");
        swGrabador.WriteLine(" </html>");
        swGrabador.Close();
        fsFlujo.Close();
        swGrabador = null;
        fsFlujo = null;
    }
    /// <summary>
    /// Obtiene el valor de un único concepto para una empresa/instancia/version, dentro de un rango de fechas
    /// </summary>
    public string getValoConc(string CodiPers, string CorrInst, string VersInst, string PrefConc, string CodiConc, string FiniCntx, string FfinCntx)
    {
        return "execute SP_AX_getValoConc '" + CodiPers + "','" + CorrInst + "','" + VersInst + "','" + PrefConc + "','" + CodiConc + "','" + FiniCntx + "','" + FfinCntx + "'";
    }
    public string InsVisualizador(string pCodiEmex, string pCodiEmpr, string pCorrinst, string pCodiPers, string pCodiGrup, string pCodiSegm, string pTipoTaxo, string pSobr_arch)
    {
        return "execute SP_AX_InsVisualizador '" + pCodiEmex + "','" + pCodiEmpr + "','" + pCorrinst + "','" + pCodiPers + "','" + pCodiGrup + "','" + pCodiSegm + "', '" + pTipoTaxo + "', '" + pSobr_arch + "'";
    }
    public string[] getCodiInfoTipo(string pCodiInfo)
    {
        string[] vCTInfo = new string[2];
        vCTInfo[0] = pCodiInfo.Substring(0, pCodiInfo.IndexOf("|"));
        vCTInfo[1] = pCodiInfo.Substring(pCodiInfo.IndexOf("|") + 1, 1);
        return vCTInfo;
    }
    public string getEmpresasDocumentosPorColumna(string CodiEmex, string CodiEmpr, string CorrInst, string DescPers, string Grupo, string Segmento, string Tipo, string NombDocu, string MaxiVers)
    {
        return "execute SP_AX_getArchivosPorGrupoSegmento " + CodiEmex + "," + CodiEmpr + "," + CorrInst + ",'" + DescPers + "','" + Grupo + "','" + Segmento + "','" + Tipo + "','" + NombDocu + "'," + MaxiVers;
    }
    /// <summary>
    /// Obtiene los informes de las empresas por usuario (se usa para empresas externas)
    /// </summary>
    public string getEmpresasDocumentosPorColumna(string CodiEmex, string CodiEmpr, string CorrInst, string DescPers, string Grupo, string Segmento, string Tipo, string NombDocu, string MaxiVers, string UsuaCarga)
    {
        return "execute SP_AX_getArchivosPorGrupoSegmento " + CodiEmex + "," + CodiEmpr + "," + CorrInst + ",'" + DescPers + "','" + Grupo + "','" + Segmento + "','" + Tipo + "','" + NombDocu + "'," + MaxiVers + ",'" + UsuaCarga + "'";
    }
    public string GetArchivosXBRLExt(string codi_pers, string corr_inst, string pNombArch, string pUsuaCarg)
    {
        return "execute SP_AX_getArchivosXbrlExte '" + codi_pers + "','" + corr_inst + "','" + pNombArch + "','" + pUsuaCarg + "'";
    }

    public DataTable GenerateTransposedTable(DataTable inputTable)
    {
        DataTable outputTable = new DataTable();
        try
        {
            // Add columns by looping rows

            // Header row's first column is same as in inputTable
            outputTable.Columns.Add("desc_conc");

            // Header row's second column onwards, 'inputTable's first column taken

            for (int i = 1; i < inputTable.Rows.Count; i++)
            {
                // string newColName = inRow[0].ToString();
                outputTable.Columns.Add();
            }

            // Add rows by looping columns        
            for (int rCount = 0; rCount < inputTable.Columns.Count; rCount++)
            {
                DataRow newRow = outputTable.NewRow();

                // First column is inputTable's Header row's second column
                newRow[0] = inputTable.Columns[rCount].ColumnName.ToString();
                for (int cCount = 0; cCount <= inputTable.Rows.Count - 1; cCount++)
                {
                    string colValue = inputTable.Rows[cCount][rCount].ToString();
                    newRow[cCount] = colValue;
                }
                outputTable.Rows.Add(newRow);
            }
        }
        catch (Exception ex)
        {
            Log.putLog(ex.Message);

        }
        return outputTable;
    }
}