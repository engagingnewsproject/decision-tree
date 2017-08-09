
function TreeHistoryView(options) {
    var _TreeHistory,
        _container;

    if(typeof options.container !== 'object') {
        console.error('Tree History View container must be a valid object. Try `container: document.getElementById(your-id)`.')
        return false
    }

    if(typeof options.TreeHistory !== 'object') {
        console.error('Tree History must be a valid object.')
        return false
    }

    // setters
    this.setContainer = function(container) {
        // only let it get set once
        if(_container === undefined) {
            let historyView = this.createView()
            // place it in the passed container
            container.insertBefore(historyView, container.firstElementChild)
            // set our built div as the container
            _container = container.firstElementChild
            console.log(container.firstElementChild)
        }
        return _container
    }

    var _setTreeHistory = function(TreeHistory) {
        _TreeHistory = TreeHistory
    }

    _setTreeHistory(options.TreeHistory)
    this.setContainer(options.container)


    // getters
    this.getContainer = function() { return _container}
    this.getTreeHistory = function() { return _TreeHistory}
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
    // TODO: Bind history data to an element so we know if we need to update it or not?
    // TODO: Elements are being added/removed. Now would be a good time to know if we need to rerender to stay in sync.
}
