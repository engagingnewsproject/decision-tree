<?php
namespace Cme\Route;
use Cme\Element\Tree as Tree;
use Cme\Utility as Utility;
use Cme\Database as Database;

class Preview extends Route
{
    protected $app,
              $treeID = false,
              $tree = false,
              $env = 'prod';

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

        // get environment
        $this->env = $request->getQueryParam('env', $default = 'prod');
    }

    public function tree($request, $response) {
        // init data
        $this->init($request);


        $view = $this->app->get('view');
        $view->render($response, "preview/tree.php",
            [
                'tree' => $this->tree,
                'env'  => $this->env,
                'css'  => $request->getQueryParam('css', $default = 'base'), // css filename
                'loader' => $request->getQueryParam('loader', $default = 'simple'),
                'url'  => TREE_URL
            ]
        );
    }

}
