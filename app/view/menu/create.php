<? require_once(BASE_ROOT . '/app/view/template/template.php'); ?>

<div id="app">
  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <?// dd($_REQUEST['redirect'], false)?>

    <!-- Content Header (Page header) -->
    <section class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1>{{TITULO}}</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Início</a></li>
              <li class="breadcrumb-item active">Menus</li>
            </ol>
          </div>
        </div>
      </div><!-- /.container-fluid -->
    </section>

    <!-- Main content -->
    <section class="content">      
      <div class="container-fluid">
        <div class="row">
          <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
            <a href="/menu" class="btn btn-primary" id="btn_voltar">Voltar</a>
          </div>
          <!-- /.col -->
        </div>

        
        <form id="frmMenu" method="POST" action="/menu/store">

          <div class="row">
            <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
              <div class="form-group">
                <label for="menunome">Nome</label>
                <input name="menunome" id="menunome" type="text" class="form-control obrigatory ">
                <span class=" text-danger "><?=($Mensagens->getError('menunome.required'));?></span>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
              <div class="form-group">
                <label for="menudetalhamento">Detalhes</label>
                <input name="menudetalhamento" id="menudetalhamento" type="text" class="form-control obrigatory">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-12 col-sm-12 col-md-8 col-lg-8 col-xl-8">
              <div class="form-group">
                <label for="menucomando">Menu Comando</label>
                <input name="menucomando" id="menucomando" type="text" class="form-control obrigatory ">
              </div>
            </div>
            <div class="col-12 col-sm-12 col-md-4 col-lg-4 col-xl-4">
              <div class="form-group">
                <label for="ordenacao">Ordem</label>
                <input name="ordenacao" id="ordenacao" type="text" class="form-control ">
              </div>
            </div>
          </div>



          <div class="row">
            <div class="col-12 col-sm-12 col-md-4 col-lg-4 col-xl-4">
              <div class="form-group">
                <label for="ds_icone">Ícone</label>
                <input name="ds_icone" id="ds_icone" type="text" class="form-control ">
              </div>
            </div>
            <div class="col-12 col-sm-12 col-md-8 col-lg-8 col-xl-8">
              <div class="form-group">
                <label for="nm_menu_acao">Identificador Único</label>
                <input name="nm_menu_acao" id="nm_menu_acao" type="text" class="form-control obrigatory ">
              </div>
            </div>
          </div>

          <div class="card-footer">
            <button type="button" class="btn btn-default mr-3">Cancelar</button>
            <button type="submit" class="btn btn-info ml-3">Cadastrar</button>
          </div>
        </form>

        <!-- /.row -->
      </div>
      <!-- /.container-fluid -->
    </section>
    <!-- /.content -->
  </div>
</div>
<? require_once(BASE_ROOT . '/app/view/template/footer.php'); ?>

<script>
  options = {
    el: '#app',
    data: {
      TITULO: 'Cadastro de Menus'
    },
    methods: {
      salvar: function() {
        let form = document.querySelector('#frmMenu');
        var formData = new FormData(form);
        
        var myHeaders = new Headers();
         
        var myInit = { method: 'POST',
               headers: myHeaders,
               body: formData,            
               
               mode: 'cors',
               cache: 'default' };

        fetch(form.getAttribute('action'), myInit)
          .then((response) => response.json())
          .then((data) => {
            //console.log("Success:", data);
          })
          .catch((error) => {
            console.error("Error:", error)
          })
      }

    }
  }


  const vm = new Vue(options);
</script>