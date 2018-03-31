<?php
/**
* Manages the rendering and sending of the correct template
* @since 0.0.1
* @author jones.jeremydavid@gmail.com
*/
namespace Cme\Template;
use Cme\Utility as Utility;

class Render extends Template {
    public $data,
           $templateName,
           $templatePath;

    public function __construct($templateName, $dataSlug) {
        // set the name
        $this->setTemplateName($templateName);
        // get the name
        $templateName = $this->getTemplateName();
        // set the path
        $this->setTemplatePath($templateName);
        // set the data
        $this->set_data($dataSlug);
    }

    /**
    * Passes data to the compiled template render function
    */
    public function render() {
        $renderer = include $this->getTemplatePath();
        $data = $this->get_data();
        return $renderer($this->get_data());
    }

    protected function set_data($treeSlug) {
        $data = false;

        $body = file_get_contents(TREE_PATH."/data/$treeSlug.min.json");
        // decode it if it's not empty
        if(!empty($body)) {
            $data = json_decode($body, true);
        }

        // check to make sure it's a valid array
        if(!is_array($data)) {
            $data = false;
        }

        $this->data = $data;
    }

    protected function setTemplatePath() {
        $path = false;
        $templateName = $this->getTemplateName();
        if(Utility\isSlug($templateName)) {
            $path = "views/$templateName.php";
        }
        $this->templatePath = $path;
    }

    public function get_data() {
        return $this->data;
    }

    public function getTemplatePath() {
        return $this->templatePath;
    }

}
