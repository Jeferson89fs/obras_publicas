<?php

namespace App\Http;

use App\Model\Conexao;
use PDOException;

class DB
{
    private $conection;

    private $table;

    public function __construct()
    {
        $this->conection = (new Conexao)->getConnection();
    }

    public function table($table)
    {
        $this->table = $table;
        return $this;
    }


    public function execute($query, $params = [])
    {
        try {
            $Statement = $this->conection->prepare($query);
            $Statement->execute($params);
            return $Statement;
        } catch (PDOException $e) {
            die("Error: " . $e->getMessage());
        }
    }

    public function insert(array $values)
    {
        $fields = array_keys($values);
        $binds  = array_pad([], count($fields), '?');
        $params = array_values($values);
        $query = " insert into " . $this->table . " (" . implode(',', $fields) . " ) values(" . implode(',', $binds) . ")";

        $this->execute($query, $params);
    }
    

    public function update(array $values)
    {
        $fields = array_keys($values);
        $binds  = array_pad([], count($fields), '?');
        $params = array_values($values);

        $query = " update  " . $this->table . " set ";
        foreach ($fields as $c => $v) {
            $query .= $c . " = " . $binds[$c] . ", \n";
        }

        $this->execute($query, $params);
    }
}
