<?php

function dd($param = [], $die = true)
{
    echo "<pre>";
    print_r($param);
    echo "</pre>";

    if ($die) die();
}
