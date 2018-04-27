<?php
namespace Cme;
// allow all sites to access this file
header('Access-Control-Allow-Origin: *');

require 'vendor/autoload.php';

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;
use \Cme\Database as Database;
use \Cme\Utility as Utility;

$config = [];
$config['displayErrorDetails'] = true;
$config['addContentLengthHeader'] = false;

$app = new \Slim\App(["settings" => $config]);
$errors = [];

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

/**
 * An authentication layer for validating users before
 *
 */
$app->add(function ($request, $response, $next) {

    if($request->isGet()) {
        // No authentication needed.
        // Go ahead and move on to the actual request.
        $response = $next($request, $response);
        return $response;
    }
    // set any routes you don't want to worry about
    $exclusions = ['/api/v1/interactions'];
    if(in_array($request->getUri()->getPath(), $exclusions)) {
        // No authentication needed.
        // Go ahead and move on to the actual request.
        $response = $next($request, $response);
        return $response;
    }

    // passed data
    $data = $request->getParsedBody();
    $errors = [];

    if(!isset($data['user'])) {
        $errors[] = 'No user passed.';
    } else {
        $user = $data['user'];
        // validate the user
        $validUser = Utility\validateUserToken($user['clientToken'], $user['accessToken']);

        if($validUser !== true) {
            $errors[] = 'Invalid user.';
        }
    }

    if(!empty($errors)) {
        $response->getBody()->write(json_encode($errors));
        return $response;
    }

    // add in our valid user to the request
    $request = $request->withAttribute('user', Utility\getUser('clientToken', $data['user']['clientToken']));
    // go ahead and move on to the actual request
    $response = $next($request, $response);
    return $response;
});

/* $app->add(new Tuupola\Middleware\HttpBasicAuthentication([
    "path" => ["/api"],
    "ignore" => ["/api/v1/interactions"],
    "realm" => "Protected",
    "users" => [
        "juryjowns" => TREE_ADMIN_PASSWORD,
    ],
    "error" => function ($response, $message) {
        $data = [
            'error' => $message,
        ];

        return $response->getBody()->write(json_encode($data, JSON_UNESCAPED_SLASHES));
    }
]));*/


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

        $this->get('/trees', function (Request $request, Response $response) {
            $db = new Database\DB();
            $trees = $db->getTrees();

            $response->getBody()->write(json_encode($trees));
            return $response;
        });

        $this->post('/trees', function (Request $request, Response $response) {
            // passed data
            $data = $request->getParsedBody();
            $user = $request->getAttribute('user');
            // if we have a user, try to create the tree
            $db = new Database\DB($user);
            $tree = [];
            $tree['owner'] = $user['userID'];
            // add the user to the tree data as the owner
            if(isset($data['owner'])) {
                $tree['owner'] = $data['owner'];
            }
            $tree = new Tree($db, $tree);

            $keys = ['slug', 'title'];
            foreach($data as $key => $val) {
                if(in_array($key, $keys)) {
                    $function = 'set'.ucfirst($key);
                    $tree->$function($val);
                }
            }

            $tree = $tree->save();

            if(is_object($tree)) {
                // return the tree array
                $response->getBody()->write(json_encode($tree->array()));
            } else {
                // it's an error, so return the error
                $error = $tree;
                $response->getBody()->write(json_encode(['errors'=>[$error]]));
            }


            return $response;
        });

        $this->get('/trees/{treeID}', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');
            $db = new Database\DB();
            $tree = new Tree($db, $treeID);
            // format into JSON
            $response->getBody()->write(json_encode($tree->array()));
            return $response;
        });

        $this->put('/trees/{treeID}', function (Request $request, Response $response) {
            // passed data
            $data = $request->getParsedBody();
            $user = $request->getAttribute('user');
            $treeID = $request->getAttribute('treeID');

            $db = new Database\DB($user);
            $tree = new Tree($db, $treeID);

            $keys = ['slug', 'title'];
            foreach($data as $key => $val) {
                if(in_array($key, $keys)) {
                    $function = 'set'.ucfirst($key);
                    $tree->$function($val);
                }
            }

            $result = $tree->save();

            if($result === true) {
                $response->getBody()->write(json_encode($tree->array()));
            } else {
                $response->getBody()->write(json_encode($result));
            }

            return $response;
        });

        $this->delete('/trees/{treeID}', function (Request $request, Response $response) {

            $user = $request->getAttribute('user');
            $treeID = $request->getAttribute('treeID');

            $db = new Database\DB($user);

            $tree = new Tree($db, $treeID);

            $delete = $tree->delete();

            $response->getBody()->write(json_encode($delete));

        });

        $this->get('/trees/{treeID}/starts', function (Request $request, Response $response) {
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

        $this->get('/trees/{treeID}/groups', function (Request $request, Response $response) {
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

        $this->get('/trees/{treeID}/questions', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');

            $db = new Database\DB();
            $tree = new Tree($db, $treeID);
            $questionIDs = $tree->getQuestions();
            $allQuestions = [];
            foreach($questionIDs as $questionID) {
                $question = new Question($db, $questionID);
                // remove treeID from the response
                $allQuestions[] = $question->array(['treeID']);
            }

            // return the JSON
            $response->getBody()->write(json_encode($allQuestions));
            return $response;
        });


        $this->post('/trees/{treeID}/questions', function (Request $request, Response $response) {
            // passed data
            $data = $request->getParsedBody();
            $treeID = $request->getAttribute('treeID');
            $user = $request->getAttribute('user');
            // if we have a user, try to create the question
            $db = new Database\DB($user);
            $question = [];
            $question['owner'] = $user['userID'];
            // add the user to the question data as the owner
            if(isset($data['owner'])) {
                $question['owner'] = $data['owner'];
            }

            // add in the treeID
            $question['treeID'] = $treeID;
            $question = new Question($db, $question);

            $keys = ['title'];
            foreach($data as $key => $val) {
                if(in_array($key, $keys)) {
                    $function = 'set'.ucfirst($key);
                    $question->$function($val);
                }
            }

            $question = $question->save();

            if(is_object($question)) {
                // return the question array
                $response->getBody()->write(json_encode($question->array()));
            } else {
                // it's an error, so return the error
                $error = $question;
                $response->getBody()->write(json_encode(['errors'=>[$error]]));
            }


            return $response;
        });

        $this->get('/trees/{treeID}/questions/{questionID}', function (Request $request, Response $response) {
            $treeID = $request->getAttribute('treeID');
            $questionID = $request->getAttribute('questionID');

            $db = new Database\DB();
            $question = new Question($db, $questionID);
            $theQuestion = false;
            // make sure this question is owned by this tree
            if($question->getTreeID() == $treeID) {
                // remove treeID from the response
                $theQuestion = $question->array(['treeID']);
            }
            // return the JSON
            $response->getBody()->write(json_encode($theQuestion));
            return $response;
        });

        $this->put('/trees/{treeID}/questions/{questionID}', function (Request $request, Response $response) {
            // passed data
            $data = $request->getParsedBody();
            $user = $request->getAttribute('user');
            $treeID = $request->getAttribute('treeID');
            $questionID = $request->getAttribute('questionID');

            $db = new Database\DB($user);
            $tree = new Tree($db, $treeID);
            $question = new Question($db, $questionID);

            $keys = ['treeID','title'];
            foreach($data as $key => $val) {
                if(in_array($key, $keys)) {
                    $function = 'set'.ucfirst($key);
                    $question->$function($val);
                }
            }

            if($question->getTreeID() == $treeID) {
                $result = $question->save();
            } else {
                $result = ['errors'=>['Wrong tree.']];
            }

            if($result === true) {
                $response->getBody()->write(json_encode($question->array(['treeID'])));
            } else {
                $response->getBody()->write(json_encode($result));
            }

            return $response;
        });

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

        $this->get('/trees/{treeID}/ends', function (Request $request, Response $response) {
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

        $this->get('/trees/{treeID}/embeds', function (Request $request, Response $response) {
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

        // Save new site
        /*
        $this->post('/sites', function (Request $request, Response $response) {
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
        */
        // returns array of all the sites
        $this->get('/sites', function (Request $request, Response $response) {
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
        $this->get('/sites/{siteID}/embeds', function (Request $request, Response $response) {
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
        /*
        $this->post('/sites/{siteID}/embeds', function (Request $request, Response $response) {
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
        });*/

        // save interactions
        $this->post('/interactions', function (Request $request, Response $response) {
            // passed data
            $data = $request->getParsedBody();
            // set empty errors array. This whole "check for errors then move on" thing
            // could probably be structured better
            $errors = [];

            $site = new Database\SaveSite();
            // get the siteID. It will either save a new one or return an existing one
            $siteResponse = $site->save($data['site']);

            if(isset($siteResponse['status']) && $siteResponse['status'] === 'success') {
                $data['site']['siteID'] = $siteResponse['siteID'];
                $data['site']['treeID'] = $data['treeID'];
            } else {
                $errors = $siteResponse;
            }
            // no errors? get the embed
            if(empty($errors)) {
                // add the treeID into the site attribute cuz we'll need it
                // try to get the embed
                $embed = new Database\SaveEmbed();
                $embedResponse = $embed->save($data['site']);

                if(isset($embedResponse['status']) && $embedResponse['status'] === 'success') {
                    $data['site']['embedID'] = $embedResponse['embedID'];
                } else {
                    $errors = $embedResponse;
                }
            }

            // no errors? save the interaction
            if(empty($errors)) {
                // try to save it
                $interaction = new Database\SaveInteraction();
                $theResponse = $interaction->save($data);
            } else {
                $theResponse = $errors;
            }


            // return the JSON
            $response->withStatus(200)
                ->withHeader("Content-Type", "application/json")
                ->write(json_encode($theResponse));
            return $response;
        });

        $this->get('/interactions/types', function (Request $request, Response $response) {
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

        $this->get('/states/types', function (Request $request, Response $response) {
            $db = new Database\DB();
            $stateTypes = $db->getStateTypes();

            $response->getBody()->write(json_encode($stateTypes));
            return $response;
        });

        $this->get('/states/types/{typeID}', function (Request $request, Response $response) {
            $typeID = $request->getAttribute('typeID');
            $db = new Database\DB();
            $stateType = $db->getStateType($typeID);

            $response->getBody()->write(json_encode($stateType));
            return $response;
        });
    });
});


$app->run();
