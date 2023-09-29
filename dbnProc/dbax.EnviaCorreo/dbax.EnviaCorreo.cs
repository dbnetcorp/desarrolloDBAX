using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace EnviaCorreo
{
    class Program
    {


        static void Main(string[] args)
        {
            Console.WriteLine("iniciando");
            Correo vMail = new Correo();
            
            vMail.enviarCorreoAlertas();
        }
    }
}
