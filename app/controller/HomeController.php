<?php

namespace App\Controller;

use App\Http\Controller;

class HomeController extends Controller
{

    public function index_admin($a)
    {
        $this->load('home/default', [
            'teste' => 'xx'
        ]);
    }
    
    public function index_admin3($a)
    {
        $this->load('home/default', [
            'teste' => 'xx'
        ]);
    }
}
