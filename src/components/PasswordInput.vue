<template>
  <div class="password-input">
    <label>{{name}}</label>
    <input type="number" min="0" max="100" v-bind:value="value" v-on:input="onInput">
  </div>
</template>

<script>
export default {
  props: ['name', 'value'],
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
