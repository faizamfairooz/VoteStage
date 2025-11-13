package com.voting.servlet;

import com.voting.dao.PersonDAO;
import com.voting.model.Person;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/edit-user")
public class EditUserServlet extends HttpServlet {

    // Helper method to check if role can manage users
    private boolean canManageUsers(String role) {
        return "Admin".equals(role) || "ITSupporter".equals(role);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("🔍 EditUserServlet.doGet() called");
        System.out.println("   ➤ Request URI: " + request.getRequestURI());
        System.out.println("   ➤ Query String: " + request.getQueryString());

        try {
            // 1. Check if user is logged in
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                System.out.println("❌ Session invalid - redirecting to login");
                response.sendRedirect("login.jsp");
                return;
            }

            // 2. Check if logged-in user can manage users
            String userRole = (String) session.getAttribute("user_role");
            System.out.println("   ➤ Session user_role: '" + userRole + "'");

            if (userRole == null || !canManageUsers(userRole)) {
                System.out.println("❌ Access denied - insufficient privileges");
                response.sendRedirect("manage-users?error=Access+Denied:+Only+Admins+and+IT+Supporters+can+edit+users.");
                return;
            }

            // 3. Get 'id' parameter from URL
            String idParam = request.getParameter("id");
            System.out.println("   ➤ User ID parameter: " + idParam);

            if (idParam == null || idParam.trim().isEmpty()) {
                System.out.println("❌ Missing user ID parameter");
                response.sendRedirect("manage-users?error=Missing+user+ID");
                return;
            }

            // 4. Validate ID
            String userId = idParam.trim();
            if (userId.isEmpty()) {
                System.out.println("❌ Invalid user ID format: ID is empty");
                response.sendRedirect("manage-users?error=Invalid+user+ID");
                return;
            }

            // 5. Fetch user from database
            Person person = PersonDAO.getPersonById(userId);
            System.out.println("   ➤ Person from DB: " + (person != null ? person.getName() : "null"));

            // 6. Handle user not found
            if (person == null) {
                System.out.println("❌ User not found in database with ID: " + userId);
                response.sendRedirect("manage-users?error=User+not+found+with+ID+" + userId);
                return;
            }

            // 7. Successfully found user - forward to JSP
            System.out.println("✅ Forwarding to edit-user.jsp for user: " + person.getName());
            request.setAttribute("user", person);

            // ✅ Use relative path WITHOUT leading slash
            request.getRequestDispatcher("edit-user.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("🔥 DATABASE ERROR in EditUserServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("manage-users?error=Database+error+-+contact+admin");

        } catch (Exception e) {
            System.err.println("💥 UNEXPECTED ERROR in EditUserServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("manage-users?error=Server+error+-+check+logs");
        }
    }
}