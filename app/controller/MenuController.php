<?php

namespace App\Controller;

use App\Http\Controller;
use App\Http\View;
use App\Controller\AbstractController;
use App\Http\Response;
use App\Model\Menu;
use App\Http\Request;

class MenuController extends AbstractController
{

    public function index()
    {
        return View::render('menu/default', $_REQUEST);
    }


    public function create($params='')
    {

        dd($_REQUEST, false);
        $Menu = new Menu();
        $Menu->find(1);


        return View::render('menu/create', $_REQUEST);
    }

    public function store()
    {
        $Menu = new Menu();
        $Menu->id = 'xx';

        $errors =  $this->request->validate([
            'menunome'     => 'required',
            'menucomando'  => 'min:3|max:50|required',
            'nm_menu_acao' => 'min:3|max:50|required'
        ]);

        $errors = ['teste' => 'teste error'];

        return redirect('/menu/create',$errors );
        //return json_encode(['teste' => 'teste']);


        //return View::render('menu/create', $_REQUEST);        
    }
}
