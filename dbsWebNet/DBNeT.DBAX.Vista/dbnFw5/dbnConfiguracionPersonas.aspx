<%@ Page Title="" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnConfiguracionPersonas.aspx.cs" Inherits="dbnConfiguracionPersonas" %>

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
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png" OnClientClick="return confirm('Está seguro que desea eliminar la Persona);"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
    </div>

    <div class="contentFormulario">

        <table>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblCodigo" runat="server" 
                        CssClass="lblIzquierdo"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtCodigo" runat="server" Width="82" 
                        Enabled="False"/></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblRut" runat="server" 
                        CssClass="lblIzquierdo"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtRut" runat="server" MaxLength="8" Width="82"/>
                    &nbsp;&nbsp;<asp:TextBox CssClass="dbnTextbox" ID="txtDV" MaxLength="1" 
                        runat="server" Width="25" ontextchanged="txtDV_TextChanged" 
                        AutoPostBack="True"/>
                        <asp:Label CssClass="lblError" ID="lblErrorRut" runat="server"/>
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtRut" ErrorMessage="Debe ingresar un rut"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblNombre" runat="server" 
                        CssClass="lblIzquierdo"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtNombre" runat="server" Width="384"/>
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" ControlToValidate="txtNombre" runat="server" ErrorMessage="Debe ingresar un nombre"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblNombreFantasia" 
                        runat="server" CssClass="lblIzquierdo"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtNombreFantasia" runat="server" Width="384"/></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblIngreso" runat="server" 
                        CssClass="lblIzquierdo"/></td>
                <td><asp:TextBox CssClass="calendario" ID="txtIngreso" runat="server"  Width="82"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblDireccion" 
                        runat="server" CssClass="lblIzquierdo"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtDireccion" runat="server" Width="384"/></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblComuna" runat="server" 
                        CssClass="lblIzquierdo"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" Enabled="false" ID="txtComuna" runat="server" Width="63" 
                        ontextchanged="txtComuna_TextChanged"/>&nbsp;
                <asp:DropDownList CssClass="dbnListaValor" ID="ddlComuna" runat="server" 
                        onselectedindexchanged="ddlComuna_SelectedIndexChanged" 
                        AutoPostBack="True" Width="200"></asp:DropDownList> 
                        
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblPais" runat="server" 
                        CssClass="lblIzquierdo"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" Enabled="false" ID="txtPais" runat="server" Width="63" 
                        ontextchanged="txtPais_TextChanged"/>&nbsp; 
                <asp:DropDownList CssClass="dbnListaValor" ID="ddlPais" runat="server" 
                        onselectedindexchanged="ddlPais_SelectedIndexChanged" AutoPostBack="True" 
                        Width="200"></asp:DropDownList> 
                </td>
            </tr>
            <tr>
                <td style="width:12px;"><asp:Label ID="lblCodiPers1" runat="server" 
                        CssClass="lblIzquierdo"/></td>
                <td><asp:TextBox Enabled="false" CssClass="dbnTextbox" ID="txtCodiPers1" runat="server" Width="63" 
                        ontextchanged="txtCodiPers1_TextChanged" />&nbsp;
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddlPersonas" runat="server" Width="200" 
                        AutoPostBack="True" 
                        onselectedindexchanged="ddlPersonas_SelectedIndexChanged"></asp:DropDownList></td>
            </tr>
            <tr>
                <td style="width:12px;"><asp:Label ID="lblSuscursal" runat="server" 
                        CssClass="lblIzquierdo"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" Enabled="false" ID="txtSuscursal" runat="server" Width="63" 
                        ontextchanged="txtSuscursal_TextChanged"/>&nbsp;
                <asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlSuscursal" 
                        runat="server" Width="200" 
                        onselectedindexchanged="ddlSuscursal_SelectedIndexChanged"></asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblTelefono" runat="server" CssClass="lblIzquierdo"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtTelefono" runat="server" 
                        Width="384px"/></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblObservaciones" 
                        runat="server" CssClass="lblIzquierdo"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtObservaciones" Height="50" TextMode="MultiLine" runat="server" Width="384"/></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblMail" runat="server" 
                        CssClass="lblIzquierdo"/></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtMail" runat="server" Width="384px"/></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblPersona" runat="server" 
                        CssClass="lblIzquierdo"/></td>
                <td><asp:CheckBox ID="ckbPersona" runat="server" /></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label ID="lblEmpresa" runat="server" 
                        CssClass="lblIzquierdo"/></td>
                <td><asp:CheckBox ID="ckbEmpresa" runat="server" /></td>
            </tr>
        </table>
        
    </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
</div>
</asp:Content>