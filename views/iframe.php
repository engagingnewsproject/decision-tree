<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Decision Tree - <?php echo $tree_slug;?></title>
    <link rel='stylesheet' href="<?php echo $url;?>/dist/css/base.min.css"/>
</head>
<body class="no-js">
<main>
    <?php
        // on prod this would already be compiled locally and pushed - no compiling on production
        new Enp\Template\Compile('tree');
        $template = new Enp\Template\Render('tree', $tree_slug);
        echo $template->render();
    ?>

</main>

</body>
</html>
