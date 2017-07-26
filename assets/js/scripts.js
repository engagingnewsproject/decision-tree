function Tree(options) {
    var _data,
        _state,
        _stateID;

    // required options
    if(typeof options.slug !== 'string') {
        throw new Error('Tree slug is required must be a string.')
    }

    if(typeof options.container !== 'object') {
        throw new Error('Tree container must be an object. Try `container: document.getElementById(your-id)`.')
    }


    // constructor
    function createTree(response) {
        let data = JSON.parse(response);

        _data = data
        _state = 'start'
        _stateID = data.starts[0].start_id

        // render the tree
        var template = window.TreeTemplates.tree;
        var treeHTML = template(data)

        // set the HTML into the passed container
        options.container.innerHTML = treeHTML
    }

    // getters
    this.getData = function() { return _data }
    this.getState = function() { return _state }
    this.getStateID = function() { return _stateID }

    // setters
    this.setState = function(state) {
        // protect this function!
        _state = state;
    }
    this.setStateID = function(stateID) {
        // protect this function!
        _stateID = stateID;
    }

    // INIT
    // Request our Tree Data
    // create the tree
    getTreeData(options.slug, 'http://dev/decision-tree/api/v1/trees/'+options.slug+'/compiled?minfied=true')
        .then(createTree)
        .catch(handleTreeDataError);

}


Tree.prototype.getQuestion = function(id){
    // get the individual item
    questionIndex = this.getIndexBy(this.getData(), 'question_id', id)
    question = this.data.questions[questionIndex]

    return question;
};

/**
* Allowed types, 'question', 'group', 'end', 'start'
*/
Tree.prototype.getDataByType = function(type, id) {
    let typeIndex,
        whitelist,
        data;
    // check allowed types
    whitelist = ['question','group','end','start']

    if(!whitelist.includes(type)) {
        throw new Error("Allowed getDataByType types are "+whitelist.toString());
    }
    // get the data of this type
    data = this.getData();
    // append 's' to get the right array
    // 'question' becomes 'questions'
    data = data[type+'s'];

    // if there's an ID, let's get the specific one they're after
    if(id !== undefined) {
        // get the individual item
        typeIndex = this.getIndexBy(data, type+'_id', id)
        data = data[typeIndex]
    }

    return data;
}

Tree.prototype.getQuestions = function(id){
    let question;
    if(id !== undefined) {
        // get the individual item
        question = this.getDataByType('question', id)
    } else {
        question = this.getDataByType('question')
    }
    return question;
};

Tree.prototype.getStarts = function(id){
    let start;
    if(id !== undefined) {
        // get the individual item
        start = this.getDataByType('start', id)
    } else {
        start = this.getDataByType('start')
    }
    return start;
};

Tree.prototype.getEnds = function(id){
    let end;
    if(id !== undefined) {
        // get the individual item
        end = this.getDataByType('end', id)
    } else {
        end = this.getDataByType('end')
    }
    return end;
};

Tree.prototype.getGroups = function(id){
    let group;
    if(id !== undefined) {
        // get the individual item
        group = this.getDataByType('group', id)
    } else {
        group = this.getDataByType('group')
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


const Trees = []

function getTreeData(slug, url) {
    let DecisionTree;

    return new Promise(function(resolve, reject) {

      var request = new XMLHttpRequest();
      request.overrideMimeType("application/json");
      request.open('GET', url, true);
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

function handleTreeDataError(err) {
    console.log(err)
    throw new Error('Tree data could not be loaded.')
}
