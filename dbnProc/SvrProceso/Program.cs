using System.Collections.Generic;
using System.ServiceProcess;
using System.Text;


namespace SvrProceso
{
    static class Program
    {
        static void Main()
        {
            ServiceBase[] ServicesToRun;
            ServicesToRun = new ServiceBase[] { new SvrProceso() };
            
            ServiceBase.Run(ServicesToRun);
        }
    }
}