<?php use \LightnCandy\SafeString as SafeString;use \LightnCandy\Runtime as LR;return function ($in = null, $options = null) {
    $helpers = array(            'environment' => function($options) {
        return 'no-js';
    },
            'group_start' => function($question_id, $group_id, $groups, $options) {
        foreach($groups as $group) {
            if($group['group_id'] === $group_id) {
                // check if it's the first in the question order
                if($group['questions'][0] === $question_id) {
                    // set the context of the values we'll need
                    return $options['fn'](["group_id"=>$group['group_id'], "group_title"=>$group['title']]);
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
            'el_number' => function($order) {
        return $order + 1;
    },
            'destination' => function($destination_id, $destination_type, $option_id, $question_index, $options) {
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
    <svg style="visibility: hidden; position:absolute; height: 0; width: 0;"><symbol id="icon-arrow" viewBox="0 0 24 24"><title>arrow</title><path d="M20.744 12.669c0 0 0 0 0 0 0.006-0.006 0.006-0.006 0.006-0.006s0 0 0 0 0.006-0.006 0.006-0.006c0 0 0.006-0.006 0.006-0.006s0 0 0 0 0.006-0.006 0.006-0.006c0 0 0 0 0 0 0.063-0.075 0.112-0.156 0.15-0.244 0 0 0 0 0-0.006 0 0 0-0.006 0-0.006s0-0.006 0-0.006c0 0 0 0 0 0 0.038-0.094 0.063-0.194 0.069-0.3 0 0 0 0 0 0s0-0.006 0-0.006c0 0 0-0.006 0-0.006s0-0.006 0-0.006c0 0 0-0.006 0-0.006s0 0 0-0.006c0-0.025 0-0.050 0-0.075 0 0 0 0 0-0.006 0 0 0-0.006 0-0.006s0-0.006 0-0.006c0 0 0-0.006 0-0.006s0-0.006 0-0.006c0 0 0 0 0 0-0.006-0.106-0.031-0.206-0.069-0.3 0 0 0 0 0-0.006 0 0 0 0 0-0.006 0 0 0-0.006-0.006-0.006 0 0 0 0 0 0-0.038-0.094-0.094-0.175-0.156-0.256 0 0 0 0 0 0s-0.006-0.006-0.006-0.006c0 0 0 0 0 0s-0.006-0.006-0.006-0.006-0.006-0.006-0.006-0.006 0 0 0-0.006c-0.012-0.012-0.025-0.025-0.037-0.037l-6-6c-0.387-0.387-1.025-0.387-1.413 0s-0.387 1.025 0 1.413l4.294 4.294h-13.581c-0.55 0-1 0.45-1 1s0.45 1 1 1h13.587l-4.294 4.294c-0.387 0.387-0.387 1.025 0 1.413 0.194 0.194 0.45 0.294 0.706 0.294s0.513-0.1 0.706-0.294l5.994-5.994c0.019-0.025 0.031-0.044 0.044-0.056z"></path></symbol><symbol id="icon-arrow-turn" viewBox="0 0 24 24"><title>arrow</title><path d="M18.984 15l-6 6-1.406-1.406 3.609-3.609h-11.203v-12h2.016v10.031h9.188l-3.609-3.609 1.406-1.406z"></path></symbol></svg>
    <div class="enp-tree__intro-wrapper">
        <div id="enp-tree__intro--'.LR::raw($cx, (($inary && isset($in['tree_id'])) ? $in['tree_id'] : null)).'" class="enp-tree__intro">
            <h2 class="enp-tree__title enp-tree__title--tree">'.LR::raw($cx, (($inary && isset($in['title'])) ? $in['title'] : null)).'</h2>
'.((LR::ifvar($cx, (($inary && isset($in['starts'])) ? $in['starts'] : null), false)) ? '                <div class="enp-tree__start-container">
'.LR::sec($cx, (($inary && isset($in['starts'])) ? $in['starts'] : null), null, $in, true, function($cx, $in) {$inary=is_array($in);return '                        <p><a id="enp-tree__el--'.LR::encq($cx, (($inary && isset($in['start_id'])) ? $in['start_id'] : null)).'" class="enp-tree__btn enp-tree__start" href="#enp-tree__el--'.LR::raw($cx, (($inary && isset($in['destination_id'])) ? $in['destination_id'] : null)).'">'.LR::raw($cx, (($inary && isset($in['title'])) ? $in['title'] : null)).'</a></p>
'.((LR::ifvar($cx, (($inary && isset($in['content'])) ? $in['content'] : null), false)) ? '                            <div class="enp-tree__description enp-tree__description--start">
                                '.LR::encq($cx, (($inary && isset($in['content'])) ? $in['content'] : null)).'
                            </div>
' : '').'';}).'                </div>
' : '').'        </div>
    </div>
    <div id="enp-tree__content-wrapper--'.LR::raw($cx, (($inary && isset($in['tree_id'])) ? $in['tree_id'] : null)).'" class="enp-tree__content-wrapper">
        <div id="enp-tree__content-window--'.LR::raw($cx, (($inary && isset($in['tree_id'])) ? $in['tree_id'] : null)).'" class="enp-tree__content-window">
            <div id="enp-tree__content-panel--'.LR::raw($cx, (($inary && isset($in['tree_id'])) ? $in['tree_id'] : null)).'" class="enp-tree__content-panel">
'.((LR::ifvar($cx, (($inary && isset($in['questions'])) ? $in['questions'] : null), false)) ? '                <div class="enp-tree__questions">
'.LR::sec($cx, (($inary && isset($in['questions'])) ? $in['questions'] : null), null, $in, true, function($cx, $in) {$inary=is_array($in);return ''.((LR::ifvar($cx, (($inary && isset($in['group_id'])) ? $in['group_id'] : null), false)) ? ''.LR::hbbch($cx, 'group_start', array(array((($inary && isset($in['question_id'])) ? $in['question_id'] : null),(($inary && isset($in['group_id'])) ? $in['group_id'] : null),((isset($cx['scopes'][count($cx['scopes'])-1]) && is_array($cx['scopes'][count($cx['scopes'])-1]) && isset($cx['scopes'][count($cx['scopes'])-1]['groups'])) ? $cx['scopes'][count($cx['scopes'])-1]['groups'] : null)),array()), $in, false, function($cx, $in) {$inary=is_array($in);return '                                <div id="enp-tree__el--'.LR::raw($cx, (($inary && isset($in['group_id'])) ? $in['group_id'] : null)).'" class="enp-tree__group">
                                    <h3 class="enp-tree__title enp-tree__title--group">'.LR::encq($cx, (($inary && isset($in['group_title'])) ? $in['group_title'] : null)).'</h3>
';}).'' : '').'                        <section id="enp-tree__el--'.LR::raw($cx, (($inary && isset($in['question_id'])) ? $in['question_id'] : null)).'" class="enp-tree__question" tabindex="0">
                            <span class="enp-tree__el-number">'.LR::encq($cx, LR::hbch($cx, 'el_number', array(array((($inary && isset($in['order'])) ? $in['order'] : null)),array()), 'encq', $in)).'</span>
                            <h4 class="enp-tree__title enp-tree__title--question">'.LR::encq($cx, (($inary && isset($in['title'])) ? $in['title'] : null)).'</h4>
'.((LR::ifvar($cx, (($inary && isset($in['content'])) ? $in['content'] : null), false)) ? '                                <div class="enp-tree__description enp-tree__description--question">'.LR::encq($cx, (($inary && isset($in['content'])) ? $in['content'] : null)).'</div>
' : '').''.((LR::ifvar($cx, (($inary && isset($in['options'])) ? $in['options'] : null), false)) ? '                                <ul class="enp-tree__options">
'.LR::sec($cx, (($inary && isset($in['options'])) ? $in['options'] : null), null, $in, true, function($cx, $in) {$inary=is_array($in);return '                                        <li class="enp-tree__option"><a class="enp-tree__option-link" id="enp-tree__el--'.LR::raw($cx, (($inary && isset($in['option_id'])) ? $in['option_id'] : null)).'" href="#enp-tree__el--'.LR::raw($cx, (($inary && isset($in['destination_id'])) ? $in['destination_id'] : null)).'">
                                            <span class="enp-tree__option-title">'.LR::encq($cx, (($inary && isset($in['title'])) ? $in['title'] : null)).'</span>
                                            <span class="enp-tree__destination enp-tree__destination--'.LR::raw($cx, (($inary && isset($in['destination_type'])) ? $in['destination_type'] : null)).'">
'.LR::hbbch($cx, 'destination', array(array((($inary && isset($in['destination_id'])) ? $in['destination_id'] : null),(($inary && isset($in['destination_type'])) ? $in['destination_type'] : null),(($inary && isset($in['option_id'])) ? $in['option_id'] : null),((isset($cx['sp_vars']['_parent']) && isset($cx['sp_vars']['_parent']['index'])) ? $cx['sp_vars']['_parent']['index'] : null)),array()), $in, false, function($cx, $in) {$inary=is_array($in);return '                                                    <span class="enp-tree__destination-title">'.LR::raw($cx, (($inary && isset($in['destination_title'])) ? $in['destination_title'] : null)).'</span>
'.((LR::ifvar($cx, (($inary && isset($in['destination_icon'])) ? $in['destination_icon'] : null), false)) ? '                                                        <span class="enp-tree__icon-wrap"><svg id="enp-tree__destination-icon--'.LR::raw($cx, (($inary && isset($in['option_id'])) ? $in['option_id'] : null)).'" class="enp-tree__icon enp-tree__icon--'.LR::raw($cx, (($inary && isset($in['destination_icon'])) ? $in['destination_icon'] : null)).'"><use xlink:href="#icon-'.LR::raw($cx, (($inary && isset($in['destination_icon'])) ? $in['destination_icon'] : null)).'"></use></svg></span>
' : '').'';}).'                                            </span></a></li>
';}).'                                </ul>
' : '').'                        </section>

'.((LR::ifvar($cx, (($inary && isset($in['group_id'])) ? $in['group_id'] : null), false)) ? ''.LR::hbbch($cx, 'group_end', array(array((($inary && isset($in['question_id'])) ? $in['question_id'] : null),(($inary && isset($in['group_id'])) ? $in['group_id'] : null),((isset($cx['scopes'][count($cx['scopes'])-1]) && is_array($cx['scopes'][count($cx['scopes'])-1]) && isset($cx['scopes'][count($cx['scopes'])-1]['groups'])) ? $cx['scopes'][count($cx['scopes'])-1]['groups'] : null)),array()), $in, false, function($cx, $in) {$inary=is_array($in);return '                                </div>
';}).'' : '').'';}).'                </div>
' : '').'
'.((LR::ifvar($cx, (($inary && isset($in['ends'])) ? $in['ends'] : null), false)) ? '                <div class="enp-tree__ends">
'.LR::sec($cx, (($inary && isset($in['ends'])) ? $in['ends'] : null), null, $in, true, function($cx, $in) {$inary=is_array($in);return '
                        <section id="enp-tree__el--'.LR::raw($cx, (($inary && isset($in['end_id'])) ? $in['end_id'] : null)).'" class="enp-tree__end" tabindex="0">
                            <h3 class="enp-tree__title enp-tree__title--end">'.LR::raw($cx, (($inary && isset($in['title'])) ? $in['title'] : null)).'</h3>
'.((LR::ifvar($cx, (($inary && isset($in['content'])) ? $in['content'] : null), false)) ? '                                <div class="enp-tree__description enp-tree__description--end">'.LR::encq($cx, (($inary && isset($in['content'])) ? $in['content'] : null)).'</div>
' : '').'
                            <ul class="enp-tree__end-options">
                                <li class="enp-tree__end-option">
                                    <a id="enp-tree__restart--'.LR::encq($cx, (($inary && isset($in['end_id'])) ? $in['end_id'] : null)).'" class="enp-tree__btn enp-tree__btn--retry" href="#enp-tree__el--'.LR::raw($cx, ((isset($cx['scopes'][count($cx['scopes'])-1]) && is_array($cx['scopes'][count($cx['scopes'])-1]['questions']['0']) && isset($cx['scopes'][count($cx['scopes'])-1]['questions']['0']['question_id'])) ? $cx['scopes'][count($cx['scopes'])-1]['questions']['0']['question_id'] : null)).'">Start Again</a>
                                </li>
                                <li class="enp-tree__end-option">
                                    <a id="enp-tree__overview--'.LR::encq($cx, (($inary && isset($in['end_id'])) ? $in['end_id'] : null)).'" class="enp-tree__btn enp-tree__btn--overview" href="#enp-tree--'.LR::raw($cx, ((isset($cx['scopes'][count($cx['scopes'])-1]) && is_array($cx['scopes'][count($cx['scopes'])-1]) && isset($cx['scopes'][count($cx['scopes'])-1]['tree_id'])) ? $cx['scopes'][count($cx['scopes'])-1]['tree_id'] : null)).'">Go to Overview</a>
                                </li>
                            </ul>
                        </section>
';}).'                </div>
' : '').'        </div>
    </div>

</section>
';
};?>