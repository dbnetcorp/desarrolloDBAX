<%@ Page Title="" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" 
CodeFile="dbnConfiguracionUsuarios.aspx.cs" Inherits="dbnConfiguracionUsuarios" %>
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
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png" OnClientClick="return confirm('Está seguro que desea eliminar el Usuario?');"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
    </div>
    <div id="contentFormulario">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <table id="mant_usua" style="max-width:1024px;">
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo"  ID="lblUsuario" runat="server"/></td>
                        <td colspan="2"><asp:TextBox CssClass="dbnTextbox" ID="txbUsuario" runat="server" Width="157px"/>
                            <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" ControlToValidate="txbUsuario" runat="server" ErrorMessage="Debe ingresar un código de usuario"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo"  ID="lblNombre" runat="server"/></td>
                        <td colspan="2"><asp:TextBox CssClass="dbnTextbox" ID="txbNombre" runat="server" Width="306px"/>
                        <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" runat="server" ControlToValidate="txbNombre" ErrorMessage="ingresar un nombre"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo"  ID="lblFechaInicio" runat="server"/></td>
                        <td colspan="2"><asp:TextBox CssClass="calendario" ID="txbFechaInicio" 
                                runat="server" Width="110px"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo"  ID="lblFechaTermino" runat="server"/></td>
                        <td colspan="2"><asp:TextBox CssClass="calendario" ID="txbFechaTermino" 
                                runat="server" Width="110px"/></td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label  CssClass="lblIzquierdo"  ID="lblEmail" runat="server"/></td>
                        <td colspan="2"><asp:TextBox CssClass="dbnTextbox" ID="txbEmail" runat="server" Width="306px"/></td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblPersona" runat="server"/></td>
                        <td style="width:100px;""><asp:TextBox  CssClass="dbnTextbox" ID="txbPersona" Enabled="false"
                                runat="server" Width="110px" ontextchanged="txbPersona_TextChanged" AutoPostBack="true"/></td>
                        <td style="width:317px;"><asp:DropDownList ID="ddlPersona" runat="server" 
                                Width="317px" AutoPostBack="True" 
                                onselectedindexchanged="ddlPersona_SelectedIndexChanged" 
                                CssClass="dbnListaValor"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblEmpresa" runat="server"/></td>
                        <td style="width:100px;"><asp:TextBox  CssClass="dbnTextbox" ID="txbEmpresa" Enabled="false"
                                runat="server" Width="110px" ontextchanged="txbEmpresa_TextChanged"/></td>
                        <td style="width:317px;"><asp:DropDownList ID="ddlEmpresa" runat="server" 
                                Width="317px" AutoPostBack="True" 
                                onselectedindexchanged="ddlEmpresa_SelectedIndexChanged" 
                                CssClass="dbnListaValor"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCentCost" runat="server"/></td>
                        <td style="width:100px;"><asp:TextBox  CssClass="dbnTextbox" ID="txbCentroCosto" Enabled="false"
                                runat="server" Width="110px" ontextchanged="txbCentroCosto_TextChanged"/></td>
                        <td style="width:317px;"><asp:DropDownList ID="ddlCentCost" runat="server" 
                                Width="317px" AutoPostBack="True" 
                                onselectedindexchanged="ddlCentCost_SelectedIndexChanged" 
                                CssClass="dbnListaValor"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo"  ID="lblOficina" runat="server"/></td>
                        <td style="width:100px;"><asp:TextBox CssClass="dbnTextbox"  ID="txbOficina" Enabled="false"
                                runat="server" Width="110px" ontextchanged="txbOficina_TextChanged"/></td>
                        <td style="width:317px;"><asp:DropDownList ID="ddlOficina" runat="server" 
                                Width="317px" AutoPostBack="True" 
                                onselectedindexchanged="ddlOficina_SelectedIndexChanged" 
                                CssClass="dbnListaValor"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo"  ID="lblRol" runat="server"/></td>
                        <td style="width:100px;"><asp:TextBox CssClass="dbnTextbox"  ID="txbRol" Enabled="false"
                                runat="server" Width="110px" ontextchanged="txbRol_TextChanged"/></td>
                        <td style="width:317px;">
                            <asp:DropDownList ID="ddlRol" runat="server" Width="317px" 
                                AutoPostBack="True" onselectedindexchanged="ddlRol_SelectedIndexChanged" 
                                CssClass="dbnListaValor"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCodiEmex" runat="server"></asp:Label></td>
                        <td><asp:TextBox CssClass="dbnTextBox" ID="txtCodiEmex" runat="server" Width="110" Enabled="false"
                                ontextchanged="txtCodiEmex_TextChanged"></asp:TextBox></td>
                        <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlEmprExte" runat="server" 
                                Width="317" AutoPostBack="True" 
                                onselectedindexchanged="ddlCodiEmex_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo"  ID="lblClave" runat="server"/> </td>
                        <td ><asp:TextBox  CssClass="dbnTextbox" ID="txbClave" runat="server" 
                                Width="110px" TextMode="Password"/></td>
                        <td>
                            <asp:CheckBox CssClass="lblIzquierdo" ID="ckbUsuaBloq" runat="server" Text="Usuario Bloqueado"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:200px;"> <asp:Label CssClass="lblIzquierdo"  ID="lblConfClave" runat="server"/></td>
                        <td><asp:TextBox CssClass="dbnTextbox"  ID="txbConfClave" 
                                runat="server" Width="110px"  TextMode="Password"/></td>
                
                        <td>
                            <asp:CheckBox CssClass="lblIzquierdo" ID="ckbUsuaNoca" runat="server" Text="Usuario No Caduca" />
                        </td>
                
                    </tr>
                    <tr style="visibility:hidden;">
                        <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblMonitor" runat="server"/></td>
                        <td><asp:CheckBox ID="ckbMonitor" runat="server" /></td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
</div>
</asp:Content>
