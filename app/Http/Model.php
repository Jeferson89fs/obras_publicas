<?php

namespace App\Http;

use App\Http\DB;

class Model
{
    private  $db;

    protected $schema = 'public';

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
        $this->table = $this->table;
        $this->db->table($this->table);
        $this->db->schema($this->schema);
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

    /**
     * where function
     * Método responsável por adicionar where com cláusula AND ao SQL
     * @param [type] $column
     * @param string $operator
     * @param [type] $value
     * @return this
     */
    public function where($column, $operator = '=', $value)
    {
        $this->db->where($column, $value, $operator);

        return $this;
    }

    /**
     * orWhere function
     * Método responsavel por adicionar where com clausua OR ao SQL
     * @param [type] $column
     * @param string $operator
     * @param [type] $value
     * @return void
     */
    public function orWhere($column, $operator = '=', $value)
    {
        $this->db->where($column, $value, $operator, 'OR');

        return $this;
    }

    /**
     * limit function
     * Método responsável por adicionar o Limite de registros ao SQL
     * @param [string] $limit     
     * @return this
     */
    public function limit($limit)
    {
        $this->db->limit($limit);

        return $this;
    }

    /**
     * order function
     * Método responsável por adicionar a Ordem ao SQL
     * @param [type] $order
     * @param string $type
     * @return this
     */
    public function order($order, $type = 'DESC')
    {
        $this->db->order($order, $type);

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

    /**
     *Delete function
     * Método responsável por deletar o registro
     * @return true|false
     */
    public function delete()
    {
        return $this->db
            ->Model($this)
            ->schema($this->schema)
            ->table(
                $this->table
            )->primaryKey($this->primaryKey)->delete();
    }

    /**
     * fillObject function
     * Preenche o objeto
     * @param [type] $result
     * @return Model
     */
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
     * Método respopnsavel por pesquisar
     * montar o sql
     */
    public function get()
    {
        return $this->db->select();

        //return $this->fillObject($result);
    }

    /**
     * dd function
     * Método responsavel por imprimir a query 
     * @return void
     */
    public function dd(){        
        //$this->db->QueryBuilder() ;
        dd($this->db->getQuery());
    }
}
