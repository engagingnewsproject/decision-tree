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
          <div v-bind:id="'question--'+question.ID" class="element question" v-for="question in currentTree.questions">
            <form v-on:submit.prevent="saveElement(question.ID, 'question')">
              <label>
                <span class="visually-hidden">Question Title</span>
                <textarea rows="1" v-bind:id="'question-title--'+question.ID" class="element__title" v-on:blur="saveElement(question.ID, 'question')" v-on:keyup="setTextareaHeight" v-model="question.title"></textarea>
              </label>
              <input type="hidden" v-model="question.order" />
              <button class="element__save">Save</button>
            </form>
            <div class="option-wrapper" v-for="option in question.options">
              <form class="element__option" v-on:submit.prevent="saveElement(option.ID, 'option')">
                <label>
                  <span class="visually-hidden">Option Title</span>
                  <textarea rows="1" v-bind:id="'option-title--'+option.ID" class="element__title element__title--option" v-on:blur="saveElement(option.ID, 'option')" v-on:keyup="setTextareaHeight" v-model="option.title"></textarea>
                </label>
                <label>
                  <span class="visually-hidden">Destination</span>
                  <select v-bind:id="'option-destination--'+option.ID" class="element__destination" v-on:change="saveElement(option.ID, 'option')" v-model="option.destinationID">
                    <?php include 'destination-select.php'?>
                  </select>
                </label>
              </form>
            </div>
            <form class="option-create" v-on:submit.prevent="createOption(question.ID)">
              <input type="text" name="optionTitle" v-model="newEl.option.title"/>
              <label>
                <span class="visually-hidden">Destination</span>
                <select class="element__destination" v-model="newEl.option.destination">
                  <?php include 'destination-select.php'?>
                </select>
              </label>
              <button>Add Option</button>
            </form>

            <button class="btn btn--delete" v-on:click="deleteElement(question.ID, 'question')">Delete</button>
          </div>
        </div>

        <form v-on:submit.prevent="createElement('question')">
          <input type="text" name="elementTitle" v-model="newEl.question.title"/>
          <button>Add Question</button>
        </form>

        <h2>Ends</h2>
        <div class="ends">
          <div v-bind:id="'end--'+end.ID" class="element end" v-for="end in currentTree.ends">
            <form v-on:submit.prevent="saveElement(end.ID, 'end')">
              <label>
                <span class="visually-hidden">End Title</span>
                <textarea rows="1" v-bind:id="'end-title--'+end.ID" class="element__title" v-on:blur="saveElement(end.ID, 'end')" v-on:keyup="setTextareaHeight" v-model="end.title"></textarea>
              </label>
              <label>
                <span class="visually-hidden">End Content</span>
                <textarea rows="1" v-bind:id="'end-content--'+end.ID" class="element__content" v-on:blur="saveElement(end.ID, 'end')" v-on:keyup="setTextareaHeight" v-model="end.content"></textarea>
              </label>
              <button class="element__save">Save</button>
            </form>
            <button class="btn btn--delete" v-on:click="deleteElement(end.ID, 'end')">Delete</button>
          </div>
        </div>

        <form v-on:submit.prevent="createElement('end')">
          <label>
            Title
            <input type="text" name="elementTitle" v-model="newEl.end.title"/>
          </label>
          <label>
            Content
            <input type="text" name="elementContent" v-model="newEl.end.content"/>
          </label>
          <button>Add End</button>
        </form>

  </section>

</div>

<?php include_once 'footer.php';?>
