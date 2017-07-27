function Tree(options) {
    var _data,
        _state,
        _stateID;

    // required options
    if(typeof options.slug !== 'string') {
        console.error('Tree slug is must be a string.')
        return false
    }

    if(typeof options.container !== 'object') {
        console.error('Tree container must be a valid object. Try `container: document.getElementById(your-id)`.')
        return false
    }

    // constructor
    function createTree(request) {

        // check our response URL to make sure it's from a trusted source
        if(!/https?:\/\/(?:dev\/decision-tree|tree\.engagingnewsproject\.org|enptree\.staging\.wpengine\.com)\/api\//.test(request.responseURL)) {
            console.error('responseURL from an invalidated source.')
            return false;
        }

        let data = JSON.parse(request.response);

        _data = data
        _state = 'start'
        _stateID = data.starts[0].start_id

        // render the tree
        var template = window.TreeTemplates.tree;
        var treeHTML = template(data)

        // set the HTML into the passed container
        options.container.innerHTML = treeHTML
        let treeEl = options.container.firstElementChild
        // assign the value to our inserted element
        treeEl.value = data
        // assign the element to the data
        _data.el = treeEl

        // bind question data
        bindAllData(this)
        // attach event listeners to all <a> elements
        options.container.addEventListener("click", this.handleClick)


    }

    // getters
    this.getData = function() { return _data }
    this.getState = function() { return _state }
    this.getStateID = function() { return _stateID }

    // setters
    function bindAllData(context) {
        console.time("bind");
        let elTypes = ['question', 'start', 'end', 'group']
        // loop through the data and find the corresponding elements
        for(let i = 0; i < elTypes.length; i++) {
            // get the data: ex {question_id: 2, order: 2, etc}
            let elData = context.getDataByType(elTypes[i])
            for(let j = 0; j < elData.length; j++) {
                // get the id, ex. the id value '2'
                // this is like saying: getDataByType('question').question_id
                let id = elData[j][elTypes[i]+'_id']
                // find the element in the DOM
                let el = document.getElementById('enp-tree__el--'+id)
                // find the spot in the data tree to assign the el to
                // this is like saying: _data[questions]
                let dataEl = _data[elTypes[i]+'s'][j]
                // bind the data
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])
                bindDOMData(dataEl, el, elTypes[i])

                // see if we're working with a question
                if(elTypes[i] === 'question') {
                    let options = dataEl.options
                    // loop through the options
                    for(let k = 0; k < options.length; k++) {
                        // get the spot in the data tree to bind the data to
                        let optionDataEl = options[k]
                        // get option el
                        let optionEl =  document.getElementById('enp-tree__el--'+optionDataEl.option_id)
                        // bind the data
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                        bindDOMData(optionDataEl, optionEl, 'option')
                    }
                }
            }
        }
        console.timeEnd("bind");

    }

    /**
    * Bind data to an element and bind that element to the _data
    * ex. bindDOMData(_data.questions[0], document.getElementById('enp-tree__el--2'))
    * would bind the data from questions[0] to the el--2 (DOM element), and set
    * _data.questions[0].el = el--2 (DOM el)
    */
    function bindDOMData(_dataObj, element, type) {
        // we can only add this once, not overwrite existing ones
        if(_dataObj.el === undefined) {
            // clone the data so we're not giving direct access to the _data attribute
            let clonedObj;
            // building the cloned data manually so:
            // 1. it's soooo much faster. Like, exponentionally as the tree grows
            // 2. we're not recording a bunch of data we don't need
            //    (like "content", "title", etc)
            // 3. We can add data that we do need (like "type")
            switch(type) {
                case 'start':
                    clonedObj = {
                        start_id: _dataObj.start_id,
                        type: 'start',
                    }
                    break

                case 'group':
                    clonedObj = {
                        group_id: _dataObj.group_id,
                        type: 'group',
                    }
                    break

                case 'question':
                    clonedObj = {
                        question_id: _dataObj.question_id,
                        type: 'question',
                        destination_id: _dataObj.destination_id,
                    }
                    clonedObj.options = []
                    // add options
                    for(let i = 0; i < _dataObj.options.length; i++) {
                        clonedObj.options.push(_dataObj.options[i].option_id)
                    }
                    break

                case 'option':
                    clonedObj = {
                        option_id: _dataObj.option_id,
                        type: 'option',
                        question_id: _dataObj.question_id,
                        destination_id: _dataObj.destination_id,
                    }
                    break

                case 'end':
                    clonedObj = {
                        end_id: _dataObj.end_id,
                        type: 'end',
                    }
                    break
            }
            // dynamically building the structure was quite slow, so we're manually doing it for speed on this kinda expensive operation
            // bind the data to the DOM
            element.data = clonedObj
            // bind the element to the _data
            _dataObj.el = element

            return _dataObj.el
        } else {
            // can't overwrite data, so return false
            return false
        }
    }

    this.setState = function(state, stateID) {
        let whitelist = ['start','question','end']

        // TODO: Check that start can't go straight to end?
        // TODO: Check that the next state is valid from the question's options?

        // check allowed states
        if(!whitelist.includes(state)) {
            console.error(state + " is not an allowed state. Allowed states are "+whitelist.toString());
            return false;
        }

        // check if the stateID is a valid ID for this state
        let validateState = this.getDataByType(state, stateID);
        if(validateState === false || validateState === undefined || typeof validateState !== 'object') {
            console.error(stateID + " is invalid for the current state of '"+ state+"'");
            return false;
        }

        // looks valid! Set the states
        _state = state;
        _stateID = stateID;
    }

    // INIT
    // Request our Tree Data
    // create the tree
    getTreeData(options.slug, 'http://dev/decision-tree/api/v1/trees/'+options.slug+'/compiled?minfied=true')
        .then(createTree.bind(this))
        .catch(handleTreeDataError);

}

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
        console.error("Allowed getDataByType types are "+whitelist.toString());
        return false;
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
        if(typeIndex !== undefined) {
            // found one!
            data = data[typeIndex]
        } else {
            data = undefined
        }

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

Tree.prototype.toDestinationClick = function(el) {

};

Tree.prototype.setActive = function(el) {

};

Tree.prototype.handleClick = function(event) {
    let el = event.target;
    if(el.nodeName === 'A') {
        event.preventDefault();
        this.toDestinationClick(el);
    }

};
/**
* Powers most all of the retrieval of data from the tree
* Searches an array for a key that equals a certain value
*
* @param objArray (ARRAY of OBJECTS)
* @param name (STRING) of the key you're wanting to find the matching value of
* @param value (MIXED) the value you want to find a match for
* @return INT of the index that matches or UNDEFINED if not found
*/
Tree.prototype.getIndexBy = function(objArray, name, value){
    for (let i = 0; i < objArray.length; i++) {
        if (objArray[i][name] == value) {
            return i;
        }
    }
    return undefined;
};

function getTreeData(slug, url) {

    return new Promise(function(resolve, reject) {

      var request = new XMLHttpRequest();
      request.overrideMimeType("application/json");
      request.open('GET', url, true);
      //request.responseType = 'json';
      // When the request loads, check whether it was successful
      request.onload = function() {
        if (request.status === 200) {
        // If successful, resolve the promise by passing back the request response
          resolve(request);
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
    console.error(err)
}
