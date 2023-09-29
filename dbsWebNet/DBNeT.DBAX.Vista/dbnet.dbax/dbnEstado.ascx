<%@ Control Language="C#" AutoEventWireup="True" CodeFile="dbnEstado.ascx.cs" Inherits="dbnEstado" %>
        
<asp:UpdatePanel ID="UpdatePanel2" runat="server" >
            
    <ContentTemplate>
        <asp:Timer ID="Timer1" runat="server" Interval="5000" ontick="Timer1_Tick"></asp:Timer>
        <asp:Label ID="lbEstado" runat="server"  Height="20px" CssClass="dbnEstado"></asp:Label>
    </ContentTemplate>
</asp:UpdatePanel>