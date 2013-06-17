<?php

print file_get_contents("http://bristol.ins.cwi.nl:31337/export.php?".$_SERVER["QUERY_STRING"]);
