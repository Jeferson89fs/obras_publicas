<?php

namespace  App\Http;

class RouterDelete extends Router
{
    protected function executeDelete($deleteArr)
    {
        foreach ($deleteArr as $Post) {
            $route = substr($Post['router'], 0, -1) == '/' ? substr($Post['router'], 0, -1) : $Post['router'];

            if ($this->waitingForParameter($route)) {

                $exRoute = explode('/', $route);
                $exParam = explode('/', $this->uri);
                $arrParam = [];

                foreach ($exParam as $chave => $valor) {
                    if (substr($exRoute[$chave + 1], 0, 1) == '{' && substr($exRoute[$chave + 1], -1) == '}') {
                        $arrParam[] = $exParam[$chave];
                    }
                }

                if (count($arrParam) == 0) {
                    (new \App\Controller\MessageController)->message404(
                        'Dados Fornecedos incorretamente',
                        'Parametros Inválidos',
                        404
                    );
                    return;
                }

                $this->executeController($Post, $arrParam); //passando string controller

            } else if ($route == '/' . $this->uri) {
                if (is_callable($Post['call'])) { //se for uma funcao ananima
                    $Post['call']();
                    break;
                } else {
                    $this->executeController($Post); //passando string controller
                    return;
                }
            }
        }
    }
}
