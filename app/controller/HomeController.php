<?php

namespace App\Controller;

use App\Http\Controller;
use App\Http\View;
use App\Controller\AbstractController;

class HomeController extends AbstractController
{

    public function index()
    {
        $args = [];
        return View::render('home/default', $args);        
    }
    
}
