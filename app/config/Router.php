<?php

$this->get('/', function(){
    echo 'home';
    //homeController@index
});

$this->get('/home', function(){
    echo 'aa';
    //'homeController@index'
});