<%@ Page Title="" Language="C#"  MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnConfiguracionRolMenu.aspx.cs" Inherits="dbnConfiguracionRolMenu" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script>
    function jstoasp() {
        document.getElementById("bodyCP_txtMenu").value = "";
        var chks = document.getElementsByName("rolmn[]");
        for (x = 0; x < chks.length; x++) {
            if (chks[x].checked)
                document.getElementById("bodyCP_txtMenu").value += chks[x].value + "|";
        }
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    <div class="page" > 
    <div id="botones3" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" OnClientClick="jstoasp();" 
                onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" 
                runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
    </div>

    <div id="contenFormulario">
        <div style="margin-left:320px; margin-top:190px; height:60px; position:fixed; ">
            <table style=" border:0px; border-width:0px;">
                <tr>
                    <td style="width:100px;">
                        <asp:Label ID="lblModulo" runat="server" CssClass="lblIzquierdo" Text="Modulo" style="width:100px;" />
                    </td>
                    <td style="width:200px;">
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddlModulo" runat="server" Width="200px" AutoPostBack="True" onselectedindexchanged="ddlModulo_SelectedIndexChanged"></asp:DropDownList><br />
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">
                        <asp:Label ID="lblRol" runat="server" CssClass="lblIzquierdo" Text="Rol" style="width:100px;" />
                    </td>
                    <td style="width:200px;">
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddlRol" runat="server" Width="200px" AutoPostBack="True" onselectedindexchanged="ddlRol_SelectedIndexChanged"></asp:DropDownList>
                    </td>
                </tr>
            </table>
        </div>
        <div>
            <div class="rolDBSoft" style="border-color:Gray; overflow:auto; width: 310px; max-height: 440px">
                <asp:HiddenField ID="txtMenu" runat="server" />
                <% = _gsElMenu %>
            </div>
        </div>
    </div>
    <div id="divError" style="clear:both;">
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/><br />
    </div>
</div>
</asp:Content>