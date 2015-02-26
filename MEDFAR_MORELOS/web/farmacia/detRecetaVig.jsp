<%-- 
    Document   : detRecetaVig
    Created on : 26-feb-2015, 15:59:11
    Author     : amerikillo
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); %>
<%java.text.DateFormat df1 = new java.text.SimpleDateFormat("HH:mm:ss"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy");%>
<%
    ConectionDB con = new ConectionDB();
    HttpSession sesion = request.getSession();
    String id_usu = "", cla_uni = "";
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    if (id_usu == null) {
        //response.sendRedirect("index.jsp");
    }

    try {
        con.conectar();
        ResultSet rset = con.consulta("select cla_uni from usuarios where id_usu = '" + id_usu + "'");
        while (rset.next()) {
            cla_uni = rset.getString("cla_uni");
        }
        con.cierraConexion();
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
        <div class="row">
            <div class="col-sm-12">
                <%                        try {
                        String id_rec = "";
                        con.conectar();
                        ResultSet rset = con.consulta("select * from recetas where id_rec = '" + request.getParameter("id_rec") + "' and id_tip = '1' group by fol_rec");
                        while (rset.next()) {
                            id_rec = rset.getString("id_rec");
                %>
                <div class="panel panel-default">
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-sm-2">
                                <strong>Folio:</strong> <%=rset.getString("fol_rec")%>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <strong>Unidad de Atención:</strong> <%=rset.getString("uni")%>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <strong>Paciente:</strong> <%=rset.getString("nom_com")%>
                            </div>
                            <div class="col-sm-6">
                                <strong>Médico:</strong> <%=rset.getString("medico")%>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <strong>Fecha:</strong> <%=df3.format(rset.getDate("fecha_hora"))%>
                            </div>
                        </div>
                    </div>
                    <div class="panel-footer">
                        <table class="table table-bordered table-condensed table-striped">
                            <tr>
                                <td>Clave</td>
                                <td>Descripción</td>
                                <td>Lote</td>
                                <td>Caducidad</td>
                                <td>Origen</td>
                                <td>Cantidad</td>
                            </tr>
                            <%
                                ResultSet rset2 = con.consulta("select cla_pro, des_pro, lote, DATE_FORMAT(caducidad, '%d/%m/%Y') as caducidad, id_ori, cant_sur from recetas where id_rec = '" + request.getParameter("id_rec") + "' and id_tip = '1' ");
                                while (rset2.next()) {
                            %>
                            <tr>
                                <td class="text-right"><%=rset2.getString("cla_pro")%></td>
                                <td><%=rset2.getString("des_pro")%></td>
                                <td><%=rset2.getString("lote")%></td>
                                <td><%=rset2.getString("caducidad")%></td>
                                <td><%=rset2.getString("id_ori")%></td>
                                <td class="text-right"><%=rset2.getString("cant_sur")%></td>
                            </tr>
                            <%
                                }
                            %>
                        </table>
                    </div>
                </div>
                <%
                        }
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                %>
            </div>
        </div>
    </body>
</html>
