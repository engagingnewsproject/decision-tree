<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Decision Tree - <?php echo $tree_slug;?></title>
    <link rel='stylesheet' href="<?php echo $url;?>/dist/css/base.min.css"/>

</head>
<body>
<main>
    <?php
    //require_once('src/Database/Database.php');
    $pdo = new Enp\Database\DB();
        // Do a select query to see if we get a returned row
        /*$params = array(
            ":quiz_id" => $quiz_id
        );
        $sql = "SELECT * from ".$pdo->quiz_table." WHERE
                quiz_id = :quiz_id
                AND quiz_is_deleted = 0";
        $stmt = $pdo->query($sql, $params);
        $quiz_row = $stmt->fetch();
        // return the found quiz row
        return $quiz_row;*/
        $params = array(
            ":question_id" => 2
        );
        $sql = "SELECT * from tree_option WHERE question_id = :question_id";
        $stmt = $pdo->query($sql, $params);
        $options = $stmt->fetchAll();

        new Enp\Template\Compile('tree');
        $template = new Enp\Template\Render('tree', $tree_slug);
        echo $template->render();

    ?>

</main>

</body>
</html>
