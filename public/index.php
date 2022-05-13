<?php

session_start();
require_once("../vendor/autoload.php");
require_once("../app/config/config.php");
require_once("../app/functions/functions.php");
$prefixo = '';

//(new \App\Http\Response(200, 'Olá mundo'))->sendResponse();

$objRoute = new App\Http\Router(BASE_HTTP, $prefixo); //adiciona as rotas

$objRoute->run()->sendResponse(); //verifica rota atual
