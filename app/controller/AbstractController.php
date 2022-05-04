<?php

namespace App\Controller;

use App\Http\Controller;
use App\Http\Request;

abstract class AbstractController extends Controller
{

    protected $request;
    

    public function __construct()
    {
        $this->request = new Request;
        //colocar aqui a chamara da sessao

    }
}
