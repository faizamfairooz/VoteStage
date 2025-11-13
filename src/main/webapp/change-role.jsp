<!-- src/main/webapp/change-role.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    String id = request.getParameter("id");
    if (id == null) {
        response.sendRedirect("manage-users");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Change User Role</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #e2e3e5; }
        .container { max-width: 500px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .form-group { margin: 15px 0; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        select, input { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { padding: 10px 20px; background: #17a2b8; color: white; border: none; border-radius: 5px; cursor: pointer; margin: 5px; }
        .btn:hover { background: #138496; }
        .cancel { background: #6c757d; }
        .cancel:hover { background: #545b62; }
    </style>
</head>
<body>
<div class="container">
    <h2>🔄 Change Role for User #<%= id %></h2>
    <form action="change-user-role" method="post">
        <input type="hidden" name="id" value="<%= id %>">

        <div class="form-group">
            <label>New Role:</label>
            <select name="newRole" required>
                <option value="">-- Select New Role --</option>
                <option value="Voter">Voter</option>
                <option value="Contestant">Contestant</option>
                <option value="Judge">Judge</option>
                <option value="Admin">Admin</option>
            </select>
        </div>

        <button type="submit" class="btn">Change Role</button>
        <a href="manage-users" class="btn cancel">Cancel</a>
    </form>
</div>
</body>
</html>