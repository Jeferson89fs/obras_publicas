<?php

namespace App\Core;


class RouterCore
{

    private $uri;
    private $method;
    private $getArr = [];

    public function __construct()
    {
        $this->inicialize();
        require_once("../app/config/config.php");
    }

    private function inicialize()
    {
        $this->method = $_SERVER['REQUEST_METHOD'];

        $uri = $this->normalizeURI(explode('/', $_SERVER['REQUEST_URI']));

        for ($i = 0; $i < UNSET_URI_COUNT; $i++) {
            unset($uri[$i]);
        }

        $this->uri = implode('/', $uri);
        require_once("../app/config/Router.php");
        $this->execute();
    }

    private function execute()
    {
        switch ($this->method) {
            case 'GET':
                $this->executeGet();
                break;
        }
    }

    private function executeGet()
    {
        foreach ($this->getArr as $get) {
            $route = substr($get['router'], 0, -1) == '/' ? substr($get['router'], 0, -1) : $get['router'];

            if ($this->waitingForParameter($route)) {

                $exRoute = explode('/', $route);
                $exParam = explode('/', $this->uri);
                $arrParam = [];

                foreach ($exParam as $chave => $valor) {
                    if (substr($exRoute[$chave + 1], 0, 1) == '{' && substr($exRoute[$chave + 1], -1) == '}') {
                        $arrParam[] =  $exParam[$chave];
                    }
                }

                if (count($arrParam) == 0) {
                    (new \App\Controller\MessageController)->message404(
                        'Dados Fornecedos incorretamente',
                        'Parametros Inválidos',
                        404
                    );
                    return;
                }

                $this->executeController($get, $arrParam); //passando string controller

            } else  if ($route == '/' . $this->uri) {
                if (is_callable($get['call'])) { //se for uma funcao ananima
                    $get['call']();
                    break;
                } else {
                    $this->executeController($get); //passando string controller
                    return;
                }
            }
        }
    }

    private function waitingForParameter($route)
    {
        $padrao = "/^[\/a-z0-9\.\_\-]+";
        $padrao .= "[\/]+";
        $padrao .= "[\{a-z-0-9\.\-\_\}]+";
        $padrao .= "[\/]*";
        $padrao .= "$/i";

        return (preg_match($padrao, $route));
    }


    private function executeController($get, $arrParam = [])
    {
        $ex = explode('@', $get['call']);
        $class = $ex[0];
        $method = $ex[1];
        if (!isset($class) || !isset($method)) {
            (new \App\Controller\MessageController)->message404(
                'Dados Fornecedos incorretamente',
                'Classe e methodos não especificados corretamente',
                404
            );
            return;
        }

        $class =  'App\\Controller\\' . $class;

        if (!class_exists($class)) {

            (new \App\Controller\MessageController)->message404(
                'Controller não encontrado',
                'Não foi possível encontrar o copntraller solicitado',
                404
            );
            return;
        }

        if (!method_exists($class, $method)) {

            (new \App\Controller\MessageController)->message404(
                'Methodo não encontrado',
                'Não foi encvontrado o método (' . $method . ') na clesse (' . $class . ')',
                404
            );
            return;
        }

        call_user_func_array([new $class, $method], $arrParam);
    }


    private function get($router, $call)
    {
        $this->getArr[] = [
            'router' => $router,
            'call' =>    $call
        ];
    }

    private function normalizeURI($arr)
    {
        return array_values(array_filter($arr));
    }
}
