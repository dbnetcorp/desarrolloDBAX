<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="Website_Home" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="pageFw5">
    <asp:Label ID="Label10" runat="server" Text="Label" CssClass="dbnTitulo">Últimos EEFF Reportados</asp:Label>
    <br />

    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <h2 id="structures">
                <asp:Label ID="lb_error" runat="server" Text="Label" CssClass="Error"/>
            </h2>
            <br />
            <table class="Selectores">
                <tr>
                    <td>
                        <asp:Label ID="Label4" runat="server" Text="Periodo" CssClass="lblIzquierdo"/>
                    </td>
                    <td>
                        <asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddl_CorrInst" runat="server" width="353px" 
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
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_TipoTaxonomia" runat="server" 
                            width="353px" 
                            onselectedindexchanged="ddl_TipoTaxonomia_SelectedIndexChanged" 
                            AutoPostBack="True">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label7" runat="server" CssClass="lblIzquierdo" Text="Grupo"/>
                    </td>
                    <td>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Grupo" runat="server"  
                            onselectedindexchanged="ddl_Grupo_SelectedIndexChanged" 
                            width="353px" AutoPostBack="True">
                        </asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td>
                        <asp:Label ID="Label8" runat="server" CssClass="lblIzquierdo" Text="Segmento"/>
                    </td>
                    <td>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Segmento" runat="server" 
                            onselectedindexchanged="ddl_Segmento_SelectedIndexChanged" 
                            width="353px" AutoPostBack="True">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width:150px">
                        <asp:Label ID="Label3" runat="server" Text="Filtro Empresa" 
                            CssClass="lblIzquierdo"/>
                    </td>
                    <td>
                        <asp:TextBox CssClass="dbnTextbox" ID="Filtro_Empresa" runat="server" AutoPostBack="True" 
                        ontextchanged="Filtro_Empresa_TextChanged" width="350px"></asp:TextBox>
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
                            DelimiterCharacters=";">
                        </asp:AutoCompleteExtender>
                        <asp:Panel ID="autocompleteDropDownPanel" runat="server" CssClass="dbnLabel"
                            ScrollBars="Vertical" height="100px" />
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td style="text-align:center;">
                        <asp:ImageButton ID="Buscar" runat="server" height="26px"
                        ImageUrl="~/librerias/img/bt_buscar.png"
                        width="60px" onclick="Buscar_Click" Enabled="False" Visible="False" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label11" runat="server" CssClass="lblIzquierdo" 
                            Text="Versiones oficiales"></asp:Label>
                    </td>
                    <td>
                        <asp:RadioButtonList ID="rb_VersInst" runat="server" CssClass="lblIzquierdo" 
                            RepeatDirection="Horizontal" 
                            onselectedindexchanged="rb_VersInst_SelectedIndexChanged" 
                            AutoPostBack="True">
                            <asp:ListItem Value="S" Selected="True">Sí</asp:ListItem>
                            <asp:ListItem Value="N">No</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Label ID="lblProcesado" runat="server" CssClass="lblIzquierdo" 
                            Text="" />
                    </td>
                </tr>
            </table>

            <asp:UpdateProgress ID="updProgress" AssociatedUpdatePanelID="UpdatePanel2" runat="server">
                <ProgressTemplate>           
                    <img src="../librerias/img/imgLoading.gif" />
                </ProgressTemplate>
            </asp:UpdateProgress>

            <br />

            <asp:GridView ID="Grilla_Empresas" runat="server" AutoGenerateColumns="False" 
                    CssClass="GrillaNormal" GridLines="None" 
                    CellPadding="4" ForeColor="#333333" 
                    OnRowCreated="RowCreated"
                    AllowPaging="True" 
                    PageSize="20" onpageindexchanging="Grilla_Empr_desc_PageIndexChanging" 
                    onrowdatabound="RowDataBound" 
                    onrowcommand="Grilla_Empresas_SelectedIndexChanged" >
                    <AlternatingRowStyle CssClass="AlternatingRow"/>
                    <HeaderStyle CssClass="headerGrilla"/>
                <Columns>
                    <asp:ButtonField ButtonType="Image" CommandName="empr_deta"
                        ImageUrl="~/librerias/img/deta.png" HeaderText="Det.">
                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:ButtonField>
                    <asp:TemplateField HeaderText="Rut Empresa">
                        <ItemTemplate>
                            <asp:Label ID="lbCodiPers" runat="server" text='<%# Bind("codi_pers") %>'/>
                        </ItemTemplate>
                        <ItemStyle width="60px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Empresa">
                        <ItemTemplate>
                            <asp:Label ID="lbDescPers" runat="server" text='<%# Bind("desc_pers") %>' width="300px"/>
                        </ItemTemplate>
                        <HeaderStyle width="300px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="lbAnaRazo">
                        <ItemTemplate>
                            <asp:Label ID="lbAnalRazo" runat="server" text='<%# Bind("anal_razo") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:ButtonField ButtonType="Image" CommandName="anal_razo"
                        ImageUrl="~/librerias/img/pdf.png" HeaderText="Ana.Razo.">

                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:ButtonField>
                    <asp:TemplateField HeaderText="lbDecl_Resp">
                        <ItemTemplate>
                            <asp:Label ID="lbDecl_Resp" runat="server" text='<%# Bind("Decl_Resp") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:ButtonField ButtonType="Image" CommandName="Decl_Resp" 
                        ImageUrl="~/librerias/img/pdf.png" Text="Button" 
                        HeaderText="Decl.Resp." >
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:ButtonField>

                    <asp:TemplateField HeaderText="lbEsta_PDF">
                        <ItemTemplate>
                            <asp:Label ID="lbEsta_PDF" runat="server" text='<%# Bind("Esta_PDF") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:ButtonField ButtonType="Image" CommandName="Esta_PDF" 
                        ImageUrl="~/librerias/img/pdf.png" Text="Button" 
                        HeaderText="EF PDF">
                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:ButtonField>
                    <asp:TemplateField HeaderText="lbEsta_XBRL">
                        <ItemTemplate>
                            <asp:Label ID="lbEsta_XBRL" runat="server" text='<%# Bind("Esta_XBRL") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:ButtonField ButtonType="Image" CommandName="Esta_XBRL" 
                        ImageUrl="~/librerias/img/xml.png" Text="Button" 
                        HeaderText="XBRL">

                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:ButtonField>

                    <asp:TemplateField HeaderText="lbHech_Rele">
                        <ItemTemplate>
                            <asp:Label ID="lbHech_Rele" runat="server" text='<%# Bind("Hech_Rele") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:ButtonField ButtonType="Image" CommandName="Hech_Rele" 
                        ImageUrl="~/librerias/img/pdf.png" Text="Button" 
                        HeaderText="Hech.Rele.">
                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:ButtonField> 

                    <asp:TemplateField HeaderText="lbVisu_XBRL">
                        <ItemTemplate>
                            <asp:Label ID="lbVisu_XBRL" runat="server" text='<%# Bind("Visu_XBRL") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:ButtonField ButtonType="Image" CommandName="Visu_XBRL" 
                        ImageUrl="~/librerias/img/html.png" Text="Button" 
                        HeaderText="Visu.XBRL.">
                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:ButtonField> 
                </Columns>
                <EditRowStyle CssClass="TextosNegritas"/>
                <FooterStyle BackColor="#5D7B9D" CssClass="dbnGrilla" Font-Bold="True" 
                            ForeColor="White" />
                <PagerStyle BackColor="#CCCCCC" HorizontalAlign="Center" CssClass ="TextosNegritas" />
                <RowStyle CssClass="RowStyle" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            </asp:GridView>
            <asp:GridView ID="Grilla_EmpExte" runat="server" AutoGenerateColumns="False" 
                    CssClass="GrillaNormal" GridLines="None" 
                    CellPadding="4" ForeColor="#333333" 
                    OnRowCreated="RowCreated"
                    AllowPaging="True" 
                    PageSize="20" onpageindexchanging="Grilla_EmpExte_desc_PageIndexChanging" 
                    onrowdatabound="RowDataBoundExte" 
                    onrowcommand="Grilla_EmpresasExte_SelectedIndexChanged">
                    <AlternatingRowStyle CssClass="AlternatingRow"/>
                    <HeaderStyle CssClass="headerGrilla"/>
                <Columns>
                    <asp:ButtonField ButtonType="Image" CommandName="empr_deta"
                        ImageUrl="~/librerias/img/deta.png" HeaderText="Det.">
                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:ButtonField>
                    <asp:TemplateField HeaderText="Rut Empresa">
                        <ItemTemplate>
                            <asp:Label ID="lbCodiPers" runat="server" text='<%# Bind("codi_pers") %>'/>
                        </ItemTemplate>
                        <ItemStyle width="60px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Empresa">
                        <ItemTemplate>
                            <asp:Label ID="lbDescPers" runat="server" text='<%# Bind("desc_pers") %>' width="300px"/>
                        </ItemTemplate>
                        <HeaderStyle width="300px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="lbXbrlExte">
                        <ItemTemplate>
                            <asp:Label ID="lbXbrlExte" runat="server" text='<%# Bind("xbrl_exte") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:ButtonField ButtonType="Image" CommandName="xbrl_exte"
                        ImageUrl="~/librerias/img/xml.png" HeaderText="XBRL ">

                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:ButtonField>
                    <asp:TemplateField HeaderText="lbVisuHTML">
                        <ItemTemplate>
                            <asp:Label ID="lbVisuHTML" runat="server" text='<%# Bind("visu_html") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:ButtonField ButtonType="Image" CommandName="visu_html" 
                        ImageUrl="~/librerias/img/html.png" Text="Button" 
                        HeaderText="Visu. HTML" >
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:ButtonField>

                </Columns>
                <EditRowStyle CssClass="TextosNegritas"/>
                <FooterStyle BackColor="#5D7B9D" CssClass="dbnGrilla" Font-Bold="True" 
                            ForeColor="White" />
                <PagerStyle BackColor="#CCCCCC" HorizontalAlign="Center" CssClass ="TextosNegritas" />
                <RowStyle CssClass="RowStyle" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            </asp:GridView>
            <br />
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="Grilla_Empresas" />
            <asp:PostBackTrigger ControlID="Grilla_EmpExte" />
        </Triggers>
    </asp:UpdatePanel>
    <br />
    </div>
</asp:Content>