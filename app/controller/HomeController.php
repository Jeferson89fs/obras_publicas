<?php

namespace App\Controller;

use App\Http\Controller;
use App\Controller\AbstractController;

class HomeController extends AbstractController
{

    public function index()
    {
        $this->load('home/default', [
            'teste' => 'xx'
        ]);
    }
    
}
