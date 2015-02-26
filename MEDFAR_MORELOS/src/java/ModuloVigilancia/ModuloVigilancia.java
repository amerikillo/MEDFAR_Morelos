/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ModuloVigilancia;

import Clases.ConectionDB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author amerikillo
 */
@WebServlet(name = "ModuloVigilancia", urlPatterns = {"/ModuloVigilancia"})
public class ModuloVigilancia extends HttpServlet {

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
        try {
            try {
                if (request.getParameter("accion").equals("ConfirmarVig")) {

                    con.conectar();
                    byte[] a = request.getParameter("des_uni").getBytes("ISO-8859-1");
                    String des_uni = new String(a, "UTF-8");
                    a = request.getParameter("justi").getBytes("ISO-8859-1");
                    String justi = new String(a, "UTF-8");
                    //byte[] a = request.getParameter("des_pro").getBytes("ISO-8859-1");
                    //String des_pro = (new String(a, "UTF-8"));
                    String cla_uniD = "";
                    ResultSet rset = con.consulta("select cla_uni from unidades where des_uni = '" + des_uni + "' ");
                    while (rset.next()) {
                        cla_uniD = rset.getString("cla_uni");
                    }
                    con.insertar("insert into mod_vig values('" + request.getParameter("cla_uniF") + "','" + cla_uniD + "','" + request.getParameter("id_rec") + "','" + justi + "','0')");
                    con.cierraConexion();
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
                out.println("<script>alert('Error: " + e.getMessage() + "')</script>");
            }
            out.println("<script>window.location='farmacia/modVigilancia.jsp'</script>");
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
