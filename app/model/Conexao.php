<?php

namespace App\Model;
use App\Http\ConfigEnv;
use Exception;
use PDO;
use PDOException;

class Conexao{

    private static $conection;
    
    private $driver;
    
    private $name_database;

    private $host;
    
    private $username;
    
    private $password;
    
    private $port;

    public function __construct(){
        $this->driver = ConfigEnv::getAttribute('DB_CONNECTION');
        $this->host = ConfigEnv::getAttribute('DB_HOST');
        $this->port = ConfigEnv::getAttribute('DB_PORT');
        $this->name_database = ConfigEnv::getAttribute('DB_DATABASE');
        $this->username = ConfigEnv::getAttribute('DB_USERNAME');
        $this->password = ConfigEnv::getAttribute('DB_PASSWORD');      
        $this->environment = strtolower(ConfigEnv::getAttribute('DB_ENVIRONMENT'));      
     
        $this->setConection();
    }

    private function setConection(){
        try{
            if (!isset(self::$conection)) {
                return self::$conection = new PDO($this->driver.':host='.$this->host.';dbname='.$this->name_database.';port='.$this->port, $this->username, $this->password);
            }

            return self::$conection;

        }catch(PDOException $e){
            if($this->environment == 'production'){
                throw new Exception('Erro ao conectar o banco de dados');
            }else{
                throw new Exception($e->getMessage());
            }            
        }
    }

    public function getConnection(){
        return self::$conection;
    }




}