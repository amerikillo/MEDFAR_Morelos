<%-- 
    Document   : index
    Created on : 07-mar-2014, 15:38:43
    Author     : Americo
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion = request.getSession();
    String id_usu = "";
    ConectionDB con = new ConectionDB();
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    if (id_usu == null) {
        response.sendRedirect("index.jsp");
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

    for (int i = 0; i < pass.size(); i++) {
        System.out.println(pass.get(i));
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
        <%@include file="../jspf/mainMenu.jspf"%>
        <br/>
        <div class="container-fluid">
            <div class="container" style="width: 600px;">
                <h2>Cargar Abasto</h2>
                
                <form name="cargaAbasto" method="POST" enctype="multipart/form-data" action="../FileUploadServlet">
                    <div class="row">
                        <label class="form-horizontal col-lg-4">Seleccione un archivo:</label>
                        <div class="col-lg-8">
                            <input type="file" class="form-control" name="archivo" accept=".csv">
                        </div>
                    </div>
                    <br />
                    <div class="row">
                        <label class="form-horizontal col-lg-4">Contraseña:</label>
                        <div class="col-lg-8">
                            <input type="password" id="contra" placeholder="Contraseña de Administrador" class="form-control">
                        </div>
                    </div>
                    <br />
                    <div class="col-lg-12">
                        <button class="btn btn-primary btn-block" onclick="return comparaClave();">Cargar</button>
                    </div>
                </form>
            </div>
        </div>
        <br>
        <br>
        <div class="row">
                    <div class="col-md-5"></div>
                    <div class="col-md-2"><center><img src="../imagenes/medalfaLogo.png" width=100 alt="Logo"></center></div>
                    <div class="col-md-5"></div>
                    
       </div>
    </body><!-- 
================================================== -->
    <!-- Se coloca al final del documento para que cargue mas rapido -->
    <!-- Se debe de seguir ese orden al momento de llamar los JS -->
    <script src="../js/jquery-1.9.1.js"></script>
    <script src="../js/bootstrap.js"></script>
    <script src="../js/jquery-ui-1.10.3.custom.js"></script>
    <script src="http://crypto-js.googlecode.com/svn/tags/3.1.2/build/rollups/sha1.js"></script>

    <script>
                            function comparaClave() {
                                var pass = document.getElementById('contra').value;
                                var result = ("*" + CryptoJS.SHA1(CryptoJS.SHA1(pass))).toUpperCase();
        <%
            for (int i = 0; i < pass.size(); i++) {
        %>

                                if (result === "<%=pass.get(i)%>") {
                                    alert("Datos correctos");
                                    return true;
                                }
        <%
            }
        %>
                                alert("Datos incorrectos");
                                return false;
                            }
    </script>
</html>


