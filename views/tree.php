<?php use \LightnCandy\SafeString as SafeString;use \LightnCandy\Runtime as LR;return function ($in = null, $options = null) {
    $helpers = array(            'upper' => function($str) {
        return strtoupper($str);
    },
            'ifIn' => function($id, $array) {
        if(in_array($id, $array)) {
            return true;
        } else {
            return false;
        }
    },
);
    $partials = array();
    $cx = array(
        'flags' => array(
            'jstrue' => false,
            'jsobj' => false,
            'jslen' => false,
            'spvar' => true,
            'prop' => false,
            'method' => false,
            'lambda' => false,
            'mustlok' => false,
            'mustlam' => false,
            'echo' => false,
            'partnc' => false,
            'knohlp' => false,
            'debug' => isset($options['debug']) ? $options['debug'] : 1,
        ),
        'constants' => array(),
        'helpers' => isset($options['helpers']) ? array_merge($helpers, $options['helpers']) : $helpers,
        'partials' => isset($options['partials']) ? array_merge($partials, $options['partials']) : $partials,
        'scopes' => array(),
        'sp_vars' => isset($options['data']) ? array_merge(array('root' => $in), $options['data']) : array('root' => $in),
        'blparam' => array(),
        'partialid' => 0,
        'runtime' => '\LightnCandy\Runtime',
    );
    
    $inary=is_array($in);
    return '<section id="enp-tree" class="enp-tree">
    <div class="enp-tree__intro">
        <h2>'.LR::encq($cx, (($inary && isset($in['title'])) ? $in['title'] : null)).'</h2>
        <!--<a class="enp-tree__start" href="#enp-tree__destination--1">'.LR::encq($cx, (($inary && isset($in['startButton'])) ? $in['startButton'] : null)).'</a>-->
    </div>

'.((LR::ifvar($cx, (($inary && isset($in['questions'])) ? $in['questions'] : null), false)) ? ''.LR::sec($cx, (($inary && isset($in['questions'])) ? $in['questions'] : null), null, $in, true, function($cx, $in) {$inary=is_array($in);return '            <section id="enp-tree__destination--'.LR::encq($cx, (($inary && isset($in['question_id'])) ? $in['question_id'] : null)).'" class="enp-tree__question" '.LR::hbbch($cx, 'ifIn', array(array((($inary && isset($in['question_id'])) ? $in['question_id'] : null),((isset($cx['scopes'][count($cx['scopes'])-1]) && is_array($cx['scopes'][count($cx['scopes'])-1]['groups']['0']) && isset($cx['scopes'][count($cx['scopes'])-1]['groups']['0']['questions'])) ? $cx['scopes'][count($cx['scopes'])-1]['groups']['0']['questions'] : null)),array()), $in, false, function($cx, $in) {$inary=is_array($in);return ' style="background: red;"';}).'>
                <h4 class="enp-tree__question-title">'.LR::encq($cx, LR::hbch($cx, 'upper', array(array((($inary && isset($in['title'])) ? $in['title'] : null)),array()), 'encq', $in)).'</h4>
'.((LR::ifvar($cx, (($inary && isset($in['options'])) ? $in['options'] : null), false)) ? '                    <ul class="enp-tree__options">
'.LR::sec($cx, (($inary && isset($in['options'])) ? $in['options'] : null), null, $in, true, function($cx, $in) {$inary=is_array($in);return '                            <li id="enp-tree__option--'.LR::encq($cx, (($inary && isset($in['option_id'])) ? $in['option_id'] : null)).'" class="enp-tree__option"><a class="enp-tree__option-link"  href="#enp-tree__destination--'.LR::encq($cx, (($inary && isset($in['destination_id'])) ? $in['destination_id'] : null)).'">'.LR::encq($cx, (($inary && isset($in['title'])) ? $in['title'] : null)).'</a></li>
';}).'                    </ul>
' : '').'            </section>
';}).'' : '').'

</section>
';
};?>