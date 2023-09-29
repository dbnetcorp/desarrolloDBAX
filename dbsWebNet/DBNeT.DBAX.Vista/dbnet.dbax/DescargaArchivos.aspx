<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="DescargaArchivos.aspx.cs" Inherits="Website_Descarga_archivos" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="pageFw5">
  <asp:Label ID="Label10" runat="server" Text="Label" CssClass="dbnTitulo">Descarga de archivos</asp:Label>
  <br /><br />

  <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
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
                <asp:AutoCompleteExtender ID="tb_filtroConcepto_AutoCompleteExtender" 
                    runat="server" CompletionInterval="0" 
                    CompletionListElementID="autocompleteDropDownPanel" CompletionSetCount="10" 
                    DelimiterCharacters=";" Enabled="True" ServiceMethod="GetCompletionList" 
                    ServicePath="" TargetControlID="Filtro_Empresa" UseContextKey="True">
                </asp:AutoCompleteExtender>
                <asp:Panel ID="autocompleteDropDownPanel" runat="server" 
                    CssClass="lblLabel" Height="100px" ScrollBars="Vertical" Width="353px" />
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
            <tr>
                <td colspan="2">
                    <asp:UpdateProgress ID="updProgress" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                        <ProgressTemplate>           
                            <img src="../librerias/img/imgLoading.gif" />
                        </ProgressTemplate>
                    </asp:UpdateProgress>
                </td>
            </tr>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Label ID="lb_error" runat="server" Text="Label" CssClass="Error"/>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div style="position:relative; top:20px">
                    <asp:GridView ID="gv_Archivos" runat="server" AutoGenerateColumns="False" 
                        CellPadding="4" Width="100%" 
                        onrowdeleting="gv_Archivos_RowDeleting" 
                        OnRowCreated="RowCreated"
                        GridLines="None"> 
                    <AlternatingRowStyle CssClass="AlternatingRow"/>
                    <HeaderStyle CssClass="headerGrilla"/>
                    <Columns>
                        <asp:CommandField ButtonType="Image" 
                            SelectImageUrl="~/librerias/img/disk.png" 
                            ShowDeleteButton="True" 
                            DeleteImageUrl="~/librerias/img/disk.png">
                        <ItemStyle Width="25px" />
                        </asp:CommandField>
                        <asp:TemplateField HeaderText="Archivos">
                            <ItemTemplate>
                                <asp:Label ID="lb_CodiCntx" runat="server" text='<%# Bind("Archivos") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Contenido" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="lb_DiaiCntx" runat="server" text='<%# Bind("Contenido") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle CssClass="GrillaTextosEditar" />
                    <FooterStyle BackColor="#5D7B9D" CssClass="dbnGrilla" Font-Bold="True" 
                        ForeColor="White" />
                    <PagerStyle BackColor="#CCCCCC" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle CssClass="RowStyle" />
                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                </div>
            </td>
            <caption>
                <caption>
                </caption>
                </embed></caption>
        </tr>
    </table>
     </ContentTemplate>
      <Triggers>
          <asp:PostBackTrigger ControlID = gv_Archivos />
      </Triggers>
 </asp:UpdatePanel>
 </div>
</asp:Content>