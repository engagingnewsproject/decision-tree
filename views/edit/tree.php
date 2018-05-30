<?php include_once 'header.php';?>

<div id="app">

  <section v-if="errored">
    <p>We're sorry, we're not able to retrieve this information at the moment, please try back later</p>
  </section>

  <section v-else>
    <div v-if="loading">Loading...</div>

    <div v-else class="tree">
        Editing Tree: {{ tree.title }}
        <form method="PUT" :action="apiPath + '/trees/' + tree.ID">
          <label>
            Tree Title
            <input type="text" v-model="tree.title" />
          </label>
          <label>
            Tree Slug
            <input type="text" v-model="tree.slug" />
          </label>
          <button>Save</button>
        </form>

        <h2>Questions</h2>
        <div v-for="question in tree.questions" class="question">
          <form method="put" :action="apiPath + '/trees/' + tree.ID + '/questions/' + question.ID" v-on:submit.prevent="saveElement(end.ID, 'end')">
            <label>
              Question Title
              <input type="text" v-model="question.title" />
            </label>
            <label>
              Order
              <input type="number" v-model="question.order" />
            </label>
            <button v-on:click="saveElement(question.ID, 'question')">Save</button>
            <button v-on:click="deleteElement(question.ID, 'question')">Delete</button>
          </form>
        </div>

        <h2>Ends</h2>
        <div v-for="end in tree.ends" class="end">
          <form method="put" :action="apiPath + '/trees/' + tree.ID + '/ends/' + end.ID" v-on:submit.prevent="saveElement(end.ID, 'end')">
            <label>
              End Title
              <input type="text" v-model="end.title" />
            </label>
            <label>
              Order
              <input type="number" v-model="end.order" />
            </label>
            <button>Save</button>
            <button v-on:click="deleteElement(end.ID, 'end')">Delete</button>
          </form>
        </div>

  </section>

</div>




<script type="text/javascript">
  // set the tree var
  var tree = <?php echo json_encode($tree->array());?>

  var app = new Vue({
    el: '#app',
    data () {
      return {
        apiPath: 'https://decision-tree.dev/api/v1',
        tree: null,
        errored: false,
        loading: true,
        user: {
          accessToken: localStorage.getItem('accessToken'),
          clientToken: localStorage.getItem('clientToken')
        }
      }
    },
    mounted () {
      axios
        .get(this.apiPath+'/trees/'+tree.ID+'/compiled?stats=false')
        .then(response => (
          this.tree = response.data
        ))
        .catch(error => {
          console.log(error)
          this.errored = true
        })
        .finally(() => this.loading = false)

    },
    methods: {
      reMount: function() {
        this.loading = true
        axios
          .get(this.apiPath+'/trees/'+tree.ID+'/compiled?stats=false')
          .then(response => (
            this.tree = response.data
          ))
          .catch(error => {
            console.log(error)
            this.errored = true
          })
          .finally(() => this.loading = false)
      },
      saveElement: function (ID, elType) {
        els = this.tree[elType+'s']
        elIndex = this.getIndexBy(els, 'ID', ID);
        el = els[elIndex]

        // call the data build dynamically
        elData = this.buildSave(el);
        console.log(elData)
        axios
          .put(
            this.apiPath+'/trees/'+tree.ID+'/'+elType+'s/'+ID,
            elData)
          .then(response => (
            console.log(response.data)
          ))
          .catch(error => {
            console.log(error)
            this.errored = true
          })


        // check if we have an order value, if so, we can move it
        if(!("order" in el)) {
          return
        }

        // try moving it
        axios
          .put(
            this.apiPath+'/trees/'+tree.ID+'/'+elType+'s/'+ID+'/move/'+el.order,
            {user: this.user})
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
        axios
          .delete(
            this.apiPath+'/trees/'+tree.ID+'/'+elType+'s/'+ID,
            {user: this.user})
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
      buildSave(el) {
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

        // add in our client and access token
        data.user = this.user

        return data
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
      }
    }

  })
</script>

<?php include_once 'footer.php';?>
