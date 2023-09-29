<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPageNoTimer.master"  AutoEventWireup="true" CodeFile="dbaxExpoData.aspx.cs" Inherits="dbaxExpoData"%>
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
        /*$(function () {
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
        }*/
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="bodyCP" Runat="Server">
    <div class="pageFw5">
    <asp:Label ID="Label10" runat="server" Text="Label" CssClass="dbnTitulo">Exportación de datos</asp:Label>
    <br /><br />
    <asp:UpdatePanel ID="UpdatePanel2" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional">
        <ContentTemplate>
            <table class="lblIzquierdo">
                <!-- Tipo empresa -->
                <tr>
                    <td >
                        <asp:Label ID="Label9" runat="server" Text="Tipo empresa" CssClass="lblIzquierdo"/>
                    </td>
                    <td>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_TipoTaxonomia" runat="server" AutoPostBack="true" 
                             width="353px" 
                            onselectedindexchanged="ddl_TipoTaxonomia_SelectedIndexChanged">
                        </asp:DropDownList>
                    </td>
                </tr>
                
                <!-- Segmento -->
                <tr>
                    <td>
                        <asp:Label ID="Label8" runat="server" CssClass="lblIzquierdo" Text="Segmento"/>
                    </td>
                    <td>
                        <asp:DropDownList CssClass="dbnListaValor" ID="ddl_Segmento" runat="server" AutoPostBack="true" 
                             onselectedindexchanged="ddl_Segmento_SelectedIndexChanged" 
                            width="353px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <!-- Periodo-->
                <tr>
                    <td>
                        <asp:Label ID="Label4" runat="server" Text="Periodo" CssClass="lblIzquierdo"/>
                    </td>
                    <td>
                        <asp:ListBox CssClass="dbnListaValor" ID="ddl_CorrInst" runat="server" SelectionMode="Multiple" width="353px" 
                            onselectedindexchanged="ddl_CorrInst_SelectedIndexChanged" AutoPostBack="true" Height="60px">
                        </asp:ListBox>
                    </td>
                </tr>
                <!-- Tipo filtro -->
                <tr>
                    <td>
                        <asp:Label ID="Label333" runat="server" Text="Tipo filtro" CssClass="lblIzquierdo"/> 
                    </td>
                    <td>
                        <asp:RadioButtonList ID="tipoFiltro" runat="server" 
                            onselectedindexchanged="tipoFiltro_SelectedIndexChanged" AutoPostBack="true" >
                                <asp:ListItem Text="Informes publicados" Value="IP" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Todos los informes" Value="TI"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                

                <!-- Informe -->
                <tr>
                    <td><asp:Label ID="Label2" runat="server" Text="Informe" CssClass="lblIzquierdo"/></td>
                    <td>
                        <asp:ListBox CssClass="dbnListaValor" ID="ddl_CodiInfo" runat="server" SelectionMode="Multiple" 
                            width="353px" Height="150px" onselectedindexchanged="ddl_CodiInfo_SelectedIndexChanged" >
                        </asp:ListBox>
                    </td>
                </tr>

                <!-- Empresas -->
                <tr>
                    <td style="width:150px">
                        <asp:Label ID="Label1" runat="server" Text="Empresa" CssClass="lblIzquierdo"/>
                    </td>
                    <td colspan="2">
                        <asp:ListBox CssClass="dbnListaValor" ID="ddl_CodiEmpr" runat="server" SelectionMode="Multiple" Height="100px"  width="353px" 
                            onselectedindexchanged="ddl_CodiEmpr_SelectedIndexChanged" >
                        </asp:ListBox>
                    </td>
                </tr>
           
                <tr>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        <asp:ImageButton ID="Procesar" runat="server" height="26px" 
                            ImageUrl="~/librerias/img/bt_procesar.png" 
                            onclick="Procesar_Click" OnClientClick="return confirm('¿Está seguro?');" width="60px" />
                        <asp:Label ID="LabelError" runat="server" Text="" CssClass="lblError"/>
                        <%-- <asp:ImageButton ID="ib_Rescatar" runat="server" height="26px" 
                            ImageUrl="~/librerias/img/bt_rescatar.png" width="60px" 
                            onclick="ib_Rescatar_Click" />
                        <asp:ImageButton ID="Procesar" runat="server" height="26px" 
                            ImageUrl="~/librerias/img/bt_procesar.png" 
                            onclick="Procesar_Click" OnClientClick="return confirm('Se regenerará el informe a partir de los datos guardados ¿Está seguro?');" width="60px" />
                        &nbsp;<asp:CheckBox CssClass="lblIzquierdo" ID="ckbTraspuesto" runat="server" Text="Transpuesto" />--%>
                    </td>
                </tr>
            </table>

            <h2 id="structures">
            <asp:Label ID="lb_error" runat="server" Text="Label" CssClass="Error" Visible="false"/>
            </h2>
        </ContentTemplate>
    </asp:UpdatePanel>

        <%--<div style="border: 1px solid #ccc; padding: 10px; margin-bottom:25px;">
            <asp:Image runat="server" ID="semaforo" ImageUrl="~/librerias/img/imgOk.png" /> 
            <asp:Label ID="LabelProceso" runat="server" Text="No existen procesos aún para este usuario." CssClass="lblIzquierdo"/>
            <asp:LinkButton ID="linkArchivo" runat="server" Text="Descargar aquí" AutoPostBack="true" onClick="linkArchivo_Click" CommandArgument="" Visible="false" Enabled="false" CssClass="lblIzquierdo" /> 
            <asp:Label ID="LabelArchivo" runat="server" Text="" CssClass="lblIzquierdo"/>     
        </div>--%>

        <div style="border: 1px solid #ccc; padding: 10px; margin-bottom:25px;">
            <div runat="server" id="contMensaje" CssClass="lblIzquierdo"></div>
            <asp:LinkButton ID="linkArchivo" runat="server" Text="Hacer click acá para descargar archivo" AutoPostBack="true" onClick="linkArchivo_Click" CommandArgument="" Visible="false" Enabled="false" CssClass="lblIzquierdo" /> 
            <asp:Label ID="LabelArchivo" runat="server" Text="" CssClass="lblIzquierdo"/>     
        </div>
    </div>
</asp:Content>