<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Website_Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Prototipo DBAX</title>
    <link href="../librerias/CSS/DBAX.css" rel="stylesheet" type="text/css" />
</head>
<body scroll="no" style="margin:0 auto; width:800px;">
		<form id="dbnForm" method="post" runat="server">
		<i><font face="Arial" color="#800080" size="2">
					
		<table width="800" cellpadding="0" cellspacing="0" border="0" align="center">
			
		    <tr>
		        <td Height="136px">  <asp:image id="Encabezado" 
                    runat="server"
				Height="136px" Width="800px" ImageUrl= "../librerias/img/pf_inicio.jpg" EnableViewState="False">
                </asp:image></td>
		   </tr>
		   <tr>
		   <td>&nbsp;
		   </td>
		   </tr>
		   <tr>
		   <td style="padding:20px 0px 20px 0px;" align="center">
		       <div>
		       <table style="width:400px; height:270px" cellpadding="0" cellspacing="0" border="0">
		       <tr>		     
		       	<td style="background-image: url('librerias/img/CuadroRedondo/1.png'); background-repeat:no-repeat;width: 16px; height:16px; " 
                       ></td>
		        <td style="background-image: url('librerias/img/CuadroRedondo/HoriSup.png'); background-repeat: repeat-x; " 
                       ></td>
		       <td style="background-image: url('librerias/img/CuadroRedondo/2.png'); background-repeat:no-repeat;width: 16px; height:16px; " 
                       ></td>
		       </tr>
		       <tr>
		      	<td style="background-image: url('librerias/img/CuadroRedondo/vertIzq.png'); background-repeat: repeat-y;"></td>
		       <td>
		           <table  width="360px" cellpadding="0" cellspacing="0" border="0" align="center">
		           
		           <tr>
		           <td width="100px">&nbsp;</td>
    		
		           <td> &nbsp;</td>
    		
		           </tr>
		           <tr>
		           <td width="100px"></td>
    		
		           <td> </td>
    		
		           </tr>
		           <tr>
		           <td width="60px"></td>
    		
		           <td> 
                       <asp:label id="lbCodi_usua"
				    runat="server" Design_Time_Lock="True" BackColor="Transparent" 
                    BorderColor="Transparent" CssClass="lblIzquierdo" Width="123px" 
                           Font-Names="Trebuchet MS" Font-Size="XX-Small">Usuario</asp:label>
                           <asp:label ID="lbPass_usua0" runat="server" BackColor="Transparent" BorderColor="Transparent"
                    CssClass="lblIzquierdo" Visible="False" Width="123px" Font-Names="Trebuchet MS" 
                           Font-Size="XX-Small">Clave actual</asp:label></td>
    		
		           </tr>
		           <tr>
		           <td>&nbsp;</td>
		           <td><asp:textbox id="tb_usuario" runat= "server" Width="150px" CssClass="dbnTextBox" Height="19px" Design_Time_Lock="True"></asp:textbox>
				    <asp:TextBox ID="tb_clave0" runat="server" CssClass="dbnTextBox" 
                    Height="19px" 
                   TextMode="Password" Visible="False" Width="150px" Wrap="False"></asp:TextBox></td>
		           </tr>
		           <tr>
		           <td>&nbsp;</td>
		           <td><asp:label id="lbPass_usua"
				    runat="server" Design_Time_Lock="True" BackColor="Transparent" BorderColor="Transparent" 
                           CssClass="lblIzquierdo" Width="123px" Font-Names="Trebuchet MS" 
                           Font-Size="XX-Small">Clave</asp:label></td>
		           </tr>
		           <tr>
		           <td>&nbsp;</td>
		           <td><asp:textbox id="tb_clave" style="POSITION: relative;height:19px"
				    runat="server" Width="150px"  CssClass="dbnTextBox"
                           TextMode="Password" Wrap="False"></asp:textbox></td>
		           </tr>
		           <tr>
		           <td>&nbsp;</td>
		           <td><asp:label ID="lbPass_usua2" runat="server" BackColor="Transparent" BorderColor="Transparent"
                    CssClass="lblIzquierdo" Visible="False" Font-Names="Trebuchet MS" 
                           Font-Size="XX-Small">Confirme nueva clave</asp:label></td>
		           </tr>
		           <tr>
		           <td ></td>
		           <td ><asp:imagebutton id="bt_conectar" 
			     runat="server" 
                Design_Time_Lock="True" ImageUrl="../librerias/img/bt_conectar.png" 
                           onclick="bt_conectar_Click"></asp:imagebutton><asp:TextBox ID="tb_clave2" runat="server" CssClass="dbnTextBox" Design_Time_Lock="True" 
                TextMode="Password" Visible="False" Width="150px"  Height="19px" Wrap="False"></asp:TextBox></td>
		           </tr>
		           <tr>
		           <td>&nbsp;</td>
		           <td>
                       <br />
                <asp:imagebutton id="bt_CambiaClave" 
		       runat="server" Design_Time_Lock="True" ImageUrl="../librerias/img/bt_actualizar.png" 
                Visible="False"></asp:imagebutton>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:LinkButton ID="txtConfiguracion" runat="server" 
                     Font-Names="Trebuchet MS" Font-Size="X-Small" Visible="False">Configuración</asp:LinkButton></td>
		           </tr>
		           <tr>
		           <td colspan="2" align="center">
                       <asp:label id="lb_aviso" style="POSITION: relative"
				    runat="server" Width="360px" CssClass="Error" Font-Names="Trebuchet MS" 
                           Font-Size="X-Small"></asp:label></td>
		           </tr>
		           </table>
		           	<td style="background-image: url('librerias/img/CuadroRedondo/vertDer.png'); background-repeat: repeat-y;"></td>
		            </td>
		       </tr>
		     <tr>
		       <td style="background-image: url('librerias/img/CuadroRedondo/3.png'); background-repeat:no-repeat; width: 16px; height:16px;"></td>
			<td style="background-image: url('librerias/img/CuadroRedondo/HoriInf.png'); background-repeat: repeat-x; width: 100px;"></td>
			<td style="background-image: url('librerias/img/CuadroRedondo/4.png'); background-repeat:no-repeat; width: 16px; height:16px;"></td>

		       </tr>
		       </table>
		          
		           </div>
		   </td></tr>
		
		    </table>
           </font></i>

            </form>
	</body>
</html>
