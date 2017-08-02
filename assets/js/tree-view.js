function TreeView(options) {
    var _id,
        _el,
        _Tree;

    if(typeof options.container !== 'object') {
        console.error('Tree container must be a valid object. Try `container: document.getElementById(your-id)`.')
        return false
    }

    // getters
    this.getEl = function() { return _el}
    this.getId = function() { return _id}
    this.getTree = function() { return _Tree}

    // setters
    this.setTree = function(Tree) {
        // only let it be set once
        if(_Tree === undefined) {
            _Tree = Tree
        }
        return _Tree
    }

    /***********************
    ******** INIT  *********
    ***********************/
    // if a Tree was passed, add it
    if(options.Tree) {
        this.setTree(options.Tree)
    }

    // set the el
    _el = options.container;
    // attach event listeners to the tree element with
    // bound `this` so we get our reference to this element
    _el.addEventListener("click", this.click.bind(this));
}

TreeView.prototype = {
    constructor: TreeView,

    /**
    * Listen to parent Tree's emitted actions and handle accordingly
    */
    on: function(action, data) {
        console.log(action);
        switch(action) {
            case 'ready':
                // data will be the tree itself
                Tree = data;
                this.setTree(Tree)
                this.render(Tree.getData())
                break
            case 'update':
                this.update(data)
                break
        }
    },

    render: function(data) {
        // render the tree
        var template = window.TreeTemplates.tree
        var treeHTML = template(data)
        // set the HTML into the passed container
        this.getEl().innerHTML = treeHTML

        // bind question data
        this.bindAllData()
    },

    update: function(state) {
        // render the tree
        // remove is-active
        console.log(state)
        // Do stuff based on the new state change...

        /*document.querySelector('.is-active').classList.remove('is-active')
        document.getElementById('enp-tree__el--'+state.id).classList.add('is-active')*/

    },


    click: function(event) {
        let el = event.target;
        // check if it's a click on the parent tree (which we don't care about)
        if (el !== event.currentTarget) {
            if(el.nodeName === 'A') {
                event.preventDefault()
                console.log(el.data)
                this.emit('update', 'state', el.data)
            }
        }
        event.stopPropagation()
    },

    /**
    * Let our Tree know about the click.
    */
    emit: function(action, item, data) {
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
