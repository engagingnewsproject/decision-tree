'use strict';

Handlebars.registerHelper('environment', function (options) {
    return 'has-js';
});

Handlebars.registerHelper('group_start', function (question_id, group_id, groups, options) {
    // find the group
    for (var i = 0; i < groups.length; i++) {
        if (groups[i].group_id === group_id) {
            // check if it's the first in the question order
            if (groups[i].questions[0] === question_id) {
                return options.fn(groups[i].title);
            } else {
                return '';
            }
        }
    }
    return '';
});

Handlebars.registerHelper('group_end', function (question_id, group_id, groups, options) {
    // find the group
    for (var i = 0; i < groups.length; i++) {
        if (groups[i].group_id === group_id) {
            var questions = groups[i].questions;
            // check if it's the last in the question order
            if (questions[questions.length - 1] === question_id) {
                return options.fn(this);
            } else {
                return '';
            }
        }
    }
    return '';
});

Handlebars.registerHelper('group_title', function (group_id, groups, options) {
    // find the group
    for (var i = 0; i < groups.length; i++) {
        if (groups[i].group_id === group_id) {
            return groups[i].title;
        }
    }
    return '';
});
'use strict';

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

function Tree(options) {
    var _data, _state, _stateID;

    // required options
    if (typeof options.slug !== 'string') {
        throw new Error('Tree slug is required must be a string.');
    }

    if (_typeof(options.container) !== 'object') {
        throw new Error('Tree container must be an object. Try `container: document.getElementById(your-id)`.');
    }

    // constructor
    function createTree(response) {
        var data = JSON.parse(response);

        _data = data;
        _state = 'start';
        _stateID = data.starts[0].start_id;

        // render the tree
        var template = window.TreeTemplates.tree;
        var treeHTML = template(data);

        // set the HTML into the passed container
        options.container.innerHTML = treeHTML;
    }

    // getters
    this.getData = function () {
        return _data;
    };
    this.getState = function () {
        return _state;
    };
    this.getStateID = function () {
        return _stateID;
    };

    // setters
    this.setState = function (state) {
        // protect this function!
        _state = state;
    };
    this.setStateID = function (stateID) {
        // protect this function!
        _stateID = stateID;
    };

    // INIT
    // Request our Tree Data
    // create the tree
    getTreeData(options.slug, 'http://dev/decision-tree/api/v1/trees/' + options.slug + '/compiled?minfied=true').then(createTree).catch(handleTreeDataError);
}

Tree.prototype.getQuestion = function (id) {
    // get the individual item
    questionIndex = this.getIndexBy(this.getData(), 'question_id', id);
    question = this.data.questions[questionIndex];

    return question;
};

/**
* Allowed types, 'question', 'group', 'end', 'start'
*/
Tree.prototype.getDataByType = function (type, id) {
    var typeIndex = void 0,
        whitelist = void 0,
        data = void 0;
    // check allowed types
    whitelist = ['question', 'group', 'end', 'start'];

    if (!whitelist.includes(type)) {
        throw new Error("Allowed getDataByType types are " + whitelist.toString());
    }
    // get the data of this type
    data = this.getData();
    // append 's' to get the right array
    // 'question' becomes 'questions'
    data = data[type + 's'];

    // if there's an ID, let's get the specific one they're after
    if (id !== undefined) {
        // get the individual item
        typeIndex = this.getIndexBy(data, type + '_id', id);
        data = data[typeIndex];
    }

    return data;
};

Tree.prototype.getQuestions = function (id) {
    var question = void 0;
    if (id !== undefined) {
        // get the individual item
        question = this.getDataByType('question', id);
    } else {
        question = this.getDataByType('question');
    }
    return question;
};

Tree.prototype.getStarts = function (id) {
    var start = void 0;
    if (id !== undefined) {
        // get the individual item
        start = this.getDataByType('start', id);
    } else {
        start = this.getDataByType('start');
    }
    return start;
};

Tree.prototype.getEnds = function (id) {
    var end = void 0;
    if (id !== undefined) {
        // get the individual item
        end = this.getDataByType('end', id);
    } else {
        end = this.getDataByType('end');
    }
    return end;
};

Tree.prototype.getGroups = function (id) {
    var group = void 0;
    if (id !== undefined) {
        // get the individual item
        group = this.getDataByType('group', id);
    } else {
        group = this.getDataByType('group');
    }
    return group;
};

Tree.prototype.getOptions = function (question_id, option_id) {
    var option = void 0,
        optionIndex = void 0,
        question = void 0;

    // get the individual item
    question = this.getQuestions(question_id);

    if (option_id !== undefined) {
        optionIndex = this.getIndexBy(question.options, 'option_id', option_id);
        option = question.options[optionIndex];
    } else {
        option = question.options;
    }

    return option;
};

Tree.prototype.getIndexBy = function (objArray, name, value) {
    for (var i = 0; i < objArray.length; i++) {
        if (objArray[i][name] == value) {
            return i;
        }
    }
    return -1;
};

var Trees = [];

function getTreeData(slug, url) {
    var DecisionTree = void 0;

    return new Promise(function (resolve, reject) {

        var request = new XMLHttpRequest();
        request.overrideMimeType("application/json");
        request.open('GET', url, true);
        //request.responseType = 'json';
        // When the request loads, check whether it was successful
        request.onload = function () {
            if (request.status === 200) {
                // If successful, resolve the promise by passing back the request response
                resolve(request.response);
            } else {
                // If it fails, reject the promise with a error message
                reject(Error('Tree could not be loaded:' + request.statusText));
            }
        };
        request.onerror = function () {
            // Also deal with the case when the entire request fails to begin with
            // This is probably a network error, so reject the promise with an appropriate message
            reject(Error('There was a network error.'));
        };
        // Send the request
        request.send();
    });
}

function handleTreeDataError(err) {
    console.log(err);
    throw new Error('Tree data could not be loaded.');
}