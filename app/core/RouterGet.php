<?php

namespace  App\Core;

class RouterGet extends Router
{
    static protected function executeGet($getArr)
    {        
       
        foreach ($getArr as $get) {
            $route = substr($get['router'], 0, -1) == '/' ? substr($get['router'], 0, -1) : $get['router'];
            
            if (parent::waitingForParameter($route)) {
            
                $exRoute = explode('/', $route);
                $exParam = explode('/', parent::$uri);
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

                self::executeController($get, $arrParam); //passando string controller

            } else if ($route == '/' . self::$uri) {

                if (is_callable($get['call'])) { //se for uma funcao ananima
                    $get['call']();
                    break;
                } else {                    
                    self::executeController($get); //passando string controller
                    return;
                }
            }
        }
    }
}
