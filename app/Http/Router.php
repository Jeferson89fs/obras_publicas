<?php

namespace App\Http;

use Closure;
use Exception;
use ReflectionFunction;

class Router
{
    /**
     * raiz do projeto
     * @var string
     */
    private $url;

    /**
     * prerfixo do projeto
     * @var string
     */
    private $prefix;

    /**
     * grupo do projeto
     * @var $group
     */
    public $group;

    /**
     * inbdice de rotas
     * @var array
     */
    private $routes = [];

    /**
     * @var request
     */
    private $Request;

    public function __construct($url, $prefix = '')
    {
        $this->Request = new Request;
        $this->url = $url;
        $this->prefix = $prefix;

        require("../app/config/Router.php");
    }


    /**
     * Method responsavel por definir um rota GET
     */
    public function get(string $rota, $callMethod, $params = [])
    {
        return $this->addRoute('GET', $rota, $callMethod, $params);
    }


    /**
     * Method responsavel por definir um rota POST
     */
    public function post(string $rota, $callMethod, $params = [])
    {
        return $this->addRoute('POST', $rota, $callMethod, $params);
    }

    /**
     * Method responsavel por definir um rota DELETE
     */
    public function delete(string $rota, $callMethod, $params = [])
    {
        return $this->addRoute('DELETE', $rota, $callMethod, $params);
    }

    /**
     * Method responsavel por definir um rota PUT
     */
    public function put(string $rota, $callMethod, $params = [])
    {
        return  $this->addRoute('PUT', $rota, $callMethod, $params);
    }

    public function group($grupo, $call)
    {
        $this->group =  $grupo ?? '/';
        if ($call instanceof Closure) {
            $call();
        }

        $this->group = '/';
    }


    /**
     * Método responsavel por adicionar a rota
     * @var string $method
     * @var string $rota
     * @var mixed $callMethod
     */
    private function addRoute($method, $route, $callMethod, $params = [])
    {

        $params['variables'] = [];
        $patnerVariable = '/{(.*?)}/';

        if (preg_match_all($patnerVariable, $route, $matches)) {
            $route = preg_replace($patnerVariable, '(.*?)', $route);
            $params['variables'] = $matches[1];
        }

        $patternRoute = '/^' . str_replace('/', '\/', $route) . '$/';

        if ($callMethod instanceof Closure) {
            $params['controller'] = $callMethod;
            // $callMethod();
        } else if (is_string($callMethod)) {

            $controllerMethod  = explode('@', $callMethod);

            // monta um array para chamar o methodo correto
            $params['controller'] = [
                'method' => $method,
                'classe' => $controllerMethod[0],
                'metodo' => $controllerMethod[1],
                'params' => $params
            ];
        }

        //adiciona a rota dentro d aclasse
        $this->routes[$this->group][$patternRoute][$method] = $params;
    }

    /**
     * return Response
     */
    public function run(array $arrParam = [])
    {
        try {

            $route = $this->getRoute();

            if (!isset($route['controller'])) {
                throw new Exception('A URL não pode ser processada!', 500);
            }

            $args = [];

            if (is_array($route['controller'])) {
                $class = $route['controller']['classe'];
                $function = $route['controller']['metodo'];
                $method = $route['controller']['method'];

                $class =  'App\\Controller\\' . $class;

                /*
                 * TEM QUE SER AQUI POR CAUSA DO __CONSTRUCT
                 */
                $_REQUEST['redirect']['messages'] = $arrParam;                
                
                $Instancia = new $class;
                //$arrParam = [];

                if (!method_exists($class, $function)) {
                    return new Response(200, 'Método não encontrado!');
                }

                foreach ($route['controller']['params']['variables'] as $c => $v) {
                    $arrParam[$v] = $route['variables'][$v];
                }

                
                return new Response(200, call_user_func_array([$Instancia, $function], $arrParam));
            } else {
                return new Response(200, $route['controller']());
            }
        } catch (Exception $e) {
            return new Response($e->getCode(), $e->getMessage());
        }
    }

    /**
     * método responsavel por retornar a uri * desconciderando o profeixo e o grupo
     * @return string
     */
    private function getUri()
    {

        $uri = $this->Request->getUri();

        $xUri = strlen($this->prefix) ? explode($this->prefix, $uri) : [$uri];

        //adicionar para remover o grupo
        $ex = explode('/', $uri);
        unset($ex[0]);

        $grupo = $ex[1] ?? '/';


        if (isset($this->routes[$grupo])) {
            $xUri = strlen($grupo) ? explode($grupo, $uri) : [$uri];
        }

        $pos = strpos(end($xUri), '?');
        
        if($pos !== '-1'){
            $ur = explode('?', end($xUri));
            return reset($ur);
        }

        return end($xUri) ?? '/';
    }

    /**
     * Retorna os dados rota atual
     * @return array
     */

    public function redirect($uri, $httpMethod = "GET", array $paramns = [])
    {
        $this->Request->setUri($uri);
        $this->Request->setHttpMethod($httpMethod);

        executar_js("history.pushState({}, null, '" . $this->url . $this->Request->getUri() . "');");

        return $this->run($paramns)->sendResponse();
    }

    private function getRoute()
    {

        $uri = $this->getUri();

        $httpMethod = $this->Request->getHttpMethod();

        foreach ($this->routes as $group => $Routes) {
            foreach ($Routes as $pattern => $methods) {
                if (preg_match($pattern, $uri, $metches)) {

                    if ($methods[$httpMethod]) {
                        //remove a primeira posicao
                        unset($metches[0]);

                        //monta um arrau com as chaves
                        $keys = $methods[$httpMethod]['variables'];

                        //monta um array com as chaves e o metches
                        $methods[$httpMethod]['variables'] = array_combine($keys, $metches);
                        $methods[$httpMethod]['variables']['request'] = $this->Request;

                        return $methods[$httpMethod];
                    }

                    throw new Exception('Método não permitido', '405');
                }
            }
        }

        throw new Exception('Url não Encontrada', '404');
    }
}
