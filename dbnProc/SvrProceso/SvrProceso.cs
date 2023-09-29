using System;
using System.Diagnostics;
using System.ServiceProcess;
using System.IO;
using System.Timers;
using System.Data;
using System.Security.Principal;


namespace SvrProceso
{
    public partial class SvrProceso : ServiceBase
    {
        UsuarioSistema usu = new UsuarioSistema();
        MantencionParametros para = new MantencionParametros();
        public SvrProceso()
        {
            InitializeComponent();
        }

        private System.Timers.Timer temporizador;
        private int intervalo = 5000;
        int numErrores = 0;
        string query, query2;

        protected override void OnStart(string[] args)
        {
            Log.putLog("Servicio de Procesos Iniciado en " + Environment.MachineName.ToString());
            temporizador = new System.Timers.Timer(intervalo);
            this.temporizador.Elapsed += new ElapsedEventHandler(this.temporizador_Elapsed);
            temporizador.Start();
        }

        protected override void OnStop()
        {
            // Agregar código aquí para realizar cualquier anulación necesaria para detener el servicio.
            Log.putLog("Servicio de Procesos Finalizado en " + WindowsIdentity.GetCurrent().Name.ToString());
            temporizador.Stop();
        }

        private void temporizador_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            string vCodiProc = "0";
            string vProgProc;
            string vArgsProc;
            string vId;
            string vFrom;
            string vTo;
            string vCc;
            string vBCc;
            string vSubject;
            string vText;
            string vRutaBin;
            string vRutaText;
            numErrores = 0;
            temporizador.Enabled = false;

            try
            {
                vRutaBin = para.getPathBina();
                DataTable dt = usu.SP_AX_getProcesosPendientes().Tables[0];
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow dr = dt.Rows[i];
                    vCodiProc = dr["codi_proc"].ToString();
                    vProgProc = dr["prog_proc"].ToString();
                    vArgsProc = dr["args_proc"].ToString();

                    Log.putLog("Iniciando proceso " + vCodiProc + " - " + vProgProc + " " + vArgsProc);
                    usu.UpdEstadoServicio("P", vCodiProc, "");
                    Log.putLog("Proceso " + vCodiProc + " iniciado : " + vProgProc + " " + vArgsProc);
                    
                    Process proceso = new Process();
                    proceso.StartInfo.FileName = vProgProc;
                    proceso.StartInfo.Arguments = vArgsProc;
                    proceso.Start();
                    proceso.WaitForExit();

                    Log.putLog("Proceso " + vCodiProc + " finalizado.");
                    usu.UpdEstadoServicio("T", vCodiProc, "");
                }
                DataTable dtMail = usu.SP_AX_getMailPendientes();
                for (int a = 0; a < dtMail.Rows.Count; a++)
                {
                    vId = dtMail.Rows[a]["mtod_id"].ToString();
                    vFrom = dtMail.Rows[a]["mtod_from"].ToString();
                    vTo = dtMail.Rows[a]["mtod_to"].ToString();
                    vCc = dtMail.Rows[a]["mtod_cc"].ToString();
                    vSubject = dtMail.Rows[a]["mtod_subject"].ToString();
                    vText = dtMail.Rows[a]["mtod_text"].ToString();
                    vBCc = "";
                    vRutaText=vRutaBin + "MensMail.txt";
                    File.WriteAllText(vRutaText, vText);
                    vProgProc = vRutaBin + "gomail.bat ";
                    //vArgsProc = "69 \"" + vFrom + "\" \"" + vTo + "\" \"" + vCc + "\" \"\" \"" + vSubject + "\" \"" + vRutaText + "\" \"\" ";
                    vArgsProc = vFrom + " " + vTo + " " + vCc + " \"" + vSubject + "\" " + vRutaText;
                    Log.putLog("Proceso " + vCodiProc + " iniciado : " + vProgProc + " " + vArgsProc);
                    Process procesoMail = new Process();
                    procesoMail.StartInfo.FileName = vProgProc;
                    procesoMail.StartInfo.Arguments = vArgsProc;
                    procesoMail.Start();
                    procesoMail.WaitForExit();
                    Log.putLog("Proceso de envío de mail id"+ vId +"finalizado.");
                    usu.UpdEstadoServicioMail("T", vId);

                }
              
            }
            catch (Exception ex)
            {
                try
                {
                    Log.putError("error Despues del arreglo");
                    Log.putError(ex.Message);
                    usu.UpdEstadoServicio("E", vCodiProc, ex.Message);
                }
                catch (Exception ex2)
                {
                    Log.putError("error temporizador");
                    Log.putError(ex2.Message);
                }
                Log.putError(ex.Message);
            }
            temporizador.Enabled = true;
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

                    cmd = "AX_LOG.log";
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
}