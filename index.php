<?php
namespace Cme;
// allow all sites to access this file
header('Access-Control-Allow-Origin: *');

require 'vendor/autoload.php';

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

$config = [];
$config['displayErrorDetails'] = true;
$config['addContentLengthHeader'] = false;

$app = new \Slim\App(["settings" => $config]);

// Start Laxy CORS //
$app->options('/{routes:.+}', function ($request, $response, $args) {
    return $response;
});

$app->add(function ($req, $res, $next) {
    $response = $next($req, $res);
    return $response
            ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
            ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, OPTIONS');
});
// END Laxy CORS //

// An authentication layer for validating users before passing them through to the route
$app->add(new \App\Authentication());

// register views
$container = $app->getContainer();
$container['view'] = new \Slim\Views\PhpRenderer("views/");

$app->group('/api', function() {
    $this->group('/v1', function() {
        // Trees
        $this->get('/trees', '\App\Trees:getAll');
        $this->post('/trees', '\App\Trees:create');
        $this->get('/trees/{treeID}', '\App\Trees:get');
        $this->put('/trees/{treeID}', '\App\Trees:update');
        $this->delete('/trees/{treeID}', '\App\Trees:delete');
        // Tree Actions/Views
        $this->get('/trees/{treeSlug}/compile', '\App\Trees:compile');
        $this->get('/trees/{treeSlug}/compiled', '\App\Trees:compiled');
        $this->get('/trees/{treeSlug}/iframe', '\App\Trees:iframe');
        // Starts
        $this->get('/trees/{treeID}/starts', '\App\Starts:getAll');
        $this->get('/trees/{treeID}/starts/{startID}', '\App\Starts:get');
        // Groups
        $this->get('/trees/{treeID}/groups', '\App\Groups:getAll');
        $this->get('/trees/{treeID}/groups/{groupID}', '\App\Groups:get');
        // Questions
        $this->get('/trees/{treeID}/questions', '\App\Questions:getAll');
        $this->post('/trees/{treeID}/questions', '\App\Questions:create');
        $this->get('/trees/{treeID}/questions/{questionID}', '\App\Questions:get');
        $this->put('/trees/{treeID}/questions/{questionID}', '\App\Questions:update');
        $this->delete('/trees/{treeID}/questions/{questionID}', '\App\Questions:delete');


        $this->get('/trees/{treeID}/questions/{questionID}/options', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');
            $questionID = $request->getAttribute('questionID');

            $db = new Database\DB();
            $options = $db->getOptions($questionID, ['treeID' => $treeID]);
            // return the JSON
            $response->getBody()->write(json_encode($options));
            return $response;
        });

        $this->get('/trees/{treeID}/questions/{questionID}/options/{optionID}', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');
            $questionID = $request->getAttribute('questionID');
            $optionID = $request->getAttribute('optionID');

            $db = new Database\DB();
            $option = $db->getOption($optionID, ['treeID' => $treeID, 'questionID' => $questionID]);
            // return the JSON
            $response->getBody()->write(json_encode($option));
            return $response;
        });

        // ends
        $this->get('/trees/{treeID}/ends', '\App\Ends:getAll');
        $this->get('/trees/{treeID}/ends/{endID}', '\App\Ends:get');

        // embeds by tree
        $this->get('/trees/{treeID}/embeds', '\App\Embeds:getAllEmbedsByTree');
        $this->get('/trees/{treeID}/embeds/{embedID}', '\App\Embeds:getEmbedByTree');

        // sites
        $this->get('/trees/{treeID}/sites', '\App\Sites:getAll');
        $this->get('/trees/{treeID}/sites/{siteID}', '\App\Sites:get');

        // embeds by site
        $this->get('/sites/{siteID}/embeds', '\App\Embeds:getAllEmbedsBySite');
        $this->get('/sites/{siteID}/embeds/{embedID}', '\App\Embeds:getEmbedBySite');

        // interactions
        $this->post('/interactions', '\App\Interactions:create');

        // interaction types
        $this->get('/interactions/types', '\App\Interactions:getTypes');
        $this->get('/interactions/types/{typeID}', '\App\Interactions:getType');

        // state types
        $this->get('/states/types', '\App\States:getStateTypes');
        $this->get('/states/types/{typeID}', '\App\States:getStateType');

    });
});


$app->run();
