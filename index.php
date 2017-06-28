<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Gulp Starter</title>
    <link rel='stylesheet' href='dist/css/styles.min.css'/>

</head>
<body>
<?php include('views/header.php');?>
<main>
    <h2>Main content block</h2>
    <?php
    require_once('./vendor/autoload.php');
    // render the template
    new Enp\Template\Compile('tree');
    $template = new Enp\Template\Render('tree', 'citizen');
    echo $template->render();
    /*$renderer = include 'views/tree.php';
    // Render by different data

    echo $renderer($treeData);
    */?>
    <div id="enp-tree__1"></div>
</main>
<footer>
    <h2>Footer</h2>
</footer>

<script src="dist/js/handlebars.runtime.js"></script>
<script src="dist/js/templates.js"></script>

</body>
</html>
