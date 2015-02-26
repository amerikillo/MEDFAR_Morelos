<%-- 
    Document   : modVigilancia
    Created on : 26-feb-2015, 7:47:06
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
    <body>
        <%@include file="../jspf/mainMenu.jspf" %>
        <br />
        <div class="container" >
            <h2>Módulo de Vigilancia</h2>
            <hr/>
            <form action="modVigilancia.jsp" method="post">
                <div class="row">
                    <h4 class="col-sm-1">Folio:</h4>
                    <div class="col-sm-2">
                        <input class="form-control" name="fol_rec" autofocus />
                    </div>
                    <div class="col-sm-1">
                        <button class="btn btn-block btn-primary"><span class="glyphicon glyphicon-search"></span></button>
                    </div>
                </div>
            </form>
            <div class="row">
                <div class="col-sm-12">
                    <%                        try {
                            String id_rec = "";
                            con.conectar();
                            ResultSet rset = con.consulta("select * from recetas where fol_rec = '" + request.getParameter("fol_rec") + "' and id_tip = '1' and cla_uni = '" + cla_uni + "' group by fol_rec");
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
                                    ResultSet rset2 = con.consulta("select cla_pro, des_pro, lote, DATE_FORMAT(caducidad, '%d/%m/%Y') as caducidad, id_ori, cant_sur from recetas where fol_rec = '" + request.getParameter("fol_rec") + "' and id_tip = '1' and cla_uni = '" + cla_uni + "'");
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
                        int banVig = 0;
                        rset2 = con.consulta("select id_vig from vistaModVig where id_rec = '" + id_rec + "' and cla_uniF = '" + cla_uni + "'");
                        while (rset2.next()) {
                            banVig = 1;
                        }
                        if (banVig == 0) {
                    %>
                    <form method="post" action="../ModuloVigilancia">
                        <input value="<%=cla_uni%>" class="hidden" name="cla_uniF" />
                        <input value="<%=id_rec%>" class="hidden" name="id_rec" />
                        <div class="row">
                            <h4 class="col-sm-3">
                                Unidad de Futura Atención:
                            </h4>
                            <div class="col-sm-6">
                                <input class="form-control" placeholder="Ingrese Unidad" id="des_uni" name="des_uni" />
                            </div>
                            <div class="col-sm-1">
                                <a class="btn btn-info btn-block" title="Ver Mapa" target="_blank" href="https://www.google.com/maps/d/edit?mid=zpNBwpx3O2D0.kXGuHwczE2O4"><span class="glyphicon glyphicon-map-marker"></span></a>
                            </div>
                        </div>
                        <div class="row">
                            <h4 class="col-sm-2">
                                Justificación:
                            </h4>
                            <div class="col-sm-10">
                                <textarea class="form-control" rows="5" name="justi" id="justi" required></textarea>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <button name="accion" value="ConfirmarVig" class="btn btn-sm btn-block btn-primary" title="Confirmar" onclick=" return validaVigForm(this)"><span class="glyphicon glyphicon-ok"></span></button>
                            </div>
                        </div>
                    </form>
                    <%
                    } else {
                    %>
                    Receta previamente enviada
                    <%
                                }
                            }
                            con.cierraConexion();
                        } catch (Exception e) {
                            System.out.println(e.getMessage());
                        }
                    %>
                </div>
            </div>
            <hr/>
            <div class="panel panel-primary">
                <div class="panel-heading">
                    Recetas Enviada
                </div>
                <div class="panel-body">
                    <table class="tabl table-bordered table-condensed table-striped">
                        <tr>
                            <td>Unidad Destino</td>
                            <td>Paciente</td>
                            <td>Médico</td>
                            <td>Folio Rec</td>
                            <td width="500">Justificación</td>

                        </tr>
                        <%
                            try {
                                con.conectar();
                                ResultSet rset = con.consulta("select * from vistaModVig where cla_uniF='" + cla_uni + "' ");
                                while (rset.next()) {
                        %>
                        <tr>
                            <td><%=rset.getString("des_uni")%></td>
                            <td><%=rset.getString("paciente")%></td>
                            <td><%=rset.getString("medico")%></td>
                            <td><%=rset.getString("fol_rec")%></td>
                            <td><textarea readonly="" class="form-control" rows="7"><%=rset.getString("justi")%></textarea></td>
                        </tr>
                        <%
                                }
                                con.cierraConexion();
                            } catch (Exception e) {
                                out.println(e.getMessage());
                            }
                        %>
                    </table>
                </div>
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
                                    $("#des_uni").keyup(function () {
                                        var nombre = $("#des_uni").val();
                                        $("#des_uni").autocomplete({
                                            source: "../AutoUnidades?nombre=" + nombre,
                                            minLength: 2,
                                            select: function (event, ui) {
                                                $("#des_uni").val(ui.item.des_uni);
                                                return false;
                                            }
                                        }).data("ui-autocomplete")._renderItem = function (ul, item) {
                                            return $("<li>")
                                                    .data("ui-autocomplete-item", item)
                                                    .append("<a>" + item.des_uni + "</a>")
                                                    .appendTo(ul);
                                        };
                                    });


                                    function validaVigForm(e) {
                                        if (document.getElementById('des_uni').value === "") {
                                            alert('Ingrese la Unidad');
                                            return false;
                                        }
                                        else if (document.getElementById('justi').value === "") {
                                            alert('Ingrese la Justificación');
                                            return false;
                                        }
                                        else {
                                            var a = confirm('Seguro de referenciar receta?');
                                            return a;
                                        }
                                    }
        </script>
    </body>
</html>
