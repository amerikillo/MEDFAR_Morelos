<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss"); %>
<%
//  Conexi�n a la BDD -------------------------------------------------------------
    Class.forName("org.gjt.mm.mysql.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost/scr_morelos", "root", "eve9397");
    Statement stmt = con.createStatement();
    ResultSet rset = null;
    Statement stmt2 = con.createStatement();
    ResultSet rset2 = null;
// fin objetos de conexi�n ------------------------------------------------------
    int ban = 0;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    <!-- DW6 -->
    <head>
        <script language="javascript" src="list02.js"></script>
        <!-- Copyright 2005 Macromedia, Inc. All rights reserved. -->
        <title>:: REPORTE ::</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen"/>
        <link href="../css/topPadding.css" rel="stylesheet"/>
        <link href="../css/datepicker3.css" rel="stylesheet"/>
        <link href="../css/dataTables.bootstrap.css" rel="stylesheet"/>
        <script language="JavaScript" type="text/javascript">
        //--------------- LOCALIZEABLE GLOBALS ---------------
            var d = new Date();
            var monthname = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
        //Ensure correct for language. English is "January 1, 2004"
            var TODAY = monthname[d.getMonth()] + " " + d.getDate() + ", " + d.getFullYear();
        //---------------   END LOCALIZEABLE   ---------------

        //<script language="javascript" src="list02.js"></script>
        <style type="text/css">
            <!--
            .style1 {
                color: #000000;
                font-weight: bold;
            }
            .style33 {font-size: x-small}
            .style40 {font-size: 9px}
            .style41 {font-size: 9}
            .style42 {font-family: Arial, Helvetica, sans-serif}
            .Estilo8 {font-size: x-small; font-family: Arial, Helvetica, sans-serif; }
            .style43 {
                font-size: x-small;
                color: #FFFFFF;
                font-weight: bold;
            }
            .style47 {font-size: x-small; font-weight: bold; }
            .Estilo5 {font-size: x-small; font-family: Arial, Helvetica, sans-serif; font-weight: bold; }
            .style50 {color: #000000}
            .style51 {color: #BA236A}
            .style58 {font-size: x-small; font-weight: bold; color: #666666; }
            .style66 {font-size: x-small; font-weight: bold; color: #333333; }
            a:hover {
                color: #333333;
            }
            .style68 {color: #CCCCCC}
            .style75 {color: #333333; }
            a:link {
                color: #711321;
            }
            .style76 {color: #003366}
            .style77 {
                color: #711321;
                font-weight: bold;
            }
            .Estilo1 {color: #FFFFFF}
            .Estilo5 {font-family: Arial, Helvetica, sans-serif; font-size: medium;}
            .Estilo5 {font-size: large; font-family: Arial, Helvetica, sans-serif; }
            .Estilo8 {font-family: Arial, Helvetica, sans-serif; font-size: 18px;}
            .Estilo8 {font-family: Arial, Helvetica, sans-serif; font-size: 16px; }
            -->
        </style>
    </head>
    <body bgcolor="#ffffff" onload="fillCategory2()">
        <p>&nbsp;</p>
        <table width="1021" border="0" align="center" cellpadding="2">
            <tr>
                <td width="105"><img src="../imagenes/medalfaLogo.png" width="90" alt="Logo" /></td>
                <td height="63" colspan="2" align="center" valign="bottom" nowrap="nowrap" bgcolor="#FFFFFF" id="logo"><div align="center">
                        <span class="Estilo8">GOBIERNO DEL ESTADO DE M&Eacute;XICO<br />
                            SECRETARIA DE SALUD</br>
                            MEDALFA S.A. DE C.V.<br />
                            REPORTE DETALLADO DE CONSUMO POR RECETA COLECTIVA<br />
                            DE LA UNIDAD: <br />
                            <%try {
                                    rset = stmt.executeQuery("select des_uni from unidades where cla_uni = '" + request.getParameter("cla_uni") + "'");
                                    while (rset.next()) {
                                        out.println(rset.getString(1));
                                    }
                                } catch (Exception ex) {
                                    System.out.print(ex.getMessage());
                                }
                            %>
                            <br />
                            PERIODO: <%=request.getParameter("f1")%> al <%=request.getParameter("f2")%></span><br />
                        <br />
                    </div></td>
                <td width="121"><img src="../imagenes/medalfaLogo.png" width="90" alt="Logo" /></td>
            </tr>

        </table>
        <table width="94%" border="0" align="center" cellpadding="0" cellspacing="0">

            <tr>
                <td colspan="7" bgcolor="#003366"><img src="mm_spacer.gif" alt="" width="1" height="1" border="0" /></td>
            </tr>

            <tr bgcolor="#CCFF99">
                <td height="25" colspan="7" bgcolor="#FFFFFF" id="dateformat">&nbsp;&nbsp;<span class="style76">
                        <script language="JavaScript" type="text/javascript">
              //document.write(TODAY);	</script>
                        <a href="reportes_val_rc.jsp" class="style76"></a></span>&nbsp;&nbsp;<span class="h4">&nbsp;Exportar</span>&nbsp;<img src="../imagenes/exc.jpg" width="37" height="29" border="0" usemap="#Map2"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <%
                            String ori = "AMBOS";
                            try {
                                if ((request.getParameter("ori")).equals("1")) {
                                    ori = "COMPRA CONSOLIDADA";
                                }
                                if ((request.getParameter("ori")).equals("2")) {
                                    ori = "MEDALFA";
                                }
                                if ((request.getParameter("ori")).equals("0")) {
                                    ori = "ADMON COMPRA";
                                }
                            } catch (Exception e) {
                            }
                        %>
                    <span class="h3">ORIGEN "<%=ori%>"</span></td>
            </tr>
            <tr>
                <td colspan="7" bgcolor="#003366"><img src="mm_spacer.gif" alt="" width="1" height="1" border="0" /></td>
            </tr>

            <tr>
                <td width="4" valign="top" bgcolor="#ffffff">

                    �<br />
                    &nbsp;<br />
                    &nbsp;<br />
                    &nbsp;<br /> 	</td>
                <td>&nbsp;</td>
                <td colspan="2" valign="top"><form action="reporte_re2_val.jsp" method="post" name="form" onSubmit="javascript:return ValidateAbas(this)">
                        <table width="1160" border="0" align="center">
                            <tr>
                                <td width="418"><table width="1500" border="1">
                                        <tr>
                                            <td width="77" ><span class="Estilo8">Fecha</span></td>
                                            <td width="62"> <span class="Estilo8">Folio</span></td>
                                            <td width="107"> <span class="Estilo8">Servicio </span></td>
                                            <td width="83"> <span class="Estilo8">Encargado del servicio</span></td>
                                            <td width="82"> <span class="Estilo8">Clave Articulo </span></td>
                                            <td width="452"> <span class="Estilo8">Descripci&oacute;n</span></td>
                                            <td width="68"><span class="Estilo8">Lote</span></td>
                                            <td width="68"><span class="Estilo8">Caducidad</span></td>
                                            <td width="68"><span class="Estilo8">Financiamiento</span></td>
                                            <td width="68"> <span class="Estilo8">Cant. Sol </span></td>
                                            <td width="76"> <span class="Estilo8">Cant. Sur</span></td>
                                        </tr>
                                        <%try {
                                                System.out.println("SELECT r.fecha_hora, r.fol_rec, s.nom_ser, r.enc_ser, m.nom_med, pa.nom_pac, p.cla_pro, p.des_pro, dp.lot_pro, dp.cad_pro, dr.can_sol, dr.cant_sur, dp.cla_fin FROM unidades un, usuarios us, receta r, pacientes pa, medicos m, detreceta dr, detalle_productos dp, productos p, servicios s WHERE r.id_ser = s.id_ser and un.cla_uni = us.cla_uni AND us.id_usu = r.id_usu AND r.cedula = m.cedula AND r.id_rec = dr.id_rec AND dr.det_pro = dp.det_pro AND dp.cla_pro = p.cla_pro AND un.cla_uni = '" + request.getParameter("cla_uni") + "' AND r.fecha_hora BETWEEN '" + request.getParameter("f1") + " 00:00:01' and '" + request.getParameter("f2") + " 23:59:59' and dp.id_ori like '%" + request.getParameter("ori") + "%' and dr.baja!=1 and r.id_tip = '2' and dr.cant_sur!=0 ;");

                                                rset = stmt.executeQuery("SELECT r.fecha_hora, r.fol_rec, s.nom_ser, r.enc_ser, m.nom_med, pa.nom_pac, p.cla_pro, p.des_pro, dp.lot_pro, dp.cad_pro, dr.can_sol, dr.cant_sur, dp.cla_fin FROM unidades un, usuarios us, receta r, pacientes pa, medicos m, detreceta dr, detalle_productos dp, productos p, servicios s WHERE r.id_ser = s.id_ser and un.cla_uni = us.cla_uni AND us.id_usu = r.id_usu AND r.cedula = m.cedula AND r.id_rec = dr.id_rec AND dr.det_pro = dp.det_pro AND dp.cla_pro = p.cla_pro AND pa.id_pac = r.id_pac AND un.cla_uni = '" + request.getParameter("cla_uni") + "' AND r.fecha_hora BETWEEN '" + request.getParameter("f1") + " 00:00:01' and '" + request.getParameter("f2") + " 23:59:59' and dp.id_ori like '%" + request.getParameter("ori") + "%' and dr.baja!=1 and r.id_tip = '2' and dr.cant_sur!=0 group by dr.fol_det;");
                                                while (rset.next()) {
                                                    ban = 1;
                                                    String financ = "";
                                                    if (rset.getString("dp.cla_fin").equals("1")) {
                                                        financ = "Seguro Popular";
                                                    } else if (rset.getString("dp.cla_fin").equals("2")) {
                                                        financ = "FASSA";
                                                    }
                                        %>
                                        <tr>
                                            <td class="Estilo8"><%=df2.format(df3.parse(rset.getString(1)))%></td>
                                            <td><%=rset.getString("fol_rec")%></td>
                                            <td><%=rset.getString("nom_ser")%></td>
                                            <td><%=rset.getString("enc_ser")%></td>
                                            <td><%=rset.getString("cla_pro")%></td>
                                            <td><%=rset.getString("des_pro")%></td>
                                            <td align="center"><%=rset.getString("lot_pro")%></td>
                                            <td align="center"><%=df2.format(df.parse(rset.getString("cad_pro")))%></td>
                                            <td align="center"><%=financ%></td>
                                            <td align="center"><%=rset.getString("can_sol")%></td>
                                            <td align="center"><%=rset.getString("cant_sur")%></td>
                                        </tr>
                                        <%
                                                }
                                            } catch (Exception ex) {
                                                System.out.println("Error2->" + ex.getMessage());
                                            }
                                        %>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>

                                            <td class="Estilo5" align="right">&nbsp;</td>
                                            <td class="Estilo5" align="center">&nbsp;</td>
                                            <td class="Estilo5" align="center">PIEZAS</td>
                                            <td class="Estilo5" align="center">&nbsp;</td>
                                            <%
                                                try {
                                                    int cantTotalSur = 0;
                                                    int cantTotalSol = 0;
                                                    rset = stmt.executeQuery("SELECT r.fecha_hora, r.fol_rec, s.nom_ser, r.enc_ser, m.nom_med, pa.nom_pac, p.cla_pro, p.des_pro, dp.lot_pro, dp.cad_pro, dr.can_sol as sol, (dr.cant_sur) as sur FROM unidades un, usuarios us, receta r, pacientes pa, medicos m, detreceta dr, detalle_productos dp, productos p, servicios s WHERE r.id_ser = s.id_ser and un.cla_uni = us.cla_uni AND us.id_usu = r.id_usu AND r.cedula = m.cedula AND r.id_rec = dr.id_rec AND dr.det_pro = dp.det_pro AND dp.cla_pro = p.cla_pro AND pa.id_pac = r.id_pac AND un.cla_uni = '" + request.getParameter("cla_uni") + "' AND r.fecha_hora BETWEEN '" + request.getParameter("f1") + " 00:00:01' and '" + request.getParameter("f2") + " 23:59:59' and dp.id_ori like '%" + request.getParameter("ori") + "%' and dr.baja!=1 and r.id_tip = '2' and dr.cant_sur!=0 group by dr.fol_det;");
                                                    while (rset.next()) {
                                                        ban = 1;
                                                        cantTotalSur = cantTotalSur + rset.getInt("sur");
                                                        cantTotalSol = cantTotalSol + rset.getInt("sol");
                                                    }
                                            %>
                                            <td class="Estilo5" align="center"><%=cantTotalSol%></td>
                                            <td class="Estilo5" align="center"><%=cantTotalSur%></td>
                                            <%
                                                } catch (Exception ex) {
                                                    System.out.println("Erro2->" + ex.getMessage());
                                                }

                                            %>
                                        </tr>
                                        <tr>
                                            <td colspan="16">ADMINISTRADOR DE LA UNIDAD&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ENCARGADO(A) DE LA FARMACIA &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FILTRO DEL ISEM</td>
                                        </tr>
                                    </table>
                                </td>

                            </tr>
                        </table>
                    </form>   

                </td>

            </tr>

        </table>
        <map name="Map" id="Map">
            <area shape="poly" coords="241,165" href="#" />
            <area shape="poly" coords="230,40,231,88,270,43" href="#" />
        </map>
        <map name="Map2" id="Map2">
            <area shape="rect" coords="5,2,32,28" href="validaMesColFarmExcel.jsp?f1=<%=request.getParameter("f1")%>&f2=<%=request.getParameter("f2")%>&boton=Show ALL&unidad=<%=request.getParameter("cla_uni")%>&ori=<%=request.getParameter("ori")%>" />
        </map>
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui.js"></script>
        <script src="../js/bootstrap-datepicker.js"></script>
    </body>
</html>
<%
    con.close();
%>