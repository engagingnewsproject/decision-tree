<?php
namespace Cme\Route;
use Cme\Element\Tree as Tree;
use Cme\Utility as Utility;
use Cme\Database as Database;

class Editor extends Route
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
        $treeIdentifier = $request->getAttribute('treeIdentifier');
        $this->tree = new Tree($this->db, $treeIdentifier);
        $this->treeID = $this->tree->getID();
    }

    public function tree($request, $response) {
        // init data
        $this->init($request);

        $view = $this->app->get('view');
        $view->render($response, "edit/tree.php", [
            'tree' => $this->tree,
            'url'=>TREE_URL
        ]);
    }

}
