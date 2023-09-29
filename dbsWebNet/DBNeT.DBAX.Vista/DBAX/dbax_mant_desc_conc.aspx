<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbax_mant_desc_conc.aspx.cs" Inherits="dbax_mant_desc_conc" %>
<%@ Register Assembly="System.Web.Extensions, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    <%--<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" ScriptMode="Release">
    </asp:ToolkitScriptManager>--%>

<div class="page"> 
    <div id="botones3" style="visibility:visible;" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
        </div>
    <div id="contenFormulario">
        <table id="tableDbaxDescConc">
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblPrefConc" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtPrefConc" Width="40px" runat="server" MaxLength="50"/>
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" runat="server" ErrorMessage="debe ingresar un Prefijo" ControlToValidate="txtPrefConc"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiConc" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtCodiConc" Width="450px" runat="server" MaxLength="256"/>
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" runat="server" ErrorMessage="Debe ingresar un código de Concepto" ControlToValidate="txtCodiConc"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiLang" runat="server"/></td>
                <td ><asp:DropDownList CssClass="dbnListaValor" ID="ddlCodiLang" Width="100px" runat="server"/></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDescConc" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtDescConc" Width="450px" runat="server" MaxLength="512"/></td>
            </tr>
        </table>
    </div>
    <div>
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/>
    </div>
</div>
</asp:Content>
