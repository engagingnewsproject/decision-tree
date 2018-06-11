'use strict';

var treeServer = axios.create({
  baseURL: window.location.origin + '/api/v1',
  timeout: 1000,
  headers: {
    'X-API-Access': localStorage.getItem('accessToken'),
    'X-API-Client': localStorage.getItem('clientToken')
  }
});

var app = new Vue({
  el: '#app',
  data: function data() {
    return {
      trees: [], // keeps a history of all trees
      currentTree: undefined, // sets the most current version of the tree
      errored: false,
      loading: true,
      elTypes: ['question', 'end', 'start', 'group', 'option'],
      newEl: { // store the data for elements that are getting created
        question: {
          title: null
        },
        option: {
          questionID: null,
          title: null,
          destination: ''
        },
        end: {
          title: null,
          content: null
        }
      },
      sort: {
        sorting: {
          elType: null,
          from: null,
          to: null,
          el: null
        },
        sortables: [],
        whitelist: ['question']
      }
    };
  },
  mounted: function mounted() {
    this.reMount();
  },

  methods: {
    reMount: function reMount() {
      var _this = this;

      this.loading = true;
      var lastScrollPos = window.scrollY;
      treeServer.get('/trees/' + tree.ID + '/compiled?stats=false').then(function (response) {
        var responseData = response.data;
        _this.trees.push(response.data);
        if (_this.trees.length === 1) {
          var cloned = Object.assign({}, responseData);
          // if there's only one, add another (cloned so it won't store the reference)  so we have an original copy
          _this.trees.push(JSON.parse(JSON.stringify(cloned)));
        }
        _this.currentTree = _this.trees[_this.trees.length - 1];
      }).catch(function (error) {
        console.error(error);
        _this.errored = true;
      }).finally(function () {
        _this.loading = false;
        _this.$nextTick(function () {
          // Code that will run only after the
          // entire view has been rendered
          for (var i = 0; i < this.sort.whitelist.length; i++) {
            this.setupSortable(this.sort.whitelist[i]);
          }

          // move to last scroll position so it doesn't jump back to top
          window.scrollTo(0, lastScrollPos);
          // set height on all text elements
          var e = {};
          var textareas = document.querySelectorAll('textarea');
          for (var _i = 0; _i < textareas.length; _i++) {
            e.target = textareas[_i];
            this.setTextareaHeight(e);
          }
        });
      });
    },
    saveTree: function saveTree() {
      var _this2 = this;

      treeServer.put('/trees/' + this.currentTree.ID, {
        title: this.currentTree.title,
        slug: this.currentTree.slug
      }).then(function (response) {
        return console.log(response.data);
      }).catch(function (error) {
        console.log(error);
        _this2.errored = true;
      });
    },
    saveElement: function saveElement(ID, elType) {
      var _this3 = this;

      var els = void 0,
          elIndex = void 0,
          el = void 0,
          elData = void 0,
          oldElData = void 0;
      // build the old one
      els = this.trees[this.trees.length - 2][elType + 's'];
      elIndex = this.getIndexBy(els, 'ID', ID);
      el = els[elIndex];

      // call the data build dynamically
      oldElData = this.buildSave(el);

      // build the new one
      els = this.currentTree[elType + 's'];
      elIndex = this.getIndexBy(els, 'ID', ID);
      el = els[elIndex];

      // call the data build dynamically
      elData = this.buildSave(el);

      // compare if the old and new match
      if (this.areObjectsEqual(elData, oldElData)) {
        console.log('no changes');
        return;
      }
      // check that the title has actually changed
      treeServer.put('/trees/' + tree.ID + '/' + elType + 's/' + ID, elData).then(function (response) {
        return console.log(response.data);
      }).catch(function (error) {
        console.log(error);
        _this3.errored = true;
      }).finally(function () {
        return _this3.reMount();
      });
    },
    deleteElement: function deleteElement(ID, elType) {
      var _this4 = this;

      var path, question;
      alert('Are you sure? This will delete the element.');

      path = '/trees/' + tree.ID + '/' + elType + 's/' + ID;
      if (elType === 'option') {

        // find the question so we can get the question ID
        question = this.getQuestionByOption(ID);
        // set the path
        path = '/trees/' + tree.ID + '/questions/' + question.ID + '/options/' + ID;
      }

      treeServer.delete(path).then(function (response) {
        return console.log(response.data)
        // if successful, then remove this element from the data array
        ;
      }).catch(function (error) {
        console.log(error);
        _this4.errored = true;
      }).finally(function () {
        return _this4.reMount();
      });
    },
    createElement: function createElement(elType) {
      var _this5 = this;

      var path = '/trees/' + tree.ID + '/' + elType + 's';
      if (elType === 'option') {
        path = '/trees/' + tree.ID + '/questions/' + this.newEl.option.questionID + '/options';
      }
      treeServer.post(path, this.newEl[elType]).then(function (response) {
        return console.log(response.data);
      }).catch(function (error) {
        console.log(error);
        _this5.errored = true;
      }).finally(function () {
        _this5.newEl[elType].title = null;
        _this5.newEl[elType].content = null;
        _this5.newEl[elType].questionID = null;
        _this5.newEl[elType].destination = null;
        _this5.reMount();
      });
    },
    buildSave: function buildSave(el) {
      var data = {};
      // allowed keys
      var whitelist = ['title', 'content', 'questionID', 'destination', 'questions'];

      for (var i = 0; i < whitelist.length; i++) {
        // check if the object key exists
        if (whitelist[i] in el) {

          data[whitelist[i]] = el[whitelist[i]];
          //data.assign(data, {whitelist[i]: el[whitelist[i]]})
        }
      }

      return data;
    },
    createOption: function createOption(questionID) {
      this.newEl['option'].questionID = questionID;
      this.createElement('option');
    },
    setupSortable: function setupSortable(el) {
      var _this6 = this;

      var containerSelector = '.' + el + 's';
      var containers = document.querySelectorAll(containerSelector);
      if (containers.length === 0) {
        console.log('no sortable found for ' + el);
        return false;
      }

      this.sort.sortables[el] = new Sortable.default(containers, {
        draggable: '.' + el,
        appendTo: containerSelector,
        mirror: {
          constrainDimensions: true
        }
      });

      this.sort.sortables[el].on('drag:start', function (e) {
        if (document.activeElement.nodeName !== 'DIV') {
          // cancel it and assign focus back to this element
          e.cancel();
        }
        _this6.sort.sorting.elType = el;
        _this6.sort.sorting.from = _this6.getElementIndex(e.data.source);
        _this6.sort.sorting.el = _this6.currentTree[el + 's'][_this6.sort.sorting.from];
      });

      this.sort.sortables[el].on('drag:stop', function (e) {
        // make element order match the updated data
        _this6.sort.sorting.to = _this6.getElementIndex(e.data.source);
        var to = _this6.sort.sorting.to;
        var from = _this6.sort.sorting.from;
        if (to !== from) {
          // save it
          if (to > from) {
            to = to - 1; // draggable adds an element, thus making it seem like it's one higher in index than it really is when it's dropped
          }
          _this6.orderSave(el, _this6.sort.sorting.el, to);
        }
        // clear all values
        _this6.sort.sorting.elType = null;
        _this6.sort.sorting.from = null;
        _this6.sort.sorting.to = null;
        _this6.sort.sorting.el = null;
      });
    },

    orderSave: function orderSave(elType, el, to) {
      var _this7 = this;

      var path = '/trees/' + tree.ID + '/' + elType + 's/' + el.ID + '/move/' + to;
      if (elType === 'option') {
        // find the question so we can get the question ID
        var question = this.getQuestionByOption(el.ID);
        path = '/trees/' + tree.ID + '/questions/' + question.ID + '/options/' + el.ID + '/move/' + to;
      }
      treeServer.put(path).then(function (response) {
        return console.log(response.data);
      }).catch(function (error) {
        console.log(error);
        _this7.errored = true;
      }).finally(function () {
        return _this7.reMount();
      });
    },
    setTextareaHeight: function setTextareaHeight(e) {
      e.target.style.height = e.target.scrollHeight + 'px';
    },

    getElementIndex: function getElementIndex(node) {
      var index = 0;
      while (node = node.previousElementSibling) {
        index++;
      }
      return index;
    },
    getOption: function getOption(ID) {
      var questions = void 0,
          option = void 0,
          optionIndex = void 0;
      questions = this.currentTree.questions;
      // loop through questions and find the option if one matches
      for (var i = 0; i < questions.length; i++) {
        // try to find the option match in this
        optionIndex = this.getIndexBy(questions[i].options, 'ID', ID);
        if (optionIndex !== undefined) {
          return questions[i].options[optionIndex];
        }
      }
      return undefined;
    },

    // find a question ID by an option ID
    getQuestionByOption: function getQuestionByOption(ID) {
      var questions = void 0,
          option = void 0,
          optionIndex = void 0;
      questions = this.currentTree.questions;
      // loop through questions and find the option if one matches
      for (var i = 0; i < questions.length; i++) {
        // try to find the option match in this
        optionIndex = this.getIndexBy(questions[i].options, 'ID', ID);
        if (optionIndex !== undefined) {
          return questions[i];
        }
      }
      return undefined;
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
    getIndexBy: function getIndexBy(objArray, name, value) {
      for (var i = 0; i < objArray.length; i++) {
        if (objArray[i][name] == value) {
          return i;
        }
      }
      return undefined;
    },
    areObjectsEqual: function areObjectsEqual(a, b) {
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
});