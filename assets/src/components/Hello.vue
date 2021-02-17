<template>
  <div>
    Hello World
    <vue-loading 
      type="spiningDubbles"
      color="#aaa"
      :size="{ width: '100px', height: '100px' }"
      >
    </vue-loading>
  </div>
</template>

<script>
import { VueLoading } from 'vue-loading-template'

export default {
  data() {
    return {}
  },
  mounted() {
  },
  methods: {
  },
  components: {
    VueLoading
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
