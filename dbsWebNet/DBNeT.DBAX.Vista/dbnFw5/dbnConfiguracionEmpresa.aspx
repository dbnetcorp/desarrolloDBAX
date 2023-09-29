<%@ Page Title="" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true"
    CodeFile="dbnConfiguracionEmpresa.aspx.cs" Inherits="dbnMantencionEmpresa" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" runat="Server">
    <div class="page">
        <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png" OnClientClick="return confirm('Está seguro que desea eliminar la Empresa?');"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
        </div>
        <div class="contentFormulario">
            <table>
                <tr>
                    <td style="width:200px;">
                        <asp:Label CssClass="lblIzquierdo" ID="lblCodigo" runat="server"/>
                    </td>
                    <td colspan="2">
                        <asp:TextBox CssClass="dbnTextboxNumerico" ID="txtCodigo" runat="server" 
                            Width="70px" MaxLength="9"/>
                        <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" ControlToValidate="txtCodigo" runat="server" ErrorMessage="Debe ingresar código de empresa"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;">
                        <asp:Label CssClass="lblIzquierdo" ID="lblNombre" runat="server"/>
                    </td>
                    <td colspan="2">
                        <asp:TextBox CssClass="dbnTextbox" ID="txtNombre" runat="server" Width="384px"/>
                        <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" ControlToValidate="txtNombre" runat="server" ErrorMessage="ingresar nombre de empresa"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;">
                        <asp:Label CssClass="lblIzquierdo" ID="lblRut" runat="server"/>
                    </td>
                    <td colspan="2">
                        <asp:TextBox CssClass="dbnTextboxNumerico" ID="txtRut" runat="server" Width="70px" MaxLength="9"/>&nbsp;
                        <asp:TextBox ID="txtDv" CssClass="dbnTextbox" runat="server" Width="16px" MaxLength="1" AutoPostBack="True" 
                            ontextchanged="txtDv_TextChanged"/>
                        &nbsp;<asp:Label CssClass="lblError" ID="lblErroRut" runat="server"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;">
                        <asp:Label CssClass="lblIzquierdo" ID="lblNombreFantasia" runat="server"/>
                    </td>
                    <td colspan="2">
                        <asp:TextBox CssClass="dbnTextbox" ID="txtNombreFantasia" runat="server" Width="384px"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;">
                        <asp:Label CssClass="lblIzquierdo" ID="lblDireccion" runat="server"/>
                    </td>
                    <td colspan="2">
                        <asp:TextBox CssClass="dbnTextbox" ID="txtDireccion" runat="server" Width="384px"/>
                        <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator3" ControlToValidate="txtDireccion" runat="server" ErrorMessage="Debe ingresar una dirección"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;">
                        <asp:Label CssClass="lblIzquierdo" ID="lblComuna" runat="server"/>
                    </td>
                    <td colspan="2">
                        <asp:TextBox CssClass="dbnTextbox" ID="txtComuna" runat="server" Width="70px" OnTextChanged="txtComuna_TextChanged"/>&nbsp;
                        <asp:DropDownList ID="ddlComuna" runat="server" Width="310px" AutoPostBack="True" 
                            OnSelectedIndexChanged="ddlComuna_SelectedIndexChanged" CssClass="dbnListaValor"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;">
                        <asp:Label CssClass="lblIzquierdo" ID="lblCiudad" runat="server"/>
                    </td>
                    <td>
                        <asp:TextBox CssClass="dbnTextbox" ID="txtCiudad" runat="server" Width="70px" OnTextChanged="txtCiudad_TextChanged"/>&nbsp;
                        <asp:DropDownList ID="ddlCiudad" runat="server" Width="310px" AutoPostBack="True" 
                            OnSelectedIndexChanged="ddlCiudad_SelectedIndexChanged" CssClass="dbnListaValor" />
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;">
                        <asp:Label CssClass="lblIzquierdo" ID="lblGiro" runat="server"/>
                    </td>
                    <td>
                        <asp:TextBox CssClass="dbnTextbox" ID="txtGiro" runat="server" Width="70px" OnTextChanged="txtGiro_TextChanged"/>&nbsp;
                        <asp:DropDownList ID="ddlGiro" runat="server" Width="310px" AutoPostBack="True" 
                            OnSelectedIndexChanged="ddlGiro_SelectedIndexChanged" CssClass="dbnListaValor" />
                    </td>
                    <td>
                    </td>
                </tr>
                <%--<tr>
                    <td style="width:200px;">
                        <asp:Label CssClass="lblIzquierdo" ID="lblAsuntoMail" runat="server"/>
                    </td>
                    <td>
                        <asp:TextBox CssClass="dbnTextbox" ID="txtAsuntoMail" runat="server" Width="384px"/>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td style="width:200px;">
                        <asp:Label CssClass="lblIzquierdo" ID="lblCuerpoMail" runat="server"/>
                    </td>
                    <td>
                        <asp:TextBox CssClass="dbnTextbox" Height="100" ID="txtCuerpo" runat="server" TextMode="MultiLine"
                            Width="384"/>
                    </td>
                    <td>
                    </td>
                </tr>--%>
            </table>
        </div>
        <div id="divError" style="clear:both;">
            <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
        </div>
    </div>
</asp:Content>
