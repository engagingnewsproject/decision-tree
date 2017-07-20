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

        $this->get('/trees/{tree_slug}/columns/', function (Request $request, Response $response) {
            $name = $request->getAttribute('tree_slug');

            // TODO: check if ID or SLUG

            // TODO: IF ID, Find the SLUG


            return $response;
        });
    });
});


$app->run();
