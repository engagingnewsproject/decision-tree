function CmeIframeTree(data) {

    this.iframe = data.iframe
    console.log(data.iframe)
    this.iframeID = data.iframe.id
    this.quizID = data.quizID
    this.abTestID = data.abTestID
    this.parentURL = data.parentURL
    this.siteName = this.setSiteName()
    this.saveEmbedSiteComplete = false
    this.saveEmbedQuizComplete = false
    this.embedSiteID = false
    this.embedQuizID = false

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

    getSaveEmbedQuizComplete: function(){
        return this.saveEmbedQuizComplete
    },

    setSaveEmbedQuizComplete: function(val){
        if (typeof val !== 'boolean') {
            return
        }
        this.saveEmbedQuizComplete = val
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
        if(data.action === 'setHeight') {
            response.setQuizHeight = this.setQuizHeight(data.height);
        } else if(data.action === 'scrollToQuiz' || data.action === 'quizRestarted') {
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
        if(/https?:\/\/(?:local.quiz|(?:(?:local|dev|test)\.)?engagingnewsproject\.org|(?:engagingnews|enpdev)\.(?:staging\.)?wpengine\.com)\/enp-quiz\/quiz-preview\/\d+\b/.test(this.parentURL)) {
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
    setQuizHeight: function(height) {
        // Test the data
        if(/([0-9])px/.test(height)) {
            // set the height on the style
            this.iframe.style.height = height;
            return height;
        } else {
            return false;
        }
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
        var css = '.cme-tree__iframe { -webkit-transition: all .25s ease-in-out;transition: all .25s ease-in-out; }',
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


    serialize: function(data) {
        var result = '';

        for(var key in data) {
            result += key + '=' + data[key] + '&';
        }
        result = result.slice(0, result.length - 1);
        return result;
    },

    saveEmbedSite: function(origin, data, callback, boundThis) {
         if(this.getSaveEmbedSiteComplete() === true) {
             return false;
         }
         var response;
         var xhr = new XMLHttpRequest();

         xhr.open('POST', origin+'/wp-content/plugins/enp-quiz/database/class-enp_quiz_save_embed.php');
         xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
         xhr.onreadystatechange = function () {
             if(xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                  boundThis.setSaveEmbedSiteComplete(true);
                  response = JSON.parse(xhr.responseText);
                  if(response.status === 'success') {
                      response.origin = origin;
                      response.quiz_id = data.quiz_id;
                      if (typeof callback == "function") {
                          callback(response, boundThis);
                      }
                  } else {
                      console.log('XHR request for saveEmbedSite successful but returned response error: '+JSON.stringify(response));
                  }

              } else if (xhr.status !== 200) {
                  console.log('Request failed.  Returned status of ' + xhr.status);
              }
         };


         data.embed_site_url = this.parentURL;
         data.embed_site_name = this.getSiteName();
         data.save = 'embed_site';
         data.action = 'insert';
         data.doing_ajax = 'true';


         xhr.send(encodeURI(this.serialize(data)));
     },

     /**
     * What to do after we recieve a response about saving the embed site
     */
     handleEmbedSiteResponse: function(response, boundThis) {
         // set the site ID
         boundThis.embedSiteID = response.embed_site_id;
         if(0 < parseInt(boundThis.embedSiteID) ) {
             // send a request to save/update the enp_embed_quiz table
             boundThis.saveEmbedQuiz(response, boundThis.handleEmbedQuizResponse, boundThis);
             return response;
         } else {
             console.log('Could\'t locate a valid Embed Site');
         }
     },

    saveEmbedQuiz: function(data, callback, boundThis) {
          if(this.getSaveEmbedQuizComplete() === true) {
              return false;
          }

          var response;
          var xhr = new XMLHttpRequest();

          xhr.open('POST', data.origin+'/wp-content/plugins/enp-quiz/database/class-enp_quiz_save_embed.php');
          xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
          xhr.onreadystatechange = function () {
              if(xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                  boundThis.setSaveEmbedQuizComplete(true);
                  response = JSON.parse(xhr.responseText);
                  if(response.status === 'success') {
                      if (typeof callback == "function") {
                          callback(response, boundThis);
                      }
                  } else {
                      console.log('XHR request for saveEmbedQuiz successful but returned response error: '+JSON.stringify(response));
                  }

              } else if (xhr.status !== 200) {
                  console.log('Request failed.  Returned status of ' + xhr.status);
              }
          };

          embed_quiz = {
              'save': 'embed_quiz',
              'embed_site_id': data.embed_site_id,
              'quiz_id': data.quiz_id,
              'embed_quiz_url': this.parentURL,
              'doing_ajax': 'true',
          };

          xhr.send(encodeURI(this.serialize(embed_quiz)));
     },

    /**
    * What to do after we recieve a response about saving the embed site
    */
    handleEmbedQuizResponse: function(response, boundThis) {
      // set the embedQuizID
        boundThis.embedQuizID = response.embed_quiz_id;
        if(0 < parseInt(boundThis.embedQuizID) ) {
            return response;
        } else {
            console.log('Could\'t locate a valid Embed Quiz');
        }
    }
}
