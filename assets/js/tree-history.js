/**
* Manages localStorage of current question state
* and previous states of the current decision tree path
* (so people can go back to previous questions)
*/
function TreeHistory(options) {
    var _Tree,
        _storageString,
        _history; // where in the history we're at (current state)

    // getters
    this.getTree = function() { return _Tree}
    this.getHistory = function() { return _history}

    // setters

    this.clearHistory = function() {
        // create as an empty array

        let history = {
                    states: [{}],
                    currentIndex: null
                };
        saveHistory(history)
    }

    this.setTree = function(Tree) {
        // only let it be set once
        if(_Tree === undefined) {
            _Tree = Tree
        }
        return _Tree
    }

    this.setHistory = function() {
        let history,
            treeID;

        // get the tree id
        treeID = this.getTree().getTreeID()

        // set global storage string
        _storageString = 'treeHistory__'+treeID

        // if localStorage is empty, create it
        if(localStorage.getItem(_storageString) === null) {
            // sets a blank history
            this.clearHistory();
        }

        // set localStorage
        _history = JSON.parse(localStorage.getItem(_storageString))
        return _history
    }

    this.addHistory = function(state) {
        console.log('add history')
        console.log(state)
        // TODO: Validate state. Should be a function on the Tree
        // check whitelist for state?
        let history = this.getHistory();
        // check tree data for appropriate id?
        let length = history.state.push(state)
        // set the new current index
        this.setCurrentIndex(length-1)

        // save it
        saveHistory(history)
    }

    this.deleteHistoryAfter = function(index) {
        // Don't let them delete the current state
        if(index === this.getCurrentIndex()) {
            console.error('Cannot delete current state.');
            return false;
        }

        // don't allow them to delete history before the current index
        if(index < this.getCurrentIndex) {
            console.error('Cannot delete states before the current state.');
            return false;
        }

        // ok, delete away!
        // delete all history after the passed index
        _history = _history.splice(index)

        saveHistory(_history)
    }

    // save the passed history to localStorage and set the global _history to make sure everything is in sync
    var saveHistory = function(history) {
        _history = history;
        localStorage.setItem(_storageString, JSON.stringify(_history));
        console.log(_history)
    }


    this.setCurrentIndex = function(index) {
        // Check that the index exists
        if(_history.state[index] === undefined) {
            console.error('Index not found in _history.')
            return false;
        }

        // don't worry about matching that the state exists. Maybe someone wants to set the current index to the last one in the series. Who knows?
        _history.currentIndex = index

        this.saveHistory(_history)
    }

    // if a Tree was passed, build the History now
    if(options.Tree) {
        this.build(options.Tree)
    }
}


TreeHistory.prototype = {
    constructor: TreeHistory,

    build: function(Tree) {
        this.setTree(Tree)
        this.setHistory()
        // TODO: update the Tree state to match the History
    },

    getCurrentIndex: function() {
        let history = this.getHistory()
        return history.currentIndex
    },

    getHistoryStates: function() {
        let history = this.getHistory()
        return history.states
    },

    getCurrentState: function() {
        let stateHistory,
            currentIndex;

        stateHistory = this.getHistoryStates()
        currentIndex = this.getCurrentIndex()

        return stateHistory[currentIndex]
    },

    /**
    * Let our Tree know about the state we want to change to.
    */
    emit: function(action, item, data) {
        console.log('Tree History Emit: '+action);
        console.log(data)
        let Tree = this.getTree()
        switch(action) {
            case 'resume':
                // this is usually Tree.update('state', dataAboutNewState)
                Tree.update(item, data);
                break
        }
    },

    /**
    * Listen to parent Tree's emitted actions and handle accordingly
    */
    on: function(action, data) {
        console.log('TreeHistory "on" '+action);
        switch(action) {
            case 'ready':
                // data will be the tree itself
                this.build(data)
                break
            case 'update':
                this.update(data)
                break
        }
    },

    // if in overview state, brings back to their current state in the history
    resume: function() {
        // tell the main tree to set the state back to this question
        this.emit('resume', 'state', this.getCurrentState())
    },

    // sets the localStorage
    save: function() {

    },

    // updates the history state
    update: function(states) {
        // TODO: refactor out all the "addHistory(newState); return;"
        let newState,
            oldState,
            history,
            questions,
            findIndex,
            Tree;

        // data contains old state and new state
        newState = states.newState
        oldState = states.oldState
        history = this.getHistory()
        console.log('new state');

        // check if we're resuming where we left off. ie, the updated state will match where we're at in the state history
        if(newState === this.getCurrentState()) {
            // do nothing! we're good
            return;
        }

        // see if we need to add our resume button in
        if(newState.type === 'tree' && history.currentIndex !== null) {
            // TODO: add resume button next to Start button

            return;
        }

        // OK, we'll probably have to do something now
        if(newState.type === 'question') {
            Tree = this.getTree()
            questions = Tree.getQuestions()

            // if the old state is Tree and the current question is the first question, then they're just starting, so let's clear the history (if any) and set the first question
            if(oldState.type === 'tree' && newState.id === questions[0].question_id) {
                // clear the history
                this.clearHistory()
                // add it to our tree (also calls setCurrentIndex)
                this.addHistory(newState);
                return;
            }

            // try to find this state in our history
            findIndex = getIndexBy(history.states, 'id', newState.id)
            if(findIndex !== undefined) {
                // set the currentIndex accordingly
                this.setCurrentIndex(findIndex);
                return;
            }

            // try to find the previous state. is it the last one in the
            // current state tree?
            // if not, delete any history after the previous state.
            // They've gone rogue by going back in history and
            // chosing a new path
            findIndex = getIndexBy(history.states, 'id', oldState.id)
            if(findIndex !== undefined && findIndex !== history.states.length - 1) {
                // delete anything after this point, because they've changed their state history
                // we don't want to delete one by one because:
                // 1. we won't allow them to do that
                // 2. it'll be a lot slower to delete one by one
                this.deleteHistoryAfter(findIndex + 1)

                // add our new history
                this.addHistory(newState)
                return;
            }

            // nothing else to do but add some history
            this.addHistory(newState)
        }

        else if(newState.type === 'end') {
            this.addHistory(newState)
        }

        return;
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
