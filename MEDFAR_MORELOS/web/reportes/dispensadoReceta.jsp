<%@page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" import="java.text.*" import="java.lang.*" import="java.util.*" import= "javax.swing.*" import="java.io.*" import="java.text.DateFormat" import="java.text.ParseException" import="java.text.SimpleDateFormat" import="java.util.Calendar" import="java.util.Date"  import="java.text.NumberFormat" import="java.util.Locale" errorPage="" %>

<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%
    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatterDecimal = new DecimalFormat("#,###,##0.00");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator('.');
    custom.setGroupingSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    formatterDecimal.setDecimalFormatSymbols(custom);
// Conexion BDD via JDBC
    HttpSession sesion = request.getSession();
    Class.forName("org.gjt.mm.mysql.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://192.168.0.180/scr_morelos", "root", "eve9397");
    Statement stmt = con.createStatement();
    ResultSet rset = null;
// fin conexion --------

    String f1 = "2015-01-01";
    String f2 = "2016-01-01";

    try {
        String but = request.getParameter("submit");
        f1 = request.getParameter("txtf_caduc");
        f2 = request.getParameter("txtf_caduci");
        if (but.equals("Por Fechas")) {
            f1 = df2.format(df.parse(request.getParameter("txtf_caduc")));
            f2 = df2.format(df.parse(request.getParameter("txtf_caduci")));

        }
    } catch (Exception e) {
    }
    int total = 0;
    int totalCajas = 0;

    String id_usu = "";
    String cla_uni = "", des_uni = "";
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }
    try {
        rset = stmt.executeQuery("select un.des_uni, us.cla_uni from usuarios us, unidades un where us.cla_uni = un.cla_uni and id_usu = '" + id_usu + "' ");
        while (rset.next()) {
            cla_uni = rset.getString("cla_uni");
            des_uni = rset.getString("des_uni");

        }
    } catch (Exception e) {

    }
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>.:CONSUMO PROMEDIO:.</title>

        <script src="scw.js" type="text/javascript"></script>
        <script language="javascript" src="list02.js">
            function close1()
            {//alert("huge");
                top.close();
                /*if(navigator.appName=="Microsoft Internet Explorer") { 
                 this.focus();self.opener = this;self.close(); } 
                 else { window.open('','_parent',''); window.close(); } 
                 
                 */
            }

            function foco_inicial() {
                if (document.form.txtf_clave2.value == "") {
                    document.form.txtf_clave.focus();
                }
                else
                {
                    document.form.txtf_cant.focus();
                }
            }
        </script>
        <link rel="stylesheet" href="mm_restaurant1.css" type="text/css" />
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen"/>
        <link href="../css/topPadding.css" rel="stylesheet"/>
        <link href="../css/datepicker3.css" rel="stylesheet"/>
    </head>

    <body class="container">
        <%@include file="../jspf/mainMenu.jspf"%>
        <br />
        <form id="form" name="form" method="post" action="dispensadoReceta.jsp?cla_uni=<%=request.getParameter("cla_uni")%>">

            <table border="0" class="table">
                <tr>
                    <td height="90" bgcolor="#FFFFFF" class="logo style1">
                        <div align="center" class="logo style1">
                            <img ssrc=../imagenes/medalfaLogo.png" width="100" heigth="100"/>
                        </div>
                    </td>
                    <td height="90" bgcolor="#FFFFFF" class="logo style1" colspan="2">
                        <div align="center"><h2>Dispensado por Clave Receta Farmacia</h2></div>
                    </td>
                    <td height="90" bgcolor="#FFFFFF" class="logo style1"><img src="../imagenes/medalfaLogo.png" width="100"/></td>
                </tr>
                <tr>
                    <td height="14" colspan="4"><span class="style2"></span></td>
                </tr>
                <tr>
                    <td height="50">
                        <div align="right"></div></td>
                    <td colspan="2">
                        <label>Rango de fechas del:&nbsp;&nbsp;
                            <input class="form-control" name="txtf_caduc" type="text" id="datepicker" data-date-format="yyyy/mm/dd" size="10" readonly title="aaaa/mm/dd"/>
                        </label>                  &nbsp;&nbsp;&nbsp;&nbsp;
                        <label> al:&nbsp;&nbsp;
                            <input class="form-control" name="txtf_caduci" type="text" id="datepicker1" data-date-format="yyyy/mm/dd" size="10" readonly title="aaaa/mm/dd"/>
                        </label>
                        <input type="submit" class="btn-primary btn-sm" name="submit" value="Buscar"/>

                    </td>
                    <td>
                        <div align="center">
                            <a href="repor_dispensado.jsp?txtf_caduc=<%=f1%>&txtf_caduci=<%=f2%>&cla_uni=<%=cla_uni%>"><img src="../imagenes/exc.jpg" width="37" height="29" border="0" alt="Exportar a Excel" />
                            </a></div>
                    </td>
                </tr>
                <tr>
                    <td height="33">		  
                    </td>
                    <td colspan="2"><%if (f1 != null) {%>
                        <div align="center" class="Estilo8">Rango 
                            <%=f1%>
                            del al 
                            <%=f2%>
                        </div>
                        <%}%>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td height="20"><div align="center">CLAVE*</div></td>
                    <td class="bodyText"><div align="center">DESCRIPCI&Oacute;N</div></td>
                    <td><div align="center">Tab/Amp</div></td>
                    <td><div align="center">Cajas</div></td>
                </tr>
                <%
                    rset = stmt.executeQuery("SELECT p.cla_pro, p.des_pro, sum(dr.cant_sur) as cant,((sum(dr.cant_sur))/p.amp_pro) as cajas FROM productos p, detalle_productos dp, detreceta dr, receta r, usuarios u, unidades un where r.id_tip = '1' and p.cla_pro = dp.cla_pro AND dp.det_pro = dr.det_pro AND dr.id_rec = r.id_rec AND r.id_usu = u.id_usu AND u.cla_uni = un.cla_uni AND r.fecha_hora  BETWEEN '" + f1 + " 00:00:01' and '" + f2 + " 23:59:59' and dr.baja!=1 and dr.cant_sur!=0 and un.cla_uni = '" + cla_uni + "' GROUP BY p.cla_pro, dr.baja  ORDER BY dp.cla_pro+0 ASC ;");
                    while (rset.next()) {

                %>
                <tr>
                    <td width="142" height="20"><div align="center"><%=rset.getString("cla_pro")%></div></td>
                    <td width="470" class="bodyText"><%=rset.getString("des_pro")%></td>
                    <td width="143"><div align="center"><%=formatter.format(rset.getDouble("cant"))%></div></td>
                    <td width="143"><div align="center"><%=formatter.format(rset.getDouble("cajas"))%></div></td>
                </tr>
                <%
                        total = total + Integer.parseInt(rset.getString("cant"));
                        totalCajas = totalCajas + rset.getInt("cajas");
                    }
                %>
                <tr>
                    <td width="142" height="20"><div align="center"></div></td>
                    <td width="470" class="bodyText"><div align="right">Total</div></td>
                    <td width="143"><div align="center"><%=formatter.format(total)%></div></td>
                    <td width="143"><div align="center"><%=formatter.format(totalCajas)%></div></td>
                </tr>
            </table>
            <div align="center"></div>
        </form>
        <%  //----- CIERRE DE LAS CONEXIONES  ------
            con.close();
            //---FIN -----         
%>
        <link rel="stylesheet" href="themes/base/jquery.ui.all.css" />
        <script src="jquery-1.9.0.js"></script>
        <script src="ui/jquery.ui.core.js"></script>
        <script src="ui/jquery.ui.widget.js"></script>
        <script src="ui/i18n/jquery.ui.datepicker-es.js"></script>
        <script src="ui/jquery.ui.datepicker.js"></script>
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui.js"></script>
        <script src="../js/bootstrap-datepicker.js"></script>
        <script>
            $("#datepicker").datepicker({minDate: 0});
            $("#datepicker1").datepicker({minDate: 0});

        </script>
    </body>
</html>
