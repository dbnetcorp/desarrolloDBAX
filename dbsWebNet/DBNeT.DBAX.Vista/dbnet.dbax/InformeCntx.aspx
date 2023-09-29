<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="InformeCntx.aspx.cs" Inherits="Website_InformeCntx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="pageFw5">
    <asp:Label ID="Label10" runat="server" Text="Label" CssClass="dbnTitulo">Contextos por informe</asp:Label>
    <br /><br />

    <table class="Selectores" border="0">
        <tr>
            <td >
                    <asp:Label ID="Label15" runat="server" Text="Informe" 
                    CssClass="lblIzquierdo"/>
            </td>
            <td >
                <asp:DropDownList CssClass="dbnListaValor" ID="ddl_CodiInfo" runat="server" Width="300px" 
                    onselectedindexchanged="Informe_SelectedIndexChanged" AutoPostBack="True">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td>
                    <asp:Label ID="Label16" runat="server" Text="Nombre contexto" 
                    CssClass="lblIzquierdo"/>
            </td>
            <td>
                <asp:DropDownList CssClass="dbnListaValor" ID="NombreCntx" runat="server" Width="300px" >
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td>
                    <asp:Label ID="Label17" runat="server" Text="Orden de columna" 
                    CssClass="lblIzquierdo"/>
            </td>
            <td>
                    <asp:TextBox CssClass="dbnTextbox" ID="orden" runat="server" Width="100px"></asp:TextBox>

                      <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" 
                       FilterMode="ValidChars" FilterType="Numbers" 
                       TargetControlID="orden" ValidChars="0123456789">
                       </asp:FilteredTextBoxExtender>
            </td>
        </tr>
        <tr>
            <td>
            </td>
            <td>      
                <asp:ImageButton ID="agregarCntxInfo" runat="server" 
                    ImageUrl="~/librerias/img/agregar.png" 
                    onclick="agregar" Height="20px" Width="20px" />
            </td>
        </tr>
    </table>
    <br />
    <asp:GridView ID="Grilla_Cntx" runat="server" AutoGenerateColumns="False" 
                CellPadding="4" ForeColor="#333333"  
                Width="750px"  GridLines="None" 
                onrowdeleting="Grilla_Informe_RowDeleting" 
                onrowcancelingedit="Grilla_Informe_RowCancelingEdit" 
                onrowediting="Grilla_Informe_RowEditing" 
                onrowupdating="Grilla_Informe_RowUpdating">
        <AlternatingRowStyle CssClass="AlternatingRow"/>
        <HeaderStyle CssClass="headerGrilla"/>
        <Columns>
            <asp:TemplateField HeaderText="Orden">
                <ItemTemplate>
                    <asp:Label ID="Label18" runat="server" text='<%# Bind("orde_cntx") %>'/>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:Label ID="lb_OrdeCntx" runat="server" text='<%# Bind("orde_cntx") %>' Visible="false"/>
                    <asp:TextBox ID="TextBox4" runat="server" text='<%# Bind("orde_cntx") %>' Width="90px"></asp:TextBox>
                    <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" 
                        FilterMode="ValidChars" FilterType="Numbers" 
                        TargetControlID="TextBox4" ValidChars="0123456789">
                    </asp:FilteredTextBoxExtender>
                </EditItemTemplate>
                <ItemStyle HorizontalAlign="Center" Width="20px" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="CodiCntx">
                <ItemTemplate>
                    <asp:Label ID="lbCodiCntx" runat="server"  text='<%# Bind("codi_cntx") %>'/>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="DescCntx">
                <ItemTemplate>
                    <asp:Label ID="lbDescCntx" runat="server"  text='<%# Bind("desc_cntx") %>'/>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ButtonType="Image" 
                        CancelImageUrl="~/librerias/img/imgCan.png" 
                        EditImageUrl="~/librerias/img/edit.png" HeaderText="Edición" 
                        ShowEditButton="True" 
                        UpdateImageUrl="~/librerias/img/imgAct.png">
            <ItemStyle HorizontalAlign="Center" Width="30px" />
            </asp:CommandField>
            <asp:CommandField ButtonType="Image" 
                DeleteImageUrl="~/librerias/img/borrar_chico.png" 
                ShowDeleteButton="True" >
            <ItemStyle HorizontalAlign="Center" Width="20px" />
            </asp:CommandField>
        </Columns>
        <EditRowStyle CssClass="GrillaTextosEditar"/>
        <FooterStyle BackColor="#5D7B9D" CssClass="dbnGrilla" Font-Bold="True" 
                    ForeColor="White" />
        <PagerStyle BackColor="#CCCCCC" ForeColor="White" HorizontalAlign="Center" />
        <RowStyle CssClass="RowStyle" />
        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
    </asp:GridView>
    <br />
        <asp:Label ID="lb_error" runat="server" Text="Label" CssClass="Error"/>
    </div>
    </asp:Content>