<?php

namespace App\Controller;

use App\Core\Controller;

class MessageController extends Controller
{

    public function message404(string $title, string $mensage, $code = 404)
    {
        http_response_code($code);
        echo $this->load('message/error', [
            'msg_error' => $mensage,
            'title' => $title
        ]);
    }
}
