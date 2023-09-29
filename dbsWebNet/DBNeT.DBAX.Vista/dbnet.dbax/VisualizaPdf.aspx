<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VisualizaPdf.aspx.cs" Inherits="VizualizaPdf" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="~/librerias/img/botones/dbnet.ico" type="image/x-icon" rel="shortcut icon">
    <title>Visualizacion de PDF - DBNeT Prisma Financiero</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <iframe id="myPdf" runat="server">
        </iframe>
    </div>
    </form>
</body>
</html>
