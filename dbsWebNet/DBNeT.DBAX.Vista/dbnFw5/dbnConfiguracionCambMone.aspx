<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnConfiguracionCambMone.aspx.cs" Inherits="dbnConfiguracionCambMone" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script src="../librerias/jquery/calendario_dw/jquery-1.4.4.min.js" type="text/javascript"></script>
    <script src="../librerias/jquery/calendario_dw/calendario_dw.js" type="text/javascript"></script>
    <%--Metodo para Activar el Plugin de JQuery en Los Textbox que tengan asignada la clase de CSS calendario--%>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".calendario").calendarioDW();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="page">
    <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png" OnClientClick="return confirm('Está seguro que desea eliminar el Valor de Cambio?');"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
    </div>
    <div id="contenFormulario">
        <table id="tableDbnCambMone">
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiMone" runat="server"/></td>
                <td ><asp:DropDownList CssClass="dbnListaValor" ID="ddlCodiMone" Width="206px" runat="server"/>
                </td>
            </tr>
            <%--<tr>
                <td><asp:Label CssClass="lblIzquierdo" ID="lblCodiEmex" runat="server"/></td>
                <td ><asp:DropDownList CssClass="dbnListaValor" ID="ddlCodiEmex" Width="206px" runat="server"/>
                </td>
            </tr>--%>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiMone1" runat="server"/></td>
                <td ><asp:DropDownList CssClass="dbnListaValor" ID="ddlCodiMone1" Width="206px" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblFechCamo" runat="server"/></td>
                <td ><asp:TextBox CssClass="calendario" ID="txtFechCamo" Width="200px" 
                        runat="server" />
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblValoCamo" runat="server"/></td>
                <td ><asp:TextBox CssClass="dbnTextbox" ID="txtValoCamo" Width="200px" runat="server" MaxLength="9" />
                </td>
            </tr>
        </table>
    </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
</div>
</asp:Content>
