<?php

namespace  App\Http;

class RouterGet extends Router
{
    protected static function executeGet($Routes, $uri='/', $arrParam = [])
    {

        dd($Routes);
        
        foreach ($Routes as $urlA => $controllerMethod) {
            foreach ($controllerMethod as $x){
                dd($x);
            }
            $controllerMethod();
            // if(get_class(end($controllerMethod)) == 'Closure'){
            //     echo $uri."\n";
            //     echo $urlA."\n";
            //     if($uri != $urlA) continue;

            //     $controllerMethod();
            // }
            
            
            

            foreach ($controllerMethod as $urix => $method) {
                echo $uri."\n";
                echo $urix."\n";
                exit;
                if(($uri != $urix)) continue;

                if (is_object($controllerMethod) && get_class($controllerMethod) == 'Closure') {                    
                    $method();
                }   
                
                //caso for controlador passado por string
                else if (is_string($method)) {
                   
                    $ex = explode('@', $method);
                    $class = $ex[0];
                    $method = $ex[1];
                    if (!isset($class) || !isset($method)) {
                        (new \App\Controller\MessageController)->message404(
                            'Dados Fornecedos incorretamente',
                            'Classe e methodos não especificados corretamente',
                            404
                        );
                        return;
                    }
            
                    $class =  'App\\Controller\\' . $class;
            
                    if (!class_exists($class)) {
            
                        (new \App\Controller\MessageController)->message404(
                            'Controller não encontrado',
                            'Não foi possível encontrar o copntraller solicitado',
                            404
                        );
                        return;
                    }
            
                    if (!method_exists($class, $method)) {
            
                        (new \App\Controller\MessageController)->message404(
                            'Methodo não encontrado',
                            'Não foi encvontrado o método (' . $method . ') na clesse (' . $class . ')',
                            404
                        );
                        return;
                    }
            
                    call_user_func_array([new $class, $method], $arrParam);
                }
                
                // dd($get['controller'], false);

                //$Controller = $get['controller']; 


                //  dd($Controller);

                //$ex = explode('@', $get['call']);
                //$class = $ex[0];
                //$method = $ex[1];


            }
        }
    }
}
