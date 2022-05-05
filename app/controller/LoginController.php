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
        if(count($this->error) > 0 ){            
            header("Location: /login",false);
            return false;
        }
        
        $this->load('template/login', []);
    }

    private function validade():void
    {
        if(!$this->request->getInput('nm_email')) 
            $this->setError('Informe o Campo E-mail');
        
        if(!$this->request->getInput('nm_senha')) 
            $this->setError('Informe o Campo Senha');
    }
}
