<option disabled value="">Please select one</option>
<option v-for="question in currentTree.questions"  v-bind:value="question.ID">{{ question.title }}</option>
<option v-for="end in currentTree.ends" v-bind:value="end.ID">{{ end.title }}</option>
