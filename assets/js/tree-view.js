function TreeView(options) {
    var _Tree,
        _container,
        _treeEl,
        _contentWindow,
        _contentPane,
        _activeEl;

    if(typeof options.container !== 'object') {
        console.error('Tree container must be a valid object. Try `container: document.getElementById(your-id)`.')
        return false
    }

    // getters
    this.getContainer = function() { return _container}
    this.getTree = function() { return _Tree}
    this.getTreeEl = function() { return _treeEl}
    this.getActiveEl = function() { return _activeEl}
    this.getContentWindow = function() { return _contentWindow}
    this.getContentPane = function() { return _contentPane}

    // setters
    this.setTree = function(Tree) {
        // only let it be set once
        if(_Tree === undefined) {
            _Tree = Tree
        }
        return _Tree
    }

    // setters
    this.setTreeEl = function() {
        // only let it be set once
        if(_treeEl === undefined) {
            // this will be the tree rendered by handlebars
            _treeEl = _container.firstElementChild
        }
        return _treeEl
    }

    this.setContentWindow = function() {
        // only let it be set once
        if(_contentWindow === undefined) {
            _contentWindow = document.getElementById('enp-tree__content-window--'+_Tree.getTreeID())
        }
        return _contentWindow
    }

    this.setContentPane = function() {
        // only let it be set once
        if(_contentPane === undefined) {
            _contentPane =  _contentWindow.firstElementChild
        }
        return _contentPane
    }

    // Pass a state for it to set to be active
    this.setActiveEl = function(state) {
        let el,
            elId;

        if(state.type === 'tree') {
            elId = 'enp-tree--'+state.id
        } else {
            elId = 'enp-tree__el--'+state.id
        }
        // check if classname matches, if we're even going to change anything
        if(_activeEl !== undefined && _activeEl.id === elId) {
            // do nothing
            return _activeEl;
        }
        // they're trying to set a new state, so let's see if we can
        el = document.getElementById(elId)
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
    this.activeClassName = 'is-active'
    // how long animation classes are applied for until removed
    this.animationLength = 500
    // not ideal to pass this, but it's SOOO much faster performance wise
    this.scaledSize = 0.65
    // set the el
    _container = options.container;
    // attach event listeners to the tree element with
    // bound `this` so we get our reference to this element
    _container.addEventListener("click", this.click.bind(this));
    _container.addEventListener("keydown", this.keydown.bind(this));
    // add a resize timeout so we know if one is already firing
    this.resizeTimeout = null
    window.addEventListener("resize", this.resize.bind(this));

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
        // set the Tree El
        this.setTreeEl()
        // set the tree wrap
        this.setContentWindow()
        // set the questions wrap
        this.setContentPane()
        // let everyone know the tree view is ready
        // emit that we've finished render
        this.emit('ready', 'viewReady', this)
        // set the current state in the view
        let init = true
        // calculate size
        this.setState(Tree.getState(), init)
        this.updateViewHeight(Tree.getState())

        // if we don't have any groups calculated, go ahead and calculate to store the values
        this.checkForGroupsCalc()
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

    getGroups: function() {
        let treeEl,
            groups;

        treeEl = this.getTreeEl()
        return treeEl.getElementsByClassName('enp-tree__group')
    },

    getQuestions: function() {
        let treeEl,
            groups;

        treeEl = this.getTreeEl()
        return treeEl.getElementsByClassName('enp-tree__question')
    },

    getDestination: function(destination_id) {
        return document.getElementById('enp-tree__el--'+destination_id)
    },

    getOptions: function(question) {
        return question.getElementsByClassName('enp-tree__option-link')
    },

    getDestinationIcon: function(option_id) {
        return document.getElementById('enp-tree__destination-icon--'+option_id)
    },

    /**
    * Used when a state is already set and we need to change it
    */
    updateState: function(data) {
        let oldState,
            newState,
            oldActiveEl,
            newStateSuccess;

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
            // animate out
            oldActiveEl.classList.add('enp-tree__'+oldState.type+'--animate-out')
            setTimeout(()=>{
                 oldActiveEl.classList.remove('enp-tree__'+oldState.type+'--animate-out')
            }, this.animationLength)
        }

        // activate new state
        // data.newState.id
        newStateSuccess = this.setState(data.newState)

        // delay the updateViewHeight if we're switching to/from the 'tree' since there's a lot that happens height/transform wise in that time
        if(oldState.type === 'tree' || newState.type === 'tree') {
            setTimeout(()=>{
                this.updateViewHeight(newState)
            }, this.animationLength)
        } else {
            // don't worry about delaying
            this.updateViewHeight(newState)
        }

        // revert back to old state
        if(newStateSuccess === false) {
            this.setState(oldState)
            this.updateViewHeight(oldState)
        }
    },

    setState: function(state, init) {
        let activeEl;

        this.addContainerState(state)

        // set active element
        activeEl = this.setActiveEl(state)

        // if set active fails... what to do?
        if(activeEl === false) {
            return false;
        }
        // validated, so set the new class!
        activeEl.classList.add(this.activeClassName)
        // we don't want to add focus on init
        if(init !== true) {
            // focus it
            activeEl.focus()
        }

        return true;
    },

    calculateQuestionsSize: function() {
        let questions,
            bounds;
            console.log('calculateQuestionsSize')
        questions = this.getQuestions()
        for(let i =0; i < questions.length; i++) {
            questions[i].data.bounds = {
                offsetHeight: questions[i].offsetHeight,
                offsetTop: questions[i].offsetTop
            }
        }
    },

    updateViewHeight: function(state) {
        let activeEl,
            cPanel,
            cWindow,
            cWindowHeight,
            cPanelTransform,
            questionOffsetTop,
            groupsHeight;

        activeEl = this.getActiveEl()
        // if we're on a question, set the transform origin on the wrapper
        cPanel = this.getContentPane()
        cWindow = this.getContentWindow()

        if(state.type === 'question' || state.type === 'end') {

            // content window is what you can see and the pane is the full height element with transform origin applied on it. Think of a big piece of paper (the panel) and it's covered up except for a small window that you're looking through

            // if we change the margins based on a state change here, it'll mess up
            // the calculation on offsetTop. If we're going to do that, we need to
            // delay the margin change until after the animation has completed

            // Also, offsetTop only works to the next RELATIVELY positioned element, so the activeEl container (cPanel) must be set position relative
            // reset group transforms
            this.resetArrangeGroups()
            // check to make sure we have sizes
            if(activeEl.data.bounds === undefined) {
                this.calculateQuestionsSize()

            }

            questionOffsetTop = -activeEl.data.bounds.offsetTop
            cPanelTransform = 'translate3d(0,'+ questionOffsetTop+'px,0)'
            // set window scroll position to 0 (helps on mobile to center the question correctly)
            cWindow.scrollTop = 0
            // set a height
            cWindowHeight = activeEl.data.bounds.offsetHeight
        }

        else if(state.type === 'intro') {
            this.arrangeGroups()
        }
        // if the state type is tree, set a height on the window and distribute the groups accordingly
        else if(state.type === 'tree') {
            groupsHeight = this.arrangeGroups()

            this.displayArrowDirection()
            // make sure the height of the groups isn't taller than the cWindowHeight
            cWindowHeight = cPanel.getBoundingClientRect().height

            if(cWindowHeight < groupsHeight) {
                cWindowHeight = groupsHeight
            }

            cWindow.style.height = cWindowHeight+'px';


            // reset the transform origin
            cPanelTransform = ''
        } else {
            cPanelTransform = ''
        }

        // set the transforms
        cWindow.style.height = cWindowHeight+'px'
        cPanel.style.transform = cPanelTransform

        // emit to let everyone know we finished updating the height
        this.emit('viewChange', 'viewHeightUpdate', {cWindowHeight: cWindowHeight, questionOffsetTop: questionOffsetTop })
    },

    addContainerState: function(state) {
        // set the state type on the container
        let treeEl = this.getTreeEl()
        let classes = treeEl.classList;
        // if the class isn't already there, add it
        if(!classes.contains('enp-tree__state--'+state.type)) {
            classes.add('enp-tree__state--'+state.type)
        }
    },

    setTransform: function(el, prop) {
        el.style.webkitTransform = prop;
        el.style.MozTransform = prop;
        el.style.msTransform = prop;
        el.style.OTransform = prop;
        el.style.transform = prop;
    },

    removeContainerState: function(state) {
        // set the state type on the container
        let treeEl = this.getTreeEl()
        treeEl.classList.remove('enp-tree__state--'+state.type)

        // add animation classes
        treeEl.classList.add('enp-tree__state--animate-out--'+state.type)
        window.setTimeout(()=>{ treeEl.classList.remove('enp-tree__state--animate-out--'+state.type) }, this.animationLength)
    },

    keydown: function(event) {
        // check to see if it's a spacebar or enter keypress
        // 13 = 'Enter'
        // 32 = 'Space'
        if(event.keyCode === 13 || event.keyCode === 32) {
            // call the click
            this.click(event)
        }

        // TODO: don't allow focus on other questions if question view

        // TODO: don't allow focus on options if in tree state view


    },

    click: function(event) {
        let el,
            Tree,
            state;
        el = event.target;

        // check if it's a click on the parent tree (which we don't care about)
        if (el !== event.currentTarget) {
            if(el.nodeName === 'A' || (el.nodeName === 'SPAN' && el.parentNode.nodeName === 'A')) {
                // see if the parent is a link
                if(el.nodeName === 'SPAN') {
                    el = el.parentElement
                }
                event.preventDefault()
                this.emit('update', 'state', el.data)
            }

            // Let people click questions (that isn't the current question)
            // to get to the question
            else if(el.nodeName === 'SECTION') {
                event.preventDefault()
                Tree = this.getTree()
                state = Tree.getState();
                // make sure we're not curently on this question
                if((el.data.type === 'question' && state.id !== el.data.question_id)  || state.type !== 'question' ) {
                    this.emit('update', 'state', el.data)
                }

            }
        }
        event.stopPropagation()
    },

    resize: function() {

        // recalculate heights on resize
        // debounce it, kinda, by waiting 100ms until they're done so we don't fire this constantly
        this.resizeTimeout = null;
        if ( !this.resizeTimeout ) {
            this.resizeTimeout = setTimeout(()=>{
                // update the heights
                this.updateViewHeight(this.getTree().getState())
            }, 450);
        }
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
            case 'ready':
                // tell the Tree to let all the other observers know that the view is ready
                Tree.message(item, data)
                break
            case 'viewChange':
                Tree.message(item, data)
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

                // see if we're working with a question or end
                switch(elTypes[i]) {
                    case 'question':
                        let options = elData[j].options
                        // loop through the options
                        for(let k = 0; k < options.length; k++) {
                            // get option el
                            let optionEl =  document.getElementById('enp-tree__el--'+options[k].option_id)
                            // bind the data
                            this.bindDOMData(options[k], optionEl, 'option')
                        }
                        break

                    case 'end':
                        // assign data to restart button
                        // restart button
                        var restartEl = document.getElementById('enp-tree__restart--'+id)
                        this.bindDOMData(elData[j], restartEl, 'restart')
                        // go to overview button
                        var overviewEl = document.getElementById('enp-tree__overview--'+id)
                        this.bindDOMData(elData[j], overviewEl, 'overview')
                        break
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
                        order: data.order
                    }
                    break

                case 'question':
                    clonedObj = {
                        question_id: data.question_id,
                        type: 'question',
                        order: data.order,
                        group_id: data.group_id
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
                        order: data.order,
                        question_id: data.question_id,
                        destination_id: data.destination_id,
                        destination_type: data.destination_type,
                    }
                    break

                case 'end':
                    clonedObj = {
                        end_id: data.end_id,
                        type: 'end',
                        order: data.order
                    }
                    break

                case 'restart':
                    clonedObj = {
                        restart_id: data.end_id,
                        type: 'restart',
                    }
                    break
                case 'overview':
                    clonedObj = {
                        overview_id: data.end_id,
                        type: 'overview',
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
    },

    /*
    @method getAbsoluteBoundingRect
    @param {HTMLElement} el HTML element.
    @return {Object} Absolute bounding rect for _el_.
    */

    getAbsoluteBoundingRect: function(el) {
        var doc  = document,
            win  = window,
            body = doc.body,

            // pageXOffset and pageYOffset work everywhere except IE <9.
            offsetX = win.pageXOffset !== undefined ? win.pageXOffset :
                (doc.documentElement || body.parentNode || body).scrollLeft,
            offsetY = win.pageYOffset !== undefined ? win.pageYOffset :
                (doc.documentElement || body.parentNode || body).scrollTop,

            rect = el.getBoundingClientRect();

        if (el !== body) {
            var parent = el.parentNode;

            // The element's rect will be affected by the scroll positions of
            // *all* of its scrollable parents, not just the window, so we have
            // to walk up the tree and collect every scroll offset. Good times.
            while (parent !== body) {
                offsetX += parent.scrollLeft;
                offsetY += parent.scrollTop;
                parent   = parent.parentNode;
            }
        }

        return {
            bottom: rect.bottom + offsetY,
            height: rect.height,
            left  : rect.left + offsetX,
            right : rect.right + offsetX,
            top   : rect.top + offsetY,
            width : rect.width
        };
    },

    // calculate bind the group sizes to the DOM
    calculateGroups: function() {
        let groups,
            groupsBound;

            // get the groups
            groups = this.getGroups()

            for(let i = 0; i < groups.length; i++) {
                groups[i].data.size = {
                    width: groups[i].offsetWidth,
                    height: groups[i].offsetHeight
                }
            }

    },

    // check if we need to calclate the groups
    checkForGroupsCalc: function() {
        let groups = this.getGroups()

        // first time it gets called, calculate heights
        if(groups[0].data.size === undefined) {
            this.calculateGroups()
        }
    },

    arrangeGroups: function() {
        let groups,
            groupSize,
            groupsOffsetLeft,
            groupsHeight,
            groupsWidth;

        groups = this.getGroups()
        // get the groups
        this.checkForGroupsCalc()
        groupsHeight = 0
        // batch style changes for faster painting
        for(let i = 0; i < groups.length; i++) {
            groupSize = groups[i].data.size

            if(i === 0) {
                groupsWidth = groupSize.width * this.scaledSize
                if(groupsWidth < 350) {
                    groupsWidth = groupsWidth * 1.5 + 30
                } else {
                    groupsWidth = groupsWidth * 1.5 + 50
                }
            }

            console.log('width', groupSize.width)
            console.log('height', groupSize.height)
            groups[i].style.transform = 'translate3d('+groupsWidth+'px, '+groupsHeight + 'px, 0)'
            // add in the height of this one
            // an extra 110 seems to be about right for spacing
            groupsHeight = groupsHeight + groupSize.height  + 110
        }
        return groupsHeight
    },

    resetArrangeGroups: function() {
        let groups;
        groups = this.getGroups()
        if(groups[0].style.transform !== '') {
            for(let i = 0; i < groups.length; i++) {
                groups[i].style.transform = ''
            }
        }

    },
    // https://gist.github.com/conorbuck/2606166
    // p1 and p2 need x and y cordinates
    // p1 = {x: 12, y: 15}
    lineAngle: function(p1, p2) {
        let degrees;
        // angle in radians
        // let angleRadians = Math.atan2(p2.y - p1.y, p2.x - p1.x);
        // angle in degrees
        degrees = Math.atan2(p2.y - p1.y, p2.x - p1.x) * 180 / Math.PI;
        if(Math.sign(degrees) === -1) {
            degrees = degrees + 360
        }
        return degrees
    },

    displayArrowDirection: function() {
        let questions,
            destination,
            destinationPosition,
            destinationCoords,
            options,
            arrow,
            arrowPosition,
            arrowAngle,
            arrowCoords,
            arrowAngleNormalized;

        questions = this.getQuestions()
        // figure out arrow directions
        for(let q = 0; q < questions.length; q++) {

            options = this.getOptions(questions[q])

            for(let o = 0; o < options.length; o++) {
                if(options[o].data.destination_type === 'question') {
                    // see if the question and option destination are in
                    // the same column.
                    destination = this.getDestination(options[o].data.destination_id)
                    if(questions[q].data.group_id === destination.data.group_id) {
                        // if so, skip it (just use the down arrow)
                        continue;
                    }
                    // ok, they're in different columns, figure out what direction it needs to go
                    arrow = this.getDestinationIcon(options[o].data.option_id)
                    arrowPosition = this.getAbsoluteBoundingRect(arrow)
                    destinationPosition = this.getAbsoluteBoundingRect(destination)

                    arrowCoords = {y: arrowPosition.top + (arrowPosition.height/2)}
                    // we want the top third of the destination
                    destinationCoords = {y: destinationPosition.top + (destinationPosition.height/2)}


                        // we're going to an attachment
                    arrowCoords.x = arrowPosition.left + (arrowPosition.width/2)
                    destinationCoords.x = destinationPosition.left + (destinationPosition.width/2)

                    arrowAngle = this.lineAngle(arrowCoords, destinationCoords)

                    // adjust the arrow angle to be between 0 and 360 and


                    // now normalize it for 0 = pointing to right
                    arrowAngleNormalized = 360-arrowAngle
                    // arrow angle is between 70 and 120
                    if(80 < arrowAngleNormalized && arrowAngleNormalized < 90) {
                        this.templateArrowUpRight(arrow)
                    }
                    else if(90 < arrowAngleNormalized && arrowAngleNormalized < 100) {
                        this.templateArrowUpLeft(arrow)
                    }
                    // arrow angle is between 0-20 or 340-360
                    else if(arrowAngleNormalized < 10 || 350 < arrowAngleNormalized) {
                        // straight to the right (since we start with a down arrow)
                        this.templateArrow(arrow, 'arrow')
                        arrow.style.transform = 'rotate(180deg)'
                    }
                    else if(170 < arrowAngleNormalized && arrowAngleNormalized < 190) {
                        // straight to the left (since we start with a down arrow)
                        this.templateArrow(arrow, 'arrow')
                        arrow.style.transform = 'rotate(-180deg)'
                    }
                    // down and to the right
                    else if(270 < arrowAngleNormalized && arrowAngleNormalized < 280) {
                        // straight to the left (since we start with a down arrow)
                        this.templateArrowDownRight(arrow)
                    }
                    else if(260 < arrowAngleNormalized && arrowAngleNormalized < 270) {
                        // straight to the left (since we start with a down arrow)
                        this.templateArrowDownLeft(arrow)
                    } else {
                        this.templateArrow(arrow, 'arrow')
                        arrow.style.transform = 'rotate('+arrowAngle+'deg)'
                    }

                }

            }
        }
    },

    templateArrowUpRight(svg) {
        this.templateArrow(svg, 'arrow-turn')
        svg.style.transform = 'rotateX(-180deg)'
    },

    templateArrowUpLeft(svg) {
        this.templateArrow(svg, 'arrow-turn')
        svg.style.transform = 'rotate(180deg)'
    },

    templateArrowDownRight(svg) {
        this.templateArrow(svg, 'arrow-turn')
        svg.style.transform = 'rotate(0deg)'
    },

    templateArrowDownLeft(svg) {
        this.templateArrow(svg, 'arrow-turn')
        svg.style.transform = 'rotateX(-180deg)'
    },

    templateArrow(svg, iconName) {
        svg.children[0].setAttribute('xlink:href', '#icon-'+iconName)
        return svg
    }
}
