<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master"  AutoEventWireup="true" CodeFile="ConsultaEmpresasInformes.aspx.cs" Inherits="ConsultaEmpresasInformes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style1
        {
            width: 70px;
            height: 50px;
        }
        .style2
        {
            height: 50px;
        }
        .style3
        {
            height: 50px;
            width: 288px;
        }
        .style4
        {
            width: 70px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="pageFw5">
    <asp:Label ID="Label10" runat="server" Text="Label" CssClass="dbnTitulo">Consulta Grupos/Segmentos por Período</asp:Label>
    <br /><br />
    <a style="font-family:Calibri;"></a>
    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
        <ContentTemplate>
            <table class="Selectores" border="0">
                <tr>
                    <td class="style4">
                        <asp:Label ID="Label4" runat="server" Text="Periodo" CssClass="lblIzquierdo"/>
                    </td>
                    <td style="width:200px;" colspan="3">
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_CorrInst" runat="server"  width="353px" AutoPostBack="true">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        <asp:Label ID="Label9" runat="server" Text="Tipo" 
                            CssClass="lblIzquierdo"/>
                    </td>
                    <td style="width:200px;" colspan="3">
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_TipoTaxonomia" runat="server" AutoPostBack="true" 
                             width="353px" 
                            onselectedindexchanged="ddl_TipoTaxonomia_SelectedIndexChanged">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        <asp:Label ID="Label7" runat="server" CssClass="lblIzquierdo" Text="Grupo"/>
                    </td>
                    <td colspan="3">
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Grupo" runat="server" AutoPostBack="true" 
                             onselectedindexchanged="ddl_Grupo_SelectedIndexChanged" 
                            width="353px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        <asp:Label ID="Label8" runat="server" CssClass="lblIzquierdo" Text="Segmento"/>
                    </td>
                    <td colspan="3">
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Segmento" runat="server" AutoPostBack="true" 
                             onselectedindexchanged="ddl_Segmento_SelectedIndexChanged" 
                            width="353px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="style4"><asp:Label CssClass="lblIzquierdo" ID="llbTipoMone" runat="server" Text="Moneda"/></td>
                    <td colspan="3">
                        <asp:CheckBox ID="chkMoneOrig" runat="server" AutoPostBack="True" 
                            Checked="True" CssClass="dbnListaValor" 
                            oncheckedchanged="chkMoneOrig_CheckedChanged" 
                            Text="Usar moneda de presentación" />
                        <br />
                        <asp:DropDownList ID="ddlTipoMone" runat="server" CssClass="dbnListaValor"
                            Width="353px" Enabled="False" Visible="False">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="style1">
                        &nbsp;</td>
                    <td class="style3">
                        &nbsp;</td>
                    <td class="style2">
                        <asp:CheckBox ID="ckbTodos" runat="server" AutoPostBack="true" 
                            oncheckedchanged="ckbTodos_CheckedChanged" Text="Seleccionar Todos" />
                    </td>
                    <td class="style2">
                        <asp:CheckBox ID="ckbTranspuesto" runat="server" Text="Transpuesto" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                       <div style="overflow:auto; max-height:400px; width:500px;">
                        <asp:GridView ID="Grilla_Informes" runat="server" AutoGenerateColumns="False" 
                            CellPadding="4" GridLines="None" 
                            onpageindexchanging="Grilla_Informes_desc_PageIndexChanging" 
                            OnRowCreated="RowCreated" Width="494px">
                            <AlternatingRowStyle CssClass="AlternatingRow" />
                            <HeaderStyle CssClass="headerGrilla" />
                            <Columns>
                                <asp:TemplateField HeaderText="">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkInfo" runat="server" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" width="20px" />
                                </asp:TemplateField>
                                <asp:TemplateField ControlStyle-width="100" HeaderText="codi_info" 
                                    Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lbCodiInfo" runat="server" text='<%# Bind("codi_info") %>' 
                                            width="20px" />
                                    </ItemTemplate>
                                    <ControlStyle Width="100px" />
                                    <HeaderStyle width="20px" />
                                    <ItemStyle width="20px" />
                                </asp:TemplateField>
                                <asp:TemplateField ControlStyle-width="230" HeaderText="Informe">
                                    <ItemTemplate>
                                        <asp:Label ID="lbDescInfo" runat="server" text='<%# Bind("desc_info") %>' />
                                    </ItemTemplate>
                                    <ControlStyle Width="230" />
                                </asp:TemplateField>
                            </Columns>
                            <EditRowStyle CssClass="TextosNegritas" />
                            <FooterStyle BackColor="#5D7B9D" CssClass="dbnGrilla" Font-Bold="True" 
                                ForeColor="White" />
                            <PagerStyle BackColor="#CCCCCC" CssClass="TextosNegritas" 
                                HorizontalAlign="Center" />
                            <RowStyle CssClass="RowStyle" />
                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                        </asp:GridView>
                        </div>
                    </td>
                    <td colspan="2">
                    <div style="overflow:auto; max-height:400px; width:500px;">
                        <asp:GridView ID="Grilla_Empresas" runat="server" AutoGenerateColumns="False" 
                            CellPadding="4" GridLines="None" 
                            onpageindexchanging="Grilla_Empr_desc_PageIndexChanging" 
                            OnRowCreated="RowCreated" Width="494px">
                            <AlternatingRowStyle CssClass="AlternatingRow" />
                            <HeaderStyle CssClass="headerGrilla" />
                            <Columns>
                                <asp:TemplateField HeaderText="">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkEmpr" runat="server" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" width="20px" />
                                </asp:TemplateField>
                                <asp:TemplateField ControlStyle-width="50" HeaderText="Rut">
                                    <ItemTemplate>
                                        <asp:Label ID="lbCodiPers" runat="server" text='<%# Bind("codi_pers") %>' 
                                            width="20px" />
                                    </ItemTemplate>
                                    <HeaderStyle width="20px" />
                                    <ItemStyle width="20px" />
                                </asp:TemplateField>
                                <asp:TemplateField ControlStyle-width="200" HeaderText="Empresa">
                                    <ItemTemplate>
                                        <asp:Label ID="lbDescPers" runat="server" text='<%# Bind("desc_pers") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EditRowStyle CssClass="TextosNegritas" />
                            <FooterStyle BackColor="#5D7B9D" CssClass="dbnGrilla" Font-Bold="True" 
                                ForeColor="White" />
                            <PagerStyle BackColor="#CCCCCC" CssClass="TextosNegritas" 
                                HorizontalAlign="Center" />
                            <RowStyle CssClass="RowStyle" />
                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                        </asp:GridView>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:ImageButton ID="Procesar" runat="server" height="26px" 
                            ImageUrl="../librerias/img/bt_procesar.png" onclick="Procesar_Click" 
                            width="60px" />
                    </td>
                    <td colspan="2">
                        &nbsp;</td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    <h2 id="structures">
    <asp:Label ID="lb_error" runat="server" Text="Label" CssClass="Error"/>
    </h2>
  
</div>
</asp:Content>

