using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Net.Mail;
using System.Threading;

public static class Log
{
    private static string vPathHome;

    static Log()
    {
        try
        {
            Microsoft.Win32.RegistryKey key = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("Software\\DBNeT\\Prisma\\CHL", false);
            vPathHome = key.GetValue("pathBackEnd").ToString() + "log\\";
        }
        catch
        {
            vPathHome = @"C:\DBNeT\DBAX\log\";
            //DbnetGlobal.Path = Path.GetFullPath("setting.config");
        }
    }

    public static void putLog(string pMensaje)
    {
        string[] cmds = Environment.GetCommandLineArgs();
        string filename = cmds[0].Split('\\')[cmds[0].Split('\\').Length - 1];
        filename = filename.Replace(".exe", "");

        while (IsFileLocked(vPathHome + filename + ".log"))
        {
            Thread.Sleep(500);
        }

        StreamWriter archivoError = new StreamWriter(vPathHome + filename + ".log", true);
        archivoError.WriteLine(System.DateTime.Now + ": " + pMensaje);
        archivoError.Close();
    }

    public static void putLog(string pMensaje, bool Consola)
    {
        string[] cmds = Environment.GetCommandLineArgs();
        string filename = cmds[0].Split('\\')[cmds[0].Split('\\').Length - 1];
        filename = filename.Replace(".exe", "");

        while (IsFileLocked(vPathHome + filename + ".log"))
        {
            Thread.Sleep(500);
        }

        StreamWriter archivoError = new StreamWriter(vPathHome + filename + ".log", true);
        archivoError.WriteLine(System.DateTime.Now + ": " + pMensaje);
        archivoError.Close();
        if (Consola == true)
            Console.WriteLine(System.DateTime.Now + ": " + pMensaje);
    }

    public static void putLog(string pMensaje, bool Consola, string vFechaHora)
    {
        try
        {
            string[] cmds = Environment.GetCommandLineArgs();
            string filename = cmds[0].Split('\\')[cmds[0].Split('\\').Length - 1];
            filename = filename.Replace(".exe", "_" + vFechaHora);

            while (IsFileLocked(vPathHome + filename + ".log"))
            {
                Thread.Sleep(500);
            }

            StreamWriter archivoError = new StreamWriter(vPathHome + filename + ".log", true);
            archivoError.WriteLine(System.DateTime.Now + ": " + pMensaje);
            archivoError.Close();
            if (Consola == true)
                Console.WriteLine(System.DateTime.Now + ": " + pMensaje);
        }
        catch 
        {
            string[] cmds = Environment.GetCommandLineArgs();
            StreamWriter archivoError2 = new StreamWriter(vPathHome + cmds[0].Split('\\')[cmds[0].Split('\\').Length - 1] + "_2.log", true);
            archivoError2.WriteLine(System.DateTime.Now + ": " + pMensaje);
            archivoError2.Close();
            if (Consola == true)
                Console.WriteLine(System.DateTime.Now + ": " + pMensaje);
        }
    }

    public static void enviarCorreo(String vMensaje)
    {
        MailMessage mail = new MailMessage("alertaprisma@prismafinanciero.com", "mauricio.ahumada@dbnetcorp.com");
        SmtpClient client = new SmtpClient();
        client.Port = 25;
        client.DeliveryMethod = SmtpDeliveryMethod.Network;
        client.UseDefaultCredentials = false;
        client.Credentials = new System.Net.NetworkCredential("relay@smtp.suiteelectronica.com", "wer.qaz.1");
        client.Host = "smtp.suiteelectronica.com";
        mail.Subject = "Alerta de operación - PrismaFinanciero.";
        mail.Body = vMensaje;
        client.Send(mail);
    }

    public static bool IsFileLocked(string vFile)
    {
        FileInfo file = new FileInfo(vFile);
        FileStream stream = null;

        try
        {
            if(File.Exists(vFile))
                stream = file.Open(FileMode.Open, FileAccess.ReadWrite, FileShare.None);
        }
        catch (IOException)
        {
            return true;
        }
        finally
        {
            if (stream != null)
                stream.Close();
        }
        return false;
    }
}