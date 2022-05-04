<?php

namespace App\Controller;

use App\Http\Controller;
use App\Controller\AbstractController;

class LoginController extends AbstractController
{

    public function index()
    {
        $this->load('template/login', []);
    }

    public function access()
    {
        $this->validade();
        $this->load('template/login', []);
    }

    private function validade(){
        
    }
    
}
