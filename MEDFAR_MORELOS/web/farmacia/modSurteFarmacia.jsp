<%-- 
    Document   : index
    Created on : 07-mar-2014, 15:38:43
    Author     : Americo
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ConectionDB con = new ConectionDB();
    HttpSession sesion = request.getSession();
    String id_usu = "", NombreUsu = "";
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

    if (fol_rec == null) {
        fol_rec = "";
        nom_pac = "";
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

    String cla_uni = "";
    try {
        con.conectar();
        ResultSet rsetUni = con.consulta("select cla_uni from usuarios where id_usu = '" + sesion.getAttribute("id_usu") + "' ");
        while (rsetUni.next()) {
            cla_uni = rsetUni.getString("cla_uni");
        }
        con.cierraConexion();
    } catch (Exception e) {
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
        <%@include file="../jspf/mainMenu.jspf" %>
        <br />
        <div class="container-fluid">

            <div class="row">
                <div class="col-lg-4">
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            Búsqueda de Folios
                        </div>
                        <div class="panel-body">
                            <form method="post">
                                Por Folio:
                                <input type="text" class="form-control" name="fol_rec" />
                                Por Nombre de Derechohabiente:
                                <input type="text" onkeypress="return tabular(event, this);" class="form-control" placeholder="Derechohabiente" name="nom_pac" id="nom_pac" autofocus />
                                <button class="btn btn-success btn-block" type="submit">Buscar</button>
                                <button class="btn btn-warning btn-block" type="submit">Todas</button>
                                <button class="btn btn-info btn-block" type="submit">Actualizar</button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            Folios
                        </div>
                        <div class="panel-body">
                            <%
                                try {
                                    con.conectar();
                                    ResultSet rset = con.consulta("SELECT DISTINCT(fol_rec), nom_com, fecha_hora, id_rec from recetas where fol_rec like '%" + fol_rec + "%' and nom_com like '%" + nom_pac + "%' and transito!=0 and baja=0 and id_tip='1' and cla_uni = '" + cla_uni + "' order by id_rec asc ;");
                                    while (rset.next()) {

                            %>
                            <form action="../Farmacias" id="frmEnviar" name="form_<%=rset.getString(4)%>">
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
                                            <div class="col-sm-2">
                                                <button class="btn btn-block btn-info" type="button" name="imprimir" id="imprimir" value="imprimir" onclick="window.open('../reportes/RecetaFarm.jsp?fol_rec=<%=rset.getString(1)%>&tipo=4&usuario=<%=NombreUsu%>', '', 'width=1200,height=800,left=50,top=50,toolbar=no');">Imprimir</button>                                                         
                                            </div>
                                            <div class="col-sm-2">
                                                <button class="btn btn-block btn-primary" type="submit" name="accion" id="btnSur<%=rset.getString(1)%>" disabled="" value="surtir" onclick="return confirm('Seguro que desea surtir esta receta?')">Surtir</button>
                                            </div>
                                            <div class="col-sm-2">
                                                <button class="btn btn-block btn-danger" type="submit" name="accion" value="cancelar" onclick="return confirm('Seguro que desea cancelar esta receta?')">Cancelar</button>
                                            </div></div>  
                                    </div>
                                </div>
                                <div class="panel-body">
                                    <div class="col-lg-3">
                                        <b>Paciente:</b><br /> <%=rset.getString(2)%> <br>
                                        <b>Fecha y hora:</b><br /><%=df3.format(df2.parse(rset.getString(3)))%>
                                        <br /><%=df1.format(df2.parse(rset.getString(3)))%>
                                    </div>
                                    <div class="col-lg-9">
                                        <table class="table table-bordered">
                                            <tr>

                                                <td>Clave:</td>
                                                <td>Descripcion:</td>
                                                <td>Solicitado:</td>
                                                <td>Surtido:</td>
                                                <td>Lote/Caducidad</td>
                                                <td>Verificar</td>
                                            </tr>
                                            <%
                                                int F_sur = 0;
                                                int c = 0;
                                                //ResultSet rset2 = con.consulta("select cla_pro, des_pro, can_sol, cant_sur, fol_det, lote,DATE_FORMAT(caducidad,'%d/%m/%Y') AS caducidad from recetas where fol_rec = '" + rset.getString(1) + "' and cant_sur!=0 ");
                                                ResultSet rset2 = con.consulta("select cla_pro, des_pro, can_sol, cant_sur, fol_det, lote,DATE_FORMAT(caducidad,'%d/%m/%Y') AS caducidad from recetas where fol_rec = '" + rset.getString(1) + "'  and cant_sur<>0 ");
                                                while (rset2.next()) {
                                                    F_sur = rset2.getInt("cant_sur");
                                            %>
                                            <tr id="trCla<%=rset.getString(1) + "_" + c%>" style="background-color: white">
                                                <td><%=rset2.getString(1)%></td>
                                                <td><%=rset2.getString(2)%></td>                                                        
                                                <td><input type="text" class="form-control" value="<%=rset2.getString(3)%>" name="sol_<%=rset2.getString(5)%>" readonly /></td>
                                                    <%if (F_sur > 0) {%>
                                                <td><input type="text" class="form-control" value="<%=rset2.getString(4)%>" name="sur_<%=rset2.getString(5)%>" /></td>
                                                    <%} else {%>
                                                <td><input type="text" class="form-control" value="<%=rset2.getString(4)%>" name="sur_<%=rset2.getString(5)%>" readonly /></td>
                                                    <%}%>
                                                <td>Lote:&nbsp;<%=rset2.getString(6)%><br />Cadu:&nbsp;<%=rset2.getString(7)%></td>
                                                <td><input type="text" id="txtVeri<%=rset.getString(1) + "_" + c%>" name="txtVeri" class="form-control" onchange="VeriCodBar('<%=rset.getString(1) + "_" + c%>','<%=rset2.getString(1)%>','<%=rset2.getString(6)%>','<%=rset.getString(1)%>')" ></td>
                                            </tr>
                                            <%   c++;
                                                }
                                            %>
                                        </table>

                                        <button class="btn-block btn btn-success" type="submit" name="accion" value="modificar" >Modificar</button>

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

        <!-- 
        ================================================== -->
        <!-- Se coloca al final del documento para que cargue mas rapido -->
        <!-- Se debe de seguir ese orden al momento de llamar los JS -->
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui.js"></script>
        <script type="text/javascript">
                        var cuantas = new Array();
                        function VeriCodBar(num,claPro,lote,folio) {
                            var q=cuantas[folio];
                            if (q<=0 || q===undefined){
                                cuantas[folio]=0;
                            }
                            var cb=$('#txtVeri' + num).val();
                            //  alert(num + "->" + cuantas + "->cod:" + $('#txtVeri' + num).val());
                            var dir="../VerificaCodBar?cb="+cb+"&claPro="+claPro+"&lote="+lote+"&folio="+folio;
                            $.ajax({
                                url: dir,
                                success: function (data) {
                                    var json = JSON.parse(data);
                                    if(json.mensaje==="no"){
                                        alert("Codigo de Barras No Encontrado");
                                        $('#txtVeri' + num).val("");
                                    }else{
                                        $('#trCla' + num).css("background-color", "#4cae4c");
                                        cuantas[folio] =cuantas[folio]+ 1;
                                        var i,j;
                                        i=cuantas[folio];
                                        j=json.cantR;
                                        if(parseInt(i)>=parseInt(j)){
                                            $('#btnSur'+folio).attr("disabled",false);
                                        }
                                       // var n=parseInt(num);
                                        $('#txtVeri' + num).blur();
                                        $('#txtVeri' + num).css("disabled",true);
                                    }
                                },
                                error: function () {
                                    alert("Codigo de Barras No Encontrado+(Err)");
                                }
                            });
                        }
                                                    $(document).ready(function () {
                                                        $("#nom_pac").keyup(function () {
                                                            var nombre2 = $("#nom_pac").val();
                                                            $("#nom_pac").autocomplete({
                                                                source: "../AutoPacientes?nombre=" + nombre2,
                                                                minLength: 2,
                                                                select: function (event, ui) {
                                                                    $("#nom_pac").val(ui.item.nom_com);
                                                                    return false;
                                                                }
                                                            }).data("ui-autocomplete")._renderItem = function (ul, item) {
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

    </body>

</html>

