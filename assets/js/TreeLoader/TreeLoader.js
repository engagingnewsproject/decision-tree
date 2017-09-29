
(function () {

  function TreeLoader() {
    // Get Root Domain
    // get the current script being processed (this one)
    let scripts = document.querySelectorAll( 'script[src]' )
    let treeLoaderScript = scripts[ scripts.length - 1 ]

    this.rootURL = this.getRootURL(treeLoaderScript.src)
    this.treeSlug = this.getTreeSlug(treeLoaderScript.src)
    this.treeStyle = this.getTreeStyle(treeLoaderScript.src)

    this.createTreeContainer(this.treeSlug, treeLoaderScript)


    var resources = [{
                        src: this.rootURL+'/dist/js/cme-tree.min.js',
                        type: 'js'
                    },
                    {
                        src: this.rootURL+'/dist/css/'+this.treeStyle+'.min.css',
                        type: 'css'
                    }];


    var treeFilesLoaded = this.loadResources(resources).then(this.runCreateTree.bind(this));
  }

  TreeLoader.prototype = {
    constructor: TreeLoader,

    // Get our Script File Path for parsing
    getParameterByName: function(name, url) {
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    },


    getRootURL: function(url) {
        // regex it to see if it's one of our DEV urls
        let regex = /https?:\/\/(?:(?:localhost:3000|dev)\/decision-tree|(?:enptree)\.(?:staging\.)?wpengine\.com)\b/
        let rootURL = regex.exec(url)

        if(rootURL === null) {
            // we're not on DEV, so pass the rootURL as our PROD url
            rootURL = 'https://tree.mediaengagement.org'
        }

        return rootURL;
    },

    getTreeSlug: function(src) {
        // Get Tree Slug
        let treeSlug = this.getParameterByName('tree', src)
        if(treeSlug === null || treeSlug === '') {
            console.error('No tree specified. Add "?tree=slug-of-tree" to your URL, like this: https://tree.mediaengagement.org/dist/js/TreeLoader.min.js?tree=citizen')
        }
        return treeSlug
    },


    getTreeStyle: function(src) {
        // Get Style
        let treeStyle = this.getParameterByName('style', src)
        if(treeStyle === null || treeStyle === '') {
            treeStyle = 'base'
        }
        return treeStyle
    },

    createTreeContainer: function(treeSlug, insertItAfter) {
        // Create and insert container DIV
        let treeContainer = document.createElement('div')
        // set the ID
        treeContainer.id = 'cme-tree__'+treeSlug
        // insert the container after this
        insertItAfter.parentNode.insertBefore(treeContainer, insertItAfter.nextSibling)

        return treeContainer;
    },

    // Resources = [[{src: '/wutever.js', type: 'js'}, {src: '/wutever.css', type: 'css'}]]
    loadResources: function(resources) {

        var promises = [];

        for(let i = 0; i < resources.length; i++) {
            promises.push(this.loadResource(resources[i]));
        }

        return Promise.all(promises);
    },

    loadResource: function(resource) {
        // This promise will be used by Promise.all to determine success or failure
        return new Promise(function(resolve, reject) {
            var element,
                tag,
                attr,
                parent;
            switch(resource.type) {
              case 'js':
                tag = 'script'
                break
              case 'css':
                tag = 'link'
                break
            }

            element = document.createElement(tag);

            // Important success and error for the promise
            element.onload = function() {
                resolve(resource.src);
            };
            element.onerror = function() {
                reject(resource.src);
            };

            // Need to set different attributes depending on tag type
            switch(resource.type) {
              case 'js':
                element.type = 'text/javascript'
                element.async = true
                attr = 'src'
                parent = 'body'
                break;
              case 'css':
                element.type = 'text/css'
                element.rel = 'stylesheet'
                attr = 'href'
                parent = 'head'
                break;
            }

            // Inject into document to kick off loading
            element[attr] = resource.src;
            document[parent].appendChild(element);

        });
    },

    runCreateTree: function() {
        var treeOptions = {
            slug: this.treeSlug,
            container: document.getElementById('cme-tree__'+this.treeSlug)
        }
        window.createTree(treeOptions);
    }
  }

  // run the loader
  var treeLoader = new TreeLoader();
}(window));

