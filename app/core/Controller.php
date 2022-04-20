<?php

namespace App\Core;

class  Controller
{

    protected function load(string $view, $params = [])
    {
        $twig = new \Twig\Environment(
            new \Twig\Loader\FilesystemLoader('../app/view/')
        );

        $twig->addGlobal('BASE' , BASE);
        $twig->addGlobal('BASE_HTTP' , BASE_HTTP);
        echo $twig->render($view . '.php', $params);
    }

}
