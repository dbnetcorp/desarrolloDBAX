<%@ page title="" language="C#" masterpagefile="~/dbnet.dbax/MasterPage.master" autoeventwireup="true" inherits="CargaXBRLUsuario, App_Web_cargaxbrlusuario.aspx.95992650" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <link href="../librerias/CSS/jquery.sheet.css" rel="stylesheet" type="text/css" />
    <link href="../librerias/CSS/theme/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../librerias/CSS/jquery.colorPicker.css" rel="stylesheet" type="text/css" />
    <meta http-equiv="cache-control" content="no-cache"/>
    <script src="../librerias/js/jquery-ui/jquery-1.5.2.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery-ui/jquery.sheet.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery-ui/parser.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery.scrollTo-min.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery-ui/ui/jquery-ui.min.js" type="text/javascript"></script>
    <script src="../librerias/js/raphael-min.js" type="text/javascript"></script>
    <script src="../librerias/js/g.raphael-min.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery.colorPicker.min.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery.elastic.min.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery-ui/jquery.sheet.advancedfn.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery-ui/jquery.sheet.financefn.js" type="text/javascript"></script>

    <script type="text/javascript">
        $(function () {
            $('#jQuerySheet0').sheet({
                title: 'Visualizador',
                inlineMenu: inlineMenu($.sheet.instance),
                //urlGet: document.getElementById("bodyCP_ruta_html").value,
                urlGet: document.getElementById("bodyCP_ruta_html").value,
                autoFiller: true
            });
            var o = $('#structures');
            var top = o.offset().top - 300;
            $(document).scroll(function (e) {
                if ($(this).scrollTop() > top) {
                    $('#lockedMenu').removeClass('locked');
                }
                else {
                    $('#lockedMenu').addClass('locked');
                }
            }).scroll();
        });

        function inlineMenu(I) {
            I = (I ? I.length : 0);

            //we want to be able to edit the html for the menu to make them multi-instance
            var html = $('#inlineMenu').html().replace(/sheetInstance/g, "$.sheet.instance[" + I + "]");

            var menu = $(html);

            //The following is just so you get an idea of how to style cells
            menu.find('.colorPickerCell').colorPicker().change(function () {
                $.sheet.instance[I].cellChangeStyle('background-color', $(this).val());
            });

            menu.find('.colorPickerFont').colorPicker().change(function () {
                $.sheet.instance[I].cellChangeStyle('color', $(this).val());
            });

            menu.find('.colorPickers').children().eq(1).css('background-image', "url('librerias/img/palette.png')");
            menu.find('.colorPickers').children().eq(3).css('background-image', "url('librerias/img/palette_bg.png')");

            return menu;
        }

        function goToObj(s) {
            $('html, body').animate({
                scrollTop: $(s).offset().top
            }, 'slow');
            return false;
        }
    </script>
    <style type="text/css">
        .style1
        {
            width: 113px;
        }
    </style>
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
 <div class="pageFw5">
  <asp:Label ID="Label10" runat="server" Text="Label" CssClass="dbnTitulo">Carga XBRL por usuario</asp:Label>
    <br /><br />
      <table class="Selectores" border ="0">
         <tr>
             <td class="style1">
                 <asp:Label ID="Label4" runat="server" CssClass="lblIzquierdo" Text="Archivo XBRL" />
             </td>
             <td>
                 <asp:FileUpload ID="fuXbrlUsua" runat="server" Width="353px" size="43"/>
             </td>
             <td></td>
         </tr>
         <tr>
             <td class="style1">
                 <asp:Label ID="Label1" runat="server" CssClass="lblIzquierdo" Text="Generar nota IFRS 13" />
             </td>
             <td>
                 <asp:CheckBox ID="chkIFRS13" CssClass="lblIzquierdo" runat="server" />
             </td>
             <td></td>
         </tr>
         <tr>
             <td class="style1">
                 &nbsp;</td>
             <td>
              <asp:ImageButton ID="Procesar" runat="server" height="26px" 
                            ImageUrl="~/librerias/img/bt_procesar.png" 
                            onclick="Procesar_Click" width="60px" />
             </td>
             <td></td>
         </tr>   
         <tr>
             <td colspan="2">
                <asp:Label ID="lb_error" runat="server" Text="Label" CssClass="Error" 
                     Visible="False"/>
             </td>
             <td></td>
         </tr>   
         <tr>
             <td colspan="3">
                 <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Timer ID="Timer1" runat="server" Interval="3000">
                    </asp:Timer>
            <asp:GridView ID="Grilla_Empresas" runat="server" AutoGenerateColumns="False" 
                    CssClass="GrillaNormal" GridLines="None" onpageindexchanging="Grilla_Empresas_desc_PageIndexChanging" 
                    CellPadding="4" ForeColor="#333333" 
                    AllowPaging="True" 
                    PageSize="20">
                    <AlternatingRowStyle CssClass="AlternatingRow"/>
                    <HeaderStyle CssClass="headerGrilla"/>
                <Columns>
                    <asp:TemplateField HeaderText="Rut Empresa">
                        <ItemTemplate>
                            <asp:Label ID="lbCodiPers" runat="server" text='<%# Bind("codi_pers") %>'/>
                        </ItemTemplate>
                        <ItemStyle width="60px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Empresa">
                        <ItemTemplate>
                            <asp:Label ID="lbDescPers" runat="server" text='<%# Bind("desc_pers") %>' 
                                width="300px"/>
                        </ItemTemplate>
                        <HeaderStyle width="300px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Usuario">
                        <ItemTemplate>
                            <asp:Label ID="lbUsuaCarg" runat="server" text='<%# Bind("usua_carg") %>' 
                                width="50px"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Periodo">
                        <ItemTemplate>
                            <asp:Label ID="lbCorrInst" runat="server" text='<%# Bind("corr_inst") %>'/>
                        </ItemTemplate>
                        <ItemStyle width="60px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Versión">
                        <ItemTemplate>
                            <asp:Label ID="lbVersInst" runat="server" text='<%# Bind("vers_inst") %>'/>
                        </ItemTemplate>
                        <ItemStyle width="60px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Fecha">
                        <ItemTemplate>
                            <asp:Label ID="lbFechCarg" runat="server" text='<%# Bind("fech_carg") %>'/>
                        </ItemTemplate>
                        <ItemStyle width="300px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Estado Carga">
                        <ItemTemplate>
                            <asp:Label ID="lbEstaCarg" runat="server" text='<%# Bind("esta_carg") %>'/>
                        </ItemTemplate>
                        <ItemStyle width="60px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Estado HTML">
                        <ItemTemplate>
                            <asp:Label ID="lbEstaHtml" runat="server" text='<%# Bind("esta_gene") %>'/>
                        </ItemTemplate>
                        <ItemStyle width="60px" />
                    </asp:TemplateField>
                </Columns>
                <EditRowStyle CssClass="TextosNegritas"/>
                <FooterStyle BackColor="#5D7B9D" CssClass="dbnGrilla" Font-Bold="True" 
                            ForeColor="White" />
                <PagerStyle BackColor="#CCCCCC" HorizontalAlign="Center" 
                        CssClass ="TextosNegritas" />
                <RowStyle CssClass="RowStyle" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            </asp:GridView>
            </ContentTemplate>
              <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
                    <asp:PostBackTrigger ControlID="Grilla_Empresas" />
              </Triggers>
           </asp:UpdatePanel>
             </td>
         </tr>   
     </table>
 </div>
</asp:Content>

