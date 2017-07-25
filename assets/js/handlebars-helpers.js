Handlebars.registerHelper('group_start', function(question_id, group_id, groups, options) {
    // find the group
    for(let i = 0; i < groups.length; i++) {
        if(groups[i].group_id === group_id) {
            // check if it's the first in the question order
            if(groups[i].questions[0] === question_id) {
                return options.fn(groups[i].title);
            } else {
                return '';
            }
        }
    }
    return '';
});

Handlebars.registerHelper('group_end', function(question_id, group_id, groups, options) {
    // find the group
    for(let i = 0; i < groups.length; i++) {
        if(groups[i].group_id === group_id) {
            let questions = groups[i].questions;
            // check if it's the last in the question order
            if(questions[questions.length - 1] === question_id) {
                return options.fn(this);
            } else {
                return '';
            }
        }
    }
    return '';
});

Handlebars.registerHelper('group_title', function(group_id, groups, options) {
    // find the group
    for(let i = 0; i < groups.length; i++) {
        if(groups[i].group_id === group_id) {
            return groups[i].title;
        }
    }
    return '';
});
