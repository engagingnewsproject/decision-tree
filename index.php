<?php
// allow all sites to access this file
header('Access-Control-Allow-Origin: *');

require 'vendor/autoload.php';

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;
use \Cme\Database as Database;

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

// register views
$container = $app->getContainer();
$container['view'] = new \Slim\Views\PhpRenderer("views/");
$app->group('/api', function() {
    $this->group('/v1', function() {
        $this->get('/trees/{treeSlug}/compiled', function (Request $request, Response $response) {
            $treeSlug = $request->getAttribute('treeSlug');
            $minified = $request->getQueryParam('minified', $default = false);
            $ext = ($minified === 'true' ? '.min' : '');

            if(\Cme\Utility\isID($treeSlug)) {
                $treeSlug = \Cme\Utility\getTreeSlugById($treeSlug);
            }

            $response->getBody()->write(file_get_contents("data/".$treeSlug.$ext.".json"));
            return $response;
        });

        $this->get('/trees/{treeSlug}/compile', function (Request $request, Response $response) {
            $treeSlug = $request->getAttribute('treeSlug');

            if(\Cme\Utility\isID($treeSlug)) {
                $treeSlug = \Cme\Utility\getTreeSlugById($treeSlug);
            }

            // compile it
            $compiled = new Database\CompileTree($treeSlug);

            // return the file that got written
            $response->getBody()->write(file_get_contents("data/".$treeSlug.".json"));
        });

        $this->get('/trees/{treeSlug}/iframe', function (Request $request, Response $response) {

            $treeSlug = $request->getAttribute('treeSlug');
            $js = $request->getQueryParam('js', $default = 'true');

            // check if we have a slug or an id
            if(\Cme\Utility\isID($treeSlug)) {
                $treeSlug = \Cme\Utility\getTreeSlugById($treeSlug);
            }
            if($js === 'false') {
                $viewPath = 'no-js';
            } else {
                $viewPath = 'has-js';
            }
            $this->view->render($response, "iframe/$viewPath/index.php", [
                "treeSlug" => $treeSlug,
                "url"=>TREE_URL
            ]);
        });

        $this->get('/trees/', function (Request $request, Response $response) {
            $db = new Database\DB();
            $trees = $db->getTrees();

            $response->getBody()->write(json_encode($trees));
            return $response;
        });

        $this->get('/trees/{treeID}', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');
            $db = new Database\DB();
            $tree = $db->getTree($treeID);

            // format into JSON
            $response->getBody()->write(json_encode($tree));
            return $response;
        });

        $this->get('/trees/{treeID}/starts/', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');
            // get all starts from that tree id
            $db = new Database\DB();
            $starts = $db->getStarts($treeID);
            // return the JSON
            $response->getBody()->write(json_encode($starts));
            return $response;
        });

        $this->get('/trees/{treeID}/starts/{startID}', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');
            $startID = $request->getAttribute('startID');

            $db = new Database\DB();
            $start = $db->getStart($startID, $treeID);
            // return the JSON
            $response->getBody()->write(json_encode($start));
            return $response;
        });

        $this->get('/trees/{treeID}/groups/', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');
            // get all groups from that tree id
            $db = new Database\DB();
            $groups = $db->getGroups($treeID);
            // return the JSON
            $response->getBody()->write(json_encode($groups));
            return $response;
        });

        $this->get('/trees/{treeID}/groups/{groupID}', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');
            $groupID = $request->getAttribute('groupID');

            $db = new Database\DB();
            $group = $db->getGroup($groupID, $treeID);
            // return the JSON
            $response->getBody()->write(json_encode($group));
            return $response;
        });

        $this->get('/trees/{treeID}/questions/', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');

            $db = new Database\DB();
            $questions = $db->getQuestions($treeID);
            // return the JSON
            $response->getBody()->write(json_encode($questions));
            return $response;
        });

        $this->get('/trees/{treeID}/questions/{questionID}', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');
            $questionID = $request->getAttribute('questionID');

            $db = new Database\DB();
            $question = $db->getQuestion($questionID, $treeID);
            // return the JSON
            $response->getBody()->write(json_encode($question));
            return $response;
        });

        $this->get('/trees/{treeID}/questions/{questionID}/options/', function (Request $request, Response $response) {
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

        $this->get('/trees/{treeID}/ends/', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');

            $db = new Database\DB();
            $ends = $db->getEnds($treeID);
            // return the JSON
            $response->getBody()->write(json_encode($ends));
            return $response;
        });

        $this->get('/trees/{treeID}/ends/{endID}', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');
            $endID = $request->getAttribute('endID');

            $db = new Database\DB();
            $end = $db->getEnd($endID, $treeID);
            // return the JSON
            $response->getBody()->write(json_encode($end));
            return $response;
        });

        $this->get('/trees/{treeID}/embeds/', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');
            // TODO: returns array of all embeds that match this treeID
            $embeds = [[]];
            // return the JSON
            $response->getBody()->write(json_encode($embeds));
            return $response;
        });

        $this->get('/trees/{treeID}/embeds/{embedID}', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');
            $embedID = $request->getAttribute('embedID');
            // TODO: returns array of the embed with that embedID
            $embed = [];
            // return the JSON
            $response->getBody()->write(json_encode($embed));
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
            $sites = [['siteID'=>1, 'feature_finished'=>'nope!']];

            // return the JSON
            $response->getBody()->write(json_encode($sites));
            return $response;
        });

        // returns the site info for that ID
        // @param siteID can be an encoded root url w/o the http://
        $this->get('/sites/{siteID}', function (Request $request, Response $response) {
            $siteID = $request->getAttribute('siteID');

            $db = new Database\DB();
            //TODO: see if the site ID is an ID or a URL
            $site = $db->getSite($siteID);
            // return the JSON
            $response->getBody()->write(json_encode($site));
            return $response;
        });

        // Returns all embeds on that site
        $this->get('/sites/{siteID}/embeds/', function (Request $request, Response $response) {
            $siteID = $request->getAttribute('siteID');
            $db = new Database\DB();
            //TODO: see if the site ID is an ID or a URL
            $embeds = $db->getEmbedsBySite($siteID);
            // return the JSON
            $response->getBody()->write(json_encode($embeds));
            return $response;
        });

        // Returns a specific embed on that site
        $this->get('/sites/{siteID}/embeds/{embedID}', function (Request $request, Response $response) {
            $siteID = $request->getAttribute('siteID');
            $embedID = $request->getAttribute('embedID');

            $db = new Database\DB();
            $embed = $db->getEmbed($embedID, ['siteID'=>$siteID]);
            // return the JSON
            $response->getBody()->write(json_encode($embed));
            return $response;
        });

        // Add a new Tree Embed to a site
        $this->post('/sites/{siteID}/embeds/new', function (Request $request, Response $response) {
            $siteID = $request->getAttribute('siteID');
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

        // save interactions
        $this->post('/interactions/new', function (Request $request, Response $response) {
            // passed data
            $data = $request->getParsedBody();

            // set empty errors array. This whole "check for errors then move on" thing
            // could probably be structured better
            $errors = [];

            $site = new Database\SaveSite();
            // get the siteID. It will either save a new one or return an existing one
            $site_response = $site->save($data['site']);
            if(isset($site_response['status']) && $site_response['status'] === 'success') {
                $data['site']['siteID'] = $site_response['siteID'];
                $data['site']['treeID'] = $data['treeID'];
            } else {
                $errors = $site_response;
            }
            // no errors? get the embed
            if(empty($errors)) {
                // add the treeID into the site attribute cuz we'll need it
                // try to get the embed
                $embed = new Database\SaveEmbed();
                $embed_response = $embed->save($data['site']);

                if(isset($embed_response['status']) && $embed_response['status'] === 'success') {
                    $data['site']['embedID'] = $embed_response['embedID'];
                } else {
                    $errors = $embed_response;
                }
            }

            // no errors? save the interaction
            if(empty($errors)) {
                // try to save it
                $interaction = new Database\SaveInteraction();
                $the_response = $interaction->save($data);
            } else {
                $the_response = $errors;
            }

            // return the JSON
            $response->withStatus(200)
                ->withHeader("Content-Type", "application/json")
                ->write(json_encode($data));
            return $response;
        });

        $this->get('/interactions/types/', function (Request $request, Response $response) {
            $db = new Database\DB();
            $interactionTypes = $db->getInteractionTypes();

            $response->getBody()->write(json_encode($interactionTypes));
            return $response;
        });

        $this->get('/interactions/types/{typeID}', function (Request $request, Response $response) {
            $typeID = $request->getAttribute('typeID');
            $db = new Database\DB();
            $interactionType = $db->getInteractionType($typeID);

            $response->getBody()->write(json_encode($interactionType));
            return $response;
        });

        $this->get('/states/types/', function (Request $request, Response $response) {
            $db = new Database\DB();
            $state_types = $db->getStateTypes();

            $response->getBody()->write(json_encode($state_types));
            return $response;
        });

        $this->get('/states/types/{typeID}', function (Request $request, Response $response) {
            $typeID = $request->getAttribute('typeID');
            $db = new Database\DB();
            $state_type = $db->getStateType($typeID);

            $response->getBody()->write(json_encode($state_type));
            return $response;
        });
    });
});


$app->run();
