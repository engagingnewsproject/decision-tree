'use strict';

/**
* Must have one view to initialize
*/
(function () {

    function Tree(data, observers) {
        var _data, _state;

        // keep an array of observers
        this.observers = [];

        /**
        * Private functions
        */
        var _validateData = function _validateData(data) {
            // TODO: make sure the data is valid
            return true;
        };

        /*
        * Private function to set Data and State on Init
        */
        var _setData = function _setData(data) {
            _data = data;
            _state = {
                id: data.ID,
                type: 'intro'
            };
        };

        /**
        ** Public functinos
        **/

        // getters
        this.getData = function () {
            return _data;
        };
        this.getState = function () {
            return _state;
        };

        // Function to check if a state is valid or not
        this.validateState = function (stateType, stateID) {
            var whitelist = void 0,
                validState = void 0;

            whitelist = ['intro', 'overview', 'question', 'end'];

            // TODO: Check that start can't go straight to end?
            // TODO: Check that the next state is valid from the question's options?

            // check allowed states
            if (!whitelist.includes(stateType)) {
                console.error(stateType + " is not an allowed state. Allowed states are " + whitelist.toString());
                this.emitError('invalidStateType', {
                    stateType: stateType,
                    stateID: stateID
                });
                return false;
            }
            // check if stateID is valid
            if (stateID === null || stateID === '' || stateID === undefined) {
                console.error('StateID is empty: ' + stateID);
                return false;
            }

            // check if the stateID is a valid ID for this state
            if (stateType === 'overview') {
                if (stateID === this.getTreeID()) {
                    validState = true;
                } else {
                    validState = false;
                }
            } else if (stateType === 'intro') {
                // it's always fine
                validState = true;
            } else if (this.getDataByType(stateType, stateID) !== undefined) {
                validState = true;
            }

            if (validState === false || validState === undefined) {
                console.error(stateID + " is invalid for the current state of '" + stateType + "'");
                this.emitError('invalidState', {
                    stateType: stateType,
                    stateID: stateID
                });
                validState = false;
            }

            return validState;
        };

        // setters
        // @param data is simply the data that was originally passed to the function
        this.setState = function (stateType, stateID, data) {
            var whitelist = void 0,
                validState = void 0,
                oldState = void 0,
                newState = void 0;

            // check to make sure we're not trying to set the same state again
            if (_state.type === stateType && _state.id === stateID) {
                return false;
            }

            validState = this.validateState(stateType, stateID);

            if (validState !== true) {
                console.log(validState);
                return false;
            }

            // looks valid! Set the state
            // store the old state
            oldState = {
                type: _state.type,
                id: _state.id

                // set the state
            };_state.type = stateType;
            _state.id = stateID;

            // build a new state
            newState = {
                type: _state.type,
                id: _state.id
                // emit that we've changed it
            };this.emit('update', { newState: newState, oldState: oldState, data: data });
        };

        /***********************
        ******** INIT  *********
        ***********************/
        // set the data
        if (_validateData(data)) {
            // start with one observer so we can
            // alert them on ready
            this.setObservers(observers);
            // set the data
            _setData(data);
            // emit that we're ready for other code to utilize this tree
            this.emit('ready', this);
        } else {
            console.error('Tree data is invalid.');
            return false;
        }
    }

    Tree.prototype = {
        constructor: Tree,

        /**
        * Let Observers know about different actions
        * 'ready', 'update', 'error'
        */
        emit: function emit(action, data) {
            var _this = this;

            var _loop = function _loop(i) {
                // make the alert process async
                setTimeout(function () {
                    _this.observers[i].on(action, data);
                }, 0);
            };

            for (var i = 0; i < this.observers.length; i++) {
                _loop(i);
            }
        },

        /**
        * Let our observers know about the error
        */
        emitError: function emitError(action, data) {
            this.emit('error', {
                action: action,
                data: data
            });
        },

        /**
        * Request to update the tree
        */
        update: function update(action, data) {
            switch (action) {
                // data will be the element clicked
                case 'state':
                    this.updateState(data);
                    break;
            }
        },

        /**
        * How observers message the parent and each other
        */
        message: function message(action, data) {
            this.emit(action, data);
        },

        /**
        * Attempt to update a sate
        * Validation and emitting happens with setState
        */
        updateState: function updateState(data) {
            var id = void 0,
                type = void 0;
            switch (data.type) {
                case 'intro':
                    this.setState('intro', this.getTreeID(), data);
                    break;
                case 'start':
                    // emit a start
                    this.emit('start', this);

                    // go to first question
                    var question = this.getQuestions()[0];
                    this.setState('question', question.ID, data);
                    break;

                case 'question':
                    if (data.questionID === undefined) {
                        id = data.id;
                    } else {
                        id = data.questionID;
                    }
                    // find the destination
                    this.setState(data.type, id, data);
                    break;

                case 'option':
                    // find the destination
                    this.setState(data.destinationType, data.destinationID, data);
                    break;

                case 'end':
                    // find the destination
                    if (data.destinationType === undefined) {
                        type = data.type;
                    } else {
                        type = data.destinationType;
                    }
                    if (data.destinationID === undefined) {
                        id = data.id;
                    } else {
                        type = data.destinationID;
                    }
                    this.setState(type, id, data);
                    break;

                case 'overview':
                    // go to tree overview
                    this.setState('overview', this.getTreeID(), data);
                    break;
                case 'restart':
                    // emit a restart
                    this.emit('restart', this);
                    // go to first question
                    this.setState('question', this.getQuestions()[0].ID, data);
                    break;
            }
        },

        /**
        * Allowed types, 'question', 'group', 'end', 'start'
        */
        getDataByType: function getDataByType(type, id) {
            var typeIndex = void 0,
                whitelist = void 0,
                data = void 0;
            // check allowed types
            whitelist = ['question', 'group', 'end', 'start'];

            if (!whitelist.includes(type)) {
                console.error("Allowed getDataByType types are " + whitelist.toString());
                return false;
            }
            // get the data of this type
            data = this.getData();
            // append 's' to get the right array
            // 'question' becomes 'questions'
            data = data[type + 's'];

            // if there's an ID, let's get the specific one they're after
            if (id !== undefined) {
                // get the individual item
                typeIndex = this.getIndexBy(data, 'ID', id);
                if (typeIndex !== undefined) {
                    // found one!
                    data = data[typeIndex];
                } else {
                    data = undefined;
                }
            }

            return data;
        },

        getTreeID: function getTreeID() {
            return this.getData().ID;
        },

        getQuestions: function getQuestions(id) {
            var question = void 0;
            if (id !== undefined) {
                // get the individual item
                question = this.getDataByType('question', id);
            } else {
                question = this.getDataByType('question');
            }
            return question;
        },

        getStarts: function getStarts(id) {
            var start = void 0;
            if (id !== undefined) {
                // get the individual item
                start = this.getDataByType('start', id);
            } else {
                start = this.getDataByType('start');
            }
            return start;
        },

        getEnds: function getEnds(id) {
            var end = void 0;
            if (id !== undefined) {
                // get the individual item
                end = this.getDataByType('end', id);
            } else {
                end = this.getDataByType('end');
            }
            return end;
        },

        getGroups: function getGroups(id) {
            var group = void 0;
            if (id !== undefined) {
                // get the individual item
                group = this.getDataByType('group', id);
            } else {
                group = this.getDataByType('group');
            }
            return group;
        },

        getGroupIDByQuestion: function getGroupIDByQuestion(questionID) {
            var groups = void 0;

            groups = this.getGroups();
            for (var i = 0; i < groups.length; i++) {
                if (-1 < groups[i].questions.indexOf(questionID)) {
                    // found the group!
                    return groups[i].ID;
                }
            }
            // question isn't in a group
            return undefined;
        },

        getOptions: function getOptions(questionID, optionID) {
            var option = void 0,
                optionIndex = void 0,
                question = void 0;

            // get the individual item
            question = this.getQuestions(questionID);

            if (optionID !== undefined) {
                optionIndex = this.getIndexBy(question.options, 'ID', optionID);
                option = question.options[optionIndex];
            } else {
                option = question.options;
            }

            return option;
        },

        setObservers: function setObservers(observers) {
            for (var i = 0; i < observers.length; i++) {
                this.addObserver(observers[i]);
            }
            return this.observers;
        },

        addObserver: function addObserver(observer) {
            // no need to validate. anyone can listen
            // we do need to check to make sure the observer hasn't already
            // been added
            this.observers.push(observer);
        },

        getObservers: function getObservers() {
            return this.observers;
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
        getIndexBy: function getIndexBy(objArray, name, value) {
            for (var i = 0; i < objArray.length; i++) {
                if (objArray[i][name] == value) {
                    return i;
                }
            }
            return undefined;
        }
    };

    function createTree(options) {
        // required options
        if (typeof options.slug !== 'string') {
            console.error('Tree slug must be a string.');
            return false;
        }
        // INIT
        // Request our Tree Data
        // create the tree
        return getTreeData(options.slug).then(buildTree.bind(options)).catch(handleTreeDataError);
    }

    function getTreeData(slug) {

        return new Promise(function (resolve, reject) {
            var baseUrl = void 0;
            if (/https?:\/\/(?:localhost:3000|decision-tree.dev)\//.test(window.location.href)) {
                baseUrl = 'https://decision-tree.dev';
            } else {
                baseUrl = 'https://tree.mediaengagement.org';
            }

            var request = new XMLHttpRequest();
            request.overrideMimeType("application/json");
            request.open('GET', baseUrl + '/api/v1/trees/' + slug + '/compiled?minified=true', true);
            //request.responseType = 'json';
            // When the request loads, check whether it was successful
            request.onload = function () {
                if (request.status === 200) {
                    // If successful, resolve the promise by passing back the request response
                    resolve(request);
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

    function buildTree(request) {

        // check our response URL to make sure it's from a trusted source
        if (!/https?:\/\/(?:decision-tree\.dev|tree\.mediaengagement\.org|(?:enptree|cmetree)(\.staging)?\.wpengine\.com)\/api\//.test(request.responseURL)) {
            console.error('responseURL from an invalidated source.');
            return false;
        }

        var data = JSON.parse(request.response);
        console.log(data);

        var cssPriority = '';
        if (this.cssPriority) {
            cssPriority = this.cssPriority;
        }

        // the TreeView needs a container to display into
        var treeView = new TreeView({
            container: this.container,
            cssPriority: cssPriority
        });
        // Manages TreeHistory feature and TreeHistoryView
        var treeHistory = new TreeHistory({});
        // Manages passes usage Data to CME so we can continue to get funding to continue developing this tool and create new ones
        var treeInteraction = new TreeInteraction({});
        // Small postmessage package for iframe loads. Doesn't do anything if not an iframe load.

        // add the observers
        // bind history first so it will load the correct state and
        // not cause layout to have to be repainted twice (if different states)
        var observers = [treeHistory, treeView, treeInteraction];
        // if we're in an iframe, add the postMessage listener
        if (window.self.location !== window.top.location) {
            observers.push(new TreePostMessage({}));
        }
        // build the tree
        var tree = new Tree(data, observers);
        // send it to our trees array for access
        trees.push(tree);
        // return the tree we just created
        return tree;
    }

    function handleTreeDataError(err) {
        console.error(err);
    }

    var trees = [];
    window.Tree = Tree;
    window.createTree = createTree;
    window.trees = trees;
})(window);
'use strict';

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

/**
* Manages localStorage of current question state
* and previous states of the current decision tree path
* (so people can go back to previous questions)
*/
function TreeHistory(options) {
    var _Tree, _history, _historyStorageName, _currentIndex, // where in the history we're at (current state)
    _currentIndexStorageName;

    // keep an array of observers
    this.observers = [];

    /**
    * Private functions
    */
    // save the passed history to localStorage and set the global _history to make sure everything is in sync
    var _saveHistory = function _saveHistory(history) {
        _history = history;
        localStorage.setItem(_historyStorageName, JSON.stringify(_history));
    };

    var _saveCurrentIndex = function _saveCurrentIndex(currentIndex) {
        _currentIndex = currentIndex;
        localStorage.setItem(_currentIndexStorageName, JSON.stringify(_currentIndex));
    };

    // getters
    this.getTree = function () {
        return _Tree;
    };
    this.getHistory = function () {
        return _history;
    };
    this.getCurrentIndex = function () {
        return _currentIndex;
    };

    // setters
    /**
    * Clears the history and currentIndex to an empty state
    */
    this.clearHistory = function () {
        var treeID = void 0;
        treeID = this.getTree().getTreeID();
        // create as the Tree intro state with overview and index at start.
        var history = [{ type: 'intro', id: treeID }, { type: 'overview', id: treeID }];
        var currentIndex = 0;

        _saveHistory(history);
        _saveCurrentIndex(currentIndex);
    };

    /**
    * Sets the parent Tree
    */
    this.setTree = function (Tree) {
        // only let it be set once
        if (_Tree === undefined) {
            _Tree = Tree;
        }
        return _Tree;
    };

    /**
    * Sets variables and decides what state we'll init to
    */
    this.init = function () {
        var treeID = void 0,
            checkState = void 0;

        // get the tree id
        treeID = this.getTree().getTreeID();

        // set global storage string
        _historyStorageName = 'treeHistory__' + treeID;
        _currentIndexStorageName = 'treeHistoryIndex__' + treeID;

        // if localStorage is empty, create it
        if (localStorage.getItem(_historyStorageName) === null) {
            // sets a blank history and index
            this.clearHistory();
            this.emit('historyCreate', 'historyCreate', {});
        } else {
            // the history has been created before, so emit a reload
            this.emit('historyReload', 'historyReload', {});
        }

        // set from localStorage
        this.setHistory(JSON.parse(localStorage.getItem(_historyStorageName)));
        // set currentIndex from localStorage
        this.setCurrentIndex(JSON.parse(localStorage.getItem(_currentIndexStorageName)));
    };

    this.setHistory = function (history) {
        // TODO: different checks to make sure it's legit, like
        // don't add the same state twice.
        _saveHistory(history);
        // notify observers
        this.notifyObservers('historyUpdate', history);
        return;
    };

    this.setCurrentIndex = function (index) {
        var history = this.getHistory();
        // Check that the index exists
        if (index !== null && history[index] === undefined) {
            console.error('Index not found in History.');
            // Should we set the current index to null here?
            return false;
        }

        // don't worry about matching that the state exists. Maybe someone wants to set the current index to the last one in the series. Who knows?
        _saveCurrentIndex(index);
        this.notifyObservers('historyIndexUpdate', index);
        return;
    };

    this.setView = function (container) {};

    // if a Tree was passed, build the History now
    if (options.Tree) {
        this.build(options.Tree);
    }
}

TreeHistory.prototype = {
    constructor: TreeHistory,

    build: function build(Tree) {
        var history = void 0;
        this.setTree(Tree);
        this.init();
        // check the validity of the history, if it's not cool, clear history and run again
        history = this.getHistory();
        // if the first and second items aren't valid, reset it
        if (history[0].type !== 'intro' || history[1].type !== 'overview') {
            this.clearHistory();
        }
        this.forceCurrentState();
        // let everyone know the treeHistory is ready
        // emit that we've finished building the History
        this.emit('ready', 'historyReady', this);
    },

    addHistory: function addHistory(state) {
        // TODO: Validate state. Should be a function on the Tree
        // check whitelist for state?

        var history = this.getHistory();
        // add the state to the history
        history.push(state);
        // save it
        this.setHistory(history);
    },

    deleteHistoryAfter: function deleteHistoryAfter(index) {
        var history = void 0;
        // Don't let them delete the current state
        if (index === this.getCurrentIndex()) {
            console.error('Cannot delete current state.');
            return false;
        }

        // don't allow them to delete history before the current index
        if (index < this.getCurrentIndex) {
            console.error('Cannot delete states before the current state.');
            return false;
        }

        history = this.getHistory();
        // ok, delete away!
        // delete all history after the passed index
        // splice returns the delete array elements
        history.splice(index);
        this.setHistory(history);
    },

    getCurrentHistoryState: function getCurrentHistoryState() {
        var history = void 0,
            currentIndex = void 0;

        history = this.getHistory();
        currentIndex = this.getCurrentIndex();

        return history[currentIndex];
    },

    /**
    * Let our Tree know about the state we want to change to.
    */
    emit: function emit(action, item, data) {
        var Tree = this.getTree();
        switch (action) {
            case 'ready':
                Tree.message(item, data);
                break;
            case 'update':
                Tree.update(item, data);
                break;
            case 'historyCreate':
                Tree.message(item, data);
                break;
            case 'historyReload':
                Tree.message(item, data);
                break;
        }
    },

    /**
    * Get messages from observers
    */
    message: function message(action, item, data) {
        this.emit(action, item, data);
    },

    // tell the parent tree to update to our current state
    forceCurrentState: function forceCurrentState() {
        var currentIndex = void 0,
            history = void 0,
            data = void 0;

        currentIndex = this.getCurrentIndex();
        history = this.getHistory();

        if (this.currentIndex !== null && history[currentIndex] !== undefined) {
            data = Object.assign(history[currentIndex], { updatedBy: 'forceCurrentState', observer: 'TreeHistory' });
            this.emit('update', 'state', data);
        }
    },

    /**
    * Listen to parent Tree's emitted actions and handle accordingly
    */
    on: function on(action, data) {
        switch (action) {
            case 'ready':
                // data will be the tree itself
                this.build(data);
                break;
            case 'update':
                this.update(data);
                break;
            case 'viewReady':
                // build the view
                // this.setView(data)
                // get the container
                var treeView = data;
                var cWindow = treeView.getContentWindow();
                var historyView = new TreeHistoryView({
                    TreeHistory: this,
                    contentWindow: cWindow,
                    cssPriority: treeView.getCSSPriority()
                });
                // add this to the observers
                this.addObserver(historyView);
                break;
            case 'restart':
                // delete the history
                this.clearHistory();
                break;
            case 'start':
                // delete the history
                this.clearHistory();
                break;
        }

        // notify observers of these changes
        this.notifyObservers(action, data);
    },

    // updates the history state
    update: function update(states) {
        var newState = void 0,
            oldState = void 0,
            history = void 0,
            findNewStateIndex = void 0,
            findOldStateIndex = void 0,
            stateToAdd = void 0,
            Tree = void 0,
            currentHistoryState = void 0;

        // data contains old state and new state
        newState = states.newState;
        oldState = states.oldState;
        history = this.getHistory();
        currentHistoryState = this.getCurrentHistoryState();

        // check if we're resuming where we left off. ie, the updated state will match where we're at in the state history
        if (currentHistoryState !== undefined && newState.type === currentHistoryState.type && newState.id === currentHistoryState.id) {
            // do nothing! we're good
            return;
        }

        Tree = this.getTree();
        // try to find the new state in our history
        findNewStateIndex = this.getHistoryItemIndex(newState);

        // try to find the old state in our history
        findOldStateIndex = this.getHistoryItemIndex(oldState);
        // this.getIndexBy(history, 'id', oldState.id)

        // If we can find the new state index in our history,
        // then we don't want to ADD it to the history, we just want to
        // change our currentIndex to match where they are.
        // EX. Someone clicked the "back" or "forward" buttons.
        // They're not adding history, they're just changing where they are
        if (findNewStateIndex !== undefined) {
            // set the currentIndex accordingly
            this.setCurrentIndex(findNewStateIndex);
        }

        // try to find the previous state. is it the last one in the
        // current state tree?
        // if not, delete any history after the previous state.
        // They've gone rogue by going back in history and
        // then chose a new path
        // unless we're going from Start to the First Question. We want to keep the overview in there.
        else if (findOldStateIndex !== undefined && findOldStateIndex !== history.length - 1) {
                // delete anything after this point, because they've changed their state history
                // we don't want to delete one by one because:
                // 1. we won't allow them to do that
                // 2. it'll be a lot slower to delete one by one
                // make sure we're not trying to delete the intro or tree states from the history
                if (oldState.type !== 'intro' && oldState.type !== 'overview') {
                    this.deleteHistoryAfter(findOldStateIndex + 1);
                }

                // add our new history
                // set it as our var to add
                stateToAdd = newState;
            } else {
                // welp, they're just going forwards.
                // Nothing to do but add the state!
                stateToAdd = newState;
            }

        // see if there's anything to add
        if ((typeof stateToAdd === 'undefined' ? 'undefined' : _typeof(stateToAdd)) === 'object' && stateToAdd !== undefined) {
            this.addHistory(stateToAdd);
            // set the new current index
            this.setCurrentIndex(this.getHistory().length - 1);
        }
    },

    setObservers: function setObservers(observers) {
        for (var i = 0; i < observers.length; i++) {
            this.addObserver(observers[i]);
        }
        return this.observers;
    },

    addObserver: function addObserver(observer) {
        // no need to validate. anyone can listen
        // we do need to check to make sure the observer hasn't already
        // been added
        this.observers.push(observer);
    },

    getObservers: function getObservers() {
        return this.observers;
    },

    notifyObservers: function notifyObservers(action, data) {
        var _this = this;

        var _loop = function _loop(i) {
            // async emit
            setTimeout(function () {
                _this.observers[i].on(action, data);
            }, 0);
        };

        for (var i = 0; i < this.observers.length; i++) {
            _loop(i);
        }
    },

    // finds an item in the history object.
    getHistoryItemIndex: function getHistoryItemIndex(state) {
        var history = void 0,
            index = void 0;

        history = this.getHistory();
        // check for tree or intro here because there will only ever be one in the history
        // and their ID is set as the treeID which matches each other
        if (state.type === 'overview' || state.type === 'intro') {
            index = this.getIndexBy(history, 'type', state.type);
        } else {
            index = this.getIndexBy(history, 'id', state.id);
        }

        return index;
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
    getIndexBy: function getIndexBy(objArray, name, value) {
        for (var i = 0; i < objArray.length; i++) {
            if (objArray[i][name] == value) {
                return i;
            }
        }
        return undefined;
    }
};
'use strict';

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

function TreeHistoryView(options) {
    var _TreeHistory, _contentWindow, _container, _list, _resumeBtn, _progressbar, _indicator, _cssPriority;

    if (_typeof(options.contentWindow) !== 'object') {
        console.error('Tree History View container must be a valid object. Try `container: document.getElementById(your-id)`.');
        return false;
    }

    if (_typeof(options.TreeHistory) !== 'object') {
        console.error('Tree History must be a valid object.');
        return false;
    }

    // getters
    this.getContentWindow = function () {
        return _contentWindow;
    };
    this.getContainer = function () {
        return _container;
    };
    this.getList = function () {
        return _list;
    };
    this.getResumeBtn = function () {
        return _resumeBtn;
    };
    this.getProgressbar = function () {
        return _progressbar;
    };
    this.getIndicator = function () {
        return _indicator;
    };
    this.getTreeHistory = function () {
        return _TreeHistory;
    };
    this.getCSSPriority = function () {
        return _cssPriority;
    };

    // setters
    this.setContentWindow = function (contentWindow) {
        // only let it get set once
        if (_contentWindow === undefined) {
            // set our built div as the contentWindow
            _contentWindow = contentWindow;
        }
        return _contentWindow;
    };

    this.setContainer = function () {
        // only let it get set once
        if (_container === undefined) {
            var historyView = this.createView();
            var cWindow = this.getContentWindow();
            // place it in the passed container
            cWindow.insertBefore(historyView, cWindow.firstElementChild);
            // set our built div as the container
            _container = cWindow.firstElementChild;
        }
        return _container;
    };

    this.setList = function (list) {
        // only let it get set once
        if (_list === undefined) {
            // set our built div as the list
            _list = list;
        }
        return _list;
    };

    this.setResumeBtn = function (resumeBtn) {
        // only let it get set once
        if (_resumeBtn === undefined) {
            // set our built div as the resume
            _resumeBtn = resumeBtn;
        }
        return _resumeBtn;
    };

    this.setProgressbar = function (progre) {
        // only let it get set once
        if (_progressbar === undefined) {
            // set our built div as the resume
            _progressbar = progre;
        }
        return _progressbar;
    };

    this.setIndicator = function (indicator) {
        // only let it get set once
        if (_indicator === undefined) {
            // set our built div as the resume
            _indicator = indicator;
        }
        return _indicator;
    };

    this.setCSSPriority = function (cssPriority) {
        // only let it be set once
        if (_cssPriority === undefined && (cssPriority === 'important' || cssPriority === '!important')) {
            _cssPriority = cssPriority;
        } else {
            _cssPriority = '';
        }
        return _cssPriority;
    };

    var _setTreeHistory = function _setTreeHistory(TreeHistory) {
        _TreeHistory = TreeHistory;
    };

    _setTreeHistory(options.TreeHistory);
    this.setContentWindow(options.contentWindow);
    this.setCSSPriority(options.cssPriority);
    this.setContainer();
    this.templateRender(this.getTreeHistory().getHistory(), this.getTreeHistory().getCurrentIndex());
    // add click listener on container
    _container.addEventListener("click", this.click.bind(this));
}

TreeHistoryView.prototype = {
    constructor: TreeHistoryView,

    on: function on(action, data) {
        switch (action) {
            case 'historyUpdate':
                // data will be the tree itself
                this.updateHistory(data);
                break;
            case 'historyIndexUpdate':
                this.updateHistoryIndex(data);
                break;
            case 'viewHeightUpdate':
                // we need to wait until the viewHeights have been calculated and set so
                // we can set the heights appropriately
                var currentIndex = this.getCurrentIndex();
                this.templateUpdateProgressbar(currentIndex);
                break;
        }
    },

    /**
    * Let our Tree History know about whatever
    */
    message: function message(action, item, data) {
        var TreeHistory = this.getTreeHistory();
        // this is usually Tree.update('state', dataAboutNewState)
        TreeHistory.message(action, item, data);
    },

    click: function click(event) {
        var el = void 0,
            extraData = void 0;

        el = event.target;

        extraData = { updatedBy: 'click', observer: 'TreeHistoryView'

            // check if it's a click on the parent tree (which we don't care about)
        };if (el !== event.currentTarget) {
            // also check for parent, as the
            if (el.nodeName === 'BUTTON' || el.parentNode.nodeName === 'BUTTON') {
                event.preventDefault();
                // if our parent is the A, then set that as el, bc that's the one with the data set on it. This is for the overviewBtn
                if (el.parentNode.nodeName === 'BUTTON') {
                    el = el.parentNode;
                }
                // see if we want to go to overview or new question/end
                if (!el.classList.contains('is-active') || el.data.type === 'overview') {
                    this.message('update', 'state', Object.assign(el.data, extraData));
                }
            }
        }
        event.stopPropagation();
    },

    keydown: function keydown() {},

    createView: function createView() {
        var nav = void 0,
            navTitle = void 0;

        nav = document.createElement('nav');
        nav.classList.add('cme-tree__history');
        nav.id = 'cme-tree__history--' + this.getTreeHistory().getTree().getTreeID();
        nav.tabIndex = -1;

        navTitle = document.createElement('h3');
        navTitle.innerHTML = 'History Navigation: Go to Overview and Previously Answered Questions';
        navTitle.classList.add('cme-tree__title--history-nav', 'cme-tree__visually-hidden');
        nav.appendChild(navTitle);

        return nav;
    },

    getCurrentNav: function getCurrentNav() {
        var currentIndex = void 0,
            historyNav = void 0;

        currentIndex = this.getCurrentIndex();
        historyNav = this.getHistoryNavItems();

        return historyNav[currentIndex];
    },
    getCurrentIndex: function getCurrentIndex() {
        var currentIndex = void 0,
            TreeHistory = void 0;

        TreeHistory = this.getTreeHistory();
        currentIndex = TreeHistory.getCurrentIndex();
        return currentIndex;
    },


    // Gets current state of the tree
    getCurrentState: function getCurrentState() {
        var state = void 0;

        state = this.getTreeHistory().getTree().getState();
        return state;
    },


    // just the history question/end items. Not the overview btn.
    getHistoryNavItems: function getHistoryNavItems() {
        var list = this.getList();
        return list.getElementsByClassName('cme-tree__history-list-item--nav');
    },


    // All items, including overview button
    getHistoryItems: function getHistoryItems() {
        var list = this.getList();
        return list.children;
    },


    updateHistory: function updateHistory(history) {
        this.templateUpdateHistory(history);
    },

    updateHistoryIndex: function updateHistoryIndex(index) {
        this.templateUpdateIndex(index);
    },

    // TODO: Elements are being added/removed. Check each element to see if its element.data matches the history data in order. If one doesn't match, rerender from that point on.
    templateRender: function templateRender(history, currentIndex) {
        var container = void 0,
            list = void 0,
            indicator = void 0,
            current = void 0,
            item = void 0,
            goToHistoryNav = void 0;

        container = this.getContainer();
        container.appendChild(this.templateUl());
        // set the list as the _list var
        this.setList(container.children[1]);
        list = this.getList();

        // create the progressbar
        container.appendChild(this.templateProgressbar());
        this.setProgressbar(container.children[2]);

        // create the current position indicator
        indicator = document.createElement('div');
        indicator.classList.add('cme-tree__history-current-indicator');
        container.appendChild(indicator);
        this.setIndicator(container.children[3]);

        // create a visually hidden "go to history navigation" button
        goToHistoryNav = document.createElement('a');
        goToHistoryNav.href = '#' + container.id;
        goToHistoryNav.classList.add('cme-tree__visually-hidden', 'cme-tree__go-to-history-nav', 'cme-tree__btn');
        goToHistoryNav.innerHTML = 'Go to History Navigation';
        this.getContentWindow().appendChild(goToHistoryNav);

        // create the buttons
        for (var i = 0; i < history.length; i++) {
            if (i === 0) {
                if (history[i].type !== 'intro') {
                    console.error('First history item should be of type "intro"');
                }
                item = this.templateStartBtn(history[i]);
            } else if (i === 1) {
                if (history[i].type !== 'overview') {
                    console.error('Second history item should be of type "tree"');
                }
                item = this.templateOverviewBtn(history[i]);
            } else {
                // generate list data and append to item
                item = this.templateHistoryItem(history[i], i, currentIndex);
            }
            list.appendChild(item);
        }

        // set the progressbarHeight
        this.templateUpdateProgressbar(currentIndex);

        // set the active element
        this.templateUpdateIndex(currentIndex);
    },

    templateUpdateHistory: function templateUpdateHistory(history) {
        var list = void 0,
            li = void 0,
            button = void 0,
            deleteLi = void 0,
            iterator = void 0;

        // go through and compare
        list = this.getList();
        li = this.getHistoryItems();
        // the first one is the overview button, so don't include it
        deleteLi = [];
        iterator = li.length;

        // if there's no history, delete all lis
        if (!history.length) {
            for (var i = 0; i < li.length; i++) {
                list.removeChild(li[i]);
            }
            return;
        }

        // if we don't have any li's, then create them all
        if (!li.length) {
            // create the elements
            for (var _i = 0; _i < history.length; _i++) {
                list.appendChild(this.templateHistoryItem(history[_i], _i));
            }
            return;
        }

        // decide which is longer and set that as our iterator
        if (li.length <= history.length) {
            iterator = history.length;
        }
        // if we have lis and history, let's check out which ones we need to delete or add
        for (var _i2 = 0; _i2 < iterator; _i2++) {

            if (li[_i2] !== undefined) {
                button = li[_i2].firstElementChild;
            }
            if (deleteLi.length !== 0 || history[_i2] === undefined) {
                // add these to the ones to delete
                deleteLi.push(li[_i2]);
            } else if (li[_i2] === undefined) {
                // create it
                list.appendChild(this.templateHistoryItem(history[_i2], _i2));
            }
            // if both exist, compare values
            else if (button.data !== undefined && button.data.id !== history[_i2].id) {
                    // add these to the ones to delete
                    deleteLi.push(li[_i2]);
                } else {
                    // nothing to do - they're the same!
                }
        }
        // delete children if we need to
        for (var _i3 = 0; _i3 < deleteLi.length; _i3++) {
            list.removeChild(deleteLi[_i3]);
        }
    },

    templateUpdateIndex: function templateUpdateIndex(currentIndex) {
        var li = void 0,
            button = void 0;

        li = this.getHistoryItems();
        // first check that we need to update anything
        for (var i = 0; i < li.length; i++) {
            button = li[i].firstElementChild;
            if (button.classList.contains('is-active') && i !== currentIndex) {
                button.classList.remove('is-active');
                li[i].classList.remove('is-active');
            }
        }
        button = li[currentIndex].firstElementChild;
        if (!button.classList.contains('is-active')) {
            button.classList.add('is-active');
            li[currentIndex].classList.add('is-active');
        }
    },


    templateUpdateProgressbar: function templateUpdateProgressbar(currentIndex) {
        var progressbar = void 0,
            progressbarHeight = void 0,
            indicator = void 0,
            indicatorHeight = void 0,
            historyItems = void 0,
            list = void 0,
            listHeight = void 0,
            container = void 0,
            containerMoveUp = void 0,
            cWindow = void 0,
            cWindowHeight = void 0;

        container = this.getContainer();
        progressbar = this.getProgressbar();
        historyItems = this.getHistoryItems();
        progressbarHeight = historyItems[currentIndex].offsetTop;
        // update height
        progressbar.style.height = progressbarHeight + 'px';

        indicator = this.getIndicator();
        this.setTransform(indicator, 'translate3d(0,' + progressbarHeight + 'px, 0)');
        indicator.classList.add('cme-tree__history-current-indicator--gooify');
        setTimeout(function () {
            indicator.classList.remove('cme-tree__history-current-indicator--gooify');
        }, 500);

        cWindow = this.getContentWindow();
        list = this.getList();
        listHeight = list.getBoundingClientRect().height;
        cWindowHeight = parseFloat(cWindow.style.height);
        // default to the top
        containerMoveUp = 0;

        // OMG just don't. This was way harder on a Friday afternoon than it
        // should have been.
        // We're checking to see if the contentWindow is less than the listHeight AND if the progressbarHeight is tall enough that we need to address it.
        // IE. We don't want to move the list all the way down if they have 10 items, but they've moved back to the second.
        if (cWindowHeight < listHeight && cWindowHeight / 2 < progressbarHeight) {

            if (listHeight - progressbarHeight < cWindowHeight / 2) {
                // the bottom element can be in the bottom half of the view, so stack it to the bottom.
                containerMoveUp = cWindowHeight - listHeight;
            } else {
                // Center it in the window because we're not near the top or bottom
                containerMoveUp = -(progressbarHeight - cWindowHeight / 2 + historyItems[currentIndex].getBoundingClientRect().height / 2);
            }
        }

        this.setTransform(container, 'translate3d(0,' + containerMoveUp + 'px,0)');
    },

    templateUl: function templateUl() {
        var ul = document.createElement('ul');
        ul.classList.add('cme-tree__history-list');
        return ul;
    },

    templateProgressbar: function templateProgressbar() {
        var progressbar = document.createElement('div');
        progressbar.classList.add('cme-tree__history-progress');
        return progressbar;
    },

    // a button so we can display all the buttons in the html without having to show the start button
    templateStartBtn: function templateStartBtn(data) {
        var li = void 0,
            button = void 0;

        li = document.createElement('li');
        button = document.createElement('button');
        li.appendChild(button);

        li.classList.add('cme-tree__history-list-item', 'cme-tree__history-list-item--start');

        button.classList.add('cme-tree__history-list-link', 'cme-tree__history-list-link--start');
        button.data = data;

        return li;
    },

    // The data needs to be formatted to send a message that
    // we want to go to the overview mode
    templateOverviewBtn: function templateOverviewBtn(data) {
        var li = void 0,
            button = void 0;

        li = document.createElement('li');
        button = document.createElement('button');
        li.appendChild(button);

        li.classList.add('cme-tree__history-list-item', 'cme-tree__history-list-item--overview');
        button.setAttribute('aria-label', 'Go to Overview');
        button.classList.add('cme-tree__history-list-link', 'cme-tree__history-list-link--overview');
        button.innerHTML = '<div class="cme-tree__overview-icon"></div><div class="cme-tree__overview-icon"></div>';
        button.data = data;

        return li;
    },

    templateHistoryItem: function templateHistoryItem(data, index) {
        var li = void 0,
            button = void 0;

        li = document.createElement('li');
        button = document.createElement('button');
        li.appendChild(button);
        button.setAttribute('aria-label', 'Question ' + (index - 1));
        li.classList.add('cme-tree__history-list-item', 'cme-tree__history-list-item--nav');

        button.classList.add('cme-tree__history-list-link', 'cme-tree__history-list-link--nav');
        // because of the start button (hidden) and overview button before it
        // we need to subtract 1 from the index
        button.innerHTML = index - 1;
        button.data = data;

        return li;
    },

    setTransform: function setTransform(element, transform) {
        element.setAttribute('style', 'transform: ' + transform + this.getCSSPriority() + ';');
    }
};
'use strict';

/**
* Manages localStorage of current question state
* and previous states of the current decision tree path
* (so people can go back to previous questions)
*/
function TreeInteraction(options) {
    var _Tree, _rootURL, _postURL, _siteName, _host, _path, _isIframe, _userID;
    /**
    * Private functions
    */
    var _setRootURL = function _setRootURL() {
        var scripts = void 0,
            currentScript = void 0,
            regex = void 0,
            rootURL = void 0;
        // get the current script being processed (this one)
        scripts = document.querySelectorAll('script[src]');
        currentScript = scripts[scripts.length - 1].src;

        // regex it to see if it's one of our DEV urls
        regex = /https?:\/\/(?:(?:localhost:3000|decision-tree.dev)|(?:enptree|cmetree)\.(?:staging\.)?wpengine\.com)\b/;
        _rootURL = regex.exec(currentScript);

        if (_rootURL === null) {
            // we're not on DEV, so pass the rootURL as our PROD url
            _rootURL = 'https://tree.mediaengagement.org';
        }

        return _rootURL;
    };

    var _setUserID = function _setUserID() {
        var userIDStorageName = 'treeUserID';
        var userID = localStorage.getItem(userIDStorageName);
        if (userID === null) {
            userID = '';
            for (var i = 0; i < 8; i++) {
                userID = userID + Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
            }
            localStorage.setItem(userIDStorageName, userID);
        }

        _userID = userID;

        return _userID;
    };

    // getters
    this.getTree = function () {
        return _Tree;
    };
    this.getIsIframe = function () {
        return _isIframe;
    };
    this.getRootURL = function () {
        return _rootURL;
    };
    this.getPostURL = function () {
        return _postURL;
    };
    this.getSiteName = function () {
        return _siteName;
    };
    this.getHost = function () {
        return _host;
    };
    this.getPath = function () {
        return _path;
    };
    this.getUserID = function () {
        return _userID;
    };
    this.getUserIDStorageName = function () {
        return _userIDStorageName;
    };

    // setters
    /**
    * Sets the parent Tree
    */
    this.setTree = function (Tree) {
        // only let it be set once
        if (_Tree === undefined) {
            _Tree = Tree;
        }
        return _Tree;
    };

    this.setPostURL = function () {
        _postURL = this.getRootURL() + '/api/v1/interactions';
        return _postURL;
    };

    this.setSiteName = function (siteName) {
        if (_siteName === undefined) {
            if (this.getIsIframe() === false) {
                var fbOG = document.querySelector('meta[property="og:site_name"]');
                if (fbOG) {
                    _siteName = fbOG.content;
                } else {
                    _siteName = document.title;
                }
            }
            // if no siteName was passed, ask for it
            else if (siteName === undefined) {
                    this.emit('getParentSiteName', 'getParentSiteName', {});
                } else {
                    //
                    _siteName = siteName;
                    console.log('recieved siteName', _siteName);
                }
        }
    };

    this.setPath = function (path) {
        // only let it get set once
        if (_path === undefined) {
            if (this.getIsIframe() === false) {
                _path = window.self.location.pathname;
            }
            // if no path was passed, ask for it
            else if (path === undefined) {
                    this.emit('getParentPath', 'getParentPath', {});
                } else {
                    // should get set from a postmessage
                    _path = path;
                    console.log('recieved path', _path);
                }
        }
    };

    this.setHost = function (host) {
        // only let it get set once
        if (_host === undefined) {
            if (this.getIsIframe() === false) {
                _host = window.self.location.host;
            }
            // if no siteName was passed, ask for it
            else if (host === undefined) {
                    this.emit('getParentHost', 'getParentHost', {});
                } else {
                    // should get set from a postmessage
                    _host = host;
                    console.log('recieved host', _host);
                }
        }
    };

    var _setIsIframe = function _setIsIframe() {
        _isIframe = false;

        // if we're in an iframe, set _isIframe to true
        if (window.self.location !== window.top.location) {
            _isIframe = true;
        }
        return _isIframe;
    };

    this.init = function () {
        // set the userID
        _setUserID();
        // set if it's an iframe or not
        _setIsIframe();
        // set the path
        this.setPath();
        // set the host
        this.setHost();
        // set the site Name
        this.setSiteName();
        // set the post URL
        this.setPostURL();
    };

    // passes the data to the server
    this.saveInteraction = function (data) {
        var _this = this;

        var whitelist = void 0,
            validState = void 0,
            Tree = void 0,
            postURL = void 0,
            treeID = void 0;

        Tree = this.getTree();
        // Validate that it's a legit state
        validState = Tree.validateState(data.destination.type, data.destination.id);

        if (validState !== true) {
            console.error('Invalid Tree State');
            return new Promise(function (resolve, reject) {});
        }

        // validate interaction type
        whitelist = ['load', 'reload', 'start', 'restart', 'overview', 'option', 'history'];

        // check allowed interaction types
        if (!whitelist.includes(data.interaction.type)) {
            console.error(data.interaction.type + " is not an allowed interaction. Allowed interactions are " + whitelist.toString());
        }

        postURL = this.getPostURL();
        treeID = Tree.getTreeID();

        // combine data and our userID
        data = Object.assign(data, {
            userID: this.getUserID(),
            treeID: Tree.getTreeID(),
            site: {
                name: this.getSiteName(),
                host: this.getHost(),
                path: this.getPath(),
                isIframe: this.getIsIframe()
            }
        });

        if (data.site.name === undefined || data.site.host === undefined || data.site.path === undefined) {
            // chill for a sec and see if we can get it in a bit
            console.log('waiting for something...');
            setTimeout(function () {
                _this.saveInteraction(data).then(_this.response);
            }, 100);
            return new Promise(function (resolve, reject) {});
        }

        console.log('SaveInteraction sending', data);

        return new Promise(function (resolve, reject) {

            var request = new XMLHttpRequest();
            // request.overrideMimeType("application/json");
            request.open('POST', postURL);
            request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");

            // When the request loads, check whether it was successful
            request.onload = function () {
                if (request.status === 200) {
                    // If successful, resolve the promise by passing back the request response
                    resolve(request);
                } else {
                    // If it fails, reject the promise with a error message
                    reject(Error('Tree data could not be saved:' + request.statusText));
                }
            };
            request.onerror = function () {
                // Also deal with the case when the entire request fails to begin with
                // This is probably a network error, so reject the promise with an appropriate message
                reject(Error('There was a network error.'));
            };

            // Send the request
            request.send(JSON.stringify(data));
        });
    };

    this.response = function (request) {
        // response from the server
        var data = JSON.parse(request.response);
        console.log(data);
    };

    // set the rootURL
    _setRootURL();

    // if a Tree was passed, Do whatever you need to do
    if (options.Tree) {
        this.build(options.Tree);
    }
}

TreeInteraction.prototype = {
    constructor: TreeInteraction,

    build: function build(Tree) {
        this.setTree(Tree);
        this.init();
    },

    /**
    * Listen to parent Tree's emitted actions and handle accordingly
    */
    on: function on(action, data) {
        var interaction = void 0;
        switch (action) {
            case 'ready':
                // data will be the tree itself
                this.build(data);
                break;
            case 'setParentSiteName':
                console.log('SiteName', this.getSiteName());
                // set the parent site name
                this.setSiteName(data.siteName);
                console.log('After Set SiteName', this.getSiteName());
                break;
            case 'setParentHost':
                console.log('Host', this.getHost());
                // set the parent host
                this.setHost(data.host);
                console.log('After Set Host', this.getHost());
                break;
            case 'setParentPath':
                console.log('Site Path', this.getPath());
                // set the parent path
                this.setPath(data.path);
                console.log('After Set Site Path', this.getPath());
                break;
            case 'historyCreate':
                // history loaded for the first time, so it's our first load
                this.saveLoad('load');
                break;
            case 'historyReload':
                // save the reload
                this.saveLoad('reload');
                break;
            case 'update':
                // if the update is from the TreeHistory,
                // ignore it, BC we're already saving their update (forceCurrentState) from the reload/load
                if (data.data.observer === 'TreeHistory') {
                    break;
                }
                interaction = this.convertUpdateToInteraction(data);
                this.saveInteraction(interaction).then(this.response);
                break;
            case 'overviewOptionInteraction':
                interaction = this.convertOverviewOptionToInteraction(data);
                this.saveInteraction(interaction).then(this.response);
                break;
        }
    },

    /**
    * Let our Tree know about what actions we did
    */
    emit: function emit(action, item, data) {
        var Tree = this.getTree();
        switch (action) {
            case 'ready':
                // tell the Tree to let all the other observers know that the TreeInteraction class is ready
                Tree.message(item, data);
                break;
            case 'saveInteraction':
                // tell the Tree to let all the other observers know that we saved data
                Tree.message(item, data);
                break;
            case 'getParentSiteName':
                // ask for the parent site name
                Tree.message(item, data);
                break;
            case 'getParentHost':
                // ask for the parent host
                Tree.message(item, data);
                break;
            case 'getParentPath':
                // ask for the parent path
                Tree.message(item, data);
                break;
        }
    },

    /**
    * Saves load or reload from the TreeHistory
    * @param loadType (STRING) 'load' or 'reload'
    */
    saveLoad: function saveLoad(loadType) {
        var Tree = void 0,
            data = void 0;

        Tree = this.getTree();
        // build our data
        data = {};

        // set the interaction
        data.interaction = {
            type: loadType,
            id: this.getTree().getTreeID()

            // set the destination (whatever we loaded to)
        };data.destination = this.getTree().getState();

        // save the interaction
        this.saveInteraction(data).then(this.response);
    },

    /**
     * Takes the data structure from an update state response
     * and convertes it into the data structure we need to
     * save it on the server.
     */
    convertUpdateToInteraction: function convertUpdateToInteraction(update) {
        var data = void 0,
            interactionType = void 0,
            interactionID = void 0,
            observer = void 0;
        console.log('update', update);
        data = {};
        interactionType = update.data.type;
        interactionID = false;
        observer = update.data.observer;

        data.interaction = {};

        if (update.data.ID) {
            // pass the element ID
            interactionID = update.data.ID;
        }
        // check if it's a history click
        else if (observer === 'TreeHistoryView') {
                interactionType = 'history';
            }

        data.interaction.type = interactionType;
        data.interaction.id = interactionID;
        data.destination = update.newState;

        return data;
    },

    /**
     * Takes the data structure from the option.data of an
     * overviewOptionInteraction and convertes it into the
     * data structure we need to save it on the server.
     * @param data should be the option_el.data
     */
    convertOverviewOptionToInteraction: function convertOverviewOptionToInteraction(data) {
        var interactionData = void 0;

        // build data
        interactionData = {
            interaction: {
                id: data.ID,
                type: data.type // 'option'
            }

            // add the destination (NOT THE QUESTION DESTINATION CUZ WE'RE STILL IN THE OVERVIEW STATE)
            // the current tree state will be type: 'overview', id: treeID
        };interactionData.destination = this.getTree().getState();

        return interactionData;
    }

};
'use strict';

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

/**
* Sends postmessages to the parent iframe if there is one
*/
function TreePostMessage(options) {
    var _Tree;

    // getters
    this.getTree = function () {
        return _Tree;
    };

    // setters
    /**
    * Sets the parent Tree
    */
    this.setTree = function (Tree) {
        // only let it be set once
        if (_Tree === undefined) {
            _Tree = Tree;
        }
        return _Tree;
    };

    this.init = function () {
        // add our event listener for postmessages
        window.addEventListener("message", this.recieveMessage.bind(this), false);
    };

    // if a Tree was passed, Do whatever you need to do
    if (options.Tree) {
        this.build(options.Tree);
    }
}

TreePostMessage.prototype = {
    constructor: TreePostMessage,

    build: function build(Tree) {
        this.setTree(Tree);
        this.init();
    },

    /**
    * Listen to parent Tree's emitted actions and handle accordingly
    */
    on: function on(action, data) {
        var _this = this;

        console.log('data', data);
        switch (action) {
            case 'ready':
                // data will be the tree itself
                this.build(data);
                break;
            case 'viewHeightUpdate':
                // make a request to get the full treeHeight
                // wait til the height animation is finished before we set the finished height
                setTimeout(function () {
                    _this.getTree().message('getTreeHeight', {});
                }, 500);
                break;

        }
        // pass the message on to the parent
        // add the action to our data to pass
        data.action = action;
        this.postIt(data);
    },

    // send the postmessage
    postIt: function postIt(data) {
        if ((typeof data === 'undefined' ? 'undefined' : _typeof(data)) !== 'object') {
            console.error('PostMessage data is not an object');
            return false;
        }
        data.treeID = this.getTree().getTreeID();
        console.log('postIt send', data);

        // allow all domains to access this info (*)
        parent.postMessage(JSON.stringify(data), "*");
        // if you want to see what was sent
        return data;
    },

    recieveMessage: function recieveMessage(event) {
        var data = void 0;
        // check to make sure we received a string
        if (typeof event.data !== 'string') {
            return false;
        }
        // get the data
        data = JSON.parse(event.data);

        // send the data out to all the observers
        if (data.action !== undefined) {
            this.getTree().message(data.action, data);
        }

        // see what they want to do
        console.log('Iframe Recieved Message', data);
    }
};
'use strict';

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

function TreeView(options) {
    var _Tree, _container, _treeEl, _contentWindow, _contentPane, _activeEl, _cssPriority;

    if (_typeof(options.container) !== 'object') {
        console.error('Tree container must be a valid object. Try `container: document.getElementById(your-id)`.');
        return false;
    }

    // getters
    this.getContainer = function () {
        return _container;
    };
    this.getTree = function () {
        return _Tree;
    };
    this.getTreeEl = function () {
        return _treeEl;
    };
    this.getActiveEl = function () {
        return _activeEl;
    };
    this.getContentWindow = function () {
        return _contentWindow;
    };
    this.getContentPane = function () {
        return _contentPane;
    };
    this.getCSSPriority = function () {
        return _cssPriority;
    };

    // setters
    this.setTree = function (Tree) {
        // only let it be set once
        if (_Tree === undefined) {
            _Tree = Tree;
        }
        return _Tree;
    };

    // setters
    this.setTreeEl = function () {
        // only let it be set once
        if (_treeEl === undefined) {
            // this will be the tree rendered by handlebars
            _treeEl = _container.firstElementChild;
        }
        return _treeEl;
    };

    this.setContentWindow = function () {
        // only let it be set once
        if (_contentWindow === undefined) {
            _contentWindow = document.getElementById('cme-tree__content-window--' + _Tree.getTreeID());
        }
        return _contentWindow;
    };

    this.setContentPane = function () {
        // only let it be set once
        if (_contentPane === undefined) {
            _contentPane = _contentWindow.firstElementChild;
        }
        return _contentPane;
    };

    this.setCSSPriority = function (cssPriority) {
        // only let it be set once
        if (_cssPriority === undefined && (cssPriority === 'important' || cssPriority === '!important')) {
            _cssPriority = '!important';
        } else {
            _cssPriority = '';
        }
        return _cssPriority;
    };

    // Pass a state for it to set to be active
    this.setActiveEl = function (state) {
        var el = void 0,
            elId = void 0;

        if (state.type === 'overview') {
            elId = 'cme-tree--' + state.id;
        } else {
            elId = 'cme-tree__el--' + state.id;
        }
        // check if classname matches, if we're even going to change anything
        if (_activeEl !== undefined && _activeEl.id === elId) {
            // do nothing
            return _activeEl;
        }
        // they're trying to set a new state, so let's see if we can
        el = document.getElementById(elId);
        if ((typeof el === 'undefined' ? 'undefined' : _typeof(el)) !== 'object') {
            console.error('Could not set active element for state type ' + state.type + ' with state id ' + state.id);
            return false;
        }

        // valid (could be more checks, but this is good enough)
        // set it
        _activeEl = el;
        return _activeEl;
    };

    /***********************
    ******** INIT  *********
    ***********************/
    // set an active className
    this.activeClassName = 'is-active';
    // how long animation classes are applied for until removed
    this.animationLength = 500;
    // not ideal to pass this, but it's SOOO much faster performance wise
    this.scaledSize = 0.65;
    // create a stylesheet we can add rules to
    this.stylesheet = this.createStylesheet();
    // get the window width for resize checks
    this.windowWidth = window.innerWidth;
    // set the el
    _container = options.container;
    // set the priority
    this.setCSSPriority(options.cssPriority);

    // attach event listeners to the tree element with
    // bound `this` so we get our reference to this element
    _container.addEventListener("click", this.click.bind(this));
    _container.addEventListener("keydown", this.keydown.bind(this));
    // add a resize timeout so we know if one is already firing
    this.resizeTimeout = null;
    window.addEventListener("resize", this.resize.bind(this));

    // if a Tree was passed, build the view now
    if (options.Tree) {
        this.build(options.Tree);
    }
}

TreeView.prototype = {
    constructor: TreeView,

    /**
    * Listen to parent Tree's emitted actions and handle accordingly
    */
    on: function on(action, data) {
        switch (action) {
            case 'ready':
                // data will be the tree itself
                this.build(data);
                break;
            case 'update':
                this.updateState(data);
                break;
            // used by PostMessage to get the tree height to pass to the iframe
            case 'getTreeHeight':
                this.emit('treeHeight', 'treeHeight', { treeHeight: this.getTreeHeight() });
        }
    },

    build: function build(Tree) {

        this.setTree(Tree);
        this.render(Tree.getData());

        // set the tree wrap
        this.setContentWindow();
        // set the questions wrap
        this.setContentPane();
        // let everyone know the tree view is ready
        // emit that we've finished render
        this.emit('ready', 'viewReady', this);
        // set the current state in the view
        var init = true;
        // calculate size
        this.setState(Tree.getState(), init);
        this.updateViewHeight(Tree.getState());

        // if we don't have any groups calculated, go ahead and calculate to store the values
        this.checkForGroupsCalc();
    },

    render: function render(data) {
        // render the tree
        var template = window.TreeTemplates.tree;
        var treeHTML = template(data);
        // set the HTML into the passed container
        this.getContainer().innerHTML = treeHTML;
        // set the Tree El
        this.setTreeEl();
        // bind question data
        this.bindAllData();
    },

    getGroups: function getGroups() {
        var treeEl = void 0,
            groups = void 0;

        treeEl = this.getTreeEl();
        return treeEl.getElementsByClassName('cme-tree__group');
    },

    getQuestions: function getQuestions() {
        var treeEl = void 0;

        treeEl = this.getTreeEl();
        return treeEl.getElementsByClassName('cme-tree__question');
    },

    getQuestion: function getQuestion(id) {
        return this.getDestination(id);
    },

    getEnds: function getEnds() {
        var treeEl = void 0;

        treeEl = this.getTreeEl();
        return treeEl.getElementsByClassName('cme-tree__end');
    },

    getEnd: function getEnd(id) {
        return this.getDestination(id);
    },

    getDestination: function getDestination(destinationID) {
        return document.getElementById('cme-tree__el--' + destinationID);
    },

    getOptions: function getOptions(question) {
        return question.getElementsByClassName('cme-tree__option-link');
    },

    getDestinationIcon: function getDestinationIcon(optionID) {
        return document.getElementById('cme-tree__destination-icon--' + optionID);
    },

    getStylesheet: function getStylesheet() {
        return this.stylesheet;
    },

    // from https://davidwalsh.name/add-rules-stylesheets
    createStylesheet: function createStylesheet() {
        var style = void 0;

        style = document.createElement('style');

        // WebKit hack :(
        style.appendChild(document.createTextNode(""));

        // Add the <style> element to the page
        document.head.appendChild(style);

        return style.sheet;
    },

    getTreeHeight: function getTreeHeight() {
        return this.getAbsoluteBoundingRect(this.getContainer()).height;
    },

    /**
    * Used when a state is already set and we need to change it
    */
    updateState: function updateState(data) {
        var _this = this;

        var oldState = void 0,
            newState = void 0,
            oldActiveEl = void 0,
            newStateSuccess = void 0;

        oldState = data.oldState;
        newState = data.newState;
        oldActiveEl = this.getActiveEl();

        // removes container state class
        if (oldState.type !== newState.type) {
            this.removeContainerState(oldState);
        }
        if (oldState.id !== newState.id) {
            // get active element
            oldActiveEl.classList.remove(this.activeClassName);
            // animate out
            oldActiveEl.classList.add('cme-tree__' + oldState.type + '--animate-out');
            setTimeout(function () {
                oldActiveEl.classList.remove('cme-tree__' + oldState.type + '--animate-out');
            }, this.animationLength);
        }

        // activate new state
        // data.newState.id
        newStateSuccess = this.setState(data.newState);

        // delay the updateViewHeight if we're switching to/from the 'overview' since there's a lot that happens height/transform wise in that time
        if (oldState.type === 'overview' || newState.type === 'overview') {
            setTimeout(function () {
                _this.updateViewHeight(newState);
            }, this.animationLength);
        } else {
            // don't worry about delaying
            this.updateViewHeight(newState);
        }

        // update focusable elements
        this.updateFocusable(oldState, newState);

        // revert back to old state
        if (newStateSuccess === false) {
            this.setState(oldState);
            this.updateViewHeight(oldState);
        }
    },

    setState: function setState(state, init) {
        var activeEl = void 0;
        this.addContainerState(state);
        // set active element
        activeEl = this.setActiveEl(state);

        // if set active fails... what to do?
        if (activeEl === false) {
            return false;
        }
        // validated, so set the new class!
        activeEl.classList.add(this.activeClassName);
        // we don't want to add focus on init

        if (init !== true) {
            // focus it
            // don't add focus until after the event has finished animating.
            // This prevents a big jump on the page when focus an element before it arrives into view
            // also it's a big performance hit (30ms) when focusing an element outside of the view. it makes the browser think it needs to repaint everything.
            window.setTimeout(function () {
                activeEl.focus();
            }, this.animationLength);
        } else {
            // if it's the first ever load, we need to remove focus
            if (state.type !== 'overview') {
                // if init is true && state= doesn't equal tree/overview, then remove all focus as a starting point
                this.removeAllFocusable();
            }
        }
        return true;
    },

    calculateQuestionsSize: function calculateQuestionsSize() {
        var questions = void 0,
            bounds = void 0;
        questions = this.getQuestions();
        for (var i = 0; i < questions.length; i++) {
            questions[i].data.bounds = {
                offsetHeight: questions[i].offsetHeight,
                offsetTop: questions[i].offsetTop
            };
        }
    },

    calculateEndsSize: function calculateEndsSize() {
        var ends = void 0,
            bounds = void 0;
        ends = this.getEnds();
        for (var i = 0; i < ends.length; i++) {
            ends[i].data.bounds = {
                offsetHeight: ends[i].offsetHeight,
                offsetTop: ends[i].offsetTop
            };
        }
    },

    checkEndPositionAccuracy: function checkEndPositionAccuracy() {
        var ends = void 0,
            end = void 0,
            accurate = false;

        // get the last end
        ends = this.getEnds();
        end = ends[ends.length - 1];

        // check if the end positions match the stored data
        if (end.data.bounds !== undefined && end.data.bounds.offsetHeight === end.offsetHeight && end.data.bounds.offsetTop === end.offsetTop) {
            accurate = true;
        }

        return accurate;
    },

    updateViewHeight: function updateViewHeight(state) {
        var _this2 = this;

        var activeEl = void 0,
            cPanel = void 0,
            cWindow = void 0,
            cWindowHeight = void 0,
            cPanelTransform = void 0,
            questionOffsetTop = void 0,
            groupsHeight = void 0;

        activeEl = this.getActiveEl();
        // if we're on a question, set the transform origin on the wrapper
        cPanel = this.getContentPane();
        cWindow = this.getContentWindow();

        if (state.type === 'question' || state.type === 'end') {

            // content window is what you can see and the pane is the full height element with transform origin applied on it. Think of a big piece of paper (the panel) and it's covered up except for a small window that you're looking through

            // if we change the margins based on a state change here, it'll mess up
            // the calculation on offsetTop. If we're going to do that, we need to
            // delay the margin change until after the animation has completed

            // Also, offsetTop only works to the next RELATIVELY positioned element, so the activeEl container (cPanel) must be set position relative
            // check to make sure we have sizes
            if (activeEl.data.bounds === undefined) {
                // calculate both for reference
                this.calculateQuestionsSize();
                this.calculateEndsSize();
            }

            questionOffsetTop = -activeEl.data.bounds.offsetTop;
            cPanelTransform = 'translate3d(0,' + questionOffsetTop + 'px,0)';
            // set window scroll position to 0 (helps on mobile to center the question correctly)
            // cWindow.scrollTop = 0
            // set a height
            cWindowHeight = activeEl.data.bounds.offsetHeight;

            // do an async check to see if we need to recalculate the positions

            // This doesn't seem necessary since I had tried to use this to fix
            setTimeout(function () {
                console.log('resize check');

                // check the position of the first end state
                if (_this2.checkEndPositionAccuracy() !== true) {
                    // pass true to force the resize
                    _this2.resize(true);
                }
            }, 200);

            setTimeout(function () {
                // this is generally wrong on iOS safari when transitioning a long distance
                // like from 1st question to an end state.
                // it will be 0 on desktop browsers though.
                // console.log('cwindowScrollTop', cWindow.scrollTop)
                // in order to fix this, set it to scrollTop = 0 at the end of the transition time
                cWindow.scrollTop = 0;
            }, this.animationLength + 100);
        } else if (state.type === 'intro') {
            // kicks off the process for calculating necesary group data if necessary
            this.checkForGroupsCalc();
        }
        // if the state type is tree, set a height on the window and distribute the groups accordingly
        else if (state.type === 'overview') {
                // kicks off the process for calculating necesary group data if necessary
                this.checkForGroupsCalc();
                // get the groups height
                groupsHeight = this.getGroupsHeight();

                this.displayArrowDirection();
                // make sure the height of the groups isn't taller than the cWindowHeight
                cWindowHeight = cPanel.getBoundingClientRect().height;

                if (cWindowHeight < groupsHeight) {
                    cWindowHeight = groupsHeight;
                }

                // reset the transform origin
                cPanelTransform = '';
            } else {
                cPanelTransform = '';
            }

        // set the transforms
        // cWindow.style.height = cWindowHeight+'px'
        // cPanel.style.transform = cPanelTransform
        cWindow.setAttribute('style', 'height: ' + cWindowHeight + 'px' + this.getCSSPriority() + ';');
        this.setTransform(cPanel, cPanelTransform);
        // emit to let everyone know we finished updating the height
        this.emit('viewChange', 'viewHeightUpdate', { cWindowHeight: cWindowHeight, questionOffsetTop: questionOffsetTop });
    },

    addContainerState: function addContainerState(state) {
        // set the state type on the container
        var treeEl = this.getTreeEl();
        var classes = treeEl.classList;
        // if the class isn't already there, add it
        if (!classes.contains('cme-tree__state--' + state.type)) {
            classes.add('cme-tree__state--' + state.type);
        }
    },

    removeContainerState: function removeContainerState(state) {
        // set the state type on the container
        var treeEl = this.getTreeEl();
        treeEl.classList.remove('cme-tree__state--' + state.type);

        // add animation classes
        treeEl.classList.add('cme-tree__state--animate-out--' + state.type);
        window.setTimeout(function () {
            treeEl.classList.remove('cme-tree__state--animate-out--' + state.type);
        }, this.animationLength);
    },

    keydown: function keydown(event) {
        // check to see if it's a spacebar or enter keypress
        // 13 = 'Enter'
        // 32 = 'Space'
        // 9 = 'Tab'
        if (event.keyCode === 13 || event.keyCode === 32) {
            // call the click
            this.click(event, { updatedBy: 'keypress', observer: 'TreeView' });
        }
    },

    updateFocusable: function updateFocusable(oldState, newState) {
        var oldFocusedEl = void 0,
            newFocusedEl = void 0;

        // intro & old tree get everything removed
        if (newState.type === 'intro' || oldState.type === 'overview') {
            // remove focus from everything
            this.removeAllFocusable();
        }

        // questions & ends
        if (oldState.type === 'question' || oldState.type === 'end') {
            // set tabindex -1 on focusable options

            oldFocusedEl = this.getDestination(oldState.id);
            this.removeFocusable(oldFocusedEl);
        }

        // we need to add all focusable if in tree state
        if (newState.type === 'overview') {
            // remove focus from everything
            this.addAllFocusable();
        }

        if (newState.type === 'question' || newState.type === 'end') {
            // set tabindex -1 on focusable options
            newFocusedEl = this.getDestination(newState.id);
            this.addFocusable(newFocusedEl);
        }
    },

    // parentEl
    // sets them all 'a' els to tabindex = -1
    removeFocusable: function removeFocusable(parentEl) {
        var focusable = void 0;

        focusable = parentEl.querySelectorAll('a');
        for (var i = 0; i < focusable.length; i++) {
            focusable[i].tabIndex = -1;
        }
    },

    // parentEl
    // sets them all 'a' els to tabindex = -1
    addFocusable: function addFocusable(parentEl) {
        var focusable = void 0;
        focusable = parentEl.querySelectorAll('a');
        for (var i = 0; i < focusable.length; i++) {
            focusable[i].tabIndex = 0;
        }
    },

    addAllFocusable: function addAllFocusable() {
        var focusable = void 0;

        // combine them into one array
        focusable = document.querySelectorAll('.cme-tree__question, .cme-tree__end');

        for (var i = 0; i < focusable.length; i++) {
            this.addFocusable(focusable[i]);
        }
    },

    removeAllFocusable: function removeAllFocusable() {
        var focusable = void 0;
        // combine them into one array
        focusable = document.querySelectorAll('.cme-tree__question, .cme-tree__end');
        for (var i = 0; i < focusable.length; i++) {
            this.removeFocusable(focusable[i]);
        }
    },

    click: function click(event, extraData) {
        var el = void 0,
            Tree = void 0,
            state = void 0;
        if (extraData === undefined) {
            extraData = { updatedBy: 'click', observer: 'TreeView' };
        }
        el = event.target;
        // check if it's a click on the parent tree (which we don't care about)
        if (el !== event.currentTarget) {

            // we're not on an A, but try to find one
            if (el.nodeName !== 'A') {
                // try to find one
                el = this.findAncestor(el, 'A');
            }
            // now continue on with checking if we found one or not.
            if (el.nodeName === 'A' && el.data !== undefined) {
                // check for el.data
                // if we're in the overview state, don't switch the state (unless they click the start button), just go to that question on the page
                if (this.getTree().getState().type !== 'overview' || this.getTree().getState().type === 'overview' && el.data.type === 'start') {
                    event.preventDefault();
                    this.emit('update', 'state', Object.assign(el.data, extraData));
                } else {
                    // in tree state
                    event.preventDefault();
                    // focus that question/end state to show them where it is
                    var destinationEl = this.getDestination(el.data.destinationID);
                    destinationEl.focus();
                    // emit that it happened to the other observers (like TreeInteraction so we can save the interaction)
                    this.emit('overviewOptionInteraction', 'overviewOptionInteraction', el.data);
                }
            }

            // They're clicking on a question. Don't add focus
            else if (el.nodeName === 'SECTION') {
                    event.preventDefault();
                    // if it's a click on a question, it will have recieved focus, so we need to unset the focus. Move it to the previously focused element?
                    /*Tree = this.getTree()
                    state = Tree.getState();
                    // make sure we're not curently on this question
                    if((el.data.type === 'question' && state.id !== el.data.questionID)  || state.type !== 'question' ) {
                        this.emit('update', 'state', el.data)
                    }*/
                }
        }
        event.stopPropagation();
    },

    // pass forceResize = true to skip any validation
    resize: function resize(forceResize) {
        var _this3 = this;

        // iOS fires a resize event when you switch scroll direction vertically (like, scrolling up and then back down) when the url address bar expands/retracts. We don't actually need to do this costly resize on each of those, so we'll do our questionAccuracty check.
        if (forceResize !== true) {
            // check the value of our stored window width  vs the new window width
            if (this.windowWidth === window.innerWidth) {
                // console.log('window is still the same width')
                // they match, so skip this resize.
                // Remember, you can bypass this check by passing forceResize = true to resize
                // this.resize(true)
                return false;
            }
        }

        // recalculate heights on resize
        // debounce it, kinda, by waiting 100ms until they're done so we don't fire this constantly
        this.resizeTimeout = null;
        if (!this.resizeTimeout) {
            this.resizeTimeout = setTimeout(function () {
                // update the question and end sizes
                _this3.calculateQuestionsSize();
                _this3.calculateEndsSize();
                // update the group sizes
                _this3.calculateGroups();
                // update the heights
                _this3.updateViewHeight(_this3.getTree().getState());
                // update the windowWidth var to match what we just set it to
                _this3.windowWidth = window.innerWidth;
            }, 450);
        }
    },

    /**
    * Let our Tree know about thangs.
    */
    emit: function emit(action, item, data) {
        var Tree = this.getTree();
        switch (action) {
            case 'update':
                // this is usually Tree.update('state', dataAboutNewState)
                Tree.update(item, data);
                break;
            case 'ready':
                // tell the Tree to let all the other observers know that the view is ready
                Tree.message(item, data);
                break;
            case 'viewChange':
                Tree.message(item, data);
                break;
            case 'treeHeight':
                Tree.message(item, data);
                break;
            case 'overviewOptionInteraction':
                // item = overviewOptionInteraction
                // data = optionID clicked and resulting destination data
                Tree.message(item, data);
                break;
        }
    },

    /**
    * Bind tree data to the element for easy access to data when we need it
    */
    bindAllData: function bindAllData() {
        var Tree = this.getTree();
        var elTypes = ['question', 'start', 'end', 'group'];
        // bind a quick empty object for our treeEl so we can add data to it as needed
        var treeEl = this.getTreeEl();
        if (!treeEl.hasOwnProperty('data')) {
            treeEl.data = {};
        }
        // loop through the data and find the corresponding elements
        for (var i = 0; i < elTypes.length; i++) {
            // get the data: ex {questionID: 2, order: 2, etc}
            var elData = Tree.getDataByType(elTypes[i]);
            for (var j = 0; j < elData.length; j++) {
                // get the id, ex. the id value '2'
                // this is like saying: getDataByType('question').questionID
                var ID = elData[j]['ID'];
                // find the element in the DOM
                var el = document.getElementById('cme-tree__el--' + ID);

                // bind the data
                this.bindDOMData(elData[j], el, elTypes[i]);

                // see if we're working with a question or end
                switch (elTypes[i]) {
                    case 'question':
                        var options = elData[j].options;
                        // loop through the options
                        for (var k = 0; k < options.length; k++) {
                            // get option el
                            var optionEl = document.getElementById('cme-tree__el--' + options[k].ID);
                            // bind the data
                            this.bindDOMData(options[k], optionEl, 'option');
                        }
                        break;

                    case 'end':
                        // assign data to restart button
                        // restart button
                        var restartEl = document.getElementById('cme-tree__restart--' + ID);
                        this.bindDOMData(elData[j], restartEl, 'restart');
                        // go to overview button
                        var overviewEl = document.getElementById('cme-tree__overview--' + ID);
                        this.bindDOMData(elData[j], overviewEl, 'overview');
                        break;
                }
            }
        }
    },

    bindDOMData: function bindDOMData(data, element, type) {
        // we can only add this once, not overwrite existing ones
        if (element.data === undefined) {
            // clone the data so we're not giving direct access to the _data attribute
            var clonedObj = void 0;
            // building the cloned data manually so:
            // 1. it's soooo much faster. Like, exponentionally as the tree grows
            // 2. we're not recording a bunch of data we don't need
            //    (like "content", "title", etc)
            // 3. We can add data that we do need (like "type")
            switch (type) {
                case 'start':
                    clonedObj = {
                        ID: data.ID,
                        type: 'start'
                    };
                    break;

                case 'group':
                    clonedObj = {
                        ID: data.ID,
                        type: 'group',
                        order: data.order
                    };
                    break;

                case 'question':

                    clonedObj = {
                        ID: data.ID,
                        type: 'question',
                        order: data.order,
                        groupID: this.getTree().getGroupIDByQuestion(data.ID)
                    };
                    clonedObj.options = [];
                    // add options
                    for (var i = 0; i < data.options.length; i++) {
                        clonedObj.options.push(data.options[i].ID);
                    }
                    break;

                case 'option':
                    clonedObj = {
                        ID: data.ID,
                        type: 'option',
                        order: data.order,
                        destinationID: data.destinationID,
                        destinationType: data.destinationType
                    };
                    break;

                case 'end':
                    clonedObj = {
                        ID: data.ID,
                        type: 'end',
                        order: data.order
                    };
                    break;

                case 'restart':
                    clonedObj = {
                        ID: data.ID,
                        type: 'restart'
                    };
                    break;
                case 'overview':
                    clonedObj = {
                        overviewID: data.ID,
                        type: 'overview'
                    };
                    break;
            }
            // dynamically building the structure was quite slow, so we're manually doing it for speed on this kinda expensive operation
            // bind the data to the DOM
            element.data = clonedObj;
            return element.data;
        } else {
            // can't overwrite data, so return false
            return false;
        }
    },

    /*
    @method getAbsoluteBoundingRect
    @param {HTMLElement} el HTML element.
    @return {Object} Absolute bounding rect for _el_.
    */
    getAbsoluteBoundingRect: function getAbsoluteBoundingRect(el) {
        var doc = document,
            win = window,
            body = doc.body,


        // pageXOffset and pageYOffset work everywhere except IE <9.
        offsetX = win.pageXOffset !== undefined ? win.pageXOffset : (doc.documentElement || body.parentNode || body).scrollLeft,
            offsetY = win.pageYOffset !== undefined ? win.pageYOffset : (doc.documentElement || body.parentNode || body).scrollTop,
            rect = el.getBoundingClientRect();

        if (el !== body) {
            var parent = el.parentNode;

            // The element's rect will be affected by the scroll positions of
            // *all* of its scrollable parents, not just the window, so we have
            // to walk up the tree and collect every scroll offset. Good times.
            while (parent !== body) {
                offsetX += parent.scrollLeft;
                offsetY += parent.scrollTop;
                parent = parent.parentNode;
            }
        }

        return {
            bottom: rect.bottom + offsetY,
            height: rect.height,
            left: rect.left + offsetX,
            right: rect.right + offsetX,
            top: rect.top + offsetY,
            width: rect.width
        };
    },

    // calculate bind the group sizes to the DOM
    calculateGroups: function calculateGroups() {
        var groups = void 0,
            groupsBound = void 0;

        // get the groups
        groups = this.getGroups();

        for (var i = 0; i < groups.length; i++) {
            groups[i].data.size = {
                width: groups[i].offsetWidth,
                height: groups[i].offsetHeight
            };
        }

        // also calculate groupsSizes to get set on treeEl
        this.calculateGroupsSize();
        // creates the styles we need
        this.addGroupStyles();
    },

    // write group transforms to a dynamic stylesheet to improve perf.
    // rebuilds on resize
    addGroupStyles: function addGroupStyles() {
        var groups = void 0,
            groupStyles = void 0,
            groupsOffsetLeft = void 0,
            treeEl = void 0,
            cssPriority = void 0;

        // get the groups
        groups = this.getGroups();
        // get the treeEl for our groupsOffsetLeft data
        treeEl = this.getTreeEl();
        groupsOffsetLeft = treeEl.data.groupsOffsetLeft;
        cssPriority = this.getCSSPriority();

        for (var i = 0; i < groups.length; i++) {
            this.addStylesheetRule('.cme-tree__state--overview #' + groups[i].id + ', .cme-tree__state--intro #' + groups[i].id, [['transform', 'translate3d(' + groupsOffsetLeft + 'px,' + groups[i].data.offsetTop + 'px, 0)' + cssPriority + '']]);
        }
    },

    // TODO: Let there be more than one rule passed at a time
    // rules = array of arrays where those arrays are properties [key, value]
    addStylesheetRule: function addStylesheetRule(selector, rules) {
        var styles = void 0,
            insertAt = void 0;
        insertAt = null;
        styles = this.getStylesheet();
        // check if the rule exists
        for (var i = 0; i < styles.cssRules.length; i++) {
            // check if this selector already exists
            if (styles.cssRules[i].selectorText === selector) {
                insertAt = i;
                break;
            }
        }

        // If it couldn't be found, create the rule
        if (insertAt === null) {
            // it doesn't exist, so create it
            // Insert CSS Rule
            insertAt = styles.cssRules.length;
            // add the first rule as a placeholder
            styles.insertRule(selector + '{' + rules[0][0] + ': ' + rules[0][1] + '}', insertAt);
        }

        // now add all the rules
        for (var _i = 0; _i < rules.length; _i++) {
            styles.cssRules[insertAt].style[rules[_i][0]] = rules[_i][1];
        }
    },

    // check if we need to calclate the groups
    checkForGroupsCalc: function checkForGroupsCalc() {
        var groups = this.getGroups();

        // first time it gets called, calculate heights
        if (groups[0].data.size === undefined) {
            this.calculateGroups();
        }
    },

    calculateGroupsSize: function calculateGroupsSize() {
        var groups = void 0,
            groupSize = void 0,
            groupsOffsetLeft = void 0,
            groupsHeight = void 0,
            groupsWidth = void 0,
            treeEl = void 0;

        groups = this.getGroups();
        groupsHeight = 0;
        // batch style changes for faster painting
        for (var i = 0; i < groups.length; i++) {
            groupSize = groups[i].data.size;

            if (i === 0) {
                groupsWidth = groupSize.width * this.scaledSize;
                if (groupsWidth < 350) {
                    groupsOffsetLeft = groupsWidth * 1.5 + 30;
                } else {
                    groupsOffsetLeft = groupsWidth * 1.5 + 50;
                }
            }

            // groups[i].style.transform = 'translate3d('+groupsWidth+'px, '+groupsHeight + 'px, 0)'
            // add the offsetTop for the tree state
            groups[i].data.offsetTop = groupsHeight;
            // add in the height of this one
            // an extra 110 seems to be about right for spacing
            groupsHeight = groupsHeight + groupSize.height + 110;
        }

        // write the groupsOffsetLeft and groupsHeight to our tree el
        treeEl = this.getTreeEl();
        treeEl.data.groupsOffsetLeft = groupsOffsetLeft;
        treeEl.data.groupsHeight = groupsHeight;

        return groupsHeight;
    },

    getGroupsHeight: function getGroupsHeight() {
        var treeEl = void 0,
            groupsHeight = void 0;

        treeEl = this.getTreeEl();

        // check if the key exists, if not, add it
        if (!treeEl.data.hasOwnProperty('groupsHeight')) {
            this.calculateGroupsSize();
        }

        return treeEl.data.groupsHeight;
    },

    // https://gist.github.com/conorbuck/2606166
    // p1 and p2 need x and y cordinates
    // p1 = {x: 12, y: 15}
    lineAngle: function lineAngle(p1, p2) {
        var degrees = void 0;
        // angle in radians
        // let angleRadians = Math.atan2(p2.y - p1.y, p2.x - p1.x);
        // angle in degrees
        degrees = Math.atan2(p2.y - p1.y, p2.x - p1.x) * 180 / Math.PI;
        if (Math.sign(degrees) === -1) {
            degrees = degrees + 360;
        }
        return degrees;
    },

    displayArrowDirection: function displayArrowDirection() {
        var questions = void 0,
            questionGroupID = void 0,
            destination = void 0,
            destinationPosition = void 0,
            destinationCoords = void 0,
            destinationGroupID = void 0,
            options = void 0,
            arrow = void 0,
            arrowPosition = void 0,
            arrowAngle = void 0,
            arrowCoords = void 0,
            arrowAngleNormalized = void 0;

        questions = this.getQuestions();
        // figure out arrow directions
        for (var q = 0; q < questions.length; q++) {

            options = this.getOptions(questions[q]);

            for (var o = 0; o < options.length; o++) {
                if (options[o].data.destinationType === 'question') {
                    // see if the question and option destination are in
                    // the same column.
                    destination = this.getDestination(options[o].data.destinationID);

                    if (questions[q].data.groupID === destination.data.groupID) {
                        // if so, skip it (just use the down arrow)
                        continue;
                    }
                    // ok, they're in different columns, figure out what direction it needs to go
                    arrow = this.getDestinationIcon(options[o].data.ID);

                    arrowPosition = this.getAbsoluteBoundingRect(arrow);
                    destinationPosition = this.getAbsoluteBoundingRect(destination);

                    arrowCoords = { y: arrowPosition.top + arrowPosition.height / 2
                        // we want the top third of the destination
                    };destinationCoords = { y: destinationPosition.top + destinationPosition.height / 2

                        // we're going to an attachment
                    };arrowCoords.x = arrowPosition.left + arrowPosition.width / 2;
                    destinationCoords.x = destinationPosition.left + destinationPosition.width / 2;

                    arrowAngle = this.lineAngle(arrowCoords, destinationCoords);

                    // adjust the arrow angle to be between 0 and 360 and


                    // now normalize it for 0 = pointing to right
                    arrowAngleNormalized = 360 - arrowAngle;
                    // arrow angle is between 70 and 120
                    if (80 < arrowAngleNormalized && arrowAngleNormalized < 90) {
                        this.templateArrowUpRight(arrow);
                    } else if (90 < arrowAngleNormalized && arrowAngleNormalized < 100) {
                        this.templateArrowUpLeft(arrow);
                    }
                    // arrow angle is between 0-20 or 340-360
                    else if (arrowAngleNormalized < 10 || 350 < arrowAngleNormalized) {
                            // straight to the right (since we start with a down arrow)
                            this.templateArrow(arrow, 'arrow');
                            this.setTransform(arrow, 'rotate(180deg)');
                        } else if (170 < arrowAngleNormalized && arrowAngleNormalized < 190) {
                            // straight to the left (since we start with a down arrow)
                            this.templateArrow(arrow, 'arrow');
                            this.setTransform(arrow, 'rotate(-180deg)');
                        }
                        // down and to the right
                        else if (270 < arrowAngleNormalized && arrowAngleNormalized < 280) {
                                // straight to the left (since we start with a down arrow)
                                this.templateArrowDownRight(arrow);
                            } else if (260 < arrowAngleNormalized && arrowAngleNormalized < 270) {
                                // straight to the left (since we start with a down arrow)
                                this.templateArrowDownLeft(arrow);
                            } else {
                                this.templateArrow(arrow, 'arrow');
                                this.setTransform(arrow, 'rotate(' + arrowAngle + 'deg)');
                            }
                }
            }
        }
    },

    templateArrowUpRight: function templateArrowUpRight(svg) {
        this.templateArrow(svg, 'arrow-turn');
        this.setTransform(svg, 'rotateX(-180deg)');
    },
    templateArrowUpLeft: function templateArrowUpLeft(svg) {
        this.templateArrow(svg, 'arrow-turn');
        this.setTransform(svg, 'rotateX(180deg)');
    },
    templateArrowDownRight: function templateArrowDownRight(svg) {
        this.templateArrow(svg, 'arrow-turn');
        this.setTransform(svg, 'rotateX(0deg)');
    },
    templateArrowDownLeft: function templateArrowDownLeft(svg) {
        this.templateArrow(svg, 'arrow-turn');
        this.setTransform(svg, 'rotateX(-180deg)');
    },
    templateArrow: function templateArrow(svg, iconName) {
        // Use childNodes for IE Edge
        svg.childNodes[0].setAttribute('xlink:href', '#icon-' + iconName);

        return svg;
    },
    findAncestor: function findAncestor(el, theNodeName) {
        var i = 0;
        // only check a few elements so we don't go too crazy
        while (el.nodeName != theNodeName && i < 4) {
            el = el.parentElement;
            i++;
        }

        return el;
    },


    setTransform: function setTransform(element, transform) {
        element.setAttribute('style', 'transform: ' + transform + this.getCSSPriority() + ';');
    }
};
'use strict';

Handlebars.registerHelper('environment', function (options) {
    return 'has-js';
});

Handlebars.registerHelper('groupStart', function (questionID, groups, options) {
    // find the group
    for (var i = 0; i < groups.length; i++) {
        // check if it's the first in the question order
        if (groups[i].questions[0] === questionID) {
            // pass the values we'll need in the template
            return options.fn({ groupID: groups[i].ID, groupTitle: groups[i].title });
        }
    }
    return '';
});

Handlebars.registerHelper('groupEnd', function (questionID, groups, options) {
    // find the group
    for (var i = 0; i < groups.length; i++) {
        var questions = groups[i].questions;
        // check if it's the last in the question order
        if (questions[questions.length - 1] === questionID) {
            return options.fn(this);
        }
    }
    return '';
});

Handlebars.registerHelper('elNumber', function (el_order) {

    // for the arrow direction we could calculate the position on the tree-view and set an angle so the arrow points towards the destination...
    return parseInt(el_order) + 1;
});

Handlebars.registerHelper('destination', function (destinationID, destinationType, optionID, questionIndex, options) {
    var data = void 0,
        destination = void 0,
        destinationNumber = void 0,
        destinationTitle = void 0,
        destinationIcon = void 0,
        i = void 0;
    // set data (either questions or ends most likely) from main data tree
    data = options.data.root[destinationType + 's'];
    i = 0;
    if (destinationType === 'question') {
        // start it at the questionIndex.
        // An option will never go backwards, so we don't care
        // about the previous ones
        i = questionIndex;
    }

    // find the destination
    for (i; i < data.length; i++) {
        if (data[i]['ID'] === destinationID) {
            destination = data[i];
            if (destinationType === 'question') {
                destinationNumber = i + 1;
                destinationTitle = 'Question ' + destinationNumber;
                destinationIcon = 'arrow';
            } else {
                destinationTitle = data[i].title;
                destinationIcon = '';
            }

            break;
        }
    }

    // for the arrow direction we could calculate the position on the tree-view and set an angle so the arrow points towards the destination...
    return options.fn({
        destinationTitle: destinationTitle,
        destinationType: destinationType,
        destinationIcon: destinationIcon,
        optionID: optionID
    });
});