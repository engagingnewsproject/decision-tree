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
        $this->get('/tree/{name}', function (Request $request, Response $response) {
            $name = $request->getAttribute('name');
            $response->getBody()->write(file_get_contents("data/$name.json"));

            return $response;
        });

        $this->get('/tree/{name}/iframe', function (Request $request, Response $response) {
            $name = $request->getAttribute('name');
            $this->view->render($response, "iframe.php", [
                "name" => $name,
                "url"=>TREE_URL
            ]);
        });
    });
});


$app->run();
