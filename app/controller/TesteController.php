<?php 

namespace App\Controller;

use App\Core\Controller;

class TesteController extends Controller
{
    public function index()
    {
        $this->load('teste/default', [
            'teste' => 'xx'
        ]);
    }

    public function index2($i)
    {

        dd($i);
        $this->load('home/home', [
            'teste' => 'xx'
        ]);
    }
}
