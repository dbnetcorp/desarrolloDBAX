using System;
using System.ServiceProcess;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration.Install;

namespace SvrProceso
{
    [RunInstaller(true)]
    public partial class dbnetSrvProcesosInstaller : Installer
    {
        private ServiceInstaller srvInstaller;
        private ServiceProcessInstaller prcInstaller;

        public dbnetSrvProcesosInstaller()
        {
            InitializeComponent();
            prcInstaller = new ServiceProcessInstaller();
            srvInstaller = new ServiceInstaller();
            prcInstaller.Account = ServiceAccount.LocalSystem;

            // El servicio se iniciará manualmente
            // para que se inicie automáticamente, especificar el valor:
            // ServiceStartMode.Automatic
            srvInstaller.StartType = ServiceStartMode.Automatic;
            srvInstaller.ServiceName = "DBNeTAXProcesos";
            srvInstaller.Description = "Servicio que permite ejecutar procesos del modulo AX";

            //Dependencias del proceso
            //srvInstaller.ServicesDependedOn = new string[] { "MSSQL$SQLEXPRESS" };
            Installers.Add(srvInstaller);
            Installers.Add(prcInstaller);
        }
    }
}
