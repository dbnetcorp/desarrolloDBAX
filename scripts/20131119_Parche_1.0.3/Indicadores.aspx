<%@ page title="" language="C#" masterpagefile="~/dbnet.dbax/MasterPage.master" autoeventwireup="true" inherits="DragAndDrop, App_Web_indicadores.aspx.95992650" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../librerias/CSS/jquery.ui.all.css" rel="stylesheet" type="text/css" />
    <script src="../librerias/js/jquery1821/jquery-1.7.2.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery1821/ui/jquery.ui.core.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery1821/ui/jquery.ui.widget.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery1821/ui/jquery.ui.mouse.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery1821/ui/jquery.ui.draggable.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery1821/ui/jquery.ui.droppable.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery1821/ui/jquery.ui.sortable.js" type="text/javascript"></script>
    <script src="../librerias/js/jquery1821/ui/jquery.ui.accordion.js" type="text/javascript"></script>
    <link href="../librerias/CSS/demos.css" rel="stylesheet" type="text/css" />
    <script src="../librerias/js/DragAndDrop.js" type="text/javascript"></script>
    <style type="text/css">
	    h1  
	    {
	    	padding: .2em; 
	    	margin: 0; 
	    }
	    #products  
	    {
	    	float:left; 
	    	width: 500px; 
	    	height:300px; 
	    	margin-right: 2em; 
	    }
	    #bodyCP_cart  
	    {
	    	width: 500px; 
	    	float: left; 
	    }
	    /* style the list to maximize the droppable hitarea */
	    #bodyCP_cart ol  
	    {
	    	margin: 0; 
	    	padding: 1em 0 1em 3em; 
	    }
	    .style1
        {
            width: 31%;
        }
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    <div class="pageFw5">
    <asp:Label ID="Label10" runat="server" Text="Label" CssClass="dbnTitulo">Mantención indicador</asp:Label>
    <br /><br />
    <asp:UpdatePanel ID="UpdatePanel4" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
    <ContentTemplate>
    
    <asp:ImageButton ID="bt_Aceptar2" runat="server" Height="25px" 
        ImageUrl="../librerias/img/page_run.png" onclick="bt_Aceptar_Click" 
        Width="30px" />
    <asp:ImageButton ID="bt_Borrar" runat="server" Height="25px" 
        ImageUrl="../librerias/img/borrar.png" onclick="bt_Borrar_Click" 
        Width="30px" />
    <asp:ImageButton ID="bt_Volver" runat="server" Height="25px" OnClick="bt_Volver_Click"
        ImageUrl="../librerias/img/page_exit.png" CausesValidation="false" Width="30px" />

    <table style="width: 50%;" border = "0">
        <tr>
            <td style="width:30%;">
                <asp:Label ID="Label1" runat="server" Text="Label" CssClass="lblIzquierdo">Nombre</asp:Label>
            </td>
            <td>
                <asp:TextBox CssClass="dbnTextbox" ID="tb_NombForm" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                    ControlToValidate="tb_NombForm" Display="None" 
                    ErrorMessage="Debe ingresar el nombre de la fórmula."></asp:RequiredFieldValidator>
                <asp:ValidatorCalloutExtender ID="RequiredFieldValidator3_ValidatorCalloutExtender" 
                    runat="server" Enabled="True" TargetControlID="RequiredFieldValidator3">
                </asp:ValidatorCalloutExtender>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                    ControlToValidate="tb_NombForm" ErrorMessage="El nombre puede contener solo letras y/o números." 
                    ValidationExpression="^[a-zA-Z0-9]+?$" Font-Strikeout="False" Visible="True" Display="None"></asp:RegularExpressionValidator>
                <asp:ValidatorCalloutExtender ID="RegularExpressionValidator1_ValidatorCalloutExtender" 
                    runat="server" Enabled="True" TargetControlID="RegularExpressionValidator1">
                </asp:ValidatorCalloutExtender>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label3" runat="server" CssClass="lblIzquierdo">Descripción</asp:Label>
            </td>
            <td>
                <asp:TextBox CssClass="dbnTextbox" ID="tb_Descripcion" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td >
                <asp:Label ID="Label9" runat="server" 
                    CssClass="lblIzquierdo">Tipo Compañía</asp:Label>
            </td>
            <td>
                <asp:DropDownList CssClass="dbnListaValor" ID="ddl_TipoTaxonomia" runat="server" AutoPostBack="true" 
                    onselectedindexchanged="ddl_TipoTaxonomia_SelectedIndexChanged">
                </asp:DropDownList>
            </td>
        </tr>

        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Label" CssClass="lblIzquierdo">Tipo Indicador</asp:Label>
            </td>
            <td>
                <asp:DropDownList CssClass="dbnListaValor" ID="ddl_TipoIndi" runat="server"></asp:DropDownList>
            </td>
        </tr>
        
        <tr>
            <td>
                <asp:Label ID="Label4" runat="server" CssClass="lblIzquierdo">Fórmula</asp:Label>
            </td>
            <td>
                <asp:TextBox  CssClass="dbnTextbox" ID="tb_FormDefi" runat="server" AutoPostBack="True" 
                    ontextchanged="tb_FormDefi_TextChanged"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ErrorMessage="Debe ingresar la fórmula que define el validador" 
                    ControlToValidate="tb_FormDefi" Display="None"></asp:RequiredFieldValidator>
                <asp:ValidatorCalloutExtender ID="RequiredFieldValidator2_ValidatorCalloutExtender" 
                    runat="server" Enabled="True" TargetControlID="RequiredFieldValidator2">
                </asp:ValidatorCalloutExtender>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label5" runat="server" CssClass="lblIzquierdo">Aplica a holding</asp:Label>
            </td>
            <td align = "left">
                <asp:CheckBox ID="cb_ApliHold" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
               <asp:Label ID="Label6" runat="server" CssClass="lblIzquierdo">Visible en reporte</asp:Label>
            </td>
            <td align="left">
                <asp:CheckBox ID="cb_VisoRepo" runat="server" Checked="True" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label  ID="lb_RefeMini" runat="server" CssClass="lblIzquierdo">Valor de referencia mínimo</asp:Label>
            </td>
            <td align="left">
                <asp:TextBox  CssClass="dbnTextbox" ID="tb_RefeMini" runat="server" AutoPostBack="True"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                 <asp:Label  ID="lb_RefeMaxi" runat="server" CssClass="lblIzquierdo">Valor de referencia máximo</asp:Label>
            </td>
            <td align="left">
                 <asp:TextBox  CssClass="dbnTextbox" ID="tb_RefeMaxi" runat="server" AutoPostBack="True"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Label CssClass="lblError" ID="lb_error" runat="server" Text="Label"/>
            </td>
        </tr>
    </table>

    <asp:ImageButton ID="Validar" runat="server" onclick="AnalizaFormula" 
        ImageUrl="../librerias/img/bt_validar.png" style="visibility:hidden; height:0px; width:0px;" />
    <asp:TextBox CssClass="dbnTextbox" ID="tb_Resultados" runat="server" style="visibility:hidden; height:15px; width:1000px;"></asp:TextBox>
    <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <label class="TextosNegritas">Interpretación de fórmula</label>
            <div id="divVariables" runat="server" style="border-radius: 5px; background-color: #CCCCCC; padding: 0px 0px 3px 10px;"></div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="tb_FormDefi" EventName="TextChanged" />
        </Triggers>
    </asp:UpdatePanel>
    
    <br />
    <hr />
    
    <div class="product-head">
        <p style="font-family:Arial; font-size:x-small; font-style:italic; border:0; border-style:dashed; border-color:Red;">
        Seleccione un concepto y arrástrelo a la variable correspondiente.
        <br />
        Puede filtrar los resultados escribiendo todo o parte del conceptos que esté buscando.
        </p>
    </div>
    
    <table style="width: 50%;" border="0">
        <tr>
            <td class="style1">
                <asp:Label ID="Label12" runat="server" CssClass="lblIzquierdo">Formato</asp:Label>
                </td>
            <td>
                <asp:DropDownList ID="ddl_VersTaxo" runat="server" CssClass="dbnListaValor" AutoPostBack="True"
                    OnSelectedIndexChanged="ddl_VersTaxo_SelectedIndexChanged">
                </asp:DropDownList>
            </td>
        </tr>
        <!--<tr>
            <td class="style1">
                <asp:Label ID="Label13" runat="server" CssClass="lblIzquierdo">Prefijo</asp:Label>
            </td>
            <td>
                <asp:DropDownList ID="ddl_PrefConc" runat="server" CssClass="dbnListaValor">
                </asp:DropDownList>
            </td>
        </tr>-->
        <tr>
            <td class="style1">
                <div ID="divPrefConc" runat="server">
                    <label class="lblIzquierdo">
                    Filtro</label>
                    <%--    <asp:DropDownList CssClass="dbnListaValor" ID="ddl_PrefConc" AutoPostBack="true" runat="server" 
                        onselectedindexchanged="ddl_PrefConc_SelectedIndexChanged" Height="22px" 
                        Width="78px">
                    </asp:DropDownList>--%>
                </div>
            </td>
            <td>
                <asp:TextBox ID="tb_filtroConcepto" runat="server" AutoPostBack="true" 
                    CssClass="dbnTextbox" ontextchanged="tb_filtroConcepto_TextChanged" Width="400"></asp:TextBox>
                <asp:AutoCompleteExtender ID="tb_filtroConcepto_AutoCompleteExtender" 
                    runat="server" CompletionInterval="500" 
                    CompletionListElementID="autocompleteDropDownPanel" CompletionSetCount="10" 
                    DelimiterCharacters=";" Enabled="True" ServiceMethod="GetCompletionList" 
                    ServicePath="" TargetControlID="tb_filtroConcepto" UseContextKey="True">
                </asp:AutoCompleteExtender>
                <asp:Panel ID="autocompleteDropDownPanel" runat="server" CssClass="dbnLabel" 
                    Height="100px" ScrollBars="Vertical" />
            </td>
        </tr>
    </table>
    </ContentTemplate>
    </asp:UpdatePanel>
    
    <br />  
    <div id="products">
	    <h1 class="ui-widget-header">Conceptos</h1>	
        <div id="catalog">
		    <h3><a href="#">Conceptos</a></h3>
		    <panel>
                <div id="form"></div>
                <div class="clear"></div>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div style="height:150px"><ul id="listaConceptos" runat="server">
			                </ul>
		                </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="tb_filtroConcepto" 
                            EventName="TextChanged" />
                        <%--<asp:AsyncPostBackTrigger ControlID="ddl_PrefConc" 
                            EventName="SelectedIndexChanged" />--%>
                        <asp:AsyncPostBackTrigger ControlID="ddl_TipoTaxonomia" 
                            EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
            </panel>
		    <h3><a href="#">Indicadores/Ratios</a></h3>
		    <div>
			    <ul id="listaIndicadores" runat="server">
			    </ul>
		    </div>
	    </div>
    </div>
            
    <!-- Variables -->
    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <panel id="PanelgrupoDestinos" >
                <div id="cart" runat="server" style="width: 470px;">
                </div>
            </panel>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="tb_FormDefi" EventName="TextChanged" />
        </Triggers>
    </asp:UpdatePanel>
 
    <div id="divResultado">
    </div>
    <br />
    <br />
    </div>
</asp:Content>