<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
%>
<!DOCTYPE html>
<html>
<head>
    <title>ITSuppoter Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f8f9fa; }
        .container { max-width: 900px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { color: #dc3545; }
        .btn { padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 5px; display: inline-block; margin: 5px; }
        .btn:hover { background: #0056b3; }
        .logout { float: right; background: #6c757d; }
        .logout:hover { background: #545b62; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #eee; border-radius: 5px; }
    </style>
</head>
<body>
<div class="container">
    <h1>ITSUPPOTER Dashboard</h1>

    <div class="section">
        <a href="manage-users" class="btn">Manage Users</a>
        <a href="voter-dashboard.jsp" class="btn">Account</a>
        <a href="index.jsp" class="btn logout">Logout</a>
    </div>
</div>
</body>
</html>