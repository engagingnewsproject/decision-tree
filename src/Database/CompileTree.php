<?php

/**
* Manages the rendering and sending of the correct template
* @since 0.0.1
* @author jones.jeremydavid@gmail.com
*/

namespace Enp\Database;

class CompileTree extends DB {
    protected $DB,
              $compiled;

    public function __construct($tree_id) {
        $this->DB = new DB();
        // kick off build process
        // get the tree by slug or ID
        if(\Enp\Utility\is_slug($tree_id)) {
            $tree = $this->DB->get_tree_by_slug($tree_id);
            // set the real tree id
            $tree_id = $tree['tree_id'];
        } else {
            $tree = $this->DB->get_tree($tree_id);
        }

        $this->compiled = $tree;
        $this->compiled['groups'] = $this->compile_groups($tree_id);
        $this->compiled['questions'] = $this->compile_questions($tree_id);
        $this->compiled['ends'] = $this->compile_ends($tree_id);
        // encode to JSON
        $compiled_json = json_encode($this->compiled, JSON_PRETTY_PRINT);
        // write to file
        $this->write_file($tree, $compiled_json);
        // return the json, if they need it
        return $compiled_json;
    }

    protected function write_file($tree, $compiled_json) {
        file_put_contents(TREE_PATH.'/data/'.$tree['tree_slug'].'.json', $compiled_json);
    }

    protected function compile_groups($tree_id) {
        $groups = $this->DB->get_groups($tree_id);
        $i = 0;

        foreach($groups as $group) {

            $groups[$i]['questions'] = $this->DB->get_questions_by_group($group['group_id']);
            $i++;
        }


        return $groups;

    }


    protected function compile_questions($tree_id) {
        $questions = $this->DB->get_questions($tree_id);
        $i = 0;

        foreach($questions as $question) {

            $questions[$i]['options'] = $this->compile_options($question['question_id']);
            $i++;
        }


        return $questions;

    }

    protected function compile_options($question_id) {
        return $this->DB->get_options($question_id);
    }

    protected function compile_ends($tree_id) {
        return $this->DB->get_ends($tree_id);
    }
}
