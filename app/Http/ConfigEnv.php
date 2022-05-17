<?php

namespace  App\Http;

class ConfigEnv
{

    public static function getAttribute($name)
    {
        $ConfigEnv = parse_ini_file('.env');
        return ($ConfigEnv[$name]);
    }

    public static function getAll()
    {
        $ConfigEnv = parse_ini_file('.env');
        return $ConfigEnv;
    }
}
