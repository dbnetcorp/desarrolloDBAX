<%@ Page Title="Configuración de Listador" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" 
CodeFile="dbnConfiguracionListador.aspx.cs" Inherits="dbnConfiguracionListador" EnableEventValidation="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../librerias/css/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../librerias/css/StyleUI.css" rel="stylesheet" type="text/css" />
    <script src="../librerias/jquery/2.0.2/jquery-2.0.2.js" type="text/javascript"></script>
    <script src="../librerias/jquery/UI/1.9.0/jquery-ui-1.9.0.js" type="text/javascript"></script>
    <script src="../librerias/jquery/UI/1.10.0/jquery-ui-1.10.0.js" type="text/javascript"></script>
        <script>
            $(function () {
                $("#tabs").tabs();

                // Ejecuta el Efecto blind
                function runEffect() {
                    // run the effect
                    $("#divHelp").show("blind", 500, null);
                };

                //oculta el div con el efecto blind
                function callback() {
                    setTimeout(function () {
                        $("#divHelp").hide("blind").fadeOut();
                    }, 500);
                };

                $("#help").click(function () {
                    if ($("#divHelp").is(':hidden'))
                        runEffect();
                    else
                        callback();
                });
                $("#divHelp").hide();
            });

            $(function () {
                $("#bodyCP_txtColuCodigo").focusout(function () {
                    var valor = $("#bodyCP_txtColuCodigo").val();
                    $("#bodyCP_txtColuCodigoMulti").attr("value",valor);
                });
            });

            function ConfirmarEliminar() {
                if (confirm("¿Desea Eliminar el registro?") == true)
                    return true;
                else
                    return false;
            }
        </script>
        <style>
            #divHelp
            { background-color:white; }
            label
            { font-size: x-small; text-align:left; border:0;}
            h3{ font-size: x-small;}
            .btnEjecutar
            { 
                position:relative;
                float:left;
                margin-left:4px;
            }
        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    <%--<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </asp:ToolkitScriptManager>--%>
<div class="page">
    <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblRepoTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png" OnClientClick="return confirm('Está seguro que desea eliminar el Reporte?');"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
            <input type="button" class="btnHelp" id="help" style="width:30px; height:27px;" name="help" title="Ayuda Query"/>
            <asp:ImageButton CssClass="btnProcesar" ID="btnProcesar" runat="server" 
                ImageUrl="~/librerias/img/botones/bt_genLogs.png" onclick="btnProcesar_Click" />
            <asp:ImageButton CssClass="btnEjecutar" ID="btnEjecutar" runat="server"
                ImageUrl="~/librerias/img/botones/page_run.png" onclick="btnEjecutar_Click" />
        </div>
    </div>
    <!--Div para Agregar el ejemplo de query-->
    <div class="contenido" id="contenido">
        <table style="width:auto;">
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblRepoCodigoReporte" runat="server" /></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtReporteCodigo" runat="server" Width="150" />
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" ControlToValidate="txtReporteCodigo" runat="server" ErrorMessage="Debe ingresar un código de reporte"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblRepoTituloReporte" runat="server" /></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtReporteTituloReporte" runat="server" Width="250"/>
                <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" ControlToValidate="txtReporteTituloReporte" runat="server" ErrorMessage="Debe ingresar Titulo de reporte"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblRepoDescripcion" runat="server" /></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtReporteDescripcion" runat="server" Width="380" /></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblRepoCodigoMultilenguaje" runat="server" /></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtReporteCodigoMultilenguaje" runat="server" /></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblRepoProcedimiento" runat="server" /></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtReporteProcedimiento" runat="server" /></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblPageRepo" runat="server" /></td>
                <td><asp:TextBox CssClass="dbnTextbox" ID="txtPageRepo" runat="server" /></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblModo" runat="server" /></td>
                <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlModo" runat="server">
                        <asp:ListItem>Seleccione</asp:ListItem>
                        <asp:ListItem Value="M">Mantención</asp:ListItem>
                        <asp:ListItem Value="CE">Editar</asp:ListItem>
                        <asp:ListItem Value="CI">Insertar</asp:ListItem>
                        <asp:ListItem Value="C">Consulta</asp:ListItem>
                        <asp:ListItem Value="T">Tabular</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblRepoFiltro" runat="server" /></td>
                <td><asp:CheckBox ID="ckbFiltro" runat="server" /></td>
            </tr>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblRepoCate" runat="server" Text="Label" /></td>
                <td>
                    <asp:DropDownList CssClass="dbnListaValor" ID="ddlRepoCate" runat="server">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td><asp:Label CssClass="lblIzquierdo" ID="lblTipoRepo" runat="server" /></td>
                <td>
                    <asp:DropDownList CssClass="dbnListaValor" ID="ddlRepoTipoRepo" runat="server">
                        <asp:ListItem Value="">Seleccione</asp:ListItem>
                        <asp:ListItem Selected="True" Value="Maestro">Maestro</asp:ListItem>
                        <asp:ListItem Value="Detalle">Detalle</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
        </table>   
        <div id="divHelp">
            <center><h3 class="ui-widget-header ui-corner-all">Ayuda Para Querys y variables de Contexto</h3></center>
            <label>SELECT ROW_NUMBER() OVER(ORDER BY CODIGO (ASC - DESC) ) AS REG,</label>
            <label>query a ejecutar</label><br />
            <label><strong>Variables de contexto</strong></label><br />
            <label>codi_emex = ':P_CODI_EMEX'</label>
            <label>codi_empr = ':P_CODI_EMPR'</label>
            <label>codi_usua = ':P_CODI_USUA'</label><br />
            <label>parametro 1 = ':P_PAR1'</label>
            <label>parametro 2 = ':P_PAR2'</label><br />
            <label>parametro 3 = ':P_PAR3'</label>
            <label>parametro 4 = ':P_PAR4'</label><br />
            <label>parametro 5 = ':P_PAR5'</label>
        </div> 

        <div id="tabs">
             <ul>
                <li><a href="#tabs-1" class="lblIzquierdo">Columnas</a></li>
                <li><a href="#tabs-2" class="lblIzquierdo">Botones</a></li>
                <li><a href="#tabs-3" class="lblIzquierdo">SQL</a></li>
                <li><a href="#tabs-4" class="lblIzquierdo">Privilegios</a></li>
             </ul>
             <div id="tabs-1" class="tabs-1">
                    <table>
                        <tr>
                            <th style="width:100px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuCodigo" runat="server" /></th>
                            <th style="width:100px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuTitulo" runat="server" /></th>
                            <th style="width:100px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuDescripcion" runat="server" /></th>
                            <th style="width:120px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuCodigoMultilenguaje" runat="server" /></th>
                            <th style="width:90px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuClaseCss" runat="server" /></th>
                            <th style="width:90px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuTipoColu" runat="server" /></th>
                            <th style="width:45px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuAncho" runat="server" /></th>
                            <th style="width:90px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuAlineacion" runat="server" /></th>
                            <th style="width:100px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuFormato" runat="server" /></th>
                            <th style="width:50px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuVisible" runat="server" /></th>
                            <th style="width:50px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuImagen" runat="server" /></th>
                            <th style="width:50px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuJQuery" runat="server" /></th>
                            <th style="width:50px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuOrden" runat="server" /></th>
                            <th style="width:50px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuIndicadorBusqueda" runat="server" /></th>
                            <th style="width:100px; text-align:left; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuTipoBusqueda" runat="server" /></th>
                            <th style="width:50px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuCodigoBusqueda" runat="server" /></th>
                            <th style="width:80px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuIndi1" runat="server" /></th>
                            <th style="width:80px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuIndi2" runat="server" /></th>
                            <th style="width:80px; text-align:left;"><asp:Label CssClass="dbnLabel" ID="lblColuLiVa" runat="server" /></th>
                        </tr>
                        <tr>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtColuCodigo" runat="server" Width="100" MaxLength="15"  /></td>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtColuTitulo" runat="server" 
                                    Width="100" MaxLength="30"  /></td>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtColuDescripcion" runat="server" Width="100" MaxLength="128" /></td>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtColuCodigoMulti" runat="server" Width="120" MaxLength="30" /></td>
                            <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlClasCss" runat="server" Width="90" Height="20">
                                <asp:ListItem Value="">Seleccione</asp:ListItem>
                                <asp:ListItem Selected="True" Value="Bounfield">Texto</asp:ListItem>
                                <asp:ListItem Value="Buttonfield">Botón</asp:ListItem>
                                <asp:ListItem Value="ImageField">Imagen</asp:ListItem>
                                </asp:DropDownList></td>
                            <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlColuTipoColumna" runat="server" Width="105" Height="20">
                                    <asp:ListItem Value="">Seleccione</asp:ListItem>
                                    <asp:ListItem Selected="True" Value="texto">Texto</asp:ListItem>
                                    <asp:ListItem Value="imagen">Imagen</asp:ListItem>
                                </asp:DropDownList></td>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtColuAncho" runat="server" Width="45" 
                                    MaxLength="4" >100</asp:TextBox>
                            </td>
                            <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlColuAlineacion" runat="server" Width="90" Height="20">
                                    <asp:ListItem Value="">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="L" Selected="True">Izquierda</asp:ListItem>
                                    <asp:ListItem Value="C">Centro</asp:ListItem>
                                    <asp:ListItem Value="R">Derecha</asp:ListItem>
                                    <asp:ListItem Value="J">Justificada</asp:ListItem>
                                </asp:DropDownList></td>
                            <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlColuFormato" runat="server" Width="100" Height="20">
                                    <asp:ListItem Value="">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="" Selected="True">Texto</asp:ListItem>
                                    <asp:ListItem Value="{0:N0}">Número</asp:ListItem>
                                    <asp:ListItem Value="{0:N1}">Número .0</asp:ListItem>
                                    <asp:ListItem Value="{0:N2}">Número .00</asp:ListItem>
                                    <asp:ListItem Value="{0:N3}">Número .000</asp:ListItem>
                                    <asp:ListItem Value="{0:N4}">Número .0000</asp:ListItem>
                                    <asp:ListItem Value="{0:d}">Fecha Corta</asp:ListItem>
                                </asp:DropDownList></td>
                            <td><asp:CheckBox ID="ckbColuVisible" runat="server" Width="50" Checked="True"/></td>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtColuImagen" runat="server" Width="50" MaxLength="30"  /></td>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtColuJquery" runat="server" Width="50" MaxLength="30"  /></td>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtColuOrden" runat="server" Width="40" MaxLength="2"  /></td>
                            <td><asp:CheckBox ID="ckbColuIndiBusqueda" runat="server" Width="50" /></td>
                            <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlColuTipoBusqueda" runat="server" Width="105" Height="20">
                                    <asp:ListItem Value="">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="S">Texto</asp:ListItem>
                                    <asp:ListItem Value="N">Númerico</asp:ListItem>
                                    <asp:ListItem Value="F">Fecha</asp:ListItem>
                                    <asp:ListItem Value="SS">Entre Texto</asp:ListItem>
                                    <asp:ListItem Value="FF">Entre Fecha</asp:ListItem>
                                    <asp:ListItem Value="NN">Entre Númerico</asp:ListItem>
                                    <asp:ListItem Value="CK">CheckBox</asp:ListItem>
                                    <asp:ListItem Value="AU">AutoCompletar</asp:ListItem>
                                    <asp:ListItem Value="CB">Combobox</asp:ListItem>
                                </asp:DropDownList></td>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtColuCodigoBusqueda" runat="server" Width="80" MaxLength="64" /></td>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtColuIndi1" runat="server" Width="40" MaxLength="1" /></td>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtColuIndi2" runat="server" Width="40" MaxLength="1" /></td>
                            <td><asp:TextBox CssClass="dbnTextbox" ID="txtColuLiVa" runat="server" Width="65" MaxLength="64" /></td>
                        </tr>
                        <tr>
                            <td colspan="19">
                               <asp:LinkButton CssClass="lnkButton" ID="btnColuIngreso" runat="server" 
                                    onclick="btnColuIngreso_Click">Insertar</asp:LinkButton>&nbsp;&nbsp;&nbsp; 
                                <asp:LinkButton CssClass="lnkButton" ID="btnColuActualiza" runat="server" 
                                    onclick="btnColuActualiza_Click">Actualizar</asp:LinkButton>
                                <br />
                                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                                <asp:GridView CssClass="Grilla" ID="grillaColumna" runat="server" 
                                    AutoGenerateColumns="False" EnableViewState="False" 
                                    onrowcommand="grillaColumna_RowCommand" 
                                    EnableModelValidation="False" GridLines="None">
                                    <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:ImageButton runat="server" ID="editar" ImageUrl="../librerias/img/botones/edit.png" 
                                            CommandName="btnEditar" Width="25" Height="21"
                                            CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:ImageButton runat="server" ID="borrar" ImageUrl="../librerias/img/botones/page_del.png"
                                             OnClientClick="return ConfirmarEliminar();" CommandName="btnEliminar" Width="25" Height="21"
                                             CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                        <asp:BoundField DataField="ORDE_COLU" HeaderText="Orden" ItemStyle-Width="50" />
                                        <asp:BoundField DataField="CODI_COLU" HeaderText="Código" ItemStyle-Width="70" />
                                        <asp:BoundField DataField="NOMB_COLU" HeaderText="Título" ItemStyle-Width="100" />
                                        <asp:BoundField DataField="DESC_COLU" HeaderText="Descripción" ItemStyle-Width="250" />
                                        <asp:BoundField DataField="CODI_RESX" HeaderText="Código Multilenguaje" ItemStyle-Width="120" />
                                        <asp:BoundField DataField="CLAS_CSS" HeaderText="Clase CSS" ItemStyle-Width="60" />
                                        <asp:BoundField DataField="TIPO_COLU" HeaderText="Tipo Columna" ItemStyle-Width="80" />
                                        <asp:BoundField DataField="ALIN_COLU" HeaderText="Alineación" ItemStyle-Width="65"/>
                                        <asp:BoundField DataField="ANCH_COLU" HeaderText="Ancho" ItemStyle-Width="65" />
                                        <asp:BoundField DataField="FORM_COLU" HeaderText="Formato" ItemStyle-Width="65" />
                                        <asp:BoundField DataField="INDI_VISI" HeaderText="Visible" ItemStyle-Width="55" />
                                        <asp:BoundField DataField="IMAG_COLU" HeaderText="Imagen" ItemStyle-Width="70" />
                                        <asp:BoundField DataField="INDI_BUSQ" HeaderText="Búsqueda" ItemStyle-Width="70" />
                                        <asp:BoundField DataField="TIPO_BUSQ" HeaderText="Tipo Búsqueda" ItemStyle-Width="90" />
                                        <asp:BoundField DataField="CODI_LIVA" HeaderText="Lista Valor" ItemStyle-Width="70" />
                                        <asp:BoundField DataField="COLU_BUSQ" HeaderText="Código Búsqueda" ItemStyle-Width="150" />
                                        <asp:BoundField DataField="VERD_BUSQ" HeaderText="Indi 1" ItemStyle-Width="45"/>
                                        <asp:BoundField DataField="FALS_BUSQ" HeaderText="Indi 2" ItemStyle-Width="45" />
                                </Columns>
                                    <FooterStyle CssClass="footerGrilla"/>
                                    <PagerStyle CssClass="pagerGrilla"/>
                                    <HeaderStyle CssClass="headerGrilla" />
                                    <RowStyle CssClass="RowStyle" />
                                    <AlternatingRowStyle CssClass="AlternatingRow" />
                                </asp:GridView>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="grillaColumna" />
                                </Triggers>
                                </asp:UpdatePanel>  
                            </td>
                        </tr>
                    </table>
             </div>
             <div id="tabs-2" class="tabs-2">
                <table>
                    <tr>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoCodigo" runat="server"  /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoTitulo" runat="server"  /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoDescripcion" runat="server"  /></td>
                        <%--<td><asp:Label CssClass="dbnLabel" ID="lblBotoTipo" runat="server"  /></td>--%>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoCodigoMulti" runat="server" Width="80" /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoClaseCss" runat="server"  /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoUrl" runat="server"  /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="dbnLabelBotoProcedimiento" runat="server" Width="110" MaxLength="30" /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoParametro1" runat="server" /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoParametro2" runat="server" /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoParametro3" runat="server" /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoParametro4" runat="server" /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoParametro5" runat="server" /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoDetalle" runat="server" /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoImagen" runat="server" /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoOrden" runat="server" /></td>
                        <td><asp:Label CssClass="dbnLabel" ID="lblBotoVisible" runat="server" /></td>
                        <td style="width:100px;"><asp:Label CssClass="dbnLabel" ID="lblBotoModo" runat="server" /></td>
                        <td style="width:100px;"></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtBotoCodigo" runat="server" ToolTip="Código Boton" Width="70" MaxLength="15" /></td>
                        <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlNombreTitulo" runat="server" Width="90">
                            <asp:ListItem Value="">Seleccione</asp:ListItem>
                            <asp:ListItem Value="btnEditar">Editar</asp:ListItem>
                            <asp:ListItem Value="btnDetalle">Detalle</asp:ListItem>
                            <asp:ListItem Value="btnArch1">Archivo 1</asp:ListItem>
                            <asp:ListItem Value="btnArch2">Archivo 2</asp:ListItem>
                            <asp:ListItem Value="btnEjecutar">Ejecutar</asp:ListItem>
                            <asp:ListItem Value="btnEliminar">Eliminar</asp:ListItem>
                            <asp:ListItem Value="btnCheck">CheckEje</asp:ListItem>
                            </asp:DropDownList></td>
                        
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtBotoDescripcion" runat="server" ToolTip="Descripcion del Boton" Width="110" MaxLength="128" /></td>
                        <%--<td><asp:DropDownList CssClass="dbnListaValor" ID="ddlTipoBoton" runat="server" Width="90">
                            <asp:ListItem Value="">Seleccione</asp:ListItem>
                            <asp:ListItem Value="B_EDIT">Editar</asp:ListItem>
                            <asp:ListItem Value="B_DETA">Detalle</asp:ListItem>
                            <asp:ListItem Value="B_DELE">Eliminar</asp:ListItem>
                            <asp:ListItem Value="B_ARC1">Archivo 1</asp:ListItem>
                            <asp:ListItem Value="B_ARC2">Archivo 2</asp:ListItem>
                            <asp:ListItem Value="B_EJEC">Ejecutar</asp:ListItem>
                            <asp:ListItem Value="B_DELE">Eliminar</asp:ListItem>
                            </asp:DropDownList>
                            </td>--%>
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtBotoCodMulti" runat="server" Width="60" MaxLength="30" /></td>
                        <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlClaseCss" runat="server" Width="90">
                            <asp:ListItem Value="">Seleccione</asp:ListItem>
                            <asp:ListItem Value="ButtonField">Botón</asp:ListItem>
                            </asp:DropDownList></td>
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtBotoUrl" runat="server" Width="110" MaxLength="128" /></td>
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtBotoProcedimiento" runat="server" Width="110" MaxLength="30" /></td>
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtBotoPara1" runat="server" Width="70" MaxLength="30" /></td>
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtBotoPara2" runat="server" Width="70" MaxLength="30" /></td>
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtBotoPara3" runat="server" Width="70" MaxLength="30" /></td>
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtBotoPara4" runat="server" Width="70" MaxLength="30" /></td>
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtBotoPara5" runat="server" Width="70" MaxLength="30" /></td>
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtBotoDetalle" runat="server" Width="90" MaxLength="64" /></td>
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtBotoImagen" runat="server" Width="90" MaxLength="64" /></td>
                        <!--
                        <td>
                            <asp:DropDownList CssClass="dbnListaValor" ID="ddlBotoImagen" Width="70" runat="server">
                                <asp:ListItem Value="borrar.png">Borrar</asp:ListItem>
                                <asp:ListItem Value="cuadrado.png">Cuadrado</asp:ListItem>
                                <asp:ListItem Value="deta.png">Detalle</asp:ListItem>
                                <asp:ListItem Value="docu.png">Documento</asp:ListItem>
                                <asp:ListItem Value="edit.png">Editar</asp:ListItem>
                                <asp:ListItem Value="letra_config.png">Letra config</asp:ListItem>
                                <asp:ListItem Value="letra_pesos.png">Letra Pesos</asp:ListItem>
                                <asp:ListItem Value="letra_suma.png">Letra Suma</asp:ListItem>
                                <asp:ListItem Value="letra_a.png">Letra A</asp:ListItem>
                                <asp:ListItem Value="letra_B.png">Letra B</asp:ListItem>
                                <asp:ListItem Value="letra_c.png">Letra C</asp:ListItem>
                                <asp:ListItem Value="letra_D.png">Letra D</asp:ListItem>
                                <asp:ListItem Value="letra_e.png">Letra E</asp:ListItem>
                                <asp:ListItem Value="letra_F.png">Letra F</asp:ListItem>
                                <asp:ListItem Value="letra_G.png">Letra G</asp:ListItem>
                                <asp:ListItem Value="letra_H.png">Letra H</asp:ListItem>
                                <asp:ListItem Value="letra_I.png">Letra I</asp:ListItem>
                                <asp:ListItem Value="letra_l.png">Letra L</asp:ListItem>
                                <asp:ListItem Value="letra_m.png">Letra M</asp:ListItem>
                                <asp:ListItem Value="letra_P.png">Letra P</asp:ListItem>
                                <asp:ListItem Value="letra_t.png">Letra T</asp:ListItem>
                                <asp:ListItem Value="letra_U.png">Letra U</asp:ListItem>
                                <asp:ListItem Value="letra_v.png">Letra V</asp:ListItem>
                                <asp:ListItem Value="pdf.png">Pdf</asp:ListItem>
                                <asp:ListItem Value="pdf_fir.png">Pdf Firmado</asp:ListItem>
                                <asp:ListItem Value="pers.png">Pers</asp:ListItem>
                                <asp:ListItem Value="pers_vari.png">Pers Vari</asp:ListItem>
                                <asp:ListItem Value="run.png">Ejecutar</asp:ListItem>
                                <asp:ListItem Value="zoom.png">Zoom</asp:ListItem>
                                <asp:ListItem Value="zoom_out.png">Zoom Out</asp:ListItem>
                                <asp:ListItem Value="zoom_out.png">Zoom Out</asp:ListItem>
                            </asp:DropDownList> 
                        </td>
                        -->
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtBotoOrden" runat="server" Width="30" MaxLength="2" /></td>
                        <td><asp:CheckBox ID="ckbBotoVisible" runat="server" Checked="True" /><br /></td>
                        <td><asp:CheckBox ID="ckbModoM" runat="server" Text="M" /><br /></td>
                        <td><asp:CheckBox ID="ckbModoCE" runat="server" Text="CE" /><br /></td>
                        <td><asp:CheckBox ID="ckbModoCI" runat="server" Text="CI"/><br /></td>
                        <td><asp:CheckBox ID="ckbModoC" runat="server" Text="C" /><br /></td>
                        <td><asp:CheckBox ID="ckbModoT" runat="server" Text="T" /><br /></td>
                    </tr>
                    <tr>
                        <td colspan="20">
                        <asp:LinkButton CssClass="lnkButton" ID="btnBotoIngresa" runat="server" 
                                onclick="btnBotoIngresa_Click">Insertar</asp:LinkButton>&nbsp;&nbsp;&nbsp; 
                            <asp:LinkButton CssClass="lnkButton" ID="btnBotoActualiza" runat="server" 
                                onclick="btnBotoActualiza_Click">Actualizar</asp:LinkButton>
                            <br />
                            <asp:UpdatePanel ID="upGrillas" runat="server">
                            <ContentTemplate>
                            <asp:GridView CssClass="Grilla" ID="grillaBoton" runat="server" AutoGenerateColumns="False" 
                                onrowcommand="grillaBoton_RowCommand" EnableModelValidation="false" EnableViewState="false" GridLines="None">
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:ImageButton runat="server" ID="editar" ImageUrl="../librerias/img/botones/edit.png" 
                                            CommandName="btnEditar" Width="25" Height="21"
                                            CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:ImageButton runat="server" ID="borrar" ImageUrl="../librerias/img/botones/page_del.png"
                                             OnClientClick="return ConfirmarEliminar();" CommandName="btnEliminar" Width="25" Height="21"
                                             CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                        <asp:BoundField DataField="ORDE_BOTO" HeaderText="Orden" ItemStyle-Width="50" />
                                        <asp:BoundField DataField="CODI_BOTO" HeaderText="Código" ItemStyle-Width="100" />
                                        <asp:BoundField DataField="NOMB_BOTO" HeaderText="Título" ItemStyle-Width="100" />
                                        <asp:BoundField DataField="DESC_BOTO" HeaderText="Descripción" ItemStyle-Width="250" />
                                        <%--<asp:BoundField DataField="TIPO_BOTO" HeaderText="Tipo" ItemStyle-Width="100" />--%>
                                        <asp:BoundField DataField="CODI_RESX" HeaderText="Código Multilenguaje" ItemStyle-Width="100" />
                                        <asp:BoundField DataField="CLAS_CSS" HeaderText="Clase CSS" ItemStyle-Width="100" />
                                        <asp:BoundField DataField="PAGE_BOTO" HeaderText="URL" ItemStyle-Width="100"/>
                                        <asp:BoundField DataField="PROC_BOTO" HeaderText="Procedimiento" ItemStyle-Width="65" />
                                        <asp:BoundField DataField="CODI_PAR1" HeaderText="Parámetro 1" ItemStyle-Width="100" />
                                        <asp:BoundField DataField="CODI_PAR2" HeaderText="Parámetro 2" ItemStyle-Width="100" />
                                        <asp:BoundField DataField="CODI_PAR3" HeaderText="Parámetro 3" ItemStyle-Width="100" />
                                        <asp:BoundField DataField="CODI_PAR4" HeaderText="Parámetro 4" ItemStyle-Width="100" />
                                        <asp:BoundField DataField="CODI_PAR5" HeaderText="Parámetro 5" ItemStyle-Width="100" />
                                        <asp:BoundField DataField="LIST_DETA" HeaderText="Detalle listador" ItemStyle-Width="100" />
                                        <asp:BoundField DataField="IMAG_BOTO" HeaderText="Imagen" ItemStyle-Width="60" />
                                        <asp:BoundField DataField="INDI_VISI" HeaderText="Visible" ItemStyle-Width="40"/>
                                        <asp:BoundField DataField="MODO_BOTO" HeaderText="Modo" ItemStyle-Width="70" />
                                </Columns>
                                <FooterStyle CssClass="footerGrilla"/>
                                <PagerStyle CssClass="pagerGrilla"/>
                                <RowStyle CssClass="RowStyle" />
                                <HeaderStyle CssClass="headerGrilla" Wrap="False"/>
                                <AlternatingRowStyle CssClass="AlternatingRow" />
                            </asp:GridView>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="grillaColumna" />
                            </Triggers>
                            </asp:UpdatePanel> 
                        </td>
                    </tr>
                </table>
             </div>
             <div id="tabs-3" class="tabs-3">
                 <table>
                     <tr>
                         <td style="width:130px;"><asp:Label CssClass="dbnLabel" ID="lblSubtitulo" runat="server"/></td>
                         <td><asp:TextBox CssClass="dbnTextArea" ID="txaSubtitulo" runat="server" Width="850" Height="30" TextMode="MultiLine" /></td>
                     </tr>
                     <tr>
                         <td style="width:130px;"><asp:Label CssClass="dbnLabel" ID="lblSQLServer" runat="server"/></td>
                         <td><asp:TextBox CssClass="dbnTextArea" ID="txaSQLServer" runat="server" Width="850" Height="250" TextMode="MultiLine" /></td>
                     </tr>
                     <tr>
                         <td><asp:Label CssClass="dbnLabel" ID="lblOracle" runat="server"/></td>
                         <td><asp:TextBox CssClass="dbnTextArea" ID="txaOracle" runat="server" Width="850" Height="250" TextMode="MultiLine" /></td>
                     </tr>
                 </table>
             </div>
             <div id="tabs-4" class="tabs-4">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate> 
                <table style="width:auto;">
                    <tr style="width:auto;">
                        <th><asp:Label CssClass="dbnLabel" ID="lblPrivilegiosModulo" runat="server"/></th>
                        <th><asp:Label CssClass="dbnLabel" ID="lblPrivilegiosRol" runat="server"/></th>
                        <th><asp:Label CssClass="dbnLabel" ID="lblPrivilegiosExcel" runat="server"/></th>
                    </tr>
                    <tr>
                        <td>
                            <asp:DropDownList ID="ddlPrivilegiosModulo" runat="server" CssClass="dbnListaValor" 
                            Width="240" Height="20" onselectedindexchanged="ddlPrivilegiosModulo_SelectedIndexChanged" AutoPostBack="true"> </asp:DropDownList>                  
                        </td>
                        <td>
                            <asp:DropDownList CssClass="dbnListaValor" ID="ddlPrivilegiosRol" runat="server" Width="240" Height="20"> </asp:DropDownList>
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox ID="ckbValidaExcel" runat="server" /></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                        <asp:LinkButton CssClass="lnkButton" ID="btnPrivilegiosIngresar" runat="server" 
                                onclick="btnPrivilegiosIngresar_Click">Insertar</asp:LinkButton>
                            <br />
                            <asp:GridView ID="grillaPrivilegios" runat="server" AutoGenerateColumns="false" GridLines="None"
                             onrowcommand="grillaPrivilegios_RowCommand" EnableViewState="false" EnableModelValidation="false">
                             <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton runat="server" ImageUrl="~/librerias/img/botones/page_del.png" 
                                        ID="Edit" CommandName="btnEliminar" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" OnClientClick="return ConfirmarEliminar();" Width="25" Height="21" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="CODI_MODU" HeaderText="Módulo" ItemStyle-Width="250"/>
                                <asp:BoundField DataField="CODI_ROUS" HeaderText="Rol" ItemStyle-Width="250" />
                                <asp:BoundField DataField="EXPT_EXLS" HeaderText="Excel" ItemStyle-Width="20" />
                            </Columns>
                            <FooterStyle CssClass="footerGrilla" />
                            <PagerStyle CssClass="pagerGrilla" />
                            <RowStyle CssClass="RowStyle" />
                            <HeaderStyle CssClass="headerGrilla" />
                            <AlternatingRowStyle CssClass="AlternatingRow" />                            
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlPrivilegiosModulo" />
                    <asp:AsyncPostBackTrigger ControlID="grillaPrivilegios" />
                </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
        <div id="divError" style="clear:both;">
            <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
        </div>
    </div> 
</div>
</asp:Content>