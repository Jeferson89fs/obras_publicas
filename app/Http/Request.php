<?php

namespace  App\Http;

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
    }
}
