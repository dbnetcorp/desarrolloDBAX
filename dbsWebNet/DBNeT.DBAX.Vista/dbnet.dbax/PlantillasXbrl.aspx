<%@ Page Title="" Language="C#" MasterPageFile="~/dbnet.dbax/MasterPage.master"  AutoEventWireup="true" CodeFile="PlantillasXbrl.aspx.cs" Inherits="PlantillasXbrl" MaintainScrollPositionOnPostback="true" EnableEventValidation="false"  %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <meta http-equiv="CACHE-CONTROL" content="NO-CACHE"/>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodyCP" Runat="Server">
    <div class="pageFw5">
    <div id="botones3" style="visibility:visible;" class="div3Botones">
    <div class="divTitulo"><asp:Label ID="lblTitulo" runat="server" CssClass="dbnTitulo"/></div>
    <div class="divBotones">
        <asp:ImageButton ID="bt_Aceptar2" runat="server" Height="25px" 
            ImageUrl="~/librerias/img/page_run.png" Width="30px" 
            onclick="bt_Aceptar2_Click" />
        <asp:ImageButton ID="bt_Borrar" runat="server" Height="25px" 
            ImageUrl="~/librerias/img/borrar.png" Width="30px" 
            onclick="delInfoDefi" />
        <asp:ImageButton ID="bt_Volver" runat="server" Height="25px" 
            ImageUrl="~/librerias/img/botones/page_exit.png" Width="30px" CausesValidation="false" onclick="bt_Volver_Click" />
        </div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
        <ContentTemplate>
            <table class="Selectores">
            <tr>
                <td style="width:200px;" >
                    <asp:Label CssClass="lblIzquierdo" ID="Label15" runat="server" Text="Informe"/>
                </td>
                <td style="width:700px;" >
                    <asp:TextBox CssClass="dbnTextbox" ID="tb_DescInfo" runat="server" Width="347px" 
                        ontextchanged="tb_DescInfo_TextChanged" AutoPostBack="True"></asp:TextBox>
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator1" runat="server" ControlToValidate="tb_DescInfo" ErrorMessage="Ingrese un nombre"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td style="width:200px;" >
                    <asp:Label CssClass="lblIzquierdo" ID="Label4" runat="server" Text="Código"/>
                </td>
                <td style="width:700px;" >
                    <asp:TextBox CssClass="dbnTextbox" ID="tb_CodiInfo" runat="server" Width="347px"></asp:TextBox>
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator3" runat="server" ControlToValidate="tb_DescInfo" ErrorMessage="Ingrese un nombre"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td style="width:200px;" >
                    <asp:Label CssClass="lblIzquierdo" ID="Label5" runat="server" Text="Código corto"/>
                </td>
                <td style="width:700px;" >
                    <asp:TextBox CssClass="dbnTextbox" ID="tb_CodiCort" runat="server" Width="347px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td >
                    <asp:Label ID="Label9" runat="server" Text="Tipo" 
                        CssClass="lblIzquierdo"/>
                </td>
                <td>
                    <asp:DropDownList CssClass="dbnListaValor" ID="ddl_TipoTaxonomia" runat="server" AutoPostBack="true" 
                            Width="353px" onselectedindexchanged="ddl_TipoTaxonomia_SelectedIndexChanged">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator CssClass="lblError" ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddl_TipoTaxonomia" InitialValue="" ErrorMessage="Seleccione un Tipo de Taxonomía"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:RadioButtonList ID="rb_ConcIndi" runat="server" CssClass="lblIzquierdo" AutoPostBack="true"
                        onselectedindexchanged="rb_ConcIndi_SelectedIndexChanged" 
                        RepeatDirection="Horizontal">
                        <asp:ListItem Value="C" Selected="True">Conceptos</asp:ListItem>
                        <asp:ListItem Value="I">Indicadores</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>
            <tr>
                <td >
                    <asp:Label ID="Label19" runat="server" Text="Filtro de conceptos" 
                        CssClass="lblIzquierdo"/>
                </td>
                <td class="style2" >
                    <asp:TextBox CssClass="dbnTextbox" ID="tb_filtroConcepto" runat="server" 
                            ontextchanged="tb_filtroConcepto_TextChanged" AutoPostBack="true" Width="347px" ></asp:TextBox>
                    <asp:AutoCompleteExtender 
                        runat="server"
                        ID="tb_filtroConcepto_AutoCompleteExtender"
                        Enabled="True"
                        ServiceMethod="GetCompletionList"
                        ServicePath=""
                        TargetControlID="tb_filtroConcepto"
                        UseContextKey="True"
                        CompletionInterval="500"
                        CompletionSetCount="10"
                        CompletionListElementID="autocompleteDropDownPanel"
                        DelimiterCharacters=";" >
                    </asp:AutoCompleteExtender>
                    <asp:Panel ID="autocompleteDropDownPanel" runat="server" CssClass="dbnLabel"
                                ScrollBars="Vertical" Height="500px" Width="200px" />
                </td>
            </tr>
            <%--<tr>
                <td >
                    &nbsp;</td>
                <td class="style2" >
                    <asp:DropDownList CssClass="dbnListaValor" ID="ddl_PrefConc" runat="server" AutoPostBack="true" 
                            onselectedindexchanged="ddl_PrefConc_SelectedIndexChanged" 
                        Width="353px"  ></asp:DropDownList>
                </td>
            </tr>--%>
            <tr>
                <td>
                    <asp:Label ID="Label16" runat="server" CssClass="lblIzquierdo" 
                        Text="Conceptos"/>
                </td>
                <td class="style2">
                    <asp:DropDownList CssClass="dbnListaValor" ID="cb_conceptos" runat="server" Width="353px" AutoPostBack="true">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td >
                <asp:Label ID="Label17" runat="server" Text="Orden conceptos" 
                        CssClass="lblIzquierdo"/>
                </td>
                <td class="style2" >
                    <asp:TextBox CssClass="dbnTextbox" ID="tb_orden" runat="server" Width="90px"></asp:TextBox>
                        <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" 
                        FilterMode="ValidChars" FilterType="Numbers" 
                    TargetControlID="tb_orden" ValidChars="0123456789"></asp:FilteredTextBoxExtender>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label18" runat="server" Text="Nivel Conceptos" 
                        CssClass="lblIzquierdo"/>
                </td>
                <td class="style2">
                    <asp:DropDownList CssClass="dbnListaValor" ID="cb_nivel" runat="server" Width="95px">
                        <asp:ListItem>1</asp:ListItem>
                        <asp:ListItem>2</asp:ListItem>
                        <asp:ListItem>3</asp:ListItem>
                        <asp:ListItem>4</asp:ListItem>
                    </asp:DropDownList>
                    <asp:ImageButton ID="agregar" runat="server" ImageUrl="~/librerias/img/agregar.png"
                        onclick="agregar_Click" Height="20px" Width="20px" ToolTip="Agregar concepto a informe" style="vertical-align:middle"/>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label20" runat="server" CssClass="lblIzquierdo" 
                        Text="Informe vigente" />
                </td>
                <td class="style2" >
                    <asp:CheckBox ID="chk_InfoVige" runat="server" CssClass="dbnTextbox" 
                        Checked="True" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label6" runat="server" CssClass="lblIzquierdo" 
                        Text="Transponer por defecto" />
                </td>
                <td class="style2" >
                    <asp:CheckBox ID="chk_InfoTran" runat="server" CssClass="dbnTextbox" 
                        Checked="False" />
                </td>
            </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label21" runat="server" CssClass="lblIzquierdo" 
                            Text="Copiar reporte" />
                    </td>
                    <td class="style2">
                        <asp:ImageButton ID="Procesar" runat="server" height="26px" 
                            ImageUrl="~/librerias/img/bt_copiar.png" onclick="Procesar_Click" 
                            OnClientClick="return confirm('Se creará una copia del informe actual ¿Está seguro?');" 
                            width="60px" />
                    </td>
                </tr>
        </table>
        <h2 id="structures">
        <asp:Label ID="lb_error" runat="server" Text="Label" CssClass="Error"/>
        </h2>
          <asp:GridView ID="Grilla_informe" runat="server" AutoGenerateColumns="False" 
                CellPadding="4" Width="662px"  GridLines="None" 
                onrowdeleting="Grilla_Informe_RowDeleting" 
                onrowcancelingedit="Grilla_Informe_RowCancelingEdit" 
                onrowediting="Grilla_Informe_RowEditing" 
                onrowupdating="Grilla_Informe_RowUpdating"
                OnRowCreated="RowCreated">
                <AlternatingRowStyle CssClass="AlternatingRow"/>
                <HeaderStyle CssClass="headerGrilla"/>
                <Columns>
                    <asp:CommandField ButtonType="Image" DeleteImageUrl="~/librerias/img/borrar_chico.png" 
                        ShowDeleteButton="True" >
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="15px" />
                    </asp:CommandField>
                    <asp:TemplateField HeaderText="PrefConc">
                        <ItemTemplate>
                            <asp:Label ID="lbPrefConc" runat="server" text='<%# Bind("pref_conc") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="CodiConc">
                        <ItemTemplate>
                            <asp:Label ID="lbCodiConc" runat="server" text='<%# Bind("codi_conc") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Orden">
                        <ItemTemplate>
                            <asp:Label ID="lbOrdeConc" runat="server" text='<%# Bind("orde_conc") %>'/>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox4" runat="server" text='<%# Bind("orde_conc") %>' Width="90px"></asp:TextBox>
                                <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" 
                                FilterMode="ValidChars" FilterType="Numbers" 
                                TargetControlID="TextBox4" ValidChars="0123456789"></asp:FilteredTextBoxExtender>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Descripción cuenta">
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" text='<%# Bind("desc_conc") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Indicador" ShowHeader="False">
                        <ItemTemplate>
                            <asp:ImageButton ID="Idicador" runat="server" CausesValidation="False" 
                                CommandName="Select" ImageUrl='<%# Bind("imagen") %>' 
                                Text="Select" BorderStyle="None" />
                        </ItemTemplate>
                        <HeaderStyle Height="10px" Width="10px" />
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Nivel">
                        <ItemTemplate>
                            <asp:Label ID="Label3" runat="server" text='<%# Bind("nive_conc") %>'/>
                        </ItemTemplate>
                    <EditItemTemplate>
                            <asp:TextBox ID="TextBox2" runat="server" text='<%# Bind("nive_conc") %>' Width="90px"></asp:TextBox>
                                <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" 
                                    FilterMode="ValidChars" FilterType="Numbers" 
                                    TargetControlID="TextBox2" ValidChars="0123456789"></asp:FilteredTextBoxExtender>
                        </EditItemTemplate> 
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Negrita">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="negrita" runat="server" Enabled ="false" Checked='<%# Eval("negr_conc") %>'/>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:CheckBox ID="negrita" runat="server"/>
                                    </EditItemTemplate>      
                                    <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Concepto" Visible="False">
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("codi_conc") %>'/>
                        </ItemTemplate>
                            <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("codi_conc") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:CommandField ButtonType="Image"
                        UpdateImageUrl="~/librerias/img/imgAct.png"
                        CancelImageUrl="~/librerias/img/imgCan.png" 
                        EditImageUrl="~/librerias/img/edit.png" HeaderText="Edición" 
                        ShowEditButton="True">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:CommandField>

                </Columns>
                <EditRowStyle CssClass="GrillaTextosEditar" />
                <FooterStyle BackColor="#5D7B9D" CssClass="dbnGrilla" Font-Bold="True" 
                    ForeColor="White" />
                <PagerStyle BackColor="#CCCCCC" ForeColor="White" HorizontalAlign="Center" />
                <RowStyle CssClass="RowStyle" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            </asp:GridView>
            <br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br>
            <br></br>
            <br></br>
            <br></br>
            <br></br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
            </br>
        </ContentTemplate>
         <Triggers>
             <asp:AsyncPostBackTrigger ControlID="agregar" EventName="Click" />
         </Triggers>
    </asp:UpdatePanel>
    </div>
</asp:Content>