<?php
namespace App\Model;

use App\Http\Model;

class Menu extends Model{

    protected $schema = 'public';

    protected $table = 'menu';

    protected $Model = 'Menu';
    
    protected $primaryKey = 'id_menu';

    protected $fillable = [         
        'menunome',
        'menudetalhamento',
        'menucomando',
        'menupai',
        'ordenacao',
        'ds_icone',
        'nm_menu_acao',
    ];

    protected $hidden = [];

    public function getMessages(){
        return [
                'menunome.required' => 'O conteudo do texto está sendo modificado :attribute :value'
        ];
    }

 

  


}