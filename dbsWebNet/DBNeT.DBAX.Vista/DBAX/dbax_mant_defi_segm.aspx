<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbax_mant_defi_segm.aspx.cs" Inherits="DBAX_dbax_mant_defi_segm" %>
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
        <div class="contentFormulario">
            <asp:UpdatePanel ID="UpdatePanel" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <table>
                        <tr>
                            <td><asp:Label CssClass="lblIzquierdo" ID="lblCodiSegm" runat="server"/></td>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtCodiSegm" runat="server"/>
                            <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" runat="server" ErrorMessage="Debe ingresar un código" ControlToValidate="txtCodiSegm"/></td>
                        </tr>
                        <tr>
                            <td><asp:Label CssClass="lblIzquierdo" ID="lblDescSegm" runat="server"/></td>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtDescSegm" runat="server"/></td>
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