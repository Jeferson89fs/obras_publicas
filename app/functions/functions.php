<?php

use App\Http\ConfigEnv;

function dd($param = [], $die = true)
{
    echo "<pre>";
    print_r($param);
    echo "</pre>";

    if ($die) die();
}

function redirect($to, array $paramns = [], $httpMethod='GET'){
    $prefixo =  ConfigEnv::getAttribute('PREFIXO');
    $objRoute = new App\Http\Router(BASE_HTTP, $prefixo); //adiciona as rotas    
    return     $objRoute->redirect($to,$httpMethod,$paramns);    
    
}

function executar_js($script){
    echo "<script> ".$script." </script>";
}
