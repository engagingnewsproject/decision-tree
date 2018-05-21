<?php
// allow all sites to access this file
header('Access-Control-Allow-Origin: *');

require 'vendor/autoload.php';

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

$config = [];
$config['displayErrorDetails'] = true;
if(TREE_ENV === 'prod') {
    $config['displayErrorDetails'] = false;
}

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

// register views
$c = $app->getContainer();
$c['view'] = new \Slim\Views\PhpRenderer("views/");

// anytime a throw new Error happens, it'll run through this.

$c['phpErrorHandler'] = function ($c) {
    return function ($request, $response, $error) use ($c) {
        $return = [
            'status'  => 'error',
            'message' => $error->getMessage()
        ];
        return $c['response']
            ->withStatus(500)
            ->withHeader('Content-Type', 'application/json')
            ->write(json_encode($return));
    };
};

// An authentication layer for validating users before passing them through to the route
$app->add(new \Cme\Authentication());

$app->group('/api', function() {
    $this->group('/v1', function() {
        // Trees
        $this->get('/trees', '\Cme\Route\Trees:getAll');
        $this->post('/trees', '\Cme\Route\Trees:create');
        $this->get('/trees/{treeID}', '\Cme\Route\Trees:get');
        $this->put('/trees/{treeID}', '\Cme\Route\Trees:update');
        $this->delete('/trees/{treeID}', '\Cme\Route\Trees:delete');
        // Tree Actions/Views
        $this->get('/trees/{treeSlug}/compile', '\Cme\Route\Trees:compile');
        $this->get('/trees/{treeSlug}/compiled', '\Cme\Route\Trees:compiled');
        $this->get('/trees/{treeSlug}/iframe', '\Cme\Route\Trees:iframe');
        // Starts
        $this->get('/trees/{treeID}/starts', '\Cme\Route\Starts:getAll');
        $this->get('/trees/{treeID}/starts/{startID}', '\Cme\Route\Starts:get');
        // Groups
        $this->get('/trees/{treeID}/groups', '\Cme\Route\Groups:getAll');
        $this->get('/trees/{treeID}/groups/{groupID}', '\Cme\Route\Groups:get');
        // $this->put('/trees/{treeID}/groups/{groupID}/move/{position}', '\Cme\Route\Groups:move');
        // Questions
        $this->get('/trees/{treeID}/questions', '\Cme\Route\Questions:getAll');
        $this->post('/trees/{treeID}/questions', '\Cme\Route\Questions:create');
        $this->get('/trees/{treeID}/questions/{questionID}', '\Cme\Route\Questions:get');
        $this->put('/trees/{treeID}/questions/{questionID}', '\Cme\Route\Questions:update');
        $this->put('/trees/{treeID}/questions/{questionID}/move/{position}', '\Cme\Route\Questions:move');
        $this->delete('/trees/{treeID}/questions/{questionID}', '\Cme\Route\Questions:delete');

        // options
        $this->get('/trees/{treeID}/questions/{questionID}/options', '\Cme\Route\Options:getAll');
        $this->get('/trees/{treeID}/questions/{questionID}/options/{optionID}', '\Cme\Route\Options:get');
        $this->post('/trees/{treeID}/questions/{questionID}/options', '\Cme\Route\Options:create');
        $this->put('/trees/{treeID}/questions/{questionID}/options/{optionID}', '\Cme\Route\Options:update');
        $this->put('/trees/{treeID}/questions/{questionID}/options/{optionID}/move/{position}', '\Cme\Route\Options:move');
        $this->delete('/trees/{treeID}/questions/{questionID}/options/{optionID}', '\Cme\Route\Options:delete');

        // ends
        $this->get('/trees/{treeID}/ends', '\Cme\Route\Ends:getAll');
        $this->get('/trees/{treeID}/ends/{endID}', '\Cme\Route\Ends:get');
        // $this->put('/trees/{treeID}/ends/{endID}/move/{position}', '\Cme\Route\Ends:move');

        // embeds by tree
        $this->get('/trees/{treeID}/embeds', '\Cme\Route\Embeds:getAllEmbedsByTree');
        $this->get('/trees/{treeID}/embeds/{embedID}', '\Cme\Route\Embeds:getEmbedByTree');

        // sites
        $this->get('/trees/{treeID}/sites', '\Cme\Route\Sites:getAll');
        $this->get('/trees/{treeID}/sites/{siteID}', '\Cme\Route\Sites:get');

        // embeds by site
        $this->get('/sites/{siteID}/embeds', '\Cme\Route\Embeds:getAllEmbedsBySite');
        $this->get('/sites/{siteID}/embeds/{embedID}', '\Cme\Route\Embeds:getEmbedBySite');

        // interactions
        $this->post('/interactions', '\Cme\Route\Interactions:create');

        // interaction types
        $this->get('/interactions/types', '\Cme\Route\Interactions:getTypes');
        $this->get('/interactions/types/{typeID}', '\Cme\Route\Interactions:getType');

        // state types
        $this->get('/states/types', '\Cme\Route\States:getStateTypes');
        $this->get('/states/types/{typeID}', '\Cme\Route\States:getStateType');

    });
});


$app->run();
