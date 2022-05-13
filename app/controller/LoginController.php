<?php

namespace App\Controller;

use App\Http\Controller;
use App\Controller\AbstractController;
use App\Http\Error;
use App\Http\View;

class LoginController extends AbstractController
{


    public function index()
    {
        $this->Errors = $_SESSION['errors'];
        unset($_SESSION['errors']);

        //$this->setError(Error::add('nm_email', 'required', 'Informe o Campo E-mail'));
        //$this->setError(Error::add('nm_email', 'required', 'Informe o aaaa'));
        
        //echo '@@@';
        //dd($this->Errors->find('nm_email'));
        
        View::render('template/login', [$_REQUEST]);

        // $this->load('template/login', [
        //                     'teste' => 'teste',    
        //                     'base' => BASE,    
        //          ]);
    }

    public function register(){

    }

    public function access()
    {
      /*  
        $this->validade();
        if (count($this->Errors) > 0) {
            $_SESSION['errors'] = $this;
            header("Location: /login", false);
            return false;
        }

        //$this->load('template/login', []);
        */
    }

    private function validade(): void
    {
        //if(!$this->request->getInput('nm_email')) 
        //  $this->setError('nm_email','Informe o Campo E-mail');

        //if(!$this->request->getInput('nm_senha')) 
        // $this->setError('nm_senha','Informe o Campo Senha');
    }
    private function find($x){

    }
}
