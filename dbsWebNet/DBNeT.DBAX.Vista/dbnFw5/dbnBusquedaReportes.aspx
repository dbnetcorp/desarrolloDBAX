<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbnBusquedaReportes.aspx.cs" Inherits="dbnBusquedaReportes" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="../librerias/jquery/1.9.0/jquery-1.9.0.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            // Add the value of "Search..." to the input field and a class of .empty
            $(".search").val("Buscar...").addClass("empty");
            //When Click in input clear text
            $(".search").click(function () {
                $(this).val("");
            });
            // When the focus on #search is lost
            $(".search").blur(function () {
                // If the input field is empty
                if ($(this).val() == "") {
                    // Add the text "Search..." and a class of .empty
                    $(this).val("Buscar...");
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    <%--<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </asp:ToolkitScriptManager>--%>
<div class="page">
    <div class="busqueda">
        <asp:TextBox CssClass="search" ID="txtBusqueda" runat="server"/>
        <asp:ImageButton CssClass="search-button" ID="btnBusqueda" 
            ImageUrl="../librerias/img/botones/search.png" runat="server" 
            onclick="btnBusqueda_Click" />
    </div>
    <div class="pnlBusqueda">
        <asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/>
        <div class="divLink" id="divLink" runat="server">
            <div class="divHijo" id="divHijo" runat="server">
            </div>
        </div>
    </div>
</div>
</asp:Content>