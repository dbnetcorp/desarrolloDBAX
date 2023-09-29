using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Data;
using System.Xml;
using System.IO.Compression;
using DBNeT.DBAX.Controlador;
using System.Collections;
using System.Xml.Linq;
using System.Security.Cryptography;

public partial class GuardarXBRL
{
    Conexion con = new Conexion().CrearInstancia();
    ComparacionXBRL vComp = new ComparacionXBRL();
    GeneradorGrupo grup = new GeneradorGrupo();
    GeneracionHTML genHtml = new GeneracionHTML();
    MantencionParametros para = new MantencionParametros();
    GeneracionExcel Empresas = new GeneracionExcel();
    MantencionIndicadores vMantIndi = new MantencionIndicadores();
    static string nArchivo = "";
    XmlDocument xShell = new XmlDocument();
    XmlDocument xLabel = new XmlDocument();
    XmlDocument xDime = new XmlDocument();
    List<XmlDocument> xInfo = new List<XmlDocument>();
    List<XmlDocument> LDocuXml;
    Correo correo = new Correo();
    int ciclo = 0;
    private static string vVersTaxoCol = "";
 
    private void setVersTaxoCol(string vers)
    {
        vVersTaxoCol = vers;
    }

    public string getVersTaxoCol()
    {
        return vVersTaxoCol;
    }

    public void LeerXBRL(XmlDocument xDoc, string vRutEmpr, string vPeriInfo, string vInstVers, string vFolder,string vFile)
    {
        try
        {
            string vCorrConc, nodoShell, nodoLink, nodoImport, nodoXbrl, nodoUnidades, nodoContextos, nodoInstant, nodoStartDate, nodoEndDate, nodoScenario, nodoPeriodo, nodoMeasure;
            int vCountBloque = 0;
            int vCorrBloque = 0;
            DataSet dsInfo;

            List<cCntxStnd> lCntxHash = new List<cCntxStnd>();

            #region CARGA NODOS

            nodoShell = "schema";
            nodoXbrl = "xbrli:xbrl";
            if (xDoc.GetElementsByTagName(nodoXbrl).Count == 0)
            {
                nodoXbrl = "xbrl";
            }
            XmlNodeList xbrl = xDoc.GetElementsByTagName(nodoXbrl);


            nodoUnidades = "xbrli:unit";
            if (xDoc.GetElementsByTagName(nodoUnidades).Count == 0)
            {
                nodoUnidades = "unit";
            }

            nodoContextos = "xbrli:context";
            if (xDoc.GetElementsByTagName(nodoContextos).Count == 0)
            {
                nodoContextos = "context";
            }


            nodoInstant = "xbrli:instant";
            if (xDoc.GetElementsByTagName(nodoInstant).Count == 0)
            {
                nodoInstant = "instant";
            }

            nodoStartDate = "xbrli:startDate";
            if (xDoc.GetElementsByTagName(nodoStartDate).Count == 0)
            {
                nodoStartDate = "startDate";
            }

            nodoEndDate = "xbrli:endDate";
            if (xDoc.GetElementsByTagName(nodoEndDate).Count == 0)
            {
                nodoEndDate = "endDate";
            }

            nodoScenario = "xbrli:scenario";
            if (xDoc.GetElementsByTagName(nodoScenario).Count == 0)
            {
                nodoScenario = "scenario";
            }

            nodoPeriodo = "xbrli:period";
            if (xDoc.GetElementsByTagName(nodoPeriodo).Count == 0)
            {
                nodoPeriodo = "period";
            }

            nodoMeasure = "xbrli:measure";
            if (xDoc.GetElementsByTagName(nodoMeasure).Count == 0)
            {
                nodoMeasure = "measure";
            }

            nodoLink = "link:schemaRef";
            nodoImport = "import";


            //if (xbrl.Count == 0)
            //{
            //    nodoXbrl = "xbrl";
            //    nodoUnidades = "unit";
            //    nodoContextos = "context";
            //    nodoInstant = "instant";
            //    nodoStartDate = "startDate";
            //    nodoEndDate = "endDate";
            //    nodoScenario = "scenario";
            //    nodoPeriodo = "period";
            //    nodoMeasure = "measure";

            //    xbrl = xDoc.GetElementsByTagName(nodoXbrl);
            //}
            #endregion
            #region CARGA INFORMES
            Log.putLog("Cargando Informes");
            List<string> vListInfo = new List<string>();
            GetDocuXml(nodoImport);
            if (xInfo.Count == 0)
            {
                nodoImport = "xsd:import";
                GetDocuXml(nodoImport);
            }

            if (xInfo.Count == 0)
            {
                nodoImport = "link:schemaRef";
                GetDocuXml(nodoLink);
            }
            foreach (XmlDocument info in xInfo)
            {
                XmlNodeList links = info.GetElementsByTagName(nodoImport);
                foreach (XmlElement link in links)
                {
                    string vlink = link.GetAttribute("xlink:href");
                    dsInfo = con.TraerResultados0(vComp.GetEsquemaInforme(vlink));
                    foreach (DataRow row in dsInfo.Tables[0].Rows)
                    {
                        con.EjecutarQuery(vComp.InsertInformeInstancia(vRutEmpr, vPeriInfo, vInstVers, row[0].ToString()));
                        vListInfo.Add(row[0].ToString());
                    }

                    dsInfo = con.TraerResultados0(vComp.GetEsquemaInforme(link.GetAttribute("schemaLocation")));
                    foreach (DataRow row in dsInfo.Tables[0].Rows)
                    {
                        con.EjecutarQuery(vComp.InsertInformeInstancia(vRutEmpr, vPeriInfo, vInstVers, row[0].ToString()));
                        vListInfo.Add(row[0].ToString());
                    }

                    if (vlink.Contains("https://www.superfinanciera.gov.co/xbrl/ifrs/") || vlink.Contains("http://www.sui.gov.co/xbrl/ifrs/"))
                    {
                        setVersTaxoCol(con.StringEjecutarQuery(vComp.getTaxoPorUbic(vlink)));
                        con.EjecutarQuery(vComp.insertInformesColombia(vRutEmpr, vPeriInfo, vInstVers, vlink));
                    }
                }
            }
            #endregion
            #region CARGA DE CONTEXTOS
            vCountBloque = 0;
            Log.putLog("Cargando Contextos");
            string vPrefMiemb;
            XmlNodeList contextos = ((XmlElement)xbrl[0]).GetElementsByTagName(nodoContextos);
            //int contador = 0;

            foreach (XmlElement contexto in contextos)
            {
                vCountBloque++;
                string vCodiCntx = contexto.GetAttribute("id").ToString();

                //if (vCodiCntx == "c825aY1_ActivosFinancierosCostoAmortizadoMiembro" || vCodiCntx == "c825aY1_InversionesSegurosCUIMiembro")
                //{
                // Console.WriteLine(contador + ": " +vCodiCntx);
                //}

                List<cEjesMiemb> lEjesMiemb = new List<cEjesMiemb>();
                string sFechIni = "", sFechFin = "";

                try
                {
                    vComp.setBloqueContextos(vRutEmpr, vPeriInfo, vInstVers, vCodiCntx);
                }
                catch
                {
                    Log.enviarCorreo("Ocurrio un error cargando contexto " + vCodiCntx + " en " + vRutEmpr + ", " + vPeriInfo + ", " + vInstVers + ", " + vFolder);
                    throw new ArgumentException("Error cargando contexto: " + vCodiCntx + " ");
                }
                XmlNodeList periodo = contexto.GetElementsByTagName(nodoPeriodo);
                foreach (XmlElement fecha in periodo)
                {
                    if (fecha.ChildNodes.Count == 1)
                    {
                        sFechIni = fecha.GetElementsByTagName(nodoInstant).Item(0).InnerText.ToString();
                        vComp.setBloqueUpdateContextoInstant(sFechIni, vRutEmpr, vPeriInfo, vInstVers, vCodiCntx);
                    }
                    else
                    {
                        sFechIni = fecha.GetElementsByTagName(nodoStartDate).Item(0).InnerText.ToString();
                        sFechFin = fecha.GetElementsByTagName(nodoEndDate).Item(0).InnerText.ToString();
                        vComp.setBloqueUpdateContextoPeriod(sFechIni, sFechFin, vRutEmpr, vPeriInfo, vInstVers, vCodiCntx);
                    }
                }

                XmlNodeList scenario = contexto.GetElementsByTagName(nodoScenario);
                foreach (XmlElement miembros in scenario)
                {
                    for (int i = 0; i < miembros.ChildNodes.Count; i++)
                    {
                        string vDimension, vMiembro;

                        try
                        {
                            vDimension = miembros.GetElementsByTagName("xbrldi:explicitMember").Item(i).Attributes.GetNamedItem("dimension").Value.ToString();
                            vMiembro = miembros.GetElementsByTagName("xbrldi:explicitMember").Item(i).InnerText.ToString();
                        }
                        catch
                        {
                            vDimension = miembros.GetElementsByTagName("explicitMember").Item(i).Attributes.GetNamedItem("dimension").Value.ToString();
                            vMiembro = miembros.GetElementsByTagName("explicitMember").Item(i).InnerText.ToString();
                        }

                        //Se asegura que el prefijo del miembro variable sea tx
                        vPrefMiemb = para.getPreFijo(vMiembro, ":") + ":";
                        if (vPrefMiemb.Contains("tx"))
                            vMiembro = vMiembro.Replace(vPrefMiemb, "tx:");
                        // vEjeMiem.Add(vMiembro, vDimension);
                        try
                        {
                            cEjesMiemb vEjeMemb = new cEjesMiemb();
                            vEjeMemb.CODI_AXIS = vDimension;
                            vEjeMemb.CODI_MEMB = vMiembro;
                            lEjesMiemb.Add(vEjeMemb);

                            vComp.setBloqueInsertInstDicx(vRutEmpr, vPeriInfo, vInstVers, vCodiCntx, vDimension, vMiembro);
                        }
                        catch (Exception ex)
                        {
                            throw new ArgumentException("Error cargando contexto: " + vCodiCntx + " ");
                        }
                    }
                }

                string sHashContexto = HashAtributos(lEjesMiemb, sFechIni, sFechFin);
                cCntxStnd vCntxStnd = new cCntxStnd();
                vCntxStnd.CNTX_STND = sHashContexto;
                vCntxStnd.CODI_CNTX = vCodiCntx;

                lCntxHash.Add(vCntxStnd);

                //insertar
                if (vCountBloque > 900)
                {
                    con.EjecutarQuery(vComp.getBloqueContextos());
                    vCountBloque = 0;
                }

                //contador++;
            }//Fin contexto

            if (vCountBloque > 0)
            {
                con.EjecutarQuery(vComp.getBloqueContextos());
                vCountBloque = 0;
            }

            #endregion
            InsertarMiembrosVariables(vRutEmpr, vPeriInfo, vInstVers, vListInfo);
            // con.EjecutarQuery(vComp.InsertInstDicx(vRutEmpr, vPeriInfo, vInstVers, vCodiCntx, vDimension, vMiembro, vMiembroDesc));
            #region CARGA UNIDADES
            Log.putLog("Cargando Unidades");
            XmlNodeList unidades = ((XmlElement)xbrl[0]).GetElementsByTagName(nodoUnidades);
            foreach (XmlElement unidad in unidades)
            {
                string vCodiUnit = unidad.GetAttribute("id").ToString();
                con.EjecutarQuery(vComp.InsertInstUnit(vRutEmpr, vPeriInfo, vInstVers, vCodiUnit));
                XmlNodeList periodo = unidad.GetElementsByTagName(nodoMeasure);
                if (periodo.Count == 0)
                {
                    nodoMeasure = "measure";
                    periodo = unidad.GetElementsByTagName(nodoMeasure);
                }
                con.EjecutarQuery(vComp.UpdateInstUnit(periodo[0].InnerText.ToString(), vRutEmpr, vPeriInfo, vInstVers, vCodiUnit));

            }//Fin unidad
            #endregion
            #region CARGA CONCEPTOS
            vCountBloque = 0;
            Log.putLog("Cargando Conceptos");
            Console.WriteLine("Cargando Conceptos");
            // XDocument cpo = XDocument.Load(vFile);
            //XNamespace aw = "http://www.svs.cl/cl/fr/cs/2014-06-15";
            // XNamespace aw1 = "http://xbrl.ifrs.org/taxonomy/2013-03-28/ifrs";
            //   IEnumerable<XElement> awElements =
            //from el in cpo.Descendants()
            //where el.Name.Namespace == aw
            //select el;
            XmlNodeList conceptos = ((XmlElement)xbrl[0]).ChildNodes;
            List<string> LPrefConc = (from row in vMantIndi.getPrefConc().AsEnumerable() select row["pref_conc"].ToString()).ToList();

            vCorrBloque = Convert.ToInt32(con.StringEjecutarQuery(vComp.GetCorrConc(vRutEmpr, vPeriInfo, vInstVers)));

            foreach (XmlElement concepto in conceptos.OfType<XmlElement>())
            //foreach (XElement concepto in awElements)
            {
                string valor = "", vPrefFijo, vUnitRef;
                try
                {
                    //if (concepto.Prefix == "cl-ci" || concepto.Prefix == "ifrs" || concepto.Prefix == "cl-cs" || concepto.Prefix == "cl-hb" || concepto.Prefix == "cl-hs")
                    if (LPrefConc.Contains(concepto.Prefix))
                    {
                        
                        //  vPrefFijo = concepto.GetPrefixOfNamespace(concepto.Name.Namespace);

                        /*try
                        {
                            vUnitRef = concepto.Attribute("unitRef").Value;
                         }
                         catch
                         {
                             vUnitRef = "";
                         }*/

                        vCorrBloque++;
                        vCountBloque++;

                        valor = concepto.InnerText;
                        if (concepto.InnerText.Length > 5000)
                        {
                            vComp.setBloqueConceptos(vCorrBloque, vRutEmpr, vPeriInfo, vInstVers, concepto.Prefix.ToString(), concepto.Name.Substring(concepto.Name.LastIndexOf(":") + 1), concepto.GetAttribute("contextRef").ToString(), "###", concepto.GetAttribute("unitRef"), lCntxHash.Where(x => x.CODI_CNTX == concepto.GetAttribute("contextRef").ToString()).ToList()[0].CNTX_STND.ToString());
                            vComp.setBloqueConceptosGrandes(vCorrBloque, vRutEmpr, vPeriInfo, vInstVers, valor.Replace("'", "''"));
                        }
                        else
                        {
                            vComp.setBloqueConceptos(vCorrBloque, vRutEmpr, vPeriInfo, vInstVers, concepto.Prefix.ToString(), concepto.Name.Substring(concepto.Name.LastIndexOf(":") + 1), concepto.GetAttribute("contextRef").ToString(), valor.Replace("'", "''"), concepto.GetAttribute("unitRef"), lCntxHash.Where(x => x.CODI_CNTX == concepto.GetAttribute("contextRef").ToString()).ToList()[0].CNTX_STND.ToString());
                        }

                        if (vCountBloque > 900)
                        {
                            con.EjecutarQuery(vComp.getBloqueConceptos());
                            vCountBloque = 0;
                        }
                    }
                }
                catch
                {
                    Log.enviarCorreo("Ocurrió un error cargando un concepto " + vRutEmpr + ", " + vPeriInfo + ", " + vInstVers + ", " + concepto.Prefix.ToString() + ", " + concepto.Name.Substring(concepto.Name.LastIndexOf(":") + 1) + ", " + concepto.GetAttribute("contextRef").ToString() + ", " + valor.Replace("'", "''") + ", " + concepto.GetAttribute("unitRef"));
                    throw new System.Exception("Ocurrió un error cargando un concepto " + vRutEmpr + ", " + vPeriInfo + ", " + vInstVers + ", " + concepto.Prefix.ToString() + ", " + concepto.Name.Substring(concepto.Name.LastIndexOf(":") + 1) + ", " + concepto.GetAttribute("contextRef").ToString() + ", " + valor.Replace("'", "''") + ", " + concepto.GetAttribute("unitRef"));
                };
            }

            if (vCountBloque > 0)
            {
                con.EjecutarQuery(vComp.getBloqueConceptos());
                vCountBloque = 0;
            }

            Console.WriteLine(DateTime.Now + " Termina Cargando Conceptos");

            #endregion

            Console.WriteLine(DateTime.Now + " Eliminando contextos vacios");
            con.EjecutarQuery(vComp.delContextosNoUsados(vRutEmpr, vPeriInfo, vInstVers));
        }
        catch (Exception ex)
        {
            string sSujeto = "Problema cargando xbrl " + vRutEmpr + ", " + vPeriInfo + vInstVers;
            string sMensaje = "Al cargar el archivo " + vFile + " se detectaron los siguientes errores " +
                                ex.Message + " " +
                                ex.StackTrace + " " +
                                ex.Data + " " +
                                ex.InnerException;
            correo.enviarCorreo(sSujeto, sMensaje);
        }
   }
    public void LeerXBRLSonda(XmlDocument xDoc, string vRutEmpr, string vPeriInfo, string vInstVers, string vFolder, string vFile)
    {
        try
        {
            string vCorrConc, nodoShell, nodoLink, nodoImport, nodoXbrl, nodoUnidades, nodoContextos, nodoInstant, nodoStartDate, nodoEndDate, nodoScenario, nodoPeriodo, nodoMeasure;
            int vCountBloque = 0;
            int vCorrBloque = 0;
            DataSet dsInfo;

            List<cCntxStnd> lCntxHash = new List<cCntxStnd>();

            #region CARGA NODOS

            nodoShell = "schema";
            nodoXbrl = "xbrli:xbrl";
            if (xDoc.GetElementsByTagName(nodoXbrl).Count == 0)
            {
                nodoXbrl = "xbrl";
            }
            XmlNodeList xbrl = xDoc.GetElementsByTagName(nodoXbrl);


            nodoUnidades = "xbrli:unit";
            if (xDoc.GetElementsByTagName(nodoUnidades).Count == 0)
            {
                nodoUnidades = "unit";
            }

            nodoContextos = "xbrli:context";
            if (xDoc.GetElementsByTagName(nodoContextos).Count == 0)
            {
                nodoContextos = "context";
            }


            nodoInstant = "xbrli:instant";
            if (xDoc.GetElementsByTagName(nodoInstant).Count == 0)
            {
                nodoInstant = "instant";
            }

            nodoStartDate = "xbrli:startDate";
            if (xDoc.GetElementsByTagName(nodoStartDate).Count == 0)
            {
                nodoStartDate = "startDate";
            }

            nodoEndDate = "xbrli:endDate";
            if (xDoc.GetElementsByTagName(nodoEndDate).Count == 0)
            {
                nodoEndDate = "endDate";
            }

            nodoScenario = "xbrli:scenario";
            if (xDoc.GetElementsByTagName(nodoScenario).Count == 0)
            {
                nodoScenario = "scenario";
            }

            nodoPeriodo = "xbrli:period";
            if (xDoc.GetElementsByTagName(nodoPeriodo).Count == 0)
            {
                nodoPeriodo = "period";
            }

            nodoMeasure = "xbrli:measure";
            if (xDoc.GetElementsByTagName(nodoMeasure).Count == 0)
            {
                nodoMeasure = "measure";
            }

            nodoLink = "link:schemaRef";
            nodoImport = "import";


            //if (xbrl.Count == 0)
            //{
            //    nodoXbrl = "xbrl";
            //    nodoUnidades = "unit";
            //    nodoContextos = "context";
            //    nodoInstant = "instant";
            //    nodoStartDate = "startDate";
            //    nodoEndDate = "endDate";
            //    nodoScenario = "scenario";
            //    nodoPeriodo = "period";
            //    nodoMeasure = "measure";

            //    xbrl = xDoc.GetElementsByTagName(nodoXbrl);
            //}
            #endregion
            #region CARGA INFORMES
            Log.putLog("Cargando Informes");
            List<string> vListInfo = new List<string>();
            GetDocuXml(nodoImport);
            if (xInfo.Count == 0)
            {
                nodoImport = "xsd:import";
                GetDocuXml(nodoImport);
            }

            if (xInfo.Count == 0)
            {
                nodoImport = "link:schemaRef";
                GetDocuXml(nodoLink);
            }
            foreach (XmlDocument info in xInfo)
            {
                XmlNodeList links = info.GetElementsByTagName(nodoImport);
                foreach (XmlElement link in links)
                {
                    string vlink = link.GetAttribute("xlink:href");
                    dsInfo = con.TraerResultados0(vComp.GetEsquemaInforme(vlink));
                    foreach (DataRow row in dsInfo.Tables[0].Rows)
                    {
                        con.EjecutarQuery(vComp.InsertInformeInstancia(vRutEmpr, vPeriInfo, vInstVers, row[0].ToString()));
                        vListInfo.Add(row[0].ToString());
                    }

                    dsInfo = con.TraerResultados0(vComp.GetEsquemaInforme(link.GetAttribute("schemaLocation")));
                    foreach (DataRow row in dsInfo.Tables[0].Rows)
                    {
                        con.EjecutarQuery(vComp.InsertInformeInstancia(vRutEmpr, vPeriInfo, vInstVers, row[0].ToString()));
                        vListInfo.Add(row[0].ToString());
                    }

                    if (vlink.Contains("https://www.superfinanciera.gov.co/xbrl/ifrs/") || vlink.Contains("http://www.sui.gov.co/xbrl/ifrs/"))
                    {
                        con.EjecutarQuery(vComp.insertInformesColombia(vRutEmpr, vPeriInfo, vInstVers, vlink));
                    }
                }
            }
            #endregion

            #region CARGA DE CONTEXTOS
            vCountBloque = 0;
            Log.putLog("Cargando Contextos");
            string vPrefMiemb;
            XmlNodeList contextos = ((XmlElement)xbrl[0]).GetElementsByTagName(nodoContextos);

            foreach (XmlElement contexto in contextos)
            {
                vCountBloque++;

                string vCodiCntx = GetMd5Hash(contexto.GetAttribute("id").ToString());

                List<cEjesMiemb> lEjesMiemb = new List<cEjesMiemb>();
                string sFechIni = "", sFechFin = "";

                try
                {
                    vComp.setBloqueContextos(vRutEmpr, vPeriInfo, vInstVers, vCodiCntx);
                }
                catch
                {
                    Log.enviarCorreo("Ocurrio un error cargando contexto " + vCodiCntx + " en " + vRutEmpr + ", " + vPeriInfo + ", " + vInstVers + ", " + vFolder);
                    throw new ArgumentException("Error cargando contexto: " + vCodiCntx + " ");
                }
                XmlNodeList periodo = contexto.GetElementsByTagName(nodoPeriodo);
                foreach (XmlElement fecha in periodo)
                {
                    if (fecha.ChildNodes.Count == 1)
                    {
                        sFechIni = fecha.GetElementsByTagName(nodoInstant).Item(0).InnerText.ToString();
                        vComp.setBloqueUpdateContextoInstant(sFechIni, vRutEmpr, vPeriInfo, vInstVers, vCodiCntx);
                    }
                    else
                    {
                        sFechIni = fecha.GetElementsByTagName(nodoStartDate).Item(0).InnerText.ToString();
                        sFechFin = fecha.GetElementsByTagName(nodoEndDate).Item(0).InnerText.ToString();
                        vComp.setBloqueUpdateContextoPeriod(sFechIni, sFechFin, vRutEmpr, vPeriInfo, vInstVers, vCodiCntx);
                    }
                }
                XmlNodeList scenario = contexto.GetElementsByTagName(nodoScenario);
                foreach (XmlElement miembros in scenario)
                {
                    for (int i = 0; i < miembros.ChildNodes.Count; i++)
                    {
                        string vDimension, vMiembro;

                        try
                        {
                            vDimension = miembros.GetElementsByTagName("xbrldi:explicitMember").Item(i).Attributes.GetNamedItem("dimension").Value.ToString();
                            vMiembro = miembros.GetElementsByTagName("xbrldi:explicitMember").Item(i).InnerText.ToString();
                        }
                        catch
                        {
                            vDimension = miembros.GetElementsByTagName("explicitMember").Item(i).Attributes.GetNamedItem("dimension").Value.ToString();
                            vMiembro = miembros.GetElementsByTagName("explicitMember").Item(i).InnerText.ToString();

                        }
                        //Se asegura que el prefijo del miembro variable sea tx
                        vPrefMiemb = para.getPreFijo(vMiembro, ":") + ":";
                        if (vPrefMiemb.Contains("tx"))
                            vMiembro = vMiembro.Replace(vPrefMiemb, "tx:");
                        // vEjeMiem.Add(vMiembro, vDimension);
                        try
                        {
                            cEjesMiemb vEjeMemb = new cEjesMiemb();
                            vEjeMemb.CODI_AXIS = vDimension;
                            vEjeMemb.CODI_MEMB = vMiembro;
                            lEjesMiemb.Add(vEjeMemb);

                            vComp.setBloqueInsertInstDicx(vRutEmpr, vPeriInfo, vInstVers, vCodiCntx, vDimension, vMiembro);
                        }
                        catch (Exception ex)
                        {
                            throw new ArgumentException("Error cargando contexto: " + vCodiCntx + " ");
                        }
                    }
                }

                string sHashContexto = HashAtributos(lEjesMiemb, sFechIni, sFechFin);
                cCntxStnd vCntxStnd = new cCntxStnd();
                vCntxStnd.CNTX_STND = sHashContexto;
                vCntxStnd.CODI_CNTX = contexto.GetAttribute("id").ToString();

                lCntxHash.Add(vCntxStnd);

                //insertar
                if (vCountBloque > 900)
                {
                    con.EjecutarQuery(vComp.getBloqueContextos());
                    vCountBloque = 0;
                }
            }//Fin contexto

            if (vCountBloque > 0)
            {
                con.EjecutarQuery(vComp.getBloqueContextos());
                vCountBloque = 0;
            }

            #endregion
            InsertarMiembrosVariables(vRutEmpr, vPeriInfo, vInstVers, vListInfo);
            // con.EjecutarQuery(vComp.InsertInstDicx(vRutEmpr, vPeriInfo, vInstVers, vCodiCntx, vDimension, vMiembro, vMiembroDesc));
            #region CARGA UNIDADES
            Log.putLog("Cargando Unidades");
            XmlNodeList unidades = ((XmlElement)xbrl[0]).GetElementsByTagName(nodoUnidades);
            foreach (XmlElement unidad in unidades)
            {
                string vCodiUnit = unidad.GetAttribute("id").ToString();
                con.EjecutarQuery(vComp.InsertInstUnit(vRutEmpr, vPeriInfo, vInstVers, vCodiUnit));
                XmlNodeList periodo = unidad.GetElementsByTagName(nodoMeasure);
                if (periodo.Count == 0)
                {
                    nodoMeasure = "measure";
                    periodo = unidad.GetElementsByTagName(nodoMeasure);
                }
                con.EjecutarQuery(vComp.UpdateInstUnit(periodo[0].InnerText.ToString(), vRutEmpr, vPeriInfo, vInstVers, vCodiUnit));

            }//Fin unidad
            #endregion
            #region CARGA CONCEPTOS
            vCountBloque = 0;
            Log.putLog("Cargando Conceptos");
            Console.WriteLine("Cargando Conceptos");
            // XDocument cpo = XDocument.Load(vFile);
            //XNamespace aw = "http://www.svs.cl/cl/fr/cs/2014-06-15";
            // XNamespace aw1 = "http://xbrl.ifrs.org/taxonomy/2013-03-28/ifrs";
            //   IEnumerable<XElement> awElements =
            //from el in cpo.Descendants()
            //where el.Name.Namespace == aw
            //select el;
            XmlNodeList conceptos = ((XmlElement)xbrl[0]).ChildNodes;
            List<string> LPrefConc = (from row in vMantIndi.getPrefConc().AsEnumerable() select row["pref_conc"].ToString()).ToList();

            vCorrBloque = Convert.ToInt32(con.StringEjecutarQuery(vComp.GetCorrConc(vRutEmpr, vPeriInfo, vInstVers)));

            foreach (XmlElement concepto in conceptos.OfType<XmlElement>())
            //foreach (XElement concepto in awElements)
            {
                //if (concepto.Prefix == "cl-ci" || concepto.Prefix == "ifrs" || concepto.Prefix == "cl-cs" || concepto.Prefix == "cl-hb" || concepto.Prefix == "cl-hs")
                if (LPrefConc.Contains(concepto.Prefix))
                {
                    string valor = "", vPrefFijo, vUnitRef;
                    //  vPrefFijo = concepto.GetPrefixOfNamespace(concepto.Name.Namespace);

                    /*try
                    {
                        vUnitRef = concepto.Attribute("unitRef").Value;
                     }
                     catch
                     {
                         vUnitRef = "";
                     }*/

                    vCorrBloque++;
                    vCountBloque++;

                    if (concepto.InnerText.Length > 5000)
                    {
                        valor = concepto.InnerText;

                        vComp.setBloqueConceptos(vCorrBloque, vRutEmpr, vPeriInfo, vInstVers, concepto.Prefix.ToString(), concepto.Name.Substring(concepto.Name.LastIndexOf(":") + 1), GetMd5Hash(concepto.GetAttribute("contextRef").ToString()), "###", concepto.GetAttribute("unitRef"), lCntxHash.Where(x => x.CODI_CNTX == concepto.GetAttribute("contextRef").ToString()).ToList()[0].CNTX_STND);
                        vComp.setBloqueConceptosGrandes(vCorrBloque, vRutEmpr, vPeriInfo, vInstVers, valor.Replace("'", "''"));


                        //con.EjecutarQuery(vComp.InsertConceptoInstancia(vRutEmpr, vPeriInfo, vInstVers, concepto.Prefix.ToString(), concepto.Name.Substring(concepto.Name.LastIndexOf(":") + 1), concepto.GetAttribute("contextRef").ToString(), "###", concepto.GetAttribute("unitRef")));

                        //con.EjecutarQuery(vComp.InsertConceptoClobInstancia(vCorrConc, vRutEmpr, vPeriInfo, vInstVers, valor.Replace("'", "''")));
                    }
                    else
                    {
                        valor = concepto.InnerText;
                        //valor = concepto.Value;

                        try
                        {
                            vComp.setBloqueConceptos(vCorrBloque, vRutEmpr, vPeriInfo, vInstVers, concepto.Prefix.ToString(), concepto.Name.Substring(concepto.Name.LastIndexOf(":") + 1), GetMd5Hash(concepto.GetAttribute("contextRef").ToString()), valor.Replace("'", "''"), concepto.GetAttribute("unitRef"), lCntxHash.Where(x => x.CODI_CNTX == concepto.GetAttribute("contextRef").ToString()).ToList()[0].CNTX_STND);
                            // con.EjecutarQuery(vComp.InsertConceptoInstancia(vRutEmpr, vPeriInfo, vInstVers, vPrefFijo, concepto.Name.LocalName, concepto.Attribute("contextRef").Value, valor.Replace("'", "''"), vUnitRef));
                        }
                        catch
                        {
                            Log.enviarCorreo("Ocurrió un error cargando un concepto " + vRutEmpr + ", " + vPeriInfo + ", " + vInstVers + ", " + concepto.Prefix.ToString() + ", " + concepto.Name.Substring(concepto.Name.LastIndexOf(":") + 1) + ", " + concepto.GetAttribute("contextRef").ToString() + ", " + valor.Replace("'", "''") + ", " + concepto.GetAttribute("unitRef"));
                            throw new System.Exception("Ocurrió un error cargando un concepto " + vRutEmpr + ", " + vPeriInfo + ", " + vInstVers + ", " + concepto.Prefix.ToString() + ", " + concepto.Name.Substring(concepto.Name.LastIndexOf(":") + 1) + ", " + concepto.GetAttribute("contextRef").ToString() + ", " + valor.Replace("'", "''") + ", " + concepto.GetAttribute("unitRef"));
                        };
                    }

                    if (vCountBloque > 900)
                    {
                        con.EjecutarQuery(vComp.getBloqueConceptos());
                        vCountBloque = 0;
                    }
                }
            }

            if (vCountBloque > 0)
            {
                con.EjecutarQuery(vComp.getBloqueConceptos());
                vCountBloque = 0;
            }

            Console.WriteLine(DateTime.Now + " Termina Cargando Conceptos");

            #endregion

            Console.WriteLine(DateTime.Now + " Eliminando contextos vacios");
            con.EjecutarQuery(vComp.delContextosNoUsados(vRutEmpr, vPeriInfo, vInstVers));
        }
        catch (Exception ex)
        {
            string sSujeto = "Problema cargando xbrl (SONDA) " + vRutEmpr + ", " + vPeriInfo + vInstVers;
            string sMensaje = "Al cargar el archivo " + vFile + " se detectaron los siguientes errores " +
                                ex.Message + " " +
                                ex.StackTrace + " " +
                                ex.Data + " " +
                                ex.InnerException;
            correo.enviarCorreo(sSujeto, sMensaje);
        }
    }
    public string ObtieneRutDeXBRL(XmlDocument xDoc)
    {
        string nodoXbrl = "xbrli:xbrl";
        string vRut="", vPais = "";

        vPais = para.getPaisXbrl();

        if (vPais == "COL")
        {
            if (xDoc.GetElementsByTagName(nodoXbrl).Count == 0)
            {
                nodoXbrl = "xbrl";
            }
            XmlNodeList xbrl = xDoc.GetElementsByTagName(nodoXbrl);
            vRut = ((XmlElement)xbrl[0]).GetElementsByTagName("co-sfc-core:NITEntidadinforma").Item(0).InnerText;
            vRut = vRut.Replace(".", "");

            if (vRut.Contains("-"))
            {
                vRut = vRut.Substring(0, vRut.IndexOf("-"));
            }

            return vRut;
        }
        else
        {
            return "";
        }
    }
    private void InsertarMiembrosVariables(string vRutEmpr, string vPeriInfo, string vInstVers, List<string> vListInfo)
    {
        try
        {
            Log.putLog("Cargando Miembros variables");
            List<string> LPrefConc;
            GetDocuXml("link:definitionLink");
            if (xInfo.Count() > 0)
            {
                xDime = xInfo[0];
                string vRoleUri, vCodiMemb = "", vPrefMemb = "", vMembVari, vPrefVari, vCodiMembComp, vMembVariComp;
                string vMiembroDesc = "";
                //string[] tt = vMiembro.Split(':');
                string idLoc = "", idLabel = "";
                int d;
                XmlNodeList nodeDefiLink = xDime.GetElementsByTagName("link:definitionLink");
                XmlNodeList nodeLinkLoc;
                LPrefConc = (from row in vMantIndi.getPrefConc().AsEnumerable() select row["pref_conc"].ToString()).ToList();
                foreach (XmlElement defiLink in nodeDefiLink)
                {
                    d = 0;
                    vRoleUri = defiLink.Attributes.GetNamedItem("xlink:role").Value;
                    nodeLinkLoc = defiLink.GetElementsByTagName("link:loc");
                    foreach (XmlElement linkloc in nodeLinkLoc)
                    {
                        if (!LPrefConc.Contains(para.getPreFijo(para.getPostFijo(linkloc.Attributes.GetNamedItem("xlink:href").Value.ToString(), "#"), "_")))
                        {
                            vMembVariComp = linkloc.Attributes.GetNamedItem("xlink:href").Value.ToString();
                            vMembVari = para.getPostFijo(para.getPostFijo(vMembVariComp, "#"), "_");
                            vPrefVari = para.getPreFijo(para.getPostFijo(vMembVariComp, "#"), "_");


                        }
                        else
                        {  //Obtengo Miembro papá
                            vCodiMembComp = linkloc.Attributes.GetNamedItem("xlink:href").Value.ToString();
                            vCodiMemb = para.getPostFijo(para.getPostFijo(vCodiMembComp, "#"), "_");
                            vPrefMemb = para.getPreFijo(para.getPostFijo(vCodiMembComp, "#"), "_");
                            d++;
                            continue;

                        }

                        GetDocuXml("link:labelLink");
                        if (xInfo.Count() > 0)
                        {
                            xLabel = xInfo[0];
                            XmlNodeList nodeLoc = xLabel.GetElementsByTagName("link:loc");
                            foreach (XmlElement lab in nodeLoc)
                            {
                                if (lab.Attributes.GetNamedItem("xlink:href").Value.Equals(vMembVariComp))
                                {
                                    idLoc = lab.Attributes.GetNamedItem("xlink:label").Value;
                                    break;
                                }
                            }

                            XmlNodeList nodelabelArc = xLabel.GetElementsByTagName("link:labelArc");
                            foreach (XmlElement lab in nodelabelArc)
                            {
                                if (lab.Attributes.GetNamedItem("xlink:from").Value.Equals(idLoc))
                                {
                                    idLabel = lab.Attributes.GetNamedItem("xlink:to").Value;
                                    break;
                                }
                            }

                            XmlNodeList nodeLabel = xLabel.GetElementsByTagName("link:label");
                            foreach (XmlElement lab in nodeLabel)
                            {
                                if (lab.Attributes.GetNamedItem("xlink:label").Value.Equals(idLabel))
                                {
                                    vMiembroDesc = lab.InnerText;

                                    break;
                                }
                            }
                        }
                        else
                            vMiembroDesc = vMembVari;

                        InsertMembVari(vRutEmpr, vPeriInfo, vInstVers, vPrefMemb, vCodiMemb, vPrefVari, vMembVari, vMiembroDesc, vRoleUri, vListInfo);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            string sSujeto = "Problema cargando xbrl " + vRutEmpr + ", " + vPeriInfo + vInstVers;
            string sMensaje = "Al cargar el archivo xbrl, en funcion InsertarMiembrosVariables, se detectaron los siguientes errores " +
                                ex.Message + " " +
                                ex.StackTrace + " " +
                                ex.Data + " " +
                                ex.InnerException;
            correo.enviarCorreo(sSujeto, sMensaje);
        }
    }
    private void InsertMembVari(string vRutEmpr, string vPeriInfo, string vInstVers, string vPrefMemb, string vCodiMemb, string vPrefVari, string vMembVari, string vMiembroDesc, string vRoleUri, List<string> vListInfo)
    {
        try
        {
            DataTable dtDimeDefi, dtAxismemb;
            int vOrdeVari;
            string vExisMiemb,vExisDime;
            vExisMiemb = con.StringEjecutarQuery(vComp.GetMiembroInstMemb(vRutEmpr, vPeriInfo, vInstVers, vPrefVari, vMembVari));
            if (vExisMiemb.Length < 1)
                con.EjecutarQuery(vComp.InseInstMemb(vRutEmpr, vPeriInfo, vInstVers, vPrefVari + ":" + vMembVari, vMiembroDesc));
            dtDimeDefi = con.TraerResultados0(vComp.GetDimeDefi(vRoleUri)).Tables[0];
            foreach (DataRow item in dtDimeDefi.Rows)
            {
                if (vListInfo.Contains(item["codi_dein"].ToString()))
                {
                    //sacar orden insertado

                    dtAxismemb = con.TraerResultados0(vComp.GetAxisMemb(vPrefMemb, vCodiMemb, item["pref_dime"].ToString(), item["codi_dime"].ToString(), item["codi_dein"].ToString())).Tables[0];
                    vOrdeVari = Convert.ToInt16(con.StringEjecutarQuery(vComp.GetOrdenMembVari(vRutEmpr, vPeriInfo, vInstVers, item["codi_dein"].ToString(), item["pref_dime"].ToString(), item["codi_dime"].ToString(), vPrefMemb, vCodiMemb)));
                    if (dtAxismemb.Rows.Count > 0)
                    {
                        if (vOrdeVari == 0)
                        {

                            vOrdeVari = Convert.ToInt16(dtAxismemb.Rows[0]["orde_memb"].ToString()) - 999;
                        }
                        else
                        {
                            vOrdeVari++;
                        }
                        vExisDime = con.StringEjecutarQuery(vComp.GetInstDimeVers(vRutEmpr, vPeriInfo, vInstVers, item["codi_dein"].ToString(), item["pref_dime"].ToString(), item["codi_dime"].ToString(), vPrefVari + ":" + vMembVari));
                        if (vExisDime.Length < 1)
                        {
                            con.EjecutarQuery(vComp.InseInstDime(vRutEmpr, vPeriInfo, vInstVers, item["codi_dein"].ToString(), item["pref_dime"].ToString(), item["codi_dime"].ToString(), item["letr_dime"].ToString(), dtAxismemb.Rows[0]["pref_axis"].ToString(), dtAxismemb.Rows[0]["codi_axis"].ToString(), vPrefVari + ":" + vMembVari, vOrdeVari.ToString(), vPrefMemb + ":" + vCodiMemb));
                        }
                    }
                    else
                    {
                        throw new Exception("No se encontró el miembro " + vPrefMemb + ", " + vCodiMemb + " en " + item["pref_dime"].ToString() + ", " + item["codi_dime"].ToString() + ", " + item["codi_dein"].ToString());
                    }
                    
                }
            }
        }
        catch (Exception ex)
        {
            Log.putLog(ex.Message);
            Log.putLog(" Ocurrio un error cargando en archivo " + vRutEmpr + "_" + vPeriInfo);
        }
    }
    private void GetDocuXml(string nodeDime)
    {
        try
        {
            XmlNodeList nodeXml;
            XmlDocument Xdoc = new XmlDocument();
            xInfo.Clear();
            foreach (XmlDocument item in LDocuXml)
            {
                nodeXml = item.GetElementsByTagName(nodeDime);
                if (nodeXml.Count > 0)
                    xInfo.Add(item);
            }
        }
        catch (Exception ex)
        {
            Log.putLog(ex.Message);
            string sMensaje = "Error en método getDocuXml:" +
                                ex.Message + " " +
                                ex.StackTrace + " " +
                                ex.Data + " " +
                                ex.InnerException;
            throw new Exception(sMensaje);
        }
      
    }
    private void CargarArchXml(string vFolder)
    {
        string[] Files;
        LDocuXml = new List<XmlDocument>();
        XmlDocument vFile;
        Files = Directory.GetFileSystemEntries(vFolder);
        foreach (string item in Files)
        {
            //if (Path.GetExtension(item) != ".zip" && Path.GetExtension(item)!=".pdf")
            if (Path.GetExtension(item) == ".xbrl" || Path.GetExtension(item) == ".xsd" || Path.GetExtension(item) == ".xml")
            {
                vFile = new XmlDocument();
                vFile.Load(item);
                LDocuXml.Add(vFile);
            }

           
        }
         
    }
    public string ValidaXBRL(string vXBRL, string vFolder) 
    {
        XmlDocument xDoc = new XmlDocument();
        try
        {
            xDoc.Load(vXBRL);
            return vXBRL;
        }
        catch
        {
            File.Delete(vXBRL.Replace(".xbrl", ".zip"));
            File.Move(vXBRL, vXBRL.Replace(".xbrl", ".zip"));
            if (ValidaYBorraArchivosVacios(vXBRL.Replace(".xbrl", ".zip")) == 0)
            {
                DescomprimeXBRL(vXBRL.Replace(".xbrl", ".zip"), vFolder);
                return (vXBRL.Replace(".xbrl", ".zip"));
            }
            else
            {
                Log.putLog("Archivo " + vXBRL.Replace(".xbrl", ".zip") + " aparentemente está vacio");
                return "-1";
            }
        }
    }
    private int ValidaYBorraArchivosVacios(string pArchivo)
    {
        FileInfo FileProp = new FileInfo(pArchivo);
        long FileLeng = FileProp.Length;
        if (FileLeng < 1000)
        {
            Console.WriteLine("Eliminando " + pArchivo);
            File.Delete(pArchivo);
            return 1;   //1 = se borro el archivo
        }
        return 0; //No se borro el archivo
    }
    public void RescataXBRLCargaInformes(string pCorrInst, string pCodiPers)
    {
        List<string> vCorrInst = new List<string>(); 
        List<string> vCodiPers = new List<string>(); 
        if (!pCorrInst.Equals(string.Empty))
        {
            vCorrInst.Add(pCorrInst);
        }
        else
        {
            Console.WriteLine("Hacer un ciclo incluyendo todos los periodos");
        }

        if (!pCodiPers.Equals(string.Empty))
        {
            vCodiPers.Add(pCodiPers);
        }
        else
        {
            Console.WriteLine("Hacer un ciclo incluyendo todas las empresas");
        }

        string vPathBackEnd = "";
        try
        {
            Microsoft.Win32.RegistryKey key = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("Software\\DBNeT\\Prisma\\CHL", false);
            vPathBackEnd = key.GetValue("pathBackEnd").ToString();
        }
        catch
        {
            vPathBackEnd = "C:\\DBNeT\\dbax\\";
            //DbnetGlobal.Path = Path.GetFullPath("setting.config");
        }

        foreach (string tCorrInst in vCorrInst)
	    {
		    foreach (string tCodiPers in vCodiPers)
	        {
                DataTable dtArchivos = Empresas.getEmpresasDocumentosPorColumna("1", "1", tCorrInst, tCodiPers, "", "", "", "Estados_financieros_(XBRL)");
                byte[] contenido = Rescata_Archivos_XBRL((Empresas.GetArchivosXbrl(tCodiPers, pCorrInst, Empresas.getUltPersVersInst(tCodiPers, pCorrInst), dtArchivos.Rows[0]["nomb_arch"].ToString()).Rows[0]["Contenido"].ToString()));
                vComp.guardaByteArchivo(vPathBackEnd + "XBRL\\" + dtArchivos.Rows[0]["nomb_arch"].ToString(), contenido);
                DescomprimeXBRL(vPathBackEnd + "XBRL\\" + dtArchivos.Rows[0]["nomb_arch"].ToString(), vPathBackEnd + "XBRL\\" + tCodiPers + "_" + tCorrInst);

                foreach (string vFile in Directory.GetFileSystemEntries(vPathBackEnd + "XBRL\\" + tCodiPers + "_" + tCorrInst, "*.xbrl"))
                {
                    CargarArchXml(vPathBackEnd + "XBRL\\" + tCodiPers + "_" + tCorrInst);

                    XmlDocument xDoc = new XmlDocument();
                    xDoc.Load(vFile);
                    LeerXBRLCargaInformes(xDoc, tCodiPers, tCorrInst, Empresas.getUltPersVersInst(tCodiPers, pCorrInst), vPathBackEnd + "XBRL\\" + tCodiPers + "_" + tCorrInst, vFile);
                }
            }
        }
    }
    public void LeerXBRLCargaInformes(XmlDocument xDoc, string vRutEmpr, string vPeriInfo, string vInstVers, string vFolder, string vFile)
    {
        string vCorrConc, nodoShell, nodoLink, nodoImport, nodoXbrl, nodoUnidades, nodoContextos, nodoInstant, nodoStartDate, nodoEndDate, nodoScenario, nodoPeriodo, nodoMeasure;
        DataSet dsInfo;
        #region CARGA NODOS

        nodoShell = "schema";
        nodoXbrl = "xbrli:xbrl";
        if (xDoc.GetElementsByTagName(nodoXbrl).Count == 0)
        {
            nodoXbrl = "xbrl";
        }
        XmlNodeList xbrl = xDoc.GetElementsByTagName(nodoXbrl);


        nodoUnidades = "xbrli:unit";
        if (xDoc.GetElementsByTagName(nodoUnidades).Count == 0)
        {
            nodoUnidades = "unit";
        }

        nodoContextos = "xbrli:context";
        if (xDoc.GetElementsByTagName(nodoContextos).Count == 0)
        {
            nodoContextos = "context";
        }


        nodoInstant = "xbrli:instant";
        if (xDoc.GetElementsByTagName(nodoInstant).Count == 0)
        {
            nodoInstant = "instant";
        }

        nodoStartDate = "xbrli:startDate";
        if (xDoc.GetElementsByTagName(nodoStartDate).Count == 0)
        {
            nodoStartDate = "startDate";
        }

        nodoEndDate = "xbrli:endDate";
        if (xDoc.GetElementsByTagName(nodoEndDate).Count == 0)
        {
            nodoEndDate = "endDate";
        }

        nodoScenario = "xbrli:scenario";
        if (xDoc.GetElementsByTagName(nodoScenario).Count == 0)
        {
            nodoScenario = "scenario";
        }

        nodoPeriodo = "xbrli:period";
        if (xDoc.GetElementsByTagName(nodoPeriodo).Count == 0)
        {
            nodoPeriodo = "period";
        }

        nodoMeasure = "xbrli:measure";
        if (xDoc.GetElementsByTagName(nodoMeasure).Count == 0)
        {
            nodoMeasure = "measure";
        }

        nodoLink = "link:schemaRef";
        nodoImport = "import";


        //if (xbrl.Count == 0)
        //{
        //    nodoXbrl = "xbrl";
        //    nodoUnidades = "unit";
        //    nodoContextos = "context";
        //    nodoInstant = "instant";
        //    nodoStartDate = "startDate";
        //    nodoEndDate = "endDate";
        //    nodoScenario = "scenario";
        //    nodoPeriodo = "period";
        //    nodoMeasure = "measure";

        //    xbrl = xDoc.GetElementsByTagName(nodoXbrl);
        //}
        #endregion
        #region CARGA INFORMES
        Log.putLog("Cargando Informes");
        List<string> vListInfo = new List<string>();
        GetDocuXml(nodoImport);
        if (xInfo.Count == 0)
        {
            nodoImport = "xsd:import";
            GetDocuXml(nodoImport);
        }

        if (xInfo.Count == 0)
        {
            nodoImport = "link:schemaRef";
            GetDocuXml(nodoLink);
        }
        foreach (XmlDocument info in xInfo)
        {
            XmlNodeList links = info.GetElementsByTagName(nodoImport);
            foreach (XmlElement link in links)
            {
                string vlink = link.GetAttribute("xlink:href");
                dsInfo = con.TraerResultados0(vComp.GetEsquemaInforme(vlink));
                foreach (DataRow row in dsInfo.Tables[0].Rows)
                {
                    con.EjecutarQuery(vComp.InsertInformeInstancia(vRutEmpr, vPeriInfo, vInstVers, row[0].ToString()));
                    vListInfo.Add(row[0].ToString());
                }

                dsInfo = con.TraerResultados0(vComp.GetEsquemaInforme(link.GetAttribute("schemaLocation")));
                foreach (DataRow row in dsInfo.Tables[0].Rows)
                {
                    con.EjecutarQuery(vComp.InsertInformeInstancia(vRutEmpr, vPeriInfo, vInstVers, row[0].ToString()));
                    vListInfo.Add(row[0].ToString());
                }
            }
        }
        #endregion
    }
    public void CargaXBRLCorregida( bool pElimFold, bool bFuerCarg)
    {
        //comparaCantidadXbrl();
        string sRutaXBRL = con.StringEjecutarQuery(vComp.GetRutaXBRL());
        string[] Folders;
        string[] Files;
        string[] ArchivoZip;
      
        XmlDocument xDoc = new XmlDocument();
        string sXBRL64, vRutEmpr="", vPeriInfo="", vInstVers="";
        Folders = Directory.GetFileSystemEntries(sRutaXBRL);

        Dictionary<string, int> vCantCorrInst = new Dictionary<string, int>();
        foreach (string vFolder in Folders)
        {
            vPeriInfo = vFolder.Substring(vFolder.IndexOf("_") + 1);
            if (!vCantCorrInst.ContainsKey(vPeriInfo))
            {
                vCantCorrInst.Add(vPeriInfo, 1);
            }
            else
            {
                int tmp = vCantCorrInst[vPeriInfo];
                tmp++;
                vCantCorrInst.Remove(vPeriInfo);
                vCantCorrInst.Add(vPeriInfo, tmp);
            }
        }
        RescateDeConceptos conc = new RescateDeConceptos();
        bool vNuevo = false;
    
        // Para Cada directorio que se encuentre en C:\DBNeT\DBAX\XBRL
        Log.putLog("Para Cada directorio que se encuentre en " + sRutaXBRL);
        Log.putLog("Se intentarán cargar " + Folders.Count() + " archivos");
        int vNumeroArchivosCargados = 0;
        string tmpFile = "";

        foreach (string vFolder in Folders)
        {
            try
            {
                Files = Directory.GetFileSystemEntries(vFolder);
                vPeriInfo = vFolder.Substring(vFolder.IndexOf("_") + 1);
                vRutEmpr = vFolder.Substring(vFolder.LastIndexOf("\\") + 1, vFolder.IndexOf("_") - 1 - vFolder.LastIndexOf("\\"));
                ArchivoZip = Directory.GetFiles(vFolder, "*.zip");
                if (grup.getExisteEmpresa(vRutEmpr) == "0")
                {
                    Log.putLog("Empresa no existe: " + sRutaXBRL);
                    Console.WriteLine("Empresa no existe: " + sRutaXBRL);
                    con.StringEjecutarQuery(conc.InstEmpreArchXbrl(vRutEmpr));
                }

                bool bXbrlConCambios = true;

                if (ArchivoZip.Count() > 0)
                {
                    Log.putLog("Existe un archivo zip, descomprimiendo");
                    if(!DescomprimeXBRL(ArchivoZip, vFolder))
                    {
                        continue;
                    }
                }
                else
                {
                    foreach (string File in Files)
                    {
                        if (File.EndsWith(".xbrl"))
                        {
                            Log.putLog("Cargo XBRL para validar sintaxis");
                            if (ValidaXBRL(File, vFolder) == "-1")
                            {
                                bXbrlConCambios = false;
                                throw new Exception("Aparentemente el archivo " + File + " está vacío");
                            }
                        }
                    }
                }

                Log.putLog("Cargo archivos de extensión XBRL");
                CargarArchXml(vFolder);
                Log.putLog("Para cada XBRL encontrado ...");
                
                foreach (string vFile in Directory.GetFileSystemEntries(vFolder,"*.xbrl"))
                {
                    tmpFile = vFile;
                    Log.putLog("Se encontro el archivo xbrl " + vFile);
                    //Empresas.DelInstDocuVers(vRutEmpr.ToString(), vPeriInfo.ToString(), "1"); //Activar cuando se quiera insertar nuevamente la misma version.

                    sXBRL64 = con.StringEjecutarQuery(vComp.GetBase64XBRL(vRutEmpr, vPeriInfo, vFile.Substring(vFile.LastIndexOf("\\") + 1)));
                    Log.putLog(vComp.GetBase64XBRL(vRutEmpr, vPeriInfo, vFile.Substring(vFile.LastIndexOf("\\") + 1)));
                    Log.putLog("Se obtuvo versión anterior del XBRL desde base de datos, con largo " + sXBRL64.Length);

                    if (vComp.VerificarXBRL(vFile, sXBRL64) || bFuerCarg)
                    {
                        con.EjecutarQuery(vComp.updArchPen(vPeriInfo, vRutEmpr, "CARG"));

                        bXbrlConCambios = true;
                        vInstVers = con.StringEjecutarQuery(conc.getSigPersVersInst(vRutEmpr, vPeriInfo));
                        Log.putLog("La versión anterior del XBRL es distinta a la actual, se debe cargar en versión " + vInstVers);

                        /***************************************************************************/
                        //Inserción de mensaje de correo indicando que ese RUT envió XBRL con cambios
                        /***************************************************************************/
                        string vFecha = System.DateTime.Now.Year.ToString() + "-" + System.DateTime.Now.Month.ToString() + "-" + System.DateTime.Now.Day.ToString() + " " + System.DateTime.Now.Hour.ToString() + ":" + System.DateTime.Now.Minute.ToString() + ":" + System.DateTime.Now.Second.ToString();
                        con.EjecutarQuery(correo.insEstaMail(vRutEmpr, "R", "P", vFecha, vPeriInfo));

                        /***************************************************************************/
                        //Valido que si el rut procesado es nuevo
                        /***************************************************************************/
                        DataTable dtReportados = con.TraerResultadosT0(vComp.getCodiPersReportadosPeriodoActualyAnterior(vPeriInfo));

                        int vRutAntiguo = dtReportados.Select("codi_pers='" + vRutEmpr + "'").Count();
                        if (vRutAntiguo == 0)
                        {
                            con.EjecutarQuery(correo.insEstaMail(vRutEmpr, "N", "P", vFecha, vPeriInfo));
                        }

                        vNuevo = true;
                        //Aca debe insertarse la instancia SSI corresponde
                        con.EjecutarQuery(vComp.insInstDocu(vRutEmpr, vPeriInfo, "ACT"));
                        
                        con.EjecutarQuery(vComp.InsertVersionInstancia(vRutEmpr, vPeriInfo, vInstVers, "descripción", "ACT"));
                        con.EjecutarQuery(vComp.SetBase64XBRL(vRutEmpr, vPeriInfo, vInstVers, vComp.CodificarArchivo(vFile), vFile.Substring(vFile.LastIndexOf("\\") + 1), "xbrl"));
                        xDoc.Load(vFile);
                        Log.putLog("Cargando Empresa: " + vRutEmpr);
                        if (vRutEmpr == "83628100")
                        {
                            Log.putLog("Cargando empresa Sonda (83628100) con método especial");
                            LeerXBRLSonda(xDoc, vRutEmpr, vPeriInfo, vInstVers, vFolder, vFile);
                        }
                        else 
                        { 
                            LeerXBRL(xDoc, vRutEmpr, vPeriInfo, vInstVers, vFolder, vFile); 
                        }
                        Log.putLog("Finalizada lectura de XBRL");
                        validaConceptosCargados(vRutEmpr, vPeriInfo, vInstVers, vFile);
                        if (vInstVers != "1")
                            InseDiferenciasLista(vRutEmpr, vPeriInfo, vInstVers);

                        /*System.Diagnostics.ProcessStartInfo pinfo = new System.Diagnostics.ProcessStartInfo();
                        pinfo.UseShellExecute = true;
                        pinfo.RedirectStandardOutput = false;
                        pinfo.FileName = "dbax.GeneraHTML.exe";
                        pinfo.Arguments = "1 1 " + vPeriInfo + " " + vRutEmpr + " \"\" \"\" \"\" \"S\"";
                        System.Diagnostics.Process p = System.Diagnostics.Process.Start(pinfo);
                        p.WaitForExit();*/
                    }
                    else
                    {
                        con.EjecutarQuery(vComp.updArchPen(vPeriInfo, vRutEmpr, "CARG","ASC"));
                        bXbrlConCambios = false;
                        Log.putLog("La versión anterior del XBRL es igual a la actual, no se cargará nuevamente");
                        break;
                    }
                }

                if (bXbrlConCambios || bFuerCarg)
                {
                    Log.putLog("Cargando documentos anexos");
                    foreach (string vFile in Directory.GetFileSystemEntries(vFolder))
                    {
                        if (vNuevo)
                        {
                            if (vFile.Substring(vFile.LastIndexOf(".") + 1) == "pdf")
                            {
                                GZipCompresion(vFile);
                                nArchivo = vFile + ".zip";
                                con.EjecutarQuery(vComp.SetBase64XBRL(vRutEmpr, vPeriInfo, vInstVers, vComp.CodificarArchivo(nArchivo), nArchivo.Substring(nArchivo.LastIndexOf("\\") + 1), "pdf"));
                            }
                            else if (vFile.Substring(vFile.LastIndexOf(".") + 1) == "xls")
                            {
                                GZipCompresion(vFile);
                                nArchivo = vFile + ".zip";
                                guardaBase64(vRutEmpr, vPeriInfo, vInstVers, vComp.CodificarArchivo(nArchivo), nArchivo.Substring(nArchivo.LastIndexOf("\\") + 1), "xls");
                            }
                            else if (vFile.Substring(vFile.LastIndexOf(".") + 1) == "zip")
                            {
                                guardaBase64(vRutEmpr, vPeriInfo, vInstVers, vComp.CodificarArchivo(vFile), vFile.Substring(vFile.LastIndexOf("\\") + 1), "zip");
                            }
                            else if (vFile.Substring(vFile.LastIndexOf(".") + 1) == "xml")
                            {
                                guardaBase64(vRutEmpr, vPeriInfo, vInstVers, vComp.CodificarArchivo(vFile), vFile.Substring(vFile.LastIndexOf("\\") + 1), "xml");
                            }
                            else if (vFile.Substring(vFile.LastIndexOf(".") + 1) == "xsd")
                            {
                                guardaBase64(vRutEmpr, vPeriInfo, vInstVers, vComp.CodificarArchivo(vFile), vFile.Substring(vFile.LastIndexOf("\\") + 1), "xsd");
                            }
                        }
                    }

                    Log.putLog("Insertando visualizador");
                    InseVisualizador("0", "0", vPeriInfo, vRutEmpr, "", "", "", "S");
                }
                else
                {
                    Log.putLog("No se cargan documentos anexos");
                }

                if (pElimFold)
                {
                    Log.putLog("Eliminando archivo");
                    foreach (string vFile in Directory.GetFileSystemEntries(vFolder))
                    {
                        File.Delete(vFile);
                    }
                    Directory.Delete(vFolder);
                    Log.putLog("Carga Empresa: " + vRutEmpr + " Finalizada");
                }
                vNumeroArchivosCargados++;
            }
            catch (Exception ex)
            {
                Log.putLog(ex.Message);
                Log.putLog(" Ocurrio un error cargando el archivo " + vFolder.ToString());
                //con.EjecutarQuery(vComp.insXbrlConProblemas(vPeriInfo, vRutEmpr, tmpFile, "ECA","Ocurrió un problema durante la carga: " + ex.Message + " " + ex.StackTrace));
                con.EjecutarQuery(vComp.updArchPen(vPeriInfo, vRutEmpr, "CARG", "EDC"));
                

                string vFecha = System.DateTime.Now.Year.ToString() + "-" + System.DateTime.Now.Month.ToString() + "-" + System.DateTime.Now.Day.ToString() + " " + System.DateTime.Now.Hour.ToString() + ":" + System.DateTime.Now.Minute.ToString() + ":" + System.DateTime.Now.Second.ToString();
                string vMensaje = "Error al cargar el archivo en " + vFecha + (char)13 + (char)10;
                vMensaje += ex.Message;
                try
                {
                    correo.enviarCorreo("Error cargando XBRL " + vFolder.ToString(), vMensaje);
                }
                catch 
                {
                    Log.putLog(ex.Message);
                    Log.putLog(" Ocurrio un error enviando el correo " + vFolder.ToString());
                }
            }
        }
        Log.putLog("Finalizó ciclo de carga");
        con.EjecutarQuery(vComp.insValidaPersonaHolding());
        //comparaCantidadXbrl();
        Log.putLog("Se cargaron correctamente " + vNumeroArchivosCargados + " archivos de un total de " + Folders.Count());
    }
    
    private void validaConceptosCargados(string pCodiPers, string pCorrInst, string pVersInst, string pFile)
    {
        //Definir conceptos "criticos" por tipo y período (tabla SQL)
        //Obtener tipo de empresa
        //De acuerdo a tipo de empresa y periodo de envío, evaluar si conceptos críticos se cargaron correctamente
        DataTable dtConceptosCriticos = con.TraerResultadosT0(vComp.getConceptosCriticos(pCodiPers, pCorrInst, pVersInst));

        if (dtConceptosCriticos.Rows.Count > 0)
        {
            con.EjecutarQuery(vComp.insXbrlConProblemas(pCorrInst, pCodiPers, pFile, dtConceptosCriticos));
        }

        for (int i = 0; i < dtConceptosCriticos.Rows.Count; i++)
        {
            con.EjecutarQuery(vComp.updArchPen(pCorrInst, pCodiPers, "CARG", "ECC"));
            Log.putLog("No se encontró el concepto crítico: " + dtConceptosCriticos.Rows[i]["desc_conc"].ToString());
            Log.enviarCorreo("No se encontró el concepto crítico: " + dtConceptosCriticos.Rows[i]["desc_conc"].ToString());
            UpdEstadoVersInst(pCodiPers, pCorrInst, pVersInst, "C");
        }
    }
    private void comparaCantidadXbrl()
    {
        DataTable dtPeriodos = Empresas.getPersCorrInst("");
        for (int i = 0; i < dtPeriodos.Rows.Count; i++)
        {
            DataTable vXbrlConProblemas = con.TraerResultadosT0(vComp.getCantidadXbrlReportados(dtPeriodos.Rows[i][1].ToString()));

            if (vXbrlConProblemas.Rows[0]["ErroLink"].ToString() != "0")
            {
                DataTable vXbrlConProblemasLink = con.TraerResultadosT0(vComp.getListaXbrlReportadosConErrorLink(dtPeriodos.Rows[i][1].ToString()));
                string mensaje = "Rut con problemas de link: ";
                for (int j = 0; j < vXbrlConProblemasLink.Rows.Count; j++)
                {
                    mensaje += vXbrlConProblemasLink.Rows[j][0].ToString() + ", ";
                }

                mensaje = mensaje.Substring(0, mensaje.Length - 1);
                con.EjecutarQuery(vComp.insXbrlConProblemas(dtPeriodos.Rows[i][1].ToString(), "", "", "EDE", "" + mensaje));
            }

            if (vXbrlConProblemas.Rows[0]["ErroCarg"].ToString() != "0")
            {
                DataTable vXbrlConProblemasCarga = con.TraerResultadosT0(vComp.getListaXbrlReportadosYNoCargados(dtPeriodos.Rows[i][1].ToString()));
                string mensaje = "Rut con problemas de carga: ";
                for (int j = 0; j < vXbrlConProblemasCarga.Rows.Count; j++)
                {
                    mensaje += vXbrlConProblemasCarga.Rows[j][0].ToString() + ", ";
                }

                mensaje = mensaje.Substring(0, mensaje.Length - 1);
                con.EjecutarQuery(vComp.insXbrlConProblemas(dtPeriodos.Rows[i][1].ToString(), "", "", "ECA", "" + mensaje));
            }
            /*
            con.EjecutarQuery(vComp.insXbrlConProblemas(dtPeriodos.Rows[i][1].ToString(), "", "", "INF","Código de estado = " + vXbrlConProblemas));
            if (vXbrlConProblemas != "0")
            {
                con.EjecutarQuery(vComp.insRepoXbrlProb(dtPeriodos.Rows[i][1].ToString()));
            }*/
        }
    }
    public void GetArchEmpresa(string pCodiPers, string pCorrInst, string pVersInst, string pRutaEmpr)
    {
        DataTable dtArchivos = Empresas.GetArchivosXbrl(pCodiPers, pCorrInst, pVersInst);
        foreach (DataRow item in dtArchivos.Rows)
        {
            
                string contenido = Empresas.GetArchivosXbrl(pCodiPers, pCorrInst, pVersInst, item["Archivos"].ToString()).Rows[0]["Contenido"].ToString();
                DescomprimirZipController.CrearArchivo(pRutaEmpr + "\\" + item["Archivos"].ToString(), contenido);
                // vComp.guardaByteArchivo(pRutaEmpr + "\\" + item["Archivos"].ToString(), contenido);
                if (!item["Archivos"].ToString().Contains("XBRL"))
                {
                    DescomprimeXBRL3(pRutaEmpr, item["Archivos"].ToString(), pRutaEmpr);
                }
                //File.Delete(pRutaEmpr + "\\" + item["Archivos"].ToString());
            }
        
    }
    private bool DescomprimeXBRL(string[] ArchivoZip, string vFolder)
    {
        Log.putLog("Descomprimiendo archivo: " + ArchivoZip[0]);
        File.Delete(ArchivoZip[0].ToString().Replace(".zip", ".xbrl"));
        System.Diagnostics.ProcessStartInfo pinfo = new System.Diagnostics.ProcessStartInfo();
        pinfo.UseShellExecute = true;
        pinfo.RedirectStandardOutput = false;
        pinfo.FileName = para.getPathBina() + "unzip.exe";
        pinfo.Arguments = " -o -j " + ArchivoZip[0] + " -d " + vFolder;
        System.Diagnostics.Process p = System.Diagnostics.Process.Start(pinfo);
        p.WaitForExit();

        Log.putLog("Descompresion terminada con código " + p.ExitCode.ToString()); 

        if(p.ExitCode.ToString()!="0")
        {
            correo.enviarCorreo("Prisma - Error de descompresión", "No se pudo descromprimir el archivo " + ArchivoZip[0] + ", código de resultado " + p.ExitCode.ToString());
            return false;
        }
        else
        {
            return true;
        }
    }
    private void DescomprimeXBRL3(string vRutaArch,string vNombArch, string vFolder)
    {

        Console.WriteLine(System.DateTime.Now + " - Descomprimiendo archivo: " + vNombArch);
        DescomprimirZipController.Descromprimir2(vRutaArch, vNombArch, vFolder);
        Console.WriteLine(System.DateTime.Now + " - Descompresion terminada ");
    }
    public void DescomprimeXBRL(string ArchivoZip, string vFolder)
    {
        Console.WriteLine(System.DateTime.Now + " - Descomprimiendo archivo: " + ArchivoZip);
        File.Delete(ArchivoZip.ToString().Replace(".zip", ".xbrl"));
        System.Diagnostics.ProcessStartInfo pinfo = new System.Diagnostics.ProcessStartInfo();
        pinfo.UseShellExecute = true;
        pinfo.RedirectStandardOutput = false;
        pinfo.FileName = para.getPathBina() + "unzip.exe";
        pinfo.Arguments = " -o -j \"" + ArchivoZip  + "\" -d " + vFolder;
        Log.putLog(pinfo.FileName + pinfo.Arguments);
        System.Diagnostics.Process p = System.Diagnostics.Process.Start(pinfo);
        p.WaitForExit();
        Console.WriteLine(System.DateTime.Now + " - Descompresion terminada con código " + p.ExitCode.ToString());
    }
    public void DescomprimeHTML(string ArchivoZip)
    {
        Console.WriteLine(System.DateTime.Now + " - Descomprimiendo archivo: " + ArchivoZip);
        Log.putLog(System.DateTime.Now + " - Descomprimiendo archivo: " + ArchivoZip);
        System.Diagnostics.ProcessStartInfo pinfo = new System.Diagnostics.ProcessStartInfo();
        pinfo.UseShellExecute = true;
        pinfo.RedirectStandardOutput = false;
        pinfo.FileName = para.getPathBina() + "unzip.exe";
        pinfo.Arguments = " -o -u " + ArchivoZip + " Reports.html -d " + para.getPathBina() + "\\Visualizador\\Reports";
        Log.putLog(pinfo.FileName + " " + pinfo.Arguments);
        System.Diagnostics.Process p = System.Diagnostics.Process.Start(pinfo);
        p.WaitForExit();
        Console.WriteLine(System.DateTime.Now + " - Descompresion terminada con código " + p.ExitCode.ToString());
        Log.putLog(System.DateTime.Now + " - Descompresion terminada con código " + p.ExitCode.ToString());
    }
    public void limpiaDirectorio(string ruta)
    {
        string[] Files;
        Files = Directory.GetFileSystemEntries(ruta);
        foreach (string archivo in Files)
        {
            File.Delete(archivo);
        }
    }
    //private void InseDiferencias(string vRutEmpr, string vPeriInfo, string vInstVers)
    //{
    //    string vhtml = string.Empty;
    //    DataRow[] drItems;
    //    DataRow drNewItem;
    //    DataSet dsConcActu, dsConcAnte;
    //    dsConcActu = con.TraerResultados0(vComp.GetConceptosVers(vRutEmpr, vPeriInfo, vInstVers));
    //    dsConcAnte = con.TraerResultados0(vComp.GetConceptosVers(vRutEmpr, vPeriInfo, (int.Parse(vInstVers)-1).ToString()));
    //    DataTable dtConceptos = new DataTable();
    //    dtConceptos = dsConcActu.Tables[0].Clone();
    //    dtConceptos.Columns.Add("valo_ante", typeof(string));
 
    //    foreach (DataRow row in dsConcActu.Tables[0].Rows)
    //    {
    //        drItems = dsConcAnte.Tables[0].Select("codi_conc='" + row["codi_conc"] + "' and codi_cntx='" + row["codi_cntx"] + "'");
    //        if (drItems.Count() > 0)
    //        {
    //            if (drItems[0]["valo_cntx"].ToString() != row["valo_cntx"].ToString())
    //            {
    //                drNewItem = dtConceptos.NewRow();
    //                drNewItem["codi_conc"] = row["codi_conc"];
    //                drNewItem["desc_conc"] = row["desc_conc"];
    //                drNewItem["fini_cntx"] = row["fini_cntx"];
    //                drNewItem["ffin_cntx"] = row["ffin_cntx"];
    //                drNewItem["codi_cntx"] = row["codi_cntx"];
    //                drNewItem["valo_cntx"] = row["valo_cntx"];
    //                drNewItem["valo_ante"] = drItems[0]["valo_cntx"];
    //                dtConceptos.Rows.Add(drNewItem);
    //                continue;
    //            }
    //            else
    //            {
    //                continue;
    //            }
    //        }
    //        else
    //        {
    //            drNewItem = dtConceptos.NewRow();
    //            drNewItem["codi_conc"] = row["codi_conc"];
    //            drNewItem["desc_conc"] = row["desc_conc"];
    //            drNewItem["fini_cntx"] = row["fini_cntx"];
    //            drNewItem["ffin_cntx"] = row["ffin_cntx"];
    //            drNewItem["codi_cntx"] = row["codi_cntx"];
    //            drNewItem["valo_cntx"] = row["valo_cntx"];
    //            drNewItem["valo_ante"] = "";
    //            dtConceptos.Rows.Add(drNewItem);
    //            continue;
    //        }
    //    }
    //    foreach (DataRow row in dsConcAnte.Tables[0].Rows)
    //    {
    //        drItems = dsConcActu.Tables[0].Select("codi_conc='" + row["codi_conc"] + "' and codi_cntx='" + row["codi_cntx"] + "'");
    //        if (drItems.Count() > 0)
    //        {
    //            continue;
    //        }
    //        else
    //        {
    //            drNewItem = dtConceptos.NewRow();
    //            drNewItem["codi_conc"] = row["codi_conc"];
    //            drNewItem["desc_conc"] = row["desc_conc"];
    //            drNewItem["fini_cntx"] = row["fini_cntx"];
    //            drNewItem["ffin_cntx"] = row["ffin_cntx"];
    //            drNewItem["codi_cntx"] = row["codi_cntx"];
    //            drNewItem["valo_ante"] = row["valo_cntx"];
    //            drNewItem["valo_cntx"] = "";
    //            dtConceptos.Rows.Add(drNewItem);
    //            continue;
    //        }
    //    }

    //    try
    //    {
    //        int vCont = 1;
    //        string vClase;
    //        for (int i = 0; i < dtConceptos.Rows.Count; i++)
    //        {
    //            if (i == 0)
    //            {
    //                vhtml = "<html> " +
    //                        "   <head> " +
    //                        "	    <link href=..\"librerias/CSS/DBAX.css\" rel=\"stylesheet\" type=\"text/css\" /> " +
    //                        "</head> " +
    //                        "<body>" +
    //                        "   <table class = \"TablaHtml\" cellpadding=\"0\" cellspacing=\"0\" >" +
    //                        "       <tr>" +
    //                        "          <td align=\"center\">Concepto</td>" +
    //                        "          <td align=\"center\">Periodo</td>" +
    //                        "          <td align=\"center\" colspan=\"2\">Versión " + (Convert.ToInt32(vInstVers) - 1) + "</td>" +
    //                        "          <td align=\"center\" colspan=\"2\">Versión " + vInstVers + "</td>" +
    //                        "       </tr>";
    //            }

    //            //dsValoCntx = con.TraerResultados0(vComp.GetValoresInstancia(vRutEmpr, vPeriInfo, vInstVers, dsConceptos.Tables[0].Rows[i]["codi_conc"].ToString(), dsConceptos.Tables[0].Rows[i]["fini_cntx"].ToString(), dsConceptos.Tables[0].Rows[i]["ffin_cntx"].ToString()));
    //            //foreach (DataRow row in dsValoCntx.Tables[0].Rows)
    //            //{
    //            if (vCont % 2 == 0)
    //            {
    //                vClase = "filaPar";
    //            }
    //            else
    //            {
    //                vClase = "filaImpar";
    //            }
    //            vCont++;

    //            vhtml += "<tr class=\"" + vClase + "\">" +
    //                        "<td  align=\"center\">" + dtConceptos.Rows[i]["desc_conc"].ToString() + "</td>" +
    //                        "<td  align=\"center\">" + dtConceptos.Rows[i]["fini_cntx"].ToString() + " " + dtConceptos.Rows[i]["ffin_cntx"].ToString() + "</td>" +
    //                        "<td  align=\"center\" >&nbsp;&nbsp</td>" +
    //                        "<td  align=\"center\">" + dtConceptos.Rows[i]["valo_ante"].ToString() + "</td>" +
    //                        "<td  align=\"center\">&nbsp;&nbsp</td>" +
    //                        "<td  align=\"center\">" + dtConceptos.Rows[i]["valo_cntx"].ToString() + "</td>" +
    //                     "</tr>";
    //            //}
    //        }
    //        vhtml += "</body></table>";

    //        con.EjecutarQuery(vComp.InseHtmlDiferencias(vRutEmpr, vPeriInfo, vInstVers, vhtml));
    //    }
    //    catch (Exception ex)
    //    {
    //        Log.putLog("Ocurrio un error: " + ex.Message);
    //        Log.putLog(" Ocurrio un error cargando en archivo " + vRutEmpr + "_" + vPeriInfo);
    //    }
    //}
    private void InseDiferenciasLista(string vRutEmpr, string vPeriInfo, string vInstVers)
    {
        string vhtml = string.Empty;
        DataRow[] drItems;
        DataRow drNewItem;
        DataTable dtConcActu, dtConcAnte;

        dtConcActu = con.TraerResultados0(vComp.GetConceptosVers(vRutEmpr, vPeriInfo, vInstVers)).Tables[0];
        dtConcAnte = con.TraerResultados0(vComp.GetConceptosVers(vRutEmpr, vPeriInfo, (int.Parse(vInstVers) - 1).ToString())).Tables[0];  //vInstVers - 1

        //repliqué mas o menos el funcionamiento con linq pero no obtuve mejores tiempos de respuesta

        //List<cInstConc> lValoresActuales = new List<cInstConc>();
        //List<cInstConc> lValoresAnteriores = new List<cInstConc>();

        //for (int i = 0; i < dtConcActu.Rows.Count; i++)
        //{
        //    cInstConc cValor = new cInstConc();
        //    cValor.CODI_CONC = dtConcActu.Rows[i]["CODI_CONC"].ToString();
        //    cValor.DESC_CONC = dtConcActu.Rows[i]["DESC_CONC"].ToString();
        //    cValor.FINI_CNTX = dtConcActu.Rows[i]["FINI_CNTX"].ToString();
        //    cValor.FFIN_CNTX = dtConcActu.Rows[i]["FFIN_CNTX"].ToString();
        //    cValor.CODI_CNTX = dtConcActu.Rows[i]["CODI_CNTX"].ToString();
        //    cValor.VALO_CNTX = dtConcActu.Rows[i]["VALO_CNTX"].ToString();
        //    cValor.CNTX_STND = dtConcActu.Rows[i]["CNTX_STND"].ToString();

        //    lValoresActuales.Add(cValor);
        //}

        //for (int i = 0; i < dtConcAnte.Rows.Count; i++)
        //{
        //    cInstConc cValor = new cInstConc();
        //    cValor.CODI_CONC = dtConcAnte.Rows[i]["CODI_CONC"].ToString();
        //    cValor.DESC_CONC = dtConcAnte.Rows[i]["DESC_CONC"].ToString();
        //    cValor.FINI_CNTX = dtConcAnte.Rows[i]["FINI_CNTX"].ToString();
        //    cValor.FFIN_CNTX = dtConcAnte.Rows[i]["FFIN_CNTX"].ToString();
        //    cValor.CODI_CNTX = dtConcAnte.Rows[i]["CODI_CNTX"].ToString();
        //    cValor.VALO_CNTX = dtConcAnte.Rows[i]["VALO_CNTX"].ToString();
        //    cValor.CNTX_STND = dtConcAnte.Rows[i]["CNTX_STND"].ToString();

        //    lValoresAnteriores.Add(cValor);
        //}

        Console.WriteLine(System.DateTime.Now.Second + ":" + System.DateTime.Now.Millisecond);
        
        //foreach (cInstConc vValorActual in lValoresActuales)
        //{
        //    //List<cInstConc> lComparacionActualAnterior = lValoresAnteriores.Where(x => x.CODI_CONC == vValorActual.CODI_CONC
        //    //                                                                    && x.CNTX_STND == vValorActual.CNTX_STND).ToList();

        //    IEnumerable<cInstConc> ieComparacionActualAnterior = from valAnt in lValoresAnteriores
        //                                                         where valAnt.CODI_CONC == vValorActual.CODI_CONC
        //                                                         && valAnt.CNTX_STND == vValorActual.CNTX_STND
        //                                                         select valAnt;

        //    List<cInstConc> lComparacionActualAnterior = ieComparacionActualAnterior.ToList();

        //    if (lComparacionActualAnterior.Count > 0)
        //    {
        //        if (lComparacionActualAnterior[0].VALO_CNTX != vValorActual.VALO_CNTX)
        //        {
        //            Console.WriteLine("Concepto " + vValorActual.DESC_CONC + " para el contexto " + vValorActual.CODI_CNTX + " tiene valores distintos");
        //        }
        //    }
        //    else
        //    {
        //        Console.WriteLine("Concepto " + vValorActual.DESC_CONC + " para el contexto " + vValorActual.CODI_CNTX + " solo existe en la última versión");
        //    }
        //}
        
        Console.WriteLine(System.DateTime.Now.Second + ":" + System.DateTime.Now.Millisecond);

        DataTable dtConceptos = new DataTable();
        dtConceptos = dtConcActu.Clone();
        dtConceptos.Columns.Add("valo_ante", typeof(string));

        foreach (DataRow row in dtConcActu.Rows)
        {
            drItems = dtConcAnte.Select("codi_conc='" + row["codi_conc"] + "' and cntx_stnd ='" + row["cntx_stnd"] + "'");
            if (drItems.Count() > 0)
            {
                if (drItems[0]["valo_cntx"].ToString() != row["valo_cntx"].ToString())
                {
                    drNewItem = dtConceptos.NewRow();
                    drNewItem["orde_info"] = row["orde_info"];
                    drNewItem["orde_conc"] = row["orde_conc"];
                    drNewItem["codi_info"] = row["codi_info"];
                    drNewItem["desc_info"] = row["desc_info"];
                    drNewItem["codi_conc"] = row["codi_conc"];
                    drNewItem["desc_conc"] = row["desc_conc"];
                    drNewItem["fini_cntx"] = row["fini_cntx"];
                    drNewItem["ffin_cntx"] = row["ffin_cntx"];
                    drNewItem["codi_cntx"] = row["codi_cntx"];
                    drNewItem["valo_cntx"] = row["valo_cntx"];
                    drNewItem["valo_ante"] = drItems[0]["valo_cntx"];
                    dtConceptos.Rows.Add(drNewItem);
                    continue;

                    //Console.WriteLine("Concepto " + row["DESC_CONC"] + " para el contexto " + row["CODI_CNTX"] + " tiene valores distintos");
                }
                else
                {
                    continue;
                }
            }
            else
            {
                drNewItem = dtConceptos.NewRow();
                drNewItem["orde_info"] = row["orde_info"];
                drNewItem["orde_conc"] = row["orde_conc"];
                drNewItem["codi_info"] = row["codi_info"];
                drNewItem["desc_info"] = row["desc_info"];
                drNewItem["codi_conc"] = row["codi_conc"];
                drNewItem["desc_conc"] = row["desc_conc"];
                drNewItem["fini_cntx"] = row["fini_cntx"];
                drNewItem["ffin_cntx"] = row["ffin_cntx"];
                drNewItem["codi_cntx"] = row["codi_cntx"];
                drNewItem["valo_cntx"] = row["valo_cntx"];
                drNewItem["valo_ante"] = "";
                dtConceptos.Rows.Add(drNewItem);
                continue;

                //Console.WriteLine("Concepto " + row["DESC_CONC"] + " para el contexto " + row["CODI_CNTX"] + " solo existe en la última versión");
            }
        }

        Console.WriteLine(System.DateTime.Now.Second + ":" + System.DateTime.Now.Millisecond);

        foreach (DataRow row in dtConcAnte.Rows)
        {
            drItems = dtConcActu.Select("codi_conc='" + row["codi_conc"] + "' and codi_cntx='" + row["codi_cntx"] + "'");
            if (drItems.Count() > 0)
            {
                continue;
            }
            else
            {
                drNewItem = dtConceptos.NewRow();
                drNewItem["orde_info"] = row["orde_info"];
                drNewItem["orde_conc"] = row["orde_conc"];
                drNewItem["codi_info"] = row["codi_info"];
                drNewItem["desc_info"] = row["desc_info"];
                drNewItem["codi_conc"] = row["codi_conc"];
                drNewItem["desc_conc"] = row["desc_conc"];
                drNewItem["fini_cntx"] = row["fini_cntx"];
                drNewItem["ffin_cntx"] = row["ffin_cntx"];
                drNewItem["codi_cntx"] = row["codi_cntx"];
                drNewItem["valo_ante"] = row["valo_cntx"];
                drNewItem["valo_cntx"] = "";
                dtConceptos.Rows.Add(drNewItem);
                continue;
            }
        }

        DataView dv = dtConceptos.DefaultView;
        dv.Sort = "orde_info, orde_conc";
        DataTable dtConceptosOrdenados = dv.ToTable();
        Console.WriteLine(dtConceptosOrdenados.Rows.Count);

        try
        {
            int vCont = 1;
            string vClase;
            string vInforme = "";

            vhtml += "<html> " +
                    "   <head> " +
                    "	    <link href=..\"librerias/CSS/DBAX.css\" rel=\"stylesheet\" type=\"text/css\" /> " +
                    "</head> " +
                    "<body>" +
                    "<style> " +
                    ".filaPar {background-color: #EEEEEE;}  " +
                    "</style>";

            for (int i = 0; i < dtConceptosOrdenados.Rows.Count; i++)
            {
                //dsValoCntx = con.TraerResultados0(vComp.GetValoresInstancia(vRutEmpr, vPeriInfo, vInstVers, dsConceptos.Tables[0].Rows[i]["codi_conc"].ToString(), dsConceptos.Tables[0].Rows[i]["fini_cntx"].ToString(), dsConceptos.Tables[0].Rows[i]["ffin_cntx"].ToString()));
                //foreach (DataRow row in dsValoCntx.Tables[0].Rows)
                //{
                

                //Si el informe de la línea actual es distinto al informe de la línea anterior,
                //entonces es un nuevo ROL y por lo tanto debo imprimir una línea que indique el desc_info
                if (dtConceptosOrdenados.Rows[i]["codi_info"].ToString() != vInforme)
                {
                    vInforme = dtConceptosOrdenados.Rows[i]["codi_info"].ToString();

                    if (i != 0)
                    {
                        vhtml += "</table>";
                        vhtml += "</br>";
                    }

                    vCont = 1;

                    vhtml += "   <table class = \"TablaHtml\" cellpadding=\"0\" cellspacing=\"0\" border = \"1\" width=\"100%\">" +
                            "       <tr class=\"filaPar\">" +
                            "           <td  align=\"left\" colspan=\"5\"><b>" + dtConceptosOrdenados.Rows[i]["desc_info"].ToString() + "</b></td>" +
                            "       </tr>" +
                            "       <tr class=\"filaPar\">" +
                            "          <td align=\"center\" width=\"40%\">Concepto</td>" +
                            "          <td align=\"center\" width=\"20%\">Contexto</td>" +
                            "          <td align=\"center\" width=\"20%\">Fechas</td>" +
                            "          <td align=\"center\" width=\"10%\">Versión " + (Convert.ToInt32(vInstVers) - 1) + "</td>" +
                            "          <td align=\"center\" width=\"10%\">Versión " + vInstVers + "</td>" +
                            "       </tr>";
                }

                if (vCont % 2 == 0)
                {
                    vClase = "filaPar";
                }
                else
                {
                    vClase = "filaImpar";
                }

                vhtml += "<tr class=\"" + vClase + "\">" +
                            "<td  align=\"left\">" + dtConceptosOrdenados.Rows[i]["desc_conc"].ToString() + "</td>" +
                            "<td  align=\"left\">" + dtConceptosOrdenados.Rows[i]["codi_cntx"].ToString() + "</td>" +
                            "<td  align=\"center\">" + dtConceptosOrdenados.Rows[i]["fini_cntx"].ToString();

                if (dtConceptosOrdenados.Rows[i]["ffin_cntx"].ToString() != "0")
                {
                    vhtml += " / " + dtConceptosOrdenados.Rows[i]["ffin_cntx"].ToString() + "</td>";
                }
                else
                {
                    vhtml += "</td>";
                }
                vhtml += "<td  align=\"center\">" + dtConceptosOrdenados.Rows[i]["valo_ante"].ToString() + "</td>" +
                            "<td  align=\"center\">" + dtConceptosOrdenados.Rows[i]["valo_cntx"].ToString() + "</td>" +
                         "</tr>";
                //}

                vCont++;
            }
            vhtml += "</table></body>";

            con.EjecutarQuery(vComp.InseHtmlDiferencias(vRutEmpr, vPeriInfo, vInstVers, vhtml));
        }
        catch (Exception ex)
        {
            Log.putLog("Ocurrio un error: " + ex.Message);
            Log.putLog(" Ocurrio un error cargando en archivo " + vRutEmpr + "_" + vPeriInfo);
        }
    }
    public byte[] Rescata_Archivos_XBRL(string base64)
    {
        byte[] contenido = vComp.DecodificarArchivoBytes(base64);
        return contenido;
    }
    public string Obtener_Html(string vRutEmpr, string vPeriInfo, string vInstVers)
    {
        return con.StringEjecutarQuery(vComp.GetInstanciaHTML(vRutEmpr, vPeriInfo, vInstVers));
    }
    public static void GZipCompresion(string strNombreArchivo)
    {
        FileStream fsArchivo;
        try
        {
            // Leemos el archivo a comprimir
            fsArchivo = new FileStream(strNombreArchivo, FileMode.Open, FileAccess.Read, FileShare.Read);

            //Definimos el buffer con el tamaño del archivo
            byte[] btBuffer = new byte[fsArchivo.Length];
            
            //Almacenamos los bytes del archivo en el buffer
            int intCount = fsArchivo.Read(btBuffer, 0, btBuffer.Length);
            fsArchivo.Close();

            //Definimos el nuevo stream que nos va a permitir grabar el zip
            FileStream fsSalida = new FileStream(strNombreArchivo + ".zip", FileMode.Create, FileAccess.Write);
            
            //Rutina de compresion usando GZipStream
            GZipStream gzsArchivo = new GZipStream(fsSalida, CompressionMode.Compress, true);
            
            //Escribimos el resultado
            gzsArchivo.Write(btBuffer, 0, btBuffer.Length);
            gzsArchivo.Close();

            //Cerramos el archivo
            fsSalida.Flush();
            fsSalida.Close();
        }
        catch (Exception ex)
        {
            Log.putLog("Ocurrio un error en metodo: GZipCompresion");
            Log.putLog(ex.Message);
        }
    }
    public static void GZipDescompresion(string strNombreArchivo)
    {
        FileStream fsArchivo;
        try
        {
            // Leemos el archivo a comprimir
            fsArchivo = new FileStream(strNombreArchivo, FileMode.Open, FileAccess.Read, FileShare.Read);

            //Definimos el buffer con el tamaño del archivo
            byte[] btBuffer = new byte[fsArchivo.Length];

            //Almacenamos los bytes del archivo en el buffer
            int intCount = fsArchivo.Read(btBuffer, 0, btBuffer.Length);
            fsArchivo.Close();

            //Definimos el nuevo stream que nos va a permitir grabar el zip
            FileStream fsSalida = new FileStream(strNombreArchivo + ".zip", FileMode.Create, FileAccess.Write);

            //Rutina de compresion usando GZipStream
            GZipStream gzsArchivo = new GZipStream(fsSalida, CompressionMode.Compress, true);

            //Escribimos el resultado
            gzsArchivo.Write(btBuffer, 0, btBuffer.Length);
            gzsArchivo.Close();

            //Cerramos el archivo
            fsSalida.Flush();
            fsSalida.Close();
        }
        catch (Exception ex)
        {
            Log.putLog("Ocurrio un error en metodo: GZipDescompresion");
            Log.putLog(ex.Message);
        }
    }
    public static void BorrarA(String archivo)
    {
        if (System.IO.File.Exists(@archivo))
        {
            try
            {
                System.IO.File.Delete(@archivo);
            }
            catch (System.IO.IOException)
            {
                return;
            }
        }
    }
    public void guardaBase64(string vRutEmpr, string vPeriInfo, string vInstVers, string contArch, string nombArch, string tipoArch)
    {
        con.EjecutarQuery(vComp.SetBase64XBRL(vRutEmpr, vPeriInfo, vInstVers, contArch, nombArch, tipoArch));
    }
    public void guardaBase64(string vRutEmpr, string vPeriInfo, string vInstVers, string parametroVacio, string nombArchParaLeer, string nombArchParaGuardar, string tipoArch)
    {
        string contenido = vComp.CodificarArchivo(nombArchParaLeer);
        if (!contenido.StartsWith("Error "))
        {
            con.EjecutarQuery(vComp.SetBase64XBRL(vRutEmpr, vPeriInfo, vInstVers, contenido, nombArchParaGuardar, tipoArch));
        }
    }
    public string guardaBase64(string vRutEmpr, string vPeriInfo, string vInstVers, string parametroVacio, string nombArchParaLeer, string nombArchParaGuardar, string tipoArch, string parametroVacio2)
    {
        try
        {
            string contenido = vComp.CodificarArchivo(nombArchParaLeer);
            //Log.putLog("Pase 1");
            if (!contenido.StartsWith("Error "))
            {
                con.EjecutarQuery(vComp.SetBase64XBRL(vRutEmpr, vPeriInfo, vInstVers, contenido, nombArchParaGuardar, tipoArch));
               // Log.putLog("Pase 2");
                return "1";
            }
            else
            {
               // Log.putLog("Pase 3");
                return "Error ";
            }
        }
        catch (Exception ex)
        {

            Log.putLog("Ocurrio un error en metodo: guardaBase64");
            Log.putLog(ex.Message);
            return "Error ";
        }
    }
    public void InseVisualizador(string pCodiEmex, string pCodiEmpr, string pCorrinst, string pCodiPers, string pCodiGrup, string pCodiSegm, string pTipoTaxo, string pSobr_arch)
    {
        con.EjecutarQuery(genHtml.InsVisualizador(pCodiEmex, pCodiEmpr, pCorrinst, pCodiPers, pCodiGrup, pCodiSegm, pTipoTaxo, pSobr_arch));
    }
    public void CargaXBRLUsuario(string pCodiEmex, string pCodiEmpr, string pCodiUsua, string pDireXbrl, string pIFRS13, string pDbgxEmpr, string pDbgxCorr, string pDbgxVers)
    {
        string sRutaXBRL = con.StringEjecutarQuery(vComp.GetRutaXBRL());
        //string[] Folders;
        string[] Files;
        string[] ArchivoZip;

        XmlDocument xDoc = new XmlDocument();
        string vRutEmpr = "965718902", vPeriInfo = "201806", vInstVers = "30";
        //Folders = Directory.GetFileSystemEntries(sRutaXBRL);
        RescateDeConceptos conc = new RescateDeConceptos();

        if (pDireXbrl == "")
            pDireXbrl = @"C:\dbnet\DBAX\XBRL\969179902_201809";

        // Para Cada directorio que se encuentre en C:\DBNeT\DBAX\XBRL
        //Log.putLog("Para Cada directorio que se encuentre en " + Folders);
        //foreach (string vFolder in Folders)
        //{
        try
        {
            /********* comentar esto ********/
            //Empresas.ObtenerInfoEmprString(pCodiEmex, pCodiEmpr, vRutEmpr, vPeriInfo, vInstVers, pIFRS13);
            /*************Hasta acá***************************/

            Log.putLog("Comenzando carga de archivo");
            Files = Directory.GetFileSystemEntries(pDireXbrl);
            ArchivoZip = Directory.GetFiles(pDireXbrl, "*.zip");

            if (ArchivoZip.Count() > 0)
            {
                Log.putLog("Existe un archivo zip, descomprimiendo");
                DescomprimeXBRL(ArchivoZip, pDireXbrl);
            }
            else
            {
                foreach (string File in Files)
                {
                    if (File.EndsWith(".xbrl"))
                    {
                        Log.putLog("Cargo XBRL para validar sintaxis");
                        ValidaXBRL(File, pDireXbrl);
                    }
                }
            }

            Log.putLog("Cargo archivos de extensión XBRL");
            CargarArchXml(pDireXbrl);

            string vPais = para.getPaisXbrl();

            Log.putLog("Para cada XBRL encontrado ...");
            foreach (string vFile in Directory.GetFileSystemEntries(pDireXbrl, "*.xbrl"))
            {
                Log.putLog("Se encontro el archivo xbrl " + vFile);

                xDoc.Load(vFile);
                vRutEmpr = ObtieneRutDeXBRL(xDoc);

                if (vPais.Equals("COL"))
                {
                    vPeriInfo = vFile.Substring(vFile.LastIndexOf("_") + 1).Replace(".xbrl", "").Replace("-", "").Substring(0, 6);
                }
                else
                {
                    vRutEmpr = pDireXbrl.Substring(pDireXbrl.LastIndexOf("\\") + 1, pDireXbrl.IndexOf("_") - 1 - pDireXbrl.LastIndexOf("\\"));
                    vPeriInfo = pDireXbrl.Substring(pDireXbrl.IndexOf("_") + 1);
                }

                
                if (grup.getExisteEmpresa(vRutEmpr) == "0")
                {
                    Log.putLog("Empresa no existe: " + sRutaXBRL);
                    Console.WriteLine("Empresa no existe: " + sRutaXBRL);
                    con.StringEjecutarQuery(conc.InstEmpreArchXbrl(vRutEmpr));
                }

                //InseDiferenciasLista(vRutEmpr, vPeriInfo, "32");

                //Aca debe insertarse la instancia SSI corresponde
                con.EjecutarQuery(vComp.insInstDocu(vRutEmpr, vPeriInfo, "ACT"));

                //Empresas.DelInstDocuVersExte(vRutEmpr.ToString(), vPeriInfo.ToString(), pCodiUsua, pDbgxEmpr, pDbgxCorr, pDbgxVers);
                vInstVers = con.StringEjecutarQuery(conc.getSigPersVersInstExte(vRutEmpr, vPeriInfo));
                Log.putLog(vInstVers);
                con.EjecutarQuery(vComp.InsertVersionInstancia(vRutEmpr, vPeriInfo, vInstVers, "descripción", "ACT", pCodiUsua,pDbgxEmpr, pDbgxCorr, pDbgxVers));
                // con.EjecutarQuery(vComp.SetBase64XBRL(vRutEmpr, vPeriInfo, vInstVers, vComp.CodificarArchivo(vFile), "XBRL_Temporal_" + vFile.Substring(vFile.LastIndexOf("\\") + 1), "xbrl"));
                
                Log.putLog("Finalizada lectura de XBRL");
                Log.putLog("Cargando Empresa: " + vRutEmpr);
                UpdEstadoVersInst(vRutEmpr, vPeriInfo, vInstVers, "CI");
                if (vRutEmpr == "83628100")
                {
                    Log.putLog("Cargando empresa Sonda (83628100) con método especial");
                    LeerXBRLSonda(xDoc, vRutEmpr, vPeriInfo, vInstVers, pDireXbrl, vFile);
                }
                else
                {
                    LeerXBRL(xDoc, vRutEmpr, vPeriInfo, vInstVers, pDireXbrl, vFile);
                }
                validaConceptosCargados(vRutEmpr, vPeriInfo, vInstVers, vFile);
            }

            foreach (string vFile in Directory.GetFileSystemEntries(pDireXbrl))
            {
                if (vFile.Substring(vFile.LastIndexOf(".") + 1) == "zip")
                {
                    guardaBase64(vRutEmpr, vPeriInfo, vInstVers, vComp.CodificarArchivo(vFile), "XBRL_Temporal_" + vFile.Substring(vFile.LastIndexOf("\\") + 1), "zip");
                }
                File.Delete(vFile);
            }
            Directory.Delete(pDireXbrl);
            UpdEstadoVersInst(vRutEmpr, vPeriInfo, vInstVers, "C");
            Log.putLog("Carga Empresa: " + vRutEmpr + " Finalizada");
            Log.putLog("Generación HTML iniciada");
            UpdEstadoVersInst(vRutEmpr, vPeriInfo, vInstVers, "GI");
            //Empresas.ObtenerInfoEmpr(pCodiEmex, pCodiEmpr, vRutEmpr, vPeriInfo, vInstVers, pIFRS13);
            Empresas.ObtenerInfoEmprString(pCodiEmex, pCodiEmpr, vRutEmpr, vPeriInfo, vInstVers, pIFRS13);
            Log.putLog("Generación HTML finalizada");
            UpdEstadoVersInst(vRutEmpr, vPeriInfo, vInstVers, "G");

            #region envío correo
            if (vPais.Equals("COL"))
            {
                //Envío de correo si se detectan contextos "raros"
                string vMensaje = "";

                DataTable dtContextosTaxo = getContextosFechasPorTaxonomiaCOL(vPeriInfo, getVersTaxoCol());
                DataTable dtContextosVers = getContextosFechasPorEmprInstVers(vRutEmpr, vPeriInfo, vInstVers);

                for (int i = 0; i < dtContextosTaxo.Rows.Count; i++)
                {
                    DataRow[] drTemp = dtContextosVers.Select("fini_cntx = '" + dtContextosVers.Rows[i]["fini_cntx"].ToString() + "' and ffin_cntx = '" + dtContextosVers.Rows[i]["ffin_cntx"].ToString() + "'");
                    if (drTemp.Length == 0)
                    {
                        Console.Write("No se encontraron contextos con las fecha correspondientes al contexto " + dtContextosTaxo.Rows[i]["codi_cntx"].ToString() + " " + dtContextosTaxo.Rows[i]["fini_cntx"].ToString() + ", " + dtContextosTaxo.Rows[i]["ffin_cntx"].ToString());
                        vMensaje += "No se encontraron contextos con las fecha correspondientes al contexto " + dtContextosTaxo.Rows[i]["codi_cntx"].ToString() + " " + dtContextosTaxo.Rows[i]["fini_cntx"].ToString() + ", " + dtContextosTaxo.Rows[i]["ffin_cntx"].ToString();
                    }
                }

                DataTable dtFechaConc = con.TraerResultadosT0(vComp.getFechasConceptoPorEmpresaInstanciaVersion(vRutEmpr, vPeriInfo, vInstVers, "co-sfc-core", "NITEntidadinforma"));
                MantencionCntx mantCntx = new MantencionCntx();
                DataTable dtFechaTrimestreAcumuladoActual = mantCntx.getContextoFechas("0", "0", vPeriInfo, "TrimestreAcumuladoActual").Tables[0];

                if (dtFechaConc.Rows.Count == 1)
                {
                    if (dtFechaTrimestreAcumuladoActual.Rows.Count == 1)
                    {
                        if (!dtFechaConc.Rows[0]["fini_cntx"].ToString().Equals(dtFechaTrimestreAcumuladoActual.Rows[0]["fini_cntx"].ToString()) || !dtFechaConc.Rows[0]["ffin_cntx"].ToString().Equals(dtFechaTrimestreAcumuladoActual.Rows[0]["ffin_cntx"].ToString()))
                        {
                            Console.Write("El NIT de la entidad está informado con fechas " + dtFechaConc.Rows[0]["fini_cntx"].ToString() + ", " + dtFechaConc.Rows[0]["ffin_cntx"].ToString() + " las cuales no son las correctas");
                            vMensaje += "El NIT de la entidad está informado con fechas " + dtFechaConc.Rows[0]["fini_cntx"].ToString() + ", " + dtFechaConc.Rows[0]["ffin_cntx"].ToString() + " las cuales no son las correctas";
                        }
                    }
                    else
                    {
                        Log.putLog("Falta definir el TrimestreAcumuladoActual.");
                    }
                }
                else
                {
                    correo.enviarCorreoErrorXBRLColombia("Error detectade analizando XBRL " + vRutEmpr + ", " + vPeriInfo, "La empresa no informa el NIT");
                }

                if (vMensaje.Length != 0)
                {
                    correo.enviarCorreoErrorXBRLColombia("Contextos erróneos analizando XBRL " + vRutEmpr + ", " + vPeriInfo, vMensaje);
                }
            }
            #endregion
        }
        catch (Exception ex)
        {
            Log.putLog(ex.Message);
            Log.putLog(" Ocurrio un error cargando en archivo " + pDireXbrl.ToString());
        }
    }
    public string CargarXBRLExte(string pCodiEmex, string pCodiEmpr, string pCodiUsua, string vRutaTempW, string pFileName, bool IFRS13)
    {
        if (pFileName.ToLower().EndsWith(".zip"))
        {
            vMantIndi.EjecutaProceso("dbax.InserXBRLUsua.exe", pCodiEmex + " " + pCodiEmpr + " " + pCodiUsua + " " + vRutaTempW + " \"" + pFileName + "\" " + IFRS13);
            return "";
        }
        else
        {
            return "1";
        }
    }
    public string CargarXBRLExte(string pCodiEmex, string pCodiEmpr, string pCodiUsua, string vRutaTempW, string pFileName, bool IFRS13, string dbgx_empr, string dbgx_corr, string dbgx_vers)
    {
        if (pFileName.EndsWith(".zip"))
        {
            vMantIndi.EjecutaProceso("dbax.InserXBRLUsua.exe", pCodiEmex + " " + pCodiEmpr + " " + pCodiUsua + " " + vRutaTempW + " \"" + pFileName + "\" " + IFRS13 + " " + dbgx_empr + " " + dbgx_corr + " " + dbgx_vers);
            return "";
        }
        else
        {
            return "1";
        }
    }
    public DataTable GetEmpresaEstadoCargExte(string CodiEmex, string CodiEmpr, string pCodiUsua)
    {
        return con.TraerResultadosT0(genHtml.getEmpresaEstadoCargExte(CodiEmex, CodiEmpr, pCodiUsua));
    }
    public DataTable GetEmpresaEstadoCargExteVers(string CodiEmex, string CodiEmpr, string CodiPers, string CorrInst, string FechCarg, string pCodiUsua, string pDbgxEmpr, string pDbgxCorr, string pDbgxVers)
    {
        return con.TraerResultadosT0(genHtml.getEmpresaEstadoCargExteVers(CodiEmex, CodiEmpr, CodiPers, CorrInst, FechCarg, pCodiUsua, pDbgxEmpr, pDbgxCorr, pDbgxVers));
    }
    public string GetBase64HTMLExte(string vCodiPers, string vCorrInst)
    {
        return con.StringEjecutarQuery(vComp.GetBase64HTMLExte(vCodiPers, vCorrInst));
    }
    public string ValidaPermisoXBRLExte(string pCodiEmex,string pCodiEmpr,string pCodiUsua,string vRutaTempW, string pFileName)
    {
        string vCodiPers = string.Empty, vCorrInst = string.Empty,vEstaPerm;
        if (!vRutaTempW.EndsWith(Path.DirectorySeparatorChar.ToString()))
            vRutaTempW += Path.DirectorySeparatorChar.ToString();

        Random random = new Random();
        
        int randomNumber = random.Next(0, 10000);
        Console.WriteLine("Directorio temporal es " + vRutaTempW + "\\" + randomNumber);
        if (!Directory.Exists(vRutaTempW + "\\" + randomNumber))
        {
            Directory.CreateDirectory(vRutaTempW + "\\" + randomNumber);
        }
        DescomprimeXBRL(vRutaTempW + pFileName, vRutaTempW + "\\" + randomNumber);
        try
        {
            foreach (string item in Directory.GetFiles(vRutaTempW + "\\" + randomNumber))
            {
                if (Path.GetExtension(item).Contains("xbrl"))
                {
                    vCodiPers = item.Substring(item.LastIndexOf("\\") + 1, item.IndexOf("_") - item.LastIndexOf("\\") - 1);
                    vCorrInst = item.Substring(item.IndexOf("_") + 1, item.LastIndexOf("_") - item.IndexOf("_") - 1);
                    break;
                }
            }
        }
        catch(Exception ex)
        {
            Log.putLog("Hubo un problema descomprimiendo el archivo " + pFileName + " en ruta " + vRutaTempW + "\\" + randomNumber);
            Console.WriteLine("Hubo un problema descomprimiendo el archivo " + pFileName + " en ruta " + vRutaTempW + "\\" + randomNumber);
            Console.WriteLine(ex.Message);
            Console.WriteLine(ex.StackTrace);
        }
        Log.putLog(vMantIndi.GetPermusuaEmpr(pCodiEmex, vCodiPers, pCodiUsua));
        Log.putLog("vMantIndi.GetPermusuaEmpr(" + pCodiEmex + "," + vCodiPers + "," + pCodiUsua + ")");
        vEstaPerm = vMantIndi.GetPermusuaEmpr(pCodiEmex, vCodiPers, pCodiUsua);

        foreach (string item in Directory.GetFiles(vRutaTempW + "\\" + randomNumber))
        {
            File.Delete(item);
        }
        Directory.Delete(vRutaTempW + "\\" + randomNumber);

        if (vEstaPerm == "1")
        {
            if (!Directory.Exists(para.getPathXbrl() + vCodiPers + "_" + vCorrInst))
                Directory.CreateDirectory(para.getPathXbrl() + vCodiPers + "_" + vCorrInst);

            File.Delete(para.getPathXbrl() + vCodiPers + "_" + vCorrInst + Path.DirectorySeparatorChar + pFileName);
            File.Move(vRutaTempW + pFileName, para.getPathXbrl() + vCodiPers + "_" + vCorrInst + Path.DirectorySeparatorChar + pFileName);
            DescomprimeXBRL(para.getPathXbrl() + vCodiPers + "_" + vCorrInst + "\\" + pFileName, para.getPathXbrl() + vCodiPers + "_" + vCorrInst);
            //File.Delete(para.getPathXbrl() + vCodiPers + "_" + vCorrInst + "\\" + pFileName);
            return para.getPathXbrl() + vCodiPers + "_" + vCorrInst;
        }
        else
        {
            File.Delete(vRutaTempW + pFileName);
            return "1";
        }
    }
    public void UpdEstadoVersInst(string pCodiPers, string pCorrInst, string pVersInst, string pEstaVers)
    {
        con.EjecutarQuery(vComp.UpdEstadoVersInst(pCodiPers, pCorrInst, pVersInst, pEstaVers));
    }
    /// <summary>
    /// Inserta en tabla dbax_xbrl_repo la cantidad de xbrl que existen en un momento dado
    /// </summary>
    /// 
    public void insLinksXbrlReportados(string vCorrInst, DataTable dtLinks)
    {
        for (int i = 0; i < dtLinks.Rows.Count; i++)
        {
            con.EjecutarQuery(vComp.insLinksXbrlReportados(dtLinks.Rows[i]["Rut_Empr"].ToString(), dtLinks.Rows[i]["Estdo_Xbrl"].ToString(), dtLinks.Rows[i]["Analisis"].ToString(), dtLinks.Rows[i]["Declaracion"].ToString(), dtLinks.Rows[i]["Hechos"].ToString(), dtLinks.Rows[i]["Estdo_pdf"].ToString()));
        }
    }
    public void insCantidadXbrlReportados(string vCorrInst, string vCantXbrl)
    {
        con.EjecutarQuery(vComp.insCantidadXbrlReportados(vCorrInst, vCantXbrl));
    }
    public DataTable getContextosFechasPorTaxonomiaCOL(string pCorrInst, string pVersTaxo)
    {
        ModeloMantencionCntx cntx = new ModeloMantencionCntx();
        return con.TraerResultadosT0(cntx.getContextosFechasPorTaxonomiaCOL(pCorrInst, pVersTaxo));
    }
    public DataTable getContextosFechasPorEmprInstVers(string pCodiPers, string pCorrInst, string pVersInst)
    {
        ModeloMantencionCntx cntx = new ModeloMantencionCntx();
        return con.TraerResultadosT0(cntx.getContextosFechasPorEmprInstVers(pCodiPers, pCorrInst, pVersInst));
    }
    static string GetMd5Hash(string input)
    {
        using (MD5 md5Hash = MD5.Create())
        {
            // Convert the input string to a byte array and compute the hash.
            byte[] data = md5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));

            // Create a new Stringbuilder to collect the bytes
            // and create a string.
            StringBuilder sBuilder = new StringBuilder();

            // Loop through each byte of the hashed data 
            // and format each one as a hexadecimal string.
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            // Return the hexadecimal string.
            return sBuilder.ToString();
        }
    }
    static string HashAtributos(List<cEjesMiemb> lEjesMemb, string vFechIni, string vFechFina)
    {
        lEjesMemb.OrderBy(x => x.CODI_AXIS);
        string sEjesMemb = "";
        string sSalida = "";

        sEjesMemb += vFechIni + vFechFina;

        for (int i = 0; i < lEjesMemb.Count(); i++)
        {
            sEjesMemb += lEjesMemb[i].CODI_AXIS;
            sEjesMemb += lEjesMemb[i].CODI_MEMB;
        }

        //using (MD5 md5Hash = MD5.Create())
        //{
            sSalida = GetMd5Hash(sEjesMemb);
        //}

        return sSalida;
    }
}

public class cCntxStnd
{
    private string _CODI_CNTX = "";
    private string _CNTX_STND = "";
        
    public string CODI_CNTX { get { return this._CODI_CNTX; } set { this._CODI_CNTX = ""; if (value != null) { this._CODI_CNTX = value; } } }
    public string CNTX_STND { get { return this._CNTX_STND; } set { this._CNTX_STND = ""; if (value != null) { this._CNTX_STND = value; } } }
}

public class cEjesMiemb
{
    private string _CODI_AXIS = "";
    private string _CODI_MEMB = "";

    public string CODI_AXIS { get { return this._CODI_AXIS; } set { this._CODI_AXIS = ""; if (value != null) { this._CODI_AXIS = value; } } }
    public string CODI_MEMB { get { return this._CODI_MEMB; } set { this._CODI_MEMB = ""; if (value != null) { this._CODI_MEMB = value; } } }
}

public class cInstConc
{
    private string _FINI_CNTX = "";
    private string _FFIN_CNTX = "";
    private string _CODI_CONC = "";
    private string _VALO_CNTX = "";
    private string _DESC_CONC = "";
    private string _CODI_CNTX = "";
    private string _CNTX_STND = "";

    public string FINI_CNTX { get { return this._FINI_CNTX; } set { this._FINI_CNTX = string.Empty; if (value != null) { this._FINI_CNTX = value; } } }
    public string FFIN_CNTX { get { return this._FFIN_CNTX; } set { this._FFIN_CNTX = string.Empty; if (value != null) { this._FFIN_CNTX = value; } } }
    public string CODI_CONC { get { return this._CODI_CONC; } set { this._CODI_CONC = string.Empty; if (value != null) { this._CODI_CONC = value; } } }
    public string VALO_CNTX { get { return this._VALO_CNTX; } set { this._VALO_CNTX = string.Empty; if (value != null) { this._VALO_CNTX = value; } } }
    public string DESC_CONC { get { return this._DESC_CONC; } set { this._DESC_CONC = string.Empty; if (value != null) { this._DESC_CONC = value; } } }
    public string CNTX_STND { get { return this._CNTX_STND; } set { this._CNTX_STND = string.Empty; if (value != null) { this._CNTX_STND = value; } } }
    public string CODI_CNTX { get { return this._CODI_CNTX; } set { this._CODI_CNTX = string.Empty; if (value != null) { this._CODI_CNTX = value; } } }
}