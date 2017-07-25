'use strict';

Handlebars.registerHelper('environment', function (options) {
    return 'js';
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

function Tree(slug) {
    var _treeID, _starts, _questions, _ends, _state, _stateID, _template;

    // Request our Tree Data

    this.getTreeData = function (slug) {
        console.log(slug);
        var DecisionTree = void 0;

        return new Promise(function (resolve, reject) {

            var request = new XMLHttpRequest();
            request.overrideMimeType("application/json");
            request.open('GET', 'http://dev/decision-tree/api/v1/trees/' + slug + '/compiled?minfied=true', true);
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
    };

    this.handleTreeDataError = function (err) {
        console.log(err);
    };

    this.createTree = function (response) {
        var data = JSON.parse(response);

        _treeID = data.tree_id;
        _starts = data.starts;
        _questions = data.questions;
        _ends = data.ends;
        _state = 'start';
        _stateID = data.starts[0].start_id;

        // render the tree
        var template = window.TreeTemplates.tree;
        var treeHTML = template(data);

        var treeBlock = document.getElementById('enp-tree__' + _treeID);
        treeBlock.innerHTML = treeHTML;
        var treeRendered = document.getElementById('enp-tree--' + _treeID);
        // remove the no-js class
        treeRendered.classList.remove('enp-tree--no-js');
        treeRendered.classList.add('enp-tree--has-js');
    };

    var renderTree = function renderTree(data) {
        console.log('render');
    };

    // getters
    this.getTreeID = function () {
        return _treeID;
    };
    this.getStarts = function () {
        return _starts;
    };
    this.getQuestions = function () {
        return _questions;
    };
    this.getEnds = function () {
        return _ends;
    };
    this.getState = function () {
        return _ends;
    };
    this.getTemplate = function () {
        return _template;
    };
    this.getHTML = function () {
        return _html;
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

    // create the tree
    this.getTreeData(slug).then(this.createTree).catch(this.handleTreeDataError);
}

Tree.prototype.getOtherTreeID = function () {
    return this._treeID;
};

// getters and setters
/*Tree.prototype.getState = function(){
    return this.state
};



Tree.prototype.getQuestions = function(id){
    let question,
        questionIndex;
    if(id !== undefined) {
        // get the individual item
        questionIndex = this.getIndexBy(this.data.questions, 'question_id', id)
        question = this.data.questions[questionIndex]
    } else {
        question = this.data.questions
    }
    return question;
};

Tree.prototype.getStarts = function(id){
    let start,
        startIndex;
    if(id !== undefined) {
        // get the individual item
        startIndex = this.getIndexBy(this.data.starts, 'start_id', id)
        start = this.data.starts[startIndex]
    } else {
        start = this.data.starts
    }
    return start;
};

Tree.prototype.getEnds = function(id){
    let end,
        endIndex;
    if(id !== undefined) {
        // get the individual item
        endIndex = this.getIndexBy(this.data.ends, 'end_id', id)
        end = this.data.ends[endIndex]
    } else {
        end = this.data.ends
    }
    return end;
};

Tree.prototype.getGroups = function(id){
    let group,
        groupIndex;
    if(id !== undefined) {
        // get the individual item
        groupIndex = this.getIndexBy(this.data.groups, 'group_id', id)
        group = this.data.groups[groupIndex]
    } else {
        group = this.data.groups
    }
    return group;
};

Tree.prototype.getOptions = function(question_id, option_id){
    let option,
        optionIndex,
        question;

    // get the individual item
    question = this.getQuestions(question_id);

    if(option_id !== undefined) {
        optionIndex = this.getIndexBy(question.options, 'option_id', option_id)
        option = question.options[optionIndex]
    } else {
        option = question.options;
    }

    return option;
};

Tree.prototype.getIndexBy = function(objArray, name, value){
    for (let i = 0; i < objArray.length; i++) {
        if (objArray[i][name] == value) {
            return i;
        }
    }
    return -1;
};

Tree.prototype.setState(id) {
    if(id === undefined) {
        this.state = 0;
        this.state = 'start';
    } else if (){

    }
}
*/

var Trees = [];

/*
// create the tree
function getTreeData(slug) {
    let DecisionTree;

    return new Promise(function(resolve, reject) {

      var request = new XMLHttpRequest();
      request.overrideMimeType("application/json");
      request.open('GET', 'http://dev/decision-tree/api/v1/trees/'+slug+'/compiled?minfied=true', true);
      //request.responseType = 'json';
      // When the request loads, check whether it was successful
      request.onload = function() {
        if (request.status === 200) {
        // If successful, resolve the promise by passing back the request response
          resolve(request.response);
        } else {
        // If it fails, reject the promise with a error message
          reject(Error('Tree could not be loaded:' + request.statusText));
        }
      };
      request.onerror = function() {
      // Also deal with the case when the entire request fails to begin with
      // This is probably a network error, so reject the promise with an appropriate message
          reject(Error('There was a network error.'));
      };
      // Send the request
      request.send();
    });
}

function createTree(slug) {
    getTreeData(slug).then(buildTree).catch(handleTreeDataError);
}

function buildTree(response) {
    // The first runs when the promise resolves, with the request.reponse
    // specified within the resolve() method.
    let treeData = JSON.parse(response);
    let newTree = new Tree(treeData)
    // add it to our array of Tree objects
    Trees.push(newTree)
    // Render it
    renderTree(newTree)
}

function handleTreeDataError(err) {
    console.log(err)
}

function renderTree(Tree) {
    let treeBlock = document.getElementById('enp-tree__'+Tree.data.tree_id);
    treeBlock.innerHTML = Tree.html
    let treeRendered = document.getElementById('enp-tree--'+Tree.data.tree_id);
    // remove the no-js class
    treeRendered.classList.remove('enp-tree--no-js');
    treeRendered.classList.add('enp-tree--has-js');

    // hide
}

createTree('citizen');
*/

var tree = new Tree('citizen');