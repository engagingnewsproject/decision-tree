<?php
/**
* Getter functions from Database
*
* @since 0.0.1
* @author jones.jeremydavid@gmail.com
**/


namespace Cme\Database;
use Cme\Utility as Utility;
use PDO;

class Get extends DB {
    public function __construct() {
        // create a DB instance
        parent::__construct();
    }

    /**
     * Gets all trees from the database
     *
     * @return ARRAY of TREE ARRAYS
     */
    public function get_trees() {
        // Do a select query to see if we get a returned row
        $sql = "SELECT * from ".$this->views['tree'];
        // return the found tree row
        return $this->fetch_all($sql);
    }

    /**
     * Gets one tree from the database by id
     *
     * @param $tree_id INT
     * @return ARRAY/OBJECT of the TREE
     */
    public function get_tree($tree_id) {
        // Do a select query to see if we get a returned row
        $params = [":tree_id" => $tree_id];
        $sql = "SELECT * from ".$this->views['tree']." WHERE
                tree_id = :tree_id";
        // return the found tree row
        return $this->fetch_one($sql, $params);
    }

    /**
     * Gets one tree from the database by slug
     *
     * @param $tree_slug STRING
     * @return ARRAY/OBJECT of the TREE
     */
    public function get_tree_by_slug($tree_slug) {
        // Do a select query to see if we get a returned row
        $params = [":tree_slug" => $tree_slug];
        $sql = "SELECT * from ".$this->views['tree']." WHERE
                tree_slug = :tree_slug";
        // return the found tree row
        return $this->fetch_one($sql, $params);
    }

    /**
     * Gets all starts from the database by tree_id
     *
     * @param $tree_id INT
     * @return ARRAY
     */
    public function get_starts($tree_id) {
        return $this->fetch_all_by_tree('tree_start', $tree_id);
    }

    /**
     * Get a start from the database by id
     *
     * @param $start_id INT
     * @param $tree_id INT (Optional)
     * @return ARRAY of TREE ARRAYS
     */
    public function get_start($start_id, $tree_id = false) {
        return $this->fetch_one_by_view('start', $start_id, $tree_id);
    }

    /**
     * Gets all groups from the database by tree_id
     *
     * @param $tree_id INT
     * @return ARRAY
     */
    public function get_groups($tree_id) {
        return $this->fetch_all_by_tree('tree_group', $tree_id);
    }

    /**
     * Get a group from the database by group_id
     *
     * @param $group_id INT
     * @param $tree_id INT (Optional)
     * @return ARRAY of TREE ARRAYS
     */
    public function get_group($group_id, $tree_id = false) {
        return $this->fetch_one_by_view('group', $group_id, $tree_id);
    }

    /**
     * Gets all questions from the database by tree_id
     *
     * @param $tree_id INT
     * @param $options ARRAY (Optional) sets orderby paramater in SQL statement
     * @return ARRAY
     */
    public function get_questions($tree_id, $options = array()) {
        $default_options = array('orderby'=>'order');
        $options = array_merge($default_options, $options);
        return $this->fetch_all_by_tree('tree_question', $tree_id, $options);
    }

    /**
     * Get a question from the database by question_id
     *
     * @param $question_id INT
     * @param $tree_id INT (Optional)
     * @return ARRAY of TREE ARRAYS
     */
    public function get_question($question_id, $tree_id = false) {
        return $this->fetch_one_by_view('question', $question_id, $tree_id);
    }

     /**
     * Gets all questions from the database by group_id
     *
     * @param $group_id INT
     * @param $tree_id INT (optional)
     * @return ARRAY of Question IDs
     */
    public function get_questions_by_group($group_id, $tree_id = false) {
        $params = [":group_id" => $group_id];
        $sql = "SELECT question_id from ".$this->views['tree_question']." WHERE
                group_id = :group_id";

        // if a tree_id was passed, append it to the params and sql statement
        if($tree_id !== false) {
            $params[":tree_id"] = $tree_id;
            $sql .= " AND tree_id = :tree_id";
        }

        $sql .= " ORDER BY `order`";

        $stmt = $this->query($sql, $params);
        return $stmt->fetchAll(PDO::FETCH_COLUMN, 0);
    }

    public function get_options($question_id, $options = array()) {
        $default_options = array('tree_id'=>false, 'orderby'=>'order');
        $options = array_merge($default_options, $options);

        // validate the question_id
        $validate = new Validate();
        if($validate->validate_question_id($question_id) === false) {
            return false;
        }

        $params = [":question_id" => $question_id];
        $sql = "SELECT * from ".$this->views['tree_option']." WHERE
                question_id = :question_id";

        // if a tree_id was passed, append it to the params and sql statement
        if(Utility\is_id($options['tree_id'])) {
            $params[":tree_id"] = $options['tree_id'];
            $sql .= " AND tree_id = :tree_id";
        }

        $sql .= $this->get_orderby($options['orderby']);

        return $this->fetch_all($sql, $params);
    }

    public function get_option($option_id, $options = array()) {
        $default_options = array('tree_id'=>false, 'question_id'=>false);
        $options = array_merge($default_options, $options);

        $params = [":option_id" => $option_id];

        $sql = "SELECT * from ".$this->views["tree_option"]." WHERE
                option_id = :option_id";

        // if a tree_id was passed, append it to the params and sql statement
        if( Utility\is_id($options['tree_id']) ) {
            $params[":tree_id"] = $options['tree_id'];
            $sql .= " AND tree_id = :tree_id";
        }

        if( Utility\is_id($options['question_id']) ) {
            $params[":question_id"] = $options['question_id'];
            $sql .= " AND question_id = :question_id";
        }

        return $this->fetch_one($sql, $params);
    }

    public function get_ends($tree_id) {
        return $this->fetch_all_by_tree('tree_end', $tree_id);
    }

    public function get_end($end_id, $tree_id = false) {
        return $this->fetch_one_by_view('end', $end_id, $tree_id);
    }

    protected function get_orderby($orderby) {
        if($orderby === 'order') {
            // order by order
            $sql = " ORDER BY `order`";
        } else if(is_string($orderby)) {
            $sql = " ".$orderby;
        } else {
            // do nothing
            $sql = '';
        }
        return $sql;
    }

    public function get_interaction_types() {
        // Do a select query to see if we get a returned row
        $sql = "SELECT * from ".$this->tables['tree_interaction_type'];
        // return the found interaction types
        return $this->fetch_all($sql);
    }

    public function get_interaction_type($interaction_type) {
        if(Utility\is_id($interaction_type)) {
            return $this->get_interaction_type_by_id($interaction_type);
        } else {
            return $this->get_interaction_type_by_slug($interaction_type);
        }
    }

    public function get_interaction_type_by_id($interaction_type_id) {
        // Do a select query to see if we get a returned row
        $params = [":interaction_type_id" => $interaction_type_id];
        $sql = "SELECT * from ".$this->tables['tree_interaction_type']." WHERE
                interaction_type_id = :interaction_type_id";
        // return the found interaction type row
        return $this->fetch_one($sql, $params);
    }

    public function get_interaction_type_by_slug($interaction_type) {
        // Do a select query to see if we get a returned row
        $params = [":interaction_type" => $interaction_type];
        $sql = "SELECT * from ".$this->tables['tree_interaction_type']." WHERE
                interaction_type = :interaction_type";
        // return the found interaction type row
        return $this->fetch_one($sql, $params);
    }

    public function get_state_types() {
        // Do a select query to see if we get a returned row
        $sql = "SELECT * from ".$this->tables['tree_state_type'];
        // return the found state types
        return $this->fetch_all($sql);
    }

    public function get_state_type($state_type) {
        if(Utility\is_id($state_type)) {
            return $this->get_state_type_by_id($state_type);
        } else {
            return $this->get_state_type_by_slug($state_type);
        }
    }

    public function get_state_type_by_id($state_type_id) {
        // Do a select query to see if we get a returned row
        $params = [":state_type_id" => $state_type_id];
        $sql = "SELECT * from ".$this->tables['tree_state_type']." WHERE
                state_type_id = :state_type_id";
        // return the found state type row
        return $this->fetch_one($sql, $params);
    }

    public function get_state_type_by_slug($state_type) {
        // Do a select query to see if we get a returned row
        $params = [":state_type" => $state_type];
        $sql = "SELECT * from ".$this->tables['tree_state_type']." WHERE
                state_type = :state_type";
        // return the found interaction type row
        return $this->fetch_one($sql, $params);
    }

    public function get_site($site) {
        if(Utility\is_id($site)) {
            return $this->get_site_by_id($site);
        } else {
            return $this->get_site_by_host($site);
        }
    }

    public function get_site_by_id($site_id) {
        // Do a select query to see if we get a returned row
        $params = [":site_id" => $site_id];
        $sql = "SELECT * from ".$this->tables['tree_site']." WHERE
                site_id = :site_id";
        // return the found state type row
        return $this->fetch_one($sql, $params);
    }

    public function get_site_by_host($site_host) {
        // Do a select query to see if we get a returned row
        $params = [":site_host" => $site_host];
        $sql = "SELECT * from ".$this->tables['tree_site']." WHERE
                site_host = :site_host";
        // return the found interaction type row
        return $this->fetch_one($sql, $params);
    }

    public function get_embeds_by_site($site_id) {
        $params = [":site_id" => $site_id];
        $sql = "SELECT * from ".$this->tables['tree_embed']." WHERE
                site_id = :site_id";
        // return the found state type row
        return $this->fetch_all($sql, $params);
    }

    public function get_embed($embed, $options) {
        if(Utility\is_id($embed)) {
            return $this->get_embed_by_id($embed, $options);
        } else {
            return $this->get_embed_by_path($embed, $options);
        }
    }

    public function get_embed_by_id($embed_id, $options) {
        // Do a select query to see if we get a returned row
        $params = [":embed_id" => $embed_id];
        $sql = "SELECT * from ".$this->tables['tree_embed']." WHERE
                embed_id = :embed_id";

        // if a tree_id was passed, append it to the params and sql statement
        if(isset($options['tree_id']) && Utility\is_id($options['tree_id'])) {
            $params[":tree_id"] = $options['tree_id'];
            $sql .= " AND tree_id = :tree_id";
        }

        // if a site_id was passed, append it to the params and sql statement
        if(isset($options['site_id']) && Utility\is_id($options['site_id'])) {
            $params[":site_id"] = $options['site_id'];
            $sql .= " AND site_id = :site_id";
        }
        // return the found state type row
        return $this->fetch_one($sql, $params);
    }

    public function get_embed_by_path($embed_path, $options) {
        // Do a select query to see if we get a returned row
        $params = [
                    ":embed_path" => $embed_path,
                  ];
        $sql = "SELECT * from ".$this->tables['tree_embed']." WHERE
                embed_path = :embed_path";

        // if a tree_id was passed, append it to the params and sql statement
        if(isset($options['tree_id']) && Utility\is_id($options['tree_id'])) {
            $params[":tree_id"] = $options['tree_id'];
            $sql .= " AND tree_id = :tree_id";
        }

        // if a tree_id was passed, append it to the params and sql statement
        if(isset($options['site_id']) && Utility\is_id($options['site_id'])) {
            $params[":site_id"] = $options['site_id'];
            $sql .= " AND site_id = :site_id";
        }
        // return the found interaction type row
        return $this->fetch_one($sql, $params);
    }
}
