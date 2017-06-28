'use strict';

function Tree(data) {
    this.data = data;
    this.id = data.id;
    this.title = data.title;
    this.startButton = data.startButton;
    this.questions = data.questions;
    this.template = TreeTemplates.tree;
    this.html = this.template(this.data);
}

var treeJSON = {
    id: '1',
    title: 'Are You Eligible to be a US Citizen',
    startButton: 'Start',
    questions: [{
        id: 2,
        content: 'Are you at least 18 years old?',
        options: [{
            id: 3,
            content: 'Yes',
            destinationID: 2
        }, {
            id: 3,
            content: 'No',
            destinationID: 4
        }]
    }]
};

// create the tree
function getTreeData(name) {
    var DecisionTree = void 0;

    return new Promise(function (resolve, reject) {

        var request = new XMLHttpRequest();
        request.overrideMimeType("application/json");
        request.open('GET', 'http://dev/decision-tree/api/v1/tree/' + name, true);
        //request.responseType = 'json';
        // When the request loads, check whether it was successful
        request.onload = function () {
            if (request.status === 200) {
                // If successful, resolve the promise by passing back the request response
                resolve(request.response);
            } else {
                // If it fails, reject the promise with a error message
                reject(Error('Image didn\'t load successfully; error code:' + request.statusText));
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

var Trees = [];

getTreeData('citizen').then(function (response) {
    // The first runs when the promise resolves, with the request.reponse
    // specified within the resolve() method.
    var treeData = JSON.parse(response);
    var newTree = new Tree(treeData);
    // add it to our array of Tree objects
    Trees.push(newTree);
    // Render it
    var treeBlock = document.getElementById('enp-tree__' + newTree.id);
    treeBlock.innerHTML = newTree.html;
    // The second runs when the promise
    // is rejected, and logs the Error specified with the reject() method.
}, function (Error) {
    console.log(Error);
});