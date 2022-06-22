<?php

namespace App\Controller;

use App\Http\Controller;
use App\Http\View;
use App\Controller\AbstractController;
use App\Http\Response;
use App\Model\Menu;
use App\Http\Request;
use App\Http\Messages;

class MenuController extends AbstractController
{

    public function index()
    {
        $Menu = new Menu();
        $this->request->fillObject($Menu);
        //$Menu = $Menu->fillObject($this->request->getPostVars());
        
        $Menu->paginate();

        return View::render('menu/default', [$_REQUEST, 'Menu' => $Menu]);
    }


    public function create()
    {   
        $Menu = new Menu();
        $Menu->find(1);
        
        return View::render('menu/create', [$_REQUEST, 'Mensagens' => $this->Mensagens]);
    }

    public function store()
    {
        $Menu = new Menu();
        $Menu->id = 'xx';        
        
        $errors =  $this->request->validate([
            'menunome'     => 'required',
            'menucomando'  => 'min:3|max:5|required',
            'nm_menu_acao' => 'min:3|max:5|required'

        ], $Menu->getMessages());

        

        return redirect('/menu/create', $errors);        

        //return View::render('menu/create', $_REQUEST);        
    }
}
