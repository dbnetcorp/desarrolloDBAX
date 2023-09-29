<%@ Page Title="" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnCambioEmpresa.aspx.cs" Inherits="dbnCambioEmpresa" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="page"> 
   <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
    </div>
    <div id="contenFormulario">
        <table class="tablaSysParam" id="tableSysParam">
            <tr>
                <td><asp:Label CssClass="lblIzquierdo" ID="lblCodiEmpr" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtCodiEmpr" runat="server" Width="30" 
                        ontextchanged="txtCodiEmpr_TextChanged" /> &nbsp;
                    <asp:DropDownList CssClass="dbnListaValor" ID="ddlCodiEmpr" runat="server" 
                        AutoPostBack="True" Width="250" 
                        onselectedindexchanged="ddlCodiEmpr_SelectedIndexChanged"></asp:DropDownList> 
                </td>
            </tr>
        </table>
    </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
</div>
</asp:Content>