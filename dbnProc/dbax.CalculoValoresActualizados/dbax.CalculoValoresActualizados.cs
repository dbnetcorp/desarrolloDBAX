using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CalculoValoresActualizados
{
    public class CalculoValoresActualizados
    {
        static string _gsCodiEmex = string.Empty, _gsCodiEmpr = string.Empty, _gsTipoTaxo = string.Empty, _gsSegmento = string.Empty, _gsPeriDesde = string.Empty, _gsPeriHasta = string.Empty, _gsPeriActual = string.Empty;

        static void Main(string[] args)
        {
            try
            {
                if (args.Length != 7)
                {   Log.putError("----**********----"); 
                    Log.putError("Faltan parámetros"+ args.Length.ToString()); 
                    Environment.Exit(-1);
                }
                _gsCodiEmex = args[0];
                _gsCodiEmpr = args[1];
                _gsTipoTaxo = args[2];
                _gsSegmento = args[3];
                _gsPeriDesde = args[4];
                _gsPeriHasta = args[5];
                _gsPeriActual = args[6];
                CalculoValoresActualizadosC calValActu = new CalculoValoresActualizadosC();
                DataTable dtEmpresas = calValActu.getEmpresas(_gsTipoTaxo,_gsSegmento,"",_gsCodiEmpr,_gsCodiEmex);

                try
                {

                    Log.putLog("-------*******************************----------");
                    Log.putLog("Se Inicia el Proceso de Calculo Valores Actualizados");
                    //for (int i = 0; i < dtEmpresas.Rows.Count; i++)
                    //{
                        //Log.putLog("Realizando Calculo Valores Actualizados: [" + dtEmpresas.Rows[i]["codi_pers"].ToString() + "] [" + _gsCodiEmex + "] [" + Convert.ToInt32(_gsCodiEmpr) + "]");
                        Log.putLog("Realizando Calculo Valores Actualizados: [" + _gsSegmento + "]");// [" + _gsCodiEmex + "] [" + Convert.ToInt32(_gsCodiEmpr) + "]");
                        calValActu.CambioValores(_gsCodiEmex, _gsCodiEmpr, _gsSegmento, _gsPeriDesde, _gsPeriHasta, _gsPeriActual);
                    //} 
                    Log.putLog("Calculo de Valores Actualizados, ha terminado.");
                    Log.putLog("-------*******************************----------");
                }
                catch (Exception ex)
                {
                    Log.putError(ex.Message);
                }
            }
            catch (Exception ex)
            {Log.putError("Error al obtener los datos. " + ex.Message);}
        }
    }

    public class Log
    {
        public static string _Error;
        public static void putError(string pTexto)
        {
            _Error = pTexto.Replace("'", "");
            putLog("ERROR : " + pTexto);
        }
        public static void putLog(string pTexto)
        {
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

                cmd = "CalculoValoresActualizados.log";
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
