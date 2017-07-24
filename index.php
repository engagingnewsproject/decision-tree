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
            $compiled = new \Enp\Database\CompileTree($tree_slug);

            $response->getBody()->write(file_get_contents("data/$tree_slug.json"));
            return $response;
        });

        $this->get('/trees/{tree_slug}/iframe', function (Request $request, Response $response) {

            $tree_slug = $request->getAttribute('tree_slug');
            // check if we have a slug or an id
            if(\Enp\Utility\is_id($tree_slug)) {
                $tree_slug = \Enp\Utility\get_tree_slug_by_id($tree_slug);
            }

            $this->view->render($response, "iframe.php", [
                "tree_slug" => $tree_slug,
                "url"=>TREE_URL
            ]);
        });

        $this->get('/trees/', function (Request $request, Response $response) {
            $DB = new \Enp\Database\DB();
            $trees = $DB->get_trees();

            $response->getBody()->write(json_encode($trees));
            return $response;
        });

        $this->get('/trees/{tree_id}', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $DB = new \Enp\Database\DB();
            $tree = $DB->get_tree($tree_id);

            // format into JSON
            $response->getBody()->write(json_encode($tree));
            return $response;
        });


        $this->get('/trees/{tree_id}/groups/', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            // get all groups from that tree id
            $DB = new \Enp\Database\DB();
            $groups = $DB->get_groups($tree_id);
            // return the JSON
            $response->getBody()->write(json_encode($groups));
            return $response;
        });

        $this->get('/trees/{tree_id}/groups/{group_id}', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $group_id = $request->getAttribute('group_id');

            $DB = new \Enp\Database\DB();
            $group = $DB->get_group($group_id, $tree_id);
            // return the JSON
            $response->getBody()->write(json_encode($group));
            return $response;
        });

        $this->get('/trees/{tree_id}/questions/', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');

            $DB = new \Enp\Database\DB();
            $orderby = 'order';
            $questions = $DB->get_questions($tree_id, $orderby);
            // return the JSON
            $response->getBody()->write(json_encode($questions));
            return $response;
        });

        $this->get('/trees/{tree_id}/questions/{question_id}', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $question_id = $request->getAttribute('question_id');

            $DB = new \Enp\Database\DB();
            $question = $DB->get_question($question_id, $tree_id);
            // return the JSON
            $response->getBody()->write(json_encode($question));
            return $response;
        });

        $this->get('/trees/{tree_id}/questions/{question_id}/options/', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $question_id = $request->getAttribute('question_id');

            $DB = new \Enp\Database\DB();
            $orderby = 'order';
            $options = $DB->get_options($question_id, $tree_id, $orderby);
            // return the JSON
            $response->getBody()->write(json_encode($options));
            return $response;
        });

        $this->get('/trees/{tree_id}/questions/{question_id}/options/{option_id}', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $question_id = $request->getAttribute('question_id');
            $option_id = $request->getAttribute('option_id');

            $DB = new \Enp\Database\DB();
            $option = $DB->get_option($option_id, $question_id, $tree_id);
            // return the JSON
            $response->getBody()->write(json_encode($option));
            return $response;
        });

        $this->get('/trees/{tree_id}/ends/', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');

            $DB = new \Enp\Database\DB();
            $ends = $DB->get_ends($tree_id);
            // return the JSON
            $response->getBody()->write(json_encode($ends));
            return $response;
        });

        $this->get('/trees/{tree_id}/ends/{end_id}', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $end_id = $request->getAttribute('end_id');

            $DB = new \Enp\Database\DB();
            $end = $DB->get_end($end_id, $tree_id);
            // return the JSON
            $response->getBody()->write(json_encode($end));
            return $response;
        });

    });
});


$app->run();
