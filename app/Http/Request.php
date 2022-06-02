<?php

namespace  App\Http;

use Exception;

class Request
{

    private $httpMethod;

    private $httpRequest;

    private $uri;

    private $queryParameters = [];

    private $postVars = [];

    private $headers = [];

    public function __construct()
    {
        
        if($_SERVER['CONTENT_TYPE'] == 'application/json'){
            foreach((array) json_decode(file_get_contents('php://input', "r")) as $prop => $value){
                $_POST[$prop] = $value;
            }
        }
        
        $this->queryParameters = $_GET;
        $this->postVars = $_POST ?? [];
        $this->headers = getallheaders();
        $this->httpMethod = $_SERVER['REQUEST_METHOD'];
        
        $this->uri = $_SERVER['REQUEST_URI']; // (substr($_SERVER['REQUEST_URI'], strlen($_SERVER['REQUEST_URI']) - 1)) == '/' ? substr($_SERVER['REQUEST_URI'], 0, -1) : $_SERVER['REQUEST_URI'];
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
    }

    /**
     * Get the value of httpMethod
     */
    public function getHttpMethod()
    {
        return $this->httpMethod;
    }


    public function setHttpMethod($httpMethod)
    {
        $this->httpMethod = $httpMethod;
    }

    /**
     * Get the value of httpRequest
     */
    public function getHttpRequest()
    {
        return $this->httpRequest;
    }

    /**
     * Get the value of uri
     */
    public function getUri()
    {
        return $this->uri;
    }

    /**
     * setUri function
     * @param [type] $uri
     * @return void
     */
    public function setUri($uri)
    {
        $this->uri = $uri;
    }

    /**
     * Get the value of queryParameters
     */
    public function getQueryParameters()
    {
        return $this->queryParameters;
    }

    /**
     * Get the value of postVars
     */
    public function getPostVars()
    {
        return $this->postVars;
    }

    /**
     * Get the value of headers
     */
    public function getHeaders()
    {
        return $this->headers;
    }

    private function required($valor=''){
        return trim($valor) != '';
    }

    private function validateColumn($valor, $rules){
        $arrRules = explode('|', $rules);
        $errors = [];
        
        foreach($arrRules as $c => $v){
            $pos = strripos($v,':');
            
            //se nao tem
            if($pos === false){                
                if(method_exists($this, $v)){                    
                    $errors[] = $this->{$v}($valor);
                }else{
                    throw new Exception("Validação não disponível",500);
                }
            }else{
                //dd($pos);
            }                        
        }

        //dd($errors);
    }

    
    /**
     * Undocumented function
     * Funcao responsável por validar os dados
     * @param [type] $rules
     * @return 
     */
    public function validate($rules){
        $errors = [];
        if(count($rules)){
            foreach($rules as  $collumn => $rules){
                $errors[$collumn] = $this->validateColumn($this->getInput($collumn), $rules);                
            }
        }

        return $errors;        
    }
}
