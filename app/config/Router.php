<?php 

$this->get('/',          'HomeController@index');
$this->get('/home',      'HomeController@index');
$this->get('/teste',     'TesteController@index');
$this->get('/teste/{xx}','TesteController@index2');
