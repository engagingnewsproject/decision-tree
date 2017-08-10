
function TreeHistoryView(options) {
    var _TreeHistory,
        _container,
        _list,
        _overviewBtn,
        _resumeBtn;

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
    this.getOverviewBtn = function() { return _OverviewBtn}
    this.getResumeBtn = function() { return _resumeBtn}
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

    this.setOverviewBtn = function(overviewBtn) {
        // only let it get set once
        if(_overviewBtn === undefined) {
            // set our built div as the overview
            _overviewBtn = overviewBtn
        }
        return _overviewBtn
    }

    this.setResumeBtn = function(resumeBtn) {
        // only let it get set once
        if(_resumeBtn === undefined) {
            // set our built div as the resume
            _resumeBtn = resumeBtn
        }
        return _resumeBtn
    }

    var _setTreeHistory = function(TreeHistory) {
        _TreeHistory = TreeHistory
    }

    _setTreeHistory(options.TreeHistory)
    this.setContainer(options.container)
    this.templateRender(this.getTreeHistory().getHistory(), this.getTreeHistory().getCurrentIndex())
    // add click listener on container
    _container.addEventListener("click", this.click.bind(this));
    _container.addEventListener("keydown", this.keydown.bind(this));
}

TreeHistoryView.prototype = {
    constructor: TreeHistoryView,

    on: function(action, data) {
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

    /**
    * Let our Tree History know about whatever
    */
    message: function(action, item, data) {
        let TreeHistory = this.getTreeHistory()
        // this is usually Tree.update('state', dataAboutNewState)
        TreeHistory.message(action, item, data);
    },

    click: function(event) {
        let el;

        el = event.target;

        // check if it's a click on the parent tree (which we don't care about)
        if (el !== event.currentTarget) {
            if(el.nodeName === 'A') {
                event.preventDefault()
                // see if we want to go to overview or new question/end
                if(!el.classList.contains('is-active') || el.data.type === 'overview') {
                    this.message('update', 'state', el.data)
                }
            }
        }
        event.stopPropagation()
    },

    keydown: function() {

    },

    createView: function() {
        let elem;

        elem = document.createElement('aside')
        elem.classList.add('enp-tree__history')

        return elem;
    },

    getHistoryNavItems() {
        let list = this.getList()
        return list.getElementsByClassName('enp-tree__history-list-item--nav')
    },

    updateHistory: function(history) {
        this.templateUpdateHistory(history)
    },

    updateHistoryIndex: function(index) {
        this.templateUpdateIndex(index)
    },

    // TODO: Elements are being added/removed. Check each element to see if its element.data matches the history data in order. If one doesn't match, rerender from that point on.
    templateRender: function(history, currentIndex) {
        let container,
            list,
            current;
        container = this.getContainer()
        container.appendChild(this.templateUl())
        // set the list as the _list var
        this.setList(container.firstElementChild)
        list = this.getList()

        // create the overview button
        list.appendChild(this.templateOverviewBtn())
        this.setOverviewBtn(list.firstElementChild)

        // create the buttons
        for(let i = 0; i < history.length; i++) {
            // generate list data and append to item
            list.appendChild(this.templateHistoryItem(history[i], i, currentIndex))
        }
    },

    templateUpdateHistory: function(history) {
        let list,
            li,
            a,
            deleteLi,
            iterator;

        // go through and compare
        list = this.getList()
        li = this.getHistoryNavItems()
        // the first one is the overview button, so don't include it
        deleteLi = []
        iterator = li.length

        // if there's no history, delete all lis
        if(!history.length) {
            for(let i = 0; i < li.length; i++) {
                list.removeChild(li[i])
            }
            return;
        }

        // if we don't have any lis, then create them all
        if(!li.length) {
            // create the elements
            for(let i = 0; i < history.length; i++) {
                list.appendChild(this.templateHistoryItem(history[i], i))
            }
            return;
        }

        // decide which is longer and set that as our iterator
        if(li.length <= history.length) {
            iterator = history.length
        }
        // if we have lis and history, let's check out which ones we need to delete or add
        for(let i = 0; i < iterator; i++) {

            if(li[i] !== undefined) {
                a = li[i].firstElementChild
            }
            if(deleteLi.length !== 0 || history[i] === undefined) {
                // add these to the ones to delete
                deleteLi.push(li[i])
            }
            else if(li[i] === undefined) {
                // create it
                list.appendChild(this.templateHistoryItem(history[i], i))
            }
            // if both exist, compare values
            else if(a.data !== undefined && a.data.id !== history[i].id) {
                // add these to the ones to delete
                deleteLi.push(li[i])
            } else {
                // nothing to do - they're the same!
            }
        }
        // delete children if we need to
        for(let i = 0; i < deleteLi.length; i++) {
            list.removeChild(deleteLi[i])
        }
    },

    templateUpdateIndex(currentIndex) {
        let li,
            a;
        li = this.getHistoryNavItems();
        // first check that we need to update anything
        for(let i = 0; i < li.length; i++) {
            a = li[i].firstElementChild
            if(a.classList.contains('is-active') && i !== currentIndex) {
                a.classList.remove('is-active')
            }

        }
        a = li[currentIndex].firstElementChild
        if(!a.classList.contains('is-active')) {
            a.classList.add('is-active')
        }
    },

    templateUl: function() {
        let ul = document.createElement('ul')
        ul.classList.add('enp-tree__history-list')
        return ul
    },

    // The data needs to be formatted to send a message that
    // we want to go to the overview mode
    templateOverviewBtn: function() {
        let li,
            a;

        li = document.createElement('li')
        a = document.createElement('a')
        li.appendChild(a)

        li.classList.add('enp-tree__history-list-item', 'enp-tree__istory-list-item--overview')

        a.classList.add('enp-tree__history-list-link', 'enp-tree__history-list-link--overview')
        a.innerHTML = '[]'
        a.data = {type: 'overview'}

        return li
    },

    templateHistoryItem: function(data, index, currentIndex) {
        let li,
            a;

        li = document.createElement('li')
        a = document.createElement('a')
        li.appendChild(a)

        li.classList.add('enp-tree__history-list-item', 'enp-tree__history-list-item--nav')

        a.classList.add('enp-tree__history-list-link', 'enp-tree__history-list-link--nav')
        a.innerHTML = index + 1
        a.data = data

        if(currentIndex === index) {
            a.classList.add('is-active')
        }
        return li
    }
}