<%@ Page Title="" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnConfiguracionOficinaEmpresa.aspx.cs" Inherits="dbnConfiguracionOficinaEmpresa" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="page"> 
    <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png" OnClientClick="return confirm('Está seguro que desea eliminar la Sucursal?');"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
    </div>
    <div id="contenFormulario">
        <table id="tableOficEmpr">
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiOfic" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtCodiOfic" Width="30px" runat="server" MaxLength="3" />
                    <asp:RequiredFieldValidator CssClass="lblError" ControlToValidate="txtCodiOfic" ID="RequiredFieldValidator1" runat="server" ErrorMessage="Debe ingresar un código"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDescOfic" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtDescOfic" Width="405px" runat="server" MaxLength="30" />
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" ControlToValidate="txtDescOfic" runat="server" ErrorMessage="Debe ingresar el nombre"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiCeco" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" Enabled="false" ID="txtCodiCeco" 
                        Width="200px" runat="server" MaxLength="16" 
                        ontextchanged="txtCodiCeco_TextChanged" />&nbsp;
                    <asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlCodiCeco" runat="server" onselectedindexchanged="ddlCodiCeco_SelectedIndexChanged" Width="195">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator3" ControlToValidate="txtCodiCeco" runat="server" ErrorMessage="Debe seleccionar una oficina"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDireOfic" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtDireOfic" Width="405px" runat="server" MaxLength="80" />
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiCiud" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" Enabled="false" ID="txtCodiCiud" 
                        Width="200px" runat="server" MaxLength="8" 
                        ontextchanged="txtCodiCiud_TextChanged" />&nbsp;
                <asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlCiudad" runat="server" onselectedindexchanged="ddlCiudad_SelectedIndexChanged" Width="195"/>
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator4" ControlToValidate="txtCodiCiud" runat="server" ErrorMessage="Debe seleccionar una ciudad"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiComu" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" Enabled="false" ID="txtCodiComu" 
                        Width="200px" runat="server" MaxLength="8" 
                        ontextchanged="txtCodiComu_TextChanged" />&nbsp;
                <asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlComuna" runat="server" onselectedindexchanged="ddlComuna_SelectedIndexChanged" Width="195">
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
