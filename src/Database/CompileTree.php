<?php

/**
* Manages the rendering and sending of the correct template
* @since 0.0.1
* @author jones.jeremydavid@gmail.com
*/

namespace Cme\Database;

class CompileTree extends DB {
    protected $db,
              $tree,
              $compiled;

    public function __construct($tree, $db = false, $stats = true) {
        // allow a database connection to be passed in
        if($db !== false) {
            $this->db = $db;
        } else {
            $this->db = parent::__construct();
        }
        $this->tree = $tree;
        $this->compiled = $this->tree->array();
        $this->compiled['starts'] = $this->compileElement('start', $this->tree->getStarts());
        $this->compiled['groups'] = $this->compileElement('group', $this->tree->getGroups());
        $this->compiled['questions'] = $this->compileElement('question', $this->tree->getQuestions());
        $this->compiled['ends'] = $this->compileElement('end', $this->tree->getEnds());
        $this->compiled['tQs'] = $this->tree->getQuestions();
        if($stats === true) {
            // figure out total paths and longest path
            $this->compiled['stats'] = $this->computePaths($this->compiled['questions']);
        }

        // return compiled php array
        return $this->compiled;
    }

    public function getCompiled() {
        return $this->compiled;
    }

    // writes to file
    public function save() {
        // encode to JSON
        $pretty_json = json_encode($this->compiled, JSON_PRETTY_PRINT);
        $minified_json = json_encode($this->compiled);
        // write to file
        $this->writeFile($this->tree->getSlug(), $pretty_json);
        $this->writeFile($this->tree->getSlug().'.min', $minified_json);

        return $pretty_json;
    }

    protected function writeFile($filename, $contents) {
        file_put_contents(TREE_PATH.'/data/'.$filename.'.json', $contents);
    }
    protected function compileElement($elType, $elIDs) {
        $compiled = [];
        $objName = '\Cme\Element\\'.ucfirst($elType);

        foreach($elIDs as $elID) {
            $el = new $objName($this->db, $elID);
            $compiledEl = $el->array();

            // if we're on a question, run this again for the options
            if($elType === 'question') {
                $compiledEl['options'] = $this->compileElement('option', $el->getOptions());
            }
            $compiled[] = $compiledEl;
        }
        return $compiled;

    }


    /**
    * Starts with the first question and computes all possible paths
    *
    */
    protected function computePaths($questions) {
        // empty array to hold the paths
        $paths = [];
        $path_i = 0;

        // add the first question as a new array item in that array
        $paths[$path_i][] = 'Question '.$questions[0]['ID'];
        $paths = $this->process_paths($paths, $path_i, $this->db->getOptions($questions[0]['ID']));
        return ['total_paths'=>count($paths),'longest_path'=>$this->largest_array_count($paths), 'path_ends'=>$this->path_end_numbers($paths)];
        /*
        return $paths;*/
    }

    /**
    * Recursive function to follow a question's options through to the end and add it to the $paths array
    * @param $paths = array of paths
    * @param $path_i = index of where we're at in the paths array
    * @param $options the options for the question you want to process
    * @return $paths array with all paths added to it
    */
    protected function process_paths($paths, $path_i, $options) {
        // clone our path ahead of time so we have a clean one in case we need to clone it
        $cloned_path = $paths[$path_i];
        $option_i = 0;

        foreach($options as $option) {
            // clone it if it's not the first option. It's a new path
            if($option_i !== 0) {
                // increase our path counter to the length of the array +1.
                // we can't do $path_i++ because it'll likely already be taken by another recursive
                // loop on the same function
                $path_i = count($paths);
                // set the path in the array
                $paths[$path_i] = $cloned_path;
            }
            // add the destination to the path
            $paths[$path_i][] = $option['destinationType'] . ' '. $option['destinationID'];

            // now recursively process ITS paths if it's a question
            if($option['destinationType'] === 'question') {

                $paths = $this->process_paths($paths, $path_i, $this->db->getOptions($option['destinationID']));
            }

            $option_i++;
        }
        // return all the paths
        return $paths;
    }

    public function largest_array_count($arr) {
        $most = 0;
        foreach($arr as $a) {
            $count = count($a);
            if($most < $count) {
                $most = $count;
            }
        }
        return $most;
    }

    public function path_end_numbers($paths) {
        $ends = $this->compiled['ends'];
        $path_ends = [];
        foreach($ends as $end) {
            $path_ends[$end['ID']] = ['title'=>$end['title']];
            $path_count = 0;
            foreach($paths as $path) {
                $path_end = array_pop($path);
                if($path_end === 'end '.$end['ID']) {
                    $path_count++;
                }
            }
            // add it to the count
            $path_ends[$end['ID']]['count'] = $path_count;
            $path_ends[$end['ID']]['percentage'] = round($path_count/count($paths) * 100, 2);
        }
        return $path_ends;
    }


}
