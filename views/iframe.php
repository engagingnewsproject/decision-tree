<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Decision Tree - <?php echo $name;?></title>
    <link rel='stylesheet' href="<?php echo $url;?>/dist/css/base.min.css"/>

</head>
<body>
<main>
    <?php
        new Enp\Template\Compile('tree');
        $template = new Enp\Template\Render('tree', $name);
        echo $template->render();
    ?>

</main>

</body>
</html>
