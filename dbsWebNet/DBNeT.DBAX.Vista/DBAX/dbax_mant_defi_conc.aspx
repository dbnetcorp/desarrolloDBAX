<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbax_mant_defi_conc.aspx.cs" Inherits="dbax_mant_defi_conc" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="System.Web.Extensions, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="asp" %>
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
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <table id="tableDbaxDefiConc">
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblPrefConc" runat="server"/></td>
                        <td ><asp:TextBox CssClass="dbnTextbox" ID="txtPrefConc" runat="server" MaxLength="50" Width="40"/>
                            <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" runat="server" ErrorMessage="Debe ingresar un Prefijo" ControlToValidate="txtPrefConc"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiConc" runat="server"/></td>
                        <td ><asp:TextBox CssClass="dbnTextbox" ID="txtCodiConc" runat="server" MaxLength="256" Width="500px" />
                            <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" runat="server" ErrorMessage="Debe ingresar un Código" ControlToValidate="txtCodiConc"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblTipoConc" runat="server"/></td>
                        <td ><asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlTipoConc" runat="server" ></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblTipoPeri" runat="server"/></td>
                        <td ><asp:TextBox CssClass="dbnTextbox" ID="txtTipoPeri" runat="server" MaxLength="15" /></td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblTipoValo" runat="server"/></td>
                        <td ><asp:TextBox CssClass="dbnTextbox" ID="txtTipoValo" runat="server" MaxLength="256" /></td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblTipoCuen" runat="server"/></td>
                        <td ><asp:TextBox CssClass="dbnTextbox" ID="txtTipoCuen" runat="server" MaxLength="10" /></td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiNume" runat="server"/></td>
                        <td ><asp:TextBox CssClass="dbnTextbox" ID="txtCodiNume" runat="server" MaxLength="25" /></td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblTipoTaxo" runat="server"/></td>
                        <td ><asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlTipoTaxo" runat="server"  ></asp:DropDownList></td>
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