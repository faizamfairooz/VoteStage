<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Register</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        .form-group { margin: 10px 0; }
        label { display: inline-block; width: 120px; }
        input { width: 250px; padding: 5px; }
        button { padding: 8px 15px; background: #007bff; color: white; border: none; }
    </style>
</head>
<body>
<h2>Register</h2>
<form action="register" method="post">
    <div class="form-group">
        <label>Name:</label>
        <input type="text" name="name" required />
    </div>
    <div class="form-group">
        <label>Email:</label>
        <input type="email" name="email" required />
    </div>
    <div class="form-group">
        <label>Password:</label>
        <input type="password" name="password" required />
    </div>
    <button type="submit">Register</button>
</form>
</body>
</html>