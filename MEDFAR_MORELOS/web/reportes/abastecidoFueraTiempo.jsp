<%-- 
    Document   : abastecidoFueraTiempo
    Created on : 27/02/2015, 09:08:36 AM
    Author     : Americo
--%>

<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy");%>
<% /*Parametros para realizar la conexión*/

    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatterDecimal = new DecimalFormat("#,###,##0.00");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator('.');
    custom.setGroupingSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    formatterDecimal.setDecimalFormatSymbols(custom);
    HttpSession sesion = request.getSession();
    ConectionDB con = new ConectionDB();

    int sumTotal = 0, pendSur = 0, cajAmp = 0;

    /*parameters.put("hora_ini", df2.format(df3.parse(request.getParameter("hora_ini")))+" 00:00:01");
     parameters.put("hora_fin", df2.format(df3.parse(request.getParameter("hora_fin")))+" 23:59:59");
     parameters.put("id_origen", request.getParameter("id_origen"));
     parameters.put("unidad", request.getParameter("unidad"));
     parameters.put("id_tip", request.getParameter("id_tip"));*/
    String origen = "";
    try {
        if (request.getParameter("id_origen").equals("1")) {
            origen = "ISEM";
        } else if (request.getParameter("id_origen").equals("2")) {
            origen = "MEDALFA";
        } else if (request.getParameter("id_origen").equals("3")) {
            origen = "AMBOS";
        }
    } catch (Exception e) {
    }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap -->
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="../css/topPadding.css" rel="stylesheet">
        <link href="../css/dataTables.bootStrap.css" rel="stylesheet">
        <link href="../css/cupertino/jquery-ui-1.10.3.custom.css" rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>Sistema de Captura de Receta</title>
    </head>
    <body class="container">
        <%@include file="../jspf/mainMenu.jspf"%>
        <h1>Insumos Abastecidos Fuera de Tiempo</h1>
        <div class="panel panel-primary">
            <div class="panel-heading">

            </div>
            <div class="panel-body">
                <table class="table table-condensed table-bordered table-striped" id="tablaFueraTiempo">
                    <thead>
                        <tr>
                            <td>Folio Rec</td>
                            <td>Paciente</td>
                            <td>Clave</td>
                            <td>Descripción</td>
                            <td>Lote</td>
                            <td>Caducidad</td>
                            <td>Cant Sol</td>
                            <td>Cant Sur</td>
                            <td>Fecha Original</td>
                            <td>Fecha de Surtido</td>
                        </tr>
                    </thead>
                    <tbody>
                        <%                        con.conectar();
                            ResultSet rset = con.consulta("select fol_rec, nom_com, cla_pro, des_pro, lot_pro, cad_pro, can_sol, cant_sur, DATE_FORMAT(fecha, '%d/%m/%Y') as fecha, DATE_FORMAT(fecha_sur, '%d/%m/%Y') as fecha_sur from vistaFueraTiempo");
                            while (rset.next()) {
                        %>

                        <tr>
                            <td><%=rset.getString("fol_rec")%></td>
                            <td><%=rset.getString("nom_com")%></td>
                            <td><%=rset.getString("cla_pro")%></td>
                            <td><%=rset.getString("des_pro")%></td>
                            <td><%=rset.getString("lot_pro")%></td>
                            <td><%=rset.getString("cad_pro")%></td>
                            <td><%=rset.getString("can_sol")%></td>
                            <td><%=rset.getString("cant_sur")%></td>
                            <td><%=rset.getString("fecha")%></td>
                            <td><%=rset.getString("fecha_sur")%></td>
                        </tr>
                        <%
                            }
                            con.cierraConexion();
                        %>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- 
            ================================================== -->
        <!-- Se coloca al final del documento para que cargue mas rapido -->
        <!-- Se debe de seguir ese orden al momento de llamar los JS -->
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui.js"></script>
        <script src="../js/jquery.dataTables.js"></script>
        <script src="../js/dataTables.bootstrap.js"></script>
        <script src="../js/jquery-ui.js"></script>
        <script>
$(document).ready(function() {
                $('#tablaFueraTiempo').dataTable();
            });
        </script>
    </body>
</html>
