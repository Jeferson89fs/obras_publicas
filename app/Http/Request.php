<?php

use App\Http\Messages;

namespace  App\Http;

use Exception;

class Request
{

    private $httpMethod;

    private $httpRequest;

    private $uri;

    private $queryParameters = [];

    private $postVars = [];

    private $requestVars = [];

    private $headers = [];

    private $Messages;

    public function __construct()
    {
        if ($_SERVER['CONTENT_TYPE'] == 'application/json') {
            foreach ((array) json_decode(file_get_contents('php://input', "r")) as $prop => $value) {
                $_POST[$prop] = $value;
            }
        }

        $this->queryParameters = $_GET;
        $this->postVars = $_POST ?? [];
        $this->requestVars = $_REQUEST ?? [];
        $this->headers = getallheaders();
        $this->httpMethod = $_SERVER['REQUEST_METHOD'];
        $this->uri = $_SERVER['REQUEST_URI']; // (substr($_SERVER['REQUEST_URI'], strlen($_SERVER['REQUEST_URI']) - 1)) == '/' ? substr($_SERVER['REQUEST_URI'], 0, -1) : $_SERVER['REQUEST_URI'];
    }

    public function getInput($nm_campo)
    {
        if ($this->postVars[$nm_campo]) {
            return $this->postVars[$nm_campo];
        }

        if ($this->requestVars[$nm_campo]) {
            return $this->requestVars[$nm_campo];
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

    //'O campo :atributte é obrigató'
    protected function messageValidators($validator)
    {
        switch ($validator) {
            case 'required':
                return ' O campo :attribute é obrigatório!';
            case 'max':
                return ' A quantidade de caracteres deve ser no máximo :value para o campo :attribute!';
            case 'min':
                return ' A quantidade de caracteres deve ser no mínimo :value para o campo :attribute!';
        }
    }

    private function required($valor = '')
    {
        return trim($valor) == '' ? $this->messageValidators('required') : false;
    }

    private function min($valor, $validator)
    {
        return strlen($valor) < $validator  ? $this->messageValidators('min') : false;;
    }

    private function max($valor, $validator)
    {
        return strlen($valor) > $validator  ? $this->messageValidators('max') : false;;
    }

    private function validateColumn($collumn, $rules)
    {
        $value = $this->getInput($collumn);
        $arrRules = explode('|', $rules);
        $errors = [];
        $paramns = [];

        foreach ($arrRules as $c => $v) {
            $pos = strripos($v, ':');
            $method = $pos ? substr($v, 0, $pos) :  $v;
            $validator = $pos ? substr($v, ($pos + 1)) : null;

            if (method_exists($this, $method)) {
                $errors[$collumn . '.' . $method] = $this->{$method}($value, $validator);

                if (($errors[$collumn . '.' . $method]) == false) {
                    unset($errors[$collumn . '.' . $method]);
                } else {
                    $paramns[$collumn . '.' . $method] =  compact('validator', 'value', 'collumn', 'method');
                }
            } else {
                throw new Exception("Validação não disponível", 500);
            }
        }

        return [$errors, $paramns];
    }

    private function handleMessages($errors, $Messages = [], $paramns = [])
    {

        $error = [];
        foreach ($errors as $chave => $rule) {
            $param = $paramns[$chave][reset(array_keys($rule))];
            $rule[reset(array_keys($rule))] = $Messages[reset(array_keys($rule))] ?? $rule[reset(array_keys($rule))];
            $rule[reset(array_keys($rule))] = str_replace(':attribute', $param['collumn'],   $rule[reset(array_keys($rule))]);
            $rule[reset(array_keys($rule))] = str_replace(':value',     $param['validator'], $rule[reset(array_keys($rule))]);

            if ($rule[reset(array_keys($rule))]) array_push($error, $rule);
        }

        return $error;
    }

    /**
     * Undocumented function
     * Funcao responsável por validar os dados
     * @param [type] $rules
     * @return 
     */
    public function validate($rules, $Messages = [])
    {
        $errors = [];
        $paramns = [];
        if (count($rules)) {
            foreach ($rules as  $collumn => $rules) {
                list($errors['error'][], $paramns[]) = $this->validateColumn($collumn, $rules);
            }
        }

        $errors['error'] = $this->handleMessages($errors['error'], $Messages, $paramns);

        //$Messages
        return $errors;
    }
}
