<?php

namespace App\Http;

use App\Model\Conexao;
use Exception;
use PDOException;
use PDO;

class DB
{
    private $conection;

    private $schema = 'public';

    private $table;

    private $model;

    private $primarykey = '';

    private $sequence = '';

    private  $where = [];

    private  $order = [];
    
    private  $limit;

    private  $paginate;

    private $Query;

    public function getQuery(){
        return $this->Query;
    }


    /**
     * All of the available clause operators.
     *
     * @var string[]
     */
    public $operators = [
        '=', '<', '>', '<=', '>=', '<>', '!=', '<=>',
        'like', 'like binary', 'not like', 'ilike', 'in',
        '&', '|', '^', '<<', '>>', '&~',
        'rlike', 'not rlike', 'regexp', 'not regexp',
        '~', '~*', '!~', '!~*', 'similar to',
        'not similar to', 'not ilike', '~~*', '!~~*',
    ];


    public function __construct()
    {
        $this->conection = (new Conexao)->getConnection();        
        $this->table = $this->model;
    }

    public function schema($schema)
    {
        $this->schema = $schema;
        return $this;
    }

    public function model($model)
    {
        $this->model = $model;
        return $this;
    }

    public function table($table)
    {
        $this->table = $table;
        return $this;
    }

    public function limit($limit)
    {
        $this->limit = $limit;
        return $this;
    }

    public function order($order, $type='DESC')
    {
        $this->order[] = [$order, $type];
        return $this;
    }

    public function setSequence($sequence)
    {
        $this->sequence = $sequence;
        return $this;
    }

    public function getSequence()
    {
        if (!$this->sequence) {
            $this->sequence = strtolower($this->schema . '.' . $this->table . "_" . $this->primaryKey . '_seq');
        }

        return $this->sequence;
    }


    public function primaryKey($key)
    {
        $this->primaryKey = $key;
        return $this;
    }

    public function where($filter, $value, $operator = '=', $boolean='AND')
    {
        $this->where[]  = [$filter, $value, $operator,$boolean];
        return $this;
    }

    public function execute($Query, $params = [])
    {
        try {
            $this->conection->beginTransaction();
            $Statement = $this->conection->prepare($Query);
            $Statement->execute($params);
            $this->conection->commit();

            return $Statement;
        } catch (PDOException $e) {
            $this->conection->rollBack();
            die("Error: " . $e->getMessage());
        }
    }

    public function getNextVal()
    {
        $this->Query = " select nextval('" . $this->getSequence() . "') as id ";
        $Statement = $this->execute($this->Query);
        $result = $Statement->fetch(\PDO::FETCH_OBJ);
        return $result->id;
    }


    public function insert(array $values)
    {
        $values = array_merge([$this->primaryKey => ($this->getNextVal())], $values);

        $fields = array_keys($values);
        $binds  = array_pad([], count($fields), '?');
        $params = array_values($values);

        $this->Query = " insert into " . $this->table . " (" . implode(',', $fields) . " ) values(" . implode(',', $binds) . ")";

        $this->execute($this->Query, $params);
        return $this->conection->lastInsertId();
    }


    public function update($values)
    {

        //$values = $this->model->getAllAtributes();
        $fields = array_keys($values);
        $binds  = array_pad([], count($fields), '?');
        $params = array_values($values);

        $this->Query = " update  " . $this->schema . '.' . $this->table . " set ";

        $this->QueryCol = [];
        foreach ($fields as $c => $v) {
            $this->QueryCol[] = "\n " . $v . " = " . $binds[$c];
        }

        $this->Query .= implode(',', $this->QueryCol);

        $this->Query .= " where " . $this->primaryKey . " = " . $this->model->{$this->primaryKey};

        try {
            $this->execute($this->Query, $params);
            return true;
        } catch (Exception $e) {
            return false;
        }
    }

    public function delete()
    {
        $this->Query = " delete from  " . $this->schema . '.' . $this->table . " where  " . $this->primaryKey . " =  ? ";
        try {
            $this->execute($this->Query, [$this->model->{$this->primaryKey}]);
            return true;
        } catch (Exception $e) {
            return false;
        }
    }


    public function isOperadorValid(string $operador)
    {
        return in_array($operador, $this->operators);
    }

    public function structWhere($column, $operator, $value,$boolean='AND')
    {
        
        if (is_array($value)) {

            $boolean = count($value) > 1 ? 'OR' : 'AND';

            $this->Query = [];
            foreach ($value as $c => $v) {
                $this->Query[] = $boolean . ' ' . $column . ' ' . $operator . ' \'' . $v.'\'';
            }
            return implode(' ', $this->Query);
        }

        return  $boolean . ' ' . $column . ' ' . $operator . ' \'' . $value.'\'';
    }

    public function compileWhere()
    {
        $Arrwhere = [];

        foreach ($this->where  as $where) {
            if (!$this->isOperadorValid($where[2])) {
                throw new Exception("Operador inválido");
            }

            $Arrwhere[] = $this->structWhere($where[0], $where[2], $where[1],$where[3]);
        }

        return implode(' ', $Arrwhere);
    }

    private function compileOrder(){
        $QueryOrder = [];

        if(count($this->order) == 0){
            $QueryOrder[] = "1 DESC";
        }else{
            foreach($this->order as $ordem){
                $QueryOrder[] = " $ordem[0]  $ordem[1]";
            }
        }

        return $this->Query = " order by ".implode(', ',$QueryOrder);
    }

    private function compileLimit(){
        if($this->limit)
            return $this->Query = " limit ".$this->limit;

    }

    public function QueryBuilder($colmns="*"){
        $where = $this->compileWhere();
        $order = $this->compileOrder();
        $limit = $this->compileLimit();

        $sql  = " select {$colmns}";
        $sql .= " from {$this->schema}.{$this->table}";
        $sql .= " where 1=1 ";

        $this->Query  =  $sql;
        $this->Query .=  $where;
        $this->Query .=  $order;
        $this->Query .=  $limit;
        $this->Query .= "\n";

        //echo $this->Query ."\n";

    }

    public function select($colmns = '*')
    {
        $this->QueryBuilder($colmns);

        $Statement = $this->execute($this->Query);

        return  $Statement->fetchAll(PDO::FETCH_CLASS, static::class);
    }
}
