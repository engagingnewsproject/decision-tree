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


    <div v-else class="tree">

    <section>
    <h2>Editing Tree: {{ currentTree.title }}</h2>
    <div class="container">
      <form class="element">
        <label>
          Tree Title
          <input
            v-on:focus="setLastFocus"
            v-on:change="saveTree"
            type="text"
            v-model="currentTree.title"
            id="treeTitle"
            name="treeTitle" />
        </label>
        <label>
          Tree Slug
          <input v-on:focus="setLastFocus" v-on:change="saveTree" type="text" v-model="currentTree.slug"
          id="treeSlug"
          name="treeSlug" />
        </label>
        <button class="element__save">Save</button>
      </form>
    </div>
    </section>

    <section>
    <h2>Starts</h2>
    <!-- only allow one start -->
    <div class="starts container">
      <div v-bind:id="'start--'+start.ID" class="element start" v-for="(start, index) in currentTree.starts">
        <form v-on:submit.prevent="saveElement(start.ID, 'start')">
          <label>
            <span class="element__label">Start Title</span>
            <textarea
              v-on:focus="setLastFocus"
              rows="1"
              v-bind:id="'start-title--'+start.ID"
              class="element__title element__title--start"
              v-on:change="saveElement(start.ID, 'start')"
              v-on:keyup="setTextareaHeight"
              v-model="start.title"
              v-bind:placeholder="'Start Title '+(index+1)"></textarea>
          </label>
          <label>
              <span class="visually-hidden">Destination</span>
              <select
                v-on:focus="setLastFocus"
                v-bind:id="'start-destination--'+start.ID"
                class="element__destination"
                v-on:change="saveElement(start.ID, 'start')"
                v-model="start.destinationID">
                <?php include 'destination-select.php'?>
              </select>
            </label>
          <button class="element__save">Save</button>
        </form>
        <button class="btn btn--delete btn__delete-start" v-on:click="deleteElement(start.ID, 'start')"><svg class="icon icon--close"><use xlink:href="#close" /></svg></button>
      </div>

      <button class="btn btn--add" v-on:click="createElement('start')">+ Add Start</button>
    </div>
    </section>

    <section>
    <h2>Questions</h2>
    <div class="questions container">
      <div v-bind:id="'question--'+question.ID" class="element question" v-for="(question, index) in currentTree.questions">
        <form v-on:submit.prevent="saveElement(question.ID, 'question')">
          <label>
            <span class="element__label">Question Title</span>
            <textarea
              v-on:focus="setLastFocus"
              rows="1"
              v-bind:id="'question-title--'+question.ID"
              class="element__title element__title--question"
              v-on:change="saveElement(question.ID, 'question')"
              v-on:keyup="setTextareaHeight"
              v-model="question.title"
              v-bind:placeholder="'Question Title '+(index+1)"></textarea>
          </label>
          <input
            v-on:focus="setLastFocus"
            type="hidden"
            v-model="question.order" />
          <button class="element__save">Save</button>
        </form>
        <div class="options option-wrapper" v-for="(option, index) in question.options">
          <form class="element__option" v-on:submit.prevent="saveElement(option.ID, 'option')">
            <label>
              <span class="visually-hidden">Option Title</span>
              <textarea
                v-on:focus="setLastFocus"
                rows="1"
                v-bind:id="'option-title--'+option.ID"
                class="element__title element__title--option"
                v-on:change="saveElement(option.ID, 'option')"
                v-on:keyup="setTextareaHeight"
                v-model="option.title"
                v-bind:placeholder="'Option '+(index+1)"></textarea>
            </label>
            <label>
              <span class="visually-hidden">Destination</span>
              <select
                v-on:focus="setLastFocus"
                v-bind:id="'option-destination--'+option.ID"
                class="element__destination"
                v-on:change="saveElement(option.ID, 'option')"
                v-model="option.destinationID">
                <?php include 'destination-select.php'?>
              </select>
            </label>
          </form>

          <button v-if="option.order != 0"v-on:click="orderSave('option', option, option.order-1)" class="option__move option__move--up">↑</button>

          <button v-if="option.order < question.options.length - 1" v-on:click="orderSave('option', option, option.order+1)" class="option__move option__move--down">↓</button>

          <button class="btn btn--delete btn__delete-option" v-on:click="deleteElement(option.ID, 'option')"><svg class="icon icon--close"><use xlink:href="#close" /></svg></button>
        </div>

        <button class="btn btn--add" v-on:click="createOption(question.ID)">+ Add Option</button>

        <button class="btn btn--delete btn__delete-question" v-on:click="deleteElement(question.ID, 'question')"><svg class="icon icon--close"><use xlink:href="#close" /></svg></button>
      </div>

      <button class="btn btn--add" v-on:click="createElement('question')">+ Add Question</button>
    </div>

    </section>

    <section>
    <h2>Ends</h2>
    <div class="ends container">
      <div v-bind:id="'end--'+end.ID" class="element end" v-for="(end, index) in currentTree.ends">
        <form v-on:submit.prevent="saveElement(end.ID, 'end')">
          <label>
            <span class="element__label">End Title</span>
            <textarea
              v-on:focus="setLastFocus"
              rows="1"
              v-bind:id="'end-title--'+end.ID"
              class="element__title element__title--end"
              v-on:change="saveElement(end.ID, 'end')"
              v-on:keyup="setTextareaHeight"
              v-model="end.title"
              v-bind:placeholder="'End Title '+(index+1)"></textarea>
          </label>
          <label>
            <span class="element__label">End Content</span>
            <textarea
              v-on:focus="setLastFocus"
              rows="1"
              v-bind:id="'end-content--'+end.ID"
              class="element__content"
              v-on:change="saveElement(end.ID, 'end')"
              v-on:keyup="setTextareaHeight"
              v-model="end.content"
              v-bind:placeholder="'End Content '+(index+1)"></textarea>
          </label>
          <button class="element__save">Save</button>
        </form>
        <button class="btn btn--delete" v-on:click="deleteElement(end.ID, 'end')"><svg class="icon icon--close"><use xlink:href="#close" /></svg></button>
      </div>

      <button class="btn btn--add" v-on:click="createElement('end')">+ Add End</button>
    </div>
    </section>

    <section>
    <h2>Groups</h2>
    <div class="groups container">
      <div v-bind:id="'group--'+group.ID" class="element group" v-for="(group, index) in currentTree.groups">
        <form v-on:submit.prevent="saveElement(group.ID, 'group')">
          <label>
            <span class="element__label">Group Title</span>
            <textarea
              v-on:focus="setLastFocus"
              rows="1"
              v-bind:id="'group-title--'+group.ID"
              class="element__title element__title--group"
              v-on:change="saveElement(group.ID, 'group')"
              v-on:keyup="setTextareaHeight"
              v-model="group.title"
              v-bind:placeholder="'Group Title '+(index+1)"></textarea>
          </label>
          <label>
            <span class="element__label">Group Content</span>
            <textarea
              v-on:focus="setLastFocus"
              rows="1"
              v-bind:id="'group-content--'+group.ID"
              class="element__content"
              v-on:change="saveElement(group.ID, 'group')"
              v-on:keyup="setTextareaHeight"
              v-model="group.content"
              v-bind:placeholder="'Group Content '+(index+1)"></textarea>
          </label>
          <input
            v-on:focus="setLastFocus"
            type="hidden"
            v-model="group.order" />
          <select
            v-on:focus="setLastFocus"
            v-bind:id="'group-destination--'+group.ID"
            class="element__multiselect"
            v-on:blur="saveElement(group.ID, 'group')"
            v-model="group.questions"
            multiple>
            <option v-for="question in currentTree.questions" v-bind:value="question.ID">{{ question.title }}</option>
          </select>
          <button class="element__save">Save</button>
        </form>
        <button class="btn btn--delete" v-on:click="deleteElement(group.ID, 'group')"><svg class="icon icon--close"><use xlink:href="#close" /></svg></button>
      </div>
      <button class="btn btn--add" v-on:click="createElement('group')">+ Add Group</button>
    </div>
    </section>

    <section>
    <!-- compile -->
    <div class="compiled">

      <h2>Compile</h2>
      <div class="container">
        <p>After editing, click this button to update the data structure file with all stats so it can be used as an actual decision tree.</p>
        <button v-on:click="compile">Compile</button>
        <pre v-if="compiledResult" class="compiled-json">{{ compiledResult }}</pre>
      </div>
    </div>
    </section>
  </section>

</div>

<?php include_once 'footer.php';?>
