<?php

namespace App\Http\Middleware;

use App\Http\Request;
use App\Http\ConfigEnv;
use App\Http\Response;

class Maintenance{

    /**
     *Méodo responsavel por executar o Middleware
     * @param Request $request
     * @param [Closure] $next
     * @return Response
     */
    public function handle(Request $request, $next){

        if(ConfigEnv::getAttribute('MAINTENANCE')){
            return new Response(200, "Em Manutenção");   
        }

        return $next($request);
        
        
    }
}