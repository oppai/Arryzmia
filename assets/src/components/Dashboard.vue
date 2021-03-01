<template>
  <div>
    <h1>GitHub Health Board of <a href="https://github.com/tokyo-metropolitan-gov/covid19" target="_blank">{{ this.repo }}</a></h1>
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
      api_url: process.env.VUE_APP_API,
      issueDataset: null, pullDataset: null, currentOpenIssue: 0, currentOpenPull: 0,
      options: { responsive: false }
    }
  },
  mounted() {
    this
      .axios
      .get(`${this.api_url}/api/dashboard/summary?repo=${this.repo}`)
      .then((response) => {
        const data = response.data.data
        const issueData = this.dataOf(data.issues)
        const pullData = this.dataOf(data.pulls)

        this.issueDataset = {
          labels: issueData.days,
          datasets: [
            {
              label: 'Total Issues',
              type: 'line',
              fill: false,
              backgroundColor: '#f8f879',
              data: issueData.countPerDay,
            },
            {
              label: 'Open Issues',
              backgroundColor: '#f87979',
              data: issueData.openPerDay,
            },
            {
              label: 'Closed Issues',
              backgroundColor: '#7979f8',
              data: issueData.closedPerDay,
            }
          ]
        }
        this.pullDataset = {
          labels: pullData.days,
          datasets: [
            {
              label: 'Total pulls',
              type: 'line',
              fill: false,
              backgroundColor: '#f8f879',
              data: pullData.countPerDay,
            },
            {
              label: 'Open Pulls',
              backgroundColor: '#f87979',
              data: pullData.openPerDay,
            },
            {
              label: 'Close Pulls',
              backgroundColor: '#7979f8',
              data: pullData.closedPerDay,
            }
          ]
        }
        this.currentOpenIssue = data.issues.open_count
        this.currentOpenPull = data.pulls.open_count
      })
  },
  methods:{
    dataOf: (issues) => {
      const issueCountPerDay = issues.created_count_per_day.reduce((acc, v, i) => {
        const last = acc[acc.length - 1]
        const closed = issues.closed_count_per_day[i]
        return acc.concat(last - v.count + closed.count)
      }, [issues.open_count]).slice(0,-1)
      return {
        days: issues.created_count_per_day.map((day) => ( day.date )),
        countPerDay: issueCountPerDay,
        openPerDay: issues.created_count_per_day.map((day) => ( day.count )),
        closedPerDay: issues.closed_count_per_day.map((day) => ( -day.count )),
      }
    }
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
}
.dashboard-issues-chars {
  display: flex;
}

.dashboard-pulls {
}
.dashboard-pulls-chars {
  display: flex;
}
</style>
