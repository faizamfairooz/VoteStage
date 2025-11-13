<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.voting.model.Person" %>
<%
  @SuppressWarnings("unchecked")
  List<Person> allUsers = (List<Person>) request.getAttribute("users");
  if (allUsers == null) {
    allUsers = java.util.Collections.emptyList();
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Manage Users</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 30px; background: #f8f9fa; }
    .container { max-width: 1200px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    h1 { color: #dc3545; text-align: center; }
    table { width: 100%; border-collapse: collapse; margin: 20px 0; }
    th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
    th { background-color: #007bff; color: white; }
    tr:hover { background-color: #f5f5f5; }
    .actions a { margin: 0 5px; padding: 5px 10px; text-decoration: none; border-radius: 3px; }
    .edit { background: #ffc107; color: #212529; }
    .delete { background: #dc3545; color: white; }
    .change-role { background: #17a2b8; color: white; }
    .btn { padding: 8px 15px; background: #28a745; color: white; text-decoration: none; border-radius: 5px; display: inline-block; margin: 10px 0; }
    .logout { float: right; background: #6c757d; }
    .form-popup { background: #fff3cd; padding: 15px; border: 1px solid #ffeaa7; border-radius: 5px; margin: 20px 0; }
  </style>
</head>
<body>
<div class="container">
  <h1>Manage All Users</h1>
  <a href="admin-dashboard.jsp" class="btn">← Back to Dashboard</a>
  <a href="index.jsp" class="btn logout">Logout</a>
  <!-- In manage-users.jsp, inside .container div -->
  <a href="add-user.jsp" class="btn" style="background: #28a745;">Add New User</a>
  <a href="voter-dashboard.jsp" class="btn">Account</a>

  <%
    String message = (String) request.getAttribute("message");
    if (message != null) {
  %>
  <div class="form-popup">
    <strong> <%= message %></strong>
  </div>
  <%
    }
  %>

  <table>
    <thead>
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>Email</th>
      <th>Role</th>
      <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <% for (Person user : allUsers) { %>
    <tr>
      <td><%= user.getId() %></td>
      <td><%= user.getName() %></td>
      <td><%= user.getEmail() %></td>
      <td><strong><%= user.getRole() %></strong></td>
      <td>
        <a href="edit-user?id=<%= user.getId() %>" class="edit">✏️ Edit</a>
        <a href="change-role.jsp?id=<%= user.getId() %>" class="change-role">🔄 Change Role</a>
        <a href="DeleteVoterServlet?user_id=<%= user.getId() %>" class="delete" onclick="return confirm('Are you sure?')">🗑️ Delete</a>
      </td>
    </tr>
    <% } %>
    </tbody>
  </table>


  <p><strong>Total Users: <%= allUsers.size() %></strong></p>
</div>

</body>
</html>