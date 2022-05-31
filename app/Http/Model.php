<?php

namespace App\Http;

use App\Http\DB;

class Model
{
    private  $db;

    protected $schema;

    protected $table;

    protected $Model;

    protected $primaryKey = 'id';

    protected $fillable = [];

    protected $hidden = [];

    private  $atributes = [];

    private  $result = [];

    public function __construct()
    {
        $this->db = (new DB);
    }

    public function __set($name, $value)
    {
        $this->atributes[$name] = $value;
    }

    public function __get($key)
    {
        return $this->atributes[$key];
    }


    public function getFillable()
    {
        return $this->fillable;
    }

    public function getAllAtributes()
    {
        return $this->atributes;
    }

    public function getResult()
    {
        return $this->result;
    }

    public function where($column, $operator='=' ,$value)
    {
         $this->db->where($column, $value, $operator);

         return $this;
    }

    public function orWhere($column, $operator='=' ,$value )
    {
         $this->db->where($column, $value, $operator,'OR');

         return $this;
    }

    /** 
     * Método respopnsavel por inserir
     */
    public function create()
    {
        $arrAtributes = array_merge($this->fillable, $this->hidden);
        return $this->db->schema($this->schema)->table($this->table)->primaryKey($this->primaryKey)->insert($this->atributes);
    }

    /** 
     * Método respopnsavel por salvar as alteracoes (Update)
     */
    public function save()
    {
        return $this->db
            ->Model($this)
            ->schema($this->schema)
            ->table(
                $this->table
            )->primaryKey($this->primaryKey)->update($this->atributes);
    }

    public function delete()
    {
        return $this->db
            ->Model($this)
            ->schema($this->schema)
            ->table(
                $this->table
            )->primaryKey($this->primaryKey)->delete();
    }

    private function fillObject($result)
    {
        $class = "App\Model\\" . $this->Model;
        $Model = new $class;

        foreach ((array)$result as $c => $v) {
            $Model->$c = $v;
        }

        return $Model;
    }

    /** 
     * Método respopnsavel por pesquisar por chave primária
     */
    public function find(int $params_id)
    {
        $result = $this->db->schema($this->schema)
            ->table($this->table)
            ->primaryKey($this->primaryKey)
            ->where($this->primaryKey, $params_id, '=')
            ->select();

        return $this->fillObject($result[0]);
    }

    /** 
     * Método respopnsavel por pesquisar por chave primária
     */
    public function get()
    {
        return $this->db->schema($this->schema)
            ->table($this->table)
            ->primaryKey($this->primaryKey)            
            ->select();

        //return $this->fillObject($result);
    }
}
