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
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 *
 * @author Americo
 */
public class RecetaNombre extends HttpServlet {

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

        try {
            DateFormat df2 = new SimpleDateFormat("dd/MM/yyyy");
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            ConectionDB con = new ConectionDB();
            JSONObject json = new JSONObject();
            JSONArray jsona = new JSONArray();
            con.conectar();
            HttpSession sesion = request.getSession(true);
            String folio_sp = request.getParameter("sp_pac");
            String folio_rec = request.getParameter("folio");
            boolean vig=true;
            byte[] a = request.getParameter("nombre_jq").getBytes("ISO-8859-1");
            String nombre = new String(a, "UTF-8");

            System.out.println("nombre *" + nombre + "*");
            if (nombre.equals("")) {
                byte[] b = request.getParameter("select_pac").getBytes("ISO-8859-1");
                nombre = new String(b, "UTF-8");
            }

            System.out.println("nombre *" + nombre + "*");
            String id_rec = "";
            if (folio_rec.equals("")) {
                try {
                    ResultSet rset = con.consulta("select id_rec from indices");
                    while (rset.next()) {
                        id_rec = rset.getString(1);
                    }
                    if (id_rec.equals("")) {
                        con.actualizar("insert into indices (id_rec) values ('2')");
                        id_rec = "1";
                    } else {
                        con.actualizar("update indices set id_rec= '" + (Integer.parseInt(id_rec) + 1) + "' ");
                    }
                    json.put("fol_rec", id_rec);
                    sesion.setAttribute("folio_rec", id_rec);
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
                out.println();
            } else {
                json.put("fol_rec", folio_rec);
                sesion.setAttribute("folio_rec", folio_rec);
            }
            int ban = 0;
            try {
                ResultSet rset = con.consulta("select id_pac, nom_com, sexo, fec_nac, num_afi, ini_vig, fin_vig,expediente from pacientes where nom_com = '" + nombre + "' limit 1 ");
                while (rset.next()) {
                    Date ini_v = df.parse(rset.getString("ini_vig"));
                    Date fin_v = df.parse(rset.getString("fin_vig"));
                    Date f_actual = new Date();
                    if (f_actual.before(fin_v) && f_actual.after(ini_v)) {
                        json.put("mensaje", "ok");
                        vig=true;
                    } else {
                        json.put("mensaje", "ok");
                       // json.put("mensaje", "vig_no_val"); //valida la vigencia
                        vig=false;
                        System.out.println("mal");
                    }
                    ban = 1;
                    sesion.setAttribute("id_pac", rset.getString(1));
                    sesion.setAttribute("nom_com", rset.getString(2));
                    sesion.setAttribute("sexo", rset.getString(3));
                    sesion.setAttribute("fec_nac", df2.format(df.parse(rset.getString(4))));
                    sesion.setAttribute("num_afi", rset.getString(5));
                    sesion.setAttribute("carnet", rset.getString(8));
                    json.put("id_pac", rset.getString(1));
                    json.put("nom_com", rset.getString(2));
                    json.put("sexo", rset.getString(3));
                    json.put("fec_nac", df2.format(df.parse(rset.getString(4))));
                    json.put("num_afi", rset.getString(5));
                    json.put("carnet", rset.getString(8));
                    jsona.add(json);
                    json = new JSONObject();
                }
                if (ban == 0) {
                    json.put("id_pac", "");
                    json.put("nom_com", "");
                    json.put("sexo", "");
                    json.put("fec_nac", "");
                    json.put("num_afi", "");
                    json.put("mensaje", "inexistente");
                    jsona.add(json);
                    json = new JSONObject();
                }
            } catch (Exception e) {
            }
            if(!vig){
                json.put("mensaje", "vig_no_val");
                json.put("id_pac", "");
                json.put("nom_com", "");
                json.put("sexo", "");
                json.put("fec_nac", "");
                json.put("num_afi", "");
                jsona.add(json);
                json = new JSONObject();
            }

            System.out.println((String) sesion.getAttribute("folio_rec"));
            con.cierraConexion();
            out.println(jsona);
            System.out.println(jsona);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        /*String folio_sp = request.getParameter("sp_pac");
         System.out.println(folio_sp);
         out.println(folio_sp);*/
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
