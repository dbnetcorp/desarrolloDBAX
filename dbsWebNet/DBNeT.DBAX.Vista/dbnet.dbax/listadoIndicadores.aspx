<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="listadoIndicadores.aspx.cs" Inherits="Website_listadoIndicadores" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="pageFw5">
    <asp:Label ID="Label10" runat="server" Text="Label" CssClass="dbnTitulo">Mantención indicadores</asp:Label>
    <br /><br />

    <a href="Indicadores.aspx"><img alt="Agregar" src="../librerias/img/agregar.png" /></a>
    <table class="Selectores">
        <tr>
            <td>
                <asp:GridView ID="gv_Indicadores" runat="server" CssClass="GrillaNormal" 
                    style="position:relative;top: 10px; left: 0px;" GridLines="None" 
                    onselectedindexchanged="gv_Indicadores_SelectedIndexChanged" 
                    OnRowCreated="RowCreated"
                    >
                    <AlternatingRowStyle CssClass="AlternatingRow"/>
                    <HeaderStyle CssClass="headerGrilla"/>
                    <Columns>
                            <asp:CommandField ButtonType="Image" ShowSelectButton="True" SelectImageUrl="~/librerias/img/edit.png" />
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
    </div>
</asp:Content>