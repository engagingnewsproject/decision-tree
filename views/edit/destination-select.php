<template v-for="question in currentTree.questions">
  <option v-bind:value="question.ID">{{ question.title }}</option>
</template>
<template v-for="end in currentTree.ends">
  <option v-bind:value="end.ID">{{ end.title }}</option>
</template>
