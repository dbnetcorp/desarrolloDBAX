<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbax_calc_mone.aspx.cs" Inherits="DBAX_dbax_calc_mone" %>

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
                $valor = $("#bodyCP_ddlCorrInst").val();
                if ($valor != "") {
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
    <%--<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" ScriptMode="Release">
    </asp:ToolkitScriptManager>--%>

<div class="page"> 
    <div id="botones3" style="visibility:visible;" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
    </div>
    <div id="contenFormulario">
        <table>
            <tr>
                <td style="width:200px;"><asp:Label CssClass="lblIzquierdo" ID="lblCorrInst" runat="server"/></td>
                <td><asp:DropDownList CssClass="dbnListaValor" ID="ddlCorrInst" runat="server" Width="200"/>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="lblError" ErrorMessage="Debe seleccionar un período" ControlToValidate="ddlCorrInst"/>
                </td>
            </tr>
            <tr>
                <td style="width:200px;"></td>
                <td></td>
            </tr>
            <tr>
                <td style="width:200px;"></td>
                <td></td>
            </tr>
        </table>
    </div>
    <div class="toggler">
        <div id="effect" class="ui-widget-content ui-corner-all" style="width:280px;">
            <h3 class="ui-widget-header ui-corner-all">Registro Ingresado</h3>
            <p>su solicitud está procesado.</p>
        </div>
    </div>
    <div>
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/>
    </div>
</div>
</asp:Content>