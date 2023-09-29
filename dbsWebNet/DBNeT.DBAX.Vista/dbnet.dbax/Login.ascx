<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Login.ascx.cs" Inherits="Website_Login" %>

<div style="position:absolute; margin-top:-58px; margin-left:30px;">
    <asp:Button ID="Button1" style="position:relative; left: -347px; top: -13px; height: 33px; width: 200px;" runat="server" 
    BackColor="Transparent" BorderColor="Transparent" Font-Bold="True" Font-Size="x-Small" ForeColor="White" Text="" 
    onclick="irAHome" /> 
</div>
<div style="position:absolute; margin-top:10px; margin-left:845px; width:200px; height:20px;">
    <div style="margin-left:-80px; width:150px; text-align:right;">
        <asp:Label ID="lblUsuario" runat="server" CssClass="dbnLabel" style=" text-align:right;"/>
    </div>
    <div style=" position:absolute; margin-left:80px; margin-top:-15px; width:100px;">
        /<asp:Button ID="cerrar_sesion" BorderColor="Transparent" BackColor="Transparent" runat="server" CssClass="dbnLabel" Text="Cerrar Sesión" width="85px" onclick="cerrar_sesion_Click" />
    </div>
    <asp:Label ID="lbVers" runat="server" style="position: absolute; top: 20px; left: -620px;" Font-Size="X-Small" ForeColor="#188cb5" Text="Ver 2.6" Font-Bold="True" 
        Font-Names="Trebuchet MS"></asp:Label>
</div>
<div style="background-image: url(../librerias/img/PF_banner.jpg); background-repeat:no-repeat; width:auto; height:80px;" ></div>