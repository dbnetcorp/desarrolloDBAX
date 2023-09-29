<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbax_mant_homo_deta.aspx.cs" Inherits="DBAX_dbax_mant_homo_deta" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../librerias/CSS/jquery.sheet.css" rel="stylesheet" type="text/css" />
    <link href="../librerias/CSS/theme/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../librerias/CSS/jquery.colorPicker.css" rel="stylesheet" type="text/css" />
    <meta http-equiv="cache-control" content="no-cache"/>
    <script src="../librerias/js/jquery-ui/jquery-1.5.2.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery-ui/jquery.sheet.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery-ui/parser.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery.scrollTo-min.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery-ui/ui/jquery-ui.min.js" type="text/javascript"></script>
    <script src="../librerias/js/raphael-min.js" type="text/javascript"></script>
    <script src="../librerias/js/g.raphael-min.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery.colorPicker.min.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery.elastic.min.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery-ui/jquery.sheet.advancedfn.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery-ui/jquery.sheet.financefn.js" type="text/javascript"></script>
    <style type="text/css">
        .style1
        {
            height: 22px;
        }
        .style2
        {
            width: 150px;
            height: 22px;
        }
        .style3
        {
            width: 900px;
            height: 22px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="page">
    <div id="botones3" style="visibility:visible;" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblRepoTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
            <asp:ImageButton CssClass="dbn_btnEliminar" ID="btnEliminar" runat="server" onclick="btnEliminar_Click" ImageUrl="~/librerias/img/botones/page_del.png"/>
            <asp:ImageButton CssClass="dbn_btnVolver" CausesValidation="false" ID="btnVolver" runat="server" onclick="btnVolver_Click" ImageUrl="~/librerias/img/botones/page_exit.png"/>
        </div>
        </div>

    <div id="contenFormulario">
        <asp:UpdatePanel ID="UpdatePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <table>
                    <tr>
                        <td><asp:Label CssClass="lblIzquierdo" ID="lblCodiHoco" runat="server"/></td>
                        <td><asp:TextBox CssClass="dbnTextbox" ID="txtCodiHoco" runat="server" Width="200"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="style1">
                            <asp:Label ID="lblTaxoOrig" runat="server" CssClass="lblIzquierdo"></asp:Label>
                        </td>
                        <td class="style1">
                            <asp:TextBox ID="txtTaxoOrig" runat="server" CssClass="dbnTextbox" 
                                ReadOnly="True" Width="200"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:150px;"><asp:Label CssClass="lblIzquierdo" ID="lblPrefConc" runat="server"/></td>
                        <td style="width:900px;"><asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" 
                                ID="ddlPrefConc" runat="server" Width="900" 
                                onselectedindexchanged="ddlPrefConc_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                        
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="Label3" runat="server" CssClass="lblIzquierdo" 
                                Text="Filtro Concepto" />
                        </td>
                        <td style="width:900px;">
                            <asp:TextBox ID="Filtro_ConcOrig" runat="server" AutoPostBack="True" 
                                CssClass="dbnTextbox" ontextchanged="Filtro_ConcOrig_TextChanged" 
                                width="896px"></asp:TextBox>
                            <asp:AutoCompleteExtender ID="tb_filtroConcepto_AutoCompleteExtender" 
                                runat="server" CompletionInterval="0" 
                                CompletionListElementID="autocompleteDropDownPanelO" CompletionSetCount="10" 
                                DelimiterCharacters=";" Enabled="True" ServiceMethod="GetCompletionListOrig" 
                                ServicePath="" TargetControlID="Filtro_ConcOrig" UseContextKey="True">
                            </asp:AutoCompleteExtender>
                            <asp:Panel ID="autocompleteDropDownPanelO" runat="server" CssClass="dbnLabel" 
                                height="100px" ScrollBars="Vertical" />
                        </td>
                    </tr>
                    
                    <tr>
                        <td>
                            <asp:Label ID="lblCodiConc" runat="server" CssClass="lblIzquierdo" />
                        </td>
                        <td style="width:900px;">
                            <asp:DropDownList ID="ddlCodiConc" runat="server" AutoPostBack="true" 
                                CssClass="dbnListaValor" Width="900">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="style2">
                            <asp:Label ID="lblTaxoDest" runat="server" CssClass="lblIzquierdo" />
                        </td>
                        <td class="style3">
                            <asp:TextBox ID="txtTaxoDest" runat="server" CssClass="dbnTextbox" 
                                ReadOnly="True" Width="200"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="style2">
                            <asp:Label ID="lblPrefConc1" runat="server" CssClass="lblIzquierdo" />
                        </td>
                        <td class="style3">
                            <asp:DropDownList ID="ddlPrefConc1" runat="server" AutoPostBack="true" 
                                CssClass="dbnListaValor" 
                                onselectedindexchanged="ddlPrefConc1_SelectedIndexChanged" Width="900">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="style2">
                            <asp:Label ID="Label4" runat="server" CssClass="lblIzquierdo" 
                                Text="Filtro Concepto" />
                        </td>
                        <td style="width:900px;">
                            <asp:TextBox ID="Filtro_ConcDest" runat="server" AutoPostBack="True" 
                                CssClass="dbnTextbox" ontextchanged="Filtro_ConcDest_TextChanged" 
                                width="896px"></asp:TextBox>
                            <asp:AutoCompleteExtender ID="Filtro_ConcDest_AutoCompleteExtender" 
                                runat="server" CompletionInterval="0" 
                                CompletionListElementID="autocompleteDropDownPanelD" CompletionSetCount="10" 
                                DelimiterCharacters=";" Enabled="True" ServiceMethod="GetCompletionListDest" 
                                ServicePath="" TargetControlID="Filtro_ConcDest" UseContextKey="True">
                            </asp:AutoCompleteExtender>
                            <asp:Panel ID="autocompleteDropDownPanelD" runat="server" CssClass="dbnLabel" 
                                height="100px" ScrollBars="Vertical" />
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Label CssClass="lblIzquierdo" ID="lblCodiConc1" runat="server"/></td>
                        <td style="width:300px;"><asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlCodiConc1" runat="server" Width="900">
                            </asp:DropDownList>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div>
        <asp:Label CssClass="lblError" ID="lblError" runat="server"/>
    </div>
</div>
</asp:Content>