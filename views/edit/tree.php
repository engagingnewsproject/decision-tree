<?php include_once 'header.php';?>

<div id="app"
    class="app"
    v-bind:class="{
      'app--error': errored,
      'app--loading': loading
    }">

  <section v-if="errored">
    <p>{{error.message}}</p>
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

    <h2>Starts</h2>
    <!-- only allow one start -->
    <div class="starts">
      <div v-bind:id="'start--'+start.ID" class="element start" v-for="start in currentTree.starts">
        <form v-on:submit.prevent="saveElement(start.ID, 'start')">
          <label>
            <span class="visually-hidden">Start Title</span>
            <textarea rows="1" v-bind:id="'start-title--'+start.ID" class="element__title element__title--start" v-on:change="saveElement(start.ID, 'start')" v-on:keyup="setTextareaHeight" v-model="start.title"></textarea>
          </label>
          <label>
              <span class="visually-hidden">Destination</span>
              <select v-bind:id="'start-destination--'+start.ID" class="element__destination" v-on:change="saveElement(start.ID, 'start')" v-model="start.destinationID">
                <?php include 'destination-select.php'?>
              </select>
            </label>
          <button class="element__save">Save</button>
        </form>
        <button class="btn btn--delete btn__delete-start" v-on:click="deleteElement(start.ID, 'start')">x</button>
      </div>
    </div>
    <h3>New Start</h3>
    <form class="element__create element__create--start" v-on:submit.prevent="createElement('start')">
      <label>
        <span class="visually-hidden">Start title</span>
        <input type="text" name="elementTitle" v-model="newEl.start.title"/>
      </label>
      <label>
          <span class="visually-hidden">Destination</span>
          <select class="element__destination" v-model="newEl.start.destinationID">
            <?php include 'destination-select.php'?>
          </select>
      </label>
      <button>Add Start</button>
    </form>

    <h2>Questions</h2>
    <div class="questions">
      <div v-bind:id="'question--'+question.ID" class="element question" v-for="question in currentTree.questions">
        <form v-on:submit.prevent="saveElement(question.ID, 'question')">
          <label>
            <span class="visually-hidden">Question Title</span>
            <textarea rows="1" v-bind:id="'question-title--'+question.ID" class="element__title element__title--question" v-on:change="saveElement(question.ID, 'question')" v-on:keyup="setTextareaHeight" v-model="question.title"></textarea>
          </label>
          <input type="hidden" v-model="question.order" />
          <button class="element__save">Save</button>
        </form>
        <div class="options option-wrapper" v-for="option in question.options">
          <form class="element__option" v-on:submit.prevent="saveElement(option.ID, 'option')">
            <label>
              <span class="visually-hidden">Option Title</span>
              <textarea rows="1" v-bind:id="'option-title--'+option.ID" class="element__title element__title--option" v-on:change="saveElement(option.ID, 'option')" v-on:keyup="setTextareaHeight" v-model="option.title"></textarea>
            </label>
            <label>
              <span class="visually-hidden">Destination</span>
              <select v-bind:id="'option-destination--'+option.ID" class="element__destination" v-on:change="saveElement(option.ID, 'option')" v-model="option.destinationID">
                <?php include 'destination-select.php'?>
              </select>
            </label>
          </form>

          <button v-if="option.order != 0"v-on:click="orderSave('option', option, option.order-1)" class="option__move option__move--up">↑</button>
          <button v-if="option.order < question.options.length - 1" v-on:click="orderSave('option', option, option.order+1)" class="option__move option__move--down">↓</button>

          <button class="btn btn--delete btn__delete-option" v-on:click="deleteElement(option.ID, 'option')">x</button>
        </div>
        <form v-if="addOption == question.ID" class="element__create element__create--option" v-on:submit.prevent="createOption(question.ID)">
          <label>
            <span class="visually-hidden">Option Title</span>
            <input type="text" name="optionTitle" class="create__title" v-model="newEl.option.title"/>
          </label>
          <label>
            <span class="visually-hidden">Destination</span>
            <select class="element__destination" v-model="newEl.option.destinationID">
              <?php include 'destination-select.php'?>
            </select>
          </label>
          <button>Add Option</button>
        </form>
        <button v-if="addOption != question.ID" v-on:click="toggleAddOption(question.ID)">+</button>

        <button class="btn btn--delete btn__delete-question" v-on:click="deleteElement(question.ID, 'question')">x</button>
      </div>
    </div>

    <h3>New Question</h3>
    <form class="element__create element__create--question" v-on:submit.prevent="createElement('question')">
      <label>
        <span class="visually-hidden">Question title</span>
        <input type="text" name="elementTitle" v-model="newEl.question.title"/>
      </label>
      <button>Add Question</button>
    </form>

    <h2>Ends</h2>
    <div class="ends">
      <div v-bind:id="'end--'+end.ID" class="element end" v-for="end in currentTree.ends">
        <form v-on:submit.prevent="saveElement(end.ID, 'end')">
          <label>
            <span class="visually-hidden">End Title</span>
            <textarea rows="1" v-bind:id="'end-title--'+end.ID" class="element__title element__title--end" v-on:change="saveElement(end.ID, 'end')" v-on:keyup="setTextareaHeight" v-model="end.title"></textarea>
          </label>
          <label>
            <span class="visually-hidden">End Content</span>
            <textarea rows="1" v-bind:id="'end-content--'+end.ID" class="element__content" v-on:change="saveElement(end.ID, 'end')" v-on:keyup="setTextareaHeight" v-model="end.content"></textarea>
          </label>
          <button class="element__save">Save</button>
        </form>
        <button class="btn btn--delete" v-on:click="deleteElement(end.ID, 'end')">x</button>
      </div>
    </div>

    <h3>New End</h3>
    <form class="element__create element__create--end"  v-on:submit.prevent="createElement('end')">
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


    <h2>Groups</h2>
    <div class="groups">
      <div v-bind:id="'group--'+group.ID" class="element group" v-for="group in currentTree.groups">
        <form v-on:submit.prevent="saveElement(group.ID, 'group')">
          <label>
            <span class="visually-hidden">Group Title</span>
            <textarea rows="1" v-bind:id="'group-title--'+group.ID" class="element__title element__title--group" v-on:change="saveElement(group.ID, 'group')" v-on:keyup="setTextareaHeight" v-model="group.title"></textarea>
          </label>
          <label>
            <span class="visually-hidden">Group Content</span>
            <textarea rows="1" v-bind:id="'group-content--'+group.ID" class="element__content" v-on:change="saveElement(group.ID, 'group')" v-on:keyup="setTextareaHeight" v-model="group.content"></textarea>
          </label>
          <input type="hidden" v-model="group.order" />
          <select v-bind:id="'group-destination--'+group.ID" class="element__destination" v-on:blur="saveElement(group.ID, 'group')" v-model="group.questions" multiple>
            <option v-for="question in currentTree.questions" v-bind:value="question.ID">{{ question.title }}</option>
          </select>
          <button class="element__save">Save</button>
        </form>
        <button class="btn btn--delete" v-on:click="deleteElement(group.ID, 'group')">x</button>
      </div>
    </div>

    <h3>New Group</h3>
    <form class="element__create element__create--group"  v-on:submit.prevent="createElement('group')">
      <label>
        Title
        <input type="text" name="elementTitle" v-model="newEl.group.title"/>
      </label>
      <label>
        Content
        <input type="text" name="elementContent" v-model="newEl.group.content"/>
      </label>
      <select v-model="newEl.group.questions" multiple>
        <option v-for="question in currentTree.questions" v-bind:value="question.ID">{{ question.title }}</option>
      </select>
      <button>Add Group</button>
    </form>

    <!-- compile -->
    <div class="compiled">
      <h2>Compile</h2>
      <p>After editing, click this button to update the data structure file with all stats so it can be used as an actual decision tree.</p>
      <button v-on:click="compile">Compile</button>
      <pre v-if="compiledResult" class="compiled-json">{{ compiledResult }}</pre>
    </div>
  </section>

</div>

<?php include_once 'footer.php';?>
