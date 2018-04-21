<template>
  <div class="password-generator">
      <password-display v-bind:password="password" v-bind:key="index" v-for="(password, index) in passwords" />
      <password-input name="Length" v-model="options.length" />
      <password-input name="Syllables" v-model="options.syllables" />
      <password-input name="Frequency" v-model="options.frequency" />
      <password-input name="Word Length" v-model="options.word_length" />
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
      options: { length: 4, syllables: 3, frequency: 10, word_length: 8 },
      words_db: [],

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
      var result = _(self.words_db)
          .filter(r => r.frequency <= self.options.frequency)
          .filter(r => r.length <= self.options.word_length)
          .filter(r => r.syllables <= self.options.syllables)
          .map(r => r.word)
          .value();

      return result;
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

      this.words_db = _.map(lines,
                            function (e) {
                                 var values = e.split(' ');
                                 return { word: values[0],
                                          length: values[1],
                                          syllables: values[2],
                                          frequency: values[3] }
                               });
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
