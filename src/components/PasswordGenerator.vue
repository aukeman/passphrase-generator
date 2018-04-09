<template>
  <div class="password-generator">
      <password-display v-bind:password="password" v-bind:key="password" v-for="password in passwords" />
      <password-input name="Minimum Length" v-model="options.length" />
      <password-input name="Special Characters" v-model="options.specialChars" />
      <password-input name="Upper Case" v-model="options.capitals" />
      <div>number of words in corpus: {{words.length}}</div>
  </div>
</template>

<script>

import PasswordDisplay from '@/components/PasswordDisplay'
import PasswordInput from '@/components/PasswordInput'

export default {
  name: 'PasswordGenerator',
  components: {
    PasswordDisplay,
    PasswordInput
  },
  data: function () {
    return {
      passwords: ['abc', 'def', 'ghi', 'jkl'],
      options: { length: 25, specialChars: 50, capitals: 75 },
      words: []
    }
  },
  created: function () {
    this.$http.get('static/dictionary.txt').then(function (response) {
      this.words = response.body.split('\n')
    })
  }
}
</script>

<style>
  .generated-password{
  border: 1px solid black;
  width: 300px;
  }
</style>
