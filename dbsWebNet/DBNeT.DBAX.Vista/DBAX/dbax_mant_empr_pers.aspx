<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbax_mant_empr_pers.aspx.cs" Inherits="dbax_mant_empr_pers" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    <%--<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" ScriptMode="Release">
    </asp:ToolkitScriptManager>--%>

<div class="page">
    <div id="botones3" style="visibility:visible;" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblRepoTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
        </div>
    <div id="contenFormulario">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table>
                <tr>
                    <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiPers" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnListaValor" ID="txtCodiPers" runat="server" Width="130"/>
                        <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" runat="server" ErrorMessage="Debe ingresar un Código" ControlToValidate="txtCodiPers"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDescPers" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnTextbox" ID="txtNombPers" runat="server" Width="450">
                        </asp:TextBox></td>
                </tr>
                <tr>
                    <td><asp:Label CssClass="lblIzquierdo" ID="lblDescPeho" runat="server"/></td>
                    <td><asp:TextBox CssClass="dbnTextbox" ID="txtDescPers" runat="server" Width="450"></asp:TextBox></td>
                </tr>
                <tr>
                    <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiGroup" runat="server"/></td>
                    <td><asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlCodiGrup" runat="server" 
                            Width="308" onselectedindexchanged="ddlCodiGrup_SelectedIndexChanged">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiSegm" runat="server"/></td>
                    <td><asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlCodiSegm" runat="server" 
                            Width="308" onselectedindexchanged="ddlCodiSegm_SelectedIndexChanged">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblTipoTaxo" runat="server"/></td>
                    <td><asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlTipoTaxo" runat="server" 
                            Width="308" onselectedindexchanged="ddlTipoTaxo_SelectedIndexChanged">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblPresBurs" runat="server"/></td>
                    <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlPartBurs" runat="server" Width="308">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblEmisBono" runat="server"/></td>
                    <td><asp:CheckBox ID="ckbEmisBono" runat="server" /></td>
                </tr>
                <tr>
                    <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblEmprVige" runat="server"/></td>
                    <td><asp:CheckBox ID="ckbEmprVige" runat="server" /></td>
                </tr>
            </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="divError">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/>
    </div>
</div>
</asp:Content>