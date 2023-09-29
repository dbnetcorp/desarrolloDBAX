<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnMantencionFunciones.aspx.cs" Inherits="dbnMantencionFunciones" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    <div class="page">
        <div id="botones3" class="div3Botones">
            <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
            <div class="divBotones">
                <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" 
                    ImageUrl="~/librerias/img/botones/aceptar.png" onclick="btnActualizar_Click"/>
                <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" 
                    ImageUrl="~/librerias/img/botones/page_del.png" onclick="btnEliminar_Click"/>
                <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" 
                    ID="btnVolver" runat="server" ImageUrl="~/librerias/img/botones/page_exit.png" 
                    onclick="btnVolver_Click"/>
            </div>
        </div>
        <div id="contenFormulario">
            <table>
                <tr>
                    <td  style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblModulo" runat="server"/></td>
                    <td colspan="3"><asp:TextBox CssClass="dbnTextbox" ID="txtCodiModu" runat="server" Width="150"/></td>
                </tr>
                <tr>
                    <td  style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblMenu" runat="server"/></td>
                    <td colspan="3"><asp:TextBox CssClass="dbnTextbox" ID="txtMenu" runat="server" Width="200"/></td>
                </tr>
                <tr>
                    <td  style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodigo" runat="server"/></td>
                    <td colspan="3"><asp:TextBox CssClass="dbnTextbox" ID="txtCodigo" runat="server" Width="150"/></td>
                </tr>
                <tr>
                    <td  style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblTipo" runat="server"/></td>
                    <td colspan="3">
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddlTipo" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td  style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblArch" runat="server"/></td>
                    <td colspan="3"><asp:TextBox CssClass="dbnTextbox" ID="txtArch" runat="server" Width="150"/></td>
                </tr>
                <tr>
                    <td  style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblResumen" runat="server" /></td>
                    <td colspan="3"><asp:TextBox CssClass="dbnTextbox" ID="txtResumen" runat="server" /></td>
                </tr>
                <tr>
                    <td  style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblAbreviatura" runat="server" /></td>
                    <td colspan="3"><asp:TextBox CssClass="dbnTextbox" ID="txtAbreviatura" runat="server" Width="150"/></td>
                </tr>
                <tr>
                    <td  style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDescripcion" runat="server"/> </td>
                    <td colspan="3"><asp:TextBox CssClass="dbnTextbox" ID="txtDescripcion" runat="server"/></td>
                </tr>
                <tr>
                    <td  style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblOrden" runat="server"/></td>
                    <td colspan="3"><asp:TextBox CssClass="dbnTextbox" ID="txtOrden" runat="server" Width="60"/></td>
                </tr>
                <tr>
                    <td  style="width:200px;"><asp:Label ID="lblParametro1" CssClass="lblIzquierdo" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnTextbox" ID="txtPara1" runat="server" Width="150"/></td>
                    <td><asp:Label ID="lblValo1" CssClass="lblIzquierdo" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnTextbox" ID="txtValo1" runat="server" Width="150"/></td>
                </tr>
                <tr>
                    <td  style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblParametro2" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnTextbox" ID="txtPara2" runat="server" Width="150"/></td>
                    <td><asp:Label ID="lblValo2" CssClass="lblIzquierdo" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnTextbox" ID="txtValo2" runat="server" Width="150"/></td>
                </tr>
                <tr>
                    <td  style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblParametro3" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnTextbox" ID="txtPara3" runat="server" Width="150"/></td>
                    <td><asp:Label ID="lblValo3" CssClass="lblIzquierdo" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnTextbox" ID="txtValo3" runat="server" Width="150"/></td>
                </tr>
            </table>
        </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
    </div>
</asp:Content>