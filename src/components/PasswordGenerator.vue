<template>
  <div class="password-generator">
      <password-display v-bind:password="password" v-bind:key="index" v-for="(password, index) in passwords" />
      <password-input name="Length" v-model="options.length" />
      <password-input name="Special Characters" v-model="options.specialChars" />
      <password-input name="Upper Case" v-model="options.capitals" />
      <div>number of words in corpus: {{words.length}}</div>
  </div>
</template>

<script>

import PasswordDisplay from '@/components/PasswordDisplay'
import PasswordInput from '@/components/PasswordInput'
import _ from 'lodash'

export default {
  name: 'PasswordGenerator',
  components: {
    PasswordDisplay,
    PasswordInput
  },
  data: function () {
    return {
      number_of_passwords: 5,
      options: { length: 4, specialChars: 50, capitals: 75 },
      words: []
    }
  },
  computed: {
    passwords: function () {
      var self = this
      if (self.words.length === 0) {
        return _.times(self.number_of_passwords, function () { return '' })
      } else {
        return _.times(self.number_of_passwords, function () {
          return _.times(self.options.length, function () {
            return self.words[Math.floor(Math.random() * self.words.length)]
          }).join(' ')
        })
      }
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
