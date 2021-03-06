<template>
  <div>
    <h1>GitHub Health Board of <a href="https://github.com/tokyo-metropolitan-gov/covid19" target="_blank">{{ this.repo }}</a></h1>
    <div class="dashboard">
      <div class="dashboard-group dashboard-deploys">
        <h4>Deployments</h4>
        <div class="dashboard-issues-chars">
          <chart :chart-data="deployDataset" :options="options.wide" :width="900" />
        </div>
      </div>
      <div class="dashboard-group dashboard-pulls-lifetime">
        <h4>Development Lifetime (For a month)</h4>
        <div class="dashboard-lifetime-chars">
          <panel name="Active PRs" :value="lifetimeOfPull.countOfAll" />
          <panel name="Average PR LifeTime(min)" :value="lifetimeOfPull.average" />
        </div>
      </div>
      <div class="dashboard-group dashboard-pulls">
        <h4>Pull Requests</h4>
        <div class="dashboard-pulls-chars">
          <chart :chart-data="pullDataset" :options="options.middle" :width="400" />
          <div>
            <panel name="Current" :value="currentOpenPull" />
            <panel name="Old(< 1 month)" :value="countOfOldPull" />
          </div>
        </div>
      </div>
      <div class="dashboard-group dashboard-issues">
        <h4>Issues</h4>
        <div class="dashboard-issues-chars">
          <chart :chart-data="issueDataset" :options="options.middle" :width="400" />
          <panel name="Current" :value="currentOpenIssue" />
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
      apiUrl: process.env.VUE_APP_API,
      issueDataset: null, pullDataset: null, deployDataset: null,
      currentOpenIssue: 0, currentOpenPull: 0,
      countOfOldPull: 0,
      lifetimeOfPull: {
        countOfAll: 0,
        average: 0
      },
      dashbordWidth: window.innerWidth * 0.8,
      options: {
        middle: { responsive: false },
        wide: { responsive: true },
      }
    }
  },
  mounted() {
    this
      .axios
      .get(`${this.apiUrl}/api/dashboard/summary?repo=${this.repo}`)
      .then((response) => {
        const data = response.data.data
        const issueData = this.dataOf(data.issues)
        const pullData = this.dataOf(data.pulls)
        const deployData = data.deploys

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
              label: 'Total PRs',
              type: 'line',
              fill: false,
              backgroundColor: '#f8f879',
              data: pullData.countPerDay,
            },
            {
              label: 'Open PRs',
              backgroundColor: '#f87979',
              data: pullData.openPerDay,
            },
            {
              label: 'Close PRs',
              backgroundColor: '#7979f8',
              data: pullData.closedPerDay,
            }
          ]
        }
        this.deployDataset = {
          labels: deployData.deploy_count_per_day.map((x) => ( x.date )),
          datasets: [
            {
              label: 'Release / Day',
              type: 'line',
              fill: false,
              backgroundColor: '#f8f879',
              data: deployData.release_count_per_day.map((x) => ( x.count )),
            },
            {
              label: 'Deploy / Day',
              backgroundColor: '#f87979',
              data: deployData.deploy_count_per_day.map((x) => ( x.count )),
            },
          ]
        }
        this.currentOpenIssue = data.issues.open_count
        this.currentOpenPull = data.pulls.open_count
        this.countOfOldPull = data.pulls.open_since_a_month_count
        this.lifetimeOfPull.countOfAll = data.pulls.lifetime_of_pull_requests.count_of_all
        this.lifetimeOfPull.average = data.pulls.lifetime_of_pull_requests.average
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
  padding: 10px;
}

.dashboard-group {
  margin: 10px;
}

.dashboard-issues-chars {
  display: flex;
}

.dashboard-pulls-chars {
  display: flex;
}
</style>
