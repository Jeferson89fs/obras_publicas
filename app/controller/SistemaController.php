<?php

namespace App\Controller;

use App\Core\Controller;

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
