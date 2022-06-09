<?php

namespace App\Controller;

use App\Http\Controller;
use App\Http\Messages;
use App\Http\Request;

abstract class AbstractController extends Controller
{

    protected $request;
    
    protected $Mensagens;

    private $App;

    public function __construct()
    {
        $this->request = new Request;
        $this->loadStructure();
        
        $this->Mensagens = new Messages($_REQUEST);
        
    }

    public function getMessage(){
        return $this->Mensagens;
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
