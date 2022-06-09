<?php

namespace  App\Http;

use Exception;

class Messages
{
    private $messages = [];
    private $typeMessages = [
        'error' => 'Erro',
        'success' => 'Sucesso',
        'info' => 'Informação',
        'alert' => 'Alerta'
    ];



    public function __construct($request = [])
    {
        if (count($request['redirect']['messages']) < 1) {
            return false;
        }

        $this->validaError($request);

        $this->messages = $request['redirect']['messages'];
    }

    private function validaError($request)
    {
        $e = false;        
        foreach ($request['redirect']['messages'] as $erro => $errors) {            
            if (!in_array($erro, array_keys($this->typeMessages))) {
                $e = true;
            }
        }

        if($e === true){
            throw new Exception('Erro não implementado!',500);
        }

        return $e;
    }

    public function getAll()
    {
        return $this->messages;
    }

    public function getError($error = '')
    {
        if($error){
            if(!$this->messages['error'][$error]){
              //  throw new Exception('Erro não encontrado', 500);
            }
            return $this->messages['error'][$error];
        }

        return $this->messages['error'];
    }

    public function getSuccess($success = '')
    {
        if($success){
            if(!$this->messages['success'][$success]){
                throw new Exception('Success não encontrado', 500);
            }
            return $this->messages['success'][$success];
        }
        
        return $this->messages['success'];
    }

    public function getAlert($alert = '')
    {
        if($alert){
            if(!$this->messages['alert'][$alert]){
                throw new Exception('alerta não encontrado', 500);
            }
            return $this->messages['alert'][$alert];
        }
        
        return $this->messages['alert'];
    }

    
    public function getInfo($info = '')
    {
        if($info){
            if(!$this->messages['info'][$info]){
                throw new Exception('informação não encontrado', 500);
            }
            return $this->messages['info'][$info];
        }
        
        return $this->messages['info'];
    }
}
