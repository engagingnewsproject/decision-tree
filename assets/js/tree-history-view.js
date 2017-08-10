
function TreeHistoryView(options) {
    var _TreeHistory,
        _container,
        _list;

    if(typeof options.container !== 'object') {
        console.error('Tree History View container must be a valid object. Try `container: document.getElementById(your-id)`.')
        return false
    }

    if(typeof options.TreeHistory !== 'object') {
        console.error('Tree History must be a valid object.')
        return false
    }

    // getters
    this.getContainer = function() { return _container}
    this.getList = function() { return _list}
    this.getTreeHistory = function() { return _TreeHistory}

    // setters
    this.setContainer = function(container) {
        // only let it get set once
        if(_container === undefined) {
            let historyView = this.createView()
            // place it in the passed container
            container.insertBefore(historyView, container.firstElementChild)
            // set our built div as the container
            _container = container.firstElementChild
        }
        return _container
    }

    this.setList = function(list) {
        // only let it get set once
        if(_list === undefined) {
            // set our built div as the list
            _list = list
        }
        return _list
    }

    var _setTreeHistory = function(TreeHistory) {
        _TreeHistory = TreeHistory
    }

    _setTreeHistory(options.TreeHistory)
    this.setContainer(options.container)
    console.log(this.getTreeHistory().getHistory())
    this.templateRender(this.getTreeHistory().getHistory(), this.getTreeHistory().getCurrentIndex())
    // add click listener on container
    _container.addEventListener("click", this.click.bind(this));
    _container.addEventListener("keydown", this.keydown.bind(this));
}

TreeHistoryView.prototype = {
    constructor: TreeHistoryView,

    on: function(action, data) {
        console.log('TreeHistoryView "on" '+action);
        switch(action) {
            case 'historyUpdate':
                // data will be the tree itself
                this.updateHistory(data)
                break
            case 'historyIndexUpdate':
                this.updateHistoryIndex(data)
                break
        }
    },

    click: function() {

    },

    keydown: function() {

    },

    createView: function() {
        let elem;

        elem = document.createElement('aside')
        elem.classList.add('enp-tree__history')

        return elem;
    },

    updateHistory: function(history) {
        console.log('history update');
    },

    updateHistoryIndex: function(index) {
        console.log('history index update');
    },

    // TODO: template it with Handlebars? Is that overkill? It should be a very simple template. BUUUUT, we already have the templating engine built so... ?
    // TODO: Bind history data to an element so we know if we need to update it or not
    // TODO: Elements are being added/removed. Check each element to see if its element.data matches the history data in order. If one doesn't match, rerender from that point on.
    templateRender: function(history, currentIndex) {
        let container,
            list,
            current;
        console.log('history')
        console.log(history)
        container = this.getContainer()
        container.appendChild(this.templateUl())
        // set the list as the _list var
        this.setList(container.firstElementChild)
        list = this.getList()

        for(let i = 0; i < history.length; i++) {
            // generate list data and append to item
            current = false
            if(i === currentIndex) {
                current = true
            }
            list.appendChild(templateLi(history[i], i, current))
        }
    },

    templateUpdate: function(history) {

    },

    templateUl: function() {
        let ul = document.createElement('ul')
        ul.classList.add('enp-tree__history-list')
        return ul
    },

    templateLi: function(data, index) {
        let li = document.createElement('li')
        li.classList.add('enp-tree__history-list-item')
        li.innerHTML = index + 1
        li.data = data
        return li
    }
}
