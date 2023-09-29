<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="listadoReportes.aspx.cs" Inherits="Website_listadoIndicadores" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="pageFw5">
    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional" style="position: relative;">
        <ContentTemplate>
            <div class="divTitulo" style="position: relative;">
                <asp:Label ID="Label10" runat="server" Text="Label" CssClass="dbnTitulo">Mantención reportes</asp:Label>
            </div>
            <div class="divBotones" style="position: relative;">
                <asp:ImageButton ID="bt_NuevoInforme" runat="server" Height="25px" 
                    ImageUrl="~/librerias/img/agregar.png" Width="30px" onclick="bt_insInfoDefi" />
            </div>
            <br />
            <br />
            <br />
            <br />
            <table class="Selectores" border = "0" style="position: relative;">
                <tr>
                    <td><asp:Label ID="Label9" runat="server" Text="Tipo" CssClass="lblIzquierdo"/></td>
                    <td><asp:DropDownList CssClass="dbnListaValor" ID="ddl_TipoTaxonomia" 
                            runat="server" Width="353px" AutoPostBack="True" 
                            onselectedindexchanged="ddl_TipoTaxonomia_SelectedIndexChanged" /></td>
                </tr>
            </table>
            <asp:Label ID="lb_error" runat="server" Text="Label" CssClass="Error"/>
            <table class="Selectores">
                <tr>
                    <td>
                        <asp:GridView ID="gv_Reportes" runat="server" CssClass="GrillaNormal" AutoGenerateColumns="False" 
                            style="position:relative;top: 10px; left: 0px;" GridLines="None" 
                            onselectedindexchanged="gv_Reportes_SelectedIndexChanged" 
                            OnRowCreated="RowCreated">
                            <AlternatingRowStyle CssClass="AlternatingRow"/>
                            <HeaderStyle CssClass="headerGrilla"/>
                            <Columns>
                                <asp:CommandField ButtonType="Image" ShowSelectButton="True" 
                                    SelectImageUrl="~/librerias/img/edit.png">
                                <ItemStyle Width="15px" HorizontalAlign="Center" />
                                </asp:CommandField>
                                <asp:TemplateField HeaderText="CodiInfo">
                                    <ItemTemplate>
                                        <asp:Label ID="lbCodiInfo" runat="server" text='<%# Bind("codi_info") %>'/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Reporte">
                                    <ItemTemplate>
                                        <asp:Label ID="lbDescInfo" runat="server" text='<%# Bind("desc_info") %>'/>
                                    </ItemTemplate>
                                    <HeaderStyle Width="400px" />
                                    <ItemStyle Width="400px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Vigente" >
                                    <ItemTemplate>
                                        <asp:Label ID="lbIndiVige" runat="server" text='<%# Bind("indi_vige") %>'/>
                                    </ItemTemplate>
                                    <HeaderStyle Width="15px" />
                                    <ItemStyle Width="15px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="TipoTaxo">
                                    <ItemTemplate>
                                        <asp:Label ID="lbTipoTaxo" runat="server" text='<%# Bind("tipo_taxo") %>'/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Tipo de formato">
                                    <ItemTemplate>
                                        <asp:Label ID="lbDescTipo" runat="server" text='<%# Bind("desc_tipo") %>'/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Tipo">
                                    <ItemTemplate>
                                        <asp:Label ID="lbTipoInfo" runat="server" text='<%# Bind("tipo_info") %>'/>
                                    </ItemTemplate>
                                    <HeaderStyle Width="15px" />
                                    <ItemStyle Width="15px" />
                                </asp:TemplateField>
                            </Columns>
                            <EditRowStyle CssClass ="GrillaTextosEditar"/>
                            <FooterStyle BackColor="#5D7B9D" CssClass="dbnGrilla" Font-Bold="True"  ForeColor="White" />
                            <PagerStyle BackColor="#CCCCCC" ForeColor="White" HorizontalAlign="Center" />
                            <RowStyle CssClass="RowStyle" />
                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                        </asp:GridView>
                        <br />
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    </div>
</asp:Content>