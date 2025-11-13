<!-- add-user.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
  <title>Add New User</title>
  <style>
    body { font-family: Arial; margin: 40px; background: #f8f9fa; }
    .container { max-width: 600px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    .form-group { margin: 15px 0; }
    label { display: block; margin-bottom: 5px; font-weight: bold; }
    input, select { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
    .btn { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; margin: 5px; }
    .btn:hover { background: #0056b3; }
    .cancel { background: #6c757d; }
    .cancel:hover { background: #545b62; }
    h2 { color: #28a745; }
  </style>
</head>
<body>
<div class="container">
  <h2>Add New User</h2>

  <form action="${pageContext.request.contextPath}/add-user" method="post">
    <div class="form-group">
      <label>Name:</label>
      <input type="text" name="name" required>
    </div>

    <div class="form-group">
      <label>Email:</label>
      <input type="email" name="email" required>
    </div>

    <div class="form-group">
      <label>Password:</label>
      <input type="password" name="password" required>
    </div>

    <div class="form-group">
      <label>Role:</label>
      <select name="role" required onchange="toggleFields()">
        <option value="">-- Select Role --</option>
        <option value="Admin">Admin</option>
        <option value="Contestant">Contestant</option>
        <option value="ITSupporter">IT Supporter</option>
        <option value="Judge">Judge</option>
      </select>
    </div>

    <!-- Admin Level -->
    <div class="form-group" id="adminLevelGroup" style="display:none;">
      <label>Admin Level:</label>
      <select name="adminLevel">
        <option value="Support">Support</option>
        <option value="Moderator">Moderator</option>
        <option value="Super">Super</option>
      </select>
    </div>

    <!-- Supporter Level -->
    <div class="form-group" id="supporterLevelGroup" style="display:none;">
      <label>Supporter Level:</label>
      <select name="supporterLevel">
        <option value="Support">Support</option>
        <option value="Moderator">Moderator</option>
        <option value="Super">Super</option>
      </select>
    </div>

    <!-- Contestant Fields -->
    <div class="form-group" id="ageGroup" style="display:none;">
      <label>Age:</label>
      <input type="number" name="age" min="1" max="120">
    </div>

    <div class="form-group" id="genderGroup" style="display:none;">
      <label>Gender:</label>
      <select name="gender">
        <option value="">-- Select --</option>
        <option value="Male">Male</option>
        <option value="Female">Female</option>
        <option value="Other">Other</option>
      </select>
    </div>

    <button type="submit" class="btn">Create User</button>
    <a href="manage-users" class="btn cancel">Cancel</a>
  </form>
</div>

<script>
  function toggleFields() {
    const role = document.querySelector('select[name="role"]').value;
    document.getElementById('adminLevelGroup').style.display = role === 'Admin' ? 'block' : 'none';
    document.getElementById('supporterLevelGroup').style.display = role === 'ITSupporter' ? 'block' : 'none';
    document.getElementById('ageGroup').style.display = role === 'Contestant' ? 'block' : 'none';
    document.getElementById('genderGroup').style.display = role === 'Contestant' ? 'block' : 'none';

  }
</script>
</body>
</html>