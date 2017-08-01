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

/* window Tree */
(function () {
    function Tree(options) {
        var _data, _state;

        // required options
        if (typeof options.slug !== 'string') {
            console.error('Tree slug must be a string.');
            return false;
        }

        if (_typeof(options.container) !== 'object') {
            console.error('Tree container must be a valid object. Try `container: document.getElementById(your-id)`.');
            return false;
        }

        // constructor
        function createTree(request) {

            // check our response URL to make sure it's from a trusted source
            if (!/https?:\/\/(?:dev\/decision-tree|tree\.engagingnewsproject\.org|enptree\.staging\.wpengine\.com)\/api\//.test(request.responseURL)) {
                console.error('responseURL from an invalidated source.');
                return false;
            }

            var data = JSON.parse(request.response);

            _data = data;
            _state = {
                id: data.starts[0].start_id,
                type: 'start'

                // render the tree
            };var template = window.TreeTemplates.tree;
            var treeHTML = template(data);

            // set the HTML into the passed container
            options.container.innerHTML = treeHTML;
            var treeEl = options.container.firstElementChild;
            // assign the value to our inserted element
            treeEl.value = data;
            // assign the element to the data
            _data.el = treeEl;

            // bind question data
            bindAllData(this);

            // attach event listeners to the tree element
            treeEl.addEventListener("click", this.click);
        }

        // getters
        this.getData = function () {
            return _data;
        };
        this.getState = function () {
            return _state;
        };

        // setters
        function bindAllData(context) {
            console.time("bind");
            var elTypes = ['question', 'start', 'end', 'group'];
            // loop through the data and find the corresponding elements
            for (var i = 0; i < elTypes.length; i++) {
                // get the data: ex {question_id: 2, order: 2, etc}
                var elData = context.getDataByType(elTypes[i]);
                for (var j = 0; j < elData.length; j++) {
                    // get the id, ex. the id value '2'
                    // this is like saying: getDataByType('question').question_id
                    var id = elData[j][elTypes[i] + '_id'];
                    // find the element in the DOM
                    var el = document.getElementById('enp-tree__el--' + id);
                    // find the spot in the data tree to assign the el to
                    // this is like saying: _data[questions]
                    var dataEl = _data[elTypes[i] + 's'][j];
                    // bind the data
                    bindDOMData(dataEl, el, elTypes[i]);

                    // see if we're working with a question
                    if (elTypes[i] === 'question') {
                        var _options = dataEl.options;
                        // loop through the options
                        for (var k = 0; k < _options.length; k++) {
                            // get the spot in the data tree to bind the data to
                            var optionDataEl = _options[k];
                            // get option el
                            var optionEl = document.getElementById('enp-tree__el--' + optionDataEl.option_id);
                            // bind the data
                            bindDOMData(optionDataEl, optionEl, 'option');
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
            if (_dataObj.el === undefined) {
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
                            start_id: _dataObj.start_id,
                            type: 'start'
                        };
                        break;

                    case 'group':
                        clonedObj = {
                            group_id: _dataObj.group_id,
                            type: 'group'
                        };
                        break;

                    case 'question':
                        clonedObj = {
                            question_id: _dataObj.question_id,
                            type: 'question',
                            destination_id: _dataObj.destination_id
                        };
                        clonedObj.options = [];
                        // add options
                        for (var i = 0; i < _dataObj.options.length; i++) {
                            clonedObj.options.push(_dataObj.options[i].option_id);
                        }
                        break;

                    case 'option':
                        clonedObj = {
                            option_id: _dataObj.option_id,
                            type: 'option',
                            question_id: _dataObj.question_id,
                            destination_id: _dataObj.destination_id
                        };
                        break;

                    case 'end':
                        clonedObj = {
                            end_id: _dataObj.end_id,
                            type: 'end'
                        };
                        break;
                }
                // dynamically building the structure was quite slow, so we're manually doing it for speed on this kinda expensive operation
                // bind the data to the DOM
                element.data = clonedObj;
                // bind the element to the _data
                _dataObj.el = element;

                return _dataObj.el;
            } else {
                // can't overwrite data, so return false
                return false;
            }
        }

        this.setState = function (stateType, stateID) {
            var whitelist = ['start', 'question', 'end'];

            // TODO: Check that start can't go straight to end?
            // TODO: Check that the next state is valid from the question's options?

            // check allowed states
            if (!whitelist.includes(stateType)) {
                console.error(stateType + " is not an allowed state. Allowed states are " + whitelist.toString());
                return false;
            }

            // check if the stateID is a valid ID for this state
            var validateState = this.getDataByType(stateType, stateID);
            if (validateState === false || validateState === undefined || (typeof validateState === 'undefined' ? 'undefined' : _typeof(validateState)) !== 'object') {
                console.error(stateID + " is invalid for the current state of '" + stateType + "'");
                return false;
            }

            // looks valid! Set the state
            _state.type = stateType;
            _state.id = stateID;
        };

        // INIT
        // Request our Tree Data
        // create the tree
        getTreeData(options.slug, 'http://dev/decision-tree/api/v1/trees/' + options.slug + '/compiled?minfied=true').then(createTree.bind(this)).catch(handleTreeDataError);
    }

    /**
    * Allowed types, 'question', 'group', 'end', 'start'
    */
    Tree.prototype.getDataByType = function (type, id) {
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
    };

    Tree.prototype.getQuestions = function (id) {
        var question = void 0;
        if (id !== undefined) {
            // get the individual item
            question = this.getDataByType('question', id);
        } else {
            question = this.getDataByType('question');
        }
        return question;
    };

    Tree.prototype.getStarts = function (id) {
        var start = void 0;
        if (id !== undefined) {
            // get the individual item
            start = this.getDataByType('start', id);
        } else {
            start = this.getDataByType('start');
        }
        return start;
    };

    Tree.prototype.getEnds = function (id) {
        var end = void 0;
        if (id !== undefined) {
            // get the individual item
            end = this.getDataByType('end', id);
        } else {
            end = this.getDataByType('end');
        }
        return end;
    };

    Tree.prototype.getGroups = function (id) {
        var group = void 0;
        if (id !== undefined) {
            // get the individual item
            group = this.getDataByType('group', id);
        } else {
            group = this.getDataByType('group');
        }
        return group;
    };

    Tree.prototype.getOptions = function (question_id, option_id) {
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
    };

    Tree.prototype.toDestinationClick = function (el) {};

    Tree.prototype.setActive = function (el) {};

    Tree.prototype.click = function (event) {

        var el = event.target;
        // check if it's a click on the parent tree (which we don't care about)
        if (el !== event.currentTarget) {
            if (el.nodeName === 'A') {
                event.preventDefault();
                this.toDestinationClick(el);
            }
        }
        e.stopPropagation();
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
    Tree.prototype.getIndexBy = function (objArray, name, value) {
        for (var i = 0; i < objArray.length; i++) {
            if (objArray[i][name] == value) {
                return i;
            }
        }
        return undefined;
    };

    function getTreeData(slug, url) {

        return new Promise(function (resolve, reject) {

            var request = new XMLHttpRequest();
            request.overrideMimeType("application/json");
            request.open('GET', url, true);
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

    function handleTreeDataError(err) {
        console.error(err);
    }
    // give access to Tree function in window scope
    window.Tree = Tree;
})(window);