<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="CalculadorIndicadores.aspx.cs" Inherits="Website_CalculadorIndicadores" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script>
        //        $("#bodyCP_Calcular_Indi_Click").blur

            $(function () {
            // run the currently selected effect
            function runEffect() {
                // run the effect
                $("#effect").show("shake", 500, callback());
            };

            //callback function to bring a hidden box back
            function callback() {
                setTimeout(function () {
                    $("#effect").hide("drop").fadeOut();
                }, 2000);
            };
            // set effect from select menu value
            $("#bodyCP_Calcular_Indi_Click").click(function () {
                    runEffect();
                    setTimeout(function () {
                        return true;
                    }, 8000);
            });
            $("#effect").hide();
        });
  </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="page">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <div id="botones3" style="visibility:visible;" class="div3Botones">
            <div class="divTitulo">
            <asp:Label ID="lblTitulo" runat="server" Text="Label" CssClass="dbnTitulo">Cálculo de Indicadores</asp:Label>
            </div>
            <div class="divBotones">
                <asp:ImageButton CssClass="dbn_btnVolver" ID="Calcular_Indi_Click" runat="server" 
                            ImageUrl="~/librerias/img/botones/aceptar.png" onclick="Calcular_Indi_Click_Click" />
                <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" 
                        onclick="bt_Volver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
            </div>
        </div>
        <table class="Selectores" >
            <tr>
                <td class="style1">
                    <asp:Label ID="Label6" runat="server" CssClass="lblIzquierdo" Text="Período"/>
                </td>
                <td class="style1">
                    <asp:DropDownList CssClass="dbnListaValor" ID="ddl_CorrInst" runat="server" AutoPostBack="True" Width="353px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="style1">
                    <asp:Label ID="Label7" runat="server" CssClass="lblIzquierdo" Text="Grupo"/>
                </td>
                <td class="style1">
                    <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Grupo" runat="server" AutoPostBack="True" 
                            onselectedindexchanged="ddl_Grupo_Select" Width="353px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="style1">
                    <asp:Label ID="Label2" runat="server" CssClass="lblIzquierdo" Text="Segmento"/>
                </td>
                <td class="style1">
                    <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Segmento" runat="server" AutoPostBack="True" 
                            onselectedindexchanged="ddl_Segmento_Select" Width="353px">
                    </asp:DropDownList>
                </td>
            </tr>
            <%--<tr>
                <td >
                    <asp:Label ID="Label3" runat="server" Text="Filtro Empresa" 
                        CssClass="lblIzquierdo"/>
                </td>
                <td >
                    <asp:TextBox ID="Filtro_Empresa" runat="server" AutoPostBack="True" 
                        Height="20px" ontextchanged="Filtro_Empresa_TextChanged" Width="353px"></asp:TextBox>
                    <asp:AutoCompleteExtender ID="tb_filtroConcepto_AutoCompleteExtender" 
                        runat="server" CompletionInterval="0" 
                        CompletionListElementID="autocompleteDropDownPanel" CompletionSetCount="10" 
                        DelimiterCharacters=";" Enabled="True" ServiceMethod="GetCompletionList" 
                        ServicePath="" TargetControlID="Filtro_Empresa" UseContextKey="True">
                    </asp:AutoCompleteExtender>
                    <asp:Panel ID="autocompleteDropDownPanel" runat="server" 
                        CssClass="lblIzquierdo" Height="100px" ScrollBars="Vertical" Width="353px" />
                </td>
            </tr>--%>
            <%--<tr>
                <td class="style1">
                    <asp:Label ID="Label1" runat="server" Text="Empresa" 
                CssClass="lblIzquierdo"/>
                </td>
                <td class="style1">
                    <asp:DropDownList CssClass="dbnListaValor" ID="ddl_CodiEmpr" runat="server"  Width="353px" 
                        AutoPostBack="true" >
                    </asp:DropDownList>
                </td>
            </tr>--%>
            <tr>
                <td><asp:Label CssClass="lblIzquierdo" ID="lblTaxonomia" runat="server" Text="Taxonomía"/></td>
                <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlTipoTaxo" runat="server" 
                        Width="353px" AutoPostBack="True" 
                        onselectedindexchanged="ddlTipoTaxo_SelectedIndexChanged"/>
                </td>
            </tr>
            <tr>
                <td class="style3">
                    <asp:Label ID="lb_error" runat="server" CssClass="Error" Text="Label"/>
                </td>
                <td class="style3">
                    &nbsp;</td>
            </tr>
            </table>
        <table>
            <tr>
                <td style="width:200px;"></td>
                <td>
                    <asp:CheckBox CssClass="lblIzquierdo" ID="ckbTodos" AutoPostBack="true" runat="server" Text="Seleccionar Todos" 
                        oncheckedchanged="ckbTodos_CheckedChanged" />
                </td>
            </tr>
            <tr>
                <td class="style4"></td>
                <td class="style4">
                    <asp:CheckBoxList ID="CheckBoxList1" runat="server" AutoPostBack="true"
                        CssClass="lblIzquierdo" Height="16px" Width="350px">
                    </asp:CheckBoxList>
                    <br />
                    <br />
                </td>
            </tr>
        </table>
    </ContentTemplate>
    </asp:UpdatePanel>
    </div>
</div>
</asp:Content>