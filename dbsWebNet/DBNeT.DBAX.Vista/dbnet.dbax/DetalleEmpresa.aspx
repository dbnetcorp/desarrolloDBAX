<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="DetalleEmpresa.aspx.cs" Inherits="Website_Home" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    <asp:Label ID="lb_error" runat="server" Text="Label" CssClass="Error"/>
    <asp:Label CssClass="dbnTitulo" ID="lblTitulo" runat="server" Text="Label">Información Empresa</asp:Label>
    <div id="enca">
        <table border="0">
            <tr>
                <td>
                    <div id="InfoEmpr" style="background-color: #EEEEEE; width: 340px; height: auto; border-radius: 10px; position:relative; width:380px;">
                        <br />
                        <asp:Label ID="lbNombEmpr" runat="server" CssClass="lblIzquierdo"/>    
                        <br />
                        <asp:Label ID="lblRutEmpr" runat="server" CssClass="lblIzquierdo"/>
                        <br />
                        <asp:Label ID="lbFechInst" runat="server" CssClass="lblIzquierdo"/>
                        <br />
                        <asp:Label ID="lbDescGrup" runat="server" CssClass="lblIzquierdo"/>
                        <br />
                        <asp:Label ID="lbDescSegm" runat="server" CssClass="lblIzquierdo"/>
                        <br />
                        <asp:Label ID="lblMoneda" runat="server" CssClass="lblIzquierdo"/>
                        <br />
                        <asp:Label ID="lblTipoTaxo" runat="server" CssClass="lblIzquierdo" Visible="false"/>
                        <br />&nbsp;&nbsp;
                    </div>
                </td>
                <td>
                    <div id="DocuEmpr" style="position:relative; width:450px; margin-left:50px;">
                        <asp:Label ID="Label2" runat="server" Text="Documentos" CssClass="TextosNegritas"/>
                        <div style="vertical-align: top;">
                            <asp:GridView CssClass="gvArch" ID="gv_Archivos" runat="server" AutoGenerateColumns="False" 
                                    CellPadding="4" width="100%" GridLines="None" 
                                    OnRowCreated="RowCreated" onrowcommand="gv_Archivos_Click"> 
                                <AlternatingRowStyle CssClass="AlternatingRow"/>
                                <HeaderStyle CssClass="headerGrilla"/>
                                <Columns>
                                    <asp:ButtonField ButtonType="Image" CommandName="Descarga"
                                        ImageUrl="~/librerias/img/pdf.png" HeaderText=" " ItemStyle-width="40">
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    </asp:ButtonField>
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
                    </div>
                </td>
            </tr>
            <tr>
                <td height="50px"></td>
                <td></td>
            </tr>
            <tr>
                <td>
                    <div id="IndiEmpr" style="position:absolute; width:340px; padding-bottom:30px;">
                        <asp:Label ID="Label3" runat="server" Text="Indicadores" CssClass="TextosNegritas"/>
                        <div style="width:340px;" >
                            <asp:GridView ID="gv_Indicadores" runat="server" AutoGenerateColumns="False" 
                                    CellPadding="4" width="100%" GridLines="None"  
                                    OnRowCreated="RowCreated"> 
                                <AlternatingRowStyle CssClass="AlternatingRow"/>
                                <HeaderStyle CssClass="headerGrilla"/>
                                <Columns>
                                    <asp:TemplateField HeaderText="Código" Visible="False">
                                        <ItemTemplate>
                                            <asp:Label ID="lb_IndiCodi" runat="server" text='<%# Bind("Nombre") %>'/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Tipo" Visible="False">
                                        <ItemTemplate>
                                            <asp:Label ID="lb_IndiTipo" runat="server" text='<%# Bind("Tipo") %>'/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Descripción" Visible="True">
                                        <ItemTemplate>
                                            <asp:Label ID="lb_IndiDesc" runat="server" text='<%# Bind("Descripción") %>'/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Fórmula" Visible="False">
                                        <ItemTemplate>
                                            <asp:Label ID="lb_IndiForm" runat="server" text='<%# Bind("Fórmula") %>'/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Valor" ItemStyle-HorizontalAlign="Right" Visible="True">
                                        <ItemTemplate>
                                            <asp:Label CssClass="lblDerecho" ID="lb_IndiForm" runat="server" text='<%# Bind("ValoCntx") %>'/>
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
                    </div>
                </td>
                <td>
                    <div id="RepoEmpr" style="position:absolute; width:450px; margin-left:50px;">
                        <asp:Label ID="Label4" runat="server" Text="Reportes" CssClass="TextosNegritas" />
                        <div>
                            <asp:GridView ID="gv_Reportes" runat="server" AutoGenerateColumns="False" 
                                    CellPadding="4" width="100%"  GridLines="None" 
                                    OnRowCreated="RowCreated"
                                    onrowcommand="gv_ReportesClick"> 
                                <AlternatingRowStyle CssClass="AlternatingRow"/>
                                <HeaderStyle CssClass="headerGrilla"/>
                                <Columns>
                                    <asp:ButtonField ButtonType="Image" CommandName="Descarga"
                                        ImageUrl="~/librerias/img/excel.png" HeaderText=" " ItemStyle-width="40">
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    </asp:ButtonField>
                                    <asp:TemplateField HeaderText="Código" Visible="False">
                                        <ItemTemplate>
                                            <asp:Label ID="lb_CodiInfo" runat="server" text='<%# Bind("codi_info") %>'/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Reporte" Visible="True">
                                        <ItemTemplate>
                                            <asp:Label ID="lb_DescInfo" runat="server" text='<%# Bind("desc_info") %>'/>
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
                    </div>
                </td>
            </tr>
        </table>   
    </div>
    <div id="enca2">
    
    
    </div>
</asp:Content>