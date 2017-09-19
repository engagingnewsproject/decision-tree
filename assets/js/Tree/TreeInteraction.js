/**
* Manages localStorage of current question state
* and previous states of the current decision tree path
* (so people can go back to previous questions)
*/
function TreeInteraction(options) {
    var _Tree,
        _rootURL,
        _postURL,
        _userID;
    /**
    * Private functions
    */
    var _setRootURL = function() {
        let scripts,
            currentScript,
            regex,
            rootURL;
        // get the current script being processed (this one)
        scripts = document.querySelectorAll( 'script[src]' )
        currentScript = scripts[ scripts.length - 1 ].src

        // regex it to see if it's one of our DEV urls
        // If you want to see what it matches/doesn't match, go here: http://regexr.com/3g4rc
        regex = /https?:\/\/(?:(?:localhost:3000|dev)\/decision-tree|(?:enptree)\.(?:staging\.)?wpengine\.com)\b/
        _rootURL = regex.exec(currentScript)

        if(rootURL === null) {
            // we're not on DEV, so pass the rootURL as our PROD url
            _rootURL = 'https://tree.mediaengagement.org'
        }

        return _rootURL
    }

    var _setUserID = function() {
        let userIDStorageName = 'treeUserID'
        let userID = localStorage.getItem(userIDStorageName)
        if(userID === null) {
             userID = ''
             for(let i = 0; i < 8; i++) {
                 userID = userID + Math.floor((1 + Math.random()) * 0x10000)
                   .toString(16)
                   .substring(1)
             }
             localStorage.setItem(userIDStorageName, userID)
        }

        _userID = userID

        return _userID
    }

    // getters
    this.getTree = function() { return _Tree}
    this.getRootURL = function() { return _rootURL}
    this.getPostURL = function() { return _postURL}
    this.getUserID = function() { return _userID}
    this.getUserIDStorageName = function() { return _userIDStorageName}

    // setters
    /**
    * Sets the parent Tree
    */
    this.setTree = function(Tree) {
        // only let it be set once
        if(_Tree === undefined) {
            _Tree = Tree
        }
        return _Tree
    }

    this.setPostURL = function() {
        _postURL = this.getRootURL()+'/api/v1/interactions/new';
        return _postURL
    }

    this.init = function() {
        // set the userID
        _setUserID()

        // set the post URL
        this.setPostURL()
    }

    // passes the data to the server
    this.saveInteraction = function(data) {
        let whitelist,
            validState,
            Tree,
            postURL,
            treeID;

        Tree = this.getTree()
        // Validate that it's a legit state
        validState = Tree.validateState(data.destination.type, data.destination.id)

        if(validState !== true) {
            console.error('Invalid Tree State');
            return new Promise(function(resolve, reject) {});
        }


        // validate interaction type
        whitelist = ['load', 'reload', 'start', 'restart', 'overview', 'option', 'history']

        // check allowed interaction types
        if(!whitelist.includes(data.interaction.type)) {
            console.error(data.interaction.type + " is not an allowed interaction. Allowed interactions are "+whitelist.toString())
        }


        postURL = this.getPostURL()
        treeID =  Tree.getTreeID()

        // combine data and our userID
        data = Object.assign(data, {user_id: this.getUserID(), tree_id: Tree.getTreeID()})

        return new Promise(function(resolve, reject) {

          var request = new XMLHttpRequest();
          // request.overrideMimeType("application/json");
          request.open('POST', postURL);
          request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");

          // When the request loads, check whether it was successful
          request.onload = function() {
            if (request.status === 200) {
            // If successful, resolve the promise by passing back the request response
              resolve(request);
            } else {
            // If it fails, reject the promise with a error message
              reject(Error('Tree data could not be saved:' + request.statusText));
            }
          };
          request.onerror = function() {
          // Also deal with the case when the entire request fails to begin with
          // This is probably a network error, so reject the promise with an appropriate message
              reject(Error('There was a network error.'));
          };

          console.log(data)
          // Send the request
          request.send(JSON.stringify(data));
        })
    }

    this.response = function(request) {
        // response from the server
        let data = JSON.parse(request.response)
        console.log('response', data)
    }

    // set the rootURL
    _setRootURL()

    // if a Tree was passed, Do whatever you need to do
    if(options.Tree) {
        this.build(options.Tree)
    }
}


TreeInteraction.prototype = {
    constructor: TreeInteraction,

    build: function(Tree) {
        this.setTree(Tree)
        this.init()
    },

    /**
    * Listen to parent Tree's emitted actions and handle accordingly
    */
    on: function(action, data) {
        let interaction;
        switch(action) {
            case 'ready':
                // data will be the tree itself
                this.build(data)
                break
            case 'historyCreate':
                // history loaded for the first time, so it's our first load
                this.saveLoad('load')
                break
            case 'historyReload':
                // save the reload
                this.saveLoad('reload')
                break
            case 'update':
                // if the update is from the TreeHistory,
                // ignore it, BC we're already saving their update (forceCurrentState) from the reload/load
                if(data.data.observer === 'TreeHistory') {
                    break
                }
                interaction = this.convertUpdateToInteraction(data)
                this.saveInteraction(interaction)
                    .then(this.response);
                break
            case 'overviewOptionInteraction':
                interaction = this.convertOverviewOptionToInteraction(data)
                this.saveInteraction(interaction)
                    .then(this.response);
                break
        }

    },

    /**
    * Let our Tree know about what actions we did
    */
    emit: function(action, item, data) {
        let Tree = this.getTree()
        switch(action) {
            case 'ready':
                // tell the Tree to let all the other observers know that the TreeInteraction class is ready
                Tree.message(item, data)
                break
            case 'saveInteraction':
                // tell the Tree to let all the other observers know that we saved data
                Tree.message(item, data)
                break
        }
    },


    /**
    * Saves load or reload from the TreeHistory
    * @param loadType (STRING) 'load' or 'reload'
    */
    saveLoad: function(loadType) {
        let Tree,
            data;

        Tree = this.getTree()
        // build our data
        data = {}

        // set the interaction
        data.interaction = {
            type: loadType,
            id: this.getTree().getTreeID()
        }

        // set the destination (whatever we loaded to)
        data.destination = this.getTree().getState()

        // save the interaction
        this.saveInteraction(data)
            .then(this.response);
    },

    /**
     * Takes the data structure from an update state response
     * and convertes it into the data structure we need to
     * save it on the server.
     */
    convertUpdateToInteraction: function(update) {
        let data,
            interactionType,
            interactionID,
            observer;

        console.log(update)
        data = {}
        interactionType = update.data.type
        interactionID = false
        observer = update.data.observer

        data.interaction = {}

        if(interactionType === 'option') {
            // pass the option_id
            interactionID = update.data.option_id
        }
        // check if it's a history click
        else if(observer === 'TreeHistoryView') {
            interactionType = 'history'
        }


        data.interaction.type = interactionType
        data.interaction.id = interactionID
        data.destination = update.newState

        return data;
    },


    /**
     * Takes the data structure from the option.data of an
     * overviewOptionInteraction and convertes it into the
     * data structure we need to save it on the server.
     * @param data should be the option_el.data
     */
    convertOverviewOptionToInteraction: function(data) {
        let interactionData;

        // build data
        interactionData = {
            interaction: {
                id: data.option_id,
                type: data.type // 'option'
            }
        }

        // add the destination (NOT THE QUESTION DESTINATION CUZ WE'RE STILL IN THE OVERVIEW STATE)
        // the current tree state will be type: 'overview', id: treeID
        interactionData.destination = this.getTree().getState()

        return interactionData;
    }


}
