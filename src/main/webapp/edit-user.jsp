<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.voting.model.Person" %>
<%
    Person user = (Person) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect("manage-users?error=User+not+found");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>✏️ Edit User</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; background: #f8f9fa; }
        .container { max-width: 600px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { color: #007bff; text-align: center; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="email"], input[type="password"] {
            width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;
        }
        .btn { padding: 10px 20px; margin: 5px; text-decoration: none; border-radius: 5px; display: inline-block; }
        .save { background: #28a745; color: white; border: none; cursor: pointer; }
        .cancel { background: #6c757d; color: white; }
        .form-popup { background: #f8d7da; color: #721c24; padding: 10px; border: 1px solid #f5c6cb; border-radius: 5px; margin-bottom: 15px; }
    </style>
</head>
<body>
<div class="container">
    <h1>✏️ Edit User</h1>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="form-popup"><%= error %></div>
    <%
        }
    %>

    <form action="update-user" method="post">
        <input type="hidden" name="id" value="<%= user.getId() %>">

        <div class="form-group">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" value="<%= user.getName() %>" required>
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required>
        </div>

        <div class="form-group">
            <label for="password">Password (leave blank to keep current):</label>
            <input type="password" id="password" name="password">
        </div>

        <button type="submit" class="btn save">💾 Save Changes</button>
        <a href="manage-users" class="btn cancel">❌ Cancel</a>
    </form>
</div>
</body>
</html>