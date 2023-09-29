<%@ Page Title="" Language="C#" AutoEventWireup="true"
    CodeFile="dbnLogin.aspx.cs" Inherits="dbnLogin" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title>DBNeT - Prisma Financiero</title>
    <link href="~/librerias/img/botones/dbnet.ico" type="image/x-icon" rel="shortcut icon"/>
    <link href="~/librerias/css/Style.css" rel="stylesheet" type="text/css" media="screen" />
    <meta name="msapplication-TileColor" content="#123456"/>
    <meta name="msapplication-TileImage" content="~/librerias/img/botones/dbnet.ico"/>
    <script src="../librerias/jquery/1.9.0/jquery-1.9.0.js" type="text/javascript"></script>
    <style type="text/css">
    .texto{width:500px; margin-top:-90px; margin-left:0%;}
    a
    { border:none;}
    img
    {border:none;}
    a img
    { border:none;}
    </style>
</head>
<body style="margin:0 auto; width:1024px" >
    <form id="form1" runat="server">
    <div class="pageLogin">
        <div class="encabezado">
            <asp:Image EnableViewState="false" ID="banner" runat="server" ImageUrl="~/librerias/img/pf_inicio.png"
                Width="1024" />
        </div>
        
        <div id="cuadroLogin" class="cuadroLogin">
            <table class="tabla">
                <tr style="text-align: right;">
                    <td style="width: 100px; text-align: right;">
                        <asp:Label CssClass="lblIzquierdo1" ID="lblUsuario" runat="server"/>
                    </td>
                    <td style="width: 100px; text-align: right;">
                        <asp:Label CssClass="lblIzquierdo1" ID="lblPassword" runat="server"/>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right;">
                        <asp:TextBox CssClass="dbnTextboxIzquierda" ID="txtUsuario" runat="server" Width="100px" />
                    </td>
                    <td style="width: 100px; text-align: right;">
                        <asp:TextBox CssClass="dbnTextboxIzquierda" ID="txtPassword" runat="server" Width="100px" TextMode="Password"/>
                    </td>
                    <td style="text-align: right; width: 100px; margin-left:10px;">
                        <asp:ImageButton ID="btnLogin" runat="server" Height="26" Width="90px" 
                            ImageUrl="~/librerias/img/loginPrisma/login.jpg"
                            OnClick="btnLogin_Click" />
                    </td>
                </tr>
                <tr style="">
                    <td></td>
                    <td></td>
                    <td><a href="http://www.dbnet.cl/es/cotizar.html"><img alt="Registrarse" style="margin-left:10px;"
                        src="../librerias/img/loginPrisma/regisgrarse.jpg" 
                        onmouseover="this.src='../librerias/img/loginPrisma/regisgrarse_f2.jpg'" 
                        onmouseout="this.src='../librerias/img/loginPrisma/regisgrarse.jpg'"
                        width="90px" height="26px"/></a></td>
                </tr>
                <tr>
                    <td colspan="3">
                        <asp:Label CssClass="lblError" ID="lblError" runat="server" />
                    </td>
                </tr>
            </table>
        </div>
        <div id="descripcion">
            <img alt="Descripción" class="texto" src="../librerias/img/loginPrisma/texto.png" />
        </div>
        <div id="prismaComo">
            <a href="../prisma_como.html">
                <img alt="Cómo" id="como" src="../librerias/img/loginPrisma/como.jpg" style="width:250px;"
                    onmouseover="this.src='../librerias/img/loginPrisma/como_f2.jpg'"
                    onmouseout="this.src='../librerias/img/loginPrisma/como.jpg'"  />
            </a>
        </div>

        <table style="margin-top:30px;">
            <tr>
                <td><img alt="" style="background-repeat:no-repeat;" src="../librerias/img/loginPrisma/1informaciondetalle.png" height="75px" width="320"/></td>
                <td><img alt="" style="background-repeat:no-repeat; margin-left:26px;" src="../librerias/img/loginPrisma/4consultascomparativas.png" height="75px" width="317"/></td>
                <td><img alt="" style="background-repeat:no-repeat; margin-left:26px;" src="../librerias/img/loginPrisma/7generacion.png" height="75px" width="310"/></td>
            </tr>
            <tr>
                <td><img alt="" style="background-repeat:no-repeat;" src="../librerias/img/loginPrisma/2informacionestado.png" height="75px" width="325"/></td>
                <td><img alt="" style="background-repeat:no-repeat; margin-left:26px;" src="../librerias/img/loginPrisma/5generacion.png" height="75px" width="329"/></td>
                <td><img alt="" style="background-repeat:no-repeat; margin-left:26px;" src="../librerias/img/loginPrisma/8refresco.png" height="75px" width="329"/></td>
            </tr>
            <tr>
                <td><img alt="" style="background-repeat:no-repeat;" src="../librerias/img/loginPrisma/3informacionnotas.png" height="75px" width="325" /></td>
                <td><img alt="" style="background-repeat:no-repeat; margin-left:26px;" src="../librerias/img/loginPrisma/6facilidad.png" height="75px" width="329"/></td>
                <td><img alt="" style="background-repeat:no-repeat; margin-left:26px;" src="../librerias/img/loginPrisma/9notificaciones.png" height="75px" width="329"/></td>
            </tr>
        </table>
        <div class="footer">
        </div>
    </div>
    </form>
</body>
</html>