<?php
/**
* Manages the rendering and sending of the correct template
* @since 0.0.1
* @author jones.jeremydavid@gmail.com
*/
namespace Cme\Template;
use Cme;

class Compile extends Template {
    public $template,
           $template_name;

    public function __construct($template_name) {
        $this->setTemplateName($template_name);
        $this->setTemplate();

        $template_name = $this->getTemplateName();
        $template = $this->getTemplate();

        if($template && $template_name) {
            return $this->compile($template, TREE_PATH."/views/$template_name.php");
        } else {
            return false;
        }
    }


    protected function compile($template, $destination) {
        if(empty($template)) {
            return false;
        }
        $options = array(
            'flags' => \LightnCandy\LightnCandy::FLAG_HANDLEBARS,
            'helpers' => array(
                'environment'  => '\Cme\Template\Helpers::environment',
                'groupStart'  => '\Cme\Template\Helpers::groupStart',
                'groupEnd'  => '\Cme\Template\Helpers::groupEnd',
                'elNumber'  => '\Cme\Template\Helpers::elNumber',
                'destination'  => '\Cme\Template\Helpers::destination',
            )
        );


        $phpStr = \LightnCandy\LightnCandy::compile($template, $options);
        // Save the compiled PHP code into a php file
        file_put_contents($destination, '<?php ' . $phpStr . '?>');
        // get the file and return it
        // Get the render function from the php file
        return $destination;
    }


}
