<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" 
CodeFile="dbnConfiguracionDefiMone.aspx.cs" Inherits="dbnConfiguracionDefiMone" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="page"> 
    <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png" OnClientClick="return confirm('Está seguro que desea eliminar La Moneda?');"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
    </div>
    <div id="contenFormulario">
        <table id="tableDbnDefiMone">
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiMone" runat="server"></asp:Label></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtCodiMone" Width="200px" runat="server" MaxLength="3" />
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtCodiMone" ErrorMessage="Debe ingresar código de Moneda"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblNombMone" runat="server"></asp:Label></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtNombMone" Width="200px" runat="server" MaxLength="50"  />
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtNombMone" ErrorMessage="Debe ingresar nombre de moneda"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiPais" runat="server"></asp:Label></td>
                <td ><asp:DropDownList CssClass="dbnListaValor" ID="ddlCodiPais" Width="205px" runat="server" />
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddlCodiPais" InitialValue="0" ErrorMessage="debe seleccionar un país"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblRounMone" runat="server"></asp:Label></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtRounMone" Width="200px" runat="server" MaxLength="5"  />
                </td>
            </tr>
        </table>
    </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
</div>
</asp:Content>
