<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="GeneraCntx.aspx.cs" Inherits="Website_MantencionCntx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="pageFw5">
    <asp:Label ID="Label10" runat="server" Text="Label" CssClass="dbnTitulo">Mantención contextos</asp:Label>
    <br /><br />
    
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table >
                <tr>
                    <td width="300px">
                        <asp:Label ID="Label15" runat="server" Text="Nombre contexto" CssClass="lblIzquierdo"/>
                    </td>
                    <td width="350px">
                        <asp:TextBox CssClass="dbnTextbox" ID="Nombre_cntx" runat="server" Width="350px" visible="false"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td >
                        <asp:Label ID="Label16" runat="server" Text="Fecha inicio" 
                            CssClass="lblIzquierdo" Visible="False"/>
                    </td>
                    <td>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_FechIni1" runat="server" 
                            Width="200px" Height="22px" 
                            onselectedindexchanged="ddl_FechIni1_SelectedIndexChanged" 
                            AutoPostBack="true" Visible="False"></asp:DropDownList>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_FechIni2" runat="server" Width="130px" 
                            onselectedindexchanged="ddl_FechIni1_SelectedIndexChanged" 
                            AutoPostBack="true" Visible="False"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td >
                        <asp:Label ID="Label17" runat="server" Text="Fecha término" 
                            CssClass="lblIzquierdo" Visible="False"/>
                    </td>
                    <td >
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_FechFin1" runat="server" Width="200px"
                            onselectedindexchanged="ddl_FechFin1_SelectedIndexChanged" 
                            AutoPostBack="true" Enabled="false" Visible="False"></asp:DropDownList>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_FechFin2" runat="server" Width="130px"
                            onselectedindexchanged="ddl_FechFin1_SelectedIndexChanged" 
                            AutoPostBack="true" Enabled="false" Visible="False"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label1" runat="server" Text="Periodo de referencia" CssClass="lblIzquierdo"/>
                    </td>
                    <td>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_CorrInst" runat="server" Width="200px"
                            onselectedindexchanged="ddl_CorrInst_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label2" runat="server" Text="Fechas de referencia" 
                            CssClass="lblIzquierdo" Visible="False"/>
                    </td>
                    <td>
                        <asp:Label ID="lb_FechIni" runat="server" Text="-" CssClass="lblIzquierdo" 
                            Width="100px" Visible="False"/>
                        <asp:Label ID="lb_FechFin" runat="server" Text="-" CssClass="lblIzquierdo" 
                            Width="100px" Visible="False"/>
                    </td>
                </tr>
                <tr>
                    <td >
                        &nbsp;</td>
                    <td>
                        <asp:ImageButton ID="agregar" runat="server" ImageUrl="~/librerias/img/agregar.png" 
                            onclick="agregar_Click_cntx" Height="20px" Width="20px" Visible="false" />
                    </td>
                </tr>
            </table>
            <br />
            <asp:Label ID="lb_error" runat="server" Text="Label" CssClass="Error"/>
            <br />
            <asp:GridView ID="Grilla_Cntx" runat="server" AutoGenerateColumns="False" 
                        CellPadding="4" Width="900px"  GridLines="None" 
                        onrowdeleting="Grilla_Cntx_RowDeleting" 
                        onrowediting="Grilla_Cntx_RowEditing" 
                        onrowdatabound="Grilla_Cntx_RowDataBound" 
                        onrowcancelingedit="Grilla_Cntx_RowCancelingEdit" 
                        onrowupdating="Grilla_Cntx_RowUpdating"
                        OnRowCreated="RowCreated" > 
                <AlternatingRowStyle CssClass="AlternatingRow"/>
                <HeaderStyle CssClass="headerGrilla"/>
                <Columns>
                    <asp:TemplateField HeaderText="Código">
                        <ItemTemplate>
                            <asp:Label ID="lb_CodiCntx" runat="server" text='<%# Bind("codi_cntx") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Descripción" >
                        <ItemTemplate>
                            <asp:Label ID="lbl_DescCntx" runat="server" text='<%# Bind("desc_cntx") %>' Width="150px"/>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox CssClass="dbnTextbox" ID="tb_DescCntx" runat="server" text='<%# Bind("desc_cntx") %>' Width="150px"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Codigo Dia Inicio">
                        <ItemTemplate>
                            <asp:Label ID="lb_CodiDiai" runat="server" text='<%# Bind("codi_diai") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Mes y día de inicio">
                        <ItemTemplate>
                            <asp:Label ID="lb_DiaiCntx" runat="server" text='<%# Bind("diai_cntx") %>' Width="100px"/>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList CssClass="dbnListaValor" ID="ddl_DiaiCntx" runat="server" Width="100px"></asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Codigo Ano Inicio">
                        <ItemTemplate>
                            <asp:Label ID="lb_CodiAnoi" runat="server" text='<%# Bind("codi_anoi") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Ano de inicio">
                        <ItemTemplate>
                            <asp:Label ID="lb_AnoiCntx" runat="server" text='<%# Bind("anoi_cntx") %>'  Width="100px"/>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList CssClass="dbnListaValor" ID="ddl_AnoiCntx" runat="server" Width="100px"></asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Fecha inicio (relativa)">
                        <ItemTemplate>
                            <asp:Label ID="lb_fini_cntx" runat="server" Width="90px" text='<%# Bind("fini_cntx") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Codigo Dia Termino">
                        <ItemTemplate>
                            <asp:Label ID="lb_CodiDiat" runat="server" text='<%# Bind("codi_diat") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Mes y día de término">
                        <ItemTemplate>
                            <asp:Label ID="lb_DiatCntx" runat="server" text='<%# Bind("diat_cntx") %>'  Width="100px"/>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList CssClass="dbnListaValor" ID="ddl_DiatCntx" runat="server" Width="100px"></asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Codigo Ano Termino">
                        <ItemTemplate>
                            <asp:Label ID="lb_CodiAnot" runat="server" text='<%# Bind("codi_Anot") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Ano de término">
                        <ItemTemplate>
                            <asp:Label ID="lb_AnotCntx" runat="server" text='<%# Bind("anot_cntx") %>' Width="100px"/>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList CssClass="dbnListaValor" ID="ddl_AnotCntx" runat="server" Width="100px"></asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Fecha fin (relativa)">
                        <ItemTemplate>
                            <asp:Label ID="lb_ffin_cntx" runat="server" text='<%# Bind("ffin_cntx") %>' Width="90px" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="CodiEmex">
                        <ItemTemplate>
                            <asp:Label ID="lb_codi_emex" runat="server" text='<%# Bind("codi_emex") %>' Width="40px" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="CodiEmpr">
                        <ItemTemplate>
                            <asp:Label ID="lb_codi_empr" runat="server" text='<%# Bind("codi_empr") %>' Width="40px" />
                        </ItemTemplate>
                    </asp:TemplateField>

                   <asp:TemplateField HeaderText="">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkedit1" runat="server" CommandName="Edit"><img alt="Editar" src="../librerias/img/edit.png" /></asp:LinkButton>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:LinkButton ID="lnkedit2" runat="server" CommandName="Update"><img alt="Editar" src="../librerias/img/imgAct.png" /></asp:LinkButton>
                            <asp:LinkButton ID="lnkedit3" runat="server" CommandName="Cancel"><img alt="Editar" src="../librerias/img/imgCan.png" /></asp:LinkButton>
                        </EditItemTemplate> 
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" 
                            OnClientClick="return confirm('Se eliminará este contexto y todas sus asociaciones con los informes. ¿Está seguro?');"><img alt="Borrar" src="../librerias/img/borrar.png" width="20"/></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EditRowStyle CssClass="TextosNegritas"/>
                <FooterStyle BackColor="#5D7B9D" CssClass="dbnGrilla" Font-Bold="True" 
                            ForeColor="White" />
                <PagerStyle BackColor="#CCCCCC" HorizontalAlign="Center" CssClass ="TextosNegritas" />
                <RowStyle CssClass="RowStyle" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            </asp:GridView>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="agregar" />
        </Triggers>
    </asp:UpdatePanel>
    <br />
    </div>
</asp:Content>