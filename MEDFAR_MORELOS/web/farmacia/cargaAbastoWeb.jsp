<%-- 
    Document   : index
    Created on : 07-mar-2014, 15:38:43
    Author     : Americo
--%>

<%@page import="Clases.ConectionDB2"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion = request.getSession();
    String id_usu = "";
    ConectionDB con = new ConectionDB();
    ConectionDB2 con2 = new ConectionDB2();
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    if (id_usu == null) {
        //response.sendRedirect("index.jsp");
    }
    ArrayList pass = new ArrayList();
    try {
        con.conectar();
        ResultSet rset = con.consulta("select pass from usuarios where rol=3");
        while (rset.next()) {
            pass.add(rset.getString(1));
        }
        con.cierraConexion();
    } catch (Exception e) {

    }

    String folio = "", but = "";
    int ban = 0, ban_error = 0;
    try {
        folio = request.getParameter("folio");
        but = request.getParameter("Submit");
    } catch (Exception e) {
    }
    if (folio == null) {
        folio = "";
    }

    try {
        con2.conectar();
        ResultSet rset = con2.consulta("select idAbasto from abasto_unidades where Folio = '"+folio+"' and Surtido=1 ");
        while(rset.next()){
            ban_error=1;
        }
        con2.cierraConexion();
    } catch (Exception e) {
    }
    
    try {
        con2.conectar();
        ResultSet rset = con2.consulta("select idAbasto from abasto_unidades where Folio = '"+folio+"' ");
        while(rset.next()){
            ban=1;
        }
        con2.cierraConexion();
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
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>SIALSS</title>
    </head>
    <body>
        
        <%@include file="../jspf/mainMenu.jspf" %>

        <div class="container-fluid">
            <div class="container">
                <h2>Cargar Abasto</h2>


                <form id="form1" name="form1" method="post" action="cargaAbastoWeb.jsp">
                    Ingrese el Folio:
                    <input type="text" name="folio" id="folio" value="<%=folio%>"/>
                    <input type="submit" name="Submit" id="Submit" value="Folio"/>
                    <input type="submit" name="Submit" id="Submit" value="Cargar" <%
                        if (ban == 0) {
                            out.print("style='visibility:hidden'");
                        }
                        if (ban == 0) {
                            if (folio.equals("")) {
                                out.print("style='visibility:hidden'");
                            }
                        }%>  />
                    <input type="text" name="folio2" id="folio2" value="<%=folio%>" readonly style="visibility:hidden"/>
                </form>

                <table class="table table-condensed table-striped table-bordered">

                    <%

                        if (but != null) {
                            //out.print("Boton:"+folio);
                            if (!folio.equals("")) {
                                if (but.equals("Folio")) {
                                    if (ban_error != 1) {
                                        if (ban == 1) {
                    %>
                    <tr>
                        <td></td>
                        <td></td>
                        <td><strong>CLAVE</strong></td>
                        <td><strong>DESCRIPCION</strong></td>
                        <td><strong>LOTE</strong></td>
                        <td><strong>CADUCIDAD</strong></td>
                        <td><strong>CANT SOL</strong></td>
                        <td><strong>CANT ENT</strong></td>
                        <td><strong>ORIGEN</strong></td>
                    </tr>
                    <%
                        String query_abasto = "SELECT a.ClaPro, p.DesPro, a.ClaLot, a.FecCad, a.CanReq, a.CanEnt, a.Origen, a.Id FROM abastos a INNER JOIN productos p ON a.ClaPro = p.ClaPro INNER JOIN abasto_unidades au ON a.IdAbasto = au.IdAbasto WHERE Folio = '" + folio + "';";
                        try {
                            con2.conectar();
                            ResultSet rset = con2.consulta(query_abasto);
                            while (rset.next()) {
                                String clave = rset.getString(1);
                                String descrip = rset.getString(2);
                                String lote = rset.getString(3);
                                String cad = rset.getString(4);
                                String cant = rset.getString(5);
                                String cantent = rset.getString(6);
                                String ori = rset.getString(7);
                                String id_abasto = rset.getString(8);
                                //out.print(clave+descrip+lote+cad+cant+ori);
%>
                    <tr>
                        <td>
                            <a href="edita_clave_abasto.jsp?id_abasto=<%=id_abasto%>&folio=<%=folio%>"><img src="../imagenes/edit.png"
                                                                                                            width="20" height="20"/></a>
                        </td>
                        <td>
                            <a onClick="return confirm('Estas seguro de Eliminarla?')"
                               href="cargaAbastoWeb.jsp?id_abasto=<%=id_abasto%>&folio=<%=folio%>&Submit=Folio&Accion=Eliminar"><img
                                    src="../imagenes/delete.png" width="20" height="20"/></a>
                        </td>
                        <td><%=clave%>
                        </td>
                        <td><%=descrip%>
                        </td>
                        <td><%=lote%>
                        </td>
                        <td><%=cad%>
                        </td>
                        <td><%=cant%>
                        </td>
                        <td><%=cantent%>
                        </td>
                        <td><%=ori%>
                        </td>
                    </tr>
                    <%
                            }
                            con.cierraConexion();
                        } catch (Exception e) {

                        }
                    } else {
                    %>
                    <script>
                        alert("Folio Inexistente");
                        location.href = "cargaAbastoWeb.jsp";
                    </script>
                    <%
                        }
                    } else {
                    %>
                    <script>
                        alert("Folio ya cargado");
                        location.href = "cargaAbastoWeb.jsp";
                    </script>
                    <%
                            }
                        }
                    } else {
                    %>
                    <script>
                        alert("Favor de ingresar un Folio");
                        location.href = "cargaAbastoWeb.jsp";
                    </script>
                    <%
                            }
                        }

                    %></table>
            </div>
        </div>

    </body><!-- 
================================================== -->
    <!-- Se coloca al final del documento para que cargue mas rapido -->
    <!-- Se debe de seguir ese orden al momento de llamar los JS -->
    <script src="../js/jquery-1.9.1.js"></script>
    <script src="../js/bootstrap.js"></script>
    <script src="../js/jquery-ui-1.10.3.custom.js"></script>
    <script src="http://crypto-js.googlecode.com/svn/tags/3.1.2/build/rollups/sha1.js"></script>


</html>


