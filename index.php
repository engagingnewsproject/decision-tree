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
            $minified = $request->getQueryParam('minified', $default = false);
            $ext = ($minified === 'true' ? '.min' : '');

            if(\Enp\Utility\is_id($tree_slug)) {
                $tree_slug = \Enp\Utility\get_tree_slug_by_id($tree_slug);
            }

            $response->getBody()->write(file_get_contents("data/".$tree_slug.$ext.".json"));
            return $response;
        });

        $this->get('/trees/{tree_slug}/compile', function (Request $request, Response $response) {
            $tree_slug = $request->getAttribute('tree_slug');

            if(\Enp\Utility\is_id($tree_slug)) {
                $tree_slug = \Enp\Utility\get_tree_slug_by_id($tree_slug);
            }

            // compile it
            $compiled = new \Enp\Database\CompileTree($tree_slug);

            // return the file that got written
            $response->getBody()->write(file_get_contents("data/".$tree_slug.$ext.".json"));
        });

        $this->get('/trees/{tree_slug}/iframe', function (Request $request, Response $response) {

            $tree_slug = $request->getAttribute('tree_slug');
            $js = $request->getQueryParam('js', $default = 'true');

            // check if we have a slug or an id
            if(\Enp\Utility\is_id($tree_slug)) {
                $tree_slug = \Enp\Utility\get_tree_slug_by_id($tree_slug);
            }
            if($js === 'false') {
                $view_path = 'no-js';
            } else {
                $view_path = 'has-js';
            }
            $this->view->render($response, "iframe/$view_path/index.php", [
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

        $this->get('/trees/{tree_id}/starts/', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            // get all starts from that tree id
            $DB = new \Enp\Database\DB();
            $starts = $DB->get_starts($tree_id);
            // return the JSON
            $response->getBody()->write(json_encode($starts));
            return $response;
        });

        $this->get('/trees/{tree_id}/starts/{start_id}', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $start_id = $request->getAttribute('start_id');

            $DB = new \Enp\Database\DB();
            $start = $DB->get_start($start_id, $tree_id);
            // return the JSON
            $response->getBody()->write(json_encode($start));
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
            $questions = $DB->get_questions($tree_id);
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
            $options = $DB->get_options($question_id, ['tree_id' => $tree_id]);
            // return the JSON
            $response->getBody()->write(json_encode($options));
            return $response;
        });

        $this->get('/trees/{tree_id}/questions/{question_id}/options/{option_id}', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $question_id = $request->getAttribute('question_id');
            $option_id = $request->getAttribute('option_id');

            $DB = new \Enp\Database\DB();
            $option = $DB->get_option($option_id, ['tree_id' => $tree_id, 'question_id' => $question_id]);
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

        $this->get('/trees/{tree_id}/embeds/', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            // TODO: returns array of all embeds that match this tree_id
            $embeds = [[]];
            // return the JSON
            $response->getBody()->write(json_encode($embeds));
            return $response;
        });

        $this->get('/trees/{tree_id}/embeds/{embed_id}', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            $embed_id = $request->getAttribute('embed_id');
            // TODO: returns array of the embed with that embed_id
            $embed = [];
            // return the JSON
            $response->getBody()->write(json_encode($embed));
            return $response;
        });

        // save data
        $this->post('/trees/{tree_id}/response-data/new', function (Request $request, Response $response) {
            $tree_id = $request->getAttribute('tree_id');
            // passed data
            $data = $request->getParsedBody();
            // validate it
            // print_r($data);
            // save it

            // build the response
            $savedData = ['success'=>true,
                          'savedData' => json_decode($data)
                      ];
            // return the JSON
            $response->withStatus(200)
                ->withHeader("Content-Type", "application/json")
                ->write(json_encode($data));
            return $response;
        });


        // Site data
        $this->post('/sites/new', function (Request $request, Response $response) {
            // passed data
            $data = $request->getParsedBody();
            // validate it
            // print_r($data);
            // save it

            // build the response
            $savedData = ['success'=>true,
                          'savedData' => json_decode($data)
                      ];
            // return the JSON
            $response->withStatus(200)
                ->withHeader("Content-Type", "application/json")
                ->write(json_encode($data));
            return $response;
        });

        // returns array of all the sites
        $this->get('/sites/', function (Request $request, Response $response) {
            $sites = [['site_id'=>1, 'feature_finished'=>'nope!']];

            // return the JSON
            $response->getBody()->write(json_encode($sites));
            return $response;
        });

        // returns the site info for that ID
        // @param site_id can be an encoded root url w/o the http://
        $this->get('/sites/{site_id}', function (Request $request, Response $response) {
            $site_id = $request->getAttribute('site_id');
            //TODO: see if the site ID is an ID or a URL

            // return the JSON
            $response->getBody()->write(json_encode($site_id));
            return $response;
        });

        // Returns all embeds on that site
        $this->get('/sites/{site_id}/embeds/', function (Request $request, Response $response) {
            $site_id = $request->getAttribute('site_id');

            // return the JSON
            $response->getBody()->write(json_encode($site_id));
            return $response;
        });

        // Returns a specific embed on that site
        $this->get('/sites/{site_id}/embeds/{embed_id}', function (Request $request, Response $response) {
            $site_id = $request->getAttribute('site_id');
            $embed_id = $request->getAttribute('embed_id');
            // return the JSON
            $response->getBody()->write(json_encode($site_id));
            return $response;
        });

        // Add a new Tree Embed to a site
        $this->post('/sites/{site_id}/embeds/new', function (Request $request, Response $response) {
            $site_id = $request->getAttribute('site_id');
            // passed data
            $data = $request->getParsedBody();
            // validate it
            // print_r($data);
            // save it

            // build the response
            $savedData = ['success'=>true,
                          'savedData' => json_decode($data)
                      ];
            // return the JSON
            $response->withStatus(200)
                ->withHeader("Content-Type", "application/json")
                ->write(json_encode($data));
            return $response;
        });
    });
});


$app->run();
