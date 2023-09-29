using System;
using System.Collections.Generic;
using System.Text;
using System.Data.OleDb;
using System.Data;
using System.IO;

namespace ValidaXBRL
{
    class ValidaDescarga
    {
        static string pPath;

        static void Main(string[] args)
        {
            try
            {
                if (args.Length != 1)
                {
                    System.Console.WriteLine("Número de parámetros erróneo");
                    System.Console.WriteLine("");
                    System.Console.WriteLine("PATH");
                    Environment.Exit(-1);
                }
                pPath = args[0];    // Path de descarga

                string[] files = Directory.GetFiles(pPath);
                for (int i = 0; i < files.Length; i++)
                {
                    if (ValidaArchivo(files[i]))
                        File.Delete(files[i]);
                }
                files = Directory.GetFiles(pPath);
                if (files.Length == 0)
                    Directory.Delete(pPath);
            }
            catch
            {

            }
        }

        public static bool ValidaArchivo(string pPath)
        {
            try
            {
                StreamReader fd = new StreamReader(pPath);
                string textoArchivo = fd.ReadToEnd();
                fd.Close();

                if (textoArchivo.IndexOf("Moment&aacute;neamente es imposible visualizar el archivo que hemos presentado.") > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return false;
            }
        }
    }
}
