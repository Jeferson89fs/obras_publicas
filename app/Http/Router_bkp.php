<?php

namespace App\Http;

use Closure;
use Exception;
//roteador
//gerencia as rotas
class RouterBkp
{

    private $url = '';

    private $prefixo = '';

    private $grupo = [];

    //indice de rotas
    private $routes = [];

    public function __construct($url, $prefixo = '')
    {
        $this->url = $url;
        $this->prefixo = $prefixo;

        require_once("../app/config/Router.php");

        $this->run();
    }

    public function group($grupo, $call)
    {
        $this->grupo = $grupo;
        if ($call instanceof Closure) {
            $x = $call();
            $this->grupo = '/';
        }
    }


    /**
     * Método responsavel por adicionar a rota
     */
    private  function addRoute($method, $route, $controller)
    {
        $this->routes[$method][$this->grupo ?? '/'][$route][] = $controller;

        //$this->run();
    }

    private function is_group($method_atual, $xUri)
    {
        return (isset($this->routes[$method_atual][(trim($xUri[0]) != '' ? $xUri[0] : '/')]));
    }

    private function run()
    {

        $url = substr($_SERVER['HTTP_HOST'], 0);
        $uri = substr($_SERVER['REQUEST_URI'], 1);
        $method_atual = $_SERVER['REQUEST_METHOD'];

        $xUri = strlen($this->prefixo) ? explode($this->prefixo, $uri) : explode('/', $uri);

        if ($this->is_group($method_atual, $xUri)) {
            $group =  trim($xUri[0]) != "" ? $xUri[0] : '/';
            unset($xUri[0]);
            $urlAtual = '/' . $xUri[1];
            unset($xUri[1]);
        } else {
            $group = '/';
            $urlAtual = '/' . implode('/', $xUri);
            unset($xUri[0]);
        }

        $routes = $this->routes;

        try {

            foreach ($routes[$method_atual][$group] as $c => $v) {
                $x = substr($c, 1) == '' ? '/' : '/' . reset(explode('/', substr($c, 1)));

                //pode ser implementado aqui a espera do parametro na urel {param}


                if ($c != $urlAtual) {
                    continue;
                } else {

                    if ($v[0] instanceof Closure) {
                        $v[0]();
                        exit;
                    } else if (is_string(end($v))) {
                        $controllerMethod  = explode('@', end($v));

                        $class = $controllerMethod[0];
                        $method = $controllerMethod[1];

                        if (!isset($class) || !isset($method)) {
                            (new \App\Controller\MessageController)->message404(
                                'Dados Fornecedos incorretamente',
                                'Classe e methodos não especificados corretamente',
                                404
                            );
                            return;
                        }

                        $class =  'App\\Controller\\' . $class;

                        if (!method_exists($class, $method)) {

                            return (new \App\Controller\MessageController)->message404(
                                'Methodo não encontrado',
                                'Não foi encvontrado o método (' . $method . ') na clesse (' . $class . ')',
                                404
                            );

                            return;
                        }

                        //demais parametros da url sao parametros
                        //foi apagado o indice 0 e 1 que é o grupo e o controller                            
                        $arrParam =  $xUri;
                        call_user_func_array([new $class, $method], $arrParam);
                    }
                }
            }
        } catch (Exception $e) {
            throw new Exception($e->getMessage(), $e->getCode());
        }

        exit;
        (new \App\Controller\MessageController)->message404(
            'Rota não encontrada',
            'A rota não existe!',
            500
        );


        return false;
    }

    public function get($route, $controller)
    {
        $this->addRoute('GET', $route, $controller);
    }

    public function post($route, $controller)
    {
        $this->addRoute('POST', $route, $controller);
    }

    public function delete($route, $controller)
    {
        $this->addRoute('DELETE', $route, $controller);
    }
}
