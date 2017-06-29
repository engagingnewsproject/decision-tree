<?php

new Enp\Template\Compile('tree');
$template = new Enp\Template\Render('tree', $name);
echo $template->render();
