this["TreeTemplates"] = this["TreeTemplates"] || {};
this["TreeTemplates"]["tree"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "            <div class=\"enp-tree__start-container\">\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.starts : depth0),{"name":"each","hash":{},"fn":container.program(2, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "            </div>\n";
},"2":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "                    <p><a id=\"enp-tree__el--"
    + container.escapeExpression(((helper = (helper = helpers.start_id || (depth0 != null ? depth0.start_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"start_id","hash":{},"data":data}) : helper)))
    + "\" class=\"enp-tree__btn enp-tree__start\" href=\"#enp-tree__el--"
    + ((stack1 = ((helper = (helper = helpers.destination_id || (depth0 != null ? depth0.destination_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"destination_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\">"
    + ((stack1 = ((helper = (helper = helpers.title || (depth0 != null ? depth0.title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"title","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "</a></p>\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.content : depth0),{"name":"if","hash":{},"fn":container.program(3, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "");
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return "                        <div class=\"enp-tree__description enp-tree__description--start\">\n                            "
    + container.escapeExpression(((helper = (helper = helpers.content || (depth0 != null ? depth0.content : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"content","hash":{},"data":data}) : helper)))
    + "\n                        </div>\n";
},"5":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return "            <div class=\"enp-tree__questions\">\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.questions : depth0),{"name":"each","hash":{},"fn":container.program(6, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "            </div>\n";
},"6":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.group_id : depth0),{"name":"if","hash":{},"fn":container.program(7, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "                    <section id=\"enp-tree__el--"
    + ((stack1 = ((helper = (helper = helpers.question_id || (depth0 != null ? depth0.question_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"question_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree__question\" tabindex=\"0\">\n                        <h4 class=\"enp-tree__title enp-tree__title--question\">"
    + container.escapeExpression(((helper = (helper = helpers.title || (depth0 != null ? depth0.title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"title","hash":{},"data":data}) : helper)))
    + "</h4>\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.content : depth0),{"name":"if","hash":{},"fn":container.program(10, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.options : depth0),{"name":"if","hash":{},"fn":container.program(12, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "                    </section>\n\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.group_id : depth0),{"name":"if","hash":{},"fn":container.program(15, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "");
},"7":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return ((stack1 = (helpers.group_start || (depth0 && depth0.group_start) || helpers.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.question_id : depth0),(depth0 != null ? depth0.group_id : depth0),(depths[1] != null ? depths[1].groups : depths[1]),{"name":"group_start","hash":{},"fn":container.program(8, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "");
},"8":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "                            <div id=\"enp-tree__el--"
    + ((stack1 = ((helper = (helper = helpers.group_id || (depth0 != null ? depth0.group_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"group_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree__group\">\n                                <h3 class=\"enp-tree__title enp-tree__title--group\">"
    + container.escapeExpression(((helper = (helper = helpers.group_title || (depth0 != null ? depth0.group_title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"group_title","hash":{},"data":data}) : helper)))
    + "</h3>\n";
},"10":function(container,depth0,helpers,partials,data) {
    var helper;

  return "                            <div class=\"enp-tree__description enp-tree__description--question\">"
    + container.escapeExpression(((helper = (helper = helpers.content || (depth0 != null ? depth0.content : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"content","hash":{},"data":data}) : helper)))
    + "</div>\n";
},"12":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "                            <ul class=\"enp-tree__options\">\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.options : depth0),{"name":"each","hash":{},"fn":container.program(13, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "                            </ul>\n";
},"13":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "                                    <li class=\"enp-tree__option\"><a class=\"enp-tree__option-link\" id=\"enp-tree__el--"
    + ((stack1 = ((helper = (helper = helpers.option_id || (depth0 != null ? depth0.option_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"option_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" href=\"#enp-tree__el--"
    + ((stack1 = ((helper = (helper = helpers.destination_id || (depth0 != null ? depth0.destination_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"destination_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\">"
    + container.escapeExpression(((helper = (helper = helpers.title || (depth0 != null ? depth0.title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"title","hash":{},"data":data}) : helper)))
    + "</a></li>\n";
},"15":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return ((stack1 = (helpers.group_end || (depth0 && depth0.group_end) || helpers.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.question_id : depth0),(depth0 != null ? depth0.group_id : depth0),(depths[1] != null ? depths[1].groups : depths[1]),{"name":"group_end","hash":{},"fn":container.program(16, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "");
},"16":function(container,depth0,helpers,partials,data) {
    return "                            </div>\n";
},"18":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.ends : depth0),{"name":"each","hash":{},"fn":container.program(19, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "");
},"19":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "                <section id=\"enp-tree__el--"
    + ((stack1 = ((helper = (helper = helpers.end_id || (depth0 != null ? depth0.end_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"end_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree__end\">\n                    <p>End</p>\n                    <h3 class=\"enp-tree__title enp-tree__title--end\">"
    + ((stack1 = ((helper = (helper = helpers.title || (depth0 != null ? depth0.title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"title","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "</h3>\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.content : depth0),{"name":"if","hash":{},"fn":container.program(20, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\n                    <ul class=\"enp-tree__end-options\">\n                        <li class=\"enp-tree__end-option\">\n                            <a id=\"enp-tree__restart--"
    + container.escapeExpression(((helper = (helper = helpers.end_id || (depth0 != null ? depth0.end_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"end_id","hash":{},"data":data}) : helper)))
    + "\" class=\"enp-tree__btn enp-tree__btn--retry\" href=\"#enp-tree--"
    + ((stack1 = container.lambda((depths[1] != null ? depths[1].tree_id : depths[1]), depth0)) != null ? stack1 : "")
    + "\">Start Again</a>\n                        </li>\n                    </ul>\n                </section>\n";
},"20":function(container,depth0,helpers,partials,data) {
    var helper;

  return "                        <div class=\"enp-tree__description enp-tree__description--end\">"
    + container.escapeExpression(((helper = (helper = helpers.content || (depth0 != null ? depth0.content : depth0)) != null ? helper : helpers.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"content","hash":{},"data":data}) : helper)))
    + "</div>\n";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function";

  return "<section id=\"enp-tree--"
    + ((stack1 = ((helper = (helper = helpers.tree_id || (depth0 != null ? depth0.tree_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"tree_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree enp-tree--"
    + ((stack1 = ((helper = (helper = helpers.environment || (depth0 != null ? depth0.environment : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"environment","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\">\n    <div id=\"enp-tree__intro--"
    + ((stack1 = ((helper = (helper = helpers.tree_id || (depth0 != null ? depth0.tree_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"tree_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree__intro\">\n        <h2 class=\"enp-tree__title enp-tree__title--tree\">"
    + ((stack1 = ((helper = (helper = helpers.title || (depth0 != null ? depth0.title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"title","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "</h2>\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.starts : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "    </div>\n    <div id=\"enp-tree__wrapper--"
    + ((stack1 = ((helper = (helper = helpers.tree_id || (depth0 != null ? depth0.tree_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"tree_id","hash":{},"data":data}) : helper))) != null ? stack1 : "")
    + "\" class=\"enp-tree__content-wrap\">\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.questions : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.ends : depth0),{"name":"if","hash":{},"fn":container.program(18, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "    </div>\n\n</section>\n";
},"useData":true,"useDepths":true});