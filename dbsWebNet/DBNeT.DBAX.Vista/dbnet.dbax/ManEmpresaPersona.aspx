<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="ManEmpresaPersona.aspx.cs" Inherits="Website_ManEmpresaPersona" MaintainScrollPositionOnPostback ="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">

    <asp:Label ID="Label10" runat="server" Text="Label" CssClass="dbnTitulo">Mantención empresas</asp:Label>
    <br /><br />

    <table class="Selectores">
        <tr>
            <td >
                <asp:Label ID="Label20" runat="server" Text="Grupo" 
                    CssClass="lblIzquierdo"/>
            </td>
            <td>
                <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Grupo" runat="server" 
                    onselectedindexchanged="ddl_Grupo_SelectedIndexChanged" 
                    Width="300px">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td >
                <asp:Label ID="Label1" runat="server" Text="Segmento" 
                    CssClass="lblIzquierdo"/>
            </td>
            <td>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Segmento" runat="server" 
                            onselectedindexchanged="ddl_Segmento_SelectedIndexChanged" 
                            Width="300px">
                        </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td >
                <asp:Label ID="Label4" runat="server" Text="Tipo" 
                    CssClass="lblIzquierdo"/>
            </td>
            <td>
                <asp:DropDownList CssClass="dbnListaValor" ID="ddl_TipoTaxonomia" runat="server" 
                    Width="300px" 
                    onselectedindexchanged="ddl_TipoTaxonomia_SelectedIndexChanged">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td >
                <asp:Label ID="Label3" runat="server" Text="Filtro Empresa" 
                    CssClass="lblIzquierdo"/>
            </td>
            <td>
                <asp:TextBox ID="Filtro_Empresa" runat="server" AutoPostBack="True" 
                    ontextchanged="Filtro_Empresa_TextChanged" Width="300px"></asp:TextBox>
                <asp:AutoCompleteExtender ID="tb_filtroConcepto_AutoCompleteExtender" 
                    runat="server" CompletionInterval="0" 
                    CompletionListElementID="autocompleteDropDownPanel" CompletionSetCount="10" 
                    DelimiterCharacters=";" Enabled="True" ServiceMethod="GetCompletionList" 
                    ServicePath="" TargetControlID="Filtro_Empresa" UseContextKey="True">
                </asp:AutoCompleteExtender>
                <asp:Panel ID="autocompleteDropDownPanel" runat="server" 
                    CssClass="lblIzquierdo" Height="500px" ScrollBars="Vertical" 
                    Width="300px" />
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
                <asp:Label ID="lb_error" runat="server" Text="Label" CssClass="Error"/>
            </td>
        </tr>
        </table>
        <table class="Selectores">
        <tr>
            <td colspan="2">
                <asp:GridView ID="Grilla_Empr_desc" runat="server" AutoGenerateColumns="False" 
                            class="GrillaNormal" GridLines="None" 
                            CellPadding="4" ForeColor="#333333" 
                            OnRowCreated="RowCreated"
                            onrowcancelingedit="Grilla_Empr_desc_RowCancelingEdit" 
                            onrowediting="Grilla_Empr_desc_RowEditing" 
                            onrowdatabound="Grilla_Empr_RowDataBound" 
                            onrowupdating="Grilla_Empr_desc_RowUpdating" 
                            AllowPaging="True" 
                            PageSize="20" onpageindexchanging="Grilla_Empr_desc_PageIndexChanging">
                    
                    <Columns>
                        <asp:TemplateField HeaderText="Rut">
                            <ItemTemplate>
                                <asp:Label ID="Label18" runat="server" text='<%# Bind("codi_pers") %>'/>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" Width="20px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Nombre">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server"  text='<%# Bind("desc_pers") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Descripción">
                            <ItemTemplate>
                                <asp:Label ID="Label19" runat="server" text='<%# Bind("desc_peho") %>'/>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBoxDes" runat="server" text='<%# Bind("desc_peho") %>' Width="150px"></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="CodiGrup">
                            <ItemTemplate>
                                <asp:Label ID="lbl_CodiGrup" runat="server" text='<%# Bind("codi_grup") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Grupo" HeaderStyle-Width="20px">
                            <ItemTemplate>
                                <asp:Label ID="lbl_DescGrup" runat="server" text='<%# Bind("desc_grup") %>'/>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddl_GrupoE" runat="server" Width="67px">
                                </asp:DropDownList>
                            </EditItemTemplate>

                            <HeaderStyle Width="20px"></HeaderStyle>
                            <ItemStyle Width="20px" HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="CodiSegm">
                            <ItemTemplate>
                                <asp:Label ID="lbl_CodiSegm" runat="server" text='<%# Bind("codi_segm") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Segmento" HeaderStyle-Width="20px">
                            <ItemTemplate>
                                <asp:Label ID="lbl_DescSegm" runat="server" text='<%# Bind("desc_segm") %>'/>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddl_SegmE" runat="server" Width="67px">
                                </asp:DropDownList>
                            </EditItemTemplate>

                            <HeaderStyle Width="20px"></HeaderStyle>
                            <ItemStyle Width="20px" HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="TipoTaxo">
                            <ItemTemplate>
                                <asp:Label ID="lbl_TipoTaxo" runat="server" text='<%# Bind("tipo_taxo") %>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tipo" HeaderStyle-Width="20px">
                            <ItemTemplate>
                                <asp:Label ID="lbl_DescTipo" runat="server" text='<%# Bind("desc_tipo") %>'/>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddl_TipoTaxoE" runat="server" Width="67px">
                                </asp:DropDownList>
                            </EditItemTemplate>

                            <HeaderStyle Width="20px"></HeaderStyle>
                            <ItemStyle Width="20px" HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <asp:CommandField ButtonType="Image" 
                                    CancelImageUrl="~/librerias/img/imgCan.png" 
                                    EditImageUrl="~/librerias/img/edit.png" HeaderText="Edición" 
                                    ShowEditButton="True" 
                                    UpdateImageUrl="~/librerias/img/imgAct.png">
                        <ItemStyle HorizontalAlign="Center" Width="20px" />
                        </asp:CommandField>
                    </Columns>
                    <EditRowStyle CssClass="TextosNegritas"/>
                    <FooterStyle BackColor="#5D7B9D" CssClass="dbnGrilla" Font-Bold="True" 
                                ForeColor="White" />
                    <PagerStyle BackColor="#CCCCCC" HorizontalAlign="Center" CssClass ="TextosNegritas" />
                    <RowStyle CssClass="RowStyle" />
                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                    <AlternatingRowStyle CssClass="AlternatingRow"/>
                    <HeaderStyle CssClass="headerGrilla"/>
                    <RowStyle CssClass="RowStyle" />
                </asp:GridView>
            </td>
        </tr>
    </table>
</asp:Content>

