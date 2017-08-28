
function TreeHistoryView(options) {
    var _TreeHistory,
        _contentWindow,
        _container,
        _list,
        _resumeBtn,
        _progressbar;

    if(typeof options.contentWindow !== 'object') {
        console.error('Tree History View container must be a valid object. Try `container: document.getElementById(your-id)`.')
        return false
    }

    if(typeof options.TreeHistory !== 'object') {
        console.error('Tree History must be a valid object.')
        return false
    }

    // getters
    this.getContentWindow = function() { return _contentWindow}
    this.getContainer = function() { return _container}
    this.getList = function() { return _list}
    this.getResumeBtn = function() { return _resumeBtn}
    this.getProgressbar = function() { return _progressbar}
    this.getTreeHistory = function() { return _TreeHistory}

    // setters
    this.setContentWindow = function(contentWindow) {
        // only let it get set once
        if(_contentWindow === undefined) {
            // set our built div as the contentWindow
            _contentWindow = contentWindow
        }
        return _contentWindow
    }

    this.setContainer = function() {
        // only let it get set once
        if(_container === undefined) {
            let historyView = this.createView()
            let cWindow = this.getContentWindow()
            // place it in the passed container
            cWindow.insertBefore(historyView, cWindow.firstElementChild)
            // set our built div as the container
            _container = cWindow.firstElementChild
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

    this.setResumeBtn = function(resumeBtn) {
        // only let it get set once
        if(_resumeBtn === undefined) {
            // set our built div as the resume
            _resumeBtn = resumeBtn
        }
        return _resumeBtn
    }

    this.setProgressbar = function(progressbar) {
        // only let it get set once
        if(_progressbar === undefined) {
            // set our built div as the resume
            _progressbar = progressbar
        }
        return _progressbar
    }

    var _setTreeHistory = function(TreeHistory) {
        _TreeHistory = TreeHistory
    }

    _setTreeHistory(options.TreeHistory)
    this.setContentWindow(options.contentWindow)
    this.setContainer()
    this.templateRender(this.getTreeHistory().getHistory(), this.getTreeHistory().getCurrentIndex())
    // add click listener on container
    _container.addEventListener("click", this.click.bind(this));
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
            case 'viewHeightUpdate':
                // we need to wait until the viewHeights have been calculated and set so
                // we can set the heights appropriately
                let currentIndex = this.getCurrentIndex()
                this.templateUpdateProgressbar(currentIndex)
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
            // also check for parent, as the
            if(el.nodeName === 'BUTTON' || el.parentNode.nodeName === 'BUTTON') {
                event.preventDefault()
                // if our parent is the A, then set that as el, bc that's the one with the data set on it. This is for the overviewBtn
                if(el.parentNode.nodeName === 'BUTTON') {
                    el = el.parentNode
                }
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

    getCurrentNav() {
        let currentIndex,
            historyNav;

        currentIndex = this.getCurrentIndex()
        historyNav = this.getHistoryNavItems()

        return historyNav[currentIndex]
    },

    getCurrentIndex() {
        let currentIndex,
            TreeHistory;

        TreeHistory = this.getTreeHistory();
        currentIndex = TreeHistory.getCurrentIndex()
        return currentIndex
    },

    // Gets current state of the tree
    getCurrentState() {
        let state;

        state = this.getTreeHistory().getTree().getState();
        return state
    },

    // just the history question/end items. Not the overview btn.
    getHistoryNavItems() {
        let list = this.getList()
        return list.getElementsByClassName('enp-tree__history-list-item--nav')
    },

    // All items, including overview button
    getHistoryItems() {
        let list = this.getList()
        return list.children
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
            current,
            item;

        container = this.getContainer()
        container.appendChild(this.templateUl())
        // set the list as the _list var
        this.setList(container.firstElementChild)
        list = this.getList()

        // create the progressbar
        container.appendChild(this.templateProgressbar())
        this.setProgressbar(container.children[1])

        // create the buttons
        for(let i = 0; i < history.length; i++) {
            if(i === 0) {
                if(history[i].type !== 'intro') {
                    console.error('First history item should be of type "intro"')
                }
                item  = this.templateStartBtn(history[i])
            }
            else if(i === 1) {
                if(history[i].type !== 'tree') {
                    console.error('Second history item should be of type "tree"')
                }
                item = this.templateOverviewBtn(history[i])
            } else {
                // generate list data and append to item
                item  = this.templateHistoryItem(history[i], i, currentIndex)
            }
            list.appendChild(item)
        }

        // set the progressbarHeight
        this.templateUpdateProgressbar(currentIndex)

        // set the active element
        this.templateUpdateIndex(currentIndex)
    },

    templateUpdateHistory: function(history) {
        let list,
            li,
            button,
            deleteLi,
            iterator;


        // go through and compare
        list = this.getList()
        li = this.getHistoryItems()
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

        // if we don't have any li's, then create them all
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
                button = li[i].firstElementChild
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
            else if(button.data !== undefined && button.data.id !== history[i].id) {
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
            button;

        li = this.getHistoryItems()
        // first check that we need to update anything
        for(let i = 0; i < li.length; i++) {
            button = li[i].firstElementChild
            if(button.classList.contains('is-active') && i !== currentIndex) {
                button.classList.remove('is-active')
            }

        }
        button = li[currentIndex].firstElementChild
        if(!button.classList.contains('is-active')) {
            button.classList.add('is-active')
        }

    },

    templateUpdateProgressbar: function(currentIndex) {
        let progressbar,
            progressbarHeight,
            historyItems,
            list,
            listHeight,
            container,
            containerMoveUp,
            cWindow,
            cWindowHeight;

        container = this.getContainer()
        progressbar = this.getProgressbar()

        historyItems = this.getHistoryItems()
        progressbarHeight = historyItems[currentIndex].offsetTop
        // update height
        progressbar.style.height = progressbarHeight +'px'

        cWindow = this.getContentWindow()
        list = this.getList()
        listHeight = list.getBoundingClientRect().height
        cWindowHeight = parseFloat(cWindow.style.height)
        // default to the top
        containerMoveUp = 0

        // OMG just don't. This was way harder on a Friday afternoon than it
        // should have been.
        // We're checking to see if the contentWindow is less than the listHeight AND if the progressbarHeight is tall enough that we need to address it.
        // IE. We don't want to move the list all the way down if they have 10 items, but they've moved back to the second.
        if(cWindowHeight < listHeight && cWindowHeight/2 < progressbarHeight) {

            if((listHeight - progressbarHeight) < cWindowHeight/2) {
                // the bottom element can be in the bottom half of the view, so stack it to the bottom.
                containerMoveUp = cWindowHeight - listHeight
            } else {
                // Center it in the window because we're not near the top or bottom
                containerMoveUp = -(progressbarHeight - cWindowHeight/2 + historyItems[currentIndex].getBoundingClientRect().height/2)
            }

        }

        container.style.transform = 'translate3d(0,'+ containerMoveUp +'px,0)'

    },

    templateUl: function() {
        let ul = document.createElement('ul')
        ul.classList.add('enp-tree__history-list')
        return ul
    },

    templateProgressbar: function() {
        let progressbar = document.createElement('div')
        progressbar.classList.add('enp-tree__history-progress')
        return progressbar
    },

    // a button so we can display all the buttons in the html without having to show the start button
    templateStartBtn: function(data) {
        let li,
            button;

        li = document.createElement('li')
        button = document.createElement('button')
        li.appendChild(button)

        li.classList.add('enp-tree__history-list-item', 'enp-tree__history-list-item--start')

        button.classList.add('enp-tree__history-list-link', 'enp-tree__history-list-link--start')
        button.data = data

        return li
    },

    // The data needs to be formatted to send a message that
    // we want to go to the overview mode
    templateOverviewBtn: function(data) {
        let li,
            button;

        li = document.createElement('li')
        button = document.createElement('button')
        li.appendChild(button)

        li.classList.add('enp-tree__history-list-item', 'enp-tree__istory-list-item--overview')

        button.classList.add('enp-tree__history-list-link', 'enp-tree__history-list-link--overview')
        button.innerHTML = '<div class="enp-tree__overview-icon"></div><div class="enp-tree__overview-icon"></div>'
        button.data = data

        return li
    },

    templateHistoryItem: function(data, index) {
        let li,
            button;

        li = document.createElement('li')
        button = document.createElement('button')
        li.appendChild(button)

        li.classList.add('enp-tree__history-list-item', 'enp-tree__history-list-item--nav')

        button.classList.add('enp-tree__history-list-link', 'enp-tree__history-list-link--nav')
        // because of the start button (hidden) and overview button before it
        // we need to subtract 1 from the index
        button.innerHTML = index - 1
        button.data = data

        return li
    }
}
