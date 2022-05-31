<?php

namespace App\Http;

use App\Model\Conexao;
use Exception;
use PDOException;
use PDO;

class DB
{
    private $conection;

    private $table;

    private $model;

    private $primarykey = '';

    private $sequence = '';

    private  $where = [];


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

    public function execute($query, $params = [])
    {
        try {
            $this->conection->beginTransaction();
            $Statement = $this->conection->prepare($query);
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
        $query = " select nextval('" . $this->getSequence() . "') as id ";
        $Statement = $this->execute($query);
        $result = $Statement->fetch(\PDO::FETCH_OBJ);
        return $result->id;
    }


    public function insert(array $values)
    {
        $values = array_merge([$this->primaryKey => ($this->getNextVal())], $values);

        $fields = array_keys($values);
        $binds  = array_pad([], count($fields), '?');
        $params = array_values($values);

        $query = " insert into " . $this->table . " (" . implode(',', $fields) . " ) values(" . implode(',', $binds) . ")";

        $this->execute($query, $params);
        return $this->conection->lastInsertId();
    }


    public function update($values)
    {

        //$values = $this->model->getAllAtributes();
        $fields = array_keys($values);
        $binds  = array_pad([], count($fields), '?');
        $params = array_values($values);

        $query = " update  " . $this->schema . '.' . $this->table . " set ";

        $queryCol = [];
        foreach ($fields as $c => $v) {
            $queryCol[] = "\n " . $v . " = " . $binds[$c];
        }

        $query .= implode(',', $queryCol);

        $query .= " where " . $this->primaryKey . " = " . $this->model->{$this->primaryKey};

        try {
            $this->execute($query, $params);
            return true;
        } catch (Exception $e) {
            return false;
        }
    }

    public function delete()
    {
        $query = " delete from  " . $this->schema . '.' . $this->table . " where  " . $this->primaryKey . " =  ? ";
        try {
            $this->execute($query, [$this->model->{$this->primaryKey}]);
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

            $query = [];
            foreach ($value as $c => $v) {
                $query[] = $boolean . ' ' . $column . ' ' . $operator . ' \'' . $v.'\'';
            }
            return implode(' ', $query);
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

    public function select($colmns = '*')
    {
        $where = $this->compileWhere();

        $query = "select {$colmns} from {$this->schema}.{$this->table} where 1=1 " . $where;

        echo $query;
        $Statement = $this->execute($query);

        return  $Statement->fetchAll(PDO::FETCH_CLASS, static::class);
    }
}
