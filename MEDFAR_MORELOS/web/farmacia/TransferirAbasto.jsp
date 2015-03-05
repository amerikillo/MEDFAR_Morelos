<%-- 
    Document   : TransferirAbasto
    Created on : 25/02/2015, 08:29:41 AM
    Author     : linux9
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ConectionDB con = new ConectionDB();
    HttpSession sesion = request.getSession();
    String id_usu = "", idUni = "", estado = "", ver = "hidden",lote="";
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    if (id_usu == null) {
        //response.sendRedirect("../index.jsp");
    } else {
        try {
            con.conectar();
            ResultSet rs = con.consulta("SELECT DISTINCT u.cla_uni FROM unidades u INNER JOIN usuarios ON usuarios.cla_uni = u.cla_uni "
                    + "WHERE usuarios.id_usu = '" + id_usu + "'");
            if (rs.next()) {
                idUni = rs.getString(1);
            }
        } catch (Exception ex) {
            System.out.println("Error uni->" + ex.getMessage());
        }
    }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="../css/pie-pagina.css" rel="stylesheet" media="screen">
        <link href="../css/topPadding.css" rel="stylesheet">
        <link href="../css/dataTables.bootstrap.css" rel="stylesheet">
        <link href="../css/cupertino/jquery-ui-1.10.3.custom.css" rel="stylesheet">
        <title>Transferencias</title>
    </head>
    <body>
        <%@include file="../jspf/mainMenu.jspf"%>
        <br/>
        <div class="container">
            <form method="post" id="frmEnviar" name="frmEnviar" action="../Transferencias?que=Enviar&uniD=<%=idUni%>">
                <div class="panel">
                    <div class="row">
                        <label class="h2 col-lg-12 text-center text-muted">Transferencias</label>
                        <input type="hidden" id="uniO" name="uniO" value="<%=idUni%>">
                    </div><br/>
                    <div class="row">
                        <label for="cla_pro" class="col-sm-1 control-label">Clave</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" id="cla_pro" name="cla_pro" placeholder="Clave" onkeypress="return tabular(event, this);"  value=""/>
                        </div>
                        <div class="col-sm-1">
                            <button type="button" class="btn btn-block btn-primary" name="btn_clave" id="btn_clave">Clave</button>
                        </div>
                        <label for="des_pro" class="col-sm-1 control-label">Descripción</label>
                        <div class="col-sm-5">
                            <input type="text" class="form-control" id="des_pro" name="des_pro" placeholder="Descripción"  onkeypress="return tabular(event, this);"  value="">
                        </div>
                        <div class="col-sm-2">
                            <button type="button" class="btn btn-block btn-primary" name="btn_descripcion" id="btn_descripcion">Descripción</button>
                        </div>
                    </div><br/>
                    <div class="row">
                        <label for="lote" class="col-sm-1 control-label">Lote</label>
                        <div class="col-sm-2">
                            <select disabled class="form-control" id="lote" name="lote">
                                <option class="text-muted">--Lote--</option>
                            </select>
                        </div>
                        <label for="caduc" class="col-sm-1 control-label">Caducidad</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" id="caduc" name="caduc" readonly value=""/>
                        </div>
                        <label for="origen" class="col-sm-1 control-label">Origen</label>
                        <div class="col-sm-2">
                            <select disabled class="form-control" id="origen" name="origen">
                                <option class="text-muted">Origen</option>
                                <option class="text-muted" value="0">0</option>
                                <option class="text-muted" value="1">1</option>
                                <option class="text-muted" value="2">2</option>         
                            </select>
                        </div>
                    </div><br/>
                    <div class="row">
                        <label for="exis" class="col-sm-1 control-label">Existencias:</label>
                        <div class="col-sm-1">
                            <input type="text" class="form-control" id="exis" name="exis" readonly value=""/>
                        </div>
                        <label for="cant" class="col-sm-2 control-label">Cantidad a Mover</label>
                        <div class="col-sm-2">
                            <input disabled type="number" onkeypress="return isNumberKey(event)" class="form-control" id="cant" name="cant" value=""/>
                        </div>
                        <label for="uni" class="col-sm-2 control-label">Unidad Destino</label>
                        <div class="col-sm-4">
                            <input disabled type="text" class="form-control" id="uni" name="uni">
                        </div>
                    </div><br/>
                    <div class="row">
                        <label for="justi" class="col-sm-1 control-label">Justificación</label>
                        <div class="col-sm-5">
                            <textarea disabled id="justi" name="justi" class="form-control"></textarea>
                        </div>
                    </div><br/>
                    <div class="row">
                        <div class="col-lg-12">
                            <input disabled type="submit" id="btnEnviar" name="btnEnviar" value="Enviar Insumo" class="btn btn-primary center-block">
                        </div>
                    </div>
                </div>
            </form>
            <div class="panel">
                <div class="row">
                    <div class="col-lg-12">
                        <table id="tblSinConfirmar" class="table-bordered">
                            <thead>
                                <tr>
                                    <th class="h3 text-center" colspan="12">Sin Confirmación</th>
                                </tr>
                                <tr>
                                    <th>Clave</th>
                                    <th>Lote</th>
                                    <th>Caducidad</th>
                                    <th>Fecha</th>
                                    <th>Cant.Ant</th>
                                    <th>Cant. Mov</th>
                                    <th>Origen</th>
                                    <th>Uni. Origen</th>
                                    <th>Uni. Destino</th>
                                    <th>Justi</th>
                                    <th>Estado</th>
                                    <th>Acción</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        con.conectar();
                                        ResultSet rs = con.consulta("SELECT DISTINCT t.cla_pro, t.lot_pro, t.cad_pro, t.id_ori, t.cant_ant,  t.cant_mov,u.des_uni AS origen, u2.des_uni AS destino, t.estatus,t.id_trans,t.uni_fuente,justificacion,fecha FROM  unidades AS u INNER JOIN transferencias AS t ON u.cla_uni = t.uni_fuente INNER JOIN unidades AS u2 ON u2.cla_uni = t.uni_destino"
                                                + " WHERE( t.uni_fuente ='" + idUni + "' or t.uni_destino='" + idUni + "')  and t.estatus='0'");
                                        while (rs.next()) {
                                            ResultSet rs2=con.consulta("select lot_pro from detalle_productos where det_pro='"+rs.getString(2)+"'");
                                            if(rs2.next())
                                                lote=rs2.getString(1);
                                            int est = rs.getInt(9);
                                            String uni = rs.getString(11);
                                            if (est == 0 && uni.equals(idUni)) {
                                                estado = "Nuevo";
                                                ver = "hidden";
                                            } else if (est == 0) {
                                                estado = "Solicitado";
                                                ver = "";
                                            }
                                %>
                                <tr>
                                    <td><%=rs.getString(1)%></td>
                                    <td><%=lote%></td>
                                    <td><%=rs.getString(3)%></td>
                                    <td><%=rs.getString(13)%></td>
                                    <td><%=rs.getString(5)%></td>
                                    <td><%=rs.getString(6)%></td>
                                    <td><%=rs.getString(4)%></td>
                                    <td><%=rs.getString(7)%></td>
                                    <td><%=rs.getString(8)%></td>
                                    <td><%=rs.getString(12)%></td>
                                    <td><%=estado%></td>
                                    <td><form method="post" action="../Transferencias?que=estado&idTra=<%=rs.getString(10)%>&detPro=<%=lote%>&uni=<%=idUni%>">
                                            <%if (estado.equals("Nuevo")) {%>
                                            <button class="btn-sm btn-warning" id="btnCancelar" name="Confirmar" title="Cancelar" value="Cancelar">
                                                <span class="glyphicon glyphicon-remove"></span></button>
                                                <%} else {%>
                                            <button class="btn-sm btn-success <%=ver%>" id="btnAceptar" name="Confirmar" title="Aceptar" value="Aceptar">
                                                <span class="glyphicon glyphicon-ok"></span></button>
                                            <button class="btn-sm btn-danger <%=ver%>" id="btnRechazar" name="Confirmar" title="Rechazar" value="Rechazar">
                                                <span class="glyphicon glyphicon-ban-circle"></span></button>
                                                <%}%>
                                        </form>
                                    </td>
                                </tr>
                                <%
                                        }
                                        con.cierraConexion();
                                    } catch (Exception ex) {
                                        System.out.println("Error Conf->" + ex.getMessage());
                                    }
                                %>
                            </tbody>
                        </table><hr/>
                    </div><br/><br/>
                    <div class="row">
                        <div class="col-lg-12">
                            <table id="tblConfirmadas" class="table-bordered">
                                <thead>
                                    <tr>
                                        <th class="h3 text-center" colspan="11">Finalizadas</th>
                                    </tr>
                                    <tr>
                                        <th>Clave</th>
                                        <th>Lote</th>
                                        <th>Caducidad</th>
                                        <th>Fecha</th>
                                        <th>Cant.Ant</th>
                                        <th>Cant. Mov</th>
                                        <th>Origen</th>
                                        <th>Uni. Origen</th>
                                        <th>Uni. Destino</th>
                                        <th>Justi</th>
                                        <th>Estado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try {
                                            con.conectar();
                                            ResultSet rs = con.consulta("SELECT DISTINCT t.cla_pro, t.lot_pro, t.cad_pro, t.id_ori, t.cant_ant,  t.cant_mov,u.des_uni AS origen, u2.des_uni AS destino, t.estatus,justificacion,fecha FROM  unidades AS u INNER JOIN transferencias AS t ON u.cla_uni = t.uni_fuente INNER JOIN unidades AS u2 ON u2.cla_uni = t.uni_destino"
                                                    + " WHERE( t.uni_fuente ='" + idUni + "' or t.uni_destino='" + idUni + "')  and (t.estatus='2' or t.estatus='3' or t.estatus='1')");
                                            while (rs.next()) {
                                                ResultSet rs2=con.consulta("select lot_pro from detalle_productos where det_pro='"+rs.getString(2)+"'");
                                                if(rs2.next())
                                                    lote=rs2.getString(1);
                                                if (rs.getInt(9) == 0) {
                                                    estado = "Nuevo";
                                                } else if (rs.getInt(9) == 1) {
                                                    estado = "Cancelado";
                                                } else if (rs.getInt(9) == 2) {
                                                    estado = "Confirmado";
                                                } else if (rs.getInt(9) == 3) {
                                                    estado = "Rechazado";
                                                }
                                    %>
                                    <tr>
                                        <td><%=rs.getString(1)%></td>
                                        <td><%=lote %></td>
                                        <td><%=rs.getString(3)%></td>
                                        <td><%=rs.getString(11)%></td>
                                        <td><%=rs.getString(5)%></td>
                                        <td><%=rs.getString(6)%></td>
                                        <td><%=rs.getString(4)%></td>
                                        <td><%=rs.getString(7)%></td>
                                        <td><%=rs.getString(8)%></td>
                                        <td><%=rs.getString(10)%></td>
                                        <td><%=estado%></td>
                                    </tr>
                                    <%
                                            }
                                            con.cierraConexion();
                                        } catch (Exception ex) {
                                            System.out.println("Error Conf->" + ex.getMessage());
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui.js"></script>
        <script src="../js/js_transferencias.js"></script>
        <script src="../js/jquery.dataTables.js"></script>
        <script src="../js/dataTables.bootstrap.js"></script>
        <script type="text/javascript">
                                $(document).ready(function () {
                                    $('#tblConfirmadas').dataTable();
                                    $('#tblSinConfirmar').dataTable();
                                    $(function () {
                                        var availableTags = [
            <%  try {
                    con.conectar();
                    try {
                        ResultSet rset = con.consulta("select des_uni from unidades");
                        while (rset.next()) {
                            out.println("'" + rset.getString(1) + "',");
                        }
                    } catch (Exception e) {

                    }
                    con.cierraConexion();
                } catch (Exception e) {

                }
            %>
                                        ];
                                        $("#uni").autocomplete({
                                            source: availableTags
                                        });
                                    });
                                });
                                $(function () {
                                    var availableTags = [
            <%  try {
                    con.conectar();
                    try {
                        ResultSet rset = con.consulta("select des_pro from productos");
                        while (rset.next()) {
                            out.println("'" + rset.getString(1) + "',");
                        }
                    } catch (Exception e) {

                    }
                    con.cierraConexion();
                } catch (Exception e) {

                }
            %>
                                    ];
                                    $("#des_pro").autocomplete({
                                        source: availableTags
                                    });
                                });

        </script>
    </body>
</html>
