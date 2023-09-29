<%@ Page Title="Calculo " Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbax_calc_actu.aspx.cs" Inherits="dbax_calc_actu" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../librerias/jquery/UI/1.10.3/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="../librerias/jquery/UI/1.10.3/jquery-ui.js" type="text/javascript"></script>
    <script src="../librerias/jquery/1.9.1/jquery-1.9.1.js" type="text/javascript"></script>
    <script>
        $(function () {
            // run the currently selected effect
            function runEffect() {
                // get effect type from
                var selectedEffect = "blind";
                // run the effect
                $("#effect").show(selectedEffect, 500, callback());
            };

            //callback function to bring a hidden box back
            function callback() {
                setTimeout(function () {
                    $("#effect").hide("drop").fadeOut();
                }, 2000);
            };

            // set effect from select menu value
            $("#bodyCP_btnActualizar").click(function () {
                $tipoTaxo = $("#bodyCP_ddlTipoTaxo").val();
                $segmento = $("#bodyCP_ddlSegmento").val();
                if ($tipoTaxo != "" && $segmento != "") {
                    runEffect();
                    setTimeout(function () {
                        return true;
                    }, 8000);
                    
                }
            });
            $("#effect").hide();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    <div class="page">
        <div id="botones3" style="visibility:visible;" class="div3Botones">
            <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
            <div class="divBotones">
                <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" 
                    ImageUrl="~/librerias/img/botones/aceptar.png" onclick="btnActualizar_Click"/>
                <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" 
                    ID="btnVolver" runat="server" ImageUrl="~/librerias/img/botones/page_exit.png" 
                    onclick="btnVolver_Click"/>
            </div>
        </div>
        <div id="contenFormulario">
            <table>
                <tr>
                    <td style="width:250px;"><asp:Label CssClass="lblIzquierdo" ID="Label1" runat="server" Text="Tipo Taxonomía" /></td>
                    <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlTipoTaxo" runat="server"/>
                        <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlTipoTaxo" InitialValue="" ErrorMessage="Debe Seleccionar un Tipo de Taxonomía"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td style="width:250px;"><asp:Label CssClass="lblIzquierdo" ID="Label2" runat="server" Text="Segmento" /></td>
                    <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlSegmento" runat="server"/>
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddlSegmento" InitialValue="" ErrorMessage="Debe Seleccionar un Segmento"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td style="width:250px;"><asp:Label CssClass="lblIzquierdo" ID="Label3" runat="server" Text="Periodo desde"/></td>
                    <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlPeriodoDesde" runat="server"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:250px;"><asp:Label CssClass="lblIzquierdo" ID="Label4" runat="server" Text="Periodo hasta"/></td>
                    <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlPeriodoHasta" runat="server"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:250px;"><asp:Label CssClass="lblIzquierdo" ID="Label5" runat="server" Text="Periodo actualizado"/></td>
                    <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlPeriodoActualizado" runat="server"/>
                    </td>
                </tr>
            </table>
        </div>
    <div class="toggler">
        <div id="effect" class="ui-widget-content ui-corner-all" style="width:280px;">
            <h3 class="ui-widget-header ui-corner-all">Registro Ingresado</h3>
            <p>Su solicitud está siendo procesada.</p>
        </div>
    </div>
    </div>
</asp:Content>