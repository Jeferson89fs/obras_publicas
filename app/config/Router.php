<?php


$this->group('admin', function(){    
    $this->get('/', 'HomeController@index');
});


$this->get('/',                 'HomeController@index');
$this->get('/login',            'LoginController@index');

$this->get('/login/register',   'LoginController@register');
$this->post('/login/access',    'LoginController@access');


$this->get('/menu',             'MenuController@index');
$this->post('/menu',            'MenuController@index');
$this->get('/menu/create',      'MenuController@create');
$this->post('/menu/store',      'MenuController@store');
$this->get('/menu/edit/{id}',   'MenuController@edit');
$this->post('/menu/update',     'MenuController@update');
$this->delete('/menu/destroy',  'MenuController@destroy');
