<?php


session_start();
require_once("../vendor/autoload.php");
require_once("../app/config/config.php");
require_once("../app/functions/functions.php");
$prefixo = '';

// use App\Model\Conexao;
// $Conexao = new Conexao();
// $connection = $Conexao->getConnection();
// $res = $connection->prepare("select * from public.usuario");
// $res->execute();


// $dados = $res->fetchAll(PDO::FETCH_CLASS);
// dd($dados);

//implementar .env
//$ConfigEnv = parse_ini_file('.env');
//dd($ConfigEnv);

//(new \App\Http\Response(200, 'Olá mundo'))->sendResponse();

$objRoute = new App\Http\Router(BASE_HTTP, $prefixo); //adiciona as rotas

$objRoute->run()->sendResponse(); //verifica rota atual
