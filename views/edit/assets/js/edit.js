const treeServer = axios.create({
  baseURL: window.location.origin+'/api/v1',
  timeout: 1000,
  headers: {
    'X-API-Access': localStorage.getItem('accessToken'),
    'X-API-Client': localStorage.getItem('clientToken'),
  }
});

var app = new Vue({
  el: '#app',
  data () {
    return {
      trees: [], // keeps a history of all trees
      currentTree: undefined, // sets the most current version of the tree
      errored: false,
      loading: true,
      elTypes: ['question', 'end', 'start', 'group', 'option'],
      newEl: {
        title: null
      },
      sort: {
        sorting: {
          elType: null,
          from: null,
          to: null,
          el: null
        },
        sortables: []
      }
    }
  },
  mounted () {
    this.reMount();
  },
  methods: {
    reMount: function() {
      this.loading = true
      var lastScrollPos = window.scrollY
      treeServer
        .get('/trees/'+tree.ID+'/compiled?stats=false')
        .then(response => {
          let responseData = response.data
          this.trees.push(response.data)
          if(this.trees.length === 1) {
            let cloned = Object.assign({}, responseData)
            // if there's only one, add another (cloned so it won't store the reference)  so we have an original copy
            this.trees.push(JSON.parse(JSON.stringify(cloned)))
          }
          this.currentTree = this.trees[this.trees.length - 1]
        })
        .catch(error => {
          console.log(error)
          this.errored = true
        })
        .finally(() => {
          this.loading = false
          this.$nextTick(function () {
            // Code that will run only after the
            // entire view has been rendered
            this.setupSortable()
            // move to last scroll position so it doesn't jump back to top
            window.scrollTo(0, lastScrollPos);
            // set height on all text elements
            var e = {}
            var textareas = document.querySelectorAll('textarea')
            for(let i = 0; i < textareas.length; i++) {
              e.target = textareas[i]
              this.setTextareaHeight(e)
            }

          })
        })
    },
    saveTree: function () {
      treeServer
        .put(
          '/trees/'+currentTree.ID,
          {
            title: this.currentTree.title,
            slug: this.currentTree.slug
          })
        .then(response => (
          console.log(response.data)
        ))
        .catch(error => {
          console.log(error)
          this.errored = true
        })
    },
    saveElement: function (ID, elType) {
      let els, elIndex, el, elData, oldElData;
      // build the old one
      els = this.trees[this.trees.length - 2][elType+'s']
      elIndex = this.getIndexBy(els, 'ID', ID);
      el = els[elIndex]

      // call the data build dynamically
      oldElData = this.buildSave(el);

      // build the new one
      els = this.currentTree[elType+'s']
      elIndex = this.getIndexBy(els, 'ID', ID);
      el = els[elIndex]

      // call the data build dynamically
      elData = this.buildSave(el);

      // compare if the old and new match
      console.log(elData)
      console.log(oldElData)
      if(this.areObjectsEqual(elData, oldElData)) {
        console.log('no changes');
        return
      }
      console.log('saving', elData)
      // check that the title has actually changed
      treeServer
        .put(
          '/trees/'+tree.ID+'/'+elType+'s/'+ID,
          elData)
        .then(response => (
          console.log(response.data)
        ))
        .catch(error => {
          console.log(error)
          this.errored = true
        })
        .finally(() => this.reMount())

    },
    deleteElement: function(ID, elType) {
      alert('Are you sure? This will delete the element.');
      treeServer
        .delete(
          '/trees/'+tree.ID+'/'+elType+'s/'+ID)
        .then(response => (
          console.log(response.data)
          // if successful, then remove this element from the data array
        ))
        .catch(error => {
          console.log(error)
          this.errored = true
        })
        .finally(() => this.reMount())
    },
    createElement: function(elType) {
      treeServer
        .post(
          '/trees/'+tree.ID+'/'+elType+'s',
          this.newEl)
        .then(response => (
          console.log(response.data)
        ))
        .catch(error => {
          console.log(error)
          this.errored = true
        })
        .finally(
          () => {
            this.newEl.title = null
            this.reMount()
          })
    },
    buildSave: function(el) {
      let data = {}
      // allowed keys
      let whitelist = ['title','content','questionID','destination','questions'];

      for(let i = 0; i < whitelist.length; i++) {
        // check if the object key exists
        if(whitelist[i] in el) {

          data[whitelist[i]] = el[whitelist[i]]
          //data.assign(data, {whitelist[i]: el[whitelist[i]]})
        }
      }

      return data
    },
    setupSortable: function () {

      /*for(let i = 0; i < this.elTypes.length; i++) {
        let containerSelector = '.'+this.elTypes[i];
        let containers = document.querySelectorAll(containerSelector);

        if (containers.length === 0) {
          return false;
        }

        var sortable = new Sortable(containers, {
          draggable: this.elTypes[i],
          appendTo: containerSelector,
          mirror: {
            constrainDimensions: true,
          },
        });
      }*/
      console.log('setting up draggable');
      let containerSelector = '.questions';
      let containers = document.querySelectorAll(containerSelector);
      console.log(containers)
      if (containers.length === 0) {
        console.log('nothing found');
        return false;
      }


      this.sort.sortables['question'] = new Sortable.default(
        containers,
        {
          draggable: '.question',
          appendTo: containerSelector,
          mirror: {
            constrainDimensions: true,
          },
      })

      this.sort.sortables['question'].on('drag:start', (e) => {
        if(document.activeElement.nodeName !== 'DIV') {
          // cancel it and assign focus back to this element
          e.cancel()
        }
        this.sort.sorting.elType = 'question'
        this.sort.sorting.from = this.getElementIndex(e.data.source)
        this.sort.sorting.el = this.currentTree.questions[this.sort.sorting.from]
      });

      this.sort.sortables['question'].on('drag:stop', (e) => {
        // make element order match the updated data
        this.sort.sorting.to = this.getElementIndex(e.data.source)
        let to = this.sort.sorting.to
        let from = this.sort.sorting.from
        console.log(to)
        if(to !== from) {
          // save it
          if(to > from) {
            to = to -1 // draggable adds an element, thus making it seem like it's one higher in index than it really is when it's dropped
          }
          this.orderSave('question', this.sort.sorting.el, to)
        }
        // clear all values
        this.sort.sorting.elType = null
        this.sort.sorting.from = null
        this.sort.sorting.to = null
        this.sort.sorting.el = null
      });

    },

    getElementIndex: function(node) {
      var index = 0;
      while ( (node = node.previousElementSibling) ) {
          index++;
      }
      return index;
    },

    orderSave: function(elType, el, to) {
      treeServer
        .put(
          '/trees/'+tree.ID+'/'+elType+'s/'+el.ID+'/move/'+to)
        .then(response => (
          console.log(response.data)
        ))
        .catch(error => {
          console.log(error)
          this.errored = true
        })
        .finally(() => this.reMount())
    },
    setTextareaHeight: function(e) {

      e.target.style.height = (e.target.scrollHeight)+'px'
    },
    /**
    * Powers most all of the retrieval of data from the tree
    * Searches an array for a key that equals a certain value
    *
    * @param objArray (ARRAY of OBJECTS)
    * @param name (STRING) of the key you're wanting to find the matching value of
    * @param value (MIXED) the value you want to find a match for
    * @return INT of the index that matches or UNDEFINED if not found
    */
    getIndexBy: function(objArray, name, value){
        for (let i = 0; i < objArray.length; i++) {
            if (objArray[i][name] == value) {
                return i;
            }
        }
        return undefined;
    },
    areObjectsEqual(a, b) {
        // Create arrays of property names
        var aProps = Object.getOwnPropertyNames(a);
        var bProps = Object.getOwnPropertyNames(b);

        // If number of properties is different,
        // objects are not equivalent
        if (aProps.length != bProps.length) {
            return false;
        }

        for (var i = 0; i < aProps.length; i++) {
            var propName = aProps[i];

            // If values of same property are not equal,
            // objects are not equivalent
            if (a[propName] !== b[propName]) {
                return false;
            }
        }

        // If we made it this far, objects
        // are considered equivalent
        return true;
    }
  }
})
