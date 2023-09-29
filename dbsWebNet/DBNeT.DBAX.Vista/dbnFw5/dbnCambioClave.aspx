<%@ Page Title="" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnCambioClave.aspx.cs" Inherits="dbnCambioClave" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="page"> 
    <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
    </div>

    <div id="contenFormulario">
        <table class="tablaSysParam" id="tableSysParam">
            <tr style="width:150px;">
                <td><asp:Label CssClass="lblIzquierdo" ID="lblUsuario" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtCodiUsua" runat="server" Width="120px"/></td>
                <td>&nbsp;<asp:TextBox CssClass="dbnTextbox" ID="txtNombUsua" runat="server" Width="300px"/></td>
            </tr>
            <tr>
                <td><asp:Label CssClass="lblIzquierdo" ID="lblPassAntigua" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtPassAntigua" runat="server" TextMode="Password" Width="120px"/></td>
            </tr>
            <tr>
                <td><asp:Label CssClass="lblIzquierdo" ID="lblPassNueva" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtPassNueva" runat="server" TextMode="Password" Width="120px"/></td>
            </tr>
            <tr>
                <td><asp:Label CssClass="lblIzquierdo" ID="lblPassConfirma" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtPassNuevaConfirmar" runat="server" TextMode="Password" Width="120px"/></td>
            </tr>
        </table>
    </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>

</div>
</asp:Content>