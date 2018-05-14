<?php
/**
 *
 */
namespace Cme\Template;
use Cme\Utility as Utility;

class Template
{
    public $template,
           $templateName;

    function __construct()
    {
    }

    protected function setTemplate() {
        $template = false;
        if($this->templateName !== false) {
            $template_file = file_get_contents(TREE_PATH."/templates/$this->templateName.hbs");

            if(is_string($template_file)) {
                $template = $template_file;
            }
        }

        $this->template = $template;
    }

    protected function setTemplateName($templateName) {
        if(!Utility\isSlug($templateName)) {
            return false;
        }

        $this->templateName = $templateName;
    }

    public function getTemplateName() {
        return $this->templateName;
    }

    public function getTemplate() {
        return $this->template;
    }
}
