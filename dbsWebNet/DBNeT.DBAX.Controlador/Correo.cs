using System.Data;
using System.Text;
using System.Net.Mail;
using System;

public partial class Correo
{
    public void enviarCorreo(String vSujeto, String vMensaje)
    {

        MailMessage mail = new MailMessage("alertaprisma@prismafinanciero.com", "mauricio.ahumada@dbnetcorp.com");

        SmtpClient client = new SmtpClient();
        client.Port = 25;
        client.DeliveryMethod = SmtpDeliveryMethod.Network;
        client.UseDefaultCredentials = false;
        client.Credentials = new System.Net.NetworkCredential("relay@smtp.suiteelectronica.com", "wer.qaz.1");
        client.Host = "smtp.suiteelectronica.com";
        mail.Subject = vSujeto;
        mail.Body = vMensaje;
        mail.CC.Add("jorge.toledo@dbnetcorp.com");
        mail.CC.Add("alejandro.schwarz@dbnetcorp.com");
        client.Send(mail);
    }
    public void enviarCorreo(String vMensaje)
    {
        enviarCorreo(vMensaje, "Alerta de operación - PrismaFinanciero.");
    }
    public void enviarCorreoErrorXBRLColombia(String vSujeto, String vMensaje)
    {
        MailMessage mail = new MailMessage("alertaprisma@prismafinanciero.com", "mauricio.ahumada@dbnetcorp.com");

        SmtpClient client = new SmtpClient();
        client.Port = 25;
        client.DeliveryMethod = SmtpDeliveryMethod.Network;
        client.UseDefaultCredentials = false;
        client.Credentials = new System.Net.NetworkCredential("relay@smtp.suiteelectronica.com", "wer.qaz.1");
        client.Host = "smtp.suiteelectronica.com";
        mail.Subject = vSujeto;
        mail.Body = vMensaje;
        mail.CC.Add("gx18@dbnetcorp.com");
        mail.CC.Add("fernando.cubillos@dbnetcorp.com");
        client.Send(mail);
    }

    /// <summary>
    /// Inserta registro en tabla de correos
    /// </summary>
    /// 
    public string insEstaMail(string vCodiPers, string vTipoRegi, string @vEstaMail, string @vFechDete, string vPeriInfo)
    {
        return "execute SP_AX_insEstaMail '" + vCodiPers + "','" + vTipoRegi + "','" + vEstaMail + "','" + vFechDete + "','" + vPeriInfo + "'";
    }

    /// <summary>
    /// Obtiene todos los registros pendientes de la tabla de correos
    /// </summary>
    /// 
    public string getEstaMailPendientes()
    {
        return "execute SP_AX_getEstaMail 'A'";
    }

    /// <summary>
    /// Obtiene todos registros pendientes de la tabla de correos dependiendo del tipo_regi entregado
    /// </summary>
    /// 
    public string getEstaMailPendientes(string vTipoRegi)
    {
        return "execute SP_AX_getEstaMail '" + vTipoRegi + "'";
    }

    /// <summary>
    /// Actualiza el estado de un registro de correo
    /// </summary>
    /// 
    public string updEstaMail(string vCorrRegi, string vMailDest, string vEstaMail, string vFechMail)
    {
        return "execute SP_AX_updEstaMail '" + vCorrRegi + "','" + vMailDest + "','" + vEstaMail + "'";
    }

    /// <summary>
    /// Obtiene los destinatarios de correo para alertas
    /// </summary>
    /// 
    public string getDestMail()
    {
        return "execute SP_AX_getDestMail";
    }

    public void enviarCorreoAlertas()
    {
        Console.WriteLine("Iniciando envío de correos");
        Conexion con = new Conexion().CrearInstancia();
        GuardarXBRL vXBRL = new GuardarXBRL();
        ComparacionXBRL vComp = new ComparacionXBRL();

        DataTable dtPendientesR = new DataTable();
        dtPendientesR = con.TraerResultadosT0(getEstaMailPendientes("R"));

        Console.WriteLine("Se obtuvieron " + dtPendientesR.Rows.Count + " alertas de reenvíos");

        DataTable dtPendientesN = new DataTable();
        dtPendientesN = con.TraerResultadosT0(getEstaMailPendientes("N"));
        Console.WriteLine("Se obtuvieron " + dtPendientesN.Rows.Count + " alertas de nuevos envíos");

        DataTable dtDestinatarios = new DataTable();
        dtDestinatarios = con.TraerResultadosT0(getDestMail());

        Console.WriteLine("Se obtuvieron " + dtDestinatarios.Rows.Count + " destinatarios");

        string mailBody = "";

        if (dtPendientesR.Rows.Count > 0)
        {
            Console.WriteLine("Analizando reenvíos");
            mailBody = "El Servicio de actualización de Prismafinanciero ha actualizado la información financiera por re-envios de información a CMF por parte de las siguientes compañía(s)<br />";

            for (int j = 0; j < dtPendientesR.Rows.Count; j++)
            {
                mailBody += "<br />" + dtPendientesR.Rows[j]["peri_info"].ToString() + "  -  " + dtPendientesR.Rows[j]["codi_pers"].ToString();
                if (dtPendientesR.Rows[j]["desc_pers"].ToString() != "")
                {
                    mailBody += "  -  " + dtPendientesR.Rows[j]["desc_pers"].ToString();
                }
                mailBody += "<br />";
            }
        }

        if (dtPendientesN.Rows.Count > 0)
        {
            Console.WriteLine("Analizando nuevos");
            if (dtPendientesR.Rows.Count > 0)
            {
                mailBody += "<br /><br />Además se ha detectado que la(s) siguientes(s) compañía(s) han realizado por primera vez el envío de información en formato XBRL:<br />";
            }
            else
            {
                mailBody += "El Servicio de actualización de Prismafinanciero ha actualizado la información y ha detectado que la(s) siguientes(s) compañía(s) han realizado por primera vez el envío de información en formato XBRL:<br />";
            }
            for (int j = 0; j < dtPendientesN.Rows.Count; j++)
            {
                mailBody += dtPendientesR.Rows[j]["peri_info"].ToString() + "  -  " + dtPendientesN.Rows[j]["codi_pers"].ToString();
                if (dtPendientesN.Rows[j]["desc_pers"].ToString() != "")
                {
                    mailBody += "  -  " + dtPendientesN.Rows[j]["desc_pers"].ToString();
                }

                mailBody += "<br />";
            }
        }
        mailBody += "<br />La información actualizada está disponible en el Servicios de Cubo de cuadros Técnicos y Site de DBNet PF productos de re-envíos de información por parte de compañías.  " +
                     "<br />El detalle de los cambios se puede consultar en <a href=\"https://www.prismafinanciero.com\">www.prismafinanciero.com</a>" +
                     "<br /><br />Equipo de Soporte DBNet PF";

        string vCorreos = "";
        try
        {
            if (dtPendientesR.Rows.Count > 0 || dtPendientesN.Rows.Count > 0)
            {

                for (int i = 0; i < dtDestinatarios.Rows.Count; i++)
                {
                    SmtpClient client = new SmtpClient();
                    client.Port = 25;
                    client.DeliveryMethod = SmtpDeliveryMethod.Network;
                    client.UseDefaultCredentials = false;
                    client.Credentials = new System.Net.NetworkCredential("relay@smtp.suiteelectronica.com", "wer.qaz.1");
                    client.Host = "smtp.suiteelectronica.com";

                    MailMessage mail = new MailMessage("alertaprisma@prismafinanciero.com", dtDestinatarios.Rows[i]["mail_dest"].ToString());
                    mail.IsBodyHtml = true;
                    mail.Subject = "Información actualizada en PrismaFinanciero";
                    mail.Body = mailBody;

                    //mail.CC.Add("gx18@dbnetcorp.com");
                    client.Send(mail);
                    vCorreos += dtDestinatarios.Rows[i]["mail_dest"].ToString() + " ";
                }
            }
        }
        catch(Exception ex)
        {
            Console.WriteLine("No se pudo enviar el correo:" + ex.Message);
        }

        string vFecha = System.DateTime.Now.Year.ToString() + "-" + System.DateTime.Now.Month.ToString() + "-" + System.DateTime.Now.Day.ToString() + " " + System.DateTime.Now.Hour.ToString() + ":" + System.DateTime.Now.Minute.ToString() + ":" + System.DateTime.Now.Second.ToString();

        for (int j = 0; j < dtPendientesR.Rows.Count; j++)
        {
            con.EjecutarQuery(updEstaMail(dtPendientesR.Rows[j]["corr_regi"].ToString(), vCorreos, "S", vFecha));
        }

        for (int j = 0; j < dtPendientesN.Rows.Count; j++)
        {
            con.EjecutarQuery(updEstaMail(dtPendientesN.Rows[j]["corr_regi"].ToString(), vCorreos, "S", vFecha));
        }
    }

}