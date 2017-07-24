this["TreeTemplates"] = this["TreeTemplates"] || {};
this["TreeTemplates"]["tree"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.questions : depth0),{"name":"each","hash":{},"fn":container.program(2, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "");
},"2":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3=container.escapeExpression;

  return "            <section id=\"enp-tree__destination--"
    + alias3(((helper = (helper = helpers.question_id || (depth0 != null ? depth0.question_id : depth0)) != null ? helper : alias2),(typeof helper === "function" ? helper.call(alias1,{"name":"question_id","hash":{},"data":data}) : helper)))
    + "\" class=\"enp-tree__question\" "
    + ((stack1 = (helpers.ifIn || (depth0 && depth0.ifIn) || alias2).call(alias1,(depth0 != null ? depth0.question_id : depth0),((stack1 = ((stack1 = (depths[1] != null ? depths[1].groups : depths[1])) != null ? stack1["0"] : stack1)) != null ? stack1.questions : stack1),{"name":"ifIn","hash":{},"fn":container.program(3, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + ">\n                <h4 class=\"enp-tree__question-title\">"
    + alias3((helpers.upper || (depth0 && depth0.upper) || alias2).call(alias1,(depth0 != null ? depth0.title : depth0),{"name":"upper","hash":{},"data":data}))
    + "</h4>\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.options : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "            </section>\n";
},"3":function(container,depth0,helpers,partials,data) {
    return " style=\"background: red;\"";
},"5":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "                    <ul class=\"enp-tree__options\">\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.options : depth0),{"name":"each","hash":{},"fn":container.program(6, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "                    </ul>\n";
},"6":function(container,depth0,helpers,partials,data) {
    var helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "                            <li id=\"enp-tree__option--"
    + alias4(((helper = (helper = helpers.option_id || (depth0 != null ? depth0.option_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"option_id","hash":{},"data":data}) : helper)))
    + "\" class=\"enp-tree__option\"><a class=\"enp-tree__option-link\"  href=\"#enp-tree__destination--"
    + alias4(((helper = (helper = helpers.destination_id || (depth0 != null ? depth0.destination_id : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"destination_id","hash":{},"data":data}) : helper)))
    + "\">"
    + alias4(((helper = (helper = helpers.title || (depth0 != null ? depth0.title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"title","hash":{},"data":data}) : helper)))
    + "</a></li>\n";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, alias1=depth0 != null ? depth0 : (container.nullContext || {}), alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<section id=\"enp-tree\" class=\"enp-tree\">\n    <div class=\"enp-tree__intro\">\n        <h2>"
    + alias4(((helper = (helper = helpers.title || (depth0 != null ? depth0.title : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"title","hash":{},"data":data}) : helper)))
    + "</h2>\n        <!--<a class=\"enp-tree__start\" href=\"#enp-tree__destination--1\">"
    + alias4(((helper = (helper = helpers.startButton || (depth0 != null ? depth0.startButton : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"startButton","hash":{},"data":data}) : helper)))
    + "</a>-->\n    </div>\n\n"
    + ((stack1 = helpers["if"].call(alias1,(depth0 != null ? depth0.questions : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\n\n</section>\n";
},"useData":true,"useDepths":true});