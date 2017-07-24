'use strict';

Handlebars.registerHelper('upper', function (str) {
    return str.toUpperCase();
});

Handlebars.registerHelper('starts_group', function (question_id, group_id, groups, options) {
    // find the group
    for (var i = 0; i < groups.length; i++) {
        if (groups[i].group_id === group_id) {
            // check if it's the first in the question order
            if (groups[i].questions[0] === question_id) {
                return options.fn(this);
            } else {
                return '';
            }
        }
    }
    /*if(list.indexOf(elem) > -1) {
      return options.fn(this);
    }
    return options.inverse(this);*/
});

Handlebars.registerHelper('ends_group', function (question_id, group_id, groups, options) {
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
    /*if(list.indexOf(elem) > -1) {
      return options.fn(this);
    }
    return options.inverse(this);*/
});
'use strict';

function Tree(data) {
    this.data = data;
    this.tree_id = data.tree_id;
    this.title = data.title;
    this.startButton = data.startButton;
    this.questions = data.questions;
    this.template = TreeTemplates.tree;
    this.html = this.template(this.data);
}

var Trees = [];

// create the tree
function getTreeData(slug) {
    var DecisionTree = void 0;

    return new Promise(function (resolve, reject) {

        var request = new XMLHttpRequest();
        request.overrideMimeType("application/json");
        request.open('GET', 'http://dev/decision-tree/api/v1/trees/' + slug + '/compiled', true);
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

function createTree(slug) {
    getTreeData(slug).then(buildTree).catch(handleTreeDataError);
}

function buildTree(response) {
    // The first runs when the promise resolves, with the request.reponse
    // specified within the resolve() method.
    var treeData = JSON.parse(response);
    var newTree = new Tree(treeData);
    // add it to our array of Tree objects
    Trees.push(newTree);
    // Render it
    renderTree(newTree);
}

function handleTreeDataError(err) {
    console.log(err);
}

function renderTree(Tree) {
    var treeBlock = document.getElementById('enp-tree__' + Tree.tree_id);
    treeBlock.innerHTML = Tree.html;
}

createTree('citizen');