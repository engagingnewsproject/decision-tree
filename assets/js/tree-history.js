/**
* Manages localStorage of current question state
* and previous states of the current decision tree path
* (so people can go back to previous questions)
*/
function TreeHistory(options) {
    var _Tree,
        _history,
        _historyStorageName,
        _currentIndex, // where in the history we're at (current state)
        _currentIndexStorageName;

        // keep an array of observers
        this.observers = []

    /**
    * Private functions
    */
    // save the passed history to localStorage and set the global _history to make sure everything is in sync
    var _saveHistory = function(history) {
        _history = history;
        localStorage.setItem(_historyStorageName, JSON.stringify(_history));
        console.log(_history)
    }

    var _saveCurrentIndex = function(currentIndex) {
        _currentIndex = currentIndex
        localStorage.setItem(_currentIndexStorageName, JSON.stringify(_currentIndex))
        console.log(_currentIndex)
    }

    // getters
    this.getTree = function() { return _Tree}
    this.getHistory = function() { return _history}
    this.getCurrentIndex = function() { return _currentIndex}

    // setters
    /**
    * Clears the history and currentIndex to an empty state
    */
    this.clearHistory = function() {
        // create as an empty array
        let history = [];
        let currentIndex = null;

        _saveHistory(history)
        _saveCurrentIndex(currentIndex)
    }

    /**
    * Sets the parent Tree
    */
    this.setTree = function(Tree) {
        // only let it be set once
        if(_Tree === undefined) {
            _Tree = Tree
        }
        return _Tree
    }

    /**
    * Sets variables and decides what state we'll init to
    */
    this.init = function() {
        let treeID;

        // get the tree id
        treeID = this.getTree().getTreeID()

        // set global storage string
        _historyStorageName = 'treeHistory__'+treeID
        _currentIndexStorageName = 'treeHistoryIndex__'+treeID

        // if localStorage is empty, create it
        if(localStorage.getItem(_historyStorageName) === null) {
            // sets a blank history and index
            this.clearHistory();
        }

        // set from localStorage
        this.setHistory(JSON.parse(localStorage.getItem(_historyStorageName)))
        // set currentIndex from localStorage
        this.setCurrentIndex(JSON.parse(localStorage.getItem(_currentIndexStorageName)))
    }

    this.setHistory = function(history) {
        // TODO: different checks to make sure it's legit, like
        // don't add the same state twice.
        _saveHistory(history)
        // notify observers
        this.notifyObservers('historyUpdate', history)
        return
    }

    this.setCurrentIndex = function(index) {
        let history = this.getHistory()
        // Check that the index exists
        if(index !== null && history[index] === undefined) {
            console.error('Index not found in History.')
            // Should we set the current index to null here?
            return false
        }

        // don't worry about matching that the state exists. Maybe someone wants to set the current index to the last one in the series. Who knows?
        _saveCurrentIndex(index)
        this.notifyObservers('historyIndexUpdate', index)
        return
    }

    this.setView = function(container) {

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
        this.init()
        this.forceCurrentState()
    },

    addHistory: function(state) {
        // TODO: Validate state. Should be a function on the Tree
        // check whitelist for state?

        let history = this.getHistory();
        // add the state to the history
        history.push(state)
        // save it
        this.setHistory(history)
    },

    deleteHistoryAfter: function(index) {
        let history;
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
        history = this.getHistory().splice(index)

        setHistory(history)
    },

    getCurrentState: function() {
        let history,
            currentIndex;

        history = this.getHistory()
        currentIndex = this.getCurrentIndex()

        return history[currentIndex]
    },

    /**
    * Let our Tree know about the state we want to change to.
    */
    emit: function(action, item, data) {
        let state;
        console.log('Tree History Emit: '+action);
        console.log(data)
        let Tree = this.getTree()
        switch(action) {
            case 'update':
                // this is usually Tree.update('state', dataAboutNewState)
                //  our format is data {type: 'question', id: #}, but the
                // tree needs it in format {type: 'question', question_id: id}
                state = {type: data.type}
                state[data.type+'_id'] = data.id

                Tree.update(item, state);
                break
        }
    },

    // tell the parent tree to update to our current state
    forceCurrentState: function() {
        let currentIndex,
            history;

        // TODO: update the Tree state to match the History
        // if we have a currentIndex and state, then pass it to the main tree to set the state to reflect our view
        currentIndex = this.getCurrentIndex();
        history = this.getHistory()

        if(this.currentIndex !== null && history[currentIndex] !== undefined) {
            this.emit('update', 'state', history[currentIndex])
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
            case 'viewReady':
                // build the view
                // this.setView(data)
                // get the container
                let treeView = data
                let container = treeView.getContentWindow()
                let historyView = new TreeHistoryView({TreeHistory: this, container: container})
                // add this to the observers
                this.addObserver(historyView)
        }

        // notify observers of these changes
        this.notifyObservers(action, data)
    },

    // updates the history state
    update: function(states) {
        let newState,
            oldState,
            history,
            questions,
            findNewStateIndex,
            findOldStateIndex,
            stateToAdd,
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
            // try to find the new state in our history
            findNewStateIndex = this.getIndexBy(history, 'id', newState.id)
            // try to find the old state in our history
            findOldStateIndex = this.getIndexBy(history, 'id', oldState.id)

            // if the old state is Tree or End and the current question is the first question, then they're just starting over, so let's clear the history (if any) and set the first question
            if((oldState.type === 'tree' || oldState.type === 'end') && newState.id === questions[0].question_id) {
                // clear the history
                this.clearHistory()
                // set it as our var to add
                stateToAdd = newState;
            }

            // If we can find the new state index in our history,
            // then we don't want to ADD it to the history, we just want to
            // change our currentIndex to match where they are.
            // EX. Someone clicked the "back" or "forward" buttons.
            // They're not adding history, they're just changing where they are
            else if(findNewStateIndex !== undefined) {
                // set the currentIndex accordingly
                this.setCurrentIndex(findNewStateIndex);
            }

            // try to find the previous state. is it the last one in the
            // current state tree?
            // if not, delete any history after the previous state.
            // They've gone rogue by going back in history and
            // then chose a new path
            else if(findOldStateIndex !== undefined && findOldStateIndex !== history.length - 1) {
                // delete anything after this point, because they've changed their state history
                // we don't want to delete one by one because:
                // 1. we won't allow them to do that
                // 2. it'll be a lot slower to delete one by one
                this.deleteHistoryAfter(findOldStateIndex + 1)

                // add our new history
                // set it as our var to add
                stateToAdd = newState;
            } else {
                // welp, they're just going forwards.
                // Nothing to do but add the state!
                stateToAdd = newState;
            }
        }

        else if(newState.type === 'end') {
            stateToAdd = newState
        }

        // see if there's anything to add
        if(typeof stateToAdd === 'object' && stateToAdd !== undefined) {
            this.addHistory(stateToAdd)
            // set the new current index
            this.setCurrentIndex(this.getHistory().length-1)
        }
    },

    /**
    * A little module pattern to manage the view. This way people
    * can overwrite it if they want, and it's all isolated here
    */
    view: function() {
        this.view = undefined
        this.viewHistory = undefined
        this.viewPane = undefined
        return {
            render: function() {
                let view,
                    cPane;

                this.view = this.getTreeView()

                if(this.view === undefined) {
                    console.error('Could not find a view. Trying again in 700ms')
                }
                this.viewPane = this.view.getContentPane();
                console.log(this.viewPane)
            },

            getTreeView: function() {
                let Tree,
                    observers;

                Tree = this.getTree();
                observers = Tree.getObservers()
                // find the view
                for(let i = 0; i < observers.length; i++) {
                    if(observers[i].constructor.name === 'TreeView') {
                        return observers[i]
                    }
                }
                return undefined
            }
        }
    },

    /**
    * A little module pattern to manage the view. This way people
    * can overwrite it if they want, and it's all isolated here
    */
    /*viewRender: function() {
        let view,
            cPane;

        view = this.viewGetTreeView()

        if(cPane === undefined) {
            console.error('Could not find a view. Trying again in 700ms')
        }
        this.viewParent = view.getContentPane();

    },

    // Find the tree view so we can get the pane to attach it to.
    viewGetTreeView() {
        let Tree,
            observers;

        Tree = this.getTree();
        observers = Tree.getObservers()
        // find the view
        for(let i = 0; i < observers.length; i++) {
            if(observers[i].constructor.name === 'TreeView') {
                return observers[i]
            }
        }
        return undefined
    },*/

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

    notifyObservers: function(action, data) {
        console.log('Tree History notifying observers '+action)
        for(let i = 0; i < this.observers.length; i++) {
            this.observers[i].on(action, data)
        }
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
