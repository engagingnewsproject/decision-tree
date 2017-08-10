'use strict';

Handlebars.registerHelper('environment', function (options) {
    return 'has-js';
});

Handlebars.registerHelper('group_start', function (question_id, group_id, groups, options) {
    // find the group
    for (var i = 0; i < groups.length; i++) {
        if (groups[i].group_id === group_id) {
            // check if it's the first in the question order
            if (groups[i].questions[0] === question_id) {
                // pass the values we'll need in the template
                return options.fn({ group_id: groups[i].group_id, group_title: groups[i].title });
            } else {
                return '';
            }
        }
    }
    return '';
});

Handlebars.registerHelper('group_end', function (question_id, group_id, groups, options) {
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
    return '';
});
'use strict';

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

function TreeHistoryView(options) {
    var _TreeHistory, _container, _list;

    if (_typeof(options.container) !== 'object') {
        console.error('Tree History View container must be a valid object. Try `container: document.getElementById(your-id)`.');
        return false;
    }

    if (_typeof(options.TreeHistory) !== 'object') {
        console.error('Tree History must be a valid object.');
        return false;
    }

    // getters
    this.getContainer = function () {
        return _container;
    };
    this.getList = function () {
        return _list;
    };
    this.getTreeHistory = function () {
        return _TreeHistory;
    };

    // setters
    this.setContainer = function (container) {
        // only let it get set once
        if (_container === undefined) {
            var historyView = this.createView();
            // place it in the passed container
            container.insertBefore(historyView, container.firstElementChild);
            // set our built div as the container
            _container = container.firstElementChild;
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

    var _setTreeHistory = function _setTreeHistory(TreeHistory) {
        _TreeHistory = TreeHistory;
    };

    _setTreeHistory(options.TreeHistory);
    this.setContainer(options.container);
    console.log(this.getTreeHistory().getHistory());
    this.templateRender(this.getTreeHistory().getHistory(), this.getTreeHistory().getCurrentIndex());
    // add click listener on container
    _container.addEventListener("click", this.click.bind(this));
    _container.addEventListener("keydown", this.keydown.bind(this));
}

TreeHistoryView.prototype = {
    constructor: TreeHistoryView,

    on: function on(action, data) {
        console.log('TreeHistoryView "on" ' + action);
        switch (action) {
            case 'historyUpdate':
                // data will be the tree itself
                this.updateHistory(data);
                break;
            case 'historyIndexUpdate':
                this.updateHistoryIndex(data);
                break;
        }
    },

    click: function click() {},

    keydown: function keydown() {},

    createView: function createView() {
        var elem = void 0;

        elem = document.createElement('aside');
        elem.classList.add('enp-tree__history');

        return elem;
    },

    updateHistory: function updateHistory(history) {
        console.log('history update');
    },

    updateHistoryIndex: function updateHistoryIndex(index) {
        console.log('history index update');
    },

    // TODO: template it with Handlebars? Is that overkill? It should be a very simple template. BUUUUT, we already have the templating engine built so... ?
    // TODO: Bind history data to an element so we know if we need to update it or not
    // TODO: Elements are being added/removed. Check each element to see if its element.data matches the history data in order. If one doesn't match, rerender from that point on.
    templateRender: function templateRender(history, currentIndex) {
        var container = void 0,
            list = void 0,
            current = void 0;
        console.log('history');
        console.log(history);
        container = this.getContainer();
        container.appendChild(this.templateUl());
        // set the list as the _list var
        this.setList(container.firstElementChild);
        list = this.getList();

        for (var i = 0; i < history.length; i++) {
            // generate list data and append to item
            current = false;
            if (i === currentIndex) {
                current = true;
            }
            list.appendChild(templateLi(history[i], i, current));
        }
    },

    templateUpdate: function templateUpdate(history) {},

    templateUl: function templateUl() {
        var ul = document.createElement('ul');
        ul.classList.add('enp-tree__history-list');
        return ul;
    },

    templateLi: function templateLi(data, index) {
        var li = document.createElement('li');
        li.classList.add('enp-tree__history-list-item');
        li.innerHTML = index + 1;
        li.data = data;
        return li;
    }
};
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
        console.log(_history);
    };

    var _saveCurrentIndex = function _saveCurrentIndex(currentIndex) {
        _currentIndex = currentIndex;
        localStorage.setItem(_currentIndexStorageName, JSON.stringify(_currentIndex));
        console.log(_currentIndex);
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
        // create as an empty array
        var history = [];
        var currentIndex = null;

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
        var treeID = void 0;

        // get the tree id
        treeID = this.getTree().getTreeID();

        // set global storage string
        _historyStorageName = 'treeHistory__' + treeID;
        _currentIndexStorageName = 'treeHistoryIndex__' + treeID;

        // if localStorage is empty, create it
        if (localStorage.getItem(_historyStorageName) === null) {
            // sets a blank history and index
            this.clearHistory();
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
        this.setTree(Tree);
        this.init();
        this.forceCurrentState();
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

        // ok, delete away!
        // delete all history after the passed index
        history = this.getHistory().splice(index);

        setHistory(history);
    },

    getCurrentState: function getCurrentState() {
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
        var state = void 0;
        console.log('Tree History Emit: ' + action);
        console.log(data);
        var Tree = this.getTree();
        switch (action) {
            case 'update':
                // this is usually Tree.update('state', dataAboutNewState)
                //  our format is data {type: 'question', id: #}, but the
                // tree needs it in format {type: 'question', question_id: id}
                state = { type: data.type };
                state[data.type + '_id'] = data.id;

                Tree.update(item, state);
                break;
        }
    },

    // tell the parent tree to update to our current state
    forceCurrentState: function forceCurrentState() {
        var currentIndex = void 0,
            history = void 0;

        // TODO: update the Tree state to match the History
        // if we have a currentIndex and state, then pass it to the main tree to set the state to reflect our view
        currentIndex = this.getCurrentIndex();
        history = this.getHistory();

        if (this.currentIndex !== null && history[currentIndex] !== undefined) {
            this.emit('update', 'state', history[currentIndex]);
        }
    },

    /**
    * Listen to parent Tree's emitted actions and handle accordingly
    */
    on: function on(action, data) {
        console.log('TreeHistory "on" ' + action);
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
                var container = treeView.getContentWindow();
                var historyView = new TreeHistoryView({ TreeHistory: this, container: container });
                // add this to the observers
                this.addObserver(historyView);
        }

        // notify observers of these changes
        this.notifyObservers(action, data);
    },

    // updates the history state
    update: function update(states) {
        var newState = void 0,
            oldState = void 0,
            history = void 0,
            questions = void 0,
            findNewStateIndex = void 0,
            findOldStateIndex = void 0,
            stateToAdd = void 0,
            Tree = void 0;

        // data contains old state and new state
        newState = states.newState;
        oldState = states.oldState;
        history = this.getHistory();
        console.log('new state');

        // check if we're resuming where we left off. ie, the updated state will match where we're at in the state history
        if (newState === this.getCurrentState()) {
            // do nothing! we're good
            return;
        }

        // see if we need to add our resume button in
        if (newState.type === 'tree' && history.currentIndex !== null) {
            // TODO: add resume button next to Start button
            return;
        }

        // OK, we'll probably have to do something now
        if (newState.type === 'question') {
            Tree = this.getTree();
            questions = Tree.getQuestions();
            // try to find the new state in our history
            findNewStateIndex = this.getIndexBy(history, 'id', newState.id);
            // try to find the old state in our history
            findOldStateIndex = this.getIndexBy(history, 'id', oldState.id);

            // if the old state is Tree or End and the current question is the first question, then they're just starting over, so let's clear the history (if any) and set the first question
            if ((oldState.type === 'tree' || oldState.type === 'end') && newState.id === questions[0].question_id) {
                // clear the history
                this.clearHistory();
                // set it as our var to add
                stateToAdd = newState;
            }

            // If we can find the new state index in our history,
            // then we don't want to ADD it to the history, we just want to
            // change our currentIndex to match where they are.
            // EX. Someone clicked the "back" or "forward" buttons.
            // They're not adding history, they're just changing where they are
            else if (findNewStateIndex !== undefined) {
                    // set the currentIndex accordingly
                    this.setCurrentIndex(findNewStateIndex);
                }

                // try to find the previous state. is it the last one in the
                // current state tree?
                // if not, delete any history after the previous state.
                // They've gone rogue by going back in history and
                // then chose a new path
                else if (findOldStateIndex !== undefined && findOldStateIndex !== history.length - 1) {
                        // delete anything after this point, because they've changed their state history
                        // we don't want to delete one by one because:
                        // 1. we won't allow them to do that
                        // 2. it'll be a lot slower to delete one by one
                        this.deleteHistoryAfter(findOldStateIndex + 1);

                        // add our new history
                        // set it as our var to add
                        stateToAdd = newState;
                    } else {
                        // welp, they're just going forwards.
                        // Nothing to do but add the state!
                        stateToAdd = newState;
                    }
        } else if (newState.type === 'end') {
            stateToAdd = newState;
        }

        // see if there's anything to add
        if ((typeof stateToAdd === 'undefined' ? 'undefined' : _typeof(stateToAdd)) === 'object' && stateToAdd !== undefined) {
            this.addHistory(stateToAdd);
            // set the new current index
            this.setCurrentIndex(this.getHistory().length - 1);
        }
    },

    /**
    * A little module pattern to manage the view. This way people
    * can overwrite it if they want, and it's all isolated here
    */
    view: function view() {
        this.view = undefined;
        this.viewHistory = undefined;
        this.viewPane = undefined;
        return {
            render: function render() {
                var view = void 0,
                    cPane = void 0;

                this.view = this.getTreeView();

                if (this.view === undefined) {
                    console.error('Could not find a view. Trying again in 700ms');
                }
                this.viewPane = this.view.getContentPane();
                console.log(this.viewPane);
            },

            getTreeView: function getTreeView() {
                var Tree = void 0,
                    observers = void 0;

                Tree = this.getTree();
                observers = Tree.getObservers();
                // find the view
                for (var i = 0; i < observers.length; i++) {
                    if (observers[i].constructor.name === 'TreeView') {
                        return observers[i];
                    }
                }
                return undefined;
            }
        };
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
        console.log('Tree History notifying observers ' + action);
        for (var i = 0; i < this.observers.length; i++) {
            this.observers[i].on(action, data);
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

function TreeView(options) {
    var _Tree, _container, _treeEl, _contentWrap, _contentPane, _activeEl;

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
        return _contentWrap;
    };
    this.getContentPane = function () {
        return _contentPane;
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
        if (_contentWrap === undefined) {
            _contentWrap = document.getElementById('enp-tree__content-window--' + _Tree.getTreeID());
        }
        return _contentWrap;
    };

    this.setContentPane = function () {
        // only let it be set once
        if (_contentPane === undefined) {
            _contentPane = _contentWrap.firstElementChild;
        }
        console.log('set content pane');
        return _contentPane;
    };

    // Pass a state for it to set to be active
    this.setActiveEl = function (state) {
        var el = void 0,
            elId = void 0;

        if (state.type === 'tree') {
            elId = 'enp-tree--' + state.id;
        } else {
            elId = 'enp-tree__el--' + state.id;
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
    this.animationLength = 600;
    // set the el
    _container = options.container;
    // attach event listeners to the tree element with
    // bound `this` so we get our reference to this element
    _container.addEventListener("click", this.click.bind(this));
    _container.addEventListener("keydown", this.keydown.bind(this));

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
        console.log('TreeView "on" ' + action);
        switch (action) {
            case 'ready':
                // data will be the tree itself
                this.build(data);
                break;
            case 'update':
                this.updateState(data);
                break;
        }
    },

    build: function build(Tree) {
        this.setTree(Tree);
        this.render(Tree.getData());
        // set the Tree El
        this.setTreeEl();
        // set the tree wrap
        this.setContentWindow();
        // set the questions wrap
        this.setContentPane();
        // let everyone know the tree view is ready
        // emit that we've finished render
        this.emit('ready', 'viewReady', this);
        // set the current state in the view
        var init = true;
        this.setState(Tree.getState(), init);
    },

    render: function render(data) {
        // render the tree
        var template = window.TreeTemplates.tree;
        var treeHTML = template(data);
        // set the HTML into the passed container
        this.getContainer().innerHTML = treeHTML;

        // bind question data
        this.bindAllData();
    },

    /**
    * Used when a state is already set and we need to change it
    */
    updateState: function updateState(data) {
        var oldState = void 0,
            newState = void 0,
            oldActiveEl = void 0;

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
            oldActiveEl.classList.add('enp-tree__' + oldState.type + '--animate-out');
            window.setTimeout(function () {
                oldActiveEl.classList.remove('enp-tree__' + oldState.type + '--animate-out');
            }, this.animationLength);
        }

        // activate new state
        // data.newState.id
        newState = this.setState(data.newState);

        // revert back to old state
        if (newState === false) {
            this.setState(data.oldState);
        }

        // focus new active elemnt
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
        console.log('TreeView state view is:');
        console.log(state);
        // validated, so set the new class!
        activeEl.classList.add(this.activeClassName);
        // we don't want to add focus on init
        if (init !== true) {
            // focus it
            activeEl.focus();
        }

        // if we're on a question, set the transform origin on the wrapper
        var cPanel = this.getContentPane();
        var cWindow = this.getContentWindow();
        if (state.type === 'question' || state.type === 'end') {

            // this works well if we don't scale it
            // this.getAbsoluteBoundingRect(activeEl).top - this.getAbsoluteBoundingRect(cPanel).top
            // if we change the margins based on a state change here, it'll mess up
            // the calculation on offsetTop. If we're going to do that, we need to
            // delay the margin change until after the animation has completed
            // Also, offsetTop only works to the next RELATIVELY positioned element, so the activeEl container (cPanel) must be set position relative
            this.setTransform(cPanel, 'translate3d(0,' + -activeEl.offsetTop + 'px,0)');
            // set window scroll position to 0 (helps on mobile to center the question correctly)
            cWindow.scrollTop = 0;
            // set a height
            cWindow.style.height = activeEl.offsetHeight + 'px';
        } else {
            this.setTransform(cPanel, '');
        }

        return true;
    },

    addContainerState: function addContainerState(state) {
        // set the state type on the container
        var treeEl = this.getTreeEl();
        var classes = treeEl.classList;
        // if the class isn't already there, add it
        if (!classes.contains('enp-tree__state--' + state.type)) {
            classes.add('enp-tree__state--' + state.type);
        }
        if (state.type === 'tree') {
            // if the state type is tree, set a max-height on the window.
            var cPanel = this.getContentPane();
            var cWindow = this.getContentWindow();
            // content window is what you can see and the pane is the full height element with transform origin applied on it. Think of a big piece of paper (the panel) and it's covered up except for a small window that you're looking through
            cWindow.style.height = cPanel.getBoundingClientRect().height + 'px';
        }
    },

    setTransform: function setTransform(el, prop) {
        el.style.webkitTransform = prop;
        el.style.MozTransform = prop;
        el.style.msTransform = prop;
        el.style.OTransform = prop;
        el.style.transform = prop;
    },

    removeContainerState: function removeContainerState(state) {
        // set the state type on the container
        var treeEl = this.getTreeEl();
        treeEl.classList.remove('enp-tree__state--' + state.type);

        // add animation classes
        treeEl.classList.add('enp-tree__state--animate-out--' + state.type);
        window.setTimeout(function () {
            treeEl.classList.remove('enp-tree__state--animate-out--' + state.type);
        }, this.animationLength);
    },

    keydown: function keydown(event) {
        console.log(event);
        // check to see if it's a spacebar or enter keypress
        // 13 = 'Enter'
        // 32 = 'Space'
        if (event.keyCode === 13 || event.keyCode === 32) {
            // call the click
            this.click(event);
        }

        // TODO: don't allow focus on other questions if question view

        // TODO: don't allow focus on options if in tree state view

    },

    click: function click(event) {
        var el = void 0,
            Tree = void 0,
            state = void 0;
        el = event.target;

        // check if it's a click on the parent tree (which we don't care about)
        if (el !== event.currentTarget) {
            if (el.nodeName === 'A') {
                event.preventDefault();
                this.emit('update', 'state', el.data);
            }

            // Let people click questions (that isn't the current question)
            // to get to the question
            if (el.nodeName === 'SECTION') {
                event.preventDefault();
                Tree = this.getTree();
                state = Tree.getState();
                // make sure we're not curently on this question
                console.log(el.data);
                if (el.data.type === 'question' && state.id !== el.data.question_id || state.type !== 'question') {
                    this.emit('update', 'state', el.data);
                }
            }
        }
        event.stopPropagation();
    },

    /**
    * Let our Tree know about the click.
    */
    emit: function emit(action, item, data) {
        console.log('Tree View Emit: ' + action);
        console.log(data);
        var Tree = this.getTree();
        switch (action) {
            case 'update':
                // this is usually Tree.update('state', dataAboutNewState)
                Tree.update(item, data);
                break;
            case 'ready':
                // tell the Tree to let all the other observers know that the view is ready
                Tree.message(item, data);
        }
    },

    /**
    * Bind tree data to the element for easy access to data when we need it
    */
    bindAllData: function bindAllData() {
        Tree = this.getTree();
        var elTypes = ['question', 'start', 'end', 'group'];
        // loop through the data and find the corresponding elements
        for (var i = 0; i < elTypes.length; i++) {
            // get the data: ex {question_id: 2, order: 2, etc}
            var elData = Tree.getDataByType(elTypes[i]);
            for (var j = 0; j < elData.length; j++) {
                // get the id, ex. the id value '2'
                // this is like saying: getDataByType('question').question_id
                var id = elData[j][elTypes[i] + '_id'];
                // find the element in the DOM
                var el = document.getElementById('enp-tree__el--' + id);
                // bind the data
                this.bindDOMData(elData[j], el, elTypes[i]);

                // see if we're working with a question or end
                switch (elTypes[i]) {
                    case 'question':
                        var options = elData[j].options;
                        // loop through the options
                        for (var k = 0; k < options.length; k++) {
                            // get option el
                            var optionEl = document.getElementById('enp-tree__el--' + options[k].option_id);
                            // bind the data
                            this.bindDOMData(options[k], optionEl, 'option');
                        }
                        break;

                    case 'end':
                        // assign data to restart button
                        // restart button
                        var restartEl = document.getElementById('enp-tree__restart--' + id);
                        this.bindDOMData(elData[j], restartEl, 'restart');
                        // go to overview button
                        var overviewEl = document.getElementById('enp-tree__overview--' + id);
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
                        start_id: data.start_id,
                        type: 'start'
                    };
                    break;

                case 'group':
                    clonedObj = {
                        group_id: data.group_id,
                        type: 'group',
                        order: data.order
                    };
                    break;

                case 'question':
                    clonedObj = {
                        question_id: data.question_id,
                        type: 'question',
                        order: data.order
                    };
                    clonedObj.options = [];
                    // add options
                    for (var i = 0; i < data.options.length; i++) {
                        clonedObj.options.push(data.options[i].option_id);
                    }
                    break;

                case 'option':
                    clonedObj = {
                        option_id: data.option_id,
                        type: 'option',
                        order: data.order,
                        question_id: data.question_id,
                        destination_id: data.destination_id,
                        destination_type: data.destination_type
                    };
                    break;

                case 'end':
                    clonedObj = {
                        end_id: data.end_id,
                        type: 'end',
                        order: data.order
                    };
                    break;

                case 'restart':
                    clonedObj = {
                        restart_id: data.end_id,
                        type: 'restart'
                    };
                    break;
                case 'overview':
                    clonedObj = {
                        overview_id: data.end_id,
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
    }
};
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
                id: data.tree_id,
                type: 'tree'
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

        // setters
        this.setState = function (stateType, stateID) {
            var whitelist = void 0,
                validateState = void 0,
                oldState = void 0,
                newState = void 0;

            whitelist = ['tree', 'start', 'question', 'end'];

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
                // return false
            }
            // check if the stateID is a valid ID for this state
            if (stateType === 'tree') {
                if (stateID === this.getTreeID()) {
                    validateState = true;
                } else {
                    validateState = false;
                }
            } else {
                validateState = this.getDataByType(stateType, stateID);
            }

            if (validateState === false || validateState === undefined) {
                console.error(stateID + " is invalid for the current state of '" + stateType + "'");
                this.emitError('invalidState', {
                    stateType: stateType,
                    stateID: stateID
                });
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
            };
            console.log('tree.js emitting states update');
            console.log({ newState: newState, oldState: oldState });
            // emit that we've changed it
            this.emit('update', { newState: newState, oldState: oldState });
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
            var _iteratorNormalCompletion = true;
            var _didIteratorError = false;
            var _iteratorError = undefined;

            try {

                for (var _iterator = this.observers[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
                    var observer = _step.value;

                    console.log('Tree.js emitting ' + action + ' to ' + observer.constructor.name);
                    observer.on(action, data);
                }
            } catch (err) {
                _didIteratorError = true;
                _iteratorError = err;
            } finally {
                try {
                    if (!_iteratorNormalCompletion && _iterator.return) {
                        _iterator.return();
                    }
                } finally {
                    if (_didIteratorError) {
                        throw _iteratorError;
                    }
                }
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
        * Request to update the tree o
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
            switch (data.type) {
                case 'start':
                    // go to first question
                    var question = this.getQuestions()[0];
                    this.setState('question', question.question_id);
                    break;

                case 'question':
                    // find the destination
                    this.setState(data.type, data.question_id);
                    break;

                case 'option':
                    // find the destination
                    this.setState(data.destination_type, data.destination_id);
                    break;

                case 'end':
                    // find the destination
                    this.setState(data.destination_type, data.destination_id);
                    break;

                case 'overview':
                    // go to tree overview
                    this.setState('tree', this.getTreeID());
                    break;

                case 'restart':
                    // go to first question
                    this.setState('question', this.getQuestions()[0].question_id);
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
                typeIndex = this.getIndexBy(data, type + '_id', id);
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
            return this.getData().tree_id;
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

        getOptions: function getOptions(question_id, option_id) {
            var option = void 0,
                optionIndex = void 0,
                question = void 0;

            // get the individual item
            question = this.getQuestions(question_id);

            if (option_id !== undefined) {
                optionIndex = this.getIndexBy(question.options, 'option_id', option_id);
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
        getTreeData(options.slug).then(buildTree.bind(options)).catch(handleTreeDataError);
    }

    function getTreeData(slug) {

        return new Promise(function (resolve, reject) {
            var baseUrl = void 0;
            if (/https?:\/\/(?:dev\/decision-tree|localhost:3000\/decision-tree)\//.test(window.location.href)) {
                baseUrl = 'http://dev/decision-tree';
            } else {
                baseUrl = 'http://enptree.wpengine.com';
            }

            var request = new XMLHttpRequest();
            request.overrideMimeType("application/json");
            request.open('GET', baseUrl + '/api/v1/trees/' + slug + '/compiled?minfied=true', true);
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
        if (!/https?:\/\/(?:dev\/decision-tree|tree\.engagingnewsproject\.org|enptree(\.staging)?\.wpengine\.com)\/api\//.test(request.responseURL)) {
            console.error('responseURL from an invalidated source.');
            return false;
        }

        var data = JSON.parse(request.response);
        var treeView = new TreeView({
            container: this.container
        });
        var treeHistory = new TreeHistory({});
        console.log(treeHistory);
        // add the observers
        var observers = [treeView, treeHistory];
        // build the tree
        var tree = new Tree(data, observers);
        // send it to our trees array for access
        trees.push(tree);
    }

    function handleTreeDataError(err) {
        console.error(err);
    }

    var trees = [];
    window.Tree = Tree;
    window.createTree = createTree;
    window.trees = trees;
})(window);