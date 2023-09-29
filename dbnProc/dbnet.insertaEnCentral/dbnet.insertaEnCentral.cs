using DBNeT.DBAX.Controlador;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dbnet.insertaEnCentral
{

    //exec prc_create_dbax_tras_arch  'XBRL', 'CL-CI','202003_CI\60503000_202003.zip','1','6/4/2020 12:22:33 PM'
    //exec prc_create_dbax_tras_arch  'XBRL', 'CL-CI','202003_CI\60806000_202003.zip','1','6/4/2020 12:17:28 PM'

    class Program
    {
        static void Main(string[] args)
        {
            Conexion conexion = new Conexion();
            insertaRegistroEnCentralController insertaCentral = new insertaRegistroEnCentralController();
            
            if(args.Length == 0)
            {
                Log.putLog("No se recibió el nombre del archivo como parámetro de entrada");
                Environment.Exit(-1);
            }
            else if (args.Length > 1)
            {
                Log.putLog("Demasiados parámetros de entrada. Solo debe entregar un nombre de archivo");
                Environment.Exit(-2);
            }
            else
            {
                try
                {
                    string vNombArch = args[0];

                    if (File.Exists(vNombArch))
                    {
                        StreamReader sr = new StreamReader(vNombArch);
                        string linea = sr.ReadLine();
                        while (linea != "")
                        {
                            linea = sr.ReadLine();
                            linea = linea.Substring(linea.IndexOf(" ", 10) + 1);
                            string[] paraSeparados = linea.Split(',');
                            int i = 0;
                            foreach (string para in paraSeparados)
                            {

                                paraSeparados[i] = para.Trim();
                                i++;
                            }

                            Log.putLog("Intentando insertar: " + paraSeparados[0] + ", " + paraSeparados[1] + ", " + paraSeparados[2] + ", " + paraSeparados[3] + ", " + paraSeparados[4]);
                            conexion.EjecutarQueryCentral(insertaCentral.insertaRegistroEnCentral(paraSeparados[0], paraSeparados[1], paraSeparados[2], paraSeparados[3], paraSeparados[4]));
                            Log.putLog("Insertado ok");
                        }
                    }else
                    {
                        Log.putLog("No se encontró el archivo " + vNombArch);
                        Environment.Exit(-3);
                    }
                }
                catch
                {

                }
            }
        }
    }
}
