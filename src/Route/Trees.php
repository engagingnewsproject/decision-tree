<?php
namespace Cme\Route;
use Cme\Element\Tree as Tree;
use Cme\Utility as Utility;
use Cme\Database as Database;

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
            $this->tree = new Tree($this->db, $treeID);
        } else {
            $treeSlug = $request->getAttribute('treeSlug');
            $this->tree = new Tree($this->db, $treeSlug);
            $this->treeID = $this->tree->getID();
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
        // init data
        $this->init($request);
        $js = $request->getQueryParam('js', $default = 'true');

        if($js === 'false') {
            $viewPath = 'no-js';
        } else {
            $viewPath = 'has-js';
        }

        $view = $this->app->get('view');
        $view->render($response, "iframe/$viewPath/index.php", [
            'treeSlug' => $this->tree->getSlug(),
            'url'=>TREE_URL
        ]);
    }

    public function compile($request, $response) {
        // init data
        $this->init($request);

        $treeSlug = $this->tree->getSlug();
        // compile it, passing in the database
        $compiled = new Database\CompileTree($this->tree, $this->db);

        // return the file that got written
        // It's already JSON, so don't pass it through the $this->return function
        $response->getBody()->write(file_get_contents("data/".$treeSlug.".json"));
        return $response;
    }

    public function compiled($request, $response) {
        $treeSlug = $request->getAttribute('treeSlug');
        $minified = $request->getQueryParam('minified', $default = false);
        $ext = ($minified === 'true' ? '.min' : '');

        if(Utility\isID($treeSlug)) {
            $treeSlug = Utility\getTreeSlugById($treeSlug);
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

        $tree = new Tree($this->db, $tree);

        $keys = ['slug', 'title'];
        $tree = $this->dynamicSet($this->data, $keys, $tree);

        $tree = $tree->save();
        if(!is_object($tree)) {
            $this->addError($tree);
        }
        $this->return((is_object($tree) ? $tree->array() : ''), $response);
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
