<?php

use App\Http\Middleware\Queue as MiddlewareQueue;

//mapear class
MiddlewareQueue::setMap([
    'Maintenance' => \App\Http\Middleware\Maintenance::class
]);

MiddlewareQueue::setMapDefault([
    
]);