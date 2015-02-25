<%-- 
    Document   : existenciasExternas
    Created on : 25/02/2015, 11:40:32 AM
    Author     : Americo
--%>

<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>

<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    DecimalFormat formatNumber = new DecimalFormat("#,###,###,###");
    ConectionDB con = new ConectionDB();
    HttpSession sesion = request.getSession();
    String id_usu = "";
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    if (id_usu == null) {
        response.sendRedirect("index.jsp");
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
        <div class="container">
            <h3>Existencias en otras U. A. </h3>
            <hr/>
            <form action="existenciasExternas.jsp" method="post">
                <div class="row">
                    <h4 class="col-sm-1">
                        Clave:
                    </h4>
                    <div class="col-sm-2">
                        <input class="form-control" name="cla_pro" />
                    </div>
                    <h4 class="col-sm-2">
                        Descripción:
                    </h4>
                    <div class="col-sm-6">
                        <input class="form-control" name="des_pro" id="des_pro" />
                    </div>
                    <div class="col-sm-1">
                        <button class="btn btn-primary" name="accion" value="buscar"><span class="glyphicon glyphicon-search"></span></button>
                    </div>
                </div>
            </form>
            <hr/>
            <%
                if (request.getParameter("accion") != null) {
                    if (request.getParameter("accion").equals("buscar")) {
            %>
            <table class="table table-condensed table-bordered table-striped" id="tablaExistencias">
                <tr>
                    <td>Unidad</td>
                    <td>Clave</td>
                    <td>Lote</td>
                    <td>Caducidad</td>
                    <td>Origen</td>
                    <td>Cantidad</td>
                </tr>
                <%
                    try {
                        
                        con.conectar();
                        String cla_pro = "";
                        cla_pro = request.getParameter("cla_pro");

                        byte[] a = request.getParameter("des_pro").getBytes("ISO-8859-1");
                        String des_pro = (new String(a, "UTF-8"));
                        if (!request.getParameter("des_pro").equals("")) {
                            ResultSet rset = con.consulta("select cla_pro from productos where des_pro = '" + des_pro + "'");
                            while (rset.next()) {
                                cla_pro = rset.getString("cla_pro");
                            }
                        }
                        ResultSet rset = con.consulta("select * from existencias where cla_pro = '" + cla_pro + "' and cant!=0");
                        while (rset.next()) {
                            String des_uni = "";
                            ResultSet rset2 = con.consulta("select des_uni from unidades where cla_uni = '" + rset.getString("cla_uni") + "'");
                            while (rset2.next()) {
                                des_uni = rset2.getString("des_uni");
                            }
                %>
                <tr>
                    <td><%=rset.getString("cla_uni")%> - <%=des_uni%></td>
                    <td title="<%=rset.getString("des_pro")%>"><%=rset.getString("cla_pro")%></td>
                    <td><%=rset.getString("lot_pro")%></td>
                    <td><%=rset.getString("cad_pro")%></td>
                    <td><%=rset.getString("id_ori")%></td>
                    <td><%=rset.getString("cant")%></td>
                </tr>
                <%
                        }
                        con.cierraConexion();
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                %>
            </table>
            <%
                    }
                }
            %>
        </div> <!-- 
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
                $('#tablaExistencias').dataTable();
            });

            $("#des_pro").keyup(function() {
                var nombre = $("#des_pro").val();
                $("#des_pro").autocomplete({
                    source: "../AutoProductos?nombre=" + nombre,
                    minLength: 2,
                    select: function(event, ui) {
                        $("#des_pro").val(ui.item.des_pro);
                        return false;
                    }
                }).data("ui-autocomplete")._renderItem = function(ul, item) {
                    return $("<li>")
                            .data("ui-autocomplete-item", item)
                            .append("<a>" + item.des_pro + "</a>")
                            .appendTo(ul);
                };
            });

        </script>

    </body>
</html>
