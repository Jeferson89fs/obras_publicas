<?php

namespace App\Http;

class  Controller
{

    protected function load(string $view, $params = [])
    {
        require_once '../app/view/'.$view . '.php';
        // $twig = new \Twig\Environment(
        //     new \Twig\Loader\FilesystemLoader('../app/view/')
        // );
        
        // $twig->addGlobal('BASE' , BASE);
        // $twig->addGlobal('BASE_HTTP' , BASE_HTTP);        
        // $twig->addGlobal('_REQUEST' , $_REQUEST);
        // $twig->addGlobal('Error' , $this->error);
        // echo $twig->render($view . '.php', $params);
    }

}
