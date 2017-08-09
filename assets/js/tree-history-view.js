
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

    on: function() {

    },

    createView: function() {
        let elem;

        elem = document.createElement('aside')
        elem.classList.add('enp-tree__history')

        return elem;
    }
}
