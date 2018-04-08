<template>
    <div class="password">{{password}}</div>
</template>

<script>
export default {
  name: 'password-display',
  props: ['password']
}
</script>

<style>
  .password{
  border: 1px solid black;
  width: 300px;
  }
</style>
