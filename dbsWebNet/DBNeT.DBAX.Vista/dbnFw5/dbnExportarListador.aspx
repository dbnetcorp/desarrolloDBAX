<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnExportarListador.aspx.cs" Inherits="dbnFw5_dbnExportarListador" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="page">
    <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" 
                ImageUrl="~/librerias/img/botones/aceptar.png" 
                onclick="btnActualizar_Click" />
            <%--<asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" ImageUrl="~/librerias/img/botones/page_del.png" OnClientClick="return confirm('Está seguro que desea eliminar el Usuario?');"/>--%>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" 
                ID="btnVolver" runat="server" 
                ImageUrl="~/librerias/img/botones/page_exit.png" onclick="btnVolver_Click" />
        </div>
    </div>
    <div id="contentFormulario">
        <table>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblReporte" CssClass="lblIzquierdo" runat="server" /></td>
                <td>
                    <asp:DropDownList CssClass="dbnListaValor" ID="ddlReportes" runat="server">
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