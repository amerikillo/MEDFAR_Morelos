<%-- 
    Document   : index
    Created on : 07-mar-2014, 15:38:43
    Author     : Americo
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%    ConectionDB con = new ConectionDB();
    HttpSession sesion = request.getSession();
    String id_usu = "",NombreUsu="";
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    if (id_usu == null) {
        //response.sendRedirect("index.jsp");
    }

    String fol_rec = "", nom_pac = "";
    try {
        fol_rec = request.getParameter("fol_rec");
        nom_pac = request.getParameter("nom_pac");
    } catch (Exception e) {

    }
    try {
        con.conectar();
        ResultSet RsetUsu = con.consulta("SELECT nombre FROM usuarios WHERE id_usu='" + id_usu + "'");
        if (RsetUsu.next()) {
            NombreUsu = RsetUsu.getString(1);
        }
        con.cierraConexion();
    } catch (Exception ex) {

    }


    if (fol_rec == null) {
        fol_rec = "";
        nom_pac = "";
    }
%>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); %>
<%java.text.DateFormat df1 = new java.text.SimpleDateFormat("HH:mm:ss"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy");%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap -->
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="../css/pie-pagina.css" rel="stylesheet" media="screen">
        <link href="../css/topPadding.css" rel="stylesheet">
        <link href="../css/cupertino/jquery-ui-1.10.3.custom.css" rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>Sistema de Captura de Receta</title>
    </head>
    <body>
        <%@include file="../jspf/mainMenu.jspf"%>
        <br/>
        <div class="container-fluid">
            <div class="container">
                <div class="row">
                    <div class="col-lg-4">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                Búsqueda de Folios Surtidos
                            </div>
                            <div class="panel-body">
                                <form>
                                    Por Folio:
                                    <input type="text" class="form-control" name="fol_rec" />
                                    Por Nombre de Derechohabiente:
                                    <input type="text" onclick="return tabular(event, this);" class="form-control" name="nom_pac" id="nom_pac" placeholder="Derechohabiente" autofocus/>
                                    <button class="btn btn-success btn-block" type="submit">Buscar</button>
                                    <button class="btn btn-warning btn-block" type="submit">Todas</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-8">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                Folios Surtidos
                            </div>
                            <div class="panel-body">
                                <%
                                    try {
                                        con.conectar();
                                        ResultSet rset = con.consulta("SELECT DISTINCT(fol_rec), nom_com, fecha_hora, id_rec from recetas where fol_rec like '%" + fol_rec + "%' and nom_com like '%" + nom_pac + "%' and transito!=1 and baja=0 order by id_rec asc limit 0,50 ;");
                                        while (rset.next()) {
                                %>
                                <form action="../Farmacias" name="form_<%=rset.getString(4)%>">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-sm-3">
                                                    <h4>Folio: <%=rset.getString(1)%></h4>
                                                </div>
                                                <div class="col-sm-3">
                                                    <input class="hidden" value="<%=rset.getString(1)%>" name="fol_rec" />
                                                    <input class="hidden" value="<%=rset.getString(4)%>" name="id_rec" />
                                                    <%
                                                        String fol_det = "";
                                                        try {
                                                            ResultSet rset2 = con.consulta("select fol_det from detreceta where id_rec = '" + rset.getString(4) + "' ");
                                                            while (rset2.next()) {
                                                                fol_det = fol_det + rset2.getString(1) + ",";
                                                            }
                                                        } catch (Exception e) {

                                                        }
                                                    %>
                                                    
                                                    <input class="hidden" name="fol_det" value="<%=fol_det%>" />
                                                </div>
                                                <div class="col-sm-3">
                                                        <button class="btn btn-block btn-info" type="button" name="imprimir" id="imprimir" value="imprimir" onclick="window.open('../reportes/RecetaFarm.jsp?fol_rec=<%=rset.getString(1)%>&tipo=1&re=si&usuario=<%=NombreUsu%>', '', 'width=1200,height=800,left=50,top=50,toolbar=no');">Imprimir Receta</button>                                                         
                                                    </div>
                                                <div class="col-sm-3">
                                                </div>
                                                <div class="col-sm-3">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="col-lg-4">
                                                <b>Paciente:</b><br /> <%=rset.getString(2)%> <br>
                                                <b>Fecha y hora:</b><br /><%=df3.format(df2.parse(rset.getString(3)))%>
                                                <br /><%=df1.format(df2.parse(rset.getString(3)))%>
                                            </div>
                                            <div class="col-lg-8">
                                                <table class="table table-bordered">
                                                    <tr>

                                                        <td>Clave:</td>
                                                        <td>Descripcion:</td>
                                                        <td>Solicitado:</td>
                                                        <td>Surtido:</td>
                                                        <td>Indicaciones</td>
                                                    </tr>
                                                    <%
                                                        ResultSet rset2 = con.consulta("select cla_pro, des_pro, can_sol, cant_sur, fol_det, indicaciones from recetas where fol_rec = '" + rset.getString(1) + "' and cant_sur!=0 ");
                                                        while (rset2.next()) {
                                                    %>
                                                    <tr>

                                                        <td><%=rset2.getString(1)%></td>
                                                        <td><%=rset2.getString(2)%></td>
                                                        <td><input type="text" class="form-control" value="<%=rset2.getString(3)%>" name="sol_<%=rset2.getString(5)%>" readonly="true" /></td>
                                                        <td><input type="text" class="form-control" value="<%=rset2.getString(4)%>" name="sur_<%=rset2.getString(5)%>" readonly="true" /></td>
                                                        <td><%=rset2.getString(6)%></td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                                <%
                                        }
                                        con.cierraConexion();
                                    } catch (Exception e) {
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </body>
    <!-- 
    ================================================== -->
    <!-- Se coloca al final del documento para que cargue mas rapido -->
    <!-- Se debe de seguir ese orden al momento de llamar los JS -->
    <script src="../js/jquery-1.9.1.js"></script>
    <script src="../js/bootstrap.js"></script>
    <script src="../js/jquery-ui.js"></script>
    <script type="text/javascript">
                                                            $(document).ready(function() {
                                                                $("#nom_pac").keyup(function() {
                                                                    var nombre2 = $("#nom_pac").val();
                                                                    $("#nom_pac").autocomplete({
                                                                        source: "../AutoPacientes?nombre=" + nombre2,
                                                                        minLength: 2,
                                                                        select: function(event, ui) {
                                                                            $("#nom_pac").val(ui.item.nom_com);
                                                                            return false;
                                                                        }
                                                                    }).data("ui-autocomplete")._renderItem = function(ul, item) {
                                                                        return $("<li>")
                                                                                .data("ui-autocomplete-item", item)
                                                                                .append("<a>" + item.nom_com + "</a>")
                                                                                .appendTo(ul);
                                                                    };
                                                                });
                                                            });

                                                            function tabular(e, obj) {
                                                                tecla = (document.all) ? e.keyCode : e.which;
                                                                if (tecla !== 13)
                                                                    return;
                                                                frm = obj.form;
                                                                for (i = 0; i < frm.elements.length; i++)
                                                                    if (frm.elements[i] === obj)
                                                                    {
                                                                        if (i === frm.elements.length - 1)
                                                                            i = -1;
                                                                        break
                                                                    }
                                                                /*ACA ESTA EL CAMBIO*/
                                                                if (frm.elements[i + 1].disabled === true)
                                                                    tabular(e, frm.elements[i + 1]);
                                                                else
                                                                    frm.elements[i + 1].focus();
                                                                return false;
                                                            }
    </script>
</html>

