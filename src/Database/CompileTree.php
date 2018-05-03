<?php

/**
* Manages the rendering and sending of the correct template
* @since 0.0.1
* @author jones.jeremydavid@gmail.com
*/

namespace Cme\Database;

class CompileTree extends DB {
    protected $db,
              $compiled;

    public function __construct($treeID, $db = false) {
        // allow a database connection to be passed in
        if($db !== false) {
            $this->db = $db;
        } else {
            $this->db = new \Cme\Database\DB();
        }

        // kick off build process
        // get the tree by slug or ID
        if(\Cme\Utility\isSlug($treeID)) {
            $tree = $this->db->getTreeBySlug($treeID);
            // set the real tree id
            $treeID = $tree['treeID'];
        } else {
            $tree = $this->db->getTree($treeID);
        }

        $this->compiled = $tree;
        $this->compiled['starts'] = $this->compile_starts($treeID);
        $this->compiled['groups'] = $this->compile_groups($treeID);
        $this->compiled['questions'] = $this->compile_questions($treeID);
        $this->compiled['ends'] = $this->compile_ends($treeID);
        // figure out total paths and longest path
        $this->compiled['stats'] = $this->compute_paths($this->compiled['questions']);
        // encode to JSON
        $pretty_json = json_encode($this->compiled, JSON_PRETTY_PRINT);
        $minified_json = json_encode($this->compiled);
        // write to file
        $this->write_file($tree['treeSlug'], $pretty_json);
        $this->write_file($tree['treeSlug'].'.min', $minified_json);
        // return the json, if they need it
        return $pretty_json;
    }

    protected function write_file($filename, $contents) {
        file_put_contents(TREE_PATH.'/data/'.$filename.'.json', $contents);
    }

    protected function compile_starts($treeID) {
        return $this->db->getStarts($treeID);
    }

    protected function compile_groups($treeID) {
        $groups = $this->db->getGroups($treeID);
        $i = 0;

        foreach($groups as $group) {

            $groups[$i]['questions'] = $this->db->getQuestionsByGroup($group['groupID']);
            $i++;
        }


        return $groups;

    }


    protected function compile_questions($treeID) {
        $questions = $this->db->getQuestions($treeID);
        $i = 0;

        foreach($questions as $question) {
            // $questions[$i]['content'] = addslashes($questions[$i]['content']);
            $questions[$i]['description'] = ( isset($questions[$i]['description']) ? addslashes($questions[$i]['description']) : '');
            $questions[$i]['options'] = $this->compile_options($question['questionID']);
            $i++;
        }


        return $questions;

    }

    protected function compile_options($questionID) {
        return $this->db->getOptions($questionID);
    }

    protected function compile_ends($treeID) {
        return $this->db->getEnds($treeID);
    }

    /**
    * Starts with the first question and computes all possible paths
    *
    */
    protected function compute_paths($questions) {
        // empty array to hold the paths
        $paths = [];
        $path_i = 0;

        // add the first question as a new array item in that array
        $paths[$path_i][] = 'Question '.$questions[0]['questionID'];
        $paths = $this->process_paths($paths, $path_i, $this->db->getOptions($questions[0]['questionID']));
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
            $path_ends[$end['endID']] = ['title'=>$end['title']];
            $path_count = 0;
            foreach($paths as $path) {
                $path_end = array_pop($path);
                if($path_end === 'end '.$end['endID']) {
                    $path_count++;
                }
            }
            // add it to the count
            $path_ends[$end['endID']]['count'] = $path_count;
            $path_ends[$end['endID']]['percentage'] = round($path_count/count($paths) * 100, 2);
        }
        return $path_ends;
    }


}
