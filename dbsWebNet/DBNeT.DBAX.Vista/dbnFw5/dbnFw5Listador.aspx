<%@ Page Title="" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPageNoTimer.master" AutoEventWireup="true" 
CodeFile="dbnFw5Listador.aspx.cs" Inherits="dbnFw5Listador"  EnableEventValidation="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="../librerias/jquery/calendario_dw/jquery-1.4.4.min.js" type="text/javascript"></script>
    <script src="../librerias/jquery/calendario_dw/calendario_dw.js" type="text/javascript"></script>
    <script src="../librerias/jquery/1.8.2/jquery-1.8.2.js" type="text/javascript"></script>
    <link href="../librerias/css/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../librerias/css/StyleUI.css" rel="stylesheet" type="text/css" />
    <script src="../librerias/jquery/2.0.2/jquery-2.0.2.js" type="text/javascript"></script>
    <script src="../librerias/jquery/UI/1.9.0/jquery-ui-1.9.0.js" type="text/javascript"></script>
    <script src="../librerias/jquery/UI/1.10.0/jquery-ui-1.10.0.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            var valorDdl;
            function runEffect() {
                // run the effect
                $("#contenidoBusqueda").show("blind", 500, null);
            };
            //callback function to bring a hidden box back
            function callback() {
                setTimeout(function () {
                    $("#contenidoBusqueda").hide("blind").fadeOut();
                }, 500);
            };
            $("#btnBuscar").click(function () {
                if ($("#contenidoBusqueda").is(':hidden'))
                    runEffect();
                else
                    callback();
            });
            $("#contenidoBusqueda").hide();

            $(".ButtonField-btnEditar").attr("title", "Editar");
            $(".-btnEditar").attr("title", "Editar");
            $(".ButtonField-btnEjecutar").attr("title", "Ejecutar");
            $(".-btnEjecutar").attr("title", "Ejecutar");
            $(".ButtonField-btnDetalle").attr("title", "Detalle");
            $(".-btnDetalle").attr("title", "Detalle");
        });

        $("#bodyCP_ddlLista").change(function () {
            valorDdl = $("#bodyCP_ddlLista:selected").val();
        });

        function ConfirmarEliminar() {
            if (confirm("Desea Eliminar el registro") == true)
                return true;
            else
                return false;
        }
    </script>
    <script type="text/javascript">
        var TotalChkBx;
        var Counter;

        window.onload = function () {
            //Get total no. of CheckBoxes in side the GridView.
            TotalChkBx = parseInt('<%= this.grilla.Rows.Count %>');
            //Get total no. of checked CheckBoxes in side the GridView.
            Counter = 0;
        }

        function HeaderClick(CheckBox) {
            //Get target base & child control.
            var TargetBaseControl = document.getElementById('<%= this.grilla.ClientID %>');
            var TargetChildControl = "chkSelect";

            //Get all the control of the type INPUT in the base control.
            var Inputs = TargetBaseControl.getElementsByTagName("input");

            //Checked/Unchecked all the checkBoxes in side the GridView.
            for (var n = 0; n < Inputs.length; ++n)
                if (Inputs[n].type == 'checkbox' && Inputs[n].id.indexOf(TargetChildControl, 0) >= 0)
                    Inputs[n].checked = CheckBox.checked;
            //Reset Counter
            Counter = CheckBox.checked ? TotalChkBx : 0;
        }

        function ChildClick(CheckBox, HCheckBox) {
            //get target base & child control.
            var HeaderCheckBox = document.getElementById(HCheckBox);

            //Modifiy Counter;            
            if (CheckBox.checked && Counter < TotalChkBx)
                Counter++;
            else if (Counter > 0)
                Counter--;

            //Change state of the header CheckBox.
            if (Counter < TotalChkBx)
                HeaderCheckBox.checked = false;
            else if (Counter == TotalChkBx)
                HeaderCheckBox.checked = true;
        }
    </script>

    <style type="text/css">
        @media print
        {
            .divBotones
            { visibility:hidden;}
            .lblListador
            {visibility:hidden;}
            .divMenu
            { visibility:hidden;}
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    <div class="page">    
    <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnPrimeraPagina" ID="btnPrimeraPagina" runat="server" 
                onclick="btnPrimeraPagina_Click" ImageUrl="~/librerias/img/botones/page_first.png" />
            <asp:ImageButton CssClass="btnPaginaAnterior" ID="btnPaginaAnterior" runat="server" 
                onclick="btnPaginaAnterior_Click" ImageUrl="~/librerias/img/botones/page_back.png" />
            <asp:ImageButton CssClass="dbn_btnPaginaSiguiente" ID="btnPaginaSiguiente" runat="server" 
                onclick="btnPaginaSiguiente_Click" ImageUrl="~/librerias/img/botones/page_next.png" />
            <asp:ImageButton CssClass="dbn_btnUltimaPagina" ID="btnUltimaPagina" runat="server" 
                onclick="btnUltimaPagina_Click" ImageUrl="~/librerias/img/botones/page_last.png" />
            <input type="button" class="dbn_btnBuscar" id="btnBuscar" name="buscar" title="Búsqueda Avanzada" />
            <asp:ImageButton CssClass="dbn_btnVolver" ID="btnVolver" runat="server" 
                onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png" />
            <asp:ImageButton CssClass="dbn_btnExcel" ID="btnExcel" runat="server"
                onclick="btnExcel_Click" ImageUrl="~/librerias/img/botones/page_save.png" />
            <asp:ImageButton CssClass="dbn_btnAgregar" ID="btnAgregar" runat="server" 
                onclick="btnAgregar_Click" Visible="false" ImageUrl="~/librerias/img/botones/page_new.png" />  
            <asp:CheckBox ID="ckbTranspuesto" CssClass="ckbTranspuesto" AutoPostBack="true" 
                runat="server" oncheckedchanged="ckbTranspuesto_CheckedChanged" />
            <asp:ToggleButtonExtender ID="btnTransponer" runat="server"
                CheckedImageUrl="~/librerias/img/botones/page_rot.png" UncheckedImageUrl="~/librerias/img/botones/page_rot.png"
                TargetControlID="ckbTransPuesto" ImageWidth="31" ImageHeight="27" CheckedImageAlternateText="Tabular"
                UncheckedImageAlternateText="No Tabular"/>
        </div>
        <asp:UpdatePanel ID="up1" runat="server">
            <ContentTemplate>
            <div id="Div1" class="subtitulo">
                <asp:Label CssClass="dbnSubTitulo" ID="lblSubtitulo" runat="server"></asp:Label>
            </div>
            <div class="lblListador">
                <div id="divlblListador">
                    <div id="divPaginas" class="divPaginas">
                        <asp:Label CssClass="lblIzquierdo" ID="lblPaginas" runat="server"/>
                        <asp:Label CssClass="lblIzquierdo" ID="lblPaginaActual" runat="server"/>
                        <asp:Label CssClass="lblIzquierdo" ID="lblDivisor" runat="server">/</asp:Label>
                        <asp:Label CssClass="lblIzquierdo" ID="lblTotalPaginas" runat="server"/>
                    </div>
                    <div id="divRegistros" class="divRegistros">
                        <asp:Label CssClass="lblIzquierdo" ID="lblTotalRegistro" runat="server"/>
                        <asp:Label CssClass="lblIzquierdo" ID="lblTotalRegistros" runat="server" />
                    </div>
                    <div id="DivddlRegPag" class="DivddlRegPag">
                        <asp:Label CssClass="lblIzquierdo" ID="lblRegPag" runat="server"/>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddlRegPag" runat="server" 
                            onselectedindexchanged="ddlRegPag_SelectedIndexChanged" AutoPostBack="true" Width="50" >
                            <asp:ListItem>1</asp:ListItem>
                            <asp:ListItem>5</asp:ListItem>
                            <asp:ListItem>10</asp:ListItem>
                            <asp:ListItem>15</asp:ListItem>
                            <asp:ListItem>25</asp:ListItem>
                            <asp:ListItem>30</asp:ListItem>
                            <asp:ListItem>50</asp:ListItem>
                            <asp:ListItem>100</asp:ListItem>
                            <asp:ListItem>200</asp:ListItem>
                            <asp:ListItem>500</asp:ListItem>
                            <asp:ListItem>1000</asp:ListItem>
                            <asp:ListItem>5000</asp:ListItem>
                            </asp:DropDownList>
                    </div>
                </div>
            </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnPaginaSiguiente" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btnPaginaAnterior" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btnPrimeraPagina" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btnUltimaPagina" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btnConsultaDinamica" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
    <div id="divcheck">
   <table>
    <td> 
         <%--Combobox--%>
            <asp:DropDownList CssClass="dbnListaValor" ID="ddlListaEje" Width="200" 
            Visible="false" runat="server"> 
            </asp:DropDownList>
        <td />
            <td>
            <asp:ImageButton ID="btnchkProcesar" runat="server" Visible="false"
             onclick="btnchkProcesar_Click" 
           ImageUrl="~/librerias/img/botones/bt_generar.png" />
            </td>
             <td>
              <asp:Label ID="lblCorrect" CssClass="lblIzquierdo" runat="server"/>
            </td>
        </table>
    </div>
    <div id="pnlPadreBusqueda" class="padreBusqueda" style=" position:relative; width:1024px;">
        <div id="contenidoBusqueda" class="pnlPadreBusqueda">
            <asp:UpdatePanel ID="up2" runat="server">
                <ContentTemplate>
                <asp:Label CssClass="lblIzquierdo" ID="lblBusqueda" runat="server"/>
                    <div id="pnlBusqueda" runat="server">
                    <%--TextBox con autoComplete 1 --%>
                        <asp:TextBox CssClass="dbnTextArea" ID="txtBusquedaAutoComplete1" runat="server" Visible="false"/>
                        <asp:AutoCompleteExtender ID="txtBusquedaAutoComplete1_Extender"
                            runat="server"
                            ContextKey="1"
                            CompletionSetCount="15"
                            CompletionInterval="0"
                            CompletionListElementID="autoCompleteDropDownPanel1"
                            DelimiterCharacters=";"
                            Enabled="true"
                            MinimumPrefixLength="1"
                            ServiceMethod="GetCompletionList"
                            ServicePath=""
                            TargetControlID="txtBusquedaAutoComplete1"
                            UseContextKey="true" />
                        <asp:Panel ID="autoCompleteDropDownPanel1"
                            runat="server"
                            CssClass="dbnTextArea"
                            ScrollBars="Vertical"
                            Height="160px"
                            Visible="false"/>

                    <%-- Textbox con extender fecha 1 --%>
                        <asp:TextBox ID="txtBusquedaFecha1" runat="server" Visible="false"/>
                        <asp:CalendarExtender ID="CalendarExtender3" runat="server"
                            Enabled="true" TargetControlID="txtBusquedaFecha1" Format="d/MM/yyyy">
                        </asp:CalendarExtender>
                    
                    <%-- Textbox con extender fecha fecha 1 --%>
                        <asp:TextBox ID="txtBusquedaFechaFecha1" runat="server" Visible="false"/>
                        <asp:CalendarExtender ID="CalendarExtender1" runat="server" 
                            Enabled="true" TargetControlID="txtBusquedaFechaFecha1" Format="d/MM/yyyy">
                        </asp:CalendarExtender>
                    
                        <asp:TextBox ID="txtBusquedaFecha2" runat="server" Visible="false"/>
                        <asp:CalendarExtender ID="CalendarExtender4" runat="server"
                            Enabled="true" TargetControlID="txtBusquedaFecha2" Format="d/MM/yyyy">
                        </asp:CalendarExtender>

                    <%-- Textbox con extender fecha fecha 2 --%>
                        <asp:TextBox ID="txtBusquedaFechaFecha2" runat="server" Visible="false"/>
                        <asp:CalendarExtender ID="CalendarExtender2" runat="server" 
                            Enabled="true" TargetControlID="txtBusquedaFechaFecha2" Format="d/MM/yyyy">
                        </asp:CalendarExtender>

                    <%--Combobox--%>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddlLista" Width="350" 
                        Visible="false" runat="server"
                        onselectedindexchanged="ddlLista_SelectedIndexChanged" >
                        </asp:DropDownList>
                    </div>
                    <div id="pnlBotones">
                        <asp:CheckBox ID="ckbConsulta" runat="server" Checked="false" CssClass="lblIzquierdo"/>
                        <br />
                        <asp:ImageButton ID="btnConsultaDinamica" runat="server" CssClass="dbn_btnBuscar2"
                        onclick="btnConsultaDinamica_Click" ImageUrl="~/librerias/img/botones/bt_buscar.png" />
                    </div>
                    <div style="visibility:hidden"></div>
                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="txtBusquedaAutoComplete1" />
                    <asp:AsyncPostBackTrigger ControlID="ddlLista" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divGrilla" class="divGrilla" runat="server" >
        <asp:UpdatePanel ID="up_grilla" runat="server">
            <ContentTemplate>
                <asp:ImageButton ID="btnEditarTabular" 
                    ImageUrl="~/librerias/img/botones/edit.png" runat="server" Visible="false" 
                    onclick="btnEditarTabular_Click" />
                <asp:ImageButton ID="btnDetalleTabular1" runat="server" Visible="false" 
                    onclick="btnDetalleTabular1_Click"/>
                <asp:ImageButton ID="btnDetalleTabular2"  runat="server" Visible="false" 
                    onclick="btnDetalleTabular2_Click"/>
                <asp:ImageButton ID="btnDetalleTabular3"  runat="server" Visible="false" 
                    onclick="btnDetalleTabular3_Click"/>
                <asp:ImageButton ID="btnDetalleTabular4"  runat="server" Visible="false" 
                    onclick="btnDetalleTabular4_Click"/>
                <asp:ImageButton ID="btnDetalleTabular5"  runat="server" Visible="false" 
                    onclick="btnDetalleTabular5_Click"/>
                <asp:ImageButton ID="btnDetalleTabular6"  runat="server" Visible="false" 
                    onclick="btnDetalleTabular6_Click"/>
                <asp:ImageButton ID="btnDetalleTabular7" runat="server" Visible="false" 
                    onclick="btnDetalleTabular7_Click"/>
                <asp:ImageButton ID="btnDetalleTabular8" runat="server" Visible="false" 
                    onclick="btnDetalleTabular8_Click"/>
                <asp:ImageButton ID="btnDetalleTabular9" runat="server" Visible="false" 
                    onclick="btnDetalleTabular9_Click"/>
                <asp:ImageButton ID="btnDetalleTabular10" runat="server" Visible="false" 
                    onclick="btnDetalleTabular10_Click"/>
                <asp:ImageButton ID="btnEjecutarTabular" 
                ImageUrl="~/librerias/img/botones/run.png" runat="server" Visible="false" 
                    onclick="btnEjecutarTabular_Click" />
                
                <asp:GridView ID="grilla" runat="server" AutoGenerateColumns="False"  GridLines="None"
                    onrowcommand="grilla_RowCommand" EnableViewState="False" EnableModelValidation="False" 
                    CssClass="Grilla">
                    <Columns>
                        <asp:TemplateField>
                        <HeaderTemplate>
                                <asp:CheckBox ID="chkTodas" runat="server" onclick="javascript:HeaderClick(this);"
                                    AutoPostBack="true" Visible="true" /> 
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="server" Visible="true"/>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle CssClass="footerGrilla" />
                    <PagerStyle CssClass="pagerGrilla" />
                    <RowStyle CssClass="RowStyle" />
                    <HeaderStyle CssClass="headerGrilla" />
                    <AlternatingRowStyle CssClass="AlternatingRow" />                                    
                </asp:GridView>
                <%--Grilla para el la exportacion de Datos--%>
                <asp:GridView ID="grillaExport" CssClass="Grilla" runat="server" 
                    AutoGenerateColumns="False" EnableViewState="false" 
                    EnableModelValidation="false" GridLines="None">
                    <AlternatingRowStyle CssClass="AlternatingRow"  />
                </asp:GridView>
                <%--Grilla para datos transpuestos--%>
                <asp:GridView ID="grillaTabular" CssClass="GrillaTabular" runat="server" 
                    AutoGenerateColumns="false" EnableViewState="false" 
                    onrowcommand="grilla_RowCommand" 
                    EnableModelValidation="false" GridLines="None">
                    <FooterStyle CssClass="footerGrilla"/>
                    <PagerStyle CssClass="pagerGrilla"/>
                    <HeaderStyle CssClass="headerGrilla" BorderColor="Transparent" />
                    <RowStyle CssClass="RowStyle" />
                    <AlternatingRowStyle CssClass="AlternatingRow" />
                    <Columns>
                        <asp:TemplateField HeaderText="Campo" HeaderStyle-HorizontalAlign="Center" >
                            <ItemTemplate>
                                <asp:Label ID="lblCampo" runat="server" CssClass="lblIzquierdo" text='<%# Bind("Campo") %>'/>
                            </ItemTemplate>
                            <ItemStyle Width="200" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Valor" HeaderStyle-HorizontalAlign="Justify" >
                            <ItemTemplate>
                                <asp:Label ID="lblValor" runat="server" text='<%# Bind("Valor") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="grilla" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
    
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
</div>
</asp:Content>