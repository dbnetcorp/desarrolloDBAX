<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="dbax_ejec_proc.aspx.cs" Inherits="DBAX_dbax_ejec_proc" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../librerias/jquery/UI/1.10.3/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="../librerias/jquery/UI/1.10.3/jquery-ui.js" type="text/javascript"></script>
    <script src="../librerias/jquery/1.9.1/jquery-1.9.1.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            // run the currently selected effect
            function runEffect() {
                // get effect type from
                var selectedEffect = "blind";
                // run the effect
                $("#effect").show(selectedEffect, 500, callback());
            };

            //callback function to bring a hidden box back
            function callback() {
                setTimeout(function () {
                    $("#effect").hide("drop").fadeOut();
                }, 2000);
            };

            // set effect from select menu value
            $("#bodyCP_btnActualizar").click(function () {
                runEffect();
                setTimeout(function () {
                    return true;
                }, 8000);
            });
            $("#effect").hide();
        });
    </script>
    <style type="text/css">
        .style1
        {
            width: 312px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    <div class="page">
    <div id="botones3" style="visibility:visible;" class="div3Botones">
        <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
        <div class="divBotones">
            <asp:ImageButton CssClass="dbn_btnEditar" ID="btnActualizar" runat="server" 
                    ImageUrl="~/librerias/img/botones/aceptar.png" onclick="btnActualizar_Click"/>
        </div>
    </div>
        <div id="contenFormulario">
            <asp:RadioButton ID="rbtRescata" runat="server" GroupName="carga" Text="Rescata XBRL"
                 oncheckedchanged="rbtCarga_CheckedChanged" CssClass="dbnLabel" AutoPostBack="True" /><br />
            <asp:RadioButton ID="rbtEjecuta" runat="server" GroupName="carga" Text="Ejecuta Cubo"
                 oncheckedchanged="rbtCarga_CheckedChanged" CssClass="dbnLabel" AutoPostBack="True" /><br />
            <asp:RadioButton ID="rbtSubir" runat="server" GroupName="carga" 
                Text="Subir XBRL" CssClass="dbnLabel" 
                oncheckedchanged="rbtCarga_CheckedChanged" AutoPostBack="True" /><br />
            <div id="cargaxbrl" visible="false" class="CargaXbrl" runat="server">
                <table>
                    <tr>
                        <td style="width:250px;"><asp:Label ID="lblCargaArchivo" CssClass="dbnLabel" runat="server" Text="Archivo: " /></td>
                        <td class="style1">
                            <asp:FileUpload ID="FileUpload1" runat="server"/>
                            </td>
                           <td style="width:250px;"> <asp:Label ID="Label" runat="server" Enabled="False" 
                                   Visible="False" Text="Seleccione Archivo *.zip" Font-Size="X-Small" 
                                   Font-Bold="True" Font-Italic="True" Font-Overline="False" 
                                   Font-Strikeout="False"/></td>
                                   <td>
                    </td>
                                            </tr>
                    <tr>
                    <td>
                    </td>
                       <td>
                       <asp:Label CssClass="lblError" ID="Mensaje" runat="server" Font-Size="Small"></asp:Label>
                    </td>
                        <td>
                            
                        </td>
                    </tr>
                 </table>
                 <table>
                    <tr>                 
                     <td>
                                  <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                      <ContentTemplate>
                                          <asp:Timer ID="Timer1" runat="server" Interval="3000">
                                          </asp:Timer>
                                          <asp:GridView ID="Grilla_Subir" runat="server" AllowPaging="True" 
                                              AutoGenerateColumns="False" CellPadding="4" CssClass="GrillaNormal" 
                                              ForeColor="#333333" GridLines="None" 
                                              onpageindexchanging="Grilla_Subir_desc_PageIndexChanging" PageSize="15" 
                                              HorizontalAlign="Center">
                                              <AlternatingRowStyle CssClass="AlternatingRow" />
                                              <HeaderStyle CssClass="headerGrilla" />
                                              <Columns>
                                                  <asp:TemplateField HeaderText="Rut Empresa">
                                                      <ItemTemplate>
                                                          <asp:Label ID="lbCodiPers" runat="server" text='<%# Bind("codi_pers") %>' />
                                                      </ItemTemplate>
                                                      <ItemStyle width="60px" />
                                                  </asp:TemplateField>
                                                  <asp:TemplateField HeaderText="Empresa">
                                                      <ItemTemplate>
                                                          <asp:Label ID="lbDescPers" runat="server" text='<%# Bind("desc_pers") %>' 
                                                              width="300px" />
                                                      </ItemTemplate>
                                                      <HeaderStyle width="300px" />
                                                  </asp:TemplateField>
                                                 <%-- <asp:TemplateField HeaderText="Usuario">
                                                      <ItemTemplate>
                                                          <asp:Label ID="lbUsuaCarg" runat="server" text='<%# Bind("usua_carg") %>' 
                                                              width="50px" />
                                                      </ItemTemplate>
                                                  </asp:TemplateField>--%>
                                                  <asp:TemplateField HeaderText="Periodo">
                                                      <ItemTemplate>
                                                          <asp:Label ID="lbCorrInst" runat="server" text='<%# Bind("corr_inst") %>' />
                                                      </ItemTemplate>
                                                      <ItemStyle width="60px" />
                                                  </asp:TemplateField>
                                                  <asp:TemplateField HeaderText="Versión">
                                                      <ItemTemplate>
                                                          <asp:Label ID="lbVersInst" runat="server" text='<%# Bind("vers_inst") %>' />
                                                      </ItemTemplate>
                                                      <ItemStyle width="60px" />
                                                  </asp:TemplateField>
                                                  <asp:TemplateField HeaderText="Fecha">
                                                      <ItemTemplate>
                                                          <asp:Label ID="lbFechCarg" runat="server" text='<%# Bind("fech_carg") %>' />
                                                      </ItemTemplate>
                                                      <ItemStyle width="300px" />
                                                  </asp:TemplateField>
                                                  <asp:TemplateField HeaderText="Estado Carga">
                                                      <ItemTemplate>
                                                          <asp:Label ID="lbEstaCarg" runat="server" text='<%# Bind("esta_carg") %>' />
                                                      </ItemTemplate>
                                                      <ItemStyle width="60px" />
                                                  </asp:TemplateField>
                                          <%--asp:TemplateField HeaderText="Estado HTML">
                                                      <ItemTemplate>
                                                          <asp:Label ID="lbEstaHtml" runat="server" text='<%# Bind("esta_gene") %>' />
                                                      </ItemTemplate>
                                                      <ItemStyle width="60px" />
                                                  </asp:TemplateField>--%>
                                              </Columns>
                                              <EditRowStyle CssClass="TextosNegritas" HorizontalAlign="Center" />
                                              <FooterStyle BackColor="#5D7B9D" CssClass="dbnGrilla" Font-Bold="True" 
                                                  ForeColor="White" />
                                              <PagerStyle BackColor="#CCCCCC" CssClass="TextosNegritas" 
                                                  HorizontalAlign="Center" />
                                              <RowStyle CssClass="RowStyle" HorizontalAlign="Center" />
                                              <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                          </asp:GridView>
                                      </ContentTemplate>
                                      <Triggers>
                                          <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
                                          <asp:PostBackTrigger ControlID="Grilla_Subir" />
                                      </Triggers>
                                  </asp:UpdatePanel>
              </td>
              
                    </tr>
                </table>
            </div>
        </div> 
    <!-- <div class="toggler">
        <div id="effect" class="ui-widget-content ui-corner-all" style="width:280px;">
            <center><h3 class="ui-widget-header ui-corner-all">Registro Ingresado</h3></center>
            <p>Su solicitud está siendo procesada.</p>
        </div>
    </div>  -->
</div>
</asp:Content>