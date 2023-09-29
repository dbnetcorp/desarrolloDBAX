<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnConfiguracionUsuarioRoles.aspx.cs" Inherits="dbnFw5_dbnConfiguracionUsuarioRoles" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div id="page" class="page">
    <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" 
                ImageUrl="~/librerias/img/botones/aceptar.png" onclick="btnActualizar_Click"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" 
                ImageUrl="~/librerias/img/botones/page_del.png" onclick="btnEliminar_Click" OnClientClick="return confirm('Está seguro que desea eliminar el rol asignado al usuario?');"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" 
                ID="btnVolver" runat="server" ImageUrl="~/librerias/img/botones/page_exit.png" 
                onclick="btnVolver_Click"/>
        </div>
    </div>
    <div id="contenFormulario">
        <table>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblUsuario" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtUsuario" runat="server" Width="130"/></td>
                <td>
                    <asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlUsuario" runat="server" 
                        onselectedindexchanged="ddlUsuario_SelectedIndexChanged">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblRol" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtRol" runat="server" Width="130"/></td>
                <td>
                    <asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlRol" runat="server" 
                        onselectedindexchanged="ddlRol_SelectedIndexChanged">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblModulo" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtModulo" runat="server" Width="130"/></td>
                <td>
                    <asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlModulo" runat="server" 
                        onselectedindexchanged="ddlModulo_SelectedIndexChanged">
                    </asp:DropDownList>
                </td>
            </tr>
        </table>
    </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
</div>
</asp:Content>