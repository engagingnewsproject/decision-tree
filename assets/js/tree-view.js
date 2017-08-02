function TreeView(options) {
    var _id,
        _container,
        _Tree,
        _activeEl;

    if(typeof options.container !== 'object') {
        console.error('Tree container must be a valid object. Try `container: document.getElementById(your-id)`.')
        return false
    }

    // getters
    this.getContainer = function() { return _container}
    this.getId = function() { return _id}
    this.getTree = function() { return _Tree}
    this.getActiveEl = function() { return _activeEl}

    // setters
    this.setTree = function(Tree) {
        // only let it be set once
        if(_Tree === undefined) {
            _Tree = Tree
        }
        return _Tree
    }

    // Pass a state for it to set to be active
    this.setActiveEl = function(state) {
        let el;
        // check if classname matches, if we're even going to change anything
        if(_activeEl !== undefined && _activeEl.id === 'enp-tree__el--'+state.id) {
            // do nothing
            return _activeEl;
        }
        // they're trying to set a new state, so let's see if we can
        el = document.getElementById('enp-tree__el--'+state.id)
        if(typeof el !== 'object') {
            console.error('Could not set active element for state type '+state.type+ ' with state id '+state.id)
            return false
        }

        // valid (could be more checks, but this is good enough)
        // set it
        _activeEl = el
        return _activeEl
    }

    /***********************
    ******** INIT  *********
    ***********************/
    // set an active className
    if(options.activeClass) {
        this.activeClassName = options.activeClass
    } else {
        this.activeClassName = 'is-active'
    }
    // set the el
    _container = options.container;
    // attach event listeners to the tree element with
    // bound `this` so we get our reference to this element
    _container.addEventListener("click", this.click.bind(this));

    // if a Tree was passed, build the view now
    if(options.Tree) {
        this.build(options.Tree)
    }

}

TreeView.prototype = {
    constructor: TreeView,

    /**
    * Listen to parent Tree's emitted actions and handle accordingly
    */
    on: function(action, data) {
        console.log('TreeView "on" '+action);
        switch(action) {
            case 'ready':
                // data will be the tree itself
                this.build(data)
                break
            case 'update':
                this.updateState(data)
                break
        }
    },

    build: function(Tree) {
        this.setTree(Tree)
        this.render(Tree.getData())
        // set the current state in the view
        this.setState(Tree.getState())
    },

    render: function(data) {
        // render the tree
        var template = window.TreeTemplates.tree
        var treeHTML = template(data)
        // set the HTML into the passed container
        this.getContainer().innerHTML = treeHTML

        // bind question data
        this.bindAllData()
    },

    /**
    * Used when a state is already set and we need to change it
    */
    updateState: function(data) {
        let oldState,
            newState,
            oldActiveEl;

        oldState = data.oldState
        newState = data.newState
        oldActiveEl = this.getActiveEl()

        // removes container state class
        if(oldState.type !== newState.type) {
            this.removeContainerState(oldState)
        }
        if(oldState.id !== newState.id) {
            // get active element
            oldActiveEl.classList.remove(this.activeClassName)
        }

        // activate new state
        // data.newState.id
        newState = this.setState(data.newState)

        // revert back to old state
        if(newState === false) {
            this.setState(data.oldState)
        }
    },

    setState: function(state) {
        let activeEl;

        this.addContainerState(state)

        // set active element
        activeEl = this.setActiveEl(state)

        // if set active fails, let setState know
        if(activeEl === false) {
            return false;
        }
        console.log('TreeView state view is:');
        console.log(state)
        // validated, so set the new class!
        activeEl.classList.add(this.activeClassName)
        return true;
    },

    addContainerState: function(state) {
        // set the state type on the container
        let container = this.getContainer()
        let classes = container.classList;
        // if the class isn't already there, add it
        if(!classes.contains('enp-tree__state--'+state.type)) {
            classes.add('enp-tree__state--'+state.type)
        }

    },

    removeContainerState: function(state) {
        // set the state type on the container
        let container = this.getContainer()
        container.classList.remove('enp-tree__state--'+state.type)
    },

    /*updateContainerState: function(data) {
        let oldState,
            newState,
            container;

        container = this.getContainer()
        oldState = data.oldState
        newState = data.newState

        if(oldState.type !== newState.type) {
            this.removeContainerState()
            this.addContainerState();
        }
    },*/

    click: function(event) {
        let el = event.target;
        // check if it's a click on the parent tree (which we don't care about)
        if (el !== event.currentTarget) {
            if(el.nodeName === 'A') {
                event.preventDefault()
                this.emit('update', 'state', el.data)
            }
        }
        event.stopPropagation()
    },

    /**
    * Let our Tree know about the click.
    */
    emit: function(action, item, data) {
        console.log('Tree View Emit: '+action);
        console.log(data)
        let Tree = this.getTree()
        switch(action) {
            case 'update':
                // this is usually Tree.update('state', dataAboutNewState)
                Tree.update(item, data);
                break
        }

    },


    /**
    * Bind tree data to the element for easy access to data when we need it
    */
    bindAllData: function() {
        Tree = this.getTree();
        let elTypes = ['question', 'start', 'end', 'group']
        // loop through the data and find the corresponding elements
        for(let i = 0; i < elTypes.length; i++) {
            // get the data: ex {question_id: 2, order: 2, etc}
            let elData = Tree.getDataByType(elTypes[i])
            for(let j = 0; j < elData.length; j++) {
                // get the id, ex. the id value '2'
                // this is like saying: getDataByType('question').question_id
                let id = elData[j][elTypes[i]+'_id']
                // find the element in the DOM
                let el = document.getElementById('enp-tree__el--'+id)
                // bind the data
                this.bindDOMData(elData[j], el, elTypes[i])

                // see if we're working with a question
                if(elTypes[i] === 'question') {
                    let options = elData[j].options
                    // loop through the options
                    for(let k = 0; k < options.length; k++) {
                        // get option el
                        let optionEl =  document.getElementById('enp-tree__el--'+options[k].option_id)
                        // bind the data
                        this.bindDOMData(options[k], optionEl, 'option')
                    }
                }
            }
        }
    },


    bindDOMData: function(data, element, type) {
        // we can only add this once, not overwrite existing ones
        if(element.data === undefined) {
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
                        start_id: data.start_id,
                        type: 'start',
                    }
                    break

                case 'group':
                    clonedObj = {
                        group_id: data.group_id,
                        type: 'group',
                    }
                    break

                case 'question':
                    clonedObj = {
                        question_id: data.question_id,
                        type: 'question',
                    }
                    clonedObj.options = []
                    // add options
                    for(let i = 0; i < data.options.length; i++) {
                        clonedObj.options.push(data.options[i].option_id)
                    }
                    break

                case 'option':
                    clonedObj = {
                        option_id: data.option_id,
                        type: 'option',
                        question_id: data.question_id,
                        destination_id: data.destination_id,
                        destination_type: data.destination_type,
                    }
                    break

                case 'end':
                    clonedObj = {
                        end_id: data.end_id,
                        type: 'end',
                    }
                    break
            }
            // dynamically building the structure was quite slow, so we're manually doing it for speed on this kinda expensive operation
            // bind the data to the DOM
            element.data = clonedObj
            return element.data
        } else {
            // can't overwrite data, so return false
            return false
        }
    }
}
