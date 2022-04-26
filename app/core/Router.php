<?php

namespace App\Core;


class Router 
{

    public static $uri;
    public static $method;
    public static $getArr = [];
    public static $postArr = [];

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

        self::$uri = implode('/', $uri);
        require_once("../app/config/Router.php");
        $this->execute();
    }

    private function execute()
    {
        switch ($this->method) {
            case 'GET':                
                return RouterGet::executeGet($this->getArr);
                break;
            case 'POST':
                return RouterPost::executePost($this->postArr);
                break;
            case 'DELETE':
                return Routerdelete::executeDelete($this->deleteArr);
                break;
        }
    }

    

    public static function waitingForParameter($route)
    {
        $padrao = "/^[\/a-z0-9\.\_\-]+";
        $padrao .= "[\/]+";
        $padrao .= "[\{a-z-0-9\.\-\_\}]+";
        $padrao .= "[\/]*";
        $padrao .= "$/i";

        return (preg_match($padrao, $route));
    }


    public static function executeController($get, $arrParam = [])
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
