<?php

namespace App\Controller;

use App\Http\Controller;
use App\Http\Request;

abstract class AbstractController extends Controller
{

    protected $request;
    
    protected $error  = [];
    

    public function __construct()
    {
        $this->request = new Request;
        //colocar aqui a chamara da sessao

    }

    /**
     * Get the value of error
     */ 
    public function getErrors($error='')
    {    
        return $this->error;
    }

    /**
     * Set the value of error
     *
     * @return  self
     */ 
    public function setError($error)
    {
        array_push($this->error, $error) ;
        return $this;
    }
}
