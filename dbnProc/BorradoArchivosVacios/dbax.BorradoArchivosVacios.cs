using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace BorradoArchivosVacios
{
    class BorradoArchivosVacios
    {
        static string pRutaXbrl = "";
        static string pPausEjec = "";
        static void Main(string[] args)
        {
            try
            {
                string[] Archivos;
                //string[] Folders;
                //bool BorrArch = false;
                if (args.Length != 2)
                {
                    Console.WriteLine("Numero incorrecto de parámetros, se informaron " + args.Length);

                    foreach (string parametro in args)
                    {
                        Console.WriteLine(parametro);
                    }
                    Environment.Exit(-1);
                }

                pRutaXbrl = args[0];
                if (!pRutaXbrl.EndsWith("\\"))
                    pRutaXbrl += "\\";
                pPausEjec = args[1];
                foreach (string parametro in args)
                {
                    //Console.ReadKey();
                    Console.WriteLine(parametro);
                }
                string[] Folders = Directory.GetFileSystemEntries(pRutaXbrl);
                
                //Para cada carpeta en el directorio de XBRL
                foreach (string vFolder in Folders)
                {
                    //FileInfo archivo;
                    Archivos = Directory.GetFileSystemEntries(pRutaXbrl + vFolder);
                    if (pPausEjec == "1")
                    {
                        Console.WriteLine("Se encontraron " + Archivos.Length + " archivos");
                        Console.ReadKey();
                    }
                    //Busco los archivos para evaluar el tamaño
                    
                    foreach (string Archivo in Archivos)
                    {
                        //BorrArch = false;
                        if (Archivo.EndsWith(".xbrl") || Archivo.EndsWith(".zip"))
                        {
                            FileInfo FileProp = new FileInfo(Archivo);
                            long FileLeng = FileProp.Length;
                            if (FileLeng < 1000)
                            {
                                if (pPausEjec == "1")
                                {
                                    Console.WriteLine("Eliminando " + Archivo);
                                    Console.ReadKey();
                                }

                                File.Delete(Archivo);
                            }
                        }
                    }

                    //if (BorrArch == true)
                    //{
                    //    foreach (string Archivo in Archivos)
                    //    {
                    //        File.Delete(Archivo);
                    //    }
                    //}
                }
            }
            catch(Exception ex)
            {
                
            }
        }
    }
}
