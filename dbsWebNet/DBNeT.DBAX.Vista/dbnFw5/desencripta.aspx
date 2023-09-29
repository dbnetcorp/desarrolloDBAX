<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="desencripta.aspx.cs" Inherits="dbnFw5_desencripta" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div>
    <asp:Label ID="lblEncripta" runat="server" Text="Encripta"></asp:Label>
    <asp:TextBox ID="txtencripta" runat="server"></asp:TextBox>
    <asp:Button ID="btnEncripta" runat="server" Text="Encripta" 
        onclick="btnEncripta_Click" />
    <asp:Label ID="lblEncriptaClave" runat="server" Text="Resultado"></asp:Label>
</div>


<div>
    <asp:Label ID="lblDesencripta" runat="server" Text="Desencripta"></asp:Label>
    <asp:TextBox ID="txtdesencripta" runat="server"></asp:TextBox>
    <asp:Button ID="btnDesencripta" runat="server" Text="Desencripta" 
        onclick="btnDesencripta_Click" />
    <asp:Label ID="lbldesencriptaClave" runat="server"></asp:Label>
</div>
</asp:Content>