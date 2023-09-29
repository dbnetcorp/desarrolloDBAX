<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbax_mant_defi_ramo.aspx.cs" Inherits="dbax_mant_defi_ramo" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    

<div class="page">
        <div id="botones3" style="visibility:visible;" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
        </div>
        <div class="contentFormulario">
        <asp:UpdatePanel ID="UpdatePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
            <table>
                <tr>
                    <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiSegm" runat="server"/></td>
                    <td><asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlCodiSegm" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td><asp:Label CssClass="lblIzquierdo" ID="lblCodiRamo" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnTextbox" ID="txtCodiRamo" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="lblError" ErrorMessage="Debe ingresar un código" ControlToValidate="txtCodiRamo" />
                    </td>
                </tr>
                <tr>
                    <td><asp:Label CssClass="lblIzquierdo" ID="lblDescRamo" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnTextbox" ID="txtDescRamo" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td><asp:Label CssClass="lblIzquierdo" ID="lblCodiRamoSupe" runat="server"/></td>
                    <td><asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlCodiRamoSupe" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td><asp:Label CssClass="lblIzquierdo" ID="lblTipoRamo" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnTextbox" ID="txtTipoRamo" runat="server"/>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="lblError" ErrorMessage="Debe ingresar un Tipo" ControlToValidate="txtTipoRamo"/></td>
                </tr>
                <tr>
                    <td><asp:Label CssClass="lblIzquierdo" ID="lblCodiConc" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnTextbox" ID="txtCodiConc" runat="server"/></td>
                </tr>
                <tr>
                    <td><asp:Label CssClass="lblIzquierdo" ID="lblNumeRamo" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnTextbox" ID="txtNumeRamo" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" CssClass="lblError" runat="server" ErrorMessage="Debe ingresar un Valor" ControlToValidate="txtNumeRamo"/></td>
                </tr>
            </table>
            </ContentTemplate>
        </asp:UpdatePanel>
        </div>
        <div>
            <asp:Label CssClass="lblError" ID="lblError" runat="server"/>
        </div>
</div>
</asp:Content>