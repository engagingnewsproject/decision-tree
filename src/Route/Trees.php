<?php
namespace App;
use \Cme\Database as Database;
use \Cme\Utility as Utility;

class Trees extends Route
{
    protected $app,
              $data = [], // the passed data in the request
              $treeID = false,
              $tree = false,
              $user = false,
              $db = false;

    public function __construct($app = false) {
        $this->app = $app;

    }

    public function init($request) {
        // set DB connection
        $this->user = $request->getAttribute('user');

        // if we have a user, try to create the tree
        $this->db = new Database\DB($this->user);

        // set tree
        $treeID = $request->getAttribute('treeID');
        if($treeID) {
            $this->treeID = $treeID;
            $this->tree = new \Cme\Tree($this->db, $treeID);
        }

        $data = $request->getParsedBody();
        if($data) {
            $this->data = $request->getParsedBody();
        }
    }

    public function getAll($request, $response) {
        // set up our vars
        $this->init($request);

        $trees = $this->db->getTrees();

        $this->return($trees, $response);
    }

    public function get($request, $response) {
        $this->init($request);

        $this->return($this->tree->array(), $response);
    }

    public function iframe($request, $response) {
        $treeSlug = $request->getAttribute('treeSlug');
        $js = $request->getQueryParam('js', $default = 'true');

        // check if we have a slug or an id
        if(Utility\isID($treeSlug)) {
            $treeSlug = Utility\getTreeSlugById($treeSlug);
        }
        if($js === 'false') {
            $viewPath = 'no-js';
        } else {
            $viewPath = 'has-js';
        }

        $view = $this->app->get('view');
        $view->render($response, "iframe/$viewPath/index.php", [
            'treeSlug' => $treeSlug,
            'url'=>TREE_URL
        ]);
    }
    public function create($request, $response) {
        // init data
        $this->init($request);

        $tree = [];
        $tree['owner'] = $this->user['userID'];
        // add the user to the tree data as the owner
        if(isset($this->data['owner'])) {
            $tree['owner'] = $this->data['owner'];
        }

        $tree = new \Cme\Tree($this->db, $tree);

        $keys = ['slug', 'title'];
        $tree = $this->dynamicSet($this->data, $keys, $tree);

        $tree = $tree->save();

        if(!is_object($tree)) {
            $this->addError($tree);
        }

        $this->return($tree->array(), $response);
    }

    public function update($request, $response) {
        // init data
        $this->init($request);

        // set what we want to allow to be updated
        $keys = ['slug', 'title'];
        $this->tree = $this->dynamicSet($this->data, $keys, $this->tree);

        $result = $this->tree->save();

        if($result !== true) {
            $this->addError($result);
        }

        $this->return($this->tree->array(), $response);
    }

    public function delete($request, $response) {
        // init data
        $this->init($request);

        $delete = $this->tree->delete();

        $this->return($delete, $response);
    }



}
