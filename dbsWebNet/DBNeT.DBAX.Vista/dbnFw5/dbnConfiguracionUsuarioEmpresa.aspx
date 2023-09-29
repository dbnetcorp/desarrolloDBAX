<%@ Page Title="" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnConfiguracionUsuarioEmpresa.aspx.cs" Inherits="dbnConfiguracionUsuarioEmpresa" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="page" id="page">
    <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png" OnClientClick="return confirm('Está seguro que desea eliminar usuario de la empresa?');"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
    </div>
    <div id="contentFormulario">
        <table>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblUsuario" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" Enabled="false" ID="txtUsuario" 
                        runat="server" ontextchanged="txtUsuario_TextChanged"/>&nbsp;
                <asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlUsuario" runat="server" Width="250" 
                onselectedindexchanged="ddlUsuario_SelectedIndexChanged" /> 
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" ControlToValidate="ddlUsuario" runat="server" InitialValue="0" ErrorMessage="Debe seleccionar un usuario"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblEmpresa" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" Enabled="false" ID="txtEmpresa" 
                        runat="server" ontextchanged="txtEmpresa_TextChanged"/>&nbsp;
                <asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlEmpresa" runat="server" Width="250" 
                onselectedindexchanged="ddlEmpresa_SelectedIndexChanged" /> 
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddlEmpresa" InitialValue="0" ErrorMessage="Debe seleccionar una empresa"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="LblEmex" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" Enabled="false" ID="txtEmex" 
                        runat="server" ontextchanged="txtEmex_TextChanged"/>&nbsp;
                <asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlEmex" runat="server" Width="250" 
                onselectedindexchanged="ddlEmex_SelectedIndexChanged" /> 
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddlEmex" InitialValue="0" ErrorMessage="Debe seleccionar un Holding"/>
                </td>
            </tr>
        </table>
    </div>
    <div id="divError">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
</div>
</asp:Content>