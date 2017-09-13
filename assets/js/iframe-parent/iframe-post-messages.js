function CmeIframeTree(data) {

    this.iframe = data.iframe
    this.iframeID = data.iframe.id
    this.treeID = data.treeID
    this.parentURL = data.parentURL
    this.siteName = this.setSiteName()
    this.saveEmbedSiteComplete = false
    this.saveEmbedTreeComplete = false
    this.embedSiteID = false
    this.embedTreeID = false

    // load it!
    this.onLoadIframe()
}

// getters and setters

CmeIframeTree.prototype = {
    constructor: CmeIframeTree,

    getSaveEmbedSiteComplete: function(){
        return this.saveEmbedSiteComplete
    },

    setSaveEmbedSiteComplete: function(val){
        if (typeof val !== 'boolean') {
            return
        }
        this.saveEmbedSiteComplete = val
    },

    getSaveEmbedTreeComplete: function(){
        return this.saveEmbedTreeComplete
    },

    setSaveEmbedTreeComplete: function(val){
        if (typeof val !== 'boolean') {
            return
        }
        this.saveEmbedTreeComplete = val
    },

    setSiteName: function(siteName) {
        siteName = this.getFBSiteNameMeta()
        // see if there's a Facebook OG:SiteName attribute, if not, return the current URL
        if(siteName && typeof siteName === 'string') {
            this.siteName = siteName
        } else {
            this.siteName = this.parentURL
        }
        return this.siteName
    },

    getSiteName: function() {
        return this.siteName
    },

    getFBSiteNameMeta: function() {
        var siteName = document.querySelector('meta[property="og:site_name"]');
        if(siteName) {
            return siteName.content;
        } else {
            return false;
        }
    },

    // What to do when we receive a postMessage
    receiveIframeMessage: function(origin, data) {
        var response;
        response = {};
        console.log('parent recieved message', data)

        // find out what we need to do with it
        if(data.action === 'treeHeight') {
            response.setTreeHeight = this.setTreeHeight(data.treeHeight);
        }
        // anytime there's a state update, scroll to the quiz, but not on load
        else if(data.action === 'update' && data.data.updatedBy !== 'forceCurrentState') {
             response.scrollToQuizResponse = this.scrollToQuiz();
        }
        else if(data.action === 'sendURL') {
            // send the url of the parent (that embedded the quiz)
            response.sendParentURLResponse = this.sendParentURL();
        } else if(data.action === 'saveSite') {
            // log embed
            this.saveEmbedSite(origin, data, this.handleEmbedSiteResponse, this);
        }

        // send a response sayin, yea, we got it!
        // event.source.postMessage("success!", event.origin);
        return response;
    },

    // what to do on load of an iframe
    onLoadIframe: function() {
        // write our styles that apply to ALL quizzes
        this.addIframeStyles();
        // call the quiz and get its height
        this.getQuizHeight();
        // call the quiz and send the URL of the page its embedded on
        this.sendParentURL();
        // call the quiz and send the URL of the page its embedded on
        this.sendSaveSite();
    },

    getQuizHeight: function() {
        var request;
        // send a postMessage to get the correct height
        request = '{"status":"request","action":"sendBodyHeight"}';
        this.iframe.contentWindow.postMessage(request, this.iframe.src);
    },

    sendSaveSite: function() {
        var request;
        // send a postMessage to get the correct height
        request = '{"status":"request","action":"sendSaveSite"}';
        this.iframe.contentWindow.postMessage(request, this.iframe.src);
    },

    /**
    * Send the full URL and path of the current page (the parent page)
    * so it can be appended in the Share URLs
    */
    sendParentURL: function() {
        var request;

        // first, check to make sure we're not on the quiz preview page.
        // If we are, we shouldn't send the URL because we don't want
        // to set the quiz preview URL as the share URL
        // to see what it matches: http://regexr.com/3g4rr
        if(/https?:\/\/(?:local.quiz|(?:(?:local|dev|test)\.)?engagingnewsproject\.org|(?:engagingnews|cmedev)\.(?:staging\.)?wpengine\.com)\/cme-quiz\/quiz-preview\/\d+\b/.test(this.parentURL)) {
            // if it equals one of our site preview pages, abandon ship
            return false;
        }

        // send a postMessage to get the correct height
        request = '{"status":"request","action":"setShareURL","parentURL":"'+this.parentURL+'"}';
        this.iframe.contentWindow.postMessage(request, this.iframe.src);
    },


    /**
    * Sets the height of the iframe on the page
    */
    setTreeHeight: function(height) {
        console.log(height)
        // set the height on the style
        this.iframe.style.height = height+'px';
        return height;
    },

    /**
    * Snaps the quiz to the top of the viewport, if needed
    */
    scrollToQuiz: function() {
        var response = false;
        // this will get the current quiz distance from the top of the viewport
        var distanceFromTopOfViewport = this.iframe.getBoundingClientRect().top;
        // see if we're within -20px and 100px of the question (negative numbers means we've scrolled PAST (down) the quiz)
        if( -20 < distanceFromTopOfViewport && distanceFromTopOfViewport < 100) {
            // Question likely within viewport. Do not scroll.
            response = 'noScroll';
        } else {
            // let's scroll them to the top of the next question (some browsers like iPhone Safari jump them way down the page)
            scrollBy(0, (distanceFromTopOfViewport - 10));
            response = 'scrolledTop';
        }
        return response;
    },

    addIframeStyles: function() {
        // set our styles
        var css = '.cme-tree__iframe { -webkit-transition: all .3s ease-in-out;transition: all .3s ease-in-out; }',
        head = document.head || document.getElementsByTagName('head')[0],
        style = document.createElement('style');

        style.type = 'text/css';
        if (style.styleSheet){
          style.styleSheet.cssText = css;
        } else {
          style.appendChild(document.createTextNode(css));
        }

        head.appendChild(style);
    },

    saveEmbedSite: function(origin, data, callback, boundThis) {
         if(this.getSaveEmbedSiteComplete() === true) {
             return false;
         }
         var response;
         var request = new XMLHttpRequest();

         request.open('POST', origin+'/sites/new');
         request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
         request.onreadystatechange = function () {
             if(request.readyState === XMLHttpRequest.DONE && request.status === 200) {
                  boundThis.setSaveEmbedSiteComplete(true);
                  response = JSON.parse(request.responseText);
                  if(response.status === 'success') {
                      response.origin = origin;
                      response.tree_id = data.tree_id;
                      if (typeof callback == "function") {
                          callback(response, boundThis);
                      }
                  } else {
                      console.log('XHR request for saveEmbedSite successful but returned response error: '+JSON.stringify(response));
                  }

              } else if (request.status !== 200) {
                  console.log('Request failed.  Returned status of ' + request.status);
              }
         };


         data.embed_site_url = this.parentURL;
         data.embed_site_name = this.getSiteName();


         request.send(JSON.stringify(data));
     },

     /**
     * What to do after we recieve a response about saving the embed site
     */
     handleEmbedSiteResponse: function(response, boundThis) {
         // set the site ID
         boundThis.embedSiteID = response.embed_site_id;
         if(0 < parseInt(boundThis.embedSiteID) ) {
             // send a request to save/update the cme_embed_tree table
             boundThis.saveEmbedTree(response, boundThis.handleEmbedTreeResponse, boundThis);
             return response;
         } else {
             console.log('Could\'t locate a valid Embed Site');
         }
     },

    saveEmbedTree: function(data, callback, boundThis) {
          if(this.getSaveEmbedTreeComplete() === true) {
              return false;
          }

          var response;
          var request = new XMLHttpRequest();

          request.open('POST', data.origin+'/sites/'+data.embed_site_id+'/embed/new');
          request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
          request.onreadystatechange = function () {
              if(request.readyState === XMLHttpRequest.DONE && request.status === 200) {
                  boundThis.setSaveEmbedTreeComplete(true);
                  response = JSON.parse(request.responseText);
                  if(response.status === 'success') {
                      if (typeof callback == "function") {
                          callback(response, boundThis);
                      }
                  } else {
                      console.log('XHR request for saveEmbedTree successful but returned response error: '+JSON.stringify(response));
                  }

              } else if (request.status !== 200) {
                  console.log('Request failed.  Returned status of ' + request.status);
              }
          };

          embed_tree = {
              'tree_id': data.tree_id,
              'embed_tree_url': this.parentURL,
          };

          request.send(JSON.stringify(embed_tree));
     },

    /**
    * What to do after we recieve a response about saving the embed site
    */
    handleEmbedTreeResponse: function(response, boundThis) {
      // set the embedTreeID
        boundThis.embedTreeID = response.embed_tree_id;
        if(0 < parseInt(boundThis.embedTreeID) ) {
            return response;
        } else {
            console.log('Could\'t locate a valid Embed Quiz');
        }
    }
}
