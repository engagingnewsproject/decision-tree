function Tree(data) {
    this.data = data
    this.id = data.id
    this.title = data.title
    this.startButton = data.startButton
    this.questions = data.questions
    this.template = TreeTemplates.tree
    this.html = this.template(this.data)
}

var treeJSON = {
    id: '1',
    title: 'Are You Eligible to be a US Citizen',
    startButton: 'Start',
    questions: [
            {
                id: 2,
                content: 'Are you at least 18 years old?',
                options: [
                    {
                        id: 3,
                        content: 'Yes',
                        destinationID: 2,
                    },
                    {
                        id: 3,
                        content: 'No',
                        destinationID: 4,
                    }
                ],
            },
    ]
};

const Trees = []

// create the tree
function getTreeData(slug) {
    let DecisionTree;

    return new Promise(function(resolve, reject) {

      var request = new XMLHttpRequest();
      request.overrideMimeType("application/json");
      request.open('GET', 'http://dev/decision-tree/api/v1/trees/'+slug+'/compiled', true);
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
    let treeBlock = document.getElementById('enp-tree__'+Tree.id);
    treeBlock.innerHTML = Tree.html
}

createTree('citizen');
