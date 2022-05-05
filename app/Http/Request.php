<?php

namespace  App\Http;

use Exception;

class Request
{

    private $httpRequest;

    private $uri;

    private $queryParameters = [];

    private $postVars = [];

    private $headers = [];

    public function __construct()
    {
        $this->queryParameters = $_GET;
        $this->postVars = $_POST ?? [];
        $this->header = getallheaders();
        $this->uri = $_SERVER[''];
    }

    public function getInput($nm_campo)
    {
        if ($this->postVars[$nm_campo]) {
            return $this->postVars[$nm_campo];
        }
    }

    public function get($nm_campo)
    {
        if ($this->queryParameters[$nm_campo]) {
            return $this->queryParameters[$nm_campo];
        }

        //throw new Exception("Atributo Get não encontrado!", 500);

    }
}
