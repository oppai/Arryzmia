<template>
  <div>
    <h3>GitHub Health Board of <a href="https://github.com/tokyo-metropolitan-gov/covid19" target="_blank">{{ this.repo }}</a></h3>
    <div class="dashboard">
      <div class="dashboard-issues">
        <h4>Issues</h4>
        <div class="dashboard-issues-chars">
          <chart :chart-data="issueDataset" :options="options" :width="400" />
          <panel name="Current" :value="currentOpenIssue" />
        </div>
      </div>
      <div class="dashboard-pulls">
        <h4>Pull Requests</h4>
        <div class="dashboard-pulls-chars">
          <chart :chart-data="pullDataset" :options="options" :width="400" />
          <panel name="Current" :value="currentOpenPull" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Chart from './charts/Chart.vue'
import Panel from './charts/Panel.vue'

export default {
  data() {
    return {
      repo: "tokyo-metropolitan-gov/covid19",
      issueDataset: null, pullDataset: null, currentOpenIssue: 0, currentOpenPull: 0,
      options: { responsive: false }
    }
  },
  mounted() {
    this
      .axios
      .get(`http://localhost:4000/api/dashboard/summary?repo=${this.repo}`)
      .then((response) => {
        const data = response.data.data
        this.issueDataset = {
          labels: data.issues.created_count_per_day.map((day) => ( day.date )),
          datasets: [
            {
              label: 'Open Issues',
              backgroundColor: '#f87979',
              data: data.issues.created_count_per_day.map((day) => ( day.count )),
            },
            {
              label: 'Close Issues',
              backgroundColor: '#7979f8',
              data: data.issues.closed_count_per_day.map((day) => ( day.count )),
            }
          ]
        }
        this.pullDataset = {
          labels: data.issues.closed_count_per_day.map((day) => ( day.date )),
          datasets: [
            {
              label: 'Open Pulls',
              backgroundColor: '#f87979',
              data: data.pulls.created_count_per_day.map((day) => ( day.count )),
            },
            {
              label: 'Close Pulls',
              backgroundColor: '#7979f8',
              data: data.pulls.closed_count_per_day.map((day) => ( day.count )),
            }
          ]
        }
        this.currentOpenIssue = data.issues.open_count
        this.currentOpenPull = data.pulls.open_count
      })
  },
  methods: {
  },
  components: {
    Chart,
    Panel
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
div.dashboard {
  display: flex;
  flex-wrap: wrap;
}

.dashboard-issues {
  width: 50%;
}
.dashboard-issues-chars {
  display: flex;
}

.dashboard-pulls {
  width: 50%;
}
.dashboard-pulls-chars {
  display: flex;
}
</style>
