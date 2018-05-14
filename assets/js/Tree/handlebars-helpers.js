Handlebars.registerHelper('environment', function(options) {
    return 'has-js';
});

Handlebars.registerHelper('groupStart', function(questionID, groups, options) {
    // find the group
    console.log(questionID);
    for(let i = 0; i < groups.length; i++) {
        // check if it's the first in the question order
        if(groups[i].questions[0] === questionID) {
            console.log('found first question', questionID);
            // pass the values we'll need in the template
            return options.fn({groupID: groups[i].ID, groupTitle: groups[i].title});
        }
    }
    return '';
});

Handlebars.registerHelper('groupEnd', function(questionID, groups, options) {
    // find the group
    for(let i = 0; i < groups.length; i++) {
        let questions = groups[i].questions;
        // check if it's the last in the question order
        if(questions[questions.length - 1] === questionID) {
            console.log('found last question', questionID);
            return options.fn(this);
        }
    }
    return '';
});

Handlebars.registerHelper('elNumber', function(el_order) {

    // for the arrow direction we could calculate the position on the tree-view and set an angle so the arrow points towards the destination...
    return parseInt(el_order) + 1;
});

Handlebars.registerHelper('destination', function(destinationID, destinationType, optionID, question_index, options) {
    let data,
        destination,
        destinationNumber,
        destinationTitle,
        destinationIcon,
        i;
    // set data (either questions or ends most likely) from main data tree
    data = options.data.root[destinationType+'s']
    i = 0;
    if(destinationType === 'question') {
        // start it at the question_index.
        // An option will never go backwards, so we don't care
        // about the previous ones
        i = question_index;
    }

    // find the destination
    for (i; i < data.length; i++) {
        if (data[i][destinationType+'ID'] === destinationID) {
            destination = data[i];
            if(destinationType === 'question') {
                destinationNumber = i+ 1
                destinationTitle = 'Question '+ destinationNumber
                destinationIcon = 'arrow'
            } else {
                destinationTitle = data[i].title
                destinationIcon = ''
            }

            break
        }
    }

    // for the arrow direction we could calculate the position on the tree-view and set an angle so the arrow points towards the destination...
    return options.fn({
            destinationTitle: destinationTitle,
            destinationType: destinationType,
            destinationIcon: destinationIcon,
            optionID: optionID
        });
});
