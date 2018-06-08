<?php include_once 'header.php';?>

<div id="app"
    class="app"
    v-bind:class="{
      'app--error': errored,
      'app--loading': loading
    }">

  <section v-if="errored">
    <p>We're sorry, we're not able to retrieve this information at the moment, please try back later</p>
  </section>

  <section v-else>
    <div v-if="loading">Loading...</div>

    <div v-else class="tree container">
        <h2>Editing Tree: {{ currentTree.title }}</h2>
        <form v-on:submit.prevent="saveTree()" class="element">
          <label>
            Tree Title
            <input type="text" v-model="currentTree.title" />
          </label>
          <label>
            Tree Slug
            <input type="text" v-model="currentTree.slug" />
          </label>
          <button>Save</button>
        </form>

        <h2>Questions</h2>
        <div class="questions">
          <div v-bind:id="'question--'+question.id" class="element question" v-for="question in currentTree.questions">
            <form v-on:submit.prevent="saveElement(question.ID, 'question')">
              <label>
                <span class="visually-hidden">Question Title</span>
                <textarea rows="1" v-bind:id="'question-title--'+question.id" class="element__title" v-on:blur="saveElement(question.ID, 'question')" v-on:keyup="setTextareaHeight" v-model="question.title"></textarea>
              </label>
              <input type="hidden" v-model="question.order" />
              <button class="element__save">Save</button>
            </form>
            <button class="btn btn--delete" v-on:click="deleteElement(question.ID, 'question')">Delete</button>
          </div>
        </div>

        <form v-on:submit.prevent="createElement('question')">
          <input type="text" name="elementTitle" v-model="newEl.title"/>
          <button>Add Question</button>
        </form>

        <h2>Ends</h2>
        <div class="ends">
          <div v-bind:id="'end--'+end.id" class="element end" v-for="end in currentTree.ends">
            <form v-on:submit.prevent="saveElement(end.ID, 'end')">
              <label>
                <span class="visually-hidden">End Title</span>
                <textarea rows="1" v-bind:id="'end-title--'+end.id" class="element__title" v-on:blur="saveElement(end.ID, 'end')" v-on:keyup="setTextareaHeight" v-model="end.title"></textarea>
              </label>
              <label>
                Order
                <input type="number" v-model="end.order" />
              </label>
              <button class="element__save">Save</button>
            </form>
            <button class="btn btn--delete" v-on:click="deleteElement(end.ID, 'end')">Delete</button>
          </div>
        </div>

        <form v-on:submit.prevent="createElement('end')">
          <input type="text" name="elementTitle" v-model="newEl.title"/>
          <button>Add End</button>
        </form>

  </section>

</div>

<?php include_once 'footer.php';?>
