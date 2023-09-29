using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NCalc;
using System.Data;


namespace CalculoIndicadores
{
    class CalculoIndicadores
    {
        //static private string pCodiEmpr = "0";
        static string pCodiEmex = "1", pCodiEmpr = "1";
        static int pCorrInst = 0;
        static string pCodiGrup = "0", pCodiSegm = "0", pCodiIndi = "", pTipoTaxo = "", pCodiUsua = "";
        //static string codi_conc = "", pref_conc = "", letr_vali = "", diai_cntx = "", anoi_cntx = "", diat_cntx = "", anot_cntx = "", Fecha_Inicio = "", Fecha_Termino = "", Valo_Cntx = "";
        static string Codi_cntx = "";
        static string Codi_unit = "";
        static string MensajeCorreo = "";
        static void Main(string[] args)
        {
            try
            {
                MantencionIndicadores Indicador = new MantencionIndicadores();
                GeneracionExcel Empresas = new GeneracionExcel();
                MantencionParametros para = new MantencionParametros();

                if (args.Length < 7)
                {
                    Console.WriteLine("Numero incorrecto de parámetros, se informaron " + args.Length);

                    foreach (string parametro in args)
                    {
                        Console.WriteLine(parametro);
                    }
                    Environment.Exit(-1);
                }

                pCodiEmex = args[0];
                pCodiEmpr = args[1];
                pCorrInst = Convert.ToInt32(args[2]);
                pCodiGrup = args[3];
                pCodiSegm = args[4];
                pCodiIndi = args[5];
                pTipoTaxo = args[6];

                if (args.Length == 8)
                {
                    pCodiUsua = args[7];
                }

                para.SP_AX_insEstadoBarra("Proc", "Proceso de calculo de indicadores iniciado.", "N", pCodiUsua);

                foreach (string parametro in args)
                {
                    Log.putLog(parametro);
                }
                
                DataTable dtIndicadores = Indicador.getListaIndicadores(pCodiEmex, pCodiEmpr, "", pCodiIndi);
                
                for (int i = 0; i < dtIndicadores.Rows.Count; i++)
                {
                    try
                    {
                        string vIndicador = dtIndicadores.Rows[i]["Nombre"].ToString();
                        Log.putLog("Calculo Indicador : " + vIndicador);
                        CalculadorIndicadorCorregido(vIndicador);
                        Log.putLog("Fin Calculo Indicador : " + vIndicador);
                    }
                    catch (Exception e)
                    {
                        string var = e.ToString();
                        Indicador.BorraTempIndi();
                        //Log.enviarCorreo("Problema calculando indicador " + dtIndicadores.Rows[i]["Nombre"].ToString() + " en " + pCorrInst + ", " + e.Message);
                        MensajeCorreo += '\n' + "Problema calculando indicador " + dtIndicadores.Rows[i]["Nombre"].ToString() + " en " + pCorrInst + ", " + e.Message;
                    }
                }

                if(MensajeCorreo.Length>0)
                    Log.enviarCorreo(MensajeCorreo);

                para.SP_AX_insEstadoBarra("OK", "Proceso de calculo de indicadores finalizado.", "S", pCodiUsua);
            }
            catch (Exception e)
            {
                string var = e.ToString();
                MantencionIndicadores Indicador = new MantencionIndicadores();
                Indicador.BorraTempIndi();
                //Log.enviarCorreo("Problema general en CalculoIndicarores (Main) " + pCorrInst + ", " + e.Message);
                MensajeCorreo += '\n' + "Problema general en CalculoIndicarores (Main) " + pCorrInst + ", " + e.Message;
            }
        }// fin main
        // Metodo corregido para calcular conceptos Indicadores
        static void CalculadorIndicadorCorregido(string pIndicador)
        {
            string codi_conc = "", pref_conc = "", letr_vali = "", diai_cntx = "", anoi_cntx = "", diat_cntx = "", anot_cntx = "", Fecha_Inicio = "", Fecha_Termino = "", Valo_Cntx = "";
            try
            {
                Log.putLog("Calculando indicador [" + pIndicador + "]");

                MantencionIndicadores Indicador = new MantencionIndicadores();
                GeneracionExcel Empresas = new GeneracionExcel();
                MantencionCntx Cntx = new MantencionCntx();
                CalculoMonedaC calcMone = new CalculoMonedaC();
                DataTable dtIndicadores = Indicador.getListaIndicadores(pCodiEmex, pCodiEmpr, "", pIndicador);
                Log.putLog("Se calculará " + dtIndicadores.Rows.Count + " indicadores");

                if (dtIndicadores.Rows.Count == 0)
                    Log.putLog("Indicador.getListaIndicadores(" + pCodiEmex + "," + pCodiEmpr + ",\"\"," + pIndicador + ");");

                DataTable dtEmpresas = Empresas.GetEmpresas(pCodiEmex, pCodiEmpr, pCorrInst.ToString(), "", pCodiGrup, pCodiSegm, pTipoTaxo, "P").Tables[0];
                Log.putLog("Se obtuvieron " + dtEmpresas.Rows.Count + " empresas");

                if (dtEmpresas.Rows.Count == 0)
                    Log.putLog("Empresas.GetEmpresas(" + pCodiEmex + "," + pCodiEmpr + "," + pCorrInst.ToString() + ", \"\"," + pCodiGrup + ", " + pCodiSegm + ", " + pTipoTaxo + ", \"P\")");

                DataTable dtDetalle = Indicador.getDetalleIndicador(dtIndicadores.Rows[0]["codi_emex"].ToString(), dtIndicadores.Rows[0]["codi_empr"].ToString(), pCorrInst, pIndicador);
                if (dtDetalle.Rows.Count == 0)
                {
                    MensajeCorreo= "El indicador " + pIndicador + " no tiene conceptos asociados a las variables de la fórmula: " + dtIndicadores.Rows[0]["Fórmula"].ToString();
                    return;
                }
                Log.putLog("Del indicador se obtuvieron " + dtDetalle.Rows.Count + " registros de detalle");

                if (dtDetalle.Rows.Count == 0)
                    Log.putLog("Indicador.getDetalleIndicador(" + dtIndicadores.Rows[0]["codi_emex"].ToString() + "," + dtIndicadores.Rows[0]["codi_empr"].ToString() + ", " + pCorrInst + "," + pIndicador + ");");

                Expression formula = new Expression(dtIndicadores.Rows[0]["Fórmula"].ToString());

                DataTable valor_cntx = new DataTable();
                for (int e = 0; e < dtEmpresas.Rows.Count; e++)
                {
                    try
                    {
                        string vPersona = dtEmpresas.Rows[e]["codi_pers"].ToString();
                        string vVersInst = dtEmpresas.Rows[e]["vers_inst"].ToString();
                        Log.putLog("Versión:" + vVersInst);
                        if (vVersInst != "")
                        {
                            Log.putLog("Evaluando empresa " + vPersona + " y versión " + vVersInst);
                            DataTable dtContextos = Cntx.getCntxActuales(vPersona, pCorrInst.ToString(), vVersInst);
                            //Log.putLog("Sociedad:[" + vPersona + "] Version:[" + vVersInst + "]" + "Contextos:[" + dtContextos.Rows.Count.ToString() + "]");
                            Log.putLog("Sociedad:[" + vPersona + "] Version:[" + vVersInst + "]");

                            //for (int c = 0; c < dtContextos.Rows.Count; c++)
                            //{
                            //if (e == 15)
                            //    Console.WriteLine(e);
                            for (int j = 0; j < dtDetalle.Rows.Count; j++)
                            {
                                DataRow dx = dtDetalle.Rows[j];
                                pref_conc = dx["pref_conc"].ToString();
                                codi_conc = dx["codi_conc"].ToString();
                                letr_vali = dx["letr_vari"].ToString();
                                diai_cntx = dx["diai_cntx"].ToString();
                                anoi_cntx = dx["anoi_cntx"].ToString();
                                diat_cntx = dx["diat_cntx"].ToString();
                                anot_cntx = dx["anot_cntx"].ToString();
                                Codi_cntx = dx["codi_cntx"].ToString();
                                var Inicio = System.DateTime.Now;
                                Console.WriteLine("Indicador.GetValoCntx("+dtEmpresas.Rows[e]["codi_pers"].ToString()+", "+pCorrInst.ToString()+", "+vVersInst+", "+pref_conc+", "+codi_conc+", "+dtDetalle.Rows[j]["fini_cntx"].ToString()+", "+dtDetalle.Rows[j]["ffin_cntx"].ToString());
                                valor_cntx = Indicador.GetValoCntx(dtEmpresas.Rows[e]["codi_pers"].ToString(), pCorrInst.ToString(), vVersInst, pref_conc, codi_conc, dtDetalle.Rows[j]["fini_cntx"].ToString(), dtDetalle.Rows[j]["ffin_cntx"].ToString());
                                var Termino = System.DateTime.Now;
                                Console.WriteLine(Termino - Inicio);
                                if (pref_conc == "indi" && valor_cntx.Rows.Count < 1)
                                {
                                    CalculadorIndicadorCorregido(vPersona, vVersInst, codi_conc);
                                    valor_cntx = Indicador.GetValoCntx(dtEmpresas.Rows[e]["codi_pers"].ToString(), pCorrInst.ToString(), vVersInst, pref_conc, codi_conc, dtDetalle.Rows[j]["fini_cntx"].ToString(), dtDetalle.Rows[j]["ffin_cntx"].ToString());
                                }

                                if (valor_cntx.Rows.Count == 0)
                                {
                                    Valo_Cntx = "0";
                                    formula.Parameters[letr_vali] = new Expression(Valo_Cntx);
                                }
                                else
                                {
                                    DataRow vct = valor_cntx.Rows[0];
                                    Valo_Cntx = vct["valo_cntx"].ToString();
                                    Codi_unit = vct["codi_unit"].ToString();
                                    formula.Parameters[letr_vali] = new Expression(Valo_Cntx);
                                }
                            }

                            string valor = "";
                            Int64 Entero64;
                            Double Doble;
                            var resultado = formula.Evaluate();
                            valor = resultado.ToString();

                            if (valor == "NeuN")
                            {
                                Log.putLog("[" + Codi_cntx + "] : No se pudo calcular el valor para el indicador");
                            }
                            else
                            {
                                /*if (dtEmpresas.Rows[e]["codi_pers"].ToString() == "61105000")
                                    Console.WriteLine("asdasd");
                                */
                                if (Double.Parse(resultado.ToString()) % 1 == 0)
                                {
                                    Entero64 = (Int64)Double.Parse(resultado.ToString().Replace(".", ","));
                                    valor = Entero64.ToString();
                                }
                                else
                                {
                                    Doble = Double.Parse(resultado.ToString().Replace(".", ",")); ;
                                    valor = Doble.ToString();
                                }

                                for (int w = 0; w < dtContextos.Rows.Count; w++)
                                {
                                    Indicador.InsValoresIndicadores(dtEmpresas.Rows[e]["codi_pers"].ToString(), pCorrInst.ToString(), vVersInst, pIndicador, dtContextos.Rows[w]["codi_cntx"].ToString(), valor, Codi_unit);
                                    Log.putLog("Se inserta valor: " + dtEmpresas.Rows[e]["codi_pers"].ToString() + "," + pCorrInst.ToString() + "," + vVersInst + "," + pIndicador + "," + dtContextos.Rows[w]["codi_cntx"].ToString() + "," + valor + "," + Codi_unit);
                                    calcMone.getCambioMoneda(dtEmpresas.Rows[e]["codi_pers"].ToString(), Convert.ToInt32(pCorrInst), Convert.ToInt32(vVersInst), pCodiEmex, Convert.ToInt32(pCodiEmpr), "indi", pIndicador);
                                    /*if (w == 0)
                                    {
                                        Log.putLog("Insertando Anomalias indicador: " + pIndicador);
                                        Log.putLog(dtEmpresas.Rows[e]["codi_pers"].ToString() + "," + pCorrInst.ToString() + "," + vVersInst + "," + pIndicador + "," + dtContextos.Rows[w]["codi_cntx"].ToString() + "," + valor + "," + dtIndicadores.Rows[0]["refe_mini"].ToString() + "," + dtIndicadores.Rows[0]["refe_maxi"].ToString());
                                        Indicador.InsAnomaliasIndicadores(dtEmpresas.Rows[e]["codi_pers"].ToString(), pCorrInst.ToString(), vVersInst, pIndicador, dtContextos.Rows[w]["codi_cntx"].ToString(), valor, dtIndicadores.Rows[0]["refe_mini"].ToString(), dtIndicadores.Rows[0]["refe_maxi"].ToString());
                                       
                                    }*/

                                }
                            }

                            //}
                        }
                    }
                    catch (Exception ex)
                    {
                        //Log.enviarCorreo("Problema calculando indicador (CalculadorIndicadorCorregido(string pIndicador)) para " + pIndicador + ", " + dtEmpresas.Rows[e]["codi_pers"].ToString() + ", " + pCorrInst + ", " + ex.Message);
                        MensajeCorreo += '\n' + "Problema calculando indicador (CalculadorIndicadorCorregido(string pIndicador)) para " + pIndicador + ", " + dtEmpresas.Rows[e]["codi_pers"].ToString() + ", " + pCorrInst + ", " + ex.Message;
                    }
                }
            }
            catch (Exception ex)
            {
                Log.putLog("Ocurrió un error calculando el indicador");
                string var = ex.ToString();
                MantencionIndicadores Indicador = new MantencionIndicadores();
                Indicador.BorraTempIndi();
                //Log.enviarCorreo("Problema general calculando indicador (CalculadorIndicadorCorregido(string pIndicador)) para " + pIndicador + ", " + pCorrInst + ": " + ex.Message + " : " + ex.StackTrace.ToString());
                MensajeCorreo += '\n' + "Problema general calculando indicador (CalculadorIndicadorCorregido(string pIndicador)) para " + pIndicador + ", " + pCorrInst + ": " + ex.Message + " : " + ex.StackTrace.ToString();
            }
        }
        static void CalculadorIndicadorCorregido(string vPersona, string vVersInst, string pIndicador)
        {
            string codi_conc = "", pref_conc = "", letr_vali = "", diai_cntx = "", anoi_cntx = "", diat_cntx = "", anot_cntx = "", Fecha_Inicio = "", Fecha_Termino = "", Valo_Cntx = "";
            try
            {
                Log.putLog("Calculando indicador [" + pIndicador + "]");

                MantencionIndicadores Indicador = new MantencionIndicadores();
                GeneracionExcel Empresas = new GeneracionExcel();
                MantencionCntx Cntx = new MantencionCntx();
                CalculoMonedaC calcMone = new CalculoMonedaC();

                DataTable dtIndicadores = Indicador.getListaIndicadores(pCodiEmex, pCodiEmpr, "", pIndicador);
                DataTable dtDetalle = Indicador.getDetalleIndicador(dtIndicadores.Rows[0]["codi_emex"].ToString(), dtIndicadores.Rows[0]["codi_empr"].ToString(), pCorrInst, pIndicador);
                Expression formula = new Expression(dtIndicadores.Rows[0]["Fórmula"].ToString());

                // Esta malo no debe ir por contexto, debe ir por fecha
                DataTable valor_cntx = new DataTable();
                //for (int e = 0; e < dtEmpresas.Rows.Count; e++)
                //{
                //string vPersona = dtEmpresas.Rows[e]["codi_pers"].ToString();
                //string vVersInst = dtEmpresas.Rows[e]["vers_inst"].ToString();

                //if (vVersInst != "")
                //{
                DataTable dtContextos = Cntx.getCntxActuales(vPersona, pCorrInst.ToString(), vVersInst);
                //Log.putLog("Sociedad:[" + vPersona + "] Version:[" + vVersInst + "]" + "Contextos:[" + dtContextos.Rows.Count.ToString() + "]");
                Log.putLog("Sociedad:[" + vPersona + "] Version:[" + vVersInst + "]");

                //for (int c = 0; c < dtContextos.Rows.Count; c++)
                //{
                for (int j = 0; j < dtDetalle.Rows.Count; j++)
                {

                    DataRow dx = dtDetalle.Rows[j];
                    pref_conc = dx["pref_conc"].ToString();
                    codi_conc = dx["codi_conc"].ToString();
                    letr_vali = dx["letr_vari"].ToString();
                    diai_cntx = dx["diai_cntx"].ToString();
                    anoi_cntx = dx["anoi_cntx"].ToString();
                    diat_cntx = dx["diat_cntx"].ToString();
                    anot_cntx = dx["anot_cntx"].ToString();
                    Codi_cntx = dx["codi_cntx"].ToString();

                    valor_cntx = Indicador.GetValoCntx(vPersona, pCorrInst.ToString(), vVersInst, pref_conc, codi_conc, dtDetalle.Rows[j]["fini_cntx"].ToString(), dtDetalle.Rows[j]["ffin_cntx"].ToString());

                    if (pref_conc == "indi" && valor_cntx.Rows.Count < 1)
                    {
                        CalculadorIndicadorCorregido(vPersona, vVersInst, codi_conc);
                        valor_cntx = Indicador.GetValoCntx(vPersona, pCorrInst.ToString(), vVersInst, pref_conc, codi_conc, dtDetalle.Rows[j]["fini_cntx"].ToString(), dtDetalle.Rows[j]["ffin_cntx"].ToString());
                    }

                    if (valor_cntx.Rows.Count == 0)
                    {
                        Valo_Cntx = "0";
                        formula.Parameters[letr_vali] = new Expression(Valo_Cntx);
                    }
                    else
                    {
                        DataRow vct = valor_cntx.Rows[0];
                        Valo_Cntx = vct["valo_cntx"].ToString();
                        Codi_unit = vct["codi_unit"].ToString();
                        formula.Parameters[letr_vali] = new Expression(Valo_Cntx);
                    }


                    string valor;
                    double dValor = Convert.ToDouble(formula.Evaluate());

                    valor = dValor.ToString();

                    if (valor == "NeuN")
                    {
                        Log.putLog("[" + Codi_cntx + "] : No se pudo calcular el valor para el indicador");
                    }
                    else
                    {
                        for (int w = 0; w < dtContextos.Rows.Count; w++)
                        {
                            Indicador.InsValoresIndicadores(vPersona, pCorrInst.ToString(), vVersInst, pIndicador, dtContextos.Rows[w]["codi_cntx"].ToString(), valor, Codi_unit);
                            calcMone.getCambioMoneda(vPersona, Convert.ToInt32(pCorrInst), Convert.ToInt32(vVersInst), pCodiEmex, Convert.ToInt32(pCodiEmpr), "indi", pIndicador);
                        }
                    }

                }

                //}
                //}
                //}
            }
            catch (Exception e)
            {
                string var = e.ToString();
                MantencionIndicadores Indicador = new MantencionIndicadores();
                Indicador.BorraTempIndi();
                //Log.enviarCorreo("Problema general calculando indicador (CalculadorIndicadorCorregido(string vPersona, string vVersInst, string pIndicador)) para " + vPersona + ", " + pIndicador + ", " + pCorrInst + ", " + e.Message);
                MensajeCorreo += '\n' + "Problema general calculando indicador (CalculadorIndicadorCorregido(string vPersona, string vVersInst, string pIndicador)) para " + vPersona + ", " + pIndicador + ", " + pCorrInst + ", " + e.Message;
            }
        }
        // Metodo para calcular conceptos Indicadores
    } // fin clase
} // fin namespace