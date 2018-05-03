<?php
namespace App;
use \Cme\Database as Database;
use \Cme\Utility as Utility;

class Trees extends Route
{
    protected $app,
              $treeID = false,
              $tree = false;

    public function __construct($app = false) {
        $this->app = $app;
    }

    public function init($request) {
        // build the parent init
        parent::init($request);

        // set tree
        $treeID = $request->getAttribute('treeID');
        if($treeID) {
            $this->treeID = $treeID;
            $this->tree = new \Cme\Tree($this->db, $treeID);
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

    public function compile($request, $response) {
        $treeSlug = $request->getAttribute('treeSlug');

        if(\Cme\Utility\isID($treeSlug)) {
            $treeSlug = \Cme\Utility\getTreeSlugById($treeSlug);
        }

        // compile it, passing in the database
        $compiled = new Database\CompileTree($treeSlug, $this->db);

        // return the file that got written
        // It's already JSON, so don't pass it through the $this->return function
        $response->getBody()->write(file_get_contents("data/".$treeSlug.".json"));
        return $response;
    }

    public function compiled($request, $response) {
        $treeSlug = $request->getAttribute('treeSlug');
        $minified = $request->getQueryParam('minified', $default = false);
        $ext = ($minified === 'true' ? '.min' : '');

        if(\Cme\Utility\isID($treeSlug)) {
            $treeSlug = \Cme\Utility\getTreeSlugById($treeSlug);
        }

        $response->getBody()->write(file_get_contents("data/".$treeSlug.$ext.".json"));
        return $response;
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
