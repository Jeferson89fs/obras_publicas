<?php

namespace App\Controller;

use App\Http\Controller;
use App\Http\View;
use App\Controller\AbstractController;
use App\Http\Response;
use App\Model\Menu;

class MenuController extends AbstractController
{

    public function index()
    {
        return View::render('menu/default', $_REQUEST);
    }


    public function create()
    {

        $Menu = new Menu();
        $Menu = $Menu->find(2);

        $x = $Menu
        ->where('menunome',   '=' , '1')        
        ->orWhere('menunome', 'like' , '%2%')
        ->get();
        //dd($x );


//        dd($Menu , false);

      

       /* 
        $Menu = new Menu();
        $Menu->menunome = 'Menus 3';
        $Menu->menudetalhamento = 'Cadastro de Menus 3';
        $Menu->menucomando = 'menu 3';
        $Menu->menupai = null;
        $Menu->ordenacao = 1;
        $Menu->ds_icone = null;
        $Menu->nm_menu_acao = 'obras_publicas_menu3';
        $Menu->create();

            
        $Menu = new Menu();
        $Menu->menunome = 'Menus 4';
        $Menu->menudetalhamento = 'Cadastro de Menus 4';
        $Menu->menucomando = 'menu 4';
        $Menu->menupai = null;
        $Menu->ordenacao = 1;
        $Menu->ds_icone = null;
        $Menu->nm_menu_acao = 'obras_publicas_menu4';
        $Menu->create();
*/

        dd($Menu);
        

        

        return View::render('menu/create', $_REQUEST);
    }

    public function store()
    {
        $Menu = new Menu();
        $Menu->id = 'xx';

        return json_encode(['teste' => 'teste']);


        //return View::render('menu/create', $_REQUEST);        
    }
}
