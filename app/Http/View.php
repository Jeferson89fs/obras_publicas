<?php

namespace  App\Http;

class View
{

    public function __construct()
    {
    }

    /*
    * Métogo respoinsavel por retornar o conteudo da view
    */
    private static function getContentView($view, $vars)
    {
        $file = __DIR__ . "/../view/{$view}.php";

        $html = '';
        if (file_exists($file)) {
            ob_start();
            include $file;
            $html  = ob_get_clean();
        }

        return $html;
    }

    /*
    * Métogo respoinsavel por retornar o conteudo renderizado da view
    */
    public static function render($view, $vars = [])
    {
        $contentView = self::getContentView($view, $vars);

        return $contentView;
    }
}
