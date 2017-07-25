function Tree(data) {
    this.data = data
    this.tree_id = data.tree_id
    this.title = data.title
    this.startButton = data.startButton
    this.questions = data.questions
    this.template = TreeTemplates.tree
    this.html = this.template(this.data)
}

const Trees = []


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
    let treeBlock = document.getElementById('enp-tree__'+Tree.tree_id);
    treeBlock.innerHTML = Tree.html
}

createTree('citizen');
