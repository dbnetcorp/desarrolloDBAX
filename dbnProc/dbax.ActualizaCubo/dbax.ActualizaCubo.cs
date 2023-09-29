using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace dbax.ActualizaCubo
{
    class ActualizaCubo
    {
        static string vTipoOper= "", vPeriodo = "";

        static void Main(string[] args)
        {
            /*try
            { 
                if (args.Length != 2)
                {
                    Console.WriteLine("Faltan Parámetros " + args.Length.ToString());
                    Environment.Exit(-1);
                }
                vPeriodo = args[0];
                vTipoOper = args[1];

                if (vTipoOper == "P")
                {
                    MantencionCubo cub = new MantencionCubo();

                    cub.updCuboParcial(vPeriodo);
                }
                else
                {
                    MantencionCubo cub = new MantencionCubo();
                    cub.updCuboTodos(vTipoOper);
                }
            }
            catch (Exception ex)
            {
                Log.putLog("Error al obtener los datos. " + ex.Message);
            }*/
        }
    }
}
