this["TreeTemplates"] = this["TreeTemplates"] || {};
this["TreeTemplates"]["tree"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "                <div class=\"enp-tree__start-container\">\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.starts : depth0),{"name":"each","hash":{},"fn":container.program(2, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "                </div>\n";
},"2":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "                        <p><a id=\"enp-tree__el--"
    + container.escapeExpression(((helper = (helper = helpers.start_id || (depth0 != null ? depth0.start_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"start_id","hash":{},"data":data}) : helper)))
    + "\" class=\"enp-tree__btn enp-tree__start\" href=\"#enp-tree__el--"
    + ((stack1 = ((helper = (helper = helpers.destination_id || (depth0 != null ? depth0.destination_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"destination_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\">"
    + ((stack1 = ((helper = (helper = helpers.title || (depth0 != null ? depth0.title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"title","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "</a></p>\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.content : depth0),{"name":"if","hash":{},"fn":container.program(3, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "");
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return "                            <div class=\"enp-tree__description enp-tree__description--start\">\n                                "
    + container.escapeExpression(((helper = (helper = helpers.content || (depth0 != null ? depth0.content : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"content","hash":{},"data":data}) : helper)))
    + "\n                            </div>\n";
},"5":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return "                <div class=\"enp-tree__questions\">\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.questions : depth0),{"name":"each","hash":{},"fn":container.program(6, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "                </div>\n";
},"6":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.group_id : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "                        <section id=\"enp-tree__el--"
    + ((stack1 = ((helper = (helper = helpers.question_id || (depth0 != null ? depth0.question_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"question_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree__question\" tabindex=\"0\">\n                            <span class=\"enp-tree__el-number\">"
    + alias4((helpers.el_number || (depth0 && depth0.el_number) || alias2).call(alias1,(depth0 != null ? depth0.order : depth0),{"name":"el_number","hash":{},"data":data}))
    + "</span>\n                            <h4 class=\"enp-tree__title enp-tree__title--question\">"
    + alias4(((helper = (helper = helpers.title || (depth0 != null ? depth0.title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"title","hash":{},"data":data}) : helper)))
    + "</h4>\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.content : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.options : depth0),{"name":"if","hash":{},"fn":container.program(12, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "                        </section>\n\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.group_id : depth0),{"name":"if","hash":{},"fn":container.program(17, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "");
},"7":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return ((stack1 = (helpers.group_start || (depth0 && depth0.group_start) || helpers.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.question_id : depth0),(depth0 != null ? depth0.group_id : depth0),(depths[1] != null ? depths[1].groups : depths[1]),{"name":"group_start","hash":{},"fn":container.program(8, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "");
},"8":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "                                <div id=\"enp-tree__el--"
    + ((stack1 = ((helper = (helper = helpers.group_id || (depth0 != null ? depth0.group_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"group_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree__group\">\n                                    <h3 class=\"enp-tree__title enp-tree__title--group\">"
    + container.escapeExpression(((helper = (helper = helpers.group_title || (depth0 != null ? depth0.group_title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"group_title","hash":{},"data":data}) : helper)))
    + "</h3>\n";
},"10":function(container,depth0,helpers,partials,data) {
    var helper;

  return "                                <div class=\"enp-tree__description enp-tree__description--question\">"
    + container.escapeExpression(((helper = (helper = helpers.content || (depth0 != null ? depth0.content : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"content","hash":{},"data":data}) : helper)))
    + "</div>\n";
},"12":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return "                                <ul class=\"enp-tree__options\">\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.options : depth0),{"name":"each","hash":{},"fn":container.program(13, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "                                </ul>\n";
},"13":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "                                        <li class=\"enp-tree__option\"><a class=\"enp-tree__option-link\" id=\"enp-tree__el--"
    + ((stack1 = ((helper = (helper = helpers.option_id || (depth0 != null ? depth0.option_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"option_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" href=\"#enp-tree__el--"
    + ((stack1 = ((helper = (helper = helpers.destination_id || (depth0 != null ? depth0.destination_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"destination_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\">\n                                            <span class=\"enp-tree__option-title\">"
    + container.escapeExpression(((helper = (helper = helpers.title || (depth0 != null ? depth0.title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"title","hash":{},"data":data}) : helper)))
    + "</span>\n                                            <span class=\"enp-tree__destination enp-tree__destination--"
    + ((stack1 = ((helper = (helper = helpers.destination_type || (depth0 != null ? depth0.destination_type : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"destination_type","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\">\n"
    + ((stack1 = (helpers.destination || (depth0 && depth0.destination) || alias2).call(alias1,(depth0 != null ? depth0.destination_id : depth0),(depth0 != null ? depth0.destination_type : depth0),(depth0 != null ? depth0.option_id : depth0),(container.data(data, 1) && container.data(data, 1).index),{"name":"destination","hash":{},"fn":container.program(14, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "                                            </span></a></li>\n";
},"14":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {});

  return "                                                    <span class=\"enp-tree__destination-title\">"
    + ((stack1 = ((helper = (helper = helpers.destination_title || (depth0 != null ? depth0.destination_title : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(alias1,{"name":"destination_title","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "</span>\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.destination_icon : depth0),{"name":"if","hash":{},"fn":container.program(15, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "");
},"15":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "                                                        <span class=\"enp-tree__icon-wrap\"><svg id=\"enp-tree__destination-icon--"
    + ((stack1 = ((helper = (helper = helpers.option_id || (depth0 != null ? depth0.option_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"option_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree__icon enp-tree__icon--"
    + ((stack1 = ((helper = (helper = helpers.destination_icon || (depth0 != null ? depth0.destination_icon : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"destination_icon","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\"><use xlink:href=\"#icon-"
    + ((stack1 = ((helper = (helper = helpers.destination_icon || (depth0 != null ? depth0.destination_icon : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"destination_icon","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\"></use></svg></span>\n";
},"17":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return ((stack1 = (helpers.group_end || (depth0 && depth0.group_end) || helpers.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.question_id : depth0),(depth0 != null ? depth0.group_id : depth0),(depths[1] != null ? depths[1].groups : depths[1]),{"name":"group_end","hash":{},"fn":container.program(18, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "");
},"18":function(container,depth0,helpers,partials,data) {
    return "                                </div>\n";
},"20":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return "                <div class=\"enp-tree__ends\">\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.ends : depth0),{"name":"each","hash":{},"fn":container.program(21, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "                </div>\n";
},"21":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression, alias5=container.lambda;

  return "\n                        <section id=\"enp-tree__el--"
    + ((stack1 = ((helper = (helper = helpers.end_id || (depth0 != null ? depth0.end_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"end_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree__end\" tabindex=\"0\">\n                            <h3 class=\"enp-tree__title enp-tree__title--end\">"
    + ((stack1 = ((helper = (helper = helpers.title || (depth0 != null ? depth0.title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"title","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "</h3>\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.content : depth0),{"name":"if","hash":{},"fn":container.program(22, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\n                            <ul class=\"enp-tree__end-options\">\n                                <li class=\"enp-tree__end-option\">\n                                    <a id=\"enp-tree__restart--"
    + alias4(((helper = (helper = helpers.end_id || (depth0 != null ? depth0.end_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"end_id","hash":{},"data":data}) : helper)))
    + "\" class=\"enp-tree__btn enp-tree__btn--retry\" href=\"#enp-tree__el--"
    + ((stack1 = alias5(((stack1 = ((stack1 = (depths[1] != null ? depths[1].questions : depths[1])) != null ? stack1["0"] : stack1)) != null ? stack1.question_id : stack1), depth0)) != null ? stack1 : "")
    + "\">Start Again</a>\n                                </li>\n                                <li class=\"enp-tree__end-option\">\n                                    <a id=\"enp-tree__overview--"
    + alias4(((helper = (helper = helpers.end_id || (depth0 != null ? depth0.end_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"end_id","hash":{},"data":data}) : helper)))
    + "\" class=\"enp-tree__btn enp-tree__btn--overview\" href=\"#enp-tree--"
    + ((stack1 = alias5((depths[1] != null ? depths[1].tree_id : depths[1]), depth0)) != null ? stack1 : "")
    + "\">Go to Overview</a>\n                                </li>\n                            </ul>\n                        </section>\n";
},"22":function(container,depth0,helpers,partials,data) {
    var helper;

  return "                                <div class=\"enp-tree__description enp-tree__description--end\">"
    + container.escapeExpression(((helper = (helper = helpers.content || (depth0 != null ? depth0.content : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"content","hash":{},"data":data}) : helper)))
    + "</div>\n";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "<section id=\"enp-tree--"
    + ((stack1 = ((helper = (helper = helpers.tree_id || (depth0 != null ? depth0.tree_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"tree_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree enp-tree--"
    + ((stack1 = ((helper = (helper = helpers.environment || (depth0 != null ? depth0.environment : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"environment","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" tabindex=\"-1\">\n    <svg style=\"visibility: hidden; position:absolute; height: 0; width: 0;\"><symbol id=\"icon-arrow\" viewBox=\"0 0 24 24\"><title>arrow</title><path d=\"M20.744 12.669c0 0 0 0 0 0 0.006-0.006 0.006-0.006 0.006-0.006s0 0 0 0 0.006-0.006 0.006-0.006c0 0 0.006-0.006 0.006-0.006s0 0 0 0 0.006-0.006 0.006-0.006c0 0 0 0 0 0 0.063-0.075 0.112-0.156 0.15-0.244 0 0 0 0 0-0.006 0 0 0-0.006 0-0.006s0-0.006 0-0.006c0 0 0 0 0 0 0.038-0.094 0.063-0.194 0.069-0.3 0 0 0 0 0 0s0-0.006 0-0.006c0 0 0-0.006 0-0.006s0-0.006 0-0.006c0 0 0-0.006 0-0.006s0 0 0-0.006c0-0.025 0-0.050 0-0.075 0 0 0 0 0-0.006 0 0 0-0.006 0-0.006s0-0.006 0-0.006c0 0 0-0.006 0-0.006s0-0.006 0-0.006c0 0 0 0 0 0-0.006-0.106-0.031-0.206-0.069-0.3 0 0 0 0 0-0.006 0 0 0 0 0-0.006 0 0 0-0.006-0.006-0.006 0 0 0 0 0 0-0.038-0.094-0.094-0.175-0.156-0.256 0 0 0 0 0 0s-0.006-0.006-0.006-0.006c0 0 0 0 0 0s-0.006-0.006-0.006-0.006-0.006-0.006-0.006-0.006 0 0 0-0.006c-0.012-0.012-0.025-0.025-0.037-0.037l-6-6c-0.387-0.387-1.025-0.387-1.413 0s-0.387 1.025 0 1.413l4.294 4.294h-13.581c-0.55 0-1 0.45-1 1s0.45 1 1 1h13.587l-4.294 4.294c-0.387 0.387-0.387 1.025 0 1.413 0.194 0.194 0.45 0.294 0.706 0.294s0.513-0.1 0.706-0.294l5.994-5.994c0.019-0.025 0.031-0.044 0.044-0.056z\"></path></symbol><symbol id=\"icon-arrow-turn\" viewBox=\"0 0 24 24\"><title>arrow</title><path d=\"M18.984 15l-6 6-1.406-1.406 3.609-3.609h-11.203v-12h2.016v10.031h9.188l-3.609-3.609 1.406-1.406z\"></path></symbol></svg>\n    <div class=\"enp-tree__intro-wrapper\">\n        <div id=\"enp-tree__intro--"
    + ((stack1 = ((helper = (helper = helpers.tree_id || (depth0 != null ? depth0.tree_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"tree_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree__intro\">\n            <h2 class=\"enp-tree__title enp-tree__title--tree\">"
    + ((stack1 = ((helper = (helper = helpers.title || (depth0 != null ? depth0.title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"title","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "</h2>\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.starts : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "        </div>\n    </div>\n    <div id=\"enp-tree__content-wrapper--"
    + ((stack1 = ((helper = (helper = helpers.tree_id || (depth0 != null ? depth0.tree_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"tree_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree__content-wrapper\">\n        <div id=\"enp-tree__content-window--"
    + ((stack1 = ((helper = (helper = helpers.tree_id || (depth0 != null ? depth0.tree_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"tree_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree__content-window\">\n            <div id=\"enp-tree__content-panel--"
    + ((stack1 = ((helper = (helper = helpers.tree_id || (depth0 != null ? depth0.tree_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"tree_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree__content-panel\">\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.questions : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.ends : depth0),{"name":"if","hash":{},"fn":container.program(20, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "        </div>\n    </div>\n\n</section>\n";
},"useData":true,"useDepths":true});