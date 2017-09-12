/**
* Sends postmessages to the parent iframe if there is one
*/
function TreePostMessage(options) {
    var _Tree;

    // getters
    this.getTree = function() {
        return _Tree}

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

    this.init = function() {
        // add our event listener for postmessages
        window.addEventListener("message", this.recieveMessage.bind(this), false);
    }

    // if a Tree was passed, Do whatever you need to do
    if(options.Tree) {
        this.build(options.Tree)
    }

}


TreePostMessage.prototype = {
    constructor: TreePostMessage,

    build: function(Tree) {
        this.setTree(Tree)
        this.init()
    },

    /**
    * Listen to parent Tree's emitted actions and handle accordingly
    */
    on: function(action, data) {
        switch(action) {
            case 'ready':
                // data will be the tree itself
                this.build(data)
                break
        }
        // pass the message on to the parent
        // add the action to our data to pass
        data.action = action
        this.postIt(data)
    },

    // send the postmessage
    postIt: function(data) {
        if(typeof data !== 'object') {
            console.error('PostMessage data is not an object')
            return false
        }
        data.tree_id = this.getTree().getTreeID()
        console.log('postIt send', data)

        // allow all domains to access this info (*)
        parent.postMessage(JSON.stringify(data), "*");
        // if you want to see what was sent
        return data;
    },

    recieveMessage: function(event) {
        let data;
        // check to make sure we received a string
        if(typeof event.data !== 'string') {
            return false;
        }
        // get the data
        data = event.data;

        // see what they want to do
        console.log('Iframe Recieved Message', data)
        // they want us to send something... what do they want to send?
        // if they want the bodyHeight, then send the bodyHeight!
        /*if(data.action === 'sendBodyHeight') {
            sendBodyHeight();
        } else if(data.action === 'setShareURL') {
            setShareURL(data.parentURL);
            setCalloutURL(data.parentURL);
        } else if(data.action === 'sendSaveSite') {
            sendSaveSite();
        }*/
    }
}
