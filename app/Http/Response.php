<?php

namespace  App\Http;

class Response
{
    /**Código do stauts HTTP
     * @var integer
     */
    private $httpcode = 200;

    /**
     * Cabeçalho do response
     * 
     */

    private $Headers = [];

    /**
     * Tipo do conteudo
     * @var string
     */
    private $contentType = 'text/html';

    /**
     * Conteudo do Response
     */
    private $content;

    /**
     * @var integer $httpCode
     * @var mexed $content
     * @var string $contentType
     */
    public function __construct($httpCode, $content, $contentType = 'text/html')
    {
        $this->httpcode    = $httpCode;
        $this->content     = $content;
        $this->setContentType($contentType);
    }

    /**
     * Set tipo do conteudo
     * @param  string  $contentType  
     * @return  self
     */
    public function setContentType(string $contentType)
    {
        $this->contentType = $contentType;
        $this->addHeader('Content-Type', $contentType);
    }

    public function addHeader($key, $value)
    {
        $this->Headers[$key] = $value;
    }

    private function sendHeaders()
    {
        http_response_code($this->httpcode);

        //Enviar Headers
        foreach ($this->Headers as $key => $value) {
            header($key . ': ' . $value);
        }
    }

    /**
     * Método responsavel por enviar a resposta ao usuario
     */
    public function sendResponse()
    {
        $this->sendHeaders();

        switch ($this->contentType) {
            case 'text/html':
                echo $this->content;
                exit;
        }
    }
}
