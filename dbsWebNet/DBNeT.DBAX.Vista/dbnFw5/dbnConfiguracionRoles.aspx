<%@ Page Title="" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnConfiguracionRoles.aspx.cs" Inherits="dbnConfiguracionRoles" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="page">
    <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png" OnClientClick="return confirm('Está seguro que desea eliminar el Rol?');"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
    </div>

    <div class="contentFormulario">
        <table>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodigoRol" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtCodigoRol" runat="server" Width="200"/>
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" ControlToValidate="txtCodigoRol" runat="server" ErrorMessage="Debe ingresar un Rol"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDescripcion" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDescripcion" runat="server" Width="200"/>
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" ControlToValidate="txtDescripcion" runat="server" ErrorMessage="Debe ingresar una descripción"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodigoModulo" runat="server"/></td>
                <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlModulo" runat="server" Width="206"/></td>
            </tr>
        </table>
    </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
</div>
</asp:Content>