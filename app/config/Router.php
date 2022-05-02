<?php 


$this->group('admin', function(){
    
    $this->get('/',function(){
        echo 'teste aqui';
    });

    $this->get('/admin_index1',          'HomeController@index_admin');
    $this->get('/admin_index3',          'HomeController@index_admin3');
    $this->get('/admin_index4',          'HomeController@index_admin4');

});


//$this->get('/',          'HomeController@index');
$this->get('/home',      'HomeController@index');
$this->get('/home1',      'HomeController@index1');
$this->get('/home2',      'HomeController@index2');
//$this->get('/teste',     'TesteController@index');
//$this->get('/teste/{xx}','TesteController@index2');
