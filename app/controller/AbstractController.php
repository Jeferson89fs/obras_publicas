<?php

namespace App\Controller;

use App\Http\Controller;
use App\Http\Request;

abstract class AbstractController extends Controller
{

    protected $request;
    
    protected $Errors = [];

    private $App;

    public function __construct()
    {
        $this->request = new Request;
        //colocar aqui a chamara da sessao
        $this->loadStructure();
    }


    private function loadStructure(){
        $this->App['Menu'] = $this->loadMenu();
    }


    /**
     * Undocumented function
     * Method responsible for loading menu
     * @return array
     */
    private function loadMenu():array{

        return [];
    }

}
