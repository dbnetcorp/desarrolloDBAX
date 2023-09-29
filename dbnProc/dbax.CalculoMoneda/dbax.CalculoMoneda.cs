using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Xml;

namespace CalculoMoneda
{
    public class CalculoMoneda
    {
        static string gsCodiEmex = "", gsCodiEmpr = "", gsCorrInst = "", gsCodiGrup = "", gsCodiSegm = "", gsCodiIndi = "";

        static void Main(string[] args)
        {
            if (args.Length != 6)
            { Console.WriteLine("Faltan Parámetros " + args.Length.ToString()); Environment.Exit(-1); }
            gsCodiEmex = args[0];
            gsCodiEmpr = args[1];
            gsCorrInst = args[2];
            gsCodiGrup = args[3];
            gsCodiSegm = args[4];
            gsCodiIndi = args[5];
            CalculoMonedaC calcMone = new CalculoMonedaC();
            DataTable dtEmpresas = new DataTable();

            string vCodiEmpr = "";
            string vVersInst = "";

            try
            {
                Log.putLog("-------*******************************----------");
                Log.putLog("Se Inicia el Proceso de Conversión de Moneda");


                //for (int i = 0; i < dtEmpresas.Rows.Count; i++)
                //{
                //    if (dtEmpresas.Rows[i]["codi_pers"].Equals("966831201"))
                //    {
                //        vCodiEmpr = dtEmpresas.Rows[i]["codi_pers"].ToString();
                //        vVersInst = dtEmpresas.Rows[i]["vers_inst"].ToString();
                //        Log.putLog("Realizando Conversión de Moneda: [" + vCodiEmpr + "] [" + gsCorrInst + "] [" + Convert.ToInt32(vVersInst) + "] [" + gsCodiEmex + "] [" + Convert.ToInt32(gsCodiEmpr) + "]");
                //        calcMone.getCambioMoneda(dtEmpresas.Rows[i]["codi_pers"].ToString(), Convert.ToInt32(gsCorrInst), Convert.ToInt32(dtEmpresas.Rows[i]["vers_inst"].ToString()), gsCodiEmex, Convert.ToInt32(gsCodiEmpr));
                //    }

                //    Log.putLog("Fin");
                //}
                Correo vCorreo = new Correo();
                DataTable vMonedas = calcMone.getEstadoMonedas(gsCorrInst);
                if (vMonedas.Rows.Count < 2)
                {
                    int vMonth;
                    int vYear;
                    int vDays;
                    int vDaysTemp;

                    vMonth = Convert.ToInt16(gsCorrInst.Substring(4, 2));
                    vYear = Convert.ToInt16(gsCorrInst.Substring(0, 4));
                    vDays = System.DateTime.DaysInMonth(vYear, vMonth);

                    string sMonth = vMonth.ToString();
                    string sDays = vDays.ToString();

                    if (vMonth < 10)
                        sMonth = "0" + vMonth.ToString();
                    
                    if (vDays < 10)
                        sDays = "0" + vDays.ToString();

                    //La ruta siguiente la cambié por una de la sbif (más abajo)
                    string apiUrl = "http://mindicador.cl/api/uf/" + sDays + "-" + sMonth + "-" + vYear; 
                    string jsonString = "{}";
                    WebClient http = new WebClient();
                    //JavaScriptSerializer jss = new JavaScriptSerializer();

                    //http.Headers.Add(HttpRequestHeader.Accept, "application/json");
                    //jsonString = http.DownloadString(apiUrl);

                    //string vValorUF = jsonString.Substring(jsonString.IndexOf("valor") + 7, jsonString.LastIndexOf("}]}") - (jsonString.IndexOf("valor") + 7));

                    /*
                    apiUrl = "http://mindicador.cl/api/dolar/" + sDays + "-" + sMonth + "-" + vYear;
                    jsonString = http.DownloadString(apiUrl);
                    string vValorDolar = jsonString.Substring(jsonString.IndexOf("valor") + 7, jsonString.LastIndexOf("}]}") - (jsonString.IndexOf("valor") + 7));
                    */
                    XmlDocument xDoc = new XmlDocument();

                    //Esta key es necesaria para utilizar la API del SBIF
                    //http://api.sbif.cl/documentacion/
                    string vApiKey = "af0fd34a1865ded72a53b56d7edde2ce1081edd8";
                    apiUrl = "http://api.sbif.cl/api-sbifv3/recursos_api/uf/" + vYear + "/" + sMonth + "/dias/" + sDays + "?apikey=" + vApiKey + "&formato=xml";
                    Log.putLog("UF Intentando consumir " + apiUrl);
                    jsonString = http.DownloadString(apiUrl);
                    xDoc.LoadXml(jsonString);
                    string vValorUF = xDoc.GetElementsByTagName("Valor")[0].InnerXml;
                    Log.putLog("Se obtuvo el valor de UF: " + vValorUF);

                    string vValorDolar = "";
                    vDaysTemp = vDays;
                    //Hago un ciclo para que, si el 
                    do
                    {
                        apiUrl = "http://api.sbif.cl/api-sbifv3/recursos_api/dolar/" + vYear + "/" + sMonth + "/dias/" + vDaysTemp + "?apikey=" + vApiKey + "&formato=xml";
                        Log.putLog("USD Intentando consumir " + apiUrl);
                        try
                        {
                            jsonString = http.DownloadString(apiUrl);
                            xDoc.LoadXml(jsonString);

                            vValorDolar = xDoc.GetElementsByTagName("Valor")[0].InnerXml;
                        }
                        catch
                        {
                            Log.putLog("No se logró obtener el valor para el dolar para " + vYear + sMonth + vDaysTemp + ". Intentando con el día anterior");
                            vDaysTemp = (Convert.ToInt16(vDaysTemp) - 1);
                            vValorDolar = "";
                        }
                    } while (vValorDolar == "");

                    //Log.putLog("Se obtuvo el valor de USD: " + vValorUF);
                    //Response.Write("El valor actual de la UF es $" + dailyIndicators["uf"]["valor"]);
                    //

                    if (vValorDolar.Length < 3 || vValorUF.Length < 3)
                    {
                        Log.putError("No se han definido todas las monedas requeridas para el período " + gsCorrInst);
                        vCorreo.enviarCorreo("Error en conversión de moneda", "No se han definido todas las monedas requeridas para el período " + gsCorrInst);
                        Environment.Exit(-1);
                    }
                    else
                    {
                        Console.WriteLine("Insertando monedas rescatadas desde sbif <" + vValorDolar + " - " + vValorUF + ">");
                        Log.putLog("Insertando monedas rescatadas desde sbif <" + vValorDolar + " - " + vValorUF + ">");
                        calcMone.insValorMoneda("1", "CLP", "CLF", vYear + "-" + sMonth + "-" + sDays + " 00:00:00.000", vValorUF.Replace(".","").Replace(",","."));
                        calcMone.insValorMoneda("1", "CLP", "USD", vYear + "-" + sMonth + "-" + sDays + " 00:00:00.000", vValorDolar.Replace(".","").Replace(",", "."));

                        vCorreo.enviarCorreo("Se insertaron automáticamente los tipos de cambio " + gsCorrInst, "Se han actualizado los valores para el periodo " + gsCorrInst + ". Dolar <" + vValorDolar + ">. UF <" + vValorUF + ">");
                    }
                }


                dtEmpresas = calcMone.getCodigosEmpresaSinActualizar(gsCorrInst);
                List<string> vListEmpresasError = new List<string>();
                Log.putLog("Se Inicia el Proceso de Conversión de Moneda mejorado");
                for (int i = 0; i < dtEmpresas.Rows.Count; i++)
                {
                    int cnt = 0;
                    /*if (dtEmpresas.Rows[i]["codi_pers"].ToString() == "61106000")
                        Console.Write("a.oae");*/
                    vCodiEmpr = dtEmpresas.Rows[i]["codi_pers"].ToString();
                    vVersInst = dtEmpresas.Rows[i]["vers_inst"].ToString();
                    Log.putLog("Realizando Conversión de Moneda: [" + vCodiEmpr + "] [" + gsCorrInst + "] [" + Convert.ToInt32(vVersInst) + "] [" + gsCodiEmex + "] [" + Convert.ToInt32(gsCodiEmpr) + "]");
                    DataTable dtRes = new DataTable();
                    while (cnt < 3)
                    {
                        try
                        {
                            dtRes = calcMone.getCambioMoneda2(dtEmpresas.Rows[i]["codi_pers"].ToString(), Convert.ToInt32(gsCorrInst), Convert.ToInt32(dtEmpresas.Rows[i]["vers_inst"].ToString()));
                            cnt = 3;
                        }
                        catch (Exception ex)
                        {
                            cnt++;
                        }
                    }

                    if (dtRes.Rows[0][0].ToString() == "-1")
                        vListEmpresasError.Add(dtEmpresas.Rows[i]["codi_pers"].ToString());
                    Log.putLog("Fin");
                }

                if (vListEmpresasError.Count > 0)
                {
                    string empresas = "";
                    for (int i = 0; i < vListEmpresasError.Count; i++)
                    {
                        empresas += vListEmpresasError[i] +",";
                    }

                    vCorreo.enviarCorreo("Error en conversión de moneda " + gsCorrInst, "Las siguientes empresas no pudieron ser convertidas en el periodo " + gsCorrInst + ": " + empresas);
                }

                Log.putLog("Conversión de Moneda Terminada");
                Log.putLog("-------*******************************----------");
            }
            catch (Exception ex)
            {
                Log.putError(ex.Message);
                Log.putError("Error en conversión de Moneda: [" + vCodiEmpr + "] [" + gsCorrInst + "] [" + Convert.ToInt32(vVersInst) + "] [" + gsCodiEmex + "] [" + Convert.ToInt32(gsCodiEmpr) + "]");
                Correo vCorreo = new Correo();
                vCorreo.enviarCorreo("Error en conversión de moneda " + gsCorrInst, ex.Message + " ### " + "Error en conversión de Moneda: [" + vCodiEmpr + "] [" + gsCorrInst + "] [" + Convert.ToInt32(vVersInst) + "] [" + gsCodiEmex + "] [" + Convert.ToInt32(gsCodiEmpr) + "]");
            }

        }
    }

    public class Log
    {
        public static string _Error;
        public static void putError(string pTexto)
        {
            Console.WriteLine(pTexto);
            _Error = pTexto.Replace("'", "");
            putLog("ERROR : " + pTexto);
        }
        public static void putLog(string pTexto)
        {
            Console.WriteLine(pTexto);
            string vFileName;
            string vFecha = System.DateTime.Now.Year.ToString("0000") + "-" +
                            System.DateTime.Now.Month.ToString("00") + "-" +
                            System.DateTime.Now.Day.ToString("00") + " " +
                            System.DateTime.Now.Hour.ToString("00") + ":" +
                            System.DateTime.Now.Minute.ToString("00") + ":" +
                            System.DateTime.Now.Second.ToString("00") + " ";

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

            try
            {
                string[] cmds = Environment.GetCommandLineArgs();
                string cmd = cmds[0].Split('\\')[cmds[0].Split('\\').Length - 1];
                cmd = cmd.Replace(".exe", "");

                cmd = "CambioMoneda.log";
                vFileName = vPathBackEnd + "log\\" + cmd;
            }
            catch (Exception ex)
            {
                try
                {
                    string[] cmds = Environment.GetCommandLineArgs();
                    string cmd = cmds[0].Split('\\')[cmds[0].Split('\\').Length - 1];
                    cmd = cmd.Replace(".exe", ".log");
                    vFileName = vPathBackEnd + "log\\" + cmd;
                }
                catch
                {
                    vFileName = vPathBackEnd + "log\\dbnet.log";
                    Console.WriteLine(ex.Message);
                }
            }
            using (System.IO.TextWriter streamWriter = new System.IO.StreamWriter(vFileName, true))
            {
                streamWriter.WriteLine(vFecha + pTexto);
            }
        }
    }
}
