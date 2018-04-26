<template>
  <div class="password-input">
    <label>{{name}}</label>
    <input type="number" v-bind:value="value" v-bind:min="min" v-bind:max="max" v-on:input="onInput">
  </div>
</template>

<script>
export default {
  props: ['name', 'min', 'max', 'value'],
  methods: {
    onInput: function (e) {
      let value = parseInt(e.target.value)
      let min = parseInt(e.target.min)
      let max = parseInt(e.target.max)

      if (value < min || isNaN(value)) {
        value = e.target.value = min
      } else if (max < value) {
        value = e.target.value = max
      }

      this.$emit('input', value)
    }
  }
}
</script>

<style>
</style>
