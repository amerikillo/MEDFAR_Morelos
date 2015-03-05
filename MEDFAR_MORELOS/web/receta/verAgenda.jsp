
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ConectionDB con = new ConectionDB();
    HttpSession sesion = request.getSession();
    String id_usu = "";
    String medico = "";
    try {
        id_usu = (String) session.getAttribute("id_usu");
        con.conectar();
        ResultSet rset = con.consulta("select nom_com from medicos m, usuarios u where m.cedula = u.cedula and u.id_usu = '" + id_usu + "' ");
        while (rset.next()) {
            medico = rset.getString("nom_com");
            System.out.println(medico);
        }
        con.cierraConexion();
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
        <link href='../css/fullcalendar.css' rel='stylesheet' />
        <link href='../css/bootstrap.css' rel='stylesheet' />
        <link href="../css/pie-pagina.css" rel="stylesheet" media="screen">
        <link href="../css/topPadding.css" rel="stylesheet">
        <link href='../css/fullcalendar.print.css' rel='stylesheet' media='print' />

    </head>
    <body>
        <%@include file="../jspf/mainMenu.jspf" %>
        <div class="container-fluid">
            <div class="container" style="padding-top: 20px">
                <h3>Médico: <%=medico%></h3>
                <form class="form-horizontal" role="form">
                    <!--div class="form-group col-lg-12">
                        <label for="selectMedico" class="col-lg-2 control-label">Filtrar por Médico</label>
                        <div class="col-lg-6">
                            <select class="form-control" name="selectMedico" id="selectMedico">
                                <option value="">TODOS</option>
                    <%                                    try {
                            con.conectar();
                            ResultSet rset = con.consulta("select url from eventos group by url order by url");
                            while (rset.next()) {
                                out.println("<option value='" + rset.getString(1) + "'>" + rset.getString(1) + "</option>");
                            }
                            con.cierraConexion();
                        } catch (Exception e) {

                        }
                    %>
                </select>
            </div>
        </div-->
                </form>
                <div id='calendar'></div>
            </div>
        </div>
    </body>
    <script src='js/jquery.min.js'></script>
    <script src='js/jquery-ui.custom.min.js'></script>
    <script src='../js/fullcalendar.js'></script>
    <script src='../js/bootstrap.js'></script>
    <script>

        $(document).ready(function() {
            var date = new Date();
            var d = date.getDate();
            var m = date.getMonth();
            var y = date.getFullYear();


            var medico = '<%=medico%>';
            var calendar = $('#calendar').fullCalendar({
                editable: false,
                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay'
                },
                events: "../Events?ban=6&medico=" + medico,
                // Convert the allDay from string to boolean
                eventRender: function(event, element, view) {
                    if (event.allDay === 'true') {
                        event.allDay = true;
                    } else {
                        event.allDay = false;
                    }
                }
            });

        });

    </script>
</html>