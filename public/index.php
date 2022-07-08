<?php

use App\Http\DB;
use App\Http\ConfigEnv;

session_start();
require_once("../vendor/autoload.php");
include_once("../app/config/Config.php");
include_once("../app/config/Middleware.php");
include_once("../app/functions/functions.php");
$prefixo =  ConfigEnv::getAttribute('PREFIXO');
$objRoute = new App\Http\Router(BASE_HTTP, $prefixo); //adiciona as rotas

$objRoute->run()->sendResponse(); //verifica rota atual


