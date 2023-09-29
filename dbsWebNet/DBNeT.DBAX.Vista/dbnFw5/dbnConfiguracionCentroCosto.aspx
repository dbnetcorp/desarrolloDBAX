<%@ Page Title="" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true"
    CodeFile="dbnConfiguracionCentroCosto.aspx.cs" Inherits="dbnConfiguracionCentroCosto" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="../librerias/jquery/calendario_dw/jquery-1.4.4.min.js" type="text/javascript"></script>
    <script src="../librerias/jquery/calendario_dw/calendario_dw.js" type="text/javascript"></script>
    <%--Metodo para Activar el Plugin de JQuery en Los Textbox que tengan asignada la clase de CSS calendario--%>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".calendario").calendarioDW();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" runat="Server">
    <div class="page">
        <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png" OnClientClick="return confirm('Está seguro que desea eliminar el Centro de Costo?');"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
        </div>
        <div class="contentFormulario">
            <table>
                <tr>
                    <td style="width:200px;"><asp:Label ID="lblCodigo" CssClass="lblIzquierdo" runat="server" /></td>
                    <td colspan="2"><asp:TextBox ID="txtCodigo" CssClass="dbnTextbox" runat="server" MaxLength="30" />
                        <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtCodigo" ErrorMessage="Debe ingresar un código de Centro costo"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;"><asp:Label ID="lblNombre" CssClass="lblIzquierdo" runat="server" /></td>
                    <td colspan="2">
                    <asp:TextBox ID="txtNombre" CssClass="dbnTextbox" runat="server" Width="384px" />
                        <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtNombre" ErrorMessage="RequiredFieldValidator" />
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;"><asp:Label ID="lblNombreCorto" CssClass="lblIzquierdo" runat="server" /></td>
                    <td colspan="2"><asp:TextBox ID="txtNombreCorto" CssClass="dbnTextbox" runat="server" /></td>
                </tr>
                <tr>
                    <td style="width:200px;"><asp:Label ID="lblNumeroCentro" CssClass="lblIzquierdo" runat="server" /></td>
                    <td colspan="2"><asp:TextBox ID="txtNumeroCentro" CssClass="dbnTextbox" runat="server" />
                        <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtNumeroCentro" ErrorMessage="RequiredFieldValidator"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;"><asp:Label ID="lblDesde" CssClass="lblIzquierdo" runat="server" /></td>
                    <td colspan="2"><asp:TextBox ID="txtDesde" CssClass="calendario" runat="server" Width="80" /></td>
                </tr>
                <tr>
                    <td style="width:200px;"><asp:Label ID="lblHasta" CssClass="lblIzquierdo" runat="server"/></td>
                    <td colspan="2"><asp:TextBox ID="txtHasta" CssClass="calendario" runat="server" Width="80"/></td>
                </tr>
                <tr>
                    <td style="width:200px;"><asp:Label ID="lblSuperior" CssClass="lblIzquierdo" runat="server" /></td>
                    <td colspan="2">
                        <asp:TextBox ID="txtSuperior" CssClass="dbnTextbox" runat="server" OnTextChanged="txtSuperior_TextChanged" />&nbsp;&nbsp;<asp:DropDownList
                            CssClass="dbnListaValor" ID="ddlSuperior" runat="server" Width="277px" AutoPostBack="True" 
                            onselectedindexchanged="ddlSuperior_SelectedIndexChanged" />
                    </td>
                </tr>
            </table>
        </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
    </div>
</asp:Content>
