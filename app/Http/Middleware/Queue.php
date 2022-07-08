<?php

namespace App\Http\Middleware;

use App\Http\Response;
use Exception;

class Queue
{


    /**
     * Mapeamento         
     * @var array
     */
    private static $map = [];

    /**
     * Mapeamento   default
     * @var array
     */
    private static $mapDefault = [];

    /**
     * Fila de Middlewares
     * @var array
     */
    private $middlewares = [];

    /**
     * Funcao de execucao do controllador     
     * @var [Closure]
     */
    private $controller;

    /**
     * Argumentos do controller
     *  @var array
     */
    private $controllerArgs = [];

    public function __construct($middlewares=[], $controller, $controllerArgs)
    {   
        $this->middlewares = $middlewares;        
        
        if(count(self::$mapDefault)){
            $this->middlewares = array_merge(self::$mapDefault, $middlewares);        
        }
        
        $this->controller = $controller;
        $this->controllerArgs = $controllerArgs;
    }

    /**
     * Método responsavel por definir o mapeamento
     * @param [type] $map
     * @return void
     */
    public static function setMap($map){
        self::$map = $map;
    }

    /**
     * Método responsavel por definir o mapeamento default
     * @param [type] $map
     * @return void
     */
    public static function setMapDefault($map){
        self::$mapDefault = $map;
    }

    /**
     * Undocumented function
     *
     * @param [type] $request
     * @return void
     */
    public function next($request){        

        //verifica se a fila esta vazia e executa a porra toda
        if(empty($this->middlewares)){
            
            $class = $this->controller['classe'];
            $function = $this->controller['metodo'];
            $method = $this->controller['method'];
            $class =  'App\\Controller\\' . $class;

            /*
             * TEM QUE SER AQUI POR CAUSA DO __CONSTRUCT
             */
            $_REQUEST['redirect']['messages'] = $this->controllerArgs;                
            
            $Instancia = new $class;               

            if (!method_exists($class, $function)) {
                return new Response(200, 'Método não encontrado!');
            }

            return new Response(200, call_user_func_array([$Instancia, $function], $this->controllerArgs));

        }

        $middleware = array_shift($this->middlewares);

        echo $middleware;
        
        if(!isset(self::$map[$middleware])){
            throw new Exception("Problemas ao processar o middleware" , 500);
        }

        $queue = $this;
        $next = function($request) use ($queue){
            return $queue->next($request);
        };
        
        return (new self::$map[$middleware])->handle($request, $next);

    }
}
