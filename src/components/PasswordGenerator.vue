<template>
  <div class="password-generator">
      <password-display v-bind:password="password" v-bind:key="index" v-for="(password, index) in passwords" />
      <password-input name="Length" v-model="options.length" />
      <password-input name="Special Characters" v-model="options.specialChars" />
      <password-input name="Upper Case" v-model="options.capitals" />
      <div>number of words in corpus: {{words.length}}</div>
      <div>minimum length: {{min_length}}</div>
      <div>maximum length: {{max_length}}</div>
      <div>minimum syllables: {{min_syllables}}</div>
      <div>maximum syllables: {{max_syllables}}</div>
      <div>minimum frequency: {{min_frequency}}</div>
      <div>maximum frequency: {{max_frequency}}</div>
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
      words_db: {},

      min_length: 0,
      max_length: 0,

      min_syllables: 0,
      max_syllables: 0,

      min_frequency: 0,
      max_frequency: 0
    }
  },
  computed: {
    words: function () {
      var self = this;
      if (Object.keys(self.words_db).length === 0) {
        return [];
      } else {
        return Object.keys(self.words_db);
      }
    },
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
      var lines = response.body.split('\n')

      var minValues = lines.shift().split(' ')

      this.min_length = minValues[0]
      this.min_syllables = minValues[1]
      this.min_frequency = minValues[2]

      var maxValues = lines.shift().split(' ')

      this.max_length = maxValues[0]
      this.max_syllables = maxValues[1]
      this.max_frequency = maxValues[2]

      this.words_db = _.reduce(lines,
                               function (a, e) {
                                 var values = e.split(' ');
                                 a[values[0]] = {
                                   length: values[1],
                                   syllables: values[2],
                                   frequency: values[3]}
                                 return a
        },
        {})
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
