<?php

namespace App\Controller;

use App\Http\Controller;
use App\Http\View;
use App\Controller\AbstractController;

class MenuController extends AbstractController
{

    public function index()
    {
        return View::render('menu/default', $_REQUEST);        
    }


    public function create()
    {
        return View::render('menu/create', $_REQUEST);        
    }
    
}
