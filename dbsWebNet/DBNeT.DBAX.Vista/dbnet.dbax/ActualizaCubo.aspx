<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="ActualizaCubo.aspx.cs" Inherits="dbax_ActualizaCubo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style1
        {
            width: 200px;
            height: 24px;
        }
        .style2
        {
            height: 24px;
        }
        .style3
        {
            width: 200px;
            height: 22px;
        }
        .style4
        {
            height: 22px;
        }
        .style5
        {
            width: 200px;
            height: 23px;
        }
        .style6
        {
            height: 23px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
 
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
                <td class="style1">
                    <asp:Label ID="lblTipoActu" runat="server" CssClass="lblIzquierdo"></asp:Label>
                </td>
                <td class="style2">
                    <asp:RadioButtonList ID="rbTipoActu" runat="server" CssClass="lblIzquierdo" 
                        onselectedindexchanged="rbTipoActu_SelectedIndexChanged">
                        <asp:ListItem Value="T">Todos los períodos</asp:ListItem>
                        <asp:ListItem Selected="True" Value="P">Por período</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>
            <tr>
                <td class="style3"><asp:Label CssClass="lblIzquierdo" ID="lblCorrInst" 
                        runat="server" Visible="False"/></td>
                <td class="style4">
                    <asp:DropDownList CssClass="dbnListaValor" ID="ddlCorrInst" runat="server" 
                        Width="200" Visible="False"/>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="lblError" ErrorMessage="Debe seleccionar un período" ControlToValidate="ddlCorrInst"/>
                </td>
            </tr>
            <tr>
                <td class="style5"></td>
                <td class="style6"></td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Label ID="lblError" runat="server" CssClass="dbnLabel" />
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
                        </Triggers>
                    </asp:UpdatePanel>
                    <asp:Timer ID="Timer1" runat="server" Interval="5000">
                    </asp:Timer>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>

