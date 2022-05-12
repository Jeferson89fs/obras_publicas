<?php


/*$this->group('admin', function(){    
    $this->get('/',             'HomeController@index_admin');
}); */


// $this->get('/',                 function () {
//     echo 'aa';
// });

$this->get('/',                 'HomeController@index');

$this->get('/login/{id}',       'LoginController@teste');

$this->get('/login',            'LoginController@index');
$this->get('/login/register',   'LoginController@register');
$this->post('/login/access',    'LoginController@access');
