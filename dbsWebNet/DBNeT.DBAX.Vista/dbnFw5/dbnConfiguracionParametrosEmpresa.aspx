<%@ Page Title="" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnConfiguracionParametrosEmpresa.aspx.cs" Inherits="dbnConfiguracionParametroEmpresa" %>
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
        <table id="tableParaEmpr">
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiPaem" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtCodiPaem" Width="200px" runat="server" MaxLength="30" />
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtCodiPaem" ErrorMessage="Debe ingresar un código"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDescPaem" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtDescPaem" Width="200px" runat="server" MaxLength="200" />
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtDescPaem" ErrorMessage="Debe ingresar una descripción"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblValoPaem" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtValoPaem" Width="200px" runat="server" MaxLength="100" /></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblTipoComo" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtTipoComo" Width="200px" runat="server" MaxLength="3" />
                </td>
            </tr>
            <%--<tr>
                <td><asp:Label CssClass="lblIzquierdo" ID="lblCodiEmex" runat="server"/></td>
                <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlCodiEmex" runat="server" Width="250">
                    </asp:DropDownList></td>
            </tr>--%>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblObliPaem" runat="server"/></td>
                <td ><asp:CheckBox ID="ckbObligatorio" runat="server" />
                </td>
            </tr>
        </table>
    </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
</div>
</asp:Content>
