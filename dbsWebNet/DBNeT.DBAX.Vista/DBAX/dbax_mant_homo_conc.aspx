<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbax_mant_homo_conc.aspx.cs" Inherits="DBAX_dbax_homo_conc" %>
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
            <asp:ImageButton CssClass="dbn_btnAgregar" ID="btnEjecutar" 
                ToolTip="Ejecuta Proceso de Homologación" runat="server" 
                ImageUrl="~/librerias/img/botones/imgProc.png" onclick="btnEjecutar_Click" />
        </div>
        </div>

    <div id="contenFormulario">
        <asp:UpdatePanel ID="UpdatePanel" runat="server" >
            <ContentTemplate>
                <table>
                    <tr>
                        <td><asp:Label CssClass="lblIzquierdo" ID="lblTipoTaxo" runat="server"/></td>
                        <td><asp:DropDownList AutoPostBack="True" CssClass="dbnListaValor" ID="ddlTipoTaxo" 
                                runat="server" Width="308" 
                                onselectedindexchanged="ddlTipoTaxo_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Label CssClass="lblIzquierdo" ID="lblVersTaxo" runat="server"/></td>
                        <td><asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlVersTaxo" 
                                runat="server" Width="308" />
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Label CssClass="lblIzquierdo" ID="lblVersTaxoDest" runat="server"/></td>
                        <td><asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlVersTaxoDest" runat="server" Width="308"/>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div>
        <asp:Label ID="lblError" CssClass="lblError" runat="server"/>
    </div>
</div>
</asp:Content>