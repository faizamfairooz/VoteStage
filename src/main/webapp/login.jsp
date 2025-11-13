<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="description" content="">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <!-- Title -->
  <title>VOTESTAGE</title>

  <!-- Favicon -->
  <link rel="icon" href="img/core-img/favicon.ico">

  <!-- Stylesheet -->
  <link rel="stylesheet" href="style.css">

</head>

<body>


<!-- ##### Breadcumb Area Start ##### -->
<section class="breadcumb-area bg-img bg-overlay" style="background-image: url(img/bg-img/breadcumb3.jpg);">
  <div class="bradcumbContent">
    <h2>Login</h2>
  </div>
</section>
<!-- ##### Breadcumb Area End ##### -->

<!-- ##### Login Area Start ##### -->
<section class="login-area section-padding-100">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-12 col-lg-8">
        <div class="login-content">
          <h3>Welcome Back</h3>
          <!-- Login Form -->
          <div class="login-form">
            <form action="login" method="post">
              <div class="form-group">
                <label for="email">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
              </div>
              <div class="form-group">
                <label for="password">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
              </div>

              <button type="submit" class="btn oneMusic-btn mt-30">Login</button>
            </form>
            <div class="mt-3 text-center">
              <a href="register.jsp">Don't have an account? Register</a>
            </div>
          </div>
          <% String error = (String) request.getAttribute("error"); %>
          <% if (error != null) { %>
          <div style="color:red;text-align:center;"><%= error %></div>
          <% } %>
        </div>
      </div>
    </div>
  </div>
</section>
<!-- ##### Login Area End ##### -->




</body>

</html>