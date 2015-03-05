<%-- 
    Document   : index
    Created on : 07-mar-2014, 15:38:43
    Author     : Americo
--%>

<%@page import="java.util.*"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("HH:mm:ss"); %>
<%java.text.DateFormat df1 = new java.text.SimpleDateFormat("dd/MM/yyyy");%>
<%
    ConectionDB con = new ConectionDB();
    HttpSession sesion = request.getSession();
    String id_usu = "";
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    if (id_usu == null) {
        //response.sendRedirect("index.jsp");
    }

    String fecha1 = "", fecha2 = "";

    try {
        fecha1 = df2.format(df1.parse(request.getParameter("hora_ini")));
        fecha2 = df2.format(df1.parse(request.getParameter("hora_fin")));
    } catch (Exception e) {

    }

    if (fecha1.equals("")) {

        try {
            con.conectar();
            ResultSet rset = con.consulta("select min(fecha_hora) from receta_resportes");
            con.cierraConexion();
        } catch (Exception e) {

        }

        fecha1 = df2.format((new Date()));
        fecha2 = df2.format((new Date()));
    }

    System.out.println(fecha1);
    System.out.println(fecha2);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap -->
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="../css/topPadding.css" rel="stylesheet">
        <link href="../css/datepicker3.css" rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>Sistema de Captura de Receta</title>
    </head>
    <body>
        <%@include file="../jspf/mainMenu.jspf" %>
        <br />
        <div class="container-fluid">
            <div class="container">
                <form class="form-horizontal" action="repConsSemanal.jsp" method="POST">
                    <div class="row">
                        <h3>Reporte Mensual Farmacia</h3>
                    </div>
                    <br />
                    <div class="row">
                        <label class="control-label col-lg-1" for="hora_ini">Inicio</label>
                        <div class="col-lg-2">
                            <input class="form-control" id="hora_ini" name="hora_ini" data-date-format="dd/mm/yyyy"  value="<%=df1.format(df2.parse(fecha1))%>" readonly />
                        </div>
                        <label class="control-label col-lg-1" for="hora_fin">Fin</label>
                        <div class="col-lg-2">
                            <input class="form-control" id="hora_fin" name="hora_fin" data-date-format="dd/mm/yyyy"  value="<%=df1.format(df2.parse(fecha2))%>" readonly />
                        </div>
                        <div class="col-lg-1">
                        </div>
                        <div class="col-lg-2">
                            <button class="btn btn-primary btn-block" >Consultar</button>
                        </div>
                        <div class="col-lg-2">
                            <a class="btn btn-success btn-block" onclick="return generaExcel();">Generar Excel</a>
                        </div>
                    </div>

                </form>
                <br/>
                <table class="table table-bordered table-striped">
                    <tr>
                        <td>Clave</td>
                        <td>Descripción</td>
                        <td>Cantidad</td>
                    </tr>
                    <%
                        try {
                            con.conectar();
                            ResultSet rset = con.consulta("select cla_pro, des_pro, cantidad from receta_reportes where fecha_hora between '" + fecha1 + " 00:00:01' and '" + fecha2 + " 23:59:59' and cantidad != 0 ;");
                            while (rset.next()) {
                    %>
                    <tr>
                        <td><%=rset.getString(1)%></td>
                        <td><%=rset.getString(2)%></td>
                        <td><%=rset.getString(3)%></td>
                    </tr>
                    <%                            }
                            con.cierraConexion();
                        } catch (Exception e) {
                            System.out.println(e.getMessage());
                        }
                    %>
                    <%
                        try {
                            con.conectar();
                            ResultSet rset = con.consulta("select sum(cantidad) from receta_reportes where fecha_hora between '" + fecha1 + " 00:00:01' and '" + fecha2 + " 23:59:59' and cantidad != 0 ;");
                            while (rset.next()) {
                                if(rset.getString(1)!=null){
                    %>
                    <tr>
                        <td colspan="2" class="text-right"><b>Totales</b></td>
                        <td><b><%=rset.getString(1)%><b></td>
                    </tr>
                    <%                            }
                            }
                            con.cierraConexion();
                        } catch (Exception e) {
                            System.out.println(e.getMessage());
                        }
                    %>
                </table>
            </div>
        </div>

    </body>
    <!-- 
    ================================================== -->
    <!-- Se coloca al final del documento para que cargue mas rapido -->
    <!-- Se debe de seguir ese orden al momento de llamar los JS -->
    <script src="../js/jquery-1.9.1.js"></script>
    <script src="../js/bootstrap.js"></script>
    <script src="../js/jquery-ui-1.10.3.custom.js"></script>
    <script src="../js/bootstrap-datepicker.js"></script>
    <script>

                                $("#hora_ini").datepicker({minDate: 0});
                                $("#hora_fin").datepicker({minDate: 0});

                                function generaExcel() {
                                    var hora_ini = document.getElementById("hora_ini").value;
                                    var hora_fin = document.getElementById("hora_fin").value;
                                    if (hora_ini === "" || hora_fin === "") {
                                        alert("Seleccione todos los parametros");
                                        return false;
                                    } else {
                                        window.location = "../reportes/repConSem.jsp?hora_ini=" + hora_ini + "&hora_fin=" + hora_fin + "";
                                    }

                                }
    </script>
</html>

