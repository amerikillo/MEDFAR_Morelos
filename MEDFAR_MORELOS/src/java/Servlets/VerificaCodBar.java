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
import org.json.simple.JSONObject;

/**
 *
 * @author linux9
 */
public class VerificaCodBar extends HttpServlet {

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
        ResultSet rs;
        String mensaje;
        int cantR=0;
        try {
            con.conectar();
            rs=con.consulta("SELECT cb.F_Id FROM tb_codigob AS cb WHERE cb.F_Cb = '"+request.getParameter("cb")+"'"
            + " AND cb.F_Clave = '"+request.getParameter("claPro")+"' AND cb.F_Lote = '"+request.getParameter("lote")+"'");
            if(rs.next())
                mensaje="si";
            else{
                mensaje="no";
            }
            rs=con.consulta("SELECT Count(dr.fol_det) FROM detreceta AS dr INNER JOIN receta AS r ON r.id_rec = dr.id_rec "
                    + " WHERE r.fol_rec = '"+request.getParameter("folio")+"' and cant_sur<>0");
            if(rs.next()){
                cantR=rs.getInt(1);
            }
            json.put("mensaje",mensaje);
            json.put("cantR", cantR);
            con.cierraConexion();
            System.out.println(json);
            out.println(json);
        } catch (SQLException ex) {
            Logger.getLogger(VerificaCodBar.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Error-> "+ex.getMessage());
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
