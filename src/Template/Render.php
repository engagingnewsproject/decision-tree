<?php
/**
* Manages the rendering and sending of the correct template
* @since 0.0.1
* @author jones.jeremydavid@gmail.com
*/
namespace Enp\Template;
require_once('./vendor/autoload.php');
use Enp\Utility as Utility;

class Render extends Template {
    public $data,
           $template_name,
           $template_path;

    public function __construct($template_name, $data_slug) {
        // set the name
        $this->set_template_name($template_name);
        // get the name
        $template_name = $this->get_template_name();
        // set the path
        $this->set_template_path($template_name);
        // set the data
        $this->set_data($data_slug);
        return $this->data;
    }

    /**
    * Passes data to the compiled template render function
    */
    public function render() {
        $renderer = include $this->get_template_path();
        return $renderer($this->get_data());
    }

    protected function set_data($data_slug) {
        $data = false;
        if(!Utility\is_slug($data_slug)) {
            $this->data = $data;
            return $this->data;
        }

        $url = Utility\get_data_url($data_slug);
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_TIMEOUT, 5);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $JSON = curl_exec($ch);
        curl_close($ch);

        if(is_string($JSON)) {
            $data = json_decode($JSON, true);
        }

        if(is_array($data)) {
            $this->data = $data;
        } else {
            $this->data = false;
        }
        return $this->data;
    }

    protected function set_template_path() {
        $path = false;
        $template_name = $this->get_template_name();
        if(Utility\is_slug($template_name)) {
            $path = "views/$template_name.php";
        }
        $this->template_path = $path;
    }

    public function get_data() {
        return $this->data;
    }

    public function get_template_path() {
        return $this->template_path;
    }




}
