<?php use \LightnCandy\SafeString as SafeString;use \LightnCandy\Runtime as LR;return function ($in = null, $options = null) {
    $helpers = array(            'environment' => function($options) {
        return 'no-js';
    },
            'group_start' => function($question_id, $group_id, $groups, $options) {
        foreach($groups as $group) {
            if($group['group_id'] === $group_id) {
                // check if it's the first in the question order
                if($group['questions'][0] === $question_id) {
                    return $options['fn']($group['title']);
                } else {
                    return '';
                }
            }
        }
        return '';
    },
            'group_end' => function($question_id, $group_id, $groups, $options) {
        foreach($groups as $group) {
            if($group['group_id'] === $group_id) {
                // check if it's the first in the question order
                $last_question = array_values(array_slice($group['questions'], -1))[0];
                if($last_question === $question_id) {
                    return $options['fn']();
                } else {
                    return '';
                }
            }
        }
        return '';
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
    return '<section id="enp-tree--'.LR::raw($cx, (($inary && isset($in['tree_id'])) ? $in['tree_id'] : null)).'" class="enp-tree enp-tree--'.LR::raw($cx, LR::hbch($cx, 'environment', array(array(),array()), 'raw', $in)).'">
    <div class="enp-tree__intro">
        <h2 class="enp-tree__title enp-tree__title--tree">'.LR::raw($cx, (($inary && isset($in['title'])) ? $in['title'] : null)).'</h2>
'.((LR::ifvar($cx, (($inary && isset($in['starts'])) ? $in['starts'] : null), false)) ? ''.LR::sec($cx, (($inary && isset($in['starts'])) ? $in['starts'] : null), null, $in, true, function($cx, $in) {$inary=is_array($in);return '                <div class="enp-tree__start-container">
                    <p><a class="enp-tree__start" href="#enp-tree__destination--'.LR::raw($cx, (($inary && isset($in['destination_id'])) ? $in['destination_id'] : null)).'" data-enp-tree-destination-id="'.LR::raw($cx, (($inary && isset($in['destination_id'])) ? $in['destination_id'] : null)).'">'.LR::raw($cx, (($inary && isset($in['title'])) ? $in['title'] : null)).'</a></p>
'.((LR::ifvar($cx, (($inary && isset($in['content'])) ? $in['content'] : null), false)) ? '                        <div class="enp-tree__description enp-tree__description--start">
                            '.LR::encq($cx, (($inary && isset($in['content'])) ? $in['content'] : null)).'
                        </div>
' : '').'                </div>
';}).'' : '').'    </div>

'.((LR::ifvar($cx, (($inary && isset($in['questions'])) ? $in['questions'] : null), false)) ? ''.LR::sec($cx, (($inary && isset($in['questions'])) ? $in['questions'] : null), null, $in, true, function($cx, $in) {$inary=is_array($in);return ''.((LR::ifvar($cx, (($inary && isset($in['group_id'])) ? $in['group_id'] : null), false)) ? ''.LR::hbbch($cx, 'group_start', array(array((($inary && isset($in['question_id'])) ? $in['question_id'] : null),(($inary && isset($in['group_id'])) ? $in['group_id'] : null),((isset($cx['scopes'][count($cx['scopes'])-1]) && is_array($cx['scopes'][count($cx['scopes'])-1]) && isset($cx['scopes'][count($cx['scopes'])-1]['groups'])) ? $cx['scopes'][count($cx['scopes'])-1]['groups'] : null)),array()), $in, false, function($cx, $in) {$inary=is_array($in);return '                    <div class="enp-tree__group">
                        <h3 class="enp-tree__title enp-tree__title--group">'.LR::encq($cx, $in).'</h3>
';}).'' : '').'            <section id="enp-tree__destination--'.LR::raw($cx, (($inary && isset($in['question_id'])) ? $in['question_id'] : null)).'" class="enp-tree__question" >
                <h4 class="enp-tree__title enp-tree__title--question">'.LR::encq($cx, (($inary && isset($in['title'])) ? $in['title'] : null)).'</h4>
'.((LR::ifvar($cx, (($inary && isset($in['content'])) ? $in['content'] : null), false)) ? '                    <div class="enp-tree__description enp-tree__description--question">'.LR::encq($cx, (($inary && isset($in['content'])) ? $in['content'] : null)).'</div>
' : '').''.((LR::ifvar($cx, (($inary && isset($in['options'])) ? $in['options'] : null), false)) ? '                    <ul class="enp-tree__options">
'.LR::sec($cx, (($inary && isset($in['options'])) ? $in['options'] : null), null, $in, true, function($cx, $in) {$inary=is_array($in);return '                            <li id="enp-tree__option--'.LR::raw($cx, (($inary && isset($in['option_id'])) ? $in['option_id'] : null)).'" class="enp-tree__option"><a class="enp-tree__option-link"  href="#enp-tree__destination--'.LR::raw($cx, (($inary && isset($in['destination_id'])) ? $in['destination_id'] : null)).'" data-enp-tree-destination-id="'.LR::raw($cx, (($inary && isset($in['destination_id'])) ? $in['destination_id'] : null)).'">'.LR::encq($cx, (($inary && isset($in['title'])) ? $in['title'] : null)).'</a></li>
';}).'                    </ul>
' : '').'            </section>

'.((LR::ifvar($cx, (($inary && isset($in['group_id'])) ? $in['group_id'] : null), false)) ? ''.LR::hbbch($cx, 'group_end', array(array((($inary && isset($in['question_id'])) ? $in['question_id'] : null),(($inary && isset($in['group_id'])) ? $in['group_id'] : null),((isset($cx['scopes'][count($cx['scopes'])-1]) && is_array($cx['scopes'][count($cx['scopes'])-1]) && isset($cx['scopes'][count($cx['scopes'])-1]['groups'])) ? $cx['scopes'][count($cx['scopes'])-1]['groups'] : null)),array()), $in, false, function($cx, $in) {$inary=is_array($in);return '                    </div>
';}).'' : '').'';}).'' : '').'
'.((LR::ifvar($cx, (($inary && isset($in['ends'])) ? $in['ends'] : null), false)) ? ''.LR::sec($cx, (($inary && isset($in['ends'])) ? $in['ends'] : null), null, $in, true, function($cx, $in) {$inary=is_array($in);return '            <section id="enp-tree__destination--'.LR::raw($cx, (($inary && isset($in['end_id'])) ? $in['end_id'] : null)).'" class="enp-tree__end">
                <p>End</p>
                <h3 class="enp-tree__title enp-tree__title--end">'.LR::raw($cx, (($inary && isset($in['title'])) ? $in['title'] : null)).'</h3>
'.((LR::ifvar($cx, (($inary && isset($in['content'])) ? $in['content'] : null), false)) ? '                    <div class="enp-tree__description enp-tree__description--end">'.LR::encq($cx, (($inary && isset($in['content'])) ? $in['content'] : null)).'</div>
' : '').'                <a class="enp-tree__btn enp-tree__btn--retry" href="#enp-tree--'.LR::raw($cx, ((isset($cx['scopes'][count($cx['scopes'])-1]) && is_array($cx['scopes'][count($cx['scopes'])-1]) && isset($cx['scopes'][count($cx['scopes'])-1]['tree_id'])) ? $cx['scopes'][count($cx['scopes'])-1]['tree_id'] : null)).'">Start Again</a>
            </section>
';}).'' : '').'

</section>
';
};?>