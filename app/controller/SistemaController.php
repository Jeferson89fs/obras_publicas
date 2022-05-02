<?php

namespace App\Controller;

use App\Http\Controller;

class SistemaController extends Controller
{
    public function index()
    {

        dd('sistema controller');
        $this->load('teste/default', [
            'teste' => 'xx'
        ]);
    }

  
}
