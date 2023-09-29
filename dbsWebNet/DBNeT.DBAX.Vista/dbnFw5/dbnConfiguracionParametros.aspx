<%@ Page Title="" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnConfiguracionParametros.aspx.cs" Inherits="dbnParametros" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="page"> 
    <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png" OnClientClick="return confirm('Está seguro que desea eliminar el parámetro?');"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
    </div>
    <div id="contenFormulario">
        <table class="tablaSysParam" id="tableSysParam">
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblParamName" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtParam_name" Width="200px" runat="server" />
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" ControlToValidate="txtParam_name" runat="server" ErrorMessage="Debe ingresar un código"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblValor" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtParam_value" Width="200px" runat="server" />
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtParam_value" ErrorMessage="Debe ingresar un valor"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDescripcion" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtParam_desc" Width="200px" runat="server" /></td>
            </tr>
        </table>
    </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
</div>
</asp:Content>