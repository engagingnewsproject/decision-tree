<?php
// allow all sites to access this file
header('Access-Control-Allow-Origin: *');
require 'vendor/autoload.php';

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;


$config = [];
$config['displayErrorDetails'] = true;
$config['addContentLengthHeader'] = false;

$app = new \Slim\App(["settings" => $config]);

// register views
$container = $app->getContainer();
$container['view'] = new \Slim\Views\PhpRenderer("views/");
$app->group('/api', function() {
    $this->group('/v1', function() {
        $this->get('/trees/{tree_slug}/compiled', function (Request $request, Response $response) {
            $tree_slug = $request->getAttribute('tree_slug');
            if(\Enp\Utility\is_id($tree_slug)) {
                $tree_slug = \Enp\Utility\get_tree_slug_by_id($tree_slug);
            }
            $response->getBody()->write(file_get_contents("data/$tree_slug.json"));

            return $response;
        });

        $this->get('/trees/{tree_slug}/iframe', function (Request $request, Response $response) {

            $tree_slug = $request->getAttribute('tree_slug');

            $this->view->render($response, "iframe.php", [
                "tree_slug" => $tree_slug,
                "url"=>TREE_URL
            ]);
        });

        $this->get('/trees/', function (Request $request, Response $response) {
            header('Content-type: text/javascript');
            $DB = new \ENP\Database\DB();
            $trees = $DB->get_trees();

            return json_encode($trees, JSON_PRETTY_PRINT);
        });

        $this->get('/trees/{tree_id}', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $DB = new \ENP\Database\DB();
            $tree = $DB->get_tree($tree_id);

            // format into JSON
            return json_encode($tree, JSON_PRETTY_PRINT);
        });


        $this->get('/trees/{tree_id}/groups/', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            // get all groups from that tree id
            $DB = new \ENP\Database\DB();
            $groups = $DB->get_groups($tree_id);
            // return the JSON
            return json_encode($groups, JSON_PRETTY_PRINT);
        });

        $this->get('/trees/{tree_id}/groups/{group_id}', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $group_id = $request->getAttribute('group_id');

            $DB = new \ENP\Database\DB();
            $group = $DB->get_group($group_id, $tree_id);
            // return the JSON
            return json_encode($group, JSON_PRETTY_PRINT);
        });

        $this->get('/trees/{tree_id}/questions/', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');

            $DB = new \ENP\Database\DB();
            $questions = $DB->get_questions($tree_id);
            // return the JSON
            return json_encode($questions, JSON_PRETTY_PRINT);
        });

        $this->get('/trees/{tree_id}/questions/{question_id}', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $question_id = $request->getAttribute('question_id');

            $DB = new \ENP\Database\DB();
            $question = $DB->get_question($question_id, $tree_id);
            // return the JSON
            return json_encode($question, JSON_PRETTY_PRINT);
        });

        $this->get('/trees/{tree_id}/options/', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');

            $DB = new \ENP\Database\DB();
            $options = $DB->get_options($tree_id);
            // return the JSON
            return json_encode($options, JSON_PRETTY_PRINT);
        });

        $this->get('/trees/{tree_id}/options/{option_id}', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $option_id = $request->getAttribute('option_id');

            $DB = new \ENP\Database\DB();
            $option = $DB->get_option($option_id, $tree_id);
            // return the JSON
            return json_encode($option, JSON_PRETTY_PRINT);
        });

        $this->get('/trees/{tree_id}/ends/', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');

            $DB = new \ENP\Database\DB();
            $ends = $DB->get_ends($tree_id);
            // return the JSON
            return json_encode($ends, JSON_PRETTY_PRINT);
        });

        $this->get('/trees/{tree_id}/ends/{end_id}', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $end_id = $request->getAttribute('end_id');

            $DB = new \ENP\Database\DB();
            $end = $DB->get_end($end_id, $tree_id);
            // return the JSON
            return json_encode($end, JSON_PRETTY_PRINT);
        });

    });
});


$app->run();
