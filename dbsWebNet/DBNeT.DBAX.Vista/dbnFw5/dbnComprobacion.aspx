<%@ Page Language="C#" AutoEventWireup="true" CodeFile="dbnComprobacion.aspx.cs" Inherits="dbnComprobacion" EnableViewState="false" %>

<!DOCTYPE html >
<html>
<head runat="server">
    <title>Descarga a Excel</title>
    <link href="../librerias/css/Style.css" rel="stylesheet" type="text/css" media="screen" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <p style="text-align:justify;">El Número de registros a extraer es superior a la cantidad recomendada y puede tardarse un tiempo mayor a lo esperado</p>
            <p style="text-align:justify;">Para Descargar todos los archivos presione Sí</p>
            <p style="text-align:justify;">Para Descargar sólo la página actual presione No</p>
            <div style="margin: 0 auto 0 auto; text-align:center;">
                <br />
                <asp:Button ID="btnSi" runat="server" Text="Sí" onclick="btnSi_Click" />
                <asp:Button ID="btnNo" runat="server" Text="No" onclick="btnNo_Click" />
            </div>
        </div>
    </form>
</body>
</html>
