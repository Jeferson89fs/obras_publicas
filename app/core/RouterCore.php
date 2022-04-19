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

        /**
         * Limpa a url a partir da config
         */
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
            $route = substr($get['router'],0,-1) == '/' ? substr($get['router'],0,-1) : $get['router'] ;            
            if ($route == '/'.$this->uri && is_callable($get['call'])) {
                $get['call']();
                break;
            }
        }
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
