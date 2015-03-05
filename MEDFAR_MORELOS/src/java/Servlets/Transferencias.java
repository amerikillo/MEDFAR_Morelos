/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import Clases.ConectionDB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 *
 * @author linux9
 */
public class Transferencias extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        ConectionDB con = new ConectionDB();
        HttpSession session = request.getSession();
        JSONObject json = new JSONObject();
        JSONArray jsona = new JSONArray();
        ResultSet rs;
        String lote = "";
        String caduc[]=new String[200];
        int c=0;
        try {
            con.conectar();
            if (request.getParameter("que").equals("clave")) {
                rs = con.consulta("SELECT DISTINCT p.des_pro, dp.lot_pro, dp.det_pro, dp.cad_pro, i.cla_uni FROM productos AS p LEFT JOIN detalle_productos AS dp ON dp.cla_pro = p.cla_pro INNER JOIN inventario AS i ON i.det_pro = dp.det_pro "
                        + " WHERE p.cla_pro = '"+request.getParameter("claPro")+"' AND i.cla_uni = '"+request.getParameter("uniO")+"' ORDER BY dp.cad_pro ASC");
                if (rs.next()) {
                    do {
                        json.put("desc", rs.getString(1));
                        caduc[c]=rs.getString(4);
                        lote += "<option value='" + rs.getString(3) + "'>" + rs.getString(2) + "</option>";
                        c++;
                    }while (rs.next());
                }else{
                    json.clear();
                    json.put("desc", "");
                }
                json.put("caduc", caduc[0]);
                json.put("lote", lote);
            }else if(request.getParameter("que").equals("desc")){
                rs = con.consulta("SELECT DISTINCT p.cla_pro, dp.lot_pro, dp.det_pro, dp.cad_pro  FROM productos AS p LEFT JOIN detalle_productos AS dp ON dp.cla_pro = p.cla_pro INNER JOIN inventario AS i ON i.det_pro = dp.det_pro"
                        + " WHERE p.des_pro = '"+request.getParameter("desPro")+"' AND i.cla_uni = '"+request.getParameter("uniO")+"' ORDER BY dp.cad_pro ASC");
                if (rs.next()) {
                    do {
                        json.put("cla", rs.getString(1));
                        caduc[c]=rs.getString(4);
                        lote += "<option value='" + rs.getString(3) + "'>" + rs.getString(2) + "</option>";
                        c++;
                    }while (rs.next());
                }else{
                    json.clear();
                    json.put("cla", "");
                }
                json.put("caduc", caduc[0]);
                json.put("lote", lote);
            }else if(request.getParameter("que").equals("lote")){
                rs=con.consulta("SELECT detalle_productos.cad_pro FROM detalle_productos WHERE detalle_productos.det_pro = '"+request.getParameter("lote")+"'");
                if(rs.next())
                    json.put("caduc",rs.getString(1));
                else
                    json.put("caduc","");
            }else if(request.getParameter("que").equals("origen")){
                rs=con.consulta("SELECT DISTINCT i.cant FROM inventario AS i INNER JOIN detalle_productos AS dp ON dp.det_pro ="
                        + " i.det_pro WHERE dp.det_pro = '"+request.getParameter("detPro")+"' AND dp.id_ori = '"+request.getParameter("origen")+"' and i.cla_uni='"+request.getParameter("uni")+"'");
                if(rs.next())
                    json.put("exis",rs.getString(1));
                else
                    json.put("exis","-");
            }else if(request.getParameter("que").equals("estado")){
                int est=0;
                if(request.getParameter("Confirmar").equals("Aceptar")){
                    est=2;
                    int exis=0,cant=0,cantN,detPro=0,uniF=0,uniD=0,cantN2;
                    rs=con.consulta("SELECT t.det_pro, t.cant_mov, t.cant_ant, t.uni_fuente, t.uni_destino FROM transferencias AS t WHERE t.id_trans = '"+request.getParameter("idTra")+"'");
                    if(rs.next()){
                        detPro=rs.getInt(1);                
                        cant=rs.getInt(2);
                        exis=rs.getInt(3);
                        uniF=rs.getInt(4);
                        uniD=rs.getInt(5);
                    }
                    cantN=exis-cant;    
                    rs=con.consulta("select det_pro, cant from inventario where det_pro='"+detPro+"' and cla_uni='"+uniD+"'");
                    if(rs.next()){
                        exis=rs.getInt("cant");
                        cantN2=exis+cant;
                        con.actualizar("update inventario set cant='"+cantN2+"' where (cla_uni='"+uniD+"' and det_pro='"+detPro+"')");
                    }else{
                        cantN2=cant;
                        con.insertar("INSERT INTO inventario (fec_ela, cla_uni, det_pro, cant) VALUES (now(), '"+uniD+"', '"+detPro+"', '"+cantN2+"')");
                    }
                    con.actualizar("update inventario set cant='"+cantN+"' where (cla_uni='"+uniF+"' and det_pro='"+detPro+"')");   
                    con.actualizar("update transferencias set estatus='"+est+"' where id_trans='"+request.getParameter("idTra")+"'");
                    con.insertar("INSERT INTO kardex (id_kardex, id_rec, det_pro, cant, tipo_mov, fol_aba, fecha, obser, id_usu) VALUES"
                            + " ('0', '0', '"+detPro+"', '"+cantN2+"', 'ENTRADA DE TRANSFERENCIA', '0',NOW(), 'TRANSFERENCIA DESDE "+uniF+" HASTA "+uniD+"', '"+session.getAttribute("id_usu")+"')");
                    con.insertar("INSERT INTO kardex (id_kardex, id_rec, det_pro, cant, tipo_mov, fol_aba, fecha, obser, id_usu) VALUES"
                            + " ('0', '0', '"+detPro+"', '"+cantN+"', 'SALIDA DE TRANSFERENCIA', '0',NOW(), 'TRANSFERENCIA DESDE "+uniF+" HASTA "+uniD+"', '"+session.getAttribute("id_usu")+"')");
                }
                else if(request.getParameter("Confirmar").equals("Rechazar"))
                    est=3;
                else if(request.getParameter("Confirmar").equals("Cancelar"))
                    est=1;
                con.actualizar("update transferencias set estatus='"+est+"' where id_trans='"+request.getParameter("idTra")+"'");
                con.cierraConexion();
                response.sendRedirect("farmacia/TransferirAbasto.jsp");
                
            }else if(request.getParameter("que").equals("Enviar")){
                String uni,justi;
                byte[] a;
                a = request.getParameter("uni").getBytes("ISO-8859-1");
                uni = new String(a, "UTF-8");
                a = request.getParameter("justi").getBytes("ISO-8859-1");
                justi= new String(a, "UTF-8");
                rs=con.consulta("SELECT u.cla_uni FROM unidades AS u WHERE u.des_uni = '"+uni+"'");
                if(rs.next()){
                    uni=rs.getString(1);
                    try{
                        con.insertar("INSERT INTO transferencias (cla_pro, lot_pro, id_ori, cant_ant, cant_mov, uni_fuente, uni_destino, estatus,justificacion,cad_pro,det_pro,fecha) VALUES "
                        + "('"+request.getParameter("cla_pro")+"', '"+request.getParameter("lote")+"', '"+request.getParameter("origen")+"', "
                        + "'"+request.getParameter("exis")+"', '"+request.getParameter("cant")+"', '"+request.getParameter("uniD")+"', '"+uni+"', '0','"+justi+"','"+request.getParameter("caduc")+"','"+request.getParameter("lote")+"',now())");
                        out.println("<script>alert('Insumo Enviado Correctamente');</script>");
                        out.print("<script>window.location.href='farmacia/TransferirAbasto.jsp';</script>");
                    }catch(Exception ex){
                        System.out.println(ex.getMessage());
                        out.println("<script>alert('Error al Enviar(ex)');</script>");
                        out.print("<script>window.location.href='farmacia/TransferirAbasto.jsp';</script>");                      
                    }
                }else{
                    out.println("<script>alert('Error al Enviar(u)');</script>");
                    out.print("<script>window.location.href='farmacia/TransferirAbasto.jsp';</script>");
                }         
            }
            con.cierraConexion();
            jsona.add(json);
            System.out.println(jsona);
            out.println(jsona);
        } catch (SQLException ex) {
            Logger.getLogger(Transferencias.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Eror->"+ex.getMessage());
        } finally {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
