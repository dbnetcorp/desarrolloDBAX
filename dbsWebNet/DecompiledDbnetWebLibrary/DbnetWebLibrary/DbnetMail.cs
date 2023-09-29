// Decompiled with JetBrains decompiler
// Type: DbnetWebLibrary.DbnetMail
// Assembly: DbnetWebLibrary, Version=1.0.4846.32991, Culture=neutral, PublicKeyToken=null
// MVID: C0BBA738-7D4D-4EF6-BC01-69A3EC828016
// Assembly location: C:\dbnet\SVN_desarrolloDBAX\dbsWebNet\DBNeT.DBAX.Wss\Bin\DbnetWebLibrary.dll

using System;
using System.IO;
using System.Net.Mail;
using System.Net.Mime;

namespace DbnetWebLibrary
{
  public class DbnetMail
  {
    private MailMessage mensaje;
    public string ipServidor;
    public string from;
    public string to;
    public string cc;
    public string body;
    public string subject;
    public string file1;

    public DbnetMail()
    {
      this.ipServidor = "";
      this.from = "";
      this.to = "";
      this.cc = (string) null;
      this.body = "";
      this.subject = "";
      this.file1 = (string) null;
    }

    public void envioSmtp(out bool status, out string msg)
    {
      try
      {
        SmtpClient smtpClient = new SmtpClient(this.ipServidor);
        this.mensaje = new MailMessage(this.from, this.to, this.subject, this.body);
        if (this.cc != null)
          this.mensaje.CC.Add(new MailAddress(this.cc));
        if (this.file1 != null)
        {
          Attachment attachment = new Attachment(this.file1, "application/octet-stream");
          ContentDisposition contentDisposition = attachment.ContentDisposition;
          contentDisposition.CreationDate = File.GetCreationTime(this.file1);
          contentDisposition.ModificationDate = File.GetLastWriteTime(this.file1);
          contentDisposition.ReadDate = File.GetLastAccessTime(this.file1);
          this.mensaje.Attachments.Add(attachment);
        }
        smtpClient.Send(this.mensaje);
        status = true;
        msg = "OK";
      }
      catch (Exception ex)
      {
        status = false;
        msg = ex.Message;
      }
    }
  }
}
