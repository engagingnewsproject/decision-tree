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

function TreeView(options) {
    var _id, _container, _treeEl, _contentWrap, _contentPanel, _Tree, _activeEl;

    if (_typeof(options.container) !== 'object') {
        console.error('Tree container must be a valid object. Try `container: document.getElementById(your-id)`.');
        return false;
    }

    // getters
    this.getContainer = function () {
        return _container;
    };
    this.getId = function () {
        return _id;
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
    this.getContentPanel = function () {
        return _contentPanel;
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

    this.setContentPanel = function () {
        // only let it be set once
        if (_contentPanel === undefined) {
            _contentPanel = _contentWrap.firstElementChild;
        }
        return _contentPanel;
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
    this.questionPadding = 50;
    // set the el
    _container = options.container;
    // attach event listeners to the tree element with
    // bound `this` so we get our reference to this element
    _container.addEventListener("click", this.click.bind(this));

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
        this.setContentPanel();
        // set the current state in the view
        this.setState(Tree.getState());
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
    },

    setState: function setState(state) {
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

        // if we're on a question, set the transform origin on the wrapper
        var cPanel = this.getContentPanel();
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
            var cPanel = this.getContentPanel();
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
                // emit that we've changed it
            };this.emit('update', { newState: newState, oldState: oldState });
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
            console.log('emitting ' + action);
            for (var i = 0; i < this.observers.length; i++) {
                this.observers[i].on(action, data);
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
            console.log('Request update with this data:');
            console.log(data);
            switch (action) {
                // data will be the element clicked
                case 'state':
                    this.updateState(data);
                    break;
            }
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

                case 'restart':
                    // find the destination
                    this.setState('tree', this.getTreeID());
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
        if (!/https?:\/\/(?:dev\/decision-tree|tree\.engagingnewsproject\.org|enptree\.staging\.wpengine\.com)\/api\//.test(request.responseURL)) {
            console.error('responseURL from an invalidated source.');
            return false;
        }

        var data = JSON.parse(request.response);
        var treeView = new TreeView({
            container: this.container
        });
        var observers = [treeView];

        var tree = new Tree(data, observers);

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