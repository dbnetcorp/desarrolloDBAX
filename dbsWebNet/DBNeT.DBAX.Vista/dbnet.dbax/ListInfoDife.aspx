<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="ListInfoDife.aspx.cs" Inherits="ListInfoDife" MaintainScrollPositionOnPostback="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">

<div class="pageFw5">
    <asp:Label ID="Label10" runat="server" Text="Label" CssClass="dbnTitulo">Reporte de cambios versiones de envío</asp:Label>
    <br /><br />

    <table class="Selectores" border="0">
        <tr>
            <td >
                <asp:Label ID="Label4" runat="server" Text="Periodo" CssClass="lblIzquierdo"/>
            </td>
            <td >
                <asp:DropDownList CssClass="dbnListaValor" ID="ddl_CorrInst" runat="server" Width="353px" 
                    onselectedindexchanged="ddl_CorrInst_SelectedIndexChanged" >
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td >
                <asp:Label ID="Label9" runat="server" Text="Tipo" 
                    CssClass="lblIzquierdo"/>
            </td>
            <td>
                <asp:DropDownList CssClass="dbnListaValor" ID="ddl_TipoTaxonomia" runat="server" Width="353px" 
                    onselectedindexchanged="ddl_TipoTaxonomia_SelectedIndexChanged">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td >
                <asp:Label ID="Label5" runat="server" Text="Grupo" CssClass="lblIzquierdo"/>
            </td>
            <td >
                <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Grupo" runat="server"  Width="353px" 
                    onselectedindexchanged="ddl_Grupo_SelectedIndexChanged" >
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td >
                <asp:Label ID="Label1" runat="server" Text="Segmento" CssClass="lblIzquierdo"/>
            </td>
            <td >
                <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Segmento" runat="server"  Width="353px" 
                    onselectedindexchanged="ddl_Segmento_SelectedIndexChanged" >
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td style="width:150px" >
                <asp:Label ID="Label3" runat="server" Text="Filtro Empresa" 
                    CssClass="lblIzquierdo"/>
            </td>
            <td >
                <asp:TextBox CssClass="dbnTextbox" ID="Filtro_Empresa" runat="server" AutoPostBack="True" 
                    Height="20px" ontextchanged="Filtro_Empresa_TextChanged"></asp:TextBox>
                <asp:AutoCompleteExtender 
                    runat="server"
                    ID="tb_filtroConcepto_AutoCompleteExtender"
                    Enabled="True"
                    ServiceMethod="GetCompletionList"
                    ServicePath=""
                    TargetControlID="Filtro_Empresa"
                    UseContextKey="True"
                    CompletionInterval="0"
                    CompletionSetCount="10"
                    CompletionListElementID="autocompleteDropDownPanel"
                    DelimiterCharacters=";" >
                </asp:AutoCompleteExtender>
                <asp:Panel ID="autocompleteDropDownPanel" runat="server" CssClass="dbnLabel"
                    ScrollBars="Vertical" Height="100px" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td align="center">
                <asp:ImageButton ID="Buscar" runat="server" Height="26px"
                ImageUrl="~/librerias/img/bt_buscar.png"
                Width="60px" onclick="Buscar_Click" />
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Label ID="lb_error" runat="server" Text="Label" CssClass="Error"/>&nbsp;
            </td>
        </tr>
    </table>
    <table>
        <tr>
            <td colspan="2">
                <asp:GridView ID="Grilla_Empr" runat="server" AutoGenerateColumns="False" 
                    CssClass="GrillaNormal"  CellPadding="4" ForeColor="#333333"  
                    onrowdeleting="Grilla_Grupo_RowDeleting"   GridLines="None" 
                    onrowdatabound="Grilla_Empr_RowDataBound" 
                    OnRowCreated="RowCreated" AllowPaging="True" 
                    onpageindexchanging="Grilla_Empr_PageIndexChanging" PageSize="20">
                    <AlternatingRowStyle CssClass="AlternatingRow"/>
                    <HeaderStyle CssClass="headerGrilla"/>
                    <Columns>
                        <asp:CommandField ButtonType="Image" DeleteImageUrl="~/librerias/img/page_run.png" 
                            ShowDeleteButton="True">
                            <ItemStyle Width="10px" HorizontalAlign="Center" />
                        </asp:CommandField>

                        <asp:BoundField DataField="codi_pers" HeaderText="RUT" >
                            <ItemStyle Width="40px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="desc_pers" HeaderText="Nombre Empresa"  >
                            <ItemStyle Width="250px" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Versión Instancia" HeaderStyle-Width="20px">
                            <ItemTemplate>
                                <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Version" runat="server" Width="67px">
                                </asp:DropDownList>
                            </ItemTemplate>

                            <HeaderStyle Width="20px"></HeaderStyle>
                            <ItemStyle Width="20px" HorizontalAlign="Center" />
                        </asp:TemplateField>

                    </Columns>
                    <EditRowStyle CssClass="TextosNegritas"/>
                        <FooterStyle BackColor="#5D7B9D" CssClass="dbnGrilla" Font-Bold="True" 
                                ForeColor="White" />
                    <PagerStyle BackColor="#CCCCCC" HorizontalAlign="Center" CssClass ="TextosNegritas" />
                    <RowStyle CssClass="RowStyle" />
                        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
            </td>
        </tr>
    </table>
    <br />
    </div>
</asp:Content>