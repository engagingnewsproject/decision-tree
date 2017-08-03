/**
* Must have one view to initialize
*/
(function () {

function Tree(data, observers) {
    var _data,
        _state;

    // keep an array of observers
    this.observers = []

    /**
    * Private functions
    */
    var _validateData = function(data) {
        // TODO: make sure the data is valid
        return true;
    }

    /*
    * Private function to set Data and State on Init
    */
    var _setData = function(data) {
        _data = data
        _state = {
            id: data.tree_id,
            type: 'tree'
        }
    }


    /**
    ** Public functinos
    **/

    // getters
    this.getData = function() { return _data }
    this.getState = function() { return _state }

    // setters
    this.setState = function(stateType, stateID) {
        let whitelist,
            validateState,
            oldState,
            newState;

        whitelist = ['tree', 'start','question','end']

        // TODO: Check that start can't go straight to end?
        // TODO: Check that the next state is valid from the question's options?

        // check allowed states
        if(!whitelist.includes(stateType)) {
            console.error(stateType + " is not an allowed state. Allowed states are "+whitelist.toString())
            this.emitError('invalidStateType', {
                stateType: stateType,
                stateID: stateID
            })
            return false
        }

        // check if the stateID is a valid ID for this state
        if(stateType === 'tree') {
            if(stateID === this.getTreeID()) {
                validateState = true
            } else {
                validateState = false
            }
        } else {
            validateState = this.getDataByType(stateType, stateID);
        }

        if(validateState === false || validateState === undefined) {
            console.error(stateID + " is invalid for the current state of '"+ stateType+"'")
            this.emitError('invalidState', {
                stateType: stateType,
                stateID: stateID
            })
            return false
        }

        // looks valid! Set the state
        // store the old state
        oldState = {
            type: _state.type,
            id: _state.id,
        }

        // set the state
        _state.type = stateType
        _state.id = stateID

        // build a new state
        newState = {
            type: _state.type,
            id: _state.id,
        }
        // emit that we've changed it
        this.emit('update', {newState, oldState})
    }

    /***********************
    ******** INIT  *********
    ***********************/
    // set the data
    if(_validateData(data)) {
        // start with one observer so we can
        // alert them on ready
        this.setObservers(observers)
        // set the data
        _setData(data)
        // emit that we're ready for other code to utilize this tree
        this.emit('ready', this);
    } else {
        console.error('Tree data is invalid.')
        return false;
    }

}

Tree.prototype = {
    constructor: Tree,

    /**
    * Let Observers know about different actions
    * 'ready', 'update', 'error'
    */
    emit: function(action, data) {
        console.log('emitting '+action)
        for(let i = 0; i < this.observers.length; i++) {
            this.observers[i].on(action, data)
        }
    },

    /**
    * Let our observers know about the error
    */
    emitError: function(action, data) {
        this.emit('error', {
            action: action,
            data: data,
        });
    },

    /**
    * Request to update the tree
    */
    update: function(action, data) {
        console.log('Request update with this data:');
        console.log(data);
        switch(action) {
            // data will be the element clicked
            case 'state':
                this.updateState(data);
                break
        }
    },

    /**
    * Attempt to update a sate
    * Validation and emitting happens with setState
    */
    updateState: function(data) {
        switch(data.type) {
            case 'start':
                // go to first question
                let question = this.getQuestions()[0];
                this.setState('question', question.question_id);
                break

            case 'option':
                // find the destination
                this.setState(data.destination_type, data.destination_id);
                break

            case 'end':
                // find the destination
                this.setState(data.destination_type, data.destination_id);
                break

            case 'restart':
                // find the destination
                this.setState('tree', this.getTreeID());
                break
        }
    },

    /**
    * Allowed types, 'question', 'group', 'end', 'start'
    */
    getDataByType: function(type, id) {
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
    },

    getTreeID: function() {
        return this.getData().tree_id;
    },

    getQuestions: function(id){
        let question;
        if(id !== undefined) {
            // get the individual item
            question = this.getDataByType('question', id)
        } else {
            question = this.getDataByType('question')
        }
        return question;
    },

    getStarts: function(id){
        let start;
        if(id !== undefined) {
            // get the individual item
            start = this.getDataByType('start', id)
        } else {
            start = this.getDataByType('start')
        }
        return start;
    },

    getEnds: function(id){
        let end;
        if(id !== undefined) {
            // get the individual item
            end = this.getDataByType('end', id)
        } else {
            end = this.getDataByType('end')
        }
        return end;
    },

    getGroups: function(id){
        let group;
        if(id !== undefined) {
            // get the individual item
            group = this.getDataByType('group', id)
        } else {
            group = this.getDataByType('group')
        }
        return group;
    },

    getOptions: function(question_id, option_id){
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
    },

    setObservers: function(observers) {
        for(let i = 0; i < observers.length; i++) {
            this.addObserver(observers[i])
        }
        return this.observers
    },

    addObserver: function(observer) {
        // no need to validate. anyone can listen
        // we do need to check to make sure the observer hasn't already
        // been added
        this.observers.push(observer)
    },

    getObservers: function() {
        return this.observers
    },

    /**
    * Powers most all of the retrieval of data from the tree
    * Searches an array for a key that equals a certain value
    *
    * @param objArray (ARRAY of OBJECTS)
    * @param name (STRING) of the key you're wanting to find the matching value of
    * @param value (MIXED) the value you want to find a match for
    * @return INT of the index that matches or UNDEFINED if not found
    */
    getIndexBy: function(objArray, name, value){
        for (let i = 0; i < objArray.length; i++) {
            if (objArray[i][name] == value) {
                return i;
            }
        }
        return undefined;
    }
}







function createTree(options) {
    // required options
    if(typeof options.slug !== 'string') {
        console.error('Tree slug must be a string.')
        return false
    }
    // INIT
    // Request our Tree Data
    // create the tree
    getTreeData(options.slug)
        .then(buildTree.bind(options))
        .catch(handleTreeDataError);
}

function getTreeData(slug) {

    return new Promise(function(resolve, reject) {

      var request = new XMLHttpRequest();
      request.overrideMimeType("application/json");
      request.open('GET', 'http://dev/decision-tree/api/v1/trees/'+slug+'/compiled?minfied=true', true);
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

function buildTree(request) {

    // check our response URL to make sure it's from a trusted source
    if(!/https?:\/\/(?:dev\/decision-tree|tree\.engagingnewsproject\.org|enptree\.staging\.wpengine\.com)\/api\//.test(request.responseURL)) {
        console.error('responseURL from an invalidated source.')
        return false;
    }

    let data = JSON.parse(request.response);
    let treeView = new TreeView({
        container: this.container,
    });
    let observers = [treeView]

    let tree = new Tree(data, observers);

    trees.push(tree);

}

function handleTreeDataError(err) {
    console.error(err)
}



    var trees = [];
    window.Tree = Tree;
    window.createTree = createTree;
    window.trees = trees;

}(window));
