using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace dbax.RescataXBRL
{
    class Program
    {
        static void Main(string[] args)
        {
            string pCodi_usua = "", pPass_usua = "", pHome_dbax = @"C:\DBNeT\dbax";

            //try
            //{
            //    Microsoft.Win32.RegistryKey key = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("Software\\DBNeT\\Prisma\\CHL", false);
            //    pHome_dbax = key.GetValue("pathBackEnd").ToString();
            //}
            //catch(Exception ex)
            //{
            //    Console.ForegroundColor = ConsoleColor.Yellow;
            //    Console.WriteLine("***** No se pudo obtener el valor para Software\\DBNeT\\Prisma\\CHL\\pathBackEnd en el registro");
            //    Console.WriteLine(ex.Message);
            //    Console.WriteLine(ex.StackTrace);
            //    Console.ForegroundColor = ConsoleColor.Gray;

            //    pHome_dbax = "C:\\DBNeT\\dbax\\";
            //    //DbnetGlobal.Path = Path.GetFullPath("setting.config");
            //}
            //Console.ForegroundColor = ConsoleColor.Yellow;
            //Console.WriteLine("La ruta pHome_dbax obtenida es " + pHome_dbax);
            //Console.ForegroundColor = ConsoleColor.Gray;

            try
            {
                prismaRescataArchivo.RespuestaArchivos r1 = new prismaRescataArchivo.RespuestaArchivos();
                prismaRescataArchivo.RespuestaXBRL r2 = new prismaRescataArchivo.RespuestaXBRL();
                prismaRescataArchivo.ServicioPrismaRescata srv = new prismaRescataArchivo.ServicioPrismaRescata();

                if (args.Length == 3)
                {
                    pHome_dbax = args[0];
                    pCodi_usua = args[1];
                    pPass_usua = args[2];

                    Log.putLog("Inicio Proceso " + pCodi_usua);
                    r1 = srv.getArchivos(pCodi_usua, pPass_usua, "1");


                    Log.putLog("Conexion Central " + r1.Estado);
                    if (r1.Estado != "ERR")
                    {
                        Log.putLog("Rescatando " + r1.CantArch.ToString() + " archivos");
                        for (int i = 0; i < r1.Archivos.Length; i++)
                        {
                            string[] vName_archs = r1.Archivos[i].ArchXbrl.Split('\\');

                            string vPath_arch = r1.Archivos[i].ArchXbrl;
                            string vNomb_arch = vName_archs[vName_archs.Length - 1];

                            string[] vDire_archs = vNomb_arch.Split('.');
                            string vDire_arch = vDire_archs[0];

                            // Se le agrega la ruta completa al archivo rescatado
                            vDire_arch = pHome_dbax + @"\xbrl\" + vDire_arch;
                            vNomb_arch = pHome_dbax + @"\xbrl\" + vNomb_arch;

                            Log.putLog("Procesando Archivo : " + vNomb_arch);

                            #region RESCATA XBRL: Guarda Archivo Descargado

                            r2 = srv.getArchivo(r1.CorrSess, pCodi_usua, r1.Archivos[i].CodiArch, vPath_arch);
                            if (r2.ArchivoBytes != null)
                            {

                                System.IO.File.WriteAllBytes(vNomb_arch, r2.ArchivoBytes);
                            }
                            else
                            {
                                Console.ForegroundColor = ConsoleColor.Yellow;
                                Console.WriteLine("La ruta pHome_dbax obtenida es " + pHome_dbax);
                                Console.ForegroundColor = ConsoleColor.Gray;
                            }

                            #endregion

                            #region RESCATA XBRL: Descomprime Archivo

                            Process proceso1 = new Process();
                            proceso1.StartInfo.FileName = pHome_dbax + @"\bin\unzip.exe";
                            proceso1.StartInfo.Arguments = @" -o -d " + vDire_arch + " " + vNomb_arch;
                            proceso1.Start();
                            proceso1.WaitForExit();

                            #endregion

                            #region RESCATA XBRL: Elimina Archivo Descargado

                            System.IO.File.Delete(vNomb_arch);

                            #endregion
                        }
                        Log.putLog("Fin Proceso");
                    }
                }
                else
                {
                    Log.putLog("Parametros Incorrectos");
                }
            }
            catch(Exception ex)
            {
                Log.putLog("Error: " + ex.Message + ". " + ex.StackTrace);
                Log.enviarCorreo("Error en RescataXBRL: " + ex.Message + ". " + ex.StackTrace);
            }
        }
    }
}
