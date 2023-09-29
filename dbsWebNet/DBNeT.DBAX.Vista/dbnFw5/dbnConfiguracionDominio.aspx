<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" 
CodeFile="dbnConfiguracionDominio.aspx.cs" Inherits="dbnFw5_dbnConfiguracionDominio" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="../librerias/jquery/2.0.2/jquery-2.0.2.js" type="text/javascript"></script>
    <script src="../librerias/jquery/numeric.js" type="text/javascript"></script>
    <script>
        $('#bodyCP_txtDomainCode').numeric();
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div id="page" class="page">
    <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" 
                ImageUrl="~/librerias/img/botones/aceptar.png" 
                onclick="btnActualizar_Click" />
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" 
                ImageUrl="~/librerias/img/botones/page_del.png" 
                onclick="btnEliminar_Click" OnClientClick="return confirm('Está seguro que desea eliminar el Dominio?');"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" 
                ID="btnVolver" runat="server" 
                ImageUrl="~/librerias/img/botones/page_exit.png" onclick="btnVolver_Click" />
        </div>
    </div>
    <div id="contentFormulario">
        <table>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDomainCode" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDomainCode" runat="server"></asp:TextBox></td>
                <td><asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtDomainCode" ErrorMessage="Debe Ingresar un Código"></asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDomainName" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDomainName" runat="server"></asp:TextBox></td>
                <td><asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtDomainName" ErrorMessage="Debe Ingresar un Nombre"></asp:RequiredFieldValidator></td>
            </tr>
            <%--<tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDomainLength" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDomainLength" runat="server"></asp:TextBox></td>
                <td></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDomainType" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDomainType" runat="server"></asp:TextBox></td>
                <td></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDomainShow" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDomainShow" runat="server"></asp:TextBox></td>
                <td></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDomainClass" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDomainClass" runat="server"></asp:TextBox></td>
                <td></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDomainLow" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDomainLow" runat="server"></asp:TextBox></td>
                <td></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDomainHight" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDomainHight" runat="server"></asp:TextBox></td>
                <td></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDomainView" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDomainView" runat="server"></asp:TextBox></td>
                <td></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDomainSclass" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDomainSclass" runat="server"></asp:TextBox></td>
                <td></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDomainQuery" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDomainQuery" runat="server"></asp:TextBox></td>
                <td></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblDomainAuxLabel" runat="server"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDomainAuxlabel" runat="server"></asp:TextBox></td>
                <td></td>
            </tr>--%>
        </table>
    </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
</div>
</asp:Content>