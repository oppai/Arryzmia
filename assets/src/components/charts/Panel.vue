<template>
  <div class="charts-panel">
    <h5 class="charts-panel-title">{{ name }}</h5>
    <div class="charts-panel-value">
      {{ value }}
    </div>
  </div>
</template>

<script>
export default {
  props: ['name', 'value'],
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
div.charts-panel {
  padding: 20px;
  margin: 50px auto auto auto;
}
h5.charts-panel-title {
  font-size: 21px;
  padding: 0px;
  margin: 0px;
}
.charts-panel-value {
  font-size: 72px;
}
</style>
