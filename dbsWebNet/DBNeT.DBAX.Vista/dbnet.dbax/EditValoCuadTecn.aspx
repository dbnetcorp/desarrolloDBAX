<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="EditValoCuadTecn.aspx.cs" Inherits="Website_Descarga_archivos" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    <div class="pageFw5">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
              <div id="botones3" style="visibility:visible;" class="div3Botones">
                <div class="divTitulo"><asp:Label ID="lblRepoTitulo" runat="server" 
                        CssClass="dbnTitulo">Editor de valores (Cuadros técnicos)</asp:Label>
                  </div>
                <div class="divBotones">
                    <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" onclick="btnActualizar_Click" ImageUrl="~/librerias/img/botones/aceptar.png"/>
                </div>
                </div>
              <br /><br />

      
            <table class="Selectores" >
                <tr>
                    <td class="style1">
                        <asp:Label ID="Label6" runat="server" CssClass="lblIzquierdo" Text="Período"/>
                    </td>
                    <td class="style1">
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_CorrInst" runat="server" 
                             onselectedindexchanged="ddl_CorrInst_SelectedIndexChanged" 
                            Width="353px" AutoPostBack="True">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td >
                        <asp:Label ID="Label9" runat="server" Text="Tipo" 
                            CssClass="lblIzquierdo"/>
                    </td>
                    <td>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_TipoTaxonomia" 
                            runat="server"  Width="353px" 
                            onselectedindexchanged="ddl_TipoTaxonomia_SelectedIndexChanged" 
                            AutoPostBack="True">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="style1">
                        <asp:Label ID="Label7" runat="server" CssClass="lblIzquierdo" Text="Grupos"/>
                    </td>
                    <td class="style1">
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Grupo" runat="server" AutoPostBack="true"
                             onselectedindexchanged="ddl_Grupo_Select" 
                            Width="353px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="style1">
                        <asp:Label ID="Label2" runat="server" CssClass="lblIzquierdo" Text="Segmentos"/>
                    </td>
                    <td class="style1">
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Segmento" runat="server" AutoPostBack="true"
                             onselectedindexchanged="ddl_Segmento_Select" 
                            Width="353px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td >
                        <asp:Label ID="Label3" runat="server" Text="Filtro Empresa" 
                            CssClass="lblIzquierdo"/>
                    </td>
                    <td >
                        <asp:TextBox ID="Filtro_Empresa" runat="server" AutoPostBack="True" 
                            Height="20px" ontextchanged="Filtro_Empresa_TextChanged" Width="353px" 
                            CssClass="dbnTextbox"></asp:TextBox>
                        <asp:AutoCompleteExtender ID="tb_filtroEmpresa_AutoCompleteExtender" 
                            runat="server" CompletionInterval="0" 
                            CompletionListElementID="autocompleteDropDownPanelEmpresa" CompletionSetCount="10" 
                            DelimiterCharacters=";" Enabled="True" ServiceMethod="GetCompletionListEmpresa" 
                            ServicePath="" TargetControlID="Filtro_Empresa" UseContextKey="True">
                        </asp:AutoCompleteExtender>
                        <asp:Panel ID="autocompleteDropDownPanelEmpresa" runat="server" 
                            CssClass="dbnLabel" Height="100px" ScrollBars="Vertical" Width="353px" />
                    </td>
                </tr>
                <tr>
                    <td class="style1">
                        <asp:Label ID="Label1" runat="server" Text="Empresa" 
                    CssClass="lblIzquierdo"/>
                    </td>
                    <td class="style1">
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_CodiEmpr" runat="server"  Width="353px" 
                            onselectedindexchanged="ddl_CodiEmpr_SelectedIndexChanged" 
                            AutoPostBack="True">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td >
                        <asp:Label ID="Label5" runat="server" Text="Versión de carga" 
                            CssClass="lblIzquierdo"/>
                    </td>
                    <td >
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_VersInst" runat="server"  
                            Width="353px" onselectedindexchanged="ddl_VersInst_SelectedIndexChanged" 
                            AutoPostBack="True">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label17" runat="server" Text="Informe" 
                            CssClass="lblIzquierdo"/></td>
                    <td>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddlCodiInfo" runat="server"  
                            Width="353px" AutoPostBack="True" 
                            onselectedindexchanged="ddlCodiInfo_SelectedIndexChanged">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label10" runat="server" Text="Cuadro técnico" CssClass="lblIzquierdo"/></td>
                    <td>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddlCuadTecn" runat="server"  
                            Width="353px" AutoPostBack="True" 
                            onselectedindexchanged="ddlCuadTecn_SelectedIndexChanged">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td><asp:Label ID="lblEje1" runat="server" Text="" CssClass="lblIzquierdo"/></td>
                    <td>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddlMiembro1" runat="server"  
                            Width="353px" AutoPostBack="True" 
                            onselectedindexchanged="ddlMiembro1_SelectedIndexChanged" >
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td><asp:Label ID="lblEje2" runat="server" Text="" CssClass="lblIzquierdo"/></td>
                    <td>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddlMiembro2" runat="server"  
                            Width="353px" AutoPostBack="True" 
                            onselectedindexchanged="ddlMiembro2_SelectedIndexChanged" >
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td >
                        <asp:Label ID="Label8" runat="server" Text="Filtro Concepto" CssClass="lblIzquierdo"/>
                    </td>
                    <td >
                        <asp:TextBox ID="Filtro_concepto" runat="server" AutoPostBack="True" 
                            Height="20px" ontextchanged="Filtro_Concepto_TextChanged" Width="353px" 
                            CssClass="dbnTextbox"></asp:TextBox>
                        <asp:AutoCompleteExtender ID="tb_filtroConcepto_AutoCompleteExtender" 
                            runat="server" CompletionInterval="0" 
                            CompletionListElementID="autocompleteDropDownPanelConcepto" CompletionSetCount="10" 
                            DelimiterCharacters=";" Enabled="True" ServiceMethod="GetCompletionListConcepto" 
                            ServicePath="" TargetControlID="Filtro_concepto" UseContextKey="True">
                        </asp:AutoCompleteExtender>
                        <asp:Panel ID="autocompleteDropDownPanelConcepto" runat="server" 
                            CssClass="dbnLabel" Height="100px" ScrollBars="Vertical" Width="353px" />
                    </td>
                </tr>
                <tr>
                    <td >
                        <asp:Label ID="Label4" runat="server" Text="Concepto" CssClass="lblIzquierdo"/>
                    </td>
                    <td >
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_CodiConc" runat="server"  
                            Width="353px" AutoPostBack="True" 
                            onselectedindexchanged="ddl_CodiConc_SelectedIndexChanged">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label13" runat="server" Text="Código de concepto" CssClass="lblIzquierdo"/>
                    </td>
                    <td>
                        <asp:Label ID="lblCodiConc" runat="server" CssClass="lblIzquierdo"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label12" runat="server" Text="Contextos" CssClass="lblIzquierdo"/>
                    </td>
                    <td>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddlCodiCntx" runat="server"  
                            Width="353px" AutoPostBack="True" 
                            onselectedindexchanged="ddlCodiCntx_SelectedIndexChanged" >
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblEjeMemb0" runat="server" Text="Ejes y miembros" CssClass="lblIzquierdo" Visible="false"/>
                    </td>
                    <td>
                        <asp:Label ID="lblEjeMemb1" runat="server" Text="" CssClass="lblIzquierdo" Visible="false"/>
                    </td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label14" runat="server" Text="Valor pesos" 
                            CssClass="lblIzquierdo"/></td>
                    <td>
                        <asp:TextBox ID="txtValoPeso" runat="server" CssClass="dbnTextbox" 
                            Height="20px" Width="353px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label15" runat="server" Text="Valor dólares" 
                            CssClass="lblIzquierdo"/></td>
                    <td>
                        <asp:TextBox ID="txtValoDola" runat="server" CssClass="dbnTextbox" 
                            Height="20px" Width="353px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label16" runat="server" Text="Valor UF" CssClass="lblIzquierdo"/></td>
                    <td>
                        <asp:TextBox ID="txtValoUF" runat="server" CssClass="dbnTextbox" 
                            Height="20px" Width="353px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:UpdateProgress ID="updProgress" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                            <ProgressTemplate>           
                                <img alt="" src="../librerias/img/imgLoading.gif" />
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Label ID="lb_error" runat="server" Text="Label" CssClass="Error"/>
                    </td>
                </tr>
            </table>
         </ContentTemplate>
        </asp:UpdatePanel>
     </div>
</asp:Content>