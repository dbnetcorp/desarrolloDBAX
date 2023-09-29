<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master" AutoEventWireup="true" CodeFile="ConsultaGrupoRamos.aspx.cs" Inherits="ConsultaGrupoRamos" %>
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
<div class="pageFw5">
    <asp:Label CssClass="dbnTitulo" ID="lblTitulo" runat="server">Consulta Grupo Ramos</asp:Label>
    <br />
    <br />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table class="Selectores">
                <tr>
                    <td style="width:250px;"><asp:Label CssClass="lblIzquierdo" ID="lblSegmento" runat="server" Text="Segmento"/></td>
                    <td style="width:500px;"><asp:DropDownList CssClass="dbnListaValor" ID="ddlSegmentos" runat="server"/>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" InitialValue="0" runat="server" ErrorMessage="Debe Seleccionar un Segmento" ControlToValidate="ddlSegmentos"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:250px;"><asp:Label CssClass="lblIzquierdo" ID="lblPeriodo" runat="server" Text="Período"/></td>
                    <td style="width:500px;"><asp:DropDownList CssClass="dbnListaValor" ID="ddlPeriodos" runat="server"/>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" InitialValue="0" runat="server" ErrorMessage="Debe Seleccionar un período" ControlToValidate="ddlPeriodos"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:250px;"><asp:Label CssClass="lblIzquierdo" ID="lblCuadro" runat="server" Text="Cuadro"/></td>
                    <td style="width:500px;"><asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlCuadros" 
                            runat="server" onselectedindexchanged="ddlCuadros_SelectedIndexChanged"/>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" InitialValue="0" runat="server" ErrorMessage="Debe seleccionar un informe" ControlToValidate="ddlCuadros"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:250px;"><asp:Label CssClass="lblIzquierdo" ID="lblDimension" runat="server" Text="Dimensión"/></td>
                    <td style="width:500px;"><asp:DropDownList AutoPostBack="true" CssClass="dbnListaValor" ID="ddlDimension" runat="server" 
                            onselectedindexchanged="ddlDimension_SelectedIndexChanged"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:250px;"><asp:Label CssClass="lblIzquierdo" ID="lblConcepto" runat="server" Text="Concepto"/></td>
                    <td style="width:500px;"><asp:DropDownList CssClass="dbnListaValor" ID="ddlConcepto" runat="server"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:250px;"><asp:Label CssClass="lblIzquierdo" ID="lblMoneda" runat="server" Text="Moneda"/></td>
                    <td style="width:500px;"><asp:DropDownList CssClass="dbnListaValor" ID="ddlMoneda" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td style="width:500px;"><asp:ImageButton ID="btnProcesar" ImageUrl="~/librerias/img/bt_procesar.png" 
                            OnClientClick="return confirm('Se regenerará el informe a partir de los datos guardados ¿Está seguro?');" 
                            runat="server" onclick="btnProcesar_Click" /></td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>

    <h2 id="structures">
    <asp:Label ID="lblError" runat="server" Text="Label" CssClass="Error"/>
    </h2>
    <br/>

    <div id="mainWrapper" class="ui-corner-all wrapper">
        <table style="width: 100%;">
            <tr>
                <td rowspan="2" style="vertical-align: top;" ></td>
            </tr>

            <tr>
                <td colspan="2" style="vertical-align: top;">
                    <div id="jQuerySheet0" class="jQuerySheet" style="height: 450px;"></div>
                    <asp:TextBox ID="ruta_html" runat="server" style="visibility: visible;">librerias/sheets/Inicio.html</asp:TextBox>
                    <asp:TextBox ID="tb_html" runat="server" style="visibility: hidden;">0</asp:TextBox>
                    <br/>
                </td>
            </tr>
        </table>
    </div>
    
    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <span id="inlineMenu" style="display: none;">
		        <span>
			        <!--<a href="#" onclick="sheetInstance.controlFactory.addRow(); return false;" title="Insertar celda Después">
				        <img alt="Insert Row After Selected" src="../librerias/img/sheet_row_add.png"/></a>
			        <a href="#" onclick="sheetInstance.controlFactory.addRow(null, true); return false;" title="Insertar la celda antes">
				        <img alt="Insert Row Before Selected" src="../librerias/img/sheet_row_add.png"/></a>
			        <a href="#" onclick="sheetInstance.controlFactory.addRow(null, null, ':last'); return false;" title="agregar al final ">
				        <img alt="Add Row" src="../librerias/img/sheet_row_add.png"/></a>
			        <a href="#" onclick="sheetInstance.controlFactory.addRowMulti(); return false;" title="Agregar multi-celda">
				        <img alt="Add Multi-Rows" src="../librerias/img/sheet_row_add_multi.png"/></a>
			        <a href="#" onclick="sheetInstance.deleteRow(); return false;" title="Eliminar celda">
				        <img alt="Delete Row" src="../librerias/img/sheet_row_delete.png"/></a>
			        <a href="#" onclick="sheetInstance.controlFactory.addColumn(); return false;" title="Insertar Columnas antes">
				        <img alt="Insert Column After Selected" src="../librerias/img/sheet_col_add.png"/></a>
			        <a href="#" onclick="sheetInstance.controlFactory.addColumn(null, true); return false;" title="Insertar Columnas despues">
				        <img alt="Insert Column Before Selected" src="../librerias/img/sheet_col_add.png"/></a>
			        <a href="#" onclick="sheetInstance.controlFactory.addColumn(null, null, ':last'); return false;" title="Agregar Columnas al final">
				        <img alt="Add Column At End" src="../librerias/img/sheet_col_add.png"/></a>
			        <a href="#" onclick="sheetInstance.controlFactory.addColumnMulti(); return false;" title="Insertar Multi-Columnas">
				        <img alt="Add Multi-Columns" src="../librerias/img/sheet_col_add_multi.png"/></a>
			        <a href="#" onclick="sheetInstance.deleteColumn(); return false;" title="Eliminar Columnas">
				        <img alt="Delete Column" src="../librerias/img/sheet_col_delete.png"/></a>
			        <a href="#" onclick="sheetInstance.getTdRange(null, sheetInstance.obj.formula().val()); return false;" title="Obtener rango de celdas">
				        <img alt="Get Cell Range" src="../librerias/img/sheet_get_range.png"/></a>
                    <asp:ImageButton ID="ImageButton2" runat="server" title="Guardar cambios"
                        ImageUrl="librerias/img/disk.png" AlternateText="Guardar cambios" BorderColor="Blue" OnClientClick="sheetInstance; return true;"
                        onclick="guardarArchivo" />-->
                    <asp:ImageButton ID="ImageButton1" runat="server" ToolTip="Exportar a excel"
                        ImageUrl="../librerias/img/excel.png" AlternateText="Exportar a excel" BorderColor="Blue" OnClientClick="bodyCP_tb_html.value = encodeURIComponent(sheetInstance.exportSheet.html()[0].outerHTML);"
                        onclick="guardarArchivo" />
                    <!--<a href="#" onclick="sheetInstance.s.fnSave(); return true;" title="Save Sheets">
				        <img alt="Save Sheet" src="librerias/img/disk.png"/></a>
			        <a href="#" onclick="sheetInstance.deleteSheet(); return false;" title="Eliminar Hoja Actual">
				        <img alt="Delete Current Sheet" src="../librerias/img/table_delete.png"/></a>
			        <a href="#" onclick="sheetInstance.calc(sheetInstance.i); return false;" title="Refrescar calculos">
				        <img alt="Refresh Calculations" src="../librerias/img/arrow_refresh.png"/></a>
			        <a href="#" onclick="sheetInstance.cellFind(); return false;" title="Buscar">
				        <img alt="Find" src="../librerias/img/find.png"/></a>
			        <a href="#" onclick="sheetInstance.cellStyleToggle('styleBold'); return false;" title="Bold">
				        <img alt="Bold" src="../librerias/img/text_bold.png"/></a>
			        <a href="#" onclick="sheetInstance.cellStyleToggle('styleItalics'); return false;" title="Italic">
				        <img alt="Italic" src="../librerias/img/text_italic.png"/></a>
			        <a href="#" onclick="sheetInstance.cellStyleToggle('styleUnderline', 'styleLineThrough'); return false;" title="Underline">
				        <img alt="Underline" src="../librerias/img/text_underline.png"/></a>
			        <a href="#" onclick="sheetInstance.cellStyleToggle('styleLineThrough', 'styleUnderline'); return false;" title="Strikethrough">
				        <img alt="Strikethrough" src="../librerias/img/text_strikethrough.png"/></a>
			        <a href="#" onclick="sheetInstance.cellStyleToggle('styleLeft', 'styleCenter styleRight'); return false;" title="Alinear Izquierda">
				        <img alt="Align Left" src="../librerias/img/text_align_left.png"/></a>
			        <a href="#" onclick="sheetInstance.cellStyleToggle('styleCenter', 'styleLeft styleRight'); return false;" title="Alinear Centro">
				        <img alt="Align Center" src="../librerias/img/text_align_center.png"/></a>
			        <a href="#" onclick="sheetInstance.cellStyleToggle('styleRight', 'styleLeft styleCenter'); return false;" title="Alinear derecha">
				        <img alt="Align Right" src="../librerias/img/text_align_right.png"/></a>
			        <a href="#" onclick="sheetInstance.fillUpOrDown(); return false;" title="Rellenar abajo">
				        <img alt="Fill Down" src="../librerias/img/arrow_down.png"/></a>
			        <a href="#" onclick="sheetInstance.fillUpOrDown(true); return false;" title="Rellenar arriba">
				        <img alt="Fill Up" src="../librerias/img/arrow_up.png"/></a>
			        <span class="colorPickers">
				        <input title="Foreground color" class="colorPickerFont" style="background-image: url('librerias/img/palette.png') ! important; width: 16px; height: 16px;"/>
				        <input title="Background Color" class="colorPickerCell" style="background-image: url('librerias/img/palette_bg.png') ! important; width: 16px; height: 16px;"/>
			        </span>
			        <a href="#" onclick="sheetInstance.obj.formula().val('=HYPERLINK(\'' + prompt('Enter Web Address', 'http://www.visop-dev.com/') + '\')').keydown(); return false;" title="HyperLink">
				        <img alt="Web Link" src="../librerias/img/page_link.png"/></a>-->
			        <a href="#" onclick="sheetInstance.toggleFullScreen(); $('#lockedMenu').toggle(); return false;" title="Pantalla Completa">
				        <img alt="Web Link" src="../librerias/img/arrow_out.png"/></a>
		        </span>
	        </span>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnProcesar" />
        </Triggers>
    </asp:UpdatePanel>
</div>
</asp:Content>