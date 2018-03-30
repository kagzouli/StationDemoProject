<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>

import SearchComponent from '@/components/SearchComponent/index.vue'

export default {
  name: 'App',
  components: { SearchComponent },
  data () {
    return {
      message: 'Test'
    }
  },
  methods: {
  },
  computed: {

  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
