<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>AdminLTE 3 | Log in</title>

  <!-- Google Font: Source Sans Pro -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="<?=BASE_HTTP?>fontawesome-free/css/all.min.css">
  <!-- icheck bootstrap -->
  <link rel="stylesheet" href="<?=BASE_HTTP?>plugins/icheck-bootstrap/icheck-bootstrap.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="<?=BASE_HTTP?>dist/css/adminlte.css">
</head>
<body class="hold-transition login-page">
<div class="login-box">
  <div class="login-logo ">
    <a href="<?=BASE_HTTP?>">
        <b class="">SISTEMAS DE OBRAS</b>        
    </a>
  </div>  
  <div class="card">
    <div class="card-body login-card-body">
      <p class="login-box-msg">Faça login para iniciar sua sessão</p>
      <form action="/login/access" method="POST">
        <div class="input-group mb-3">        
          <input type="email" class="form-control" placeholder="E-mail" name="nm_email" value="<?=$_REQUEST['nm_email']?>" >
          <div class="input-group-append">
            <div class="input-group-text">
              <span class="fas fa-envelope"></span>
            </div>
          </div>
          
        </div>
        <div class="input-group mb-3">
          <input type="password" class="form-control" placeholder="Senha"  name="nm_senha"  value="<?=$_REQUEST['nm_senha']?>">
          <div class="input-group-append">
            <div class="input-group-text">
              <span class="fas fa-lock"></span>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-8">
            <div class="icheck-primary">
              <input type="checkbox" id="remember">
              <label for="remember">
                Lembrar-me
              </label>
            </div>
          </div>
          <!-- /.col -->
          <div class="col-4">
            <button type="submit" class="btn btn-primary btn-block">Entrar</button>
          </div>
          <!-- /.col -->
        </div>
      </form>

      <div class="social-auth-links text-center mb-3">
        <p>- OU -</p>
        <a href="#" class="btn btn-block btn-primary">
          <i class="fab fa-facebook mr-2"></i> Entrar usando o facebook
        </a>
        <a href="#" class="btn btn-block btn-danger">
          <i class="fab fa-google-plus mr-2"></i> Entrar usando o Google+
        </a>
      </div>
      <!-- /.social-auth-links -->

      <p class="mb-1">
        <a href="forgot-password.html">Esqueci a minha senha</a>
      </p>
      
      <!-- <p class="mb-0">
        <a href="register.html" class="text-center">Registre uma nova senha</a>
      </p> -->

    </div>
    <!-- /.login-card-body -->
  </div>
</div>
<!-- /.login-box -->

<!-- jQuery -->
<script src="../../plugins/jquery/jquery.min.js"></script>
<!-- Bootstrap 4 -->
<script src="../../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- AdminLTE App -->
<script src="../../dist/js/adminlte.min.js"></script>

<script src="<?=BASE?>/public/js/vue.js"></script>
</body>
</html>
