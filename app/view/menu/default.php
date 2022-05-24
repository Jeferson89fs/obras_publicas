<? require_once(BASE_ROOT.'/app/view/template/template.php'); ?>
<div id="app">                  
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
  <!-- Content Header (Page header) -->
  <section class="content-header">
    <div class="container-fluid">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h1>{{TITULO}}</h1>
        </div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="#">Home</a></li>
            <li class="breadcrumb-item active">User Profile</li>
          </ol>
        </div>
      </div>
    </div><!-- /.container-fluid -->
  </section>


  <!-- Main content -->
  <section class="content">
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-12">            
             <a href="/menu/create" class="btn btn-primary" id="btn_cadastrar">Cadastrar</a>
        </div>
        <!-- /.col -->
      </div>
      <!-- /.row -->
    </div>
    <!-- /.container-fluid -->
  </section>
  <!-- /.content -->
</div>
</div>
<? require_once(BASE_ROOT.'/app/view/template/footer.php'); ?>
<script>
    options = {
        el : '#app',
        data : {
            TITULO : 'Cadastro de Menus'         
        },
        methods : {}
    }

    const vm = new Vue(options);
    console.log(vm);

</script>